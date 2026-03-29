DROP PROCEDURE IF EXISTS SP_REACTIVAR_USUARIO;
DELIMITER $$

CREATE PROCEDURE SP_REACTIVAR_USUARIO(
    IN  pa_email        VARCHAR(150),
    IN  pa_tenantid     VARCHAR(150),

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

    SELECT COUNT(idUsuario)
    INTO v_count
    FROM tausuarios
    WHERE email = pa_email
    AND tenantId = pa_tenantid
    AND activo = FALSE;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Usuario no encontrado para reactivar en la BD, desde MySQL';
    ELSE
        UPDATE tausuarios
        SET activo = TRUE
        WHERE email = pa_email
        AND tenantId = pa_tenantid
        AND activo = FALSE;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Usuario reactivado correctamente en la BD, desde MySQL';

    END IF;

END$$
DELIMITER ;
