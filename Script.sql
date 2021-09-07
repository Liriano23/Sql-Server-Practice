CREATE database CursoSqlServer
use CursoSqlServer; 

--Indices 
/* 
	SINTAX: 
		create TIPODEINDICE index NOMBREINDICE
		on TABLA(CAMPO);

		Procedimiento almacenado para consultar indices
		 exec sp_helpindex libros;
*/ 

--1- Elimine la tabla si existe y créela con la siguiente estructura:
IF OBJECT_ID('ALUMNOS') IS NOT NULL
	DROP TABLE ALUMNOS;

CREATE TABLE ALUMNOS
(
	LEGAJO CHAR(5) NOT NULL,
	DOCUMENTO CHAR(8) NOT NULL,
	APELLIDO VARCHAR(30),
	NOMBRE VARCHAR(30),
	NOTAFINAL DECIMAL(4,2)
);

--2- Ingresamos algunos registros:
INSERT INTO ALUMNOS VALUES ('A123','22222222','Perez','Patricia',5.50);
INSERT INTO ALUMNOS(LEGAJO,DOCUMENTO,APELLIDO,NOMBRE,NOTAFINAL) 
VALUES ('A234','23333333','Lopez','Ana',9);
INSERT INTO ALUMNOS VALUES ('A345','24444444','Garcia','Carlos',8.5);
INSERT INTO ALUMNOS VALUES ('A348','25555555','Perez','Daniela',7.85);
INSERT INTO ALUMNOS VALUES ('A457','26666666','Perez','Fabian',3.2);
INSERT INTO ALUMNOS VALUES ('A589','27777777','Gomez','Gaston',6.90);
--Intente crear un índice agrupado único para el campo "apellido".
--No lo permite porque hay valores duplicados.
CREATE UNIQUE CLUSTERED INDEX I_ALUMNOS_APELLIDO
ON ALUMNOS(APELLIDO);
--4- Cree un índice agrupado, no único, para el campo "apellido".
CREATE CLUSTERED INDEX I_ALUMNOS_APELLIDO
ON ALUMNOS(APELLIDO);

--Intente establecer una restricción "primary key" al campo "legajo" especificando que cree un 
--índice agrupado.
--No lo permite porque ya existe un índice agrupado y solamente puede haber uno por tabla.
ALTER TABLE ALUMNOS 
ADD CONSTRAINT PK_LEGAJO PRIMARY KEY CLUSTERED(LEGAJO);

--6- Establezca la restricción "primary key" al campo "legajo" especificando que cree un índice NO 
--agrupado.
ALTER TABLE ALUMNOS
ADD CONSTRAINT PK_LEGAJO 
PRIMARY KEY NONCLUSTERED (LEGAJO);

--Vea los índices de "alumnos":
-- exec sp_helpindex alumnos;

EXEC sp_helpindex ALUMNOS;

EXEC SP_HELPCONSTRAINT ALUMNOS; 

--CREANDO INDICE COMPUESTO
CREATE INDEX I_ALUMNOS_APELLIDONOMBRE
ON ALUMNOS(APELLIDO,NOMBRE);

EXEC sp_helpindex ALUMNOS;

 select name from sysindexes
  where name like '%alumnos%';

--CREE UNA RESTRICCION UNIQUE PARA EL CAMPO DOCUMENTO
ALTER TABLE ALUMNOS
ADD CONSTRAINT UQ_ALUMNOS_DOCUMENTO
UNIQUE(DOCUMENTO); 

 exec sp_helpconstraint alumnos;
  exec sp_helpindex alumnos;

   select name from sysindexes
  where name like '%alumnos%';

 select name from sysindexes
  where name like 'I_%';


--SELECCIONANDO LOS ELEMENTOS
SELECT * FROM ALUMNOS;


--jOINS 
--1- Elimine las tablas "clientes" y "provincias", si existen:
IF OBJECT_ID('CLIENTES') IS NOT NULL
	DROP TABLE CLIENTES;

IF OBJECT_ID('PROVINCIAS') IS NOT NULL
	DROP TABLE PROVINCIAS;

