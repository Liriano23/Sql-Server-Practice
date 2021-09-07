/* 
	Para crear un procedimiento almacenado
	 create procedure NOMBREPROCEDIMIENTO as INSTRUCCIONES;

	 Para diferenciar los procedimientos almacenados del sistema de los procedimientos almacenados locales use un prefijo diferente a "sp_" cuando les de el nombre.

	 Con las siguientes instrucciones creamos un procedimiento almacenado llamado 
	 "pa_libros_limite_stock" que muestra todos los libros de los cuales hay menos de 10 disponibles:

	 create proc pa_libros_limite_stock
	  as
	   select *from libros
	   where cantidad <=10;

	   or " create proc " 

	   Para ejecutar el procedimiento almacenado creado anteriormente tipeamos:
		exec pa_libros_limite_stock;


*/

use CursoSqlServer
GO

--Una empresa almacena los datos de sus empleados en una tabla llamada "empleados".
--1- Eliminamos la tabla, si existe y la creamos:

 if object_id('empleados') is not null
  drop table empleados;

 create table empleados(
  documento char(8),
  nombre varchar(20),
  apellido varchar(20),
  sueldo decimal(6,2),
  cantidadhijos tinyint,
  seccion varchar(20),
  primary key(documento)
 );

--2- Ingrese algunos registros:
 insert into empleados values('22222222','Juan','Perez',300,2,'Contaduria');
 insert into empleados values('22333333','Luis','Lopez',300,0,'Contaduria');
 insert into empleados values ('22444444','Marta','Perez',500,1,'Sistemas');
 insert into empleados values('22555555','Susana','Garcia',400,2,'Secretaria');
 insert into empleados values('22666666','Jose Maria','Morales',400,3,'Secretaria');

--3- Elimine el procedimiento llamado "pa_empleados_sueldo" si existe:
 if object_id('pa_empleados_sueldo') is not null
  drop procedure pa_empleados_sueldo;

--4- Cree un procedimiento almacenado llamado "pa_empleados_sueldo" que seleccione los nombres, 
--apellidos y sueldos de los empleados.
create procedure pa_empleados_sueldo
as 
	select nombre, apellido, sueldo from empleados;
go
--5- Ejecute el procedimiento creado anteriormente.
exec pa_empleados_sueldo

--6- Elimine el procedimiento llamado "pa_empleados_hijos" si existe:
 if object_id('pa_empleados_hijos') is not null
  drop procedure pa_empleados_hijos;

--7- Cree un procedimiento almacenado llamado "pa_empleados_hijos" que seleccione los nombres, 
--apellidos y cantidad de hijos de los empleados con hijos.
create procedure pa_empleados_hijos
as
	select nombre, apellido,cantidadhijos from empleados;
go

--8- Ejecute el procedimiento creado anteriormente.
exec pa_empleados_hijos
go
--9- Actualice la cantidad de hijos de algún empleado sin hijos y vuelva a ejecutar el procedimiento 
--para verificar que ahora si aparece en la lista.
CREATE PROCEDURE PA_EMPLADOS_ACTUALIZARHIJOS
AS 
	UPDATE empleados SET cantidadhijos = 10 WHERE cantidadhijos = 0
GO

EXEC PA_EMPLADOS_ACTUALIZARHIJOS
GO

--PARA ELIMINAR UN PROCEDIMIENTO ALMACENADO SE ESCRIBE DROP PROCEDURE "NOMBRE-DEL-PROCEDIMIENTO"


