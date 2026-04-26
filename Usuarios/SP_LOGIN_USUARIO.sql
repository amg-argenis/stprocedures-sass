DELIMITER $$

DROP PROCEDURE IF EXISTS SP_LOGIN_USUARIO$$

CREATE PROCEDURE SP_LOGIN_USUARIO(
    IN  pa_email    VARCHAR(150),
    IN  pa_password VARCHAR(255),
    OUT pa_codigobd INT,
    OUT pa_mensaje  VARCHAR(255)
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

    SELECT
        u.idUsuario,
        u.tenantId,
        u.nombre,
        u.email,
        u.rol,
        u.activo,
        u.createdAt,
        t.nombre AS nombreTenant
    FROM tausuarios u
    LEFT JOIN tatenant t ON u.tenantId = t.idTenant
    WHERE u.email    = pa_email
      AND u.password = pa_password
      AND u.activo   = 1
    LIMIT 1;

    IF ROW_COUNT() = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Credenciales incorrectas o usuario inactivo';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Login exitoso';
    END IF;

END$$

DELIMITER ;