create table clientes (
  codigo int identity,
  nombre varchar(30),
  domicilio varchar(30),
  ciudad varchar(20),
  codigoprovincia tinyint not null,
  primary key(codigo)
 );

 create table provincias(
  codigo tinyint identity,
  nombre varchar(20),
  primary key (codigo)
 );

insert into provincias (nombre) values('Cordoba');
insert into provincias (nombre) values('Santa Fe');
insert into provincias (nombre) values('Corrientes');

insert into clientes values ('Lopez Marcos','Colon 111','Córdoba',1);
insert into clientes values ('Perez Ana','San Martin 222','Cruz del Eje',1);
insert into clientes values ('Garcia Juan','Rivadavia 333','Villa Maria',1);
insert into clientes values ('Perez Luis','Sarmiento 444','Rosario',2);
insert into clientes values ('Pereyra Lucas','San Martin 555','Cruz del Eje',1);
insert into clientes values ('Gomez Ines','San Martin 666','Santa Fe',2);
insert into clientes values ('Torres Fabiola','Alem 777','Ibera',3);

--4- Obtenga los datos de ambas tablas, usando alias:
SELECT C.nombre, C.domicilio, C.ciudad, P.NOMBRE 
FROM clientes AS C INNER JOIN provincias AS P 
ON C.codigoprovincia = P.codigo;

--5.Obtenga la misma información anterior pero ordenada por nombre de provincia.
SELECT C.NOMBRE, C.DOMICILIO, C.CIUDAD, P.NOMBRE
FROM CLIENTES AS C INNER JOIN provincias AS P
ON C.codigoprovincia = P.codigo ORDER BY P.nombre;

--6- Recupere los clientes de la provincia "Santa Fe" (2 registros devueltos)
SELECT C.NOMBRE, C.DOMICILIO, C.CIUDAD, P.NOMBRE 
FROM clientes AS C INNER JOIN provincias AS P
ON C.codigoprovincia = P.codigo WHERE P.nombre LIKE '%Santa Fe%'

--LEFT JOIN
if (object_id('clientes')) is not null
   drop table clientes;
  if (object_id('provincias')) is not null
   drop table provincias;

 create table clientes (
  codigo int identity,
  nombre varchar(30),
  domicilio varchar(30),
  ciudad varchar(20),
  codigoprovincia tinyint not null,
  primary key(codigo)
 );

 create table provincias(
  codigo tinyint identity,
  nombre varchar(20),
  primary key (codigo)
 );

--2- Ingrese algunos registros para ambas tablas:
 insert into provincias (nombre) values('Cordoba');
 insert into provincias (nombre) values('Santa Fe');
 insert into provincias (nombre) values('Corrientes');

 insert into clientes values ('Lopez Marcos','Colon 111','Córdoba',1);
 insert into clientes values ('Perez Ana','San Martin 222','Cruz del Eje',1);
 insert into clientes values ('Garcia Juan','Rivadavia 333','Villa Maria',1);
 insert into clientes values ('Perez Luis','Sarmiento 444','Rosario',2);
 insert into clientes values ('Gomez Ines','San Martin 666','Santa Fe',2);
 insert into clientes values ('Torres Fabiola','Alem 777','La Plata',4);
 insert into clientes values ('Garcia Luis','Sucre 475','Santa Rosa',5);

--Muestre todos los datos de los clientes, incluido el nombre de la provincia:
SELECT C.NOMBRE, C.DOMICILIO, C.CIUDAD, P.NOMBRE
FROM clientes AS C LEFT JOIN provincias AS P
ON C.codigoprovincia = P.codigo;

--Realice la misma consulta anterior pero alterando el orden de las tablas:
 select c.nombre,domicilio,ciudad, p.nombre
  from provincias as p
  left join clientes as c
  on codigoprovincia = p.codigo;

--5- Muestre solamente los clientes de las provincias que existen en "provincias" (5 registros):
 select c.nombre,domicilio,ciudad, p.nombre
  from clientes as c
  left join provincias as p
  on codigoprovincia = p.codigo
  where p.codigo is not null;

--6- Muestre todos los clientes cuyo código de provincia NO existe en "provincias" ordenados por 
--nombre del cliente (2 registros):
 select c.nombre,domicilio,ciudad, p.nombre
  from clientes as c
  left join provincias as p
  on codigoprovincia = p.codigo
  where p.codigo is null
  order by c.nombre;

