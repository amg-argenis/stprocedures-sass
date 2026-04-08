DELIMITER $$
DROP PROCEDURE IF EXISTS SP_LISTAR_ENTREGAS$$

CREATE PROCEDURE SP_LISTAR_ENTREGAS(
    IN  pa_tenantid  CHAR(36),
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

    -- Verify if there are records
    SELECT COUNT(idEntrega)
    INTO v_count
    FROM taentregas
    WHERE tenantId = pa_tenantid
      AND estado  <> 'ELIMINADO';

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No se encontraron entregas registradas, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Consulta de entregas correcta, desde MySQL';

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
        WHERE tenantId = pa_tenantid
          AND estado  <> 'ELIMINADO';

    END IF;

END$$
DELIMITER ;
