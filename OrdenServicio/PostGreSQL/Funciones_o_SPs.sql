-- ============================================================
-- FUNCIONES PostgreSQL - taordenservicio
-- Convertidas desde Stored Procedures MySQL
-- ============================================================


-- ============================================================
-- 1. FN_INSERTAR_ORDENSERVICIO
-- ============================================================
CREATE OR REPLACE FUNCTION FN_INSERTAR_ORDENSERVICIO(
    pa_idorden       VARCHAR,
    pa_clienteid     VARCHAR,
    pa_fechaingreso  VARCHAR,
    pa_estado        VARCHAR,
    pa_totalprendas  INT,
    pa_observaciones VARCHAR,
    pa_fechaentrega  VARCHAR,
    pa_tenantid      VARCHAR
)
RETURNS TABLE (
    pa_codigobd      INT,
    pa_mensaje       VARCHAR,
    po_idorden       VARCHAR,
    po_clienteid     VARCHAR,
    po_folio         VARCHAR,
    po_fechaingreso  VARCHAR,
    po_estado        VARCHAR,
    po_totalprendas  INT,
    po_observaciones VARCHAR,
    po_createdat     VARCHAR,
    po_tenantid      VARCHAR,
    po_fechaentrega  VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO taordenservicio (
        idOrden,
        clienteId,
        fechaIngreso,
        estado,
        totalPrendas,
        observaciones,
        createdAt,
        tenantId,
        fechaEntrega
    )
    VALUES (
        pa_idorden,
        pa_clienteid,
        pa_fechaingreso::TIMESTAMP,
        pa_estado,
        pa_totalprendas,
        pa_observaciones,
        NOW(),
        pa_tenantid,
        pa_fechaentrega::TIMESTAMP
    );

    RETURN QUERY
    SELECT
        0,
        'Orden de servicio insertada correctamente, desde PostgreSQL'::VARCHAR,
        o.idOrden::VARCHAR,
        o.clienteId::VARCHAR,
        o.folio::VARCHAR,
        o.fechaIngreso::VARCHAR,
        o.estado::VARCHAR,
        o.totalPrendas,
        o.observaciones::VARCHAR,
        o.createdAt::VARCHAR,
        o.tenantId::VARCHAR,
        o.fechaEntrega::VARCHAR
    FROM taordenservicio o
    WHERE o.idOrden = pa_idorden;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            1,
            ('Error orden servicio: ' || SQLERRM)::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR;
END;
$$;


-- ============================================================
-- 2. FN_BUSCAR_ORDENSERVICIO
-- ============================================================
CREATE OR REPLACE FUNCTION FN_BUSCAR_ORDENSERVICIO(
    pa_idorden    VARCHAR,
    pa_ordenfolio VARCHAR
)
RETURNS TABLE (
    pa_codigobd   INT,
    pa_mensaje    VARCHAR,
    idOrden       VARCHAR,
    clienteId     VARCHAR,
    folio         VARCHAR,
    fechaIngreso  VARCHAR,
    estado        VARCHAR,
    totalPrendas  INT,
    observaciones VARCHAR,
    createdAt     VARCHAR,
    tenantId      VARCHAR,
    fechaEntrega  VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
BEGIN

    SELECT COUNT(*)
    INTO v_count
    FROM taordenservicio o
    WHERE o.folio   = pa_ordenfolio
      AND o.idOrden = pa_idorden;

    IF v_count = 0 THEN
        RETURN QUERY SELECT
            1,
            'Orden de servicio no encontrada desde PostgreSQL'::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR;
    ELSE
        RETURN QUERY
        SELECT
            0,
            'Orden de servicio encontrada desde PostgreSQL'::VARCHAR,
            o.idOrden::VARCHAR,
            o.clienteId::VARCHAR,
            o.folio::VARCHAR,
            o.fechaIngreso::VARCHAR,
            o.estado::VARCHAR,
            o.totalPrendas,
            o.observaciones::VARCHAR,
            o.createdAt::VARCHAR,
            o.tenantId::VARCHAR,
            o.fechaEntrega::VARCHAR
        FROM taordenservicio o
        WHERE o.folio   = pa_ordenfolio
          AND o.idOrden = pa_idorden
          AND o.estado <> 'ELIMINADO';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            2,
            ('Error orden servicio: ' || SQLERRM)::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR;
END;
$$;


-- ============================================================
-- 3. FN_ELIMINAR_ORDENSERVICIO  (soft delete)
-- ============================================================
CREATE OR REPLACE FUNCTION FN_ELIMINAR_ORDENSERVICIO(
    pa_idorden VARCHAR,
    pa_folio   VARCHAR
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

    UPDATE taordenservicio
    SET estado = 'ELIMINADO'
    WHERE TRIM(idOrden) = TRIM(pa_idorden)
      AND TRIM(folio)   = TRIM(pa_folio);

    GET DIAGNOSTICS v_rows = ROW_COUNT;

    IF v_rows = 0 THEN
        RETURN QUERY SELECT
            2,
            'No se encontro la orden de servicio para eliminar, desde PostgreSQL'::VARCHAR;
    ELSE
        RETURN QUERY SELECT
            0,
            'Orden de servicio eliminada correctamente, desde PostgreSQL'::VARCHAR;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            1,
            ('Error orden servicio: ' || SQLERRM)::VARCHAR;
END;
$$;


-- ============================================================
-- 4. FN_ACTUALIZAR_ORDENSERVICIO
-- ============================================================
CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_ORDENSERVICIO(
    pa_idorden       VARCHAR,
    pa_clienteid     VARCHAR,
    pa_folio         VARCHAR,
    pa_fechaingreso  VARCHAR,
    pa_estado        VARCHAR,
    pa_totalprendas  INT,
    pa_observaciones VARCHAR,
    pa_fechaentrega  VARCHAR
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

    UPDATE taordenservicio
    SET
        fechaIngreso  = pa_fechaingreso::TIMESTAMP,
        estado        = pa_estado,
        totalPrendas  = pa_totalprendas,
        observaciones = pa_observaciones,
        fechaEntrega  = pa_fechaentrega::TIMESTAMP
    WHERE TRIM(idOrden)   = TRIM(pa_idorden)
      AND TRIM(clienteId) = TRIM(pa_clienteid)
      AND TRIM(folio)     = TRIM(pa_folio)
      AND estado         <> 'ELIMINADO';

    GET DIAGNOSTICS v_rows = ROW_COUNT;

    IF v_rows = 0 THEN
        RETURN QUERY SELECT
            2,
            'No se encontro la orden de servicio para actualizar, desde PostgreSQL'::VARCHAR;
    ELSE
        RETURN QUERY SELECT
            0,
            'Orden de servicio actualizada correctamente, desde PostgreSQL'::VARCHAR;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            1,
            ('Error orden servicio: ' || SQLERRM)::VARCHAR;
END;
$$;


-- ============================================================
-- 5. FN_LISTAR_ORDENES
-- ============================================================
CREATE OR REPLACE FUNCTION FN_LISTAR_ORDENES()
RETURNS TABLE (
    pa_codigobd   INT,
    pa_mensaje    VARCHAR,
    idOrden       VARCHAR,
    clienteId     VARCHAR,
    folio         VARCHAR,
    fechaIngreso  VARCHAR,
    estado        VARCHAR,
    totalPrendas  INT,
    observaciones VARCHAR,
    createdAt     VARCHAR,
    tenantId      VARCHAR,
    fechaEntrega  VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY
    SELECT
        0,
        'Consulta correcta en orden servicio BD'::VARCHAR,
        o.idOrden::VARCHAR,
        o.clienteId::VARCHAR,
        o.folio::VARCHAR,
        o.fechaIngreso::VARCHAR,
        o.estado::VARCHAR,
        o.totalPrendas,
        o.observaciones::VARCHAR,
        o.createdAt::VARCHAR,
        o.tenantId::VARCHAR,
        o.fechaEntrega::VARCHAR
    FROM taordenservicio o
    WHERE o.estado <> 'ELIMINADO';

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            1,
            ('Error orden servicio: ' || SQLERRM)::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR;
END;
$$;


-- ============================================================
-- 6. FN_LISTARPOR_FECHAINGRESO
-- ============================================================
CREATE OR REPLACE FUNCTION FN_LISTARPOR_FECHAINGRESO(
    pa_fechaingreso VARCHAR
)
RETURNS TABLE (
    pa_codigobd   INT,
    pa_mensaje    VARCHAR,
    idOrden       VARCHAR,
    clienteId     VARCHAR,
    folio         VARCHAR,
    fechaIngreso  VARCHAR,
    estado        VARCHAR,
    totalPrendas  INT,
    observaciones VARCHAR,
    createdAt     VARCHAR,
    tenantId      VARCHAR,
    fechaEntrega  VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN QUERY
    SELECT
        0,
        'Consulta correcta en orden servicio BD'::VARCHAR,
        o.idOrden::VARCHAR,
        o.clienteId::VARCHAR,
        o.folio::VARCHAR,
        o.fechaIngreso::VARCHAR,
        o.estado::VARCHAR,
        o.totalPrendas,
        o.observaciones::VARCHAR,
        o.createdAt::VARCHAR,
        o.tenantId::VARCHAR,
        o.fechaEntrega::VARCHAR
    FROM taordenservicio o
    WHERE o.fechaIngreso::DATE = pa_fechaingreso::DATE
      AND o.estado <> 'ELIMINADO';

EXCEPTION
    WHEN OTHERS THEN
        RETURN QUERY SELECT
            1,
            ('Error orden servicio: ' || SQLERRM)::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::INT,     NULL::VARCHAR, NULL::VARCHAR,
            NULL::VARCHAR, NULL::VARCHAR;
END;
$$;