--Obtenga todos los datos de los clientes de "Cordoba" (3 registros):
 select c.nombre,domicilio,ciudad, p.nombre
  from clientes as c
  left join provincias as p
  on codigoprovincia = p.codigo
  where p.nombre='Cordoba';

SELECT * FROM clientes;
SELECT * FROM provincias;



--fOREIGN KEY 
--1- Elimine las tablas "clientes" y "provincias", si existen y créelas:
 if object_id('clientes') is not null
  drop table clientes;
 if object_id('provincias') is not null
  drop table provincias;

CREATE TABLE CLIENTES
(
	CODIGO INT IDENTITY, 
	NOMBRE VARCHAR(30),
	DOMICILIO VARCHAR(30),
	CIUDAD VARCHAR(30),
	CODIGOPROVINCIO TINYINT
);
ALTER TABLE CLIENTES 
ADD CONSTRAINT FK_CODIGOPROVINCIA
FOREIGN KEY(CODIGOPROVINCIA) 
REFERENCES PROVINCIA(CODIGO);

CREATE TABLE PROVINCIAS
(
	CODIGO TINYINT NOT NULL,
	NOMBRE VARCHAR(20)
);

ALTER TABLE PROVINCIAS 
ADD CONSTRAINT pk_CODIGOPROVINCIA
PRIMARY KEY(CODIGO);

insert into provincias values(1,'Cordoba');
 insert into provincias values(2,'Santa Fe');
 insert into provincias values(3,'Misiones');
 insert into provincias values(4,'Rio Negro');

 insert into clientes values('Perez Juan','San Martin 123','Carlos Paz',1);
 insert into clientes values('Moreno Marcos','Colon 234','Rosario',2);
 insert into clientes values('Acosta Ana','Avellaneda 333','Posadas',3);
 insert into clientes values('Luisa Lopez','Juarez 555','La Plata',6);


delete from clientes where CODIGOPROVINCIO=6;
 
alter table clientes
add constraint FK_clientes_codigoprovincia
foreign key (CODIGOPROVINCIO)
references provincias(codigo)
ON DELETE CASCADE
ON UPDATE CASCADE;

--UNION
--1- Elimine las tablas si existen:
 if object_id('clientes') is not null
  drop table clientes;
 if object_id('proveedores') is not null
  drop table proveedores;
 if object_id('empleados') is not null
  drop table empleados;

  Create table proveedores(
  codigo int identity,
  nombre varchar (30),
  domicilio varchar(30),
  primary key(codigo)
 );
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

 insert into proveedores values('Bebida cola','Colon 123');
 insert into proveedores values('Carnes Unica','Caseros 222');
 insert into proveedores values('Lacteos Blanca','San Martin 987');
 insert into clientes values('Supermercado Lopez','Avellaneda 34');
 insert into clientes values('Almacen Anita','Colon 987');
 insert into clientes values('Garcia Juan','Sucre 345');
 insert into empleados values('23333333','Federico','Lopez','Colon 987');
 insert into empleados values('28888888','Ana','Marquez','Sucre 333');
 insert into empleados values('30111111','Luis','Perez','Caseros 956');

 SELECT NOMBRE, domicilio FROM proveedores
 UNION 
	SELECT NOMBRE ,DOMICILIO FROM clientes
 UNION
	SELECT NOMBRE, DOMICILIO FROM empleados;


--ALTER DROP, ADD

CREATE TABLE PERSONAS
(
	Id tinyint NOT NULL
);

ALTER TABLE PERSONAS 
ADD CONSTRAINT PK_ID
PRIMARY KEY(Id)

ALTER TABLE PERSONAS
ADD NOMBRE VARCHAR(30);

ALTER TABLE PERSONAS
DROP COLUMN NOMBRE;

exec sp_columns PERSONAS;

