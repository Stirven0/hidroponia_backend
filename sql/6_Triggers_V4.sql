-- =============================================
-- TRIGGERS PARA HIDROPONIA_V5
-- =============================================

USE `proyecto_hidroponico`;

-- Tablas adicionales necesarias para los triggers
CREATE TABLE IF NOT EXISTS `Alerta_Sistema` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cultivo_id` INT UNSIGNED NULL,
  `tipo_alerta` VARCHAR(50) NOT NULL,
  `mensaje` TEXT NOT NULL,
  `severidad` ENUM('BAJA', 'MEDIA', 'ALTA') NOT NULL,
  `activa` TINYINT(1) DEFAULT 1,
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `fecha_resolucion` TIMESTAMP NULL,
  `observaciones` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_alerta_cultivo_idx` (`cultivo_id`),
  INDEX `idx_alerta_activa` (`activa`),
  INDEX `idx_alerta_severidad` (`severidad`),
  CONSTRAINT `fk_alerta_cultivo`
    FOREIGN KEY (`cultivo_id`)
    REFERENCES `Cultivo` (`id`)
);

CREATE TABLE IF NOT EXISTS `Auditoria_Cultivo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cultivo_id` INT UNSIGNED NOT NULL,
  `campo_modificado` VARCHAR(50) NOT NULL,
  `valor_anterior` TEXT NULL,
  `valor_nuevo` TEXT NULL,
  `observaciones` TEXT NULL,
  `fecha_cambio` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `usuario` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_auditoria_cultivo_idx` (`cultivo_id`),
  INDEX `idx_auditoria_fecha` (`fecha_cambio`),
  CONSTRAINT `fk_auditoria_cultivo`
    FOREIGN KEY (`cultivo_id`)
    REFERENCES `Cultivo` (`id`)
);

-- Trigger 1: Actualización Automática de Litros Disponibles después de Aplicación
DELIMITER //

CREATE TRIGGER trg_after_insert_aplicacion
AFTER INSERT ON Aplicacion_Solucion
FOR EACH ROW
BEGIN
    DECLARE v_litros_actuales DECIMAL(10,2);
    DECLARE v_porcentaje_restante DECIMAL(5,2);
    DECLARE v_nombre_solucion VARCHAR(50);
    
    -- Obtener información actual de la solución
    SELECT litros_disponibles, nombre INTO v_litros_actuales, v_nombre_solucion
    FROM Solucion_Nutritiva 
    WHERE id = NEW.solucion_id;
    
    -- Actualizar los litros disponibles después de una aplicación
    UPDATE Solucion_Nutritiva 
    SET litros_disponibles = litros_disponibles - NEW.cantidad_aplicada,
        updated_at = NOW()
    WHERE id = NEW.solucion_id;
    
    -- Calcular porcentaje restante
    SET v_porcentaje_restante = ((v_litros_actuales - NEW.cantidad_aplicada) / 100) * 100;
    
    -- Insertar alerta si los litros bajan del 15%
    IF v_porcentaje_restante < 15 THEN
        INSERT INTO Alerta_Sistema (tipo_alerta, mensaje, severidad, activa)
        VALUES (
            'NIVEL_BAJO_SOLUCION',
            CONCAT('Solución "', v_nombre_solucion, '" tiene nivel bajo: ', 
                   ROUND(v_litros_actuales - NEW.cantidad_aplicada, 2), 'L (', 
                   ROUND(v_porcentaje_restante, 1), '%)'),
            CASE 
                WHEN v_porcentaje_restante < 5 THEN 'ALTA'
                WHEN v_porcentaje_restante < 15 THEN 'MEDIA'
                ELSE 'BAJA'
            END,
            1
        );
    END IF;
END //

DELIMITER ;

-- Trigger 2: Validación de Lecturas de Sensores
DELIMITER //

CREATE TRIGGER trg_before_insert_lectura
BEFORE INSERT ON Lectura_Sensor
FOR EACH ROW
BEGIN
    DECLARE v_unidad_id INT;
    DECLARE v_param_min DECIMAL(8,3);
    DECLARE v_param_max DECIMAL(8,3);
    DECLARE v_cultivo_id INT;
    DECLARE v_tipo_cultivo_id INT;
    DECLARE v_nombre_sensor VARCHAR(50);
    DECLARE v_simbolo_unidad VARCHAR(10);
    
    -- Obtener información del sensor
    SELECT unidad_maestra_id, nombre INTO v_unidad_id, v_nombre_sensor
    FROM Sensor WHERE id = NEW.sensor_id;
    
    -- Obtener símbolo de unidad si existe
    SELECT valor INTO v_simbolo_unidad
    FROM Maestra WHERE id = v_unidad_id;
    
    -- Buscar cultivo asociado al sensor
    SELECT c.id, c.tipo_cultivo_maestra_id INTO v_cultivo_id, v_tipo_cultivo_id
    FROM Cultivo c
    JOIN Historial_Asignacion_Sensor has ON c.id = has.cultivo_id
    WHERE has.sensor_id = NEW.sensor_id 
    AND has.fecha_desasignacion IS NULL
    LIMIT 1;
    
    -- Si encontramos cultivo, buscar parámetros ideales
    IF v_tipo_cultivo_id IS NOT NULL THEN
        SELECT minimo, maximo INTO v_param_min, v_param_max
        FROM Parametro_Cultivo 
        WHERE tipo_cultivo_maestra_id = v_tipo_cultivo_id 
        AND unidad_maestra_id = v_unidad_id
        AND activo = 1
        LIMIT 1;
        
        -- Generar alerta si la lectura está fuera de rango
        IF v_param_min IS NOT NULL AND v_param_max IS NOT NULL THEN
            IF NEW.valor < v_param_min OR NEW.valor > v_param_max THEN
                INSERT INTO Alerta_Sistema (cultivo_id, tipo_alerta, mensaje, severidad, activa)
                VALUES (
                    v_cultivo_id,
                    'LECTURA_FUERA_RANGO',
                    CONCAT('Sensor "', v_nombre_sensor, 
                           '" lectura: ', NEW.valor, ' ', 
                           COALESCE(v_simbolo_unidad, ''),
                           ' - Fuera de rango ideal (', v_param_min, '-', v_param_max, ')'),
                    CASE 
                        WHEN NEW.valor < v_param_min * 0.7 OR NEW.valor > v_param_max * 1.3 THEN 'ALTA'
                        WHEN NEW.valor < v_param_min * 0.8 OR NEW.valor > v_param_max * 1.2 THEN 'MEDIA'
                        ELSE 'BAJA'
                    END,
                    1
                );
            END IF;
        END IF;
    END IF;
END //

DELIMITER ;

-- Trigger 3: Auditoría de Cambios en Cultivos
DELIMITER //

CREATE TRIGGER trg_after_update_cultivo
AFTER UPDATE ON Cultivo
FOR EACH ROW
BEGIN
    -- Registrar cambio de estado
    IF OLD.estado_maestra_id != NEW.estado_maestra_id THEN
        INSERT INTO Auditoria_Cultivo (cultivo_id, campo_modificado, valor_anterior, valor_nuevo, observaciones)
        VALUES (
            NEW.id,
            'ESTADO',
            (SELECT nombre FROM Maestra WHERE id = OLD.estado_maestra_id),
            (SELECT nombre FROM Maestra WHERE id = NEW.estado_maestra_id),
            CONCAT('Cambio de estado - ', NOW())
        );
    END IF;
    
    -- Registrar cambio en fecha de cosecha
    IF OLD.fecha_estimada_cosecha != NEW.fecha_estimada_cosecha THEN
        INSERT INTO Auditoria_Cultivo (cultivo_id, campo_modificado, valor_anterior, valor_nuevo, observaciones)
        VALUES (
            NEW.id,
            'FECHA_COSECHA',
            OLD.fecha_estimada_cosecha,
            NEW.fecha_estimada_cosecha,
            'Actualización de fecha de cosecha estimada'
        );
    END IF;
    
    -- Registrar cambio en tipo de cultivo
    IF OLD.tipo_cultivo_maestra_id != NEW.tipo_cultivo_maestra_id THEN
        INSERT INTO Auditoria_Cultivo (cultivo_id, campo_modificado, valor_anterior, valor_nuevo, observaciones)
        VALUES (
            NEW.id,
            'TIPO_CULTIVO',
            (SELECT nombre FROM Maestra WHERE id = OLD.tipo_cultivo_maestra_id),
            (SELECT nombre FROM Maestra WHERE id = NEW.tipo_cultivo_maestra_id),
            'Cambio de tipo de cultivo'
        );
    END IF;
END //

DELIMITER ;

-- Trigger 4: Validar Asignación de Actuadores
DELIMITER //

CREATE TRIGGER trg_before_insert_asignacion_actuador
BEFORE INSERT ON Historial_Asignacion_Actuador
FOR EACH ROW
BEGIN
    DECLARE v_actuador_asignado INT DEFAULT 0;
    
    -- Verificar si el actuador ya está asignado a otro cultivo
    SELECT COUNT(*) INTO v_actuador_asignado
    FROM Historial_Asignacion_Actuador
    WHERE actuador_id = NEW.actuador_id
    AND fecha_desasignacion IS NULL
    AND cultivo_id != NEW.cultivo_id;
    
    IF v_actuador_asignado > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El actuador ya está asignado a otro cultivo activo';
    END IF;
END //

DELIMITER ;

-- Trigger 5: Actualizar Estado de Actuador al Programar
DELIMITER //

CREATE TRIGGER trg_after_insert_programacion
AFTER INSERT ON Programacion_Actuador
FOR EACH ROW
BEGIN
    -- Registrar cambio de estado a "Programado" si está activo
    IF NEW.activo = 1 THEN
        INSERT INTO Historial_Estado_Actuador (actuador_id, estado_maestra_id, fecha_hora, observaciones)
        VALUES (
            NEW.actuador_id,
            (SELECT id FROM Maestra WHERE nombre = 'Activado' AND tipo_maestra = 'ESTADOS_ACTUADOR'),
            NOW(),
            CONCAT('Programación activada - ', NEW.descripcion)
        );
    END IF;
END //

DELIMITER ;