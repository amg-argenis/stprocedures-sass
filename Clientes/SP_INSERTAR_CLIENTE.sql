DELIMITER $$
-- DROP PROCEDURE IF EXISTS SP_INSERTAR_CLIENTE$$

CREATE PROCEDURE SP_INSERTAR_CLIENTE(
    IN  pa_idcliente          VARCHAR(255),
    IN  pa_tenantid           VARCHAR(255),
    IN  pa_nombre             VARCHAR(150),
    IN  pa_contacto           VARCHAR(150),
    IN  pa_telefono           VARCHAR(30),
    IN  pa_email              VARCHAR(150),
    IN  pa_creditohabilitado  TINYINT(1),
    IN  pa_limitecredito      DECIMAL(12,2),
    OUT pa_codigobd           INT,
    OUT pa_mensaje            VARCHAR(255)
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

    INSERT INTO tacliente (
        idCliente,
        tenantId,
        nombre,
        contacto,
        telefono,
        email,
        creditoHabilitado,
        limiteCredito,
        activo
    )
    VALUES (
        pa_idcliente,
        pa_tenantid,
        pa_nombre,
        pa_contacto,
        pa_telefono,
        pa_email,
        pa_creditohabilitado,
        pa_limitecredito,
        TRUE
    );

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se pudo insertar el cliente, desde MySQL';
    END IF;

    COMMIT;

    SET pa_codigobd = 0;
    SET pa_mensaje  = 'Cliente insertado correctamente, desde MySQL';

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

END$$
DELIMITER ;