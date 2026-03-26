DELIMITER $$
DROP PROCEDURE IF EXISTS SP_ACTUALIZAR_CLIENTE$$

CREATE PROCEDURE SP_ACTUALIZAR_CLIENTE(
    IN  pa_idcliente         VARCHAR(255),
    IN  pa_tenantid          VARCHAR(255),
    IN  pa_nombre            VARCHAR(150),
    IN  pa_contacto          VARCHAR(150),
    IN  pa_telefono          VARCHAR(30),
    IN  pa_email             VARCHAR(150),
    IN  pa_creditohabilitado TINYINT(1),
    IN  pa_limitecredito     DECIMAL(12,2),
    OUT pa_codigobd          INT,
    OUT pa_mensaje           VARCHAR(255)
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
    SET
        nombre            = pa_nombre,
        contacto          = pa_contacto,
        telefono          = pa_telefono,
        email             = pa_email,
        creditoHabilitado = pa_creditohabilitado,
        limiteCredito     = pa_limitecredito
    WHERE idCliente = pa_idcliente
      AND tenantId  = pa_tenantid
      AND activo    = TRUE;

    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No se encontro el cliente para actualizar, desde MySQL';
    ELSE
        COMMIT;
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Cliente actualizado correctamente, desde MySQL';

        SELECT
            idCliente,
            tenantId,
            nombre,
            contacto,
            telefono,
            email,
            creditoHabilitado,
            limiteCredito,
            activo,
            createdAt
        FROM tacliente
        WHERE idCliente = pa_idcliente
          AND tenantId  = pa_tenantid;
          
    END IF;

END$$
DELIMITER ;
