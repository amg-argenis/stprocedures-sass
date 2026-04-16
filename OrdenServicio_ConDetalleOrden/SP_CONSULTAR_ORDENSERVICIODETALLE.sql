DELIMITER $$
DROP PROCEDURE IF EXISTS SP_BUSCAR_ORDENSERVICIOCONDETALLE$$

CREATE PROCEDURE SP_BUSCAR_ORDENSERVICIOCONDETALLE(
    IN  pa_tenantid   CHAR(36),
    IN  pa_idorden    CHAR(36),
    IN  pa_folio      VARCHAR(50),
    OUT pa_codigobd   INT,
    OUT pa_mensaje    VARCHAR(255)
)
BEGIN
    DECLARE vl_existe       INT DEFAULT 0;
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd = -1;
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

    -- Verificar si existe la orden
    SELECT COUNT(idOrden)
    INTO   vl_existe
    FROM   taordenservicio
    WHERE  idOrden  = pa_idorden
      AND  folio    = pa_folio
      AND  tenantId = pa_tenantid
      AND  estado  <> 'ELIMINADO';

    IF vl_existe = 0 THEN
        SET pa_codigobd = 2;
        SET pa_mensaje  = 'Orden de servicio no encontrada, desde MySQL';
    ELSE
        SET pa_codigobd = 0;
        SET pa_mensaje  = 'Consulta exitosa de orden servicio con detalle, desde MySQL';

        SELECT
            o.idOrden,
            o.clienteId,
            o.folio,
            o.fechaIngreso,
            o.estado,
            o.totalPrendas,
            o.observaciones,
            o.createdAt,
            o.tenantId,
            o.fechaEntrega,
            d.idDetalleOrden,
            d.ordenId      AS ordenIdDetalle,
            d.procesoId,
            d.tipoPrenda,
            d.cantidad,
            d.colorReferencia,
            d.tenantId     AS tenantIdDetalle
        FROM taordenservicio o
        LEFT JOIN tadetalleordenservicio d
            ON  d.ordenId  = o.idOrden
            AND d.tenantId = o.tenantId
            AND d.estado  <> 'ELIMINADO'
        WHERE o.idOrden  = pa_idorden
          AND o.folio    = pa_folio
          AND o.tenantId = pa_tenantid
          AND o.estado  <> 'ELIMINADO';

    END IF;

END$$
DELIMITER ;