-- Trigger para generar folio automaticamente
DELIMITER $$
DROP TRIGGER IF EXISTS trg_folio_orden_servicio$$

CREATE TRIGGER trg_folio_orden_servicio
BEFORE INSERT ON taordenservicio
FOR EACH ROW
BEGIN
    DECLARE next_folio BIGINT;

    UPDATE folio_sequence
    SET valor = valor + 1
    WHERE nombre   = 'ORDEN_SERVICIO'
      AND tenantId = NEW.tenantId;

    SELECT valor
    INTO next_folio
    FROM folio_sequence
    WHERE nombre   = 'ORDEN_SERVICIO'
      AND tenantId = NEW.tenantId;

    SET NEW.folio = CONCAT('ORD-', LPAD(next_folio, 10, '0'));

END$$

DELIMITER ;