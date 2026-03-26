DELIMITER $$
CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_ORDENSERVICIO(
    IN  pa_tenantid     VARCHAR(255),
    IN  pa_idorden      VARCHAR(255),
    IN  pa_clienteid    VARCHAR(255),
    IN  pa_folio        VARCHAR(255),
    IN  pa_fechaingreso VARCHAR(100),
    IN  pa_estado       VARCHAR(100),
    IN  pa_totalprendas INT,
    IN  pa_observaciones VARCHAR(255),
    IN  pa_fechaentrega VARCHAR(100),
    OUT pa_codigobd     INT,
    OUT pa_mensaje      VARCHAR(255)
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

    UPDATE taordenservicio
    SET
        fechaIngreso  = pa_fechaingreso,
        estado        = pa_estado,
        totalPrendas  = pa_totalprendas,
        observaciones = pa_observaciones,
        fechaEntrega  = pa_fechaentrega
    WHERE TRIM(idOrden)   = TRIM(pa_idorden)
      AND TRIM(clienteId) = TRIM(pa_clienteid)
      AND TRIM(folio)     = TRIM(pa_folio)
      AND TRIM(tenantId)  = TRIM(pa_tenantid)
      AND estado         <> 'ELIMINADO';

    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'No se encontro la orden de servicio para actualizar, desde MySQL';
    ELSE
        COMMIT;
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Orden de servicio actualizada correctamente, desde MySQL';
    END IF;

END$$
DELIMITER ;