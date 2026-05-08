# DROP PROCEDURE IF EXISTS SP_ACTUALIZAR_PROCESO;
DELIMITER $$

CREATE PROCEDURE SP_ACTUALIZAR_PROCESO(
    IN pa_codigo VARCHAR(10),
    IN pa_tenantid VARCHAR(36),
    IN pa_nombre VARCHAR(100),
    IN pa_descripcion VARCHAR(255),
    IN pa_preciounitario DECIMAL(10, 2),
    OUT pa_codigobd INT,
    OUT pa_mensaje VARCHAR(255)
)
BEGIN
    DECLARE v_sqlstate CHAR(5);
    DECLARE v_error_message TEXT;
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1
                v_sqlstate = RETURNED_SQLSTATE,
                v_error_message = MESSAGE_TEXT;
            SET pa_codigobd = -1;
            SET pa_mensaje = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
        END;

    SELECT COUNT(idProceso)
    INTO v_count
    FROM taprocesos
    WHERE codigo = pa_codigo
      AND tenantId = pa_tenantid;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Proceso de lavado no encontrado para actualizar, desde MySQL';
    ELSE
        START TRANSACTION;

        UPDATE taprocesos
        SET nombre         = pa_nombre,
            descripcion    = pa_descripcion,
            precioUnitario = pa_preciounitario
        WHERE codigo = pa_codigo
            AND tenantId = pa_tenantid;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo actualizar el proceso de lavado, desde MySQL';
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje = 'Proceso de lavado actualizado correctamente, desde MySQL';

        SELECT
            idProceso,
            tenantId,
            nombre,
            descripcion,
            precioUnitario,
            activo,
            codigo
        FROM taprocesos
        WHERE codigo = pa_codigo
        AND tenantId = pa_tenantid;

    END IF;

END$$
DELIMITER ;
