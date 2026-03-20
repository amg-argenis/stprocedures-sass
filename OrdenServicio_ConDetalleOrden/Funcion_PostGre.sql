-- ============================================================
-- FUNCION PostgreSQL - Orden de Servicio con Detalle (JOIN)
-- Convertida desde Stored Procedure MySQL
-- ============================================================


-- ============================================================
-- FN_BUSCAR_ORDENSERVICIOCONDETALLE
-- ============================================================
CREATE OR REPLACE FUNCTION FN_BUSCAR_ORDENSERVICIOCONDETALLE(
    pa_idorden VARCHAR,
    pa_folio   VARCHAR
)
RETURNS TABLE (
    pa_codigobd      INT,
    pa_mensajebd     VARCHAR,
    -- Campos taordenservicio
    idOrden          VARCHAR,
    clienteId        VARCHAR,
    folio            VARCHAR,
    fechaIngreso     VARCHAR,
    estado           VARCHAR,
    totalPrendas     INT,
    observaciones    VARCHAR,
    createdAt        VARCHAR,
    tenantId         VARCHAR,
    fechaEntrega     VARCHAR,
    -- Campos tadetalleorden
    idDetalleOrden   VARCHAR,
    ordenId          VARCHAR,
    procesoId        VARCHAR,
    tipoPrenda       VARCHAR,
    cantidad         INT,
    colorReferencia  VARCHAR,
    tenantIdDetalle  VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    vl_existe INT;
BEGIN

    SELECT COUNT(o.idOrden)
    INTO vl_existe
    FROM taordenservicio o
    WHERE o.idOrden = pa_idorden
      AND o.folio   = pa_folio;

    IF vl_existe = 0 THEN
        RETURN QUERY SELECT
            2,
            'Orden de servicio con detalle no encontrada, desde PostgreSQL'::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::INT,     NULL::VARCHAR,
            NULL::VARCHAR;
    ELSE
        RETURN QUERY
        SELECT
            0,
            'Consulta exitosa de orden servicio con detalle, desde PostgreSQL'::VARCHAR,
            o.idOrden::VARCHAR,
            o.clienteId::VARCHAR,
            o.folio::VARCHAR,
            o.fechaIngreso::VARCHAR,
            o.estado::VARCHAR,
            o.totalPrendas,
            o.observaciones::VARCHAR,
            o.createdAt::VARCHAR,
            o.tenantId::VARCHAR,
            o.fechaEntrega::VARCHAR,
            d.idDetalleOrden::VARCHAR,
            d.ordenId::VARCHAR,
            d.procesoId::VARCHAR,
            d.tipoPrenda::VARCHAR,
            d.cantidad,
            d.colorReferencia::VARCHAR,
            d.tenantId::VARCHAR
        FROM taordenservicio o
        INNER JOIN tadetalleorden d
            ON  d.ordenId  = o.idOrden
            AND d.tenantId = o.tenantId
        WHERE o.idOrden = pa_idorden
          AND o.folio   = pa_folio;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            1,
            'Error interno al consultar la orden de servicio con detalle, desde PostgreSQL'::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::INT,     NULL::VARCHAR,
            NULL::VARCHAR;
END;
$$;
