USE `proyecto_hidroponico`;

-- =============================================
-- POBLAR TABLA MAESTRA CON DATOS HIDROPÓNICOS
-- =============================================

-- Categorías principales
INSERT INTO `Maestra` (`id`, `nombre`, `valor`, `tipo_maestra`, `padre_id`, `orden`, `descripcion`) VALUES
-- Categorías raíz
(1, 'TIPOS_ACTUADOR', NULL, 'CATEGORIA', NULL, 1, 'Tipos de actuadores disponibles en el sistema'),
(2, 'TIPOS_SENSOR', NULL, 'CATEGORIA', NULL, 2, 'Tipos de sensores de monitoreo'),
(3, 'TIPOS_CULTIVO', NULL, 'CATEGORIA', NULL, 3, 'Clasificación de tipos de cultivos'),
(4, 'ESTADOS_CULTIVO', NULL, 'CATEGORIA', NULL, 4, 'Estados del ciclo de vida del cultivo'),
(5, 'TIPOS_SOLUCION', NULL, 'CATEGORIA', NULL, 5, 'Tipos de soluciones nutritivas'),
(6, 'ESTADOS_ACTUADOR', NULL, 'CATEGORIA', NULL, 6, 'Estados operativos de los actuadores'),
(7, 'UBICACIONES', NULL, 'CATEGORIA', NULL, 7, 'Ubicaciones físicas del sistema'),
(8, 'UNIDADES_MEDIDA', NULL, 'CATEGORIA', NULL, 8, 'Unidades de medida para sensores'),

-- Tipos de Actuadores
(9, 'Bomba de Agua', 'BOMBA_AGUA', 'TIPOS_ACTUADOR', 1, 1, 'Bomba para circulación de agua'),
(10, 'Ventilador', 'VENTILADOR', 'TIPOS_ACTUADOR', 1, 2, 'Control de ventilación y aireación'),
(11, 'Calefactor', 'CALEFACTOR', 'TIPOS_ACTUADOR', 1, 3, 'Control de temperatura ambiente'),
(12, 'Luces LED', 'LUZ_LED', 'TIPOS_ACTUADOR', 1, 4, 'Iluminación artificial para plantas'),
(13, 'Válvula Solenoide', 'VALVULA', 'TIPOS_ACTUADOR', 1, 5, 'Control de flujo de líquidos'),

-- Tipos de Sensores
(14, 'Sensor Temperatura', 'TEMP', 'TIPOS_SENSOR', 2, 1, 'Medición de temperatura ambiente'),
(15, 'Sensor Humedad', 'HUM', 'TIPOS_SENSOR', 2, 2, 'Medición de humedad relativa'),
(16, 'Sensor pH', 'PH', 'TIPOS_SENSOR', 2, 3, 'Medición de nivel de pH'),
(17, 'Sensor Conductividad', 'EC', 'TIPOS_SENSOR', 2, 4, 'Medición de conductividad eléctrica'),
(18, 'Sensor Nivel Agua', 'NIVEL_AGUA', 'TIPOS_SENSOR', 2, 5, 'Control de nivel en depósitos'),
(19, 'Sensor Flujo', 'FLUJO', 'TIPOS_SENSOR', 2, 6, 'Medición de flujo de líquidos'),
(20, 'Sensor Luz', 'LUX', 'TIPOS_SENSOR', 2, 7, 'Medición de intensidad lumínica'),

-- Tipos de Cultivo (Jerarquía)
(21, 'Hortalizas', 'HORTALIZAS', 'TIPOS_CULTIVO', 3, 1, 'Cultivos de hortalizas'),
(22, 'Hierbas Aromáticas', 'HIERBAS', 'TIPOS_CULTIVO', 3, 2, 'Plantas aromáticas y medicinales'),
(23, 'Frutas', 'FRUTAS', 'TIPOS_CULTIVO', 3, 3, 'Cultivos frutales'),