/*
	TIPOS DE DATOS CREADOS POR LOS USUARIOS
	exec sp_addtype NOMBRENUEVOTIPO, 'TIPODEDATODELSISTEMA', 'OPCIONNULL';
	exec sp_addtype tipo_documento, 'char(8)', 'null';

	También podemos consultar la tabla "systypes" en la cual se almacena información de todos los tipos de datos:
	=> select name from systypes;

	--PARA ELIMINAR TIPO DE DATO CREADO POR EL USUARIO SE UTILIZA 
		exec sp_droptype TIPODEDATODEFINIDOPORELUSUARIO;
		exec sp_droptype tipo_documento;

	--CONDICION PARA COMPROBAR QUE EXISTA EL TIPO DE DATO CREADO POR EL USUARIO 
		if exists (select *from systypes where name = 'NOMBRETIPODEDATODEFINIDOPORELUSUARIO')
			exec sp_droptype TIPODEDATODEFINIDOPORELUSUARIO;

*/
--EJEMPLO CREANDO TIPO DE DATO 
exec sp_help tipo_documento;

create table alumnos
(
  documento tipo_documento,
  nombre varchar(30)
);
GO 


insert into alumnos values('12345678','Ana Acosta');

select * from alumnos;

--SUBCONSULTAS
--Eliminar la tabla si existe
IF OBJECT_ID('ALUMNOS') IS NOT NULL
	DROP TABLE ALUMNOS;

--2. Agregue una restricción "primary key" para el campo "documento" 
--una "check" para validar que el campo "nota" se encuentre 
--entre los valores 0 y 10:
USE CURSOSQLSERVER; 
CREATE TABLE ALUMNOS
(
	DOCUMENTO CHAR(8),
	NOMBRE VARCHAR(30),
	NOTA DECIMAL(4,2),
	PRIMARY KEY(DOCUMENTO),
	CONSTRAINT CK_ALUMNOS_NOTAS CHECK (NOTA >= 0 AND NOTA <= 10)
);
GO

--iNGRESE ALGUNOS REGISTROS 
SELECT * FROM ALUMNOS ORDER BY NOMBRE;
INSERT INTO ALUMNOS VALUES('30111111','Ana Algarbe',5.1);
Insert into alumnos values('30222222','Bernardo Bustamante',3.2);
Insert into alumnos values('30333333','Carolina Conte',4.5);
Insert into alumnos values('30444444','Diana Dominguez',9.7);
Insert into alumnos values('30555555','Fabian Fuentes',8.5);
Insert into alumnos values('30666666','Gaston Gonzalez',9.70);

--Obtenga todos los datos de los alumnos con la nota más alta, 
--empleando subconsulta.
SELECT * FROM ALUMNOS 
WHERE NOTA = (SELECT MAX(NOTA) FROM ALUMNOS);

select documento ,nombre, nota
 from alumnos
 where nota=
  (select nombre,max(nota) from alumnos);

--6- Muestre los alumnos que tienen una nota menor al promedio, 
--su nota, y la diferencia con el promedio.
SELECT NOMBRE FROM ALUMNOS 
WHERE NOTA <= (SELECT AVG(NOTA) FROM ALUMNOS);

UPDATE ALUMNOS SET NOTA=4 WHERE NOTA = 
(SELECT MIN(NOTA) FROM ALUMNOS);

DELETE FROM ALUMNOS WHERE 
NOTA < (SELECT AVG(NOTA) FROM ALUMNOS);

--SUBCONSULTAS IN & NOT IN
--1- Elimine las tablas si existen:
 if object_id('inscriptos') is not null
  drop table inscriptos;
 if object_id('socios') is not null
  drop table socios;

--2- Cree las tablas:
 create table socios(
  numero int identity,
  documento char(8),
  nombre varchar(30),
  domicilio varchar(30),
  primary key (numero)
 );
 
 create table inscriptos (
  numerosocio int not null,
  deporte varchar(20) not null,
  cuotas tinyint
  constraint CK_inscriptos_cuotas
   check (cuotas>=0 and cuotas<=10)
  constraint DF_inscriptos_cuotas default 0,
  primary key(numerosocio,deporte),
  constraint FK_inscriptos_socio
   foreign key (numerosocio)
   references socios(numero)
   on update cascade
   on delete cascade,
 );
 insert into socios values('23333333','Alberto Paredes','Colon 111');
 insert into socios values('24444444','Carlos Conte','Sarmiento 755');
 insert into socios values('25555555','Fabian Fuentes','Caseros 987');
 insert into socios values('26666666','Hector Lopez','Sucre 344');

 insert into inscriptos values(1,'tenis',1);
 insert into inscriptos values(1,'basquet',2);
 insert into inscriptos values(1,'natacion',1);
 insert into inscriptos values(2,'tenis',9);
 insert into inscriptos values(2,'natacion',1);
 insert into inscriptos values(2,'basquet',default);
 insert into inscriptos values(2,'futbol',2);
 insert into inscriptos values(3,'tenis',8);
 insert into inscriptos values(3,'basquet',9);
 insert into inscriptos values(3,'natacion',0);
 insert into inscriptos values(4,'basquet',10);

