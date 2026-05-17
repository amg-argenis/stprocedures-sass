DELIMITER $$
DROP PROCEDURE IF EXISTS SP_LISTAR_TENANTS$$

CREATE PROCEDURE SP_LISTAR_TENANTS(
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
    WHERE activo = 1;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No hay tenants registrados en la BD, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Listado de tenants obtenido correctamente, desde MySQL';

        SELECT
            idTenant,
            nombre,
            activo,
            createdAt
        FROM tatenant
        WHERE activo = 1
        ORDER BY createdAt DESC;

    END IF;

END$$
DELIMITER ;