-- Subtipos de Hortalizas
(24, 'Lechuga', 'LECHUGA', 'TIPOS_CULTIVO', 21, 1, 'Variedades de lechuga'),
(25, 'Espinaca', 'ESPINACA', 'TIPOS_CULTIVO', 21, 2, 'Espinacas y acelgas'),
(26, 'Tomate', 'TOMATE', 'TIPOS_CULTIVO', 21, 3, 'Tomates y jitomates'),
(27, 'Pepino', 'PEPINO', 'TIPOS_CULTIVO', 21, 4, 'Pepinos y pepinillos'),

-- Subtipos de Hierbas
(28, 'Cilantro', 'CILANTRO', 'TIPOS_CULTIVO', 22, 1, 'Cilantro y culantro'),
(29, 'Albahaca', 'ALBAHACA', 'TIPOS_CULTIVO', 22, 2, 'Albahaca y variedades'),
(30, 'Menta', 'MENTA', 'TIPOS_CULTIVO', 22, 3, 'Menta y hierbabuena'),
(31, 'Perejil', 'PEREJIL', 'TIPOS_CULTIVO', 22, 4, 'Perejil y variedades'),

-- Estados de Cultivo
(32, 'Germinación', 'GERMINACION', 'ESTADOS_CULTIVO', 4, 1, 'Fase de germinación de semillas'),
(33, 'Crecimiento', 'CRECIMIENTO', 'ESTADOS_CULTIVO', 4, 2, 'Fase de crecimiento vegetativo'),
(34, 'Maduración', 'MADURACION', 'ESTADOS_CULTIVO', 4, 3, 'Fase de maduración y floración'),
(35, 'Cosecha', 'COSECHA', 'ESTADOS_CULTIVO', 4, 4, 'Listo para cosechar'),
(36, 'Finalizado', 'FINALIZADO', 'ESTADOS_CULTIVO', 4, 5, 'Ciclo completado'),

-- Tipos de Solución
(37, 'Solución Base', 'SOL_BASE', 'TIPOS_SOLUCION', 5, 1, 'Solución nutritiva base'),
(38, 'Crecimiento Vegetativo', 'SOL_CRECIMIENTO', 'TIPOS_SOLUCION', 5, 2, 'Solución para fase de crecimiento'),
(39, 'Floración', 'SOL_FLORACION', 'TIPOS_SOLUCION', 5, 3, 'Solución para fase de floración'),
(40, 'Enraizamiento', 'SOL_ENRAIZAMIENTO', 'TIPOS_SOLUCION', 5, 4, 'Solución para estimular raíces'),

-- Estados de Actuador
(41, 'Activado', 'ON', 'ESTADOS_ACTUADOR', 6, 1, 'Actuador en funcionamiento'),
(42, 'Desactivado', 'OFF', 'ESTADOS_ACTUADOR', 6, 2, 'Actuador apagado'),
(43, 'En Mantenimiento', 'MANTENIMIENTO', 'ESTADOS_ACTUADOR', 6, 3, 'Actuador en mantenimiento'),
(44, 'Fallando', 'FALLO', 'ESTADOS_ACTUADOR', 6, 4, 'Actuador con fallas'),

-- Ubicaciones
(45, 'Invernadero Principal', 'INVERNADERO_A', 'UBICACIONES', 7, 1, 'Invernadero principal'),
(46, 'Zona de Germinación', 'GERMINACION_ZONE', 'UBICACIONES', 7, 2, 'Área especial para germinación'),
(47, 'Sector Norte', 'SECTOR_NORTE', 'UBICACIONES', 7, 3, 'Sector norte del cultivo'),
(48, 'Sector Sur', 'SECTOR_SUR', 'UBICACIONES', 7, 4, 'Sector sur del cultivo'),

-- Unidades de Medida
(49, 'Grados Celsius', '°C', 'UNIDADES_MEDIDA', 8, 1, 'Temperatura'),
(50, 'Porcentaje', '%', 'UNIDADES_MEDIDA', 8, 2, 'Humedad relativa'),
(51, 'pH', 'pH', 'UNIDADES_MEDIDA', 8, 3, 'Potencial de hidrógeno'),
(52, 'mS/cm', 'mS/cm', 'UNIDADES_MEDIDA', 8, 4, 'Conductividad eléctrica'),
(53, 'Lux', 'lux', 'UNIDADES_MEDIDA', 8, 5, 'Intensidad lumínica'),
(54, 'Litros', 'L', 'UNIDADES_MEDIDA', 8, 6, 'Volumen de líquido'),
(55, 'Centímetros', 'cm', 'UNIDADES_MEDIDA', 8, 7, 'Nivel de agua');

