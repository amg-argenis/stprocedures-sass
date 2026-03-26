CREATE INDEX idx_detalle_iddetalleorden ON tadetalleordenservicio(idDetalleOrden);

-- Busquedas por tenantId
CREATE INDEX idx_detalle_tenantid 
ON tadetalleordenservicio(tenantId);

-- Busquedas por ordenId (el mas frecuente - traer detalles de una orden)
CREATE INDEX idx_detalle_ordenid 
ON tadetalleordenservicio(ordenId);

-- Combinacion tenantId + ordenId + estado (cubre la mayoria de los queries)
CREATE INDEX idx_detalle_tenantid_ordenid_estado 
ON tadetalleordenservicio(tenantId, ordenId, estado);

select * from tadetalleordenservicio;