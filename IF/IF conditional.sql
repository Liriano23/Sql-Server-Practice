/*
	 if exists (select * from libros where cantidad=0)
  (select titulo from libros where cantidad=0)
 else
  select 'No hay libros sin stock';

	if exists (select * from libros where editorial='Emece')
 begin
  update libros set precio=precio-(precio*0.1) where editorial='Emece'
  select 'libros actualizados'
 end
 else
  select 'no hay registros actualizados';

  Note que si la condición es verdadera, se deben ejecutar 2 sentencias. Por lo tanto, se deben encerrar en un bloque "begin...end".
*/

use CursoSqlServer
GO
--Example
if object_id('libros') is not null
  drop table libros;

create table libros(
  codigo int identity,
  titulo varchar(40) not null,
  autor varchar(30),
  editorial varchar(20),
  precio decimal(5,2),
  cantidad tinyint,
  primary key (codigo)
);

go

insert into libros values('Uno','Richard Bach','Planeta',15,100);
insert into libros values('El aleph','Borges','Emece',20,150);
insert into libros values('Aprenda PHP','Mario Molina','Nuevo siglo',50,200);
insert into libros values('Alicia en el pais de las maravillas','Lewis Carroll','Emece',15,0);
insert into libros values('Java en 10 minutos','Mario Molina','Emece',40,200);

-- Mostramos los títulos de los cuales no hay libros disponibles (cantidad=0); 
-- en caso que no haya, mostramos un mensaje:
IF EXISTS (select * from libros where cantidad = 0)
	begin
		--(select titulo from libros where cantidad = 0)
		select titulo from libros where cantidad = 0
	end
else
	select 'No hay elementos'



--Exercise

--Una empresa registra los datos de sus empleados en una tabla llamada "empleados".
--1- Elimine la tabla "empleados" si existe:
 if object_id('empleados') is not null
  drop table empleados;

--2- Cree la tabla:
 create table empleados(
  documento char(8) not null,
  nombre varchar(30) not null,
  sexo char(1),
  fechanacimiento datetime,
  sueldo decimal(5,2),
  primary key(documento)
);

--3- Ingrese algunos registros:
 insert into empleados values ('22333111','Juan Perez','m','1970-05-10',550);
 insert into empleados values ('25444444','Susana Morales','f','1975-11-06',650);
 insert into empleados values ('20111222','Hector Pereyra','m','1965-03-25',510);
 insert into empleados values ('30000222','Luis LUque','m','1980-03-29',700);
 insert into empleados values ('20555444','Laura Torres','f','1965-12-22',400);
 insert into empleados values ('30000234','Alberto Soto','m','1989-10-10',420);
 insert into empleados values ('20125478','Ana Gomez','f','1976-09-21',350);
 insert into empleados values ('24154269','Ofelia Garcia','f','1974-05-12',390);
 insert into empleados values ('30415426','Oscar Torres','m','1978-05-02',400);

--4- Es política de la empresa festejar cada fin de mes, los cumpleaños de todos los empleados 
--que cumplen ese mes. Si los empleados son de sexo femenino, se les regala un ramo de rosas, 
--si son de sexo masculino, una corbata. La secretaria de la Gerencia necesita saber cuántos ramos 
--de rosas y cuántas corbatas debe comprar para el mes de mayo.

if exists ( select * from empleados where DATEPART(MONTH, fechanacimiento) = 5)
begin
	select sexo, count(1) as cantidad from empleados where MONTH(fechanacimiento) = 5
	group by sexo
end
else
	select 'No hay empleados'