--4- Muestre el número de socio, el nombre del socio y el deporte 
--en que está inscripto con un join de ambas tablas.
SELECT S.numero, S.nombre FROM socios AS S
INNER JOIN inscriptos AS I ON S.NUMERO = I.NUMEROSOCIO;
GO

 select nombre
  from socios
  join inscriptos as i
  on numero=numerosocio
  where deporte='natacion' and 
  numero= any
  (select numerosocio
    from inscriptos as i
    where deporte='tenis');


--Crear tablas por select-into
--1- Elimine las tablas "empleados" y "sucursales" si existen:
 if object_id('empleados')is not null
  drop table empleados;
 if object_id('sucursales')is not null
  drop table sucursales;

create table sucursales( 
  codigo int identity,
  ciudad varchar(30) not null,
  primary key(codigo)
 ); 

--3- Cree la tabla "empleados":
 create table empleados( 
  documento char(8) not null,
  nombre varchar(30) not null,
  domicilio varchar(30),
  seccion varchar(20),
  sueldo decimal(6,2),
  codigosucursal int,
  primary key(documento),
  constraint FK_empleados_sucursal
   foreign key (codigosucursal)
   references sucursales(codigo)
   on update cascade
 ); 
 insert into sucursales values('Cordoba');
 insert into sucursales values('Villa Maria');
 insert into sucursales values('Carlos Paz');
 insert into sucursales values('Cruz del Eje');

 insert into empleados values('22222222','Ana Acosta','Avellaneda 111','Secretaria',500,1);
 insert into empleados values('23333333','Carlos Caseros','Colon 222','Sistemas',800,1);
 insert into empleados values('24444444','Diana Dominguez','Dinamarca 333','Secretaria',550,2);
 insert into empleados values('25555555','Fabiola Fuentes','Francia 444','Sistemas',750,2);
 insert into empleados values('26666666','Gabriela Gonzalez','Guemes 555','Secretaria',580,3);
 insert into empleados values('27777777','Juan Juarez','Jujuy 777','Secretaria',500,4);
 insert into empleados values('28888888','Luis Lopez','Lules 888','Sistemas',780,4);
 insert into empleados values('29999999','Maria Morales','Marina 999','Contaduria',670,4);

SELECT DOCUMENTO, NOMBRE, DOMICILIO, SECCION, SUELDO, CIUDAD
FROM empleados JOIN sucursales ON CODIGOSUCURSAL = CODIGO;

--6-Cree una tabla llamada "secciones" que contenga las secciones de la empresa (primero elimínela, si 
--existe):
if object_id('SECCIONES') is not null
  drop table secciones;

SELECT DISTINCT seccion AS NOMBRE INTO SECCIONES
FROM EMPLEADOS;

SELECT seccion FROM empleados;

SELECT * FROM SECCIONES;

--8- Se necesita una nueva tabla llamada "sueldosxseccion" que contenga la suma de los sueldos de los 
--empleados por sección. Primero elimine la tabla, si existe:
 if object_id('sueldosxseccion') is not null
  drop table sueldosxseccion;

 SELECT seccion, sum(sueldo) as total into sueldoxSeccion from empleados
 group by seccion;

 select * from sueldoxSeccion;

--10- Se necesita una tabla llamada "maximossueldos" que contenga los mismos campos que "empleados" y 
--guarde los 3 empleados con sueldos más altos. Primero eliminamos, si existe, la tabla 
--"maximossueldos":
 if object_id('maximossueldos') is not null
  drop table maximossueldos;

select top 3 * into maximoSueldo 
from empleados order by sueldo;

select * from maximoSueldo;
GO

