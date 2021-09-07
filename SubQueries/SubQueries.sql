--SUBQUERIES AS EXPRESSIONS
/*

	Las subconsultas que retornan un solo valor escalar se utiliza con un operador de comparación o en lugar de una expresión:

	 select CAMPOS
	  from TABLA
	  where CAMPO OPERADOR (SUBCONSULTA);

	 select CAMPO OPERADOR (SUBCONSULTA)
	  from TABLA;

	  Para actualizar un registro empleando subconsulta la sintaxis básica es la siguiente:

	 update TABLA set CAMPO=NUEVOVALOR
	  where CAMPO= (SUBCONSULTA);

	  Para eliminar registros empleando subconsulta empleamos la siguiente sintaxis básica:

	 delete from TABLA
	  where CAMPO=(SUBCONSULTA)

	  Recuerde que la lista de selección de una subconsulta que va luego de un operador de comparación puede incluir sólo una expresión o campo (excepto si se emplea "exists" o "in").

No olvide que las subconsultas luego de un operador de comparación (que no es seguido por "any" o "all") no pueden incluir cláusulas "group by".
*/

USE CursoSqlServer
GO

if object_id('libros') is not null
  drop table libros;
GO

create table libros(
  codigo int identity,
  titulo varchar(40),
  autor varchar(30),
  editorial varchar(20),
  precio decimal(5,2)
);
GO

insert into libros values('Alicia en el pais de las maravillas','Lewis Carroll','Emece',20.00);
insert into libros values('Alicia en el pais de las maravillas','Lewis Carroll','Plaza',35.00);
insert into libros values('Aprenda PHP','Mario Molina','Siglo XXI',40.00);
insert into libros values('El aleph','Borges','Emece',10.00);
insert into libros values('Ilusiones','Richard Bach','Planeta',15.00);
insert into libros values('Java en 10 minutos','Mario Molina','Siglo XXI',50.00);
insert into libros values('Martin Fierro','Jose Hernandez','Planeta',20.00);
insert into libros values('Martin Fierro','Jose Hernandez','Emece',30.00);
insert into libros values('Uno','Richard Bach','Planeta',10.00);
GO

-- Obtenemos el título, precio de un libro específico y la diferencia entre
-- su precio y el máximo valor:

SELECT titulo, PRECIO, 
	precio-(select MAX(precio) from libros) as diferencia 
FROM LIBROS WHERE titulo = 'UNO'
go

-- Mostramos el título y precio del libro más costoso:
select titulo, precio from libros 
where precio = (select MAX(precio) from libros);
go

-- Actualizamos el precio del libro con máximo valor:
update libros set precio = 45
	where precio = (select MAX(precio) from libros);
go

-- Eliminamos los libros con precio menor:
delete from libros 
where precio = (select min(precio) from libros);
GO

--Exercise

if OBJECT_ID( 'Alumnos' ) is not null
	drop table Alumnos;
GO

create table alumnos(
  documento char(8),
  nombre varchar(30),
  nota decimal(4,2),
  primary key(documento),
  constraint CK_alumnos_nota_valores check (nota>=0 and nota <=10),
 );
 go

 --3-Ingrese algunos registros:
 insert into alumnos values('30111111','Ana Algarbe',5.1);
 insert into alumnos values('30222222','Bernardo Bustamante',3.2);
 insert into alumnos values('30333333','Carolina Conte',4.5);
 insert into alumnos values('30444444','Diana Dominguez',9.7);
 insert into alumnos values('30555555','Fabian Fuentes',8.5);
 insert into alumnos values('30666666','Gaston Gonzalez',9.70);
 go

--4- Obtenga todos los datos de los alumnos con la nota más alta, empleando subconsulta.
--2 registros.

select * from alumnos 
where nota = (Select MAX(nota) from alumnos);
GO

--5- Realice la misma consulta anterior pero intente que la consulta interna retorne, además del 
--máximo valor de nota, el nombre. 
--Mensaje de error, porque la lista de selección de una subconsulta que va luego de un operador de 
--comparación puede incluir sólo un campo o expresión (excepto si se emplea "exists" o "in").

select * from alumnos 
where nota = (Select MAX(nota), nombre from alumnos);
GO

--6- Muestre los alumnos que tienen una nota menor al promedio, su nota, y la diferencia con el 
--promedio.
--3 registros.

select *,(select AVG(nota) from alumnos) as 'Promedio', 
	(select AVG(nota) from alumnos)-nota as 'Diferencia Prom' 
		from alumnos where nota < (select AVG(nota) from alumnos);
GO

update alumnos set nota=4
  where nota=
   (select min(nota) from alumnos);

 delete from alumnos
 where nota<
   (select avg(nota) from alumnos);

