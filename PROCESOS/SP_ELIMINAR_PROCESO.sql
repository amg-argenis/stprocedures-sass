# DROP PROCEDURE IF EXISTS SP_ELIMINAR_PROCESO;
DELIMITER $$

CREATE PROCEDURE SP_ELIMINAR_PROCESO(
    IN pa_idproceso VARCHAR(36),
    IN pa_tenantid VARCHAR(36),
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
    WHERE idProceso = pa_idproceso
      AND tenantId = pa_tenantid;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Proceso de lavado no encontrado para eliminar, desde MySQL';
    ELSE
        START TRANSACTION;

        UPDATE taprocesos
        SET activo = 0
        WHERE idProceso = pa_idproceso
            AND tenantId = pa_tenantid;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo eliminar el proceso de lavado, desde MySQL';
        END IF;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje = 'Proceso de lavado eliminado correctamente, desde MySQL';

    END IF;

END$$
DELIMITER ;
