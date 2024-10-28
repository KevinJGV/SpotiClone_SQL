DELIMITER //
-- TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico.
CREATE FUNCTION TotalGastoCliente(pClienteID INT,pYear YEAR)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE Total_ DECIMAL(9,2);
    SELECT
        SUM(Total) INTO Total_
    FROM
        Invoice
    WHERE
        CustomerId = pClienteID AND YEAR(InvoiceDate) = pYear;
    RETURN Total_;
END//

-- PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.
CREATE FUNCTION PromedioPrecioPorAlbum(pAlbumID INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE Prom_ DECIMAL(9,2);
    SELECT
        AVG(T.UnitPrice) INTO Prom_
    FROM
        Track T
    WHERE
        AlbumId = pAlbumID;
    RETURN Prom_;
END//

-- DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.
CREATE FUNCTION DuracionTotalPorGenero(pGeneroID INT)
RETURNS BIGINT
READS SQL DATA
BEGIN
    DECLARE Total_ BIGINT;
    SELECT
        SUM(Milliseconds) INTO Total_
    FROM
        Track
    WHERE
        GenreId =  pGeneroID;
    RETURN Total_;
END//

-- DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
CREATE FUNCTION DescuentoPorFrecuencia(pClienteID INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE DCTO_ INT DEFAULT 0;
    SELECT
        CASE
            WHEN COUNT(InvoiceId) >= 30 AND TIMESTAMPDIFF(YEAR, MIN(InvoiceDate), CURDATE()) >= 1 THEN 30
            WHEN COUNT(InvoiceId) >= 20 AND TIMESTAMPDIFF(YEAR, MIN(InvoiceDate), CURDATE()) >= 1 THEN 20
            WHEN COUNT(InvoiceId) >= 10 AND TIMESTAMPDIFF(YEAR, MIN(InvoiceDate), CURDATE()) >= 1 THEN 10
            ELSE 0
        END
        INTO DCTO_
    FROM
        Invoice
    WHERE
        CustomerId = pClienteID;
    RETURN DCTO_;
END//

-- VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.
CREATE FUNCTION VerificarClienteVIP(pClienteID INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE Status_ BOOL;
    SELECT
        CASE
            WHEN SUM(Total) >= 8 AND TIMESTAMPDIFF(YEAR, MIN(InvoiceDate), CURDATE()) >= 1 THEN TRUE
            ELSE FALSE
        END
        INTO Status_
    FROM
        Invoice
    WHERE
        CustomerId = pClienteID;
    RETURN Status_;
END//
DELIMITER ;