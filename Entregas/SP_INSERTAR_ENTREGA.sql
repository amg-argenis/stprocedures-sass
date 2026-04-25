DELIMITER $$
DROP PROCEDURE IF EXISTS SP_INSERTAR_ENTREGA$$

CREATE PROCEDURE SP_INSERTAR_ENTREGA(
    IN  pa_identrega        CHAR(36),
    IN  pa_tenantid         CHAR(36),
    IN  pa_ordenid          CHAR(36),
    IN  pa_tipo             VARCHAR(20),
    IN  pa_fechaentrega     VARCHAR(50),
    IN  pa_totalentregado   INT,
    IN  pa_conformidad      TINYINT,
    IN  pa_observaciones    VARCHAR(255),
    OUT pa_codigobd         INT,
    OUT pa_mensaje          VARCHAR(255)
)
BEGIN
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;
    DECLARE v_count         INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

    -- Verify the order exists and is not eliminated
    SELECT COUNT(idOrden)
    INTO v_count
    FROM taordenservicio
    WHERE idOrden  = pa_ordenid
      AND tenantId = pa_tenantid
      AND estado  <> 'ELIMINADO'
      AND estado  <> 'ENTREGADO';

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Orden no encontrada, eliminada o ya entregada completamente, desde MySQL';
    ELSE
        START TRANSACTION;

        INSERT INTO taentregas (
            idEntrega, tenantId, ordenId, tipo,
            fechaEntrega, totalEntregado, conformidadCliente,
            observaciones, estado, fechaCreacion
        )
        VALUES (
            pa_identrega, pa_tenantid, pa_ordenid, pa_tipo,
            pa_fechaentrega, pa_totalentregado, pa_conformidad,
            pa_observaciones, 'ENTREGADO', NOW()
        );

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo guardar la entrega en BD, desde MySQL';
        END IF;

        -- Only update order to ENTREGADO when tipo is COMPLETO
        IF pa_tipo = 'COMPLETO' THEN
            UPDATE taordenservicio
            SET estado = 'ENTREGADO'
            WHERE idOrden  = pa_ordenid
              AND tenantId = pa_tenantid;
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Entrega guardada exitosamente en BD, desde MySQL';

        SELECT
            e.idEntrega,
            e.tenantId,
            e.ordenId,
            o.folio,              -- from taordenservicio
            c.nombre AS cliente,  -- from tacliente
            e.fechaEntrega,
            e.totalEntregado,
            e.conformidadCliente,
            e.observaciones,
            e.estado,
            e.fechaCreacion,
            e.tipo
        FROM taentregas e
        INNER JOIN taordenservicio o
            ON  o.idOrden  = e.ordenId
            AND o.tenantId = e.tenantId
        INNER JOIN tacliente c
            ON  c.idCliente = o.clienteId
            AND c.tenantId  = e.tenantId
        WHERE e.tenantId = pa_tenantid
        AND e.estado  <> 'ELIMINADO';

    END IF;

END$$
DELIMITER ;
