-- Esquema Hidroponia_V5
CREATE SCHEMA IF NOT EXISTS `proyecto_hidroponico` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `proyecto_hidroponico`;

-- =============================================
-- TABLA MAESTRA UNIFICADA AUTO-REFERENCIADA
-- =============================================
CREATE TABLE IF NOT EXISTS `Maestra` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `valor` VARCHAR(100) NULL,
  `tipo_maestra` VARCHAR(50) NOT NULL,
  `padre_id` INT UNSIGNED NULL,
  `orden` INT NULL,
  `activo` TINYINT(1) DEFAULT 1,
  `descripcion` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_maestra_padre_idx` (`padre_id`),
  INDEX `idx_tipo_maestra` (`tipo_maestra`),
  INDEX `idx_maestra_activo` (`activo`),
  UNIQUE INDEX `uq_maestra_nombre_tipo` (`nombre`, `tipo_maestra`),
  CONSTRAINT `fk_maestra_padre`
    FOREIGN KEY (`padre_id`)
    REFERENCES `Maestra` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- =============================================
-- TABLAS PRINCIPALES (USANDO MAESTRA)
-- =============================================
CREATE TABLE IF NOT EXISTS `Actuador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo_maestra_id` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `activo` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Actuador_Maestra_idx` (`tipo_maestra_id`),
  INDEX `idx_actuador_activo` (`activo`),
  CONSTRAINT `fk_Actuador_Maestra`
    FOREIGN KEY (`tipo_maestra_id`)
    REFERENCES `Maestra` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Cultivo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `tiempo_cosecha_dias` INT NOT NULL,
  `estado_maestra_id` INT UNSIGNED NOT NULL,
  `tipo_cultivo_maestra_id` INT UNSIGNED NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_estimada_cosecha` DATE NULL,
  `descripcion` TEXT NULL,
  `activo` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Cultivo_Estado_Maestra_idx` (`estado_maestra_id`),
  INDEX `fk_Cultivo_Tipo_Maestra_idx` (`tipo_cultivo_maestra_id`),
  INDEX `idx_cultivo_activo` (`activo`),
  INDEX `idx_fecha_cosecha` (`fecha_estimada_cosecha`),
  CONSTRAINT `fk_Cultivo_Estado_Maestra`
    FOREIGN KEY (`estado_maestra_id`)
    REFERENCES `Maestra` (`id`),
  CONSTRAINT `fk_Cultivo_Tipo_Maestra`
    FOREIGN KEY (`tipo_cultivo_maestra_id`)
    REFERENCES `Maestra` (`id`)
);

CREATE TABLE IF NOT EXISTS `Solucion_Nutritiva` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo_maestra_id` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `litros_disponibles` DECIMAL(10,2) NOT NULL,
  `ph_optimo` DECIMAL(3,1) NULL,
  `conductividad_optima` DECIMAL(6,2) NULL,
  `descripcion` TEXT NULL,
  `activo` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Solucion_Maestra_idx` (`tipo_maestra_id`),
  INDEX `idx_solucion_activo` (`activo`),
  CONSTRAINT `fk_Solucion_Maestra`
    FOREIGN KEY (`tipo_maestra_id`)
    REFERENCES `Maestra` (`id`)
);

