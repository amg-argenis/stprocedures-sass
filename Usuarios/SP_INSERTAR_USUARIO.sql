DELIMITER $$
DROP PROCEDURE IF EXISTS SP_INSERTAR_USUARIO$$

CREATE PROCEDURE SP_INSERTAR_USUARIO(
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

    -- Verificar si ya existe el email en ese tenant
    SELECT COUNT(idUsuario)
    INTO v_count
    FROM tausuarios
    WHERE email    = pa_email
      AND tenantId = pa_tenantid
      AND activo   = TRUE;

    IF v_count > 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'El email ya esta registrado para este tenant, desde MySQL';
    ELSE
        START TRANSACTION;

        INSERT INTO tausuarios (
            idUsuario, tenantId, nombre, email,
            password, rol, activo, createdAt
        )
        VALUES (
            pa_idusuario, pa_tenantid, pa_nombre, pa_email,
            pa_password, pa_rol, TRUE, NOW()
        );

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo insertar el usuario, desde MySQL';
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Usuario insertado correctamente, desde MySQL';

        SELECT
            idUsuario, tenantId, nombre, email,
            rol, activo, createdAt
        FROM tausuarios
        WHERE idUsuario = pa_idusuario;

    END IF;

END$$
DELIMITER ;
