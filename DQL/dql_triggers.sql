DELIMITER / /
-- ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.
CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER INSERT ON Invoice FOR EACH ROW
BEGIN
    DECLARE Contador INT;
    DECLARE EmployeeId_ INT;

    SELECT
        C.SupportRepId INTO EmployeeId_
    FROM
        Customer C
        JOIN Invoice I ON C.CustomerId = I.CustomerId
    WHERE
        NEW.InvoiceId = InvoiceId;

    SELECT
        COUNT(I.InvoiceId) INTO Contador
    FROM
        Customer C
        JOIN Invoice I ON C.CustomerId = I.CustomerId
    WHERE
        EmployeeId_ = C.SupportRepId;
    
    UPDATE VentasXEmpleado SET Total = Contador WHERE EmployeeId = EmployeeId_;
END//
-- AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
CREATE TRIGGER AuditarActualizacionCliente
AFTER UPDATE ON Customer FOR EACH ROW
BEGIN
    INSERT INTO Logs (Fecha,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    (CURDATE(),'Datos de Cliente actualizados', 'Customer', OLD.CustomerId);
END//

-- RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.
CREATE TRIGGER RegistrarHistorialPrecioCancion
AFTER UPDATE ON Track FOR EACH ROW
BEGIN
    IF OLD.UnitPrice <> NEW.UnitPrice THEN
        INSERT INTO Logs (Fecha,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        (CURDATE(),CONCAT('Precio Track actualizado: Antes - ', OLD.UnitPrice,',Ahora - ', NEW.UnitPrice), 'Track', OLD.TrackId);
    END IF;
END//

-- NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.
CREATE TRIGGER NotificarCancelacionVenta
BEFORE DELETE ON Invoice FOR EACH ROW
BEGIN
    INSERT INTO Logs (Fecha,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    (CURDATE(),'Venta Eliminada', 'Invoice', OLD.InvoiceId);
END//

-- RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.

DELIMITER;