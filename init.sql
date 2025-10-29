-- Script de inicialización de la base de datos ProductosDB
-- Este script crea la base de datos y la tabla de productos con datos de ejemplo

-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ProductosDB')
BEGIN
    CREATE DATABASE ProductosDB;
END
GO

-- Usar la base de datos
USE ProductosDB;
GO

-- Crear la tabla de productos si no existe
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'productos')
BEGIN
    CREATE TABLE productos (
        id BIGINT PRIMARY KEY IDENTITY(1,1),
        nombre NVARCHAR(100) NOT NULL,
        descripcion NVARCHAR(500),
        precio DECIMAL(10,2) NOT NULL,
        stock INT NOT NULL,
        fecha_creacion DATETIME2 NOT NULL DEFAULT GETDATE(),
        fecha_actualizacion DATETIME2 NOT NULL DEFAULT GETDATE()
    );
END
GO

-- Insertar datos de ejemplo
IF NOT EXISTS (SELECT * FROM productos)
BEGIN
    INSERT INTO productos (nombre, descripcion, precio, stock, fecha_creacion, fecha_actualizacion)
    VALUES 
        ('Laptop Dell XPS 15', 'Laptop de alto rendimiento con procesador Intel i7', 1299.99, 15, GETDATE(), GETDATE()),
        ('Mouse Logitech MX Master', 'Mouse inalámbrico ergonómico para productividad', 99.99, 50, GETDATE(), GETDATE()),
        ('Teclado Mecánico Corsair', 'Teclado mecánico RGB para gaming', 149.99, 30, GETDATE(), GETDATE()),
        ('Monitor Samsung 27"', 'Monitor 4K UHD de 27 pulgadas', 399.99, 20, GETDATE(), GETDATE()),
        ('Webcam Logitech C920', 'Webcam Full HD 1080p con micrófono', 79.99, 45, GETDATE(), GETDATE()),
        ('Auriculares Sony WH-1000XM4', 'Auriculares con cancelación de ruido', 349.99, 25, GETDATE(), GETDATE()),
        ('Disco SSD Samsung 1TB', 'SSD NVMe de alta velocidad 1TB', 129.99, 60, GETDATE(), GETDATE()),
        ('Memoria RAM Corsair 16GB', 'Memoria DDR4 3200MHz 16GB', 89.99, 40, GETDATE(), GETDATE()),
        ('Tarjeta Gráfica RTX 3060', 'GPU NVIDIA GeForce RTX 3060 12GB', 499.99, 10, GETDATE(), GETDATE()),
        ('Fuente EVGA 750W', 'Fuente de poder modular 750W 80+ Gold', 119.99, 35, GETDATE(), GETDATE());
END
GO

-- Crear índices para mejorar el rendimiento
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_productos_nombre')
BEGIN
    CREATE INDEX IX_productos_nombre ON productos(nombre);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_productos_stock')
BEGIN
    CREATE INDEX IX_productos_stock ON productos(stock);
END
GO

-- Mostrar los datos insertados
SELECT * FROM productos;
GO

PRINT 'Base de datos ProductosDB inicializada correctamente';
GO
