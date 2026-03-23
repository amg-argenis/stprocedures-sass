-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 23, 2026 at 01:11 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `washtrack`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_INSERTAR_ORDENSERVICIO` (IN `pa_idorden` VARCHAR(255), IN `pa_clienteid` VARCHAR(255), IN `pa_fechaingreso` VARCHAR(255), IN `pa_estado` VARCHAR(100), IN `pa_totalprendas` INT, IN `pa_observaciones` VARCHAR(255), IN `pa_fechaentrega` VARCHAR(255), IN `pa_tenantid` VARCHAR(255), OUT `pa_codigobd` INT, OUT `pa_mensaje` VARCHAR(255), OUT `po_idorden` VARCHAR(255), OUT `po_clienteid` VARCHAR(255), OUT `po_folio` VARCHAR(100), OUT `po_fechaingreso` VARCHAR(255), OUT `po_estado` VARCHAR(100), OUT `po_totalprendas` INT, OUT `po_observaciones` VARCHAR(255), OUT `po_createdat` VARCHAR(255), OUT `po_tenantid` VARCHAR(255), OUT `po_fechaentrega` VARCHAR(100))   BEGIN
    DECLARE v_sqlstate      CHAR(5);
    DECLARE v_error_message TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate      = RETURNED_SQLSTATE,
            v_error_message = MESSAGE_TEXT;
        SET pa_codigobd      = -1;
        SET pa_mensaje       = CONCAT('Error desde MySQL: ', v_sqlstate, ' - ', v_error_message);
        SET po_idorden       = NULL;
        SET po_clienteid     = NULL;
        SET po_folio         = NULL;
        SET po_fechaingreso  = NULL;
        SET po_estado        = NULL;
        SET po_totalprendas  = NULL;
        SET po_observaciones = NULL;
        SET po_createdat     = NULL;
        SET po_tenantid      = NULL;
        SET po_fechaentrega  = NULL;
    END;

    START TRANSACTION;

    -- El folio lo genera el trigger automaticamente
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
        pa_fechaingreso,
        pa_estado,
        pa_totalprendas,
        pa_observaciones,
        NOW(),
        pa_tenantid,
        pa_fechaentrega
    );

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se pudo insertar la orden de servicio, desde MySQL';
    END IF;

    -- Recuperar campos incluyendo el folio generado por el trigger
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
    INTO
        po_idorden,
        po_clienteid,
        po_folio,
        po_fechaingreso,
        po_estado,
        po_totalprendas,
        po_observaciones,
        po_createdat,
        po_tenantid,
        po_fechaentrega
    FROM taordenservicio
    WHERE idOrden = pa_idorden;

    COMMIT;
    SET pa_codigobd = 0;
    SET pa_mensaje  = 'Orden de servicio insertada correctamente, desde MySQL';

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `folio_sequence`
--

CREATE TABLE `folio_sequence` (
  `tenantId` char(36) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `valor` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `folio_sequence`
--

INSERT INTO `folio_sequence` (`tenantId`, `nombre`, `valor`) VALUES
('a051a168-fa2a-11f0-aab7-e66133dbb0de', 'ORDEN_SERVICIO', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tacliente`
--

