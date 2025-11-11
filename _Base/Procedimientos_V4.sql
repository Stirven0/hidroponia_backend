-- =============================================
-- PROCEDIMIENTOS ALMACENADOS PARA HIDROPONIA_V5 - CORREGIDOS
-- =============================================

USE `proyecto_hidroponico`;

-- Procedimiento 1: Aplicar Solución a Cultivo - CORREGIDO
DELIMITER //

CREATE PROCEDURE sp_aplicar_solucion_cultivo(
    IN p_cultivo_id INT,
    IN p_solucion_id INT,
    IN p_cantidad DECIMAL(10,2),
    IN p_observaciones VARCHAR(255)
)
BEGIN
    DECLARE v_litros_disponibles DECIMAL(10,2);
    DECLARE v_existe_cultivo INT DEFAULT 0;
    DECLARE v_existe_solucion INT DEFAULT 0;
    DECLARE v_porcentaje_restante DECIMAL(5,2);
    DECLARE v_mensaje_error VARCHAR(500); -- Variable para el mensaje de error
    
    -- Verificar existencia del cultivo
    SELECT COUNT(*) INTO v_existe_cultivo FROM Cultivo WHERE id = p_cultivo_id AND activo = 1;
    IF v_existe_cultivo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cultivo no existe o está inactivo';
    END IF;
    
    -- Verificar existencia de la solución
    SELECT COUNT(*) INTO v_existe_solucion FROM Solucion_Nutritiva WHERE id = p_solucion_id AND activo = 1;
    IF v_existe_solucion = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solución no existe o está inactiva';
    END IF;
    
    -- Verificar litros disponibles
    SELECT litros_disponibles INTO v_litros_disponibles 
    FROM Solucion_Nutritiva 
    WHERE id = p_solucion_id;
    
    IF v_litros_disponibles < p_cantidad THEN
        -- CORRECCIÓN: Usar variable intermedia para CONCAT
        SET v_mensaje_error = CONCAT('Litros insuficientes. Disponible: ', v_litros_disponibles, 'L, Solicitado: ', p_cantidad, 'L');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_mensaje_error;
    END IF;
    
    -- Calcular porcentaje restante después de la aplicación
    SET v_porcentaje_restante = ((v_litros_disponibles - p_cantidad) / 100) * 100;
    
    -- Insertar aplicación
    INSERT INTO Aplicacion_Solucion (cultivo_id, solucion_id, fecha_aplicacion, cantidad_aplicada, observaciones)
    VALUES (p_cultivo_id, p_solucion_id, NOW(), p_cantidad, p_observaciones);
    
    -- Retornar éxito con detalles
    SELECT 
        'Aplicación registrada exitosamente' as resultado,
        p_cantidad as cantidad_aplicada,
        v_litros_disponibles - p_cantidad as litros_restantes,
        v_porcentaje_restante as porcentaje_restante;
END //

DELIMITER ;

-- Procedimiento 2: Generar Reporte de Cultivo
DELIMITER //

CREATE PROCEDURE sp_reporte_cultivo_completo(IN p_cultivo_id INT)
BEGIN
    -- Información básica del cultivo
    SELECT 
        c.nombre as cultivo,
        c.tiempo_cosecha_dias,
        fn_edad_cultivo(p_cultivo_id) as edad_actual_dias,
        fn_dias_restantes_cosecha(p_cultivo_id) as dias_restantes,
        m_estado.nombre as estado_actual,
        m_tipo.ruta as tipo_cultivo,
        c.fecha_inicio,
        c.fecha_estimada_cosecha,
        c.descripcion
    FROM Cultivo c
    JOIN Maestra m_estado ON c.estado_maestra_id = m_estado.id
    JOIN v_arbol_maestra m_tipo ON c.tipo_cultivo_maestra_id = m_tipo.id
    WHERE c.id = p_cultivo_id;
    
    -- Aplicaciones de solución
    SELECT 
        s.nombre as solucion,
        a.fecha_aplicacion,
        a.cantidad_aplicada,
        a.observaciones,
        fn_consumo_solucion_cultivo(p_cultivo_id, s.id) as consumo_total,
        fn_porcentaje_solucion(s.id) as porcentaje_disponible
    FROM Aplicacion_Solucion a
    JOIN Solucion_Nutritiva s ON a.solucion_id = s.id
    WHERE a.cultivo_id = p_cultivo_id
    ORDER BY a.fecha_aplicacion DESC;
    
    -- Actuadores asignados
    SELECT 
        a.nombre as actuador,
        m_tipo.nombre as tipo_actuador,
        haa.fecha_asignacion,
        fn_estado_actual_actuador(a.id) as estado_actual,
        haa.observaciones
    FROM Historial_Asignacion_Actuador haa
    JOIN Actuador a ON haa.actuador_id = a.id
    JOIN Maestra m_tipo ON a.tipo_maestra_id = m_tipo.id
    WHERE haa.cultivo_id = p_cultivo_id 
    AND haa.fecha_desasignacion IS NULL;
    
    -- Sensores asignados y últimas lecturas
    SELECT 
        s.nombre as sensor,
        m_tipo.nombre as tipo_sensor,
        m_unidad.nombre as unidad,
        has.fecha_asignacion,
        (SELECT valor FROM Lectura_Sensor WHERE sensor_id = s.id ORDER BY fecha_hora DESC LIMIT 1) as ultima_lectura,
        (SELECT fecha_hora FROM Lectura_Sensor WHERE sensor_id = s.id ORDER BY fecha_hora DESC LIMIT 1) as fecha_ultima_lectura,
        fn_promedio_lecturas_dia(s.id) as promedio_24h
    FROM Historial_Asignacion_Sensor has
    JOIN Sensor s ON has.sensor_id = s.id
    JOIN Maestra m_tipo ON s.tipo_maestra_id = m_tipo.id
    LEFT JOIN Maestra m_unidad ON s.unidad_maestra_id = m_unidad.id
    WHERE has.cultivo_id = p_cultivo_id 
    AND has.fecha_desasignacion IS NULL;
