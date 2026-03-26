-- Busquedas por tenantId (el mas usado en todos los queries)
CREATE INDEX idx_cliente_tenantid ON tacliente(tenantId);

CREATE INDEX idx_cliente_idcliente ON tacliente(idCliente);

-- Busquedas por tenantId + activo (combinacion frecuente)
CREATE INDEX idx_cliente_tenantid_activo ON tacliente(tenantId, activo);