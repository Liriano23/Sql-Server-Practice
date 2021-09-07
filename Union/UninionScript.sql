--Uninion scripts

USE CursoSqlServer

IF OBJECT_ID ('alumnos') IS NOT NULL
	DROP TABLE ALUMNOS
GO

IF OBJECT_ID ('Profesores') IS NOT NULL
	DROP TABLE Profesores;
GO

create table profesores(
  documento varchar(8) not null,
  nombre varchar (30),
  domicilio varchar(30),
  primary key(documento)
);
create table alumnos(
  documento varchar(8) not null,
  nombre varchar (30),
  domicilio varchar(30),
  primary key(documento)
);
GO

insert into alumnos values('30000000','Juan Perez','Colon 123');
insert into alumnos values('30111111','Marta Morales','Caseros 222');
insert into alumnos values('30222222','Laura Torres','San Martin 987');
insert into alumnos values('30333333','Mariano Juarez','Avellaneda 34');
insert into alumnos values('23333333','Federico Lopez','Colon 987');
insert into profesores values('22222222','Susana Molina','Sucre 345');
insert into profesores values('23333333','Federico Lopez','Colon 987');
GO

--Nombre y domicilio de profesores y alumnos
Select nombre, domicilio from alumnos
union 
select nombre, domicilio  from profesores

-- Ordenamos por domicilio:
select nombre, domicilio from alumnos
  union
    select nombre, domicilio from profesores
  order by domicilio;

--Exercise 

if object_id('Proveedores') is not null 
	drop table proveedores;
if OBJECT_ID ('Clientes') is not null
	drop table clientes;
if OBJECT_ID ('Empleados') is not null
	drop table empleados;
GO

create table proveedores(
  codigo int identity,
  nombre varchar (30),
  domicilio varchar(30),
  primary key(codigo)
 );
 GO

 create table clientes(
  codigo int identity,
  nombre varchar (30),
  domicilio varchar(30),
  primary key(codigo)
 );
 create table empleados(
  documento char(8) not null,
  nombre varchar(20),
  apellido varchar(20),
  domicilio varchar(30),
  primary key(documento)
 );
GO

--Inserts
insert into proveedores values('Bebida cola','Colon 123');
insert into proveedores values('Carnes Unica','Caseros 222');
insert into proveedores values('Lacteos Blanca','San Martin 987');
insert into clientes values('Supermercado Lopez','Avellaneda 34');
insert into clientes values('Almacen Anita','Colon 987');
insert into clientes values('Garcia Juan','Sucre 345');
insert into empleados values('23333333','Federico','Lopez','Colon 987');
insert into empleados values('28888888','Ana','Marquez','Sucre 333');
insert into empleados values('30111111','Luis','Perez','Caseros 956');

--4- El supermercado quiere enviar una tarjeta de salutación a todos los proveedores, clientes y 
--empleados y necesita el nombre y domicilio de todos ellos. Emplee el operador "union" para obtener 
--dicha información de las tres tablas.

select nombre, domicilio from proveedores
	union 
		select nombre, domicilio from clientes
			union
				select nombre, domicilio from empleados

--5- Agregue una columna con un literal para indicar si es un proveedor, un cliente o un 
--empleado y ordene por dicha columna.

select nombre, domicilio, 'Proveedor' as Categoria from proveedores
	union 
		select nombre, domicilio, 'Clientes' from clientes
			union
				select nombre, domicilio, 'Empleados' from empleados