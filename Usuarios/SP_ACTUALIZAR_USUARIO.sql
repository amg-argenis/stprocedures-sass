DELIMITER $$

DROP PROCEDURE IF EXISTS SP_ACTUALIZAR_USUARIO$$

CREATE PROCEDURE SP_ACTUALIZAR_USUARIO(
    IN  pa_idusuario VARCHAR(150),
    IN  pa_tenantid  VARCHAR(150),
    IN  pa_nombre    VARCHAR(150),
    IN  pa_email     VARCHAR(150),
    IN  pa_password  VARCHAR(255),
    IN  pa_rol       VARCHAR(100),
    
    OUT pa_codigobd  INT,
    OUT pa_mensaje   VARCHAR(255)
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

-- Verificar que exista el usuario
    SELECT COUNT(idUsuario)
    INTO v_count
    FROM tausuarios
    WHERE idUsuario = pa_idusuario
    AND tenantId  = pa_tenantid
    AND activo    = TRUE;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No existe el usuario para actualizar en la BD, desde MySQL';
    ELSE
        START TRANSACTION;

        UPDATE tausuarios
        SET nombre   = pa_nombre,
            email    = pa_email,
            password = pa_password,
            rol      = pa_rol
        WHERE idUsuario = pa_idusuario
        AND tenantId  = pa_tenantid
        AND activo    = TRUE;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo actualizar el usuario en la BD, desde MySQL';
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Usuario actualizado correctamente, desde MySQL';

        SELECT
            idUsuario, tenantId, nombre, email,
            rol, activo, createdAt
        FROM tausuarios
        WHERE idUsuario = pa_idusuario
        AND email = pa_email;

    END IF;

END$$
DELIMITER ;