--Vistas 
/*
	Las sintaxis de las vistas son: 
	 create view NOMBREVISTA as
	SENTENCIASSELECT
	from TABLA;	

	El contenido de una vista se muestra con un "select":

	select *from NOMBREVISTA;
*/
create view vistaEmpleados as
select nombre from empleados;
--create view vista_empleados as
--  select (apellido+' '+e.nombre) as nombre,sexo,
--   s.nombre as seccion, cantidadhijos
--   from empleados as e
--   join secciones as s
--   on codigo=seccion

----Visualizando vista
select * from vistaEmpleados;

--visualizar todos los objetos de la base de datos
exec sp_help
GO

--mostrar texto que define la vista
exec sp_helptext vistaEmpleados
GO
--Obtiene informacion de lo que depende el objeto
exec sp_depends VistaEmpleados
GO


--Para encripta una vista se puede hacer de la siguiente forma
/*
	create view NOMBREVISTA
		with encryption
			as 
			SENTENCIASSELECT
*/

create view VistaEmpleados
with encryption
as select nombre from empleados;
GO
--Si verifico que el texto con sp_helptext me dice que esta encriptado

--Para eliminar una vista 
drop view vistaEmpleados;
GO

--Modificando una vista  "agreando el campo domicilio
/*
	alter view NOMBREVISTA
  with encryption--opcional
 as SELECT

 alter view vista_empleados
  with encryption
 as
  select (apellido+' '+e.nombre) as nombre,sexo,
   s.nombre as seccion, cantidadhijos,domicilio
   from empleados as e
   join secciones as s
   on codigo=seccion
*/ 

--IF 
/* 
	if exists (select * from libros where cantidad=0)
	  delete from libros where cantidad=0
	 else
	  select 'No hay registros eliminados;


	SI EL IF DEBE EJECUTAR MAS DE 2 SENTENCIAS DEBE ESTAR ENTRE BEGIN Y END)
	if exists (select * from libros where editorial='Emece')
	begin
		update libros set precio=precio-(precio*0.1) where editorial='Emece'
		select 'libros actualizados'
	end
		else
			select 'no hay registros actualizados';
*/ 

--Procedimientos almacenados 
use CursoSqlServer;

/*
	Sintaxis basica: 
	create procedure NOMBREDELPROCEDIMIENTO
	AS 
		INSTRUCCIONES

	create proc pa_libros_limite_stock
	as
		select * from libros
		where cantidad <=10;
	PARA EJECUTAR ESTE PROCEMIDIMIENTO SE USA: 
	EXEC pa_libros_limite_stock

	//ELIMINAR PROCEDIMIENTOS ALMACENADOS
	if object_id('pa_libros_autor') is not null
		 drop procedure pa_libros_autor
	else 
		select 'No existe el procedimiento "pa_libros_autor"';
*/

--Una empresa almacena los datos de sus empleados en una tabla llamada "empleados".
--1- Eliminamos la tabla, si existe y la creamos:
If OBJECT_ID('EMPLEADOS') IS NOT NULL
	DROP TABLE EMPLEADOS;

CREATE TABLE EMPLEADOS
(
	DOCUMENTO CHAR(8),
	NOMBRE VARCHAR(20),
	APELLIDO VARCHAR(20),
	SUELDO DECIMAL(6,2),
	CANTIDADHIJOS TINYINT,
	SECCION VARCHAR(20)
);

insert into empleados values('22222222','Juan','Perez',300,2,'Contaduria');
insert into empleados values('22333333','Luis','Lopez',300,0,'Contaduria');
insert into empleados values ('22444444','Marta','Perez',500,1,'Sistemas');
insert into empleados values('22555555','Susana','Garcia',400,2,'Secretaria');
insert into empleados values('22666666','Jose Maria','Morales',400,3,'Secretaria');

--3.Elimine el procedimiento llamado "pa_empleados_sueldo" si existe:
IF OBJECT_ID('PA_EMPLEADOS_SUELDO') IS NOT NULL
	DROP PROCEDURE PA_EMPLEADOS_SUELDOS;

--4- Cree un procedimiento almacenado llamado "pa_empleados_sueldo" que seleccione los nombres, 
--apellidos y sueldos de los empleados.

