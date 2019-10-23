--Ejercicios de Querys para SQL Server probados con AZURE SQL SERVER

--Crear base de datos
IF NOT EXISTS (
   SELECT name
   FROM sys.databases
   WHERE name = N'TutorialDB'
)
CREATE DATABASE [TutorialDB]
GO

ALTER DATABASE [TutorialDB] SET QUERY_STORE=ON
GO

-- crear una nueva tabla llamada clientes en el esquema dbo
--Eliminar la tabla si esta en realidad existe
IF OBJECT_ID('dbo.Clientes','U')IS NOT NULL
DROP TABLE dbo.Clientes
GO
--crear la tabla en el esquema especifico
CREATE TABLE dbo.Clientes
(
    ClienteId INT NOT NULL PRIMARY KEY, 
    Nombre [NVARCHAR](50) NOT NULL,
    Direccion [NVARCHAR](50) NOT NULL,
    Email [NVARCHAR](50) NOT NULL
);
GO

--Insertar registro en tabla clientes
INSERT INTO dbo.Clientes
     ([ClienteId],[Nombre],[Direccion],[Email])
VALUES
     (1, N'Richard',N'Mexico',N''),
     (2, N'Rodrigo',N'Australia',N'rodGM_91@gmail.com'),
     (3, N'Diana',N'Canada',N'Dian_20@hotmail.com'),
     (4, N'Marilu', N'Italy',N'lulu_64@live.com')
GO  


select * from dbo.Clientes;

--SELECT * FROM sys.firewall_rules ORDER BY name;

--Ver listas de base de datos
USE TutorialDB;  
GO  
SELECT name, database_id, create_date  
FROM sys.databases ;  
GO
  
--ver propiedades
--Si devuelva 1 la opcion esta establedia en ON
-- 0 la opcion esta establecida en ON
SELECT DATABASEPROPERTYEX('TutorialDB', 'IsAutoShrink');


--Mostrar la informacion del espacio ocupado por los datos y el resgitro de la BD
-- mendiante una consulta a sys.database_file
USE TutorialDB;
GO
select file_id, name, type_desc, physical_name, size, max_size
FROM sys.database_files;
GO

--crear table ventas
IF OBJECT_ID ('dbo.Producto','U') IS NOT NULL
DROP TABLE dbo.Producto
GO
CREATE TABLE dbo.Producto
(
   productoID INT IDENTITY(1,1) PRIMARY KEY,
   nombreProducto [NVARCHAR](50) NOT NULL,
   stock [NVARCHAR](50)NOT NULL,
   precioUnit INT NOT NULL,
   preciVenta INT NOT NULL
);
GO

ALTER TABLE dbo.Producto
ALTER COLUMN stock int NOT NULL;


--DOS FORMAS DE INSERT 
--1.-
--select * from dbo.Producto;

INSERT INTO dbo.Producto
([nombreProducto],[stock],[preciVenta],[precioUnit])
SELECT N'LECHE_LALA',250,50,5 UNION ALL
SELECT N'COCA-COLA',300,20,3 UNION ALL
SELECT N'PAN_BIMBO',100,40,7 UNION ALL
SELECT N'Zucariatas',150,40,5 UNION ALL
SELECT N'Crema',320,35,9 UNION ALL
SELECT N'Jumex',145,14,1 UNION ALL
SELECT N'Agua',252,5,1 UNION ALL
SELECT N'Panales',340,50,8 UNION ALL
SELECT N'baterias',1234,5,1
GO

-- 2.- Esta  es la forma corta

INSERT INTO dbo.Clientes
     ([ClienteId],[Nombre],[Direccion],[Email])
VALUES
     (7, N'Kobe',N'Mexico',N'Kobe_io34@hotmail.com'),
     (8, N'Adrian',N'Australia',N'Adbety_1@gmail.com'),
     (9, N'Maria',N'Canada',N'Mari_a20@hotmail.com'),
     (10, N'Carla', N'Italy',N'Car_99@live.com')
GO  

--seleciiona todas tabla clientes ordenadas por nombre
select c.* From Clientes As c
ORDER BY Nombre;


--Cambiar el TIPO de dato de la columna email
ALTER TABLE dbo.Clientes
ALTER COLUMN email [NVARCHAR](50) NULL;

SELECT Nombre, Direccion, email AS correo 
from Clientes
where Direccion='Mexico' 
AND email!=''   --equivalentre a not null para NVACHAR
--IS NOT null es paradatos numerios ? 
ORDER BY Direccion;

--Usar select con encabezados de columnas y calculos
SELECT nombreProducto, precioUnit AS Unitario, preciVenta  as pVenta 
from dbo.Producto
ORDER BY preciVenta;

--Lista todos los paises unicos que hay en la lista
SELECT DISTINCT Direccion
FROM Clientes
ORDER BY Direccion;

-- GROUO BY bysca la cantidad de todas las ventas de cada dia
SELECT nombreProducto, SUM(preciVenta) AS VentasTotales
FROM Producto
GROUP BY nombreProducto
ORDER BY nombreProducto;

--having
--se usa para acortar resultados
SELECT  precioUnit , SUM(preciVenta) AS TotalesS
FROM Producto
GROUP BY precioUnit
HAVING  precioUnit < 8
ORDER BY precioUnit; 

--Usar TABLOCK y HOLDLOCK
BEGIN TRAN
SELECT COUNT(*)
FROM dbo.Clientes WITH (TABLOCK, HOLDLOCK);

--Combina todos los clientes con todos los productos
--ES UN JOINN NORMAL
SELECT c.ClienteId, p.nombreProducto AS Producto_nombre
FROM dbo.Clientes AS c
CROSS JOIN  Producto AS p 
ORDER BY c.ClienteId, p.nombreProducto;