CREATE TABLE `tacliente` (
  `idCliente` char(36) NOT NULL,
  `tenantId` char(36) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `contacto` varchar(150) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `creditoHabilitado` tinyint(1) NOT NULL DEFAULT 0,
  `limiteCredito` decimal(12,2) DEFAULT 0.00,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tacliente`
--

INSERT INTO `tacliente` (`idCliente`, `tenantId`, `nombre`, `contacto`, `telefono`, `email`, `creditoHabilitado`, `limiteCredito`, `activo`, `createdAt`) VALUES
('c1000001-0000-0000-0000-000000000001', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Uniformes Garza SA de CV', 'Roberto Garza', '8112345678', 'rgarza@uniformesgarza.com', 1, 15000.00, 1, '2026-03-22 23:35:00'),
('c1000001-0000-0000-0000-000000000002', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Hotel Presidente Monterrey', 'Laura Mendez', '8198765432', 'lmendez@hotelpresidente.com', 1, 30000.00, 1, '2026-03-22 23:35:00'),
('c1000001-0000-0000-0000-000000000003', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Clinica Santa Maria', 'Dr. Pedro Salas', '8134567890', 'psalas@clinicasantamaria.com', 1, 20000.00, 1, '2026-03-22 23:35:00'),
('c1000001-0000-0000-0000-000000000004', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Restaurante La Hacienda', 'Ana Torres', '8156781234', 'atorres@lahacienda.com', 0, 0.00, 1, '2026-03-22 23:35:00'),
('c1000001-0000-0000-0000-000000000005', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Grupo Industrial Noreste', 'Carlos Vega', '8167894321', 'cvega@gruponoreste.com', 1, 50000.00, 1, '2026-03-22 23:35:00');

-- --------------------------------------------------------

--
-- Table structure for table `tadetalleordenservicio`
--

CREATE TABLE `tadetalleordenservicio` (
  `idDetalleOrden` char(36) NOT NULL,
  `tenantId` char(36) NOT NULL,
  `ordenId` char(36) NOT NULL,
  `procesoId` char(36) NOT NULL,
  `tipoPrenda` varchar(100) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `colorReferencia` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tadetalleordenservicio`
--

INSERT INTO `tadetalleordenservicio` (`idDetalleOrden`, `tenantId`, `ordenId`, `procesoId`, `tipoPrenda`, `cantidad`, `colorReferencia`) VALUES
('d0000001-0000-0000-0000-000000000001', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000001', 'p0000001-0000-0000-0000-000000000002', 'Camisa de trabajo', 120, 'Azul rey'),
('d0000001-0000-0000-0000-000000000002', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000001', 'p0000001-0000-0000-0000-000000000003', 'Pantalon de trabajo', 80, 'Azul marino'),
('d0000001-0000-0000-0000-000000000003', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000002', 'p0000001-0000-0000-0000-000000000002', 'Sabana king size', 200, 'Blanco'),
('d0000001-0000-0000-0000-000000000004', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000002', 'p0000001-0000-0000-0000-000000000003', 'Toalla de bano', 150, 'Blanco'),
('d0000001-0000-0000-0000-000000000005', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000003', 'p0000001-0000-0000-0000-000000000001', 'Bata medica', 100, 'Blanco'),
('d0000001-0000-0000-0000-000000000006', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000003', 'p0000001-0000-0000-0000-000000000004', 'Ropa quirurgica', 80, 'Verde quirurgico'),
('d0000001-0000-0000-0000-000000000007', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000004', 'p0000001-0000-0000-0000-000000000002', 'Mantel rectangular', 70, 'Blanco marfil'),
('d0000001-0000-0000-0000-000000000008', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000004', 'p0000001-0000-0000-0000-000000000003', 'Servilleta de tela', 50, 'Blanco marfil'),
('d0000001-0000-0000-0000-000000000009', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000005', 'p0000001-0000-0000-0000-000000000002', 'Overol industrial', 300, 'Gris Oxford'),
('d0000001-0000-0000-0000-000000000010', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000005', 'p0000001-0000-0000-0000-000000000004', 'Guante industrial', 200, 'Negro'),
('d0000001-0000-0000-0000-000000000011', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000006', 'p0000001-0000-0000-0000-000000000001', 'Camisa administrativa', 90, 'Blanco'),
('d0000001-0000-0000-0000-000000000012', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000006', 'p0000001-0000-0000-0000-000000000003', 'Pantalon administrativo', 60, 'Negro'),
('d0000001-0000-0000-0000-000000000013', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000007', 'p0000001-0000-0000-0000-000000000002', 'Sabana king size', 250, 'Blanco'),
('d0000001-0000-0000-0000-000000000014', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000007', 'p0000001-0000-0000-0000-000000000003', 'Funda de almohada', 150, 'Blanco'),
('d0000001-0000-0000-0000-000000000015', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000008', 'p0000001-0000-0000-0000-000000000001', 'Uniforme enfermeria', 50, 'Blanco'),
('d0000001-0000-0000-0000-000000000016', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000008', 'p0000001-0000-0000-0000-000000000003', 'Cofia enfermeria', 40, 'Blanco'),
('d0000001-0000-0000-0000-000000000017', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000009', 'p0000001-0000-0000-0000-000000000002', 'Delantal de cocina', 45, 'Negro'),
('d0000001-0000-0000-0000-000000000018', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000009', 'p0000001-0000-0000-0000-000000000003', 'Gorro de cocina', 30, 'Blanco'),
('d0000001-0000-0000-0000-000000000019', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000010', 'p0000001-0000-0000-0000-000000000002', 'Overol industrial', 350, 'Azul marino'),
('d0000001-0000-0000-0000-000000000020', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'or000001-0000-0000-0000-000000000010', 'p0000001-0000-0000-0000-000000000005', 'Pantalon industrial', 250, 'Azul marino');

-- --------------------------------------------------------

--
-- Table structure for table `taentregas`
--

CREATE TABLE `taentregas` (
  `idEntrega` char(36) NOT NULL,
  `tenantId` char(36) NOT NULL,
  `ordenId` char(36) NOT NULL,
  `fechaEntrega` date NOT NULL,
  `totalEntregado` int(11) NOT NULL,
  `conformidadCliente` tinyint(1) NOT NULL,
  `observaciones` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tafacturainterna`
--

CREATE TABLE `tafacturainterna` (
  `idFacturaInterna` char(36) NOT NULL,
  `tenantId` char(36) NOT NULL,
  `ordenId` char(36) NOT NULL,
  `montoTotal` decimal(12,2) NOT NULL,
  `montoPagado` decimal(12,2) NOT NULL DEFAULT 0.00,
  `saldo` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PARCIAL','PAGADO') NOT NULL,
  `fechaVencimiento` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `taordenservicio`
--

CREATE TABLE `taordenservicio` (
  `idOrden` char(36) NOT NULL,
  `tenantId` char(36) NOT NULL,
  `clienteId` char(36) NOT NULL,
  `folio` varchar(50) NOT NULL,
  `fechaIngreso` date NOT NULL,
  `fechaEntrega` date DEFAULT NULL,
  `estado` varchar(50) NOT NULL,
  `totalPrendas` int(11) NOT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `taordenservicio`
--

INSERT INTO `taordenservicio` (`idOrden`, `tenantId`, `clienteId`, `folio`, `fechaIngreso`, `fechaEntrega`, `estado`, `totalPrendas`, `observaciones`, `createdAt`) VALUES
('or000001-0000-0000-0000-000000000001', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000001', 'OR-0000000001', '2026-03-01', '2026-03-05', 'ENTREGADO', 200, 'Uniformes de trabajo area produccion', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000002', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000002', 'OR-0000000002', '2026-03-02', '2026-03-06', 'ENTREGADO', 350, 'Sabanas y toallas habitaciones piso 3 y 4', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000003', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000003', 'OR-0000000003', '2026-03-03', '2026-03-07', 'LISTO', 180, 'Batas medicas y ropa quirurgica', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000004', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000004', 'OR-0000000004', '2026-03-04', '2026-03-08', 'EN_PROCESO', 120, 'Manteles y servilletas evento fin de semana', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000005', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000005', 'OR-0000000005', '2026-03-05', '2026-03-10', 'EN_PROCESO', 500, 'Overoles y guantes area soldadura', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000006', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000001', 'OR-0000000006', '2026-03-08', '2026-03-12', 'RECIBIDO', 150, 'Uniformes administrativos quincena', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000007', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000002', 'OR-0000000007', '2026-03-10', '2026-03-14', 'RECIBIDO', 400, 'Sabanas king size temporada alta', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000008', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000003', 'OR-0000000008', '2026-03-12', NULL, 'RECIBIDO', 90, 'Uniformes enfermeria turno nocturno', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000009', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000004', 'OR-0000000009', '2026-03-15', NULL, 'RECIBIDO', 75, 'Delantales y gorros cocina', '2026-03-22 23:35:29'),
('or000001-0000-0000-0000-000000000010', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'c1000001-0000-0000-0000-000000000005', 'OR-0000000010', '2026-03-18', NULL, 'RECIBIDO', 600, 'Ropa industrial lote marzo', '2026-03-22 23:35:29');

--
-- Triggers `taordenservicio`
--
DELIMITER $$
CREATE TRIGGER `trg_folio_orden_servicio` BEFORE INSERT ON `taordenservicio` FOR EACH ROW BEGIN
    DECLARE next_folio BIGINT;

    UPDATE folio_sequence
    SET valor = valor + 1
    WHERE nombre   = 'ORDEN_SERVICIO'
      AND tenantId = NEW.tenantId;

    SELECT valor
    INTO next_folio
    FROM folio_sequence
    WHERE nombre   = 'ORDEN_SERVICIO'
      AND tenantId = NEW.tenantId;

    SET NEW.folio = CONCAT('ORD-', LPAD(next_folio, 9, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tapagos`
--

CREATE TABLE `tapagos` (
  `idPago` char(36) NOT NULL,
  `tenantId` char(36) NOT NULL,
  `facturaId` char(36) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `fechaPago` date NOT NULL,
  `metodo` enum('EFECTIVO','TRANSFERENCIA') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `taprocesos`
--

CREATE TABLE `taprocesos` (
  `idProceso` char(36) NOT NULL,
  `tenantId` char(36) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `precioUnitario` decimal(10,2) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `taprocesos`
--

INSERT INTO `taprocesos` (`idProceso`, `tenantId`, `nombre`, `descripcion`, `precioUnitario`, `activo`) VALUES
('p0000001-0000-0000-0000-000000000001', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Lavado en seco', 'Lavado sin agua con solventes', 25.00, 1),
('p0000001-0000-0000-0000-000000000002', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Lavado industrial', 'Lavado con maquinaria de alta capacidad', 12.00, 1),
('p0000001-0000-0000-0000-000000000003', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Planchado', 'Planchado a vapor profesional', 8.00, 1),
('p0000001-0000-0000-0000-000000000004', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Desmanchado', 'Tratamiento de manchas especiales', 15.00, 1),
('p0000001-0000-0000-0000-000000000005', 'a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Barrido natural', 'Proceso de barrido con tono natural', 18.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tatenant`
--

CREATE TABLE `tatenant` (
  `idTenant` char(36) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tatenant`
--

INSERT INTO `tatenant` (`idTenant`, `nombre`, `activo`, `createdAt`) VALUES
('a051a168-fa2a-11f0-aab7-e66133dbb0de', 'Lavanderia El Blanco SA de CV', 1, '2026-03-22 23:34:45');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `folio_sequence`
--
ALTER TABLE `folio_sequence`
  ADD PRIMARY KEY (`tenantId`,`nombre`);

--
-- Indexes for table `tacliente`
--
ALTER TABLE `tacliente`
  ADD PRIMARY KEY (`idCliente`),
  ADD KEY `fk_cliente_tenant` (`tenantId`);

--
-- Indexes for table `tadetalleordenservicio`
--
ALTER TABLE `tadetalleordenservicio`
  ADD PRIMARY KEY (`idDetalleOrden`),
  ADD KEY `fk_detalle_tenant` (`tenantId`),
  ADD KEY `fk_detalle_orden` (`ordenId`),
  ADD KEY `fk_detalle_proceso` (`procesoId`);

--
-- Indexes for table `taentregas`
--
ALTER TABLE `taentregas`
  ADD PRIMARY KEY (`idEntrega`),
  ADD UNIQUE KEY `uk_entrega_orden` (`ordenId`),
  ADD KEY `fk_entrega_tenant` (`tenantId`);

--
-- Indexes for table `tafacturainterna`
--
ALTER TABLE `tafacturainterna`
  ADD PRIMARY KEY (`idFacturaInterna`),
  ADD UNIQUE KEY `uk_factura_orden` (`ordenId`),
  ADD KEY `fk_factura_tenant` (`tenantId`);

--
-- Indexes for table `taordenservicio`
--
ALTER TABLE `taordenservicio`
  ADD PRIMARY KEY (`idOrden`),
  ADD UNIQUE KEY `folio` (`folio`),
  ADD KEY `fk_orden_tenant` (`tenantId`),
  ADD KEY `fk_orden_cliente` (`clienteId`),
  ADD KEY `idx_orden_id_folio` (`idOrden`,`folio`);

--
-- Indexes for table `tapagos`
--
ALTER TABLE `tapagos`
  ADD PRIMARY KEY (`idPago`),
  ADD KEY `fk_pago_tenant` (`tenantId`),
  ADD KEY `fk_pago_factura` (`facturaId`);

--
-- Indexes for table `taprocesos`
--
ALTER TABLE `taprocesos`
  ADD PRIMARY KEY (`idProceso`),
  ADD KEY `fk_proceso_tenant` (`tenantId`);

--
-- Indexes for table `tatenant`
--
ALTER TABLE `tatenant`
  ADD PRIMARY KEY (`idTenant`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tacliente`
--
ALTER TABLE `tacliente`
  ADD CONSTRAINT `fk_cliente_tenant` FOREIGN KEY (`tenantId`) REFERENCES `tatenant` (`idTenant`);

--
-- Constraints for table `tadetalleordenservicio`
--
ALTER TABLE `tadetalleordenservicio`
  ADD CONSTRAINT `fk_detalle_orden` FOREIGN KEY (`ordenId`) REFERENCES `taordenservicio` (`idOrden`),
  ADD CONSTRAINT `fk_detalle_proceso` FOREIGN KEY (`procesoId`) REFERENCES `taprocesos` (`idProceso`),
  ADD CONSTRAINT `fk_detalle_tenant` FOREIGN KEY (`tenantId`) REFERENCES `tatenant` (`idTenant`);

--
-- Constraints for table `taentregas`
--
ALTER TABLE `taentregas`
  ADD CONSTRAINT `fk_entrega_orden` FOREIGN KEY (`ordenId`) REFERENCES `taordenservicio` (`idOrden`),
  ADD CONSTRAINT `fk_entrega_tenant` FOREIGN KEY (`tenantId`) REFERENCES `tatenant` (`idTenant`);

--
-- Constraints for table `tafacturainterna`
--
ALTER TABLE `tafacturainterna`
  ADD CONSTRAINT `fk_factura_orden` FOREIGN KEY (`ordenId`) REFERENCES `taordenservicio` (`idOrden`),
  ADD CONSTRAINT `fk_factura_tenant` FOREIGN KEY (`tenantId`) REFERENCES `tatenant` (`idTenant`);

--
-- Constraints for table `taordenservicio`
--
ALTER TABLE `taordenservicio`
  ADD CONSTRAINT `fk_orden_cliente` FOREIGN KEY (`clienteId`) REFERENCES `tacliente` (`idCliente`),
  ADD CONSTRAINT `fk_orden_tenant` FOREIGN KEY (`tenantId`) REFERENCES `tatenant` (`idTenant`);

--
-- Constraints for table `tapagos`
--
ALTER TABLE `tapagos`
  ADD CONSTRAINT `fk_pago_factura` FOREIGN KEY (`facturaId`) REFERENCES `tafacturainterna` (`idFacturaInterna`),
  ADD CONSTRAINT `fk_pago_tenant` FOREIGN KEY (`tenantId`) REFERENCES `tatenant` (`idTenant`);

--
-- Constraints for table `taprocesos`
--
ALTER TABLE `taprocesos`
  ADD CONSTRAINT `fk_proceso_tenant` FOREIGN KEY (`tenantId`) REFERENCES `tatenant` (`idTenant`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
