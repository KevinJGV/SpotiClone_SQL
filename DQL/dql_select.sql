-- Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.
SELECT
    C.SupportRepId AS EmployeeId,
    COUNT(I.InvoiceId) AS TotalV
FROM
    Invoice I
    JOIN Customer C ON I.CustomerId = C.CustomerId
GROUP BY
    EmployeeId
ORDER BY
    TotalV DESC
LIMIT
    1;

-- Lista los cinco artistas con más canciones vendidas en el último año.
SELECT
    A.ArtistId,
    A.Name AS Artist,
    SUM(IL.Quantity) AS Total
FROM
    Artist A
    JOIN Album AL ON A.ArtistId = AL.ArtistId
    JOIN Track T ON AL.AlbumId = T.AlbumId
    JOIN InvoiceLine IL ON T.TrackId = IL.TrackId
    JOIN Invoice I ON IL.InvoiceId = I.InvoiceId
WHERE
    I.InvoiceDate BETWEEN DATE_SUB(CURDATE(),INTERVAL 1 YEAR) AND CURDATE()
GROUP BY
    A.ArtistId
ORDER BY
    Total DESC
LIMIT 5;

-- Calcula el número total de clientes que realizaron compras por cada género en un mes específico.
SELECT 
    g.Name AS Genero,
    COUNT(DISTINCT i.CustomerId) AS TotalClientes
FROM 
    Genre g
JOIN 
    Track t ON g.GenreId = t.GenreId
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
JOIN 
    Invoice i ON il.InvoiceId = i.InvoiceId
WHERE 
    MONTH(i.InvoiceDate) = 01 AND YEAR(i.InvoiceDate) = 2024
GROUP BY 
    g.Name;

-- Encuentra a los clientes que han comprado todas las canciones de un mismo álbum.
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    a.Title AS AlbumComprado
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Album a ON t.AlbumId = a.AlbumId
GROUP BY 
    c.CustomerId, a.AlbumId
HAVING 
    COUNT(DISTINCT t.TrackId) = (SELECT COUNT(*) FROM Track WHERE AlbumId = a.AlbumId);

-- Lista los tres países con mayores ventas durante el último semestre.
SELECT 
    i.BillingCountry AS Pais,
    SUM(i.Total) AS TotalVentas
FROM 
    Invoice i
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    i.BillingCountry
ORDER BY 
    TotalVentas DESC
LIMIT 3;

-- Muestra los cinco géneros menos vendidos en el último año.
SELECT 
    g.Name AS Genero,
    COUNT(il.InvoiceLineId) AS TotalVentas
FROM 
    Genre g
JOIN 
    Track t ON g.GenreId = t.GenreId
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
JOIN 
    Invoice i ON il.InvoiceId = i.InvoiceId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    g.Name
ORDER BY 
    TotalVentas ASC
LIMIT 5;

-- Calcula el promedio de edad de los clientes al momento de su primera compra.
SELECT 
    AVG(TIMESTAMPDIFF(YEAR, e.BirthDate, MIN(i.InvoiceDate))) AS PromedioEdadPrimeraCompra
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    Employee e ON c.SupportRepId = e.EmployeeId
GROUP BY 
    c.CustomerId;

-- Encuentra los cinco empleados que realizaron más ventas de Rock.
SELECT 
    e.EmployeeId,
    e.FirstName,
    e.LastName,
    COUNT(il.InvoiceLineId) AS TotalVentasRock
FROM 
    Employee e
JOIN 
    Customer c ON e.EmployeeId = c.SupportRepId
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
WHERE 
    g.Name = 'Rock'
GROUP BY 
    e.EmployeeId
ORDER BY 
    TotalVentasRock DESC
LIMIT 5;

-- Genera un informe de los clientes con más compras recurrentes.
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    COUNT(i.InvoiceId) AS FrecuenciaCompras
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 
    c.CustomerId
HAVING 
    COUNT(i.InvoiceId) > 1
ORDER BY 
    FrecuenciaCompras DESC;

-- Calcula el precio promedio de venta por género.
SELECT 
    g.Name AS Genero,
    AVG(il.UnitPrice) AS PrecioPromedio
FROM 
    Genre g
JOIN 
    Track t ON g.GenreId = t.GenreId
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    g.Name;
    
-- Lista las cinco canciones más largas vendidas en el último año.
SELECT 
    t.Name AS Cancion,
    t.Milliseconds / 1000 AS DuracionSegundos
FROM 
    Track t
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
JOIN 
    Invoice i ON il.InvoiceId = i.InvoiceId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY 
    DuracionSegundos DESC
LIMIT 5;

-- Muestra los clientes que compraron más canciones de Jazz.
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    COUNT(il.InvoiceLineId) AS TotalJazzComprado
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
WHERE 
    g.Name = 'Jazz'
GROUP BY 
    c.CustomerId
ORDER BY 
    TotalJazzComprado DESC;

-- Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    SUM(t.Milliseconds / 60000) AS MinutosComprados
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN 
    Track t ON il.TrackId = t.TrackId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY 
    c.CustomerId;

-- Muestra el número de ventas diarias de canciones en cada mes del último trimestre.
SELECT 
    DATE(i.InvoiceDate) AS Fecha,
    COUNT(il.InvoiceLineId) AS VentasDiarias
FROM 
    Invoice i
JOIN 
    InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY 
    Fecha
ORDER BY 
    Fecha;

-- Calcula el total de ventas por cada vendedor en el último semestre.
SELECT 
    e.EmployeeId,
    e.FirstName,
    e.LastName,
    SUM(i.Total) AS TotalVentas
FROM 
    Employee e
JOIN 
    Customer c ON e.EmployeeId = c.SupportRepId
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    e.EmployeeId;

-- Encuentra el cliente que ha realizado la compra más cara en el último año.
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    MAX(i.Total) AS CompraMaxima
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    c.CustomerId
ORDER BY 
    CompraMaxima DESC
LIMIT 1;

-- Lista los cinco álbumes con más canciones vendidas durante los últimos tres meses.
SELECT 
    a.Title AS Album,
    COUNT(il.InvoiceLineId) AS CancionesVendidas
FROM 
    Album a
JOIN 
    Track t ON a.AlbumId = t.AlbumId
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
JOIN 
    Invoice i ON il.InvoiceId = i.InvoiceId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY 
    a.AlbumId
ORDER BY 
    CancionesVendidas DESC
LIMIT 5;

-- Obtén la cantidad de canciones vendidas por cada género en el último mes.
SELECT 
    g.Name AS Genero,
    COUNT(il.InvoiceLineId) AS TotalCancionesVendidas
FROM 
    Genre g
JOIN 
    Track t ON g.GenreId = t.GenreId
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
JOIN 
    Invoice i ON il.InvoiceId = i.InvoiceId
WHERE 
    i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY 
    g.Name;

-- Lista los clientes que no han comprado nada en el último año.
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName
FROM 
    Customer c
LEFT JOIN 
    Invoice i ON c.CustomerId = i.CustomerId AND i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE 
    i.InvoiceId IS NULL;