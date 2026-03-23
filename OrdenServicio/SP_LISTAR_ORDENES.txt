DELIMITER $$
CREATE OR REPLACE PROCEDURE SP_LISTAR_ORDENES(
    IN  pa_tenantid  VARCHAR(255),
    OUT pa_codigobd  INT,
    OUT pa_mensaje   VARCHAR(255)
)
BEGIN
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ': ', v_error_message);
    END;

    SET pa_codigobd = 0;
    SET pa_mensaje  = 'Consulta correcta en orden servicio BD';

    SELECT
        idOrden,
        clienteId,
        folio,
        fechaIngreso,
        estado,
        totalPrendas,
        observaciones,
        createdAt,
        tenantId,
        fechaEntrega
    FROM taordenservicio
    WHERE estado    <> 'ELIMINADO'
      AND tenantId   = pa_tenantid;

END$$
DELIMITER ;