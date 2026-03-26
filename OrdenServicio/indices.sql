CREATE INDEX idx_orden_idorden ON taordenservicio(idOrden);
CREATE INDEX idx_orden_tenantid ON taordenservicio(tenantId);
CREATE INDEX idx_orden_tenantid_estado ON taordenservicio(tenantId, estado);
CREATE INDEX idx_orden_fechaingreso ON taordenservicio(fechaIngreso);