--SubQueries using In
/*
	select nombre
  from editoriales
  where codigo in
   (select codigoeditorial
     from libros
     where autor='Richard Bach');

	 Podemos reemplazar por un "join" la consulta anterior:

	 select distinct nombre
	  from editoriales as e
	  join libros
	  on codigoeditorial=e.codigo
	  where autor='Richard Bach';
*/

if object_id('libros') is not null
  drop table libros;
go
if object_id('editoriales') is not null
  drop table editoriales;
go

create table editoriales(
  codigo tinyint identity,
  nombre varchar(30),
  primary key (codigo)
);
go

create table libros (
  codigo int identity,
  titulo varchar(40),
  autor varchar(30),
  codigoeditorial tinyint,
  primary key(codigo),
 constraint FK_libros_editorial
   foreign key (codigoeditorial)
   references editoriales(codigo)
   on update cascade,
);

go

insert into editoriales values('Planeta');
insert into editoriales values('Emece');
insert into editoriales values('Paidos');
insert into editoriales values('Siglo XXI');

insert into libros values('Uno','Richard Bach',1);
insert into libros values('Ilusiones','Richard Bach',1);
insert into libros values('Aprenda PHP','Mario Molina',4);
insert into libros values('El aleph','Borges',2);
insert into libros values('Puente al infinito','Richard Bach',2);

-- Queremos conocer el nombre de las editoriales que han publicado 
-- libros del autor "Richard Bach": 

select nombre 
	from editoriales
	where codigo in 
	(select codigoeditorial from libros 
		where autor = 'Richard Bach');
GO


-- Probamos la subconsulta separada de la consulta exterior
-- para verificar que retorna una lista de valores de un solo campo:
select codigoeditorial
  from libros
  where autor='Richard Bach';

  -- Podemos reemplazar por un "join" la primera consulta:
select distinct nombre
  from editoriales as e
  join libros
  on codigoeditorial=e.codigo
  where autor='Richard Bach';


--Exercise

--1- Elimine las tablas "clientes" y "ciudades", si existen:
  if (object_id('ciudades')) is not null
   drop table ciudades;
  if (object_id('clientes')) is not null
   drop table clientes;
GO

create table ciudades(
 codigo tinyint identity,
 nombre varchar(20),
 primary key (codigo)
);

create table clientes (
 codigo int identity,
 nombre varchar(30),
 domicilio varchar(30),
 codigociudad tinyint not null,
 primary key(codigo),
 constraint FK_clientes_ciudad
  foreign key (codigociudad)
  references ciudades(codigo)
  on update cascade,
);

insert into ciudades (nombre) values('Cordoba');
 insert into ciudades (nombre) values('Cruz del Eje');
 insert into ciudades (nombre) values('Carlos Paz');
 insert into ciudades (nombre) values('La Falda');
 insert into ciudades (nombre) values('Villa Maria');

 insert into clientes values ('Lopez Marcos','Colon 111',1);
 insert into clientes values ('Lopez Hector','San Martin 222',1);
 insert into clientes values ('Perez Ana','San Martin 333',2);
 insert into clientes values ('Garcia Juan','Rivadavia 444',3);
 insert into clientes values ('Perez Luis','Sarmiento 555',3);
 insert into clientes values ('Gomez Ines','San Martin 666',4);
 insert into clientes values ('Torres Fabiola','Alem 777',5);
 insert into clientes values ('Garcia Luis','Sucre 888',5);
 go

--4- Necesitamos conocer los nombres de las ciudades de aquellos clientes cuyo domicilio 
--es en calle "San Martin", empleando subconsulta.
--3 registros.
select nombre from ciudades as c
where c.codigo in 
	(select codigociudad from clientes 
		where domicilio like 'San Martin%');
GO

--consulta de la lista separada 
(select codigociudad from clientes 
		where domicilio like 'San Martin%');
GO

--5- Obtenga la misma salida anterior pero empleando join.
select c.nombre from ciudades as c
join clientes as cl on cl.codigociudad = c.codigo
where cl.domicilio like 'San Martin%'
go


--6- Obtenga los nombre de las ciudades de los clientes cuyo apellido no comienza con una letra 
--específica, empleando subconsulta.
--2 registros.
select nombre from ciudades
where codigo not in (select codigociudad from clientes where nombre like 'L%');
GO


--Usando joins

select distinct c.nombre from ciudades as c
join clientes as cl on cl.codigociudad = c.codigo
where cl.nombre not like 'L%';
GO

--7- Pruebe la subconsulta del punto 6 separada de la consulta exterior para verificar que retorna una 
--lista de valores de un solo campo.

--Comprobando la lista 
(select codigociudad, nombre from clientes where nombre like 'L%');