DELIMITER $$
DROP PROCEDURE IF EXISTS SP_BUSCAR_TENANT$$

CREATE PROCEDURE SP_BUSCAR_TENANT(
    IN  pa_idtenant     CHAR(36),
    OUT pa_codigobd     INT,
    OUT pa_mensaje      VARCHAR(255)
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

    SELECT COUNT(idTenant)
    INTO v_count
    FROM tatenant
    WHERE idTenant = pa_idtenant
      AND activo   = 1;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Tenant no encontrado en la BD, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Tenant encontrado correctamente, desde MySQL';

        SELECT
            idTenant,
            nombre,
            activo,
            createdAt
        FROM tatenant
        WHERE idTenant = pa_idtenant
          AND activo   = 1;

    END IF;

END$$
DELIMITER ;