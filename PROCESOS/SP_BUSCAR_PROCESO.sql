DELIMITER $$
DROP PROCEDURE IF EXISTS SP_BUSCAR_PROCESO$$

CREATE PROCEDURE SP_BUSCAR_PROCESO(
    IN  pa_codigoproceso      VARCHAR(36),
    IN  pa_tenantid       VARCHAR(36),
    OUT pa_codigobd       INT,
    OUT pa_mensaje        VARCHAR(255)
)
BEGIN
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;
    DECLARE v_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

    START TRANSACTION;

    SELECT COUNT(codigo)
    INTO v_count
    FROM taprocesos
    WHERE codigo = pa_codigoproceso
      AND tenantId  = pa_tenantid;


    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Proceso de lavado no encontrado en la BD, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Proceso de lavado encontrado correctamente, desde MySQL';

        SELECT
            idProceso,
            tenantId,
            nombre,
            descripcion,
            precioUnitario,
            activo,
            codigo
        FROM taprocesos
        WHERE codigo = pa_codigoproceso
        AND tenantId  = pa_tenantid;
    END IF;

END$$
DELIMITER ;
