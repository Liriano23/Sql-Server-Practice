use CursoSqlServer
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

--3- Ingrese algunos registros:
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

-- 4- Se necesita un listado de todos los socios que incluya nombre y domicilio, la cantidad de 
--deportes a los cuales se ha inscripto, empleando subconsulta.
--4 registros.
select nombre, domicilio, 
	(select count(deporte) from inscriptos as i where  s.numero = i.numerosocio) 
	as 'Total deportes' 
from socios as s
GO

--5- Se necesita el nombre de todos los socios, el total de cuotas que debe pagar (10 por cada 
--deporte) y el total de cuotas pagas, empleando subconsulta.
--4 registros.
select s.nombre, 
	(select COUNT(*)*10 from inscriptos as i where s.numero = i.numerosocio) as 'Total cuotas',
		(select SUM(cuotas) from inscriptos as i where s.numero = i.numerosocio) as pagas
from socios as s;
GO


--6- Obtenga la misma salida anterior empleando join.

select s.nombre, (COUNT(*)*10) as Cuotas, (SUM(cuotas)) as pagas from socios as s
join inscriptos as i on s.numero = i.numerosocio
group by s.nombre
GO