END //

DELIMITER ;

-- Procedimiento 3: Actualizar Estado de Cultivo Automáticamente
DELIMITER //

CREATE PROCEDURE sp_actualizar_estado_cultivos()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_cultivo_id INT;
    DECLARE v_edad INT;
    DECLARE v_tiempo_cosecha INT;
    DECLARE v_estado_actual_id INT;
    DECLARE v_nuevo_estado_id INT;
    DECLARE v_contador_actualizados INT DEFAULT 0;
    
    -- Cursor para recorrer cultivos activos
    DECLARE cur_cultivos CURSOR FOR 
    SELECT id, tiempo_cosecha_dias, estado_maestra_id 
    FROM Cultivo 
    WHERE activo = 1;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur_cultivos;
    
    read_loop: LOOP
        FETCH cur_cultivos INTO v_cultivo_id, v_tiempo_cosecha, v_estado_actual_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET v_edad = fn_edad_cultivo(v_cultivo_id);
        SET v_nuevo_estado_id = NULL;
        
        -- Lógica de cambio de estado basada en la edad
        IF v_edad < 7 THEN
            SET v_nuevo_estado_id = (SELECT id FROM Maestra WHERE nombre = 'Germinación' AND tipo_maestra = 'ESTADOS_CULTIVO');
        ELSEIF v_edad BETWEEN 7 AND v_tiempo_cosecha - 10 THEN
            SET v_nuevo_estado_id = (SELECT id FROM Maestra WHERE nombre = 'Crecimiento' AND tipo_maestra = 'ESTADOS_CULTIVO');
        ELSEIF v_edad BETWEEN v_tiempo_cosecha - 9 AND v_tiempo_cosecha THEN
            SET v_nuevo_estado_id = (SELECT id FROM Maestra WHERE nombre = 'Maduración' AND tipo_maestra = 'ESTADOS_CULTIVO');
        ELSEIF v_edad > v_tiempo_cosecha THEN
            SET v_nuevo_estado_id = (SELECT id FROM Maestra WHERE nombre = 'Cosecha' AND tipo_maestra = 'ESTADOS_CULTIVO');
        END IF;
        
        -- Actualizar estado si es diferente al actual
        IF v_nuevo_estado_id IS NOT NULL AND v_nuevo_estado_id != v_estado_actual_id THEN
            UPDATE Cultivo 
            SET estado_maestra_id = v_nuevo_estado_id,
                updated_at = NOW()
            WHERE id = v_cultivo_id;
            
            SET v_contador_actualizados = v_contador_actualizados + 1;
            
            -- Registrar en auditoría
            INSERT INTO Auditoria_Cultivo (cultivo_id, campo_modificado, valor_anterior, valor_nuevo, observaciones)
            VALUES (
                v_cultivo_id,
                'ESTADO_AUTO',
                (SELECT nombre FROM Maestra WHERE id = v_estado_actual_id),
                (SELECT nombre FROM Maestra WHERE id = v_nuevo_estado_id),
                CONCAT('Cambio automático por edad: ', v_edad, ' días')
            );
        END IF;
    END LOOP;
    
    CLOSE cur_cultivos;
    
    SELECT CONCAT('Estados actualizados para ', v_contador_actualizados, ' cultivos') as resultado;
END //

DELIMITER ;

-- Procedimiento 4: Monitoreo de Condiciones Ambientales
DELIMITER //

