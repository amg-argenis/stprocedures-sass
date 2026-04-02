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

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

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

END$$
DELIMITER ;