DELIMITER $$
DROP PROCEDURE IF EXISTS SP_ACTUALIZAR_ENTREGA$$

CREATE PROCEDURE SP_ACTUALIZAR_ENTREGA(
    IN  pa_tenantid       CHAR(36),
    IN  pa_identrega      CHAR(36),
    IN  pa_ordenid        CHAR(36),
    IN  pa_fechaentrega   DATE,
    IN  pa_totalentregado INT,
    IN  pa_conformidad    TINYINT,
    IN  pa_observaciones  VARCHAR(255),
    IN  pa_estado         VARCHAR(255),

    OUT pa_codigobd       INT,
    OUT pa_mensaje        VARCHAR(255)
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

    SELECT COUNT(idEntrega)
    INTO v_count
    FROM taentregas
    WHERE idEntrega = pa_identrega
      AND ordenId   = pa_ordenid
      AND tenantId  = pa_tenantid;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Entrega no encontrada para actualizar, desde MySQL';
    ELSE
        START TRANSACTION;

        UPDATE taentregas
        SET
            fechaEntrega       = pa_fechaentrega,
            totalEntregado     = pa_totalentregado,
            conformidadCliente = pa_conformidad,
            observaciones      = pa_observaciones
        WHERE idEntrega = pa_identrega
          AND ordenId   = pa_ordenid
          AND tenantId  = pa_tenantid;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo actualizar la entrega, desde MySQL';
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Entrega actualizada correctamente, desde MySQL';

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
