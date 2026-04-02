DELIMITER $$

DROP PROCEDURE IF EXISTS SP_BUSCAR_ENTREGA$$

CREATE PROCEDURE SP_BUSCAR_ENTREGA(
    IN  pa_tenantid  CHAR(36),
    IN  pa_ordenid   CHAR(36),
    OUT pa_codigobd  INT,
    OUT pa_mensaje   VARCHAR(255)
)
BEGIN
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;
    DECLARE v_count         INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

    SELECT COUNT(idEntrega)
    INTO v_count
    FROM taentregas
    WHERE ordenId  = pa_ordenid
      AND tenantId = pa_tenantid;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Entrega no encontrada, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Entrega encontrada correctamente, desde MySQL';

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
        WHERE ordenId  = pa_ordenid
          AND tenantId = pa_tenantid;

    END IF;

END$$
DELIMITER ;
