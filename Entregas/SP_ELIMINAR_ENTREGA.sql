DELIMITER $$
DROP PROCEDURE IF EXISTS SP_ELIMINAR_ENTREGA$$

CREATE PROCEDURE SP_ELIMINAR_ENTREGA(
    IN  pa_tenantid       CHAR(36),
    IN  pa_identrega      CHAR(36),

    OUT pa_codigobd       INT,
    OUT pa_mensaje        VARCHAR(255)
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

    SELECT COUNT(idEntrega)
    INTO v_count
    FROM taentregas
    WHERE idEntrega = pa_identrega
      AND tenantId  = pa_tenantid;

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Entrega no encontrada para eliminar, desde MySQL';
    ELSE
        START TRANSACTION;

        UPDATE taentregas
        SET estado = 'ELIMINADO'
        WHERE idEntrega = pa_identrega
        AND tenantId  = pa_tenantid
        AND estado   <> 'ELIMINADO';

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudo eliminar la entrega, desde MySQL';
        END IF;

        -- Revert order status back to LISTO
        UPDATE taordenservicio
        SET estado = 'LISTO'
        WHERE idOrden = (
            SELECT ordenId FROM taentregas 
            WHERE idEntrega = pa_identrega
        )
        AND tenantId = pa_tenantid;

        COMMIT;

        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Entrega eliminada correctamente, desde MySQL';

    END IF;

END$$
DELIMITER ;
