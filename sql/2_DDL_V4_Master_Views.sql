USE `proyecto_hidroponico`;

-- =============================================
-- VISTAS ÚTILES PARA CONSULTAS RECURSIVAS
-- =============================================

CREATE VIEW `v_arbol_maestra` AS
WITH RECURSIVE arbol_maestra AS (
  SELECT 
    id,
    nombre,
    valor,
    tipo_maestra,
    padre_id,
    orden,
    activo,
    0 as nivel,
    CAST(nombre AS CHAR(1000)) as ruta,
    CAST(id AS CHAR(1000)) as ruta_ids
  FROM Maestra 
  WHERE padre_id IS NULL
  
  UNION ALL
  
  SELECT 
    m.id,
    m.nombre,
    m.valor,
    m.tipo_maestra,
    m.padre_id,
    m.orden,
    m.activo,
    am.nivel + 1 as nivel,
    CONCAT(am.ruta, ' → ', m.nombre) as ruta,
    CONCAT(am.ruta_ids, '.', m.id) as ruta_ids
  FROM Maestra m
  INNER JOIN arbol_maestra am ON m.padre_id = am.id
  WHERE m.activo = 1
)
SELECT * FROM arbol_maestra ORDER BY ruta_ids;

CREATE VIEW `v_tipos_cultivo_jerarquia` AS
SELECT 
  id,
  nombre,
  valor,
  nivel,
  ruta
FROM v_arbol_maestra 
WHERE tipo_maestra = 'TIPOS_CULTIVO'
ORDER BY ruta_ids;

CREATE VIEW `v_actuadores_con_tipo` AS
SELECT 
  a.id,
  a.nombre as actuador,
  a.descripcion,
  m_tipo.nombre as tipo_actuador,
  m_cat.nombre as categoria,
  a.activo,
  a.created_at
FROM Actuador a
JOIN Maestra m_tipo ON a.tipo_maestra_id = m_tipo.id
JOIN Maestra m_cat ON m_tipo.padre_id = m_cat.id;

CREATE VIEW `v_cultivos_completos` AS
SELECT 
  c.id,
  c.nombre as cultivo,
  c.tiempo_cosecha_dias,
  m_estado.nombre as estado,
  m_tipo.ruta as tipo_cultivo,
  c.fecha_inicio,
  c.fecha_estimada_cosecha,
  c.descripcion,
  c.activo
FROM Cultivo c
JOIN Maestra m_estado ON c.estado_maestra_id = m_estado.id
JOIN v_arbol_maestra m_tipo ON c.tipo_cultivo_maestra_id = m_tipo.id;

CREATE VIEW `v_sensores_con_detalles` AS
SELECT 
  s.id,
  s.nombre as sensor,
  m_tipo.nombre as tipo_sensor,
  m_unidad.nombre as unidad_medida,
  m_unidad.valor as simbolo_unidad,
  s.descripcion,
  s.activo
FROM Sensor s
JOIN Maestra m_tipo ON s.tipo_maestra_id = m_tipo.id
LEFT JOIN Maestra m_unidad ON s.unidad_maestra_id = m_unidad.id;