CREATE PROC PA_EMPLEADOS_SUELDOS
AS 
	SELECT NOMBRE, APELLIDO, SUELDO FROM EMPLEADOS;
GO

EXEC PA_EMPLEADOS_SUELDOS;
GO

IF OBJECT_ID('PA_EMPLEADOS_HIJOS') IS NOT NULL
 DROP PROCEDURE PA_EMPLEADOS_HIJOS;

--7- Cree un procedimiento almacenado llamado "pa_empleados_hijos" que seleccione los nombres, 
--apellidos y cantidad de hijos de los empleados con hijos.

CREATE PROC PA_EMPLEADOS_HIJOS
AS 
	SELECT NOMBRE,APELLIDO,CANTIDADHIJOS FROM EMPLEADOS
	WHERE CANTIDADHIJOS > 0;
GO

EXEC PA_EMPLEADOS_HIJOS;
GO

UPDATE EMPLEADOS SET CANTIDADHIJOS = 5 WHERE CANTIDADHIJOS = 0;
GO

/* 
	PARAMETROS DE ENTRADA 
	create proc NOMBREPROCEDIMIENTO
		@NOMBREPARAMETRO TIPO =VALORPORDEFECTO
	as SENTENCIAS; 

	create procedure pa_libros_autor
	@autor varchar(30) 
	as
		select titulo, editorial,precio
		from libros
		where autor= @autor;
	
	PARA EJECUTAR EL PROCEDIMIENTO ALMACENADO
	exec pa_libros_autor 'Borges';

	create procedure pa_libros_autor_editorial
	@autor varchar(30),
	@editorial varchar(20) 
	as
		select titulo, precio
		from libros
		where autor= @autor and
		editorial=@editorial;

		PARA EJECUTAR PROCEIMIENTOS CON 2 PARAMETROS SE SEPARAN POR COMA
		exec pa_libros_autor_editorial 'Richard Bach','Planeta';

		PARA OMITIR LOS PARAMETROS AL EJECUTAR EL PROCEDIMIENTOS SE DEBE
		DE PONER VALORES POR DEFECTO A LOS PARAMETROS: 
		
		create procedure pa_libros_autor_editorial2
		@autor varchar(30)='Richard Bach',
		@editorial varchar(20)='Planeta' 
		as
			select titulo, autor,editorial,precio
			from libros
			where autor= @autor and
			editorial=@editorial;

emplear patrones de búsqueda en la consulta que define el procedimiento almacenado y utilizar comodines como valores por defecto:

 create proc pa_libros_autor_editorial3
  @autor varchar(30) = '%',
  @editorial varchar(30) = '%'
 as 
  select titulo,autor,editorial,precio
   from libros
   where autor like @autor and
   editorial like @editorial;


*/

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

 insert into empleados values('22222222','Juan','Perez',300,2,'Contaduria');
 insert into empleados values('22333333','Luis','Lopez',300,0,'Contaduria');
 insert into empleados values ('22444444','Marta','Perez',500,1,'Sistemas');
 insert into empleados values('22555555','Susana','Garcia',400,2,'Secretaria');
 insert into empleados values('22666666','Jose Maria','Morales',400,3,'Secretaria');

 IF OBJECT_ID('pa_empleados_sueldo') IS NOT NULL
	DROP PROCEDURE pa_empleados_sueldo;

CREATE PROCEDURE pa_empleados_sueldo
	@SUELDO DECIMAL(6,2)
AS 
	SELECT NOMBRE, APELLIDO, SUELDO FROM empleados
	WHERE sueldo >= @SUELDO;
GO

EXEC pa_empleados_sueldo 400;
GO
EXEC pa_empleados_sueldo 500;
GO

--Cree un procedimiento almacenado llamado "pa_empleados_actualizar_sueldo" que actualice los 
--sueldos iguales al enviado como primer parámetro con el valor enviado como segundo parámetro.

CREATE PROCEDURE pa_empleados_actualizar_sueldo
	@SUELDO1 DECIMAL(6,2),
	@SUELDO2 DECIMAL(6,2)
AS 
	UPDATE empleados SET sueldo = @SUELDO2
	WHERE sueldo = @SUELDO1;
GO

SELECT * FROM empleados;
GO 

EXEC pa_empleados_actualizar_sueldo 300, 500;
GO

