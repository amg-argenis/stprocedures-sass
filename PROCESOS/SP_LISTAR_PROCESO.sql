DELIMITER $$
DROP PROCEDURE IF EXISTS SP_LISTAR_PROCESOS$$

CREATE PROCEDURE SP_LISTAR_PROCESOS(
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
    WHERE tenantId  = pa_tenantid
      AND activo = 1;


    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No hay registro de procesos de lavado en la BD, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Listado de proceso de lavado obtenido correctamente, desde MySQL';

        SELECT
            idProceso,
            tenantId,
            nombre,
            descripcion,
            precioUnitario,
            activo,
            codigo
        FROM taprocesos
        WHERE tenantId  = pa_tenantid
        AND activo = 1
        order by codigo;
    END IF;

END$$
DELIMITER ;
