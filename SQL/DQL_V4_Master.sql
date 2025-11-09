USE `proyecto_hidroponico`;

-- =============================================
-- CONSULTAS DE EJEMPLO CON LA NUEVA ESTRUCTURA
-- =============================================

-- 1. Consulta recursiva: Obtener árbol completo de tipos de cultivo
SELECT * FROM v_tipos_cultivo_jerarquia;

-- 2. Consulta: Obtener actuadores con su tipo jerárquico
SELECT 
  a.nombre as actuador,
  m_tipo.nombre as tipo,
  m_cat.nombre as categoria
FROM Actuador a
JOIN Maestra m_tipo ON a.tipo_maestra_id = m_tipo.id
JOIN Maestra m_cat ON m_tipo.padre_id = m_cat.id
WHERE a.activo = 1;

-- 3. Consulta: Obtener cultivos con información jerárquica completa
SELECT 
  c.nombre as cultivo,
  m_estado.nombre as estado,
  m_tipo.ruta as tipo_cultivo,
  c.fecha_estimada_cosecha
FROM Cultivo c
JOIN Maestra m_estado ON c.estado_maestra_id = m_estado.id
JOIN v_arbol_maestra m_tipo ON c.tipo_cultivo_maestra_id = m_tipo.id
WHERE c.activo = 1;

-- 4. Consulta: Obtener sensores con sus unidades de medida
SELECT 
  s.nombre as sensor,
  m_tipo.nombre as tipo_sensor,
  m_unidad.nombre as unidad,
  m_unidad.valor as simbolo
FROM Sensor s
JOIN Maestra m_tipo ON s.tipo_maestra_id = m_tipo.id
LEFT JOIN Maestra m_unidad ON s.unidad_maestra_id = m_unidad.id
WHERE s.activo = 1;

-- 5. Consulta: Obtener aplicaciones de solución con detalles
SELECT 
  c.nombre as cultivo,
  s.nombre as solucion,
  a.fecha_aplicacion,
  a.cantidad_aplicada,
  a.observaciones
FROM Aplicacion_Solucion a
JOIN Cultivo c ON a.cultivo_id = c.id
JOIN Solucion_Nutritiva s ON a.solucion_id = s.id
ORDER BY a.fecha_aplicacion DESC;

-- 6. Consulta: Obtener lecturas recientes de sensores
SELECT 
  se.nombre as sensor,
  m_unidad.nombre as unidad,
  l.valor,
  l.fecha_hora
FROM Lectura_Sensor l
JOIN Sensor se ON l.sensor_id = se.id
LEFT JOIN Maestra m_unidad ON se.unidad_maestra_id = m_unidad.id
ORDER BY l.fecha_hora DESC
LIMIT 50;

-- 7. Consulta: Obtener programaciones activas de actuadores
SELECT 
  a.nombre as actuador,
  m_tipo.nombre as tipo,
  p.hora_inicio,
  p.hora_fin,
  p.dias_semana,
  p.descripcion
FROM Programacion_Actuador p
JOIN Actuador a ON p.actuador_id = a.id
JOIN Maestra m_tipo ON a.tipo_maestra_id = m_tipo.id
WHERE p.activo = 1;

-- 8. Consulta: Obtener historial de estados de actuadores
SELECT 
  a.nombre as actuador,
  m_estado.nombre as estado,
  h.fecha_hora,
  h.observaciones
FROM Historial_Estado_Actuador h
JOIN Actuador a ON h.actuador_id = a.id
JOIN Maestra m_estado ON h.estado_maestra_id = m_estado.id
ORDER BY h.fecha_hora DESC;

-- 9. Consulta: Obtener parámetros ideales por tipo de cultivo
SELECT 
  m_cultivo.ruta as tipo_cultivo,
  p.parametro,
  p.minimo,
  p.maximo,
  m_unidad.nombre as unidad
FROM Parametro_Cultivo p
JOIN v_arbol_maestra m_cultivo ON p.tipo_cultivo_maestra_id = m_cultivo.id
LEFT JOIN Maestra m_unidad ON p.unidad_maestra_id = m_unidad.id
WHERE p.activo = 1
ORDER BY m_cultivo.ruta, p.parametro;

-- 10. Consulta: Obtener estructura jerárquica completa del sistema
SELECT 
  m1.nombre as categoria_principal,
  m2.nombre as subcategoria,
  m3.nombre as elemento,
  m3.descripcion
FROM Maestra m1
LEFT JOIN Maestra m2 ON m2.padre_id = m1.id
LEFT JOIN Maestra m3 ON m3.padre_id = m2.id
WHERE m1.padre_id IS NULL
ORDER BY m1.orden, m2.orden, m3.orden;

-- Consultas adicionales útiles:

-- 11. Asignaciones activas de actuadores a cultivos
SELECT 
  c.nombre as cultivo,
  a.nombre as actuador,
  haa.fecha_asignacion,
  haa.observaciones
FROM Historial_Asignacion_Actuador haa
JOIN Cultivo c ON haa.cultivo_id = c.id
JOIN Actuador a ON haa.actuador_id = a.id
WHERE haa.fecha_desasignacion IS NULL;

-- 12. Asignaciones activas de sensores a cultivos
SELECT 
  c.nombre as cultivo,
  s.nombre as sensor,
  has.fecha_asignacion,
  has.observaciones
FROM Historial_Asignacion_Sensor has
JOIN Cultivo c ON has.cultivo_id = c.id
JOIN Sensor s ON has.sensor_id = s.id
WHERE has.fecha_desasignacion IS NULL;

-- 13. Ubicaciones actuales de actuadores
SELECT 
  a.nombre as actuador,
  m_ubicacion.nombre as ubicacion,
  hua.fecha_hora as fecha_ubicacion
FROM Historial_Ubicacion_Actuador hua
JOIN Actuador a ON hua.actuador_id = a.id
JOIN Maestra m_ubicacion ON hua.ubicacion_maestra_id = m_ubicacion.id
WHERE hua.fecha_hora = (
  SELECT MAX(fecha_hora) 
  FROM Historial_Ubicacion_Actuador 
  WHERE actuador_id = a.id
);

-- 14. Resumen del sistema
SELECT 
  (SELECT COUNT(*) FROM Cultivo WHERE activo = 1) as cultivos_activos,
  (SELECT COUNT(*) FROM Actuador WHERE activo = 1) as actuadores_activos,
  (SELECT COUNT(*) FROM Sensor WHERE activo = 1) as sensores_activos,
  (SELECT COUNT(*) FROM Lectura_Sensor WHERE fecha_hora >= NOW() - INTERVAL 1 DAY) as lecturas_hoy;