DELIMITER $$
CREATE PROCEDURE SP_INSERTAR_DETALLEORDEN(
    IN  pa_idordendetalle  VARCHAR(255),
    IN  pa_ordenid         VARCHAR(255),
    IN  pa_procesoid       VARCHAR(255),
    IN  pa_tipoprenda      VARCHAR(100),
    IN  pa_cantidad        INT,
    IN  pa_colorreferencia VARCHAR(255),
    IN  pa_tenantid        VARCHAR(255),
    OUT pa_codigobd        INT,
    OUT pa_mensaje         VARCHAR(255)
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

    INSERT INTO tadetalleordenservicio (
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

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se pudo insertar la orden detalle, desde MySQL';
    END IF;

    COMMIT;

    SET pa_codigobd = 0;
    SET pa_mensaje  = 'Orden detalle insertada correctamente, desde MySQL';

    -- Devolver el registro insertado
    SELECT
        idDetalleOrden,
        ordenId,
        procesoId,
        tipoPrenda,
        cantidad,
        colorReferencia,
        tenantId
    FROM tadetalleordenservicio
    WHERE idDetalleOrden = pa_idordendetalle
      AND tenantId       = pa_tenantid;

END$$
DELIMITER ;