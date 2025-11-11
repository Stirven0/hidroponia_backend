-- =============================================
-- FUNCIONES PARA HIDROPONIA_V5
-- =============================================

USE `proyecto_hidroponico`;

-- Función 1: Calcular Edad del Cultivo
DELIMITER //

CREATE FUNCTION fn_edad_cultivo(p_cultivo_id INT) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_edad INT;
    
    SELECT DATEDIFF(CURDATE(), fecha_inicio) INTO v_edad
    FROM Cultivo 
    WHERE id = p_cultivo_id;
    
    RETURN IFNULL(v_edad, 0);
END //

DELIMITER ;

-- Función 2: Calcular Días Restantes para Cosecha
DELIMITER //

CREATE FUNCTION fn_dias_restantes_cosecha(p_cultivo_id INT) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_dias_restantes INT;
    DECLARE v_fecha_cosecha DATE;
    
    SELECT fecha_estimada_cosecha INTO v_fecha_cosecha
    FROM Cultivo 
    WHERE id = p_cultivo_id;
    
    IF v_fecha_cosecha IS NOT NULL THEN
        SET v_dias_restantes = DATEDIFF(v_fecha_cosecha, CURDATE());
    ELSE
        SET v_dias_restantes = NULL;
    END IF;
    
    RETURN v_dias_restantes;
END //

DELIMITER ;

-- Función 3: Obtener Estado Actual del Actuador
DELIMITER //

CREATE FUNCTION fn_estado_actual_actuador(p_actuador_id INT) 
RETURNS VARCHAR(45)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_estado_actual VARCHAR(45);
    
    SELECT m.nombre INTO v_estado_actual
    FROM Historial_Estado_Actuador hea
    JOIN Maestra m ON hea.estado_maestra_id = m.id
    WHERE hea.actuador_id = p_actuador_id
    ORDER BY hea.fecha_hora DESC
    LIMIT 1;
    
    RETURN IFNULL(v_estado_actual, 'DESCONOCIDO');
END //

DELIMITER ;

-- Función 4: Calcular Consumo Total de Solución
DELIMITER //

CREATE FUNCTION fn_consumo_solucion_cultivo(p_cultivo_id INT, p_solucion_id INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_consumo_total DECIMAL(10,2);
    
    SELECT COALESCE(SUM(cantidad_aplicada), 0) INTO v_consumo_total
    FROM Aplicacion_Solucion
    WHERE cultivo_id = p_cultivo_id 
    AND solucion_id = p_solucion_id;
    
    RETURN v_consumo_total;
END //

DELIMITER ;

-- Función 5: Verificar Nivel de Solución (Porcentaje)
DELIMITER //

CREATE FUNCTION fn_porcentaje_solucion(p_solucion_id INT) 
RETURNS DECIMAL(5,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_porcentaje DECIMAL(5,2);
    DECLARE v_capacidad_inicial DECIMAL(10,2);
    
    -- Obtener capacidad inicial (asumimos 100L como capacidad estándar)
    SET v_capacidad_inicial = 100.00;
    
    SELECT (litros_disponibles / v_capacidad_inicial) * 100 INTO v_porcentaje
    FROM Solucion_Nutritiva 
    WHERE id = p_solucion_id;
    
    RETURN IFNULL(v_porcentaje, 0);
END //

DELIMITER ;

-- Función 6: Obtener Promedio de Lecturas del Último Día
DELIMITER //

CREATE FUNCTION fn_promedio_lecturas_dia(p_sensor_id INT) 
RETURNS DECIMAL(12,4)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_promedio DECIMAL(12,4);
    
    SELECT AVG(valor) INTO v_promedio
    FROM Lectura_Sensor
    WHERE sensor_id = p_sensor_id
    AND fecha_hora >= NOW() - INTERVAL 1 DAY;
    
    RETURN IFNULL(v_promedio, 0);
END //

DELIMITER ;