CREATE PROCEDURE sp_monitoreo_condiciones_ambientales()
BEGIN
    DECLARE v_alertas_generadas INT DEFAULT 0;
    
    -- Verificar temperaturas críticas
    INSERT INTO Alerta_Sistema (cultivo_id, tipo_alerta, mensaje, severidad, activa)
    SELECT 
        c.id,
        'TEMPERATURA_CRITICA',
        CONCAT('Temperatura crítica: ', ls.valor, '°C en cultivo ', c.nombre),
        CASE 
            WHEN ls.valor < 10 OR ls.valor > 35 THEN 'ALTA'
            WHEN ls.valor < 15 OR ls.valor > 30 THEN 'MEDIA'
            ELSE 'BAJA'
        END,
        1
    FROM Lectura_Sensor ls
    JOIN Sensor s ON ls.sensor_id = s.id
    JOIN Maestra m_tipo ON s.tipo_maestra_id = m_tipo.id
    JOIN Historial_Asignacion_Sensor has ON s.id = has.sensor_id
    JOIN Cultivo c ON has.cultivo_id = c.id
    WHERE m_tipo.nombre = 'Sensor Temperatura'
    AND ls.fecha_hora >= NOW() - INTERVAL 1 HOUR
    AND has.fecha_desasignacion IS NULL
    AND (ls.valor < 15 OR ls.valor > 30);
    
    SET v_alertas_generadas = v_alertas_generadas + ROW_COUNT();
    
    -- Verificar pH fuera de rango
    INSERT INTO Alerta_Sistema (cultivo_id, tipo_alerta, mensaje, severidad, activa)
    SELECT 
        c.id,
        'PH_CRITICO',
        CONCAT('pH crítico: ', ls.valor, ' en cultivo ', c.nombre),
        CASE 
            WHEN ls.valor < 4.5 OR ls.valor > 8.5 THEN 'ALTA'
            WHEN ls.valor < 5.0 OR ls.valor > 7.5 THEN 'MEDIA'
            ELSE 'BAJA'
        END,
        1
    FROM Lectura_Sensor ls
    JOIN Sensor s ON ls.sensor_id = s.id
    JOIN Maestra m_tipo ON s.tipo_maestra_id = m_tipo.id
    JOIN Historial_Asignacion_Sensor has ON s.id = has.sensor_id
    JOIN Cultivo c ON has.cultivo_id = c.id
    WHERE m_tipo.nombre = 'Sensor pH'
    AND ls.fecha_hora >= NOW() - INTERVAL 1 HOUR
    AND has.fecha_desasignacion IS NULL
    AND (ls.valor < 5.0 OR ls.valor > 7.5);
    
    SET v_alertas_generadas = v_alertas_generadas + ROW_COUNT();
    
    -- Verificar soluciones con bajo nivel
    INSERT INTO Alerta_Sistema (tipo_alerta, mensaje, severidad, activa)
    SELECT 
        'SOLUCION_BAJA',
        CONCAT('Solución "', nombre, '" tiene nivel bajo: ', litros_disponibles, 'L (', fn_porcentaje_solucion(id), '%)'),
        CASE 
            WHEN fn_porcentaje_solucion(id) < 5 THEN 'ALTA'
            WHEN fn_porcentaje_solucion(id) < 15 THEN 'MEDIA'
            ELSE 'BAJA'
        END,
        1
    FROM Solucion_Nutritiva
    WHERE activo = 1 
    AND fn_porcentaje_solucion(id) < 20;
    
    SET v_alertas_generadas = v_alertas_generadas + ROW_COUNT();
    
    SELECT CONCAT('Monitoreo completado - Alertas generadas: ', v_alertas_generadas) as resultado;
END //

DELIMITER ;

-- Procedimiento 5: Resumen del Sistema
DELIMITER //

CREATE PROCEDURE sp_resumen_sistema()
BEGIN
    -- Estadísticas generales
    SELECT 
        (SELECT COUNT(*) FROM Cultivo WHERE activo = 1) as cultivos_activos,
        (SELECT COUNT(*) FROM Actuador WHERE activo = 1) as actuadores_activos,
        (SELECT COUNT(*) FROM Sensor WHERE activo = 1) as sensores_activos,
        (SELECT COUNT(*) FROM Solucion_Nutritiva WHERE activo = 1) as soluciones_activas,
        (SELECT COUNT(*) FROM Lectura_Sensor WHERE fecha_hora >= NOW() - INTERVAL 1 DAY) as lecturas_24h,
        (SELECT COUNT(*) FROM Alerta_Sistema WHERE activa = 1) as alertas_activas;
    
    -- Cultivos por estado
    SELECT 
        m.nombre as estado,
        COUNT(*) as cantidad
    FROM Cultivo c
    JOIN Maestra m ON c.estado_maestra_id = m.id
    WHERE c.activo = 1
    GROUP BY m.nombre;
    
    -- Soluciones con nivel bajo
    SELECT 
        nombre,
        litros_disponibles,
        fn_porcentaje_solucion(id) as porcentaje
    FROM Solucion_Nutritiva
    WHERE activo = 1
    AND fn_porcentaje_solucion(id) < 30
    ORDER BY porcentaje ASC;
    
    -- Alertas recientes
    SELECT 
        tipo_alerta,
        mensaje,
        severidad,
        fecha_creacion
    FROM Alerta_Sistema
    WHERE activa = 1
    ORDER BY 
        CASE severidad
            WHEN 'ALTA' THEN 1
            WHEN 'MEDIA' THEN 2
            WHEN 'BAJA' THEN 3
        END,
        fecha_creacion DESC
    LIMIT 10;
END //

DELIMITER ;