-- Busquedas por tenantId
CREATE INDEX idx_entrega_tenantid 
ON taentregas(tenantId);

-- Busquedas por ordenId (el mas frecuente - buscar entrega de una orden)
CREATE INDEX idx_entrega_ordenid 
ON taentregas(ordenId);

-- Combinacion tenantId + estado (cubre la mayoria de los queries)
CREATE INDEX idx_entrega_tenantid_estado 
ON taentregas(tenantId, estado);

-- Busquedas por fecha de entrega (util para reportes)
CREATE INDEX idx_entrega_fechaentrega 
ON taentregas(fechaEntrega);