DELIMITER $$
DROP PROCEDURE IF EXISTS SP_DASHBOARD$$

CREATE PROCEDURE SP_DASHBOARD(
    IN  pa_tenantid  CHAR(36),
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
        SET pa_mensaje  = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
    END;

    SET pa_codigobd = 0;
    SET pa_mensaje  = 'Consulta de dashboard correcta, desde MySQL';

    SELECT
        -- Ordenes activas
        (SELECT COUNT(idOrden)
         FROM taordenservicio
         WHERE tenantId = pa_tenantid
           AND estado NOT IN ('ENTREGADO', 'ELIMINADO')) AS ordenesActivas,

        -- Total clientes activos
        (SELECT COUNT(idCliente)
         FROM tacliente
         WHERE tenantId = pa_tenantid
           AND activo = TRUE) AS clientesActivos,

        -- Total entregas del mes actual
        (SELECT COUNT(idEntrega)
         FROM taentregas
         WHERE tenantId = pa_tenantid
           AND estado  <> 'ELIMINADO'
           AND MONTH(fechaCreacion) = MONTH(NOW())
           AND YEAR(fechaCreacion)  = YEAR(NOW())) AS entregasMes,

        -- Total prendas en proceso
        (SELECT COALESCE(SUM(totalPrendas), 0)
         FROM taordenservicio
         WHERE tenantId = pa_tenantid
           AND estado   = 'EN_PROCESO') AS prendasEnProceso,

        -- Ordenes listas para entregar
        (SELECT COUNT(idOrden)
         FROM taordenservicio
         WHERE tenantId = pa_tenantid
           AND estado   = 'LISTO') AS ordenesListas,

        -- Ordenes entregadas este mes
        (SELECT COUNT(idOrden)
         FROM taordenservicio
         WHERE tenantId = pa_tenantid
           AND estado   = 'ENTREGADO'
           AND MONTH(createdAt) = MONTH(NOW())
           AND YEAR(createdAt)  = YEAR(NOW())) AS ordenesEntregadasMes;

END$$
DELIMITER ;
