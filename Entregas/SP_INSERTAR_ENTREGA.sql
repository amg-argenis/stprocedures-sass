DELIMITER $$

DROP PROCEDURE IF EXISTS SP_INSERTAR_ENTREGA$$

CREATE PROCEDURE SP_INSERTAR_ENTREGA(
    IN  pa_identrega        CHAR(36),
    IN  pa_tenantid         CHAR(36),
    IN  pa_ordenid          CHAR(36),
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

    -- Verify no existing delivery for this order
    SELECT COUNT(idEntrega)
    INTO v_count
    FROM taentregas
    WHERE ordenId  = pa_ordenid
    AND tenantId = pa_tenantid;

    IF v_count > 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Ya existe una entrega registrada para esta orden, desde MySQL';
    ELSE
        START TRANSACTION;

        INSERT INTO taentregas (
            idEntrega,
            tenantId,
            ordenId,
            fechaEntrega,
            totalEntregado,
            conformidadCliente,
            observaciones,
            estado,
            fechaCreacion
        )
        VALUES (
            pa_identrega,
            pa_tenantid,
            pa_ordenid,
            pa_fechaentrega,
            pa_totalentregado,
            pa_conformidad,
            pa_observaciones,
            'ENTREGADO',
            NOW()
        );

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo guardar la entrega en BD, desde MySQL';
        END IF;

        -- Update order status to ENTREGADO
        UPDATE taordenservicio
        SET estado = 'ENTREGADO'
        WHERE idOrden  = pa_ordenid
          AND tenantId = pa_tenantid;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Entrega guardadda exitosamente en BD, desde MySQL';

        SELECT
            idEntrega,
            tenantId,
            ordenId,
            fechaEntrega,
            totalEntregado,
            conformidadCliente,
            observaciones,
            estado,
            fechaCreacion
        FROM taentregas
        WHERE idEntrega = pa_identrega
          AND tenantId  = pa_tenantid;

    END IF;

END$$
DELIMITER ;
