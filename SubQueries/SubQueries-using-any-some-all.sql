/* 
	Queremos saber los títulos de los libros de "Borges" que pertenecen a editoriales que han publicado también libros de "Richard Bach", es decir, si los libros de "Borges" coinciden con ALGUNA de las editoriales que publicó libros de "Richard Bach":

	 select titulo
	  from libros
	  where autor='Borges' and
	  codigoeditorial = any
	   (select e.codigo
		from editoriales as e
		join libros as l
		on codigoeditorial=e.codigo
		where l.autor='Richard Bach');
*/

--Exercise
--1- Elimine las tablas si existen:
 if object_id('inscriptos') is not null
  drop table inscriptos;
 if object_id('socios') is not null
  drop table socios;

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

--4- Muestre el número de socio, el nombre del socio y el deporte en que está inscripto 
--con un join de ambas tablas.
select s.numero, s.nombre,  i.deporte 
	from socios as s join inscriptos as i on i.numerosocio = s.numero;
GO

--5- Muestre los socios que se serán compañeros en tenis y también en natación (empleando 
--subconsulta)
--3 filas devueltas.
select s.nombre from socios as s
where s.numero = any 
(select numerosocio from inscriptos as i 
	where i.deporte = 'tenis' or i.deporte = 'natacion');
go

 select nombre
  from socios
  join inscriptos as i
  on numero=numerosocio
  where i.deporte='natacion' and 
  numero= any
  (select numerosocio
    from inscriptos as i
    where deporte='tenis');
	go
--6- vea si el socio 1 se ha inscripto en algún deporte en el cual se haya inscripto el socio 2.
--3 filas.
select deporte from inscriptos as i
where i.numerosocio = 1 
	and i.deporte = any (select deporte from inscriptos where numerosocio = 2);
GO

--7- Obtenga el mismo resultado anterior pero empleando join.
	select i1.deporte from inscriptos as i1
	join inscriptos as i2 on i1.deporte = i2.deporte
	where i1.numerosocio = 1 and i2.numerosocio = 2
GO
-- 8 Muestre los deportes en los cuales el socio 2 pagó más cuotas que ALGUN deporte 
--en los que se inscribió el socio 1.
--2 registros.
	select deporte from inscriptos where numerosocio = 2 and 
	cuotas > any (select cuotas from inscriptos where numerosocio = 1);
GO

--9- Muestre los deportes en los cuales el socio 2 pagó más cuotas que TODOS los deportes en que se 
--inscribió el socio 1.
----1 registro.
select deporte from inscriptos where numerosocio = 2
and cuotas > all (select cuotas from inscriptos where numerosocio = 1);
GO

--10- Cuando un socio no ha pagado la matrícula de alguno de los deportes en que se ha inscripto, se 
--lo borra de la inscripción de todos los deportes. Elimine todos los socios que no pagaron 
--ninguna cuota en algún deporte.
--7 registros.

delete from inscriptos
where numerosocio = any (select numerosocio from inscriptos where cuotas = 0);
GO
--(select numerosocio 
--    from inscriptos
--    where cuotas=0);