-- ============================================================
-- FUNCIONES PostgreSQL - tadetalleorden
-- Convertidas desde Stored Procedures MySQL
-- ============================================================


-- ============================================================
-- 1. FN_BUSCAR_DETALLEORDEN
-- ============================================================
CREATE OR REPLACE FUNCTION FN_BUSCAR_DETALLEORDEN(
    pa_iddetalleorden VARCHAR,
    pa_ordenid        VARCHAR
)
RETURNS TABLE (
    pa_codigobd    INT,
    pa_mensaje     VARCHAR,
    idDetalleOrden VARCHAR,
    ordenId        VARCHAR,
    procesoId      VARCHAR,
    tipoPrenda     VARCHAR,
    cantidad       INT,
    colorReferencia VARCHAR,
    tenantId       VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
BEGIN

    SELECT COUNT(d.idDetalleOrden)
    INTO v_count
    FROM tadetalleorden d
    WHERE d.idDetalleOrden = pa_iddetalleorden
      AND d.ordenId        = pa_ordenid;

    IF v_count = 0 THEN
        RETURN QUERY SELECT
            1,
            'Orden detalle de servicio no encontrada desde PostgreSQL'::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR;
    ELSE
        RETURN QUERY
        SELECT
            0,
            'Orden detalle de servicio encontrada desde PostgreSQL'::VARCHAR,
            d.idDetalleOrden::VARCHAR,
            d.ordenId::VARCHAR,
            d.procesoId::VARCHAR,
            d.tipoPrenda::VARCHAR,
            d.cantidad,
            d.colorReferencia::VARCHAR,
            d.tenantId::VARCHAR
        FROM tadetalleorden d
        WHERE d.idDetalleOrden = pa_iddetalleorden
          AND d.ordenId        = pa_ordenid;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            2,
            ('Error detalle orden: ' || SQLERRM)::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR;
END;
$$;


-- ============================================================
-- 2. FN_INSERTAR_DETALLEORDEN
-- ============================================================
CREATE OR REPLACE FUNCTION FN_INSERTAR_DETALLEORDEN(
    pa_idordendetalle VARCHAR,
    pa_ordenid        VARCHAR,
    pa_procesoid      VARCHAR,
    pa_tipoprenda     VARCHAR,
    pa_cantidad       INT,
    pa_colorreferencia VARCHAR,
    pa_tenantid       VARCHAR
)
RETURNS TABLE (
    pa_codigobd INT,
    pa_mensaje  VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows INT;
BEGIN

    INSERT INTO tadetalleorden (
        idDetalleOrden,
        ordenId,
        procesoId,
        tipoPrenda,
        cantidad,
        colorReferencia,
        tenantId
    )
    VALUES (
        pa_idordendetalle,
        pa_ordenid,
        pa_procesoid,
        pa_tipoprenda,
        pa_cantidad,
        pa_colorreferencia,
        pa_tenantid
    );

    GET DIAGNOSTICS v_rows = ROW_COUNT;

    IF v_rows = 0 THEN
        RETURN QUERY SELECT
            1,
            'No se pudo insertar la orden detalle desde PostgreSQL'::VARCHAR;
    ELSE
        RETURN QUERY SELECT
            0,
            'Orden detalle insertada correctamente desde PostgreSQL'::VARCHAR;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            1,
            ('Error detalle orden: ' || SQLERRM)::VARCHAR;
END;
$$;