-- =============================================
-- DATOS DE EJEMPLO PARA TABLAS PRINCIPALES
-- =============================================

-- Actuadores de ejemplo
INSERT INTO `Actuador` (`tipo_maestra_id`, `nombre`, `descripcion`) VALUES
(9, 'Bomba Principal NFT', 'Bomba principal del sistema NFT'),
(10, 'Ventilador Sector A', 'Ventilación para zona de lechugas'),
(12, 'Luces Crecimiento', 'Iluminación LED para fase vegetativa'),
(13, 'Válvula Nutrientes', 'Control de flujo de solución nutritiva');

-- Sensores de ejemplo
INSERT INTO `Sensor` (`tipo_maestra_id`, `nombre`, `unidad_maestra_id`, `descripcion`) VALUES
(14, 'Sensor Temp Ambiente', 49, 'Temperatura ambiente general'),
(15, 'Sensor Humedad Invernadero', 50, 'Humedad relativa del aire'),
(16, 'Sensor pH Principal', 51, 'Control de pH en solución circulante'),
(17, 'Sensor EC Nutrientes', 52, 'Conductividad de solución nutritiva');

-- Cultivos de ejemplo
INSERT INTO `Cultivo` (`nombre`, `tiempo_cosecha_dias`, `estado_maestra_id`, `tipo_cultivo_maestra_id`, `fecha_inicio`, `fecha_estimada_cosecha`) VALUES
('Lechuga Romana Lote #1', 45, 33, 24, '2025-01-15', '2025-02-28'),
('Cilantro Hidropónico', 30, 32, 28, '2025-01-20', '2025-02-19'),
('Tomates Cherry', 60, 33, 26, '2025-01-10', '2025-03-10');

-- Soluciones nutritivas de ejemplo
INSERT INTO `Solucion_Nutritiva` (`tipo_maestra_id`, `nombre`, `litros_disponibles`, `ph_optimo`, `conductividad_optima`) VALUES
(37, 'Solución Base General', 100.00, 6.0, 1.8),
(38, 'Nutrientes Crecimiento', 75.50, 5.8, 2.2),
(39, 'Floración Tomates', 50.25, 6.2, 2.5);

-- =============================================
-- DATOS DE EJEMPLO PARA TABLAS TRANSACCIONALES
-- =============================================

-- Aplicaciones de solución
INSERT INTO `Aplicacion_Solucion` (`cultivo_id`, `solucion_id`, `fecha_aplicacion`, `cantidad_aplicada`, `observaciones`) VALUES
(1, 1, '2025-01-20 08:00:00', 5.00, 'Primera aplicación a lechugas'),
(1, 2, '2025-01-27 08:00:00', 5.00, 'Aplicación de crecimiento'),
(2, 1, '2025-01-25 09:30:00', 3.00, 'Aplicación inicial a cilantro'),
(3, 3, '2025-01-30 10:00:00', 7.50, 'Aplicación para floración');

-- Lecturas de sensores
INSERT INTO `Lectura_Sensor` (`sensor_id`, `fecha_hora`, `valor`) VALUES
(1, '2025-01-25 12:00:00', 25.5),
(1, '2025-01-25 13:00:00', 26.0),
(1, '2025-01-25 14:00:00', 25.8),
(2, '2025-01-25 12:00:00', 65.0),
(2, '2025-01-25 13:00:00', 63.5),
(3, '2025-01-25 12:00:00', 6.2),
(4, '2025-01-25 12:00:00', 1.8);

-- Programación de actuadores
INSERT INTO `Programacion_Actuador` (`actuador_id`, `hora_inicio`, `hora_fin`, `dias_semana`, `descripcion`) VALUES
(1, '08:00:00', '12:00:00', 'L,M,X,J,V', 'Riego matutino'),
(1, '14:00:00', '16:00:00', 'L,M,X,J,V', 'Riego vespertino'),
(2, '10:00:00', '18:00:00', 'L,M,X,J,V,S,D', 'Ventilación continua'),
(3, '06:00:00', '20:00:00', 'L,M,X,J,V,S,D', 'Fotoperiodo 14h');

-- Historial de estados de actuadores
INSERT INTO `Historial_Estado_Actuador` (`actuador_id`, `estado_maestra_id`, `fecha_hora`, `observaciones`) VALUES
(1, 41, '2025-01-25 08:00:00', 'Activación programada'),
(1, 42, '2025-01-25 12:00:00', 'Desactivación programada'),
(2, 41, '2025-01-25 10:00:00', 'Ventilación activada por temperatura'),
(3, 41, '2025-01-25 06:00:00', 'Luces encendidas');

-- Historial de ubicaciones de actuadores
INSERT INTO `Historial_Ubicacion_Actuador` (`actuador_id`, `ubicacion_maestra_id`, `fecha_hora`, `observaciones`) VALUES
(1, 45, '2025-01-15 10:00:00', 'Instalación inicial'),
(2, 47, '2025-01-16 11:00:00', 'Colocado en sector norte'),
(3, 45, '2025-01-17 09:30:00', 'Luces instaladas');

-- Historial de ubicaciones de sensores
INSERT INTO `Historial_Ubicacion_Sensor` (`sensor_id`, `ubicacion_maestra_id`, `fecha_hora`, `observaciones`) VALUES
(1, 45, '2025-01-15 08:00:00', 'Sensor temperatura ambiente'),
(2, 45, '2025-01-15 08:15:00', 'Sensor humedad general'),
(3, 45, '2025-01-15 08:30:00', 'Sensor pH solución'),
(4, 45, '2025-01-15 08:45:00', 'Sensor conductividad');

-- Historial de asignación de actuadores a cultivos
INSERT INTO `Historial_Asignacion_Actuador` (`cultivo_id`, `actuador_id`, `fecha_asignacion`, `fecha_desasignacion`, `observaciones`) VALUES
(1, 1, '2025-01-15 09:00:00', NULL, 'Bomba asignada a lechugas'),
(1, 3, '2025-01-15 09:15:00', NULL, 'Luces asignadas a lechugas'),
(2, 2, '2025-01-20 10:00:00', NULL, 'Ventilador para cilantro');

-- Historial de asignación de sensores a cultivos
INSERT INTO `Historial_Asignacion_Sensor` (`cultivo_id`, `sensor_id`, `fecha_asignacion`, `fecha_desasignacion`, `observaciones`) VALUES
(1, 1, '2025-01-15 08:00:00', NULL, 'Monitor temperatura lechugas'),
(1, 2, '2025-01-15 08:05:00', NULL, 'Monitor humedad lechugas'),
(2, 1, '2025-01-20 08:00:00', NULL, 'Monitor temperatura cilantro');

-- Parámetros de cultivo
INSERT INTO `Parametro_Cultivo` (`tipo_cultivo_maestra_id`, `parametro`, `minimo`, `maximo`, `unidad_maestra_id`, `descripcion`) VALUES
(24, 'Temperatura', 18.0, 24.0, 49, 'Temperatura ideal para lechugas'),
(24, 'Humedad', 40.0, 70.0, 50, 'Humedad ideal para lechugas'),
(24, 'pH', 5.5, 6.5, 51, 'pH ideal para lechugas'),
(24, 'Conductividad', 1.2, 1.8, 52, 'CE ideal para lechugas'),
(26, 'Temperatura', 20.0, 26.0, 49, 'Temperatura ideal para tomates'),
(26, 'Humedad', 50.0, 70.0, 50, 'Humedad ideal para tomates'),
(26, 'pH', 5.5, 6.5, 51, 'pH ideal para tomates'),
(26, 'Conductividad', 2.0, 2.5, 52, 'CE ideal para tomates'),
(28, 'Temperatura', 15.0, 25.0, 49, 'Temperatura ideal para cilantro'),
(28, 'Humedad', 45.0, 65.0, 50, 'Humedad ideal para cilantro');