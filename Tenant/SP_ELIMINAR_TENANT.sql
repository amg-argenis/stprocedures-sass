DELIMITER $$
DROP PROCEDURE IF EXISTS SP_ELIMINAR_TENANT$$

CREATE PROCEDURE SP_ELIMINAR_TENANT(
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
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

    -- Verificar si existe el tenant
    SELECT COUNT(idTenant)
    INTO v_count
    FROM tatenant
    WHERE idTenant = pa_idtenant
      AND activo   = 1;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Tenant no encontrado o ya inactivo, desde MySQL';
    ELSE
        START TRANSACTION;

        UPDATE tatenant
        SET activo = 0
        WHERE idTenant = pa_idtenant;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo eliminar el tenant, desde MySQL';
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Tenant eliminado correctamente, desde MySQL';

    END IF;

END$$
DELIMITER ;