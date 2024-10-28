DELIMITER / /
-- ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
CREATE EVENT ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO ReportesMensuales (Fecha_reporte, Ventas_Totales,Ingresos_Totales)
    SELECT
        LAST_DAY(CURDATE()) AS Fecha_reporte,
        SUM(InvoiceId) AS Ventas_Totales,
        SUM(Total)AS Ingresos_Totales
    FROM Invoice
    WHERE MONTH(InvoiceDate) = MONTH(CURDATE()) AND YEAR(InvoiceDate) = YEAR(CURDATE());
END//

-- ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.


-- AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.
CREATE EVENT AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
DO
BEGIN
    INSERT INTO Logs (Fecha, Detalles, Tabla_Afectada, ID_Referencia)
    SELECT
        NOW() AS Fecha,
        CONCAT('Álbum sin ventas en el último año: ', a.Title) AS Detalles,
        'Album' AS Tabla_Afectada,
        a.AlbumId AS ID_Referencia
    FROM Album a
    JOIN Track t ON a.AlbumId = t.AlbumId
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.InvoiceDate IS NULL OR i.InvoiceDate < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END//

-- LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.
CREATE EVENT LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
DO
BEGIN
    DELETE FROM Logs
    WHERE Fecha < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END//

-- ActualizarListaDeGenerosPopulares: Actualiza la lista de géneros más vendidos al final de cada mes.
CREATE EVENT ActualizarListaDeGenerosPopulares
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO GenerosPopulares (GeneroId, TotalVentas)
    SELECT
        t.GenreId,
        COUNT(il.InvoiceLineId) AS TotalVentas
    FROM Track t
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE MONTH(i.InvoiceDate) = MONTH(CURDATE()) AND YEAR(i.InvoiceDate) = YEAR(CURDATE())
    GROUP BY t.GenreId
    ORDER BY TotalVentas DESC;
END//
DELIMITER;


