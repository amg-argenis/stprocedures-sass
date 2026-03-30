DELIMITER $$

-- DROP PROCEDURE IF EXISTS SP_BUSCAR_USUARIO_EMAIL$$

CREATE PROCEDURE SP_BUSCAR_USUARIO_EMAIL(
    IN  pa_email    VARCHAR(150),
    IN  pa_tenantid    VARCHAR(150),

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
    AND activo = TRUE;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Usuario no encontrado con el email especificado o esta inactivo en la BD, desde MySQL';
    ELSE

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Busqueda de usuario por email exitoso, desde MySQL';

        SELECT
            idUsuario,
            tenantId,
            nombre,
            email,
            rol,
            activo,
            createdAt
        FROM tausuarios
        WHERE email = pa_email
        AND tenantId = pa_tenantid
        AND activo = TRUE;

    END IF;

END$$
DELIMITER ;