CREATE TABLE IF NOT EXISTS `Sensor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo_maestra_id` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `unidad_maestra_id` INT UNSIGNED NULL,
  `descripcion` VARCHAR(255) NULL,
  `activo` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Sensor_Tipo_Maestra_idx` (`tipo_maestra_id`),
  INDEX `fk_Sensor_Unidad_Maestra_idx` (`unidad_maestra_id`),
  INDEX `idx_sensor_activo` (`activo`),
  CONSTRAINT `fk_Sensor_Tipo_Maestra`
    FOREIGN KEY (`tipo_maestra_id`)
    REFERENCES `Maestra` (`id`),
  CONSTRAINT `fk_Sensor_Unidad_Maestra`
    FOREIGN KEY (`unidad_maestra_id`)
    REFERENCES `Maestra` (`id`)
);

-- =============================================
-- TABLAS TRANSACCIONALES
-- =============================================
CREATE TABLE IF NOT EXISTS `Aplicacion_Solucion` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cultivo_id` INT UNSIGNED NOT NULL,
  `solucion_id` INT UNSIGNED NOT NULL,
  `fecha_aplicacion` DATETIME NOT NULL,
  `cantidad_aplicada` DECIMAL(10,2) NOT NULL,
  `observaciones` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_aplicacion_unica` (`cultivo_id`, `solucion_id`, `fecha_aplicacion`),
  INDEX `fk_Aplicacion_Cultivo_idx` (`cultivo_id`),
  INDEX `fk_Aplicacion_Solucion_idx` (`solucion_id`),
  INDEX `idx_fecha_aplicacion` (`fecha_aplicacion`),
  CONSTRAINT `fk_Aplicacion_Cultivo`
    FOREIGN KEY (`cultivo_id`)
    REFERENCES `Cultivo` (`id`),
  CONSTRAINT `fk_Aplicacion_Solucion`
    FOREIGN KEY (`solucion_id`)
    REFERENCES `Solucion_Nutritiva` (`id`)
);

CREATE TABLE IF NOT EXISTS `Historial_Asignacion_Actuador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cultivo_id` INT UNSIGNED NOT NULL,
  `actuador_id` INT UNSIGNED NOT NULL,
  `fecha_asignacion` DATETIME NOT NULL,
  `fecha_desasignacion` DATETIME NULL,
  `observaciones` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_asignacion_activa` (`cultivo_id`, `actuador_id`, `fecha_desasignacion`),
  INDEX `fk_HistorialAA_Cultivo_idx` (`cultivo_id`),
  INDEX `fk_HistorialAA_Actuador_idx` (`actuador_id`),
  INDEX `idx_fecha_asignacion` (`fecha_asignacion`),
  CONSTRAINT `fk_HistorialAA_Cultivo`
    FOREIGN KEY (`cultivo_id`)
    REFERENCES `Cultivo` (`id`),
  CONSTRAINT `fk_HistorialAA_Actuador`
    FOREIGN KEY (`actuador_id`)
    REFERENCES `Actuador` (`id`)
);

CREATE TABLE IF NOT EXISTS `Historial_Asignacion_Sensor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cultivo_id` INT UNSIGNED NOT NULL,
  `sensor_id` INT UNSIGNED NOT NULL,
  `fecha_asignacion` DATETIME NOT NULL,
  `fecha_desasignacion` DATETIME NULL,
  `observaciones` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_asignacion_activa` (`cultivo_id`, `sensor_id`, `fecha_desasignacion`),
  INDEX `fk_HistorialAS_Cultivo_idx` (`cultivo_id`),
  INDEX `fk_HistorialAS_Sensor_idx` (`sensor_id`),
  INDEX `idx_fecha_asignacion` (`fecha_asignacion`),
  CONSTRAINT `fk_HistorialAS_Cultivo`
    FOREIGN KEY (`cultivo_id`)
    REFERENCES `Cultivo` (`id`),
  CONSTRAINT `fk_HistorialAS_Sensor`
    FOREIGN KEY (`sensor_id`)
    REFERENCES `Sensor` (`id`)
);

CREATE TABLE IF NOT EXISTS `Programacion_Actuador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `actuador_id` INT UNSIGNED NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NOT NULL,
  `dias_semana` VARCHAR(13) NULL,
  `fecha_especifica` DATE NULL,
  `activo` TINYINT(1) DEFAULT 1,
  `descripcion` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Programacion_Actuador_idx` (`actuador_id`),
  INDEX `idx_programacion_activo` (`activo`),
  CONSTRAINT `fk_Programacion_Actuador`
    FOREIGN KEY (`actuador_id`)
    REFERENCES `Actuador` (`id`)
);

CREATE TABLE IF NOT EXISTS `Lectura_Sensor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sensor_id` INT UNSIGNED NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `valor` DECIMAL(12,4) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_sensor_fecha` (`sensor_id`, `fecha_hora` DESC),
  INDEX `idx_fecha_hora` (`fecha_hora`),
  CONSTRAINT `fk_Lectura_Sensor`
    FOREIGN KEY (`sensor_id`)
    REFERENCES `Sensor` (`id`)
);

