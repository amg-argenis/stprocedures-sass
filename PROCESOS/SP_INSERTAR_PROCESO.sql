DELIMITER $$
DROP PROCEDURE IF EXISTS SP_INSERTAR_PROCESO$$

CREATE PROCEDURE SP_INSERTAR_PROCESO(
    IN  pa_idproceso      VARCHAR(36),
    IN  pa_tenantid       VARCHAR(36),
    IN  pa_nombre         VARCHAR(100),
    IN  pa_descripcion    VARCHAR(255),
    IN  pa_preciounitario DECIMAL(10, 2),
    OUT pa_codigobd       INT,
    OUT pa_mensaje        VARCHAR(255)
)
BEGIN
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

    START TRANSACTION;

    INSERT INTO taprocesos (
        idProceso,
        tenantId,
        nombre,
        descripcion,
        precioUnitario,
        activo
    )
    VALUES (
        pa_idproceso,
        pa_tenantid,
        pa_nombre,
        pa_descripcion,
        pa_preciounitario,
        1
    );

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se pudo insertar el proceso de lavado, desde MySQL';
    END IF;

    COMMIT;

    SET pa_codigobd = 0;
    SET pa_mensaje  = 'Proceso de lavado insertado correctamente, desde MySQL';

    SELECT
        idProceso,
        tenantId,
        nombre,
        descripcion,
        precioUnitario,
        activo,
        codigo
    FROM taprocesos
    WHERE idProceso = pa_idproceso
      AND tenantId  = pa_tenantid;

END$$
DELIMITER ;
