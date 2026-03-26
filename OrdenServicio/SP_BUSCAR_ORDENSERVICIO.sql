DELIMITER $$
CREATE OR REPLACE PROCEDURE SP_BUSCAR_ORDENSERVICIO(
    IN  pa_tenantid   VARCHAR(255),
    IN  pa_idorden    VARCHAR(255),
    IN  pa_ordenfolio VARCHAR(255),
    OUT pa_codigobd   INT,
    OUT pa_mensaje    VARCHAR(255)
)
BEGIN
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;
    DECLARE v_count         INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ': ', v_error_message);
    END;

    SELECT COUNT(idOrden)
    INTO v_count
    FROM taordenservicio
    WHERE folio    = pa_ordenfolio
      AND idOrden  = pa_idorden
      AND tenantId = pa_tenantid
      AND estado  <> 'ELIMINADO';

    IF v_count = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Orden de servicio no encontrada desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Orden de servicio encontrada desde MySQL';

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
        WHERE folio    = pa_ordenfolio
          AND idOrden  = pa_idorden
          AND tenantId = pa_tenantid
          AND estado  <> 'ELIMINADO';
    END IF;

END$$
DELIMITER ;