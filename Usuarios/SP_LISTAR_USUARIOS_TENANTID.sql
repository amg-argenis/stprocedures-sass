DELIMITER $$

-- DROP PROCEDURE IF EXISTS SP_LISTAR_USUARIOS_TENANTID$$

CREATE PROCEDURE SP_LISTAR_USUARIOS_TENANTID(
    IN pa_tenantid VARCHAR(255),

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
    WHERE tenantId = pa_tenantid;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No hay registros de usuarios en la BD, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Listado de usuarios obtenido correctamente por tenant id, desde MySQL';

        SELECT
            idUsuario,
            tenantId,
            nombre,
            email,
            rol,
            activo,
            createdAt
        FROM tausuarios
        WHERE tenantId = pa_tenantid;

    END IF;

END$$
DELIMITER ;
