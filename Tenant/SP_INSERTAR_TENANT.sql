DELIMITER $$
DROP PROCEDURE IF EXISTS SP_INSERTAR_TENANT$$

CREATE PROCEDURE SP_INSERTAR_TENANT(
    IN  pa_idtenant     CHAR(36),
    IN  pa_nombre       VARCHAR(150),
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

    -- Verificar si ya existe un tenant con el mismo nombre
    SELECT COUNT(idTenant)
    INTO v_count
    FROM tatenant
    WHERE nombre = pa_nombre
      AND activo = 1;

    IF v_count > 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Ya existe un tenant con ese nombre, desde MySQL';
    ELSE
        START TRANSACTION;

-- Nota importante: el createdAt es un tipo default CURRENT_TIMESTAMP nul, por eso no se declara en el insert
        INSERT INTO tatenant (
            idTenant,
            nombre,
            activo
        )
        VALUES (
            pa_idtenant,
            pa_nombre,
            1
        );

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo insertar el nuevo tenant, desde MySQL';
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Nuevo tenant insertado correctamente, desde MySQL';

        SELECT
            idTenant,
            nombre,
            activo,
            createdAt
        FROM tatenant
        WHERE idTenant = pa_idtenant;

    END IF;

END$$
DELIMITER ;