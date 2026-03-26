DELIMITER $$
DROP PROCEDURE IF EXISTS SP_ELIMINAR_CLIENTE$$

CREATE PROCEDURE SP_ELIMINAR_CLIENTE(
    IN  pa_idcliente VARCHAR(255),
    IN  pa_tenantid  VARCHAR(255),
    OUT pa_codigobd  INT,
    OUT pa_mensaje   VARCHAR(255)
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

    UPDATE tacliente
    SET activo = FALSE
    WHERE idCliente = pa_idcliente
      AND tenantId  = pa_tenantid
      AND activo    = TRUE;

    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No se encontro el cliente para eliminar, desde MySQL';
    ELSE
        COMMIT;
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Cliente eliminado correctamente, desde MySQL';
    END IF;

END$$
DELIMITER ;