CREATE TABLE IF NOT EXISTS `Historial_Estado_Actuador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `actuador_id` INT UNSIGNED NOT NULL,
  `estado_maestra_id` INT UNSIGNED NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `observaciones` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_HistorialEstado_Actuador_idx` (`actuador_id`),
  INDEX `fk_HistorialEstado_Maestra_idx` (`estado_maestra_id`),
  INDEX `idx_fecha_hora` (`fecha_hora`),
  CONSTRAINT `fk_HistorialEstado_Actuador`
    FOREIGN KEY (`actuador_id`)
    REFERENCES `Actuador` (`id`),
  CONSTRAINT `fk_HistorialEstado_Maestra`
    FOREIGN KEY (`estado_maestra_id`)
    REFERENCES `Maestra` (`id`)
);

CREATE TABLE IF NOT EXISTS `Historial_Ubicacion_Actuador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `actuador_id` INT UNSIGNED NOT NULL,
  `ubicacion_maestra_id` INT UNSIGNED NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `observaciones` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_HistorialUbiA_Actuador_idx` (`actuador_id`),
  INDEX `fk_HistorialUbiA_Maestra_idx` (`ubicacion_maestra_id`),
  INDEX `idx_fecha_hora` (`fecha_hora`),
  CONSTRAINT `fk_HistorialUbiA_Actuador`
    FOREIGN KEY (`actuador_id`)
    REFERENCES `Actuador` (`id`),
  CONSTRAINT `fk_HistorialUbiA_Maestra`
    FOREIGN KEY (`ubicacion_maestra_id`)
    REFERENCES `Maestra` (`id`)
);

CREATE TABLE IF NOT EXISTS `Historial_Ubicacion_Sensor` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `sensor_id` INT UNSIGNED NOT NULL,
  `ubicacion_maestra_id` INT UNSIGNED NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `observaciones` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_HistorialUbiS_Sensor_idx` (`sensor_id`),
  INDEX `fk_HistorialUbiS_Maestra_idx` (`ubicacion_maestra_id`),
  INDEX `idx_fecha_hora` (`fecha_hora`),
  CONSTRAINT `fk_HistorialUbiS_Sensor`
    FOREIGN KEY (`sensor_id`)
    REFERENCES `Sensor` (`id`),
  CONSTRAINT `fk_HistorialUbiS_Maestra`
    FOREIGN KEY (`ubicacion_maestra_id`)
    REFERENCES `Maestra` (`id`)
);

CREATE TABLE IF NOT EXISTS `Parametro_Cultivo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tipo_cultivo_maestra_id` INT UNSIGNED NOT NULL,
  `parametro` VARCHAR(45) NOT NULL,
  `minimo` DECIMAL(8,3) NULL,
  `maximo` DECIMAL(8,3) NULL,
  `unidad_maestra_id` INT UNSIGNED NULL,
  `descripcion` TEXT NULL,
  `activo` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_Parametro_Tipo_Cultivo_Maestra_idx` (`tipo_cultivo_maestra_id`),
  INDEX `fk_Parametro_Unidad_Maestra_idx` (`unidad_maestra_id`),
  UNIQUE INDEX `uq_parametro_tipo` (`tipo_cultivo_maestra_id`, `parametro`),
  CONSTRAINT `fk_Parametro_Tipo_Cultivo_Maestra`
    FOREIGN KEY (`tipo_cultivo_maestra_id`)
    REFERENCES `Maestra` (`id`),
  CONSTRAINT `fk_Parametro_Unidad_Maestra`
    FOREIGN KEY (`unidad_maestra_id`)
    REFERENCES `Maestra` (`id`)
);

-- Tabla para alertas del sistema
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

-- Tabla para auditoría de cambios
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