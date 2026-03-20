-- ============================================================
-- TRIGGER PostgreSQL - Auto-generar folio en taordenservicio
-- Convertido desde trigger MySQL
-- ============================================================

-- Paso 1: Tabla folio_sequence (si no existe)
-- ============================================================
CREATE TABLE IF NOT EXISTS folio_sequence (
    nombre VARCHAR(100) PRIMARY KEY,
    valor  BIGINT NOT NULL DEFAULT 0
);

-- Registro inicial para ordenes de servicio
INSERT INTO folio_sequence (nombre, valor)
VALUES ('ORDEN_SERVICIO', 0)
ON CONFLICT (nombre) DO NOTHING;


-- Paso 2: Función que ejecuta el trigger
-- ============================================================
CREATE OR REPLACE FUNCTION fn_trigger_generar_folio_orden()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    next_folio BIGINT;
BEGIN
    -- Incrementa el contador de forma atomica y obtiene el nuevo valor
    UPDATE folio_sequence
    SET valor = valor + 1
    WHERE nombre = 'ORDEN_SERVICIO'
    RETURNING valor INTO next_folio;

    -- Asigna el folio al nuevo registro
    NEW.folio := 'ORD-' || LPAD(next_folio::TEXT, 9, '0');

    RETURN NEW;
END;
$$;


-- Paso 3: Crear el Trigger sobre la tabla
-- ============================================================
CREATE OR REPLACE TRIGGER trg_generar_folio_orden
BEFORE INSERT
ON taordenservicio
FOR EACH ROW
EXECUTE FUNCTION fn_trigger_generar_folio_orden();