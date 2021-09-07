/*
	create procedure NOMBREPROCEDIMIENTO
  @PARAMETROENTRADA TIPO =VALORPORDEFECTO,
  @PARAMETROSALIDA TIPO=VALORPORDEFECTO output
  as 
   SENTENCIAS
   select @PARAMETROSALIDA=SENTENCIAS;

   create procedure pa_promedio
  @n1 decimal(4,2),
  @n2 decimal(4,2),
  @resultado decimal(4,2) output
  as 
   select @resultado=(@n1+@n2)/2;

   Al ejecutarlo también debe emplearse "output":
	declare @variable decimal(4,2)
	execute pa_promedio 5,6, @variable output
	select @variable;
*/

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
 insert into empleados values('22333333','Luis','Lopez',350,0,'Contaduria');
 insert into empleados values ('22444444','Marta','Perez',500,1,'Sistemas');
 insert into empleados values('22555555','Susana','Garcia',null,2,'Secretaria');
 insert into empleados values('22666666','Jose Maria','Morales',460,3,'Secretaria');
 insert into empleados values('22777777','Andres','Perez',580,3,'Sistemas');
 insert into empleados values('22888888','Laura','Garcia',400,3,'Secretaria');

--3- Elimine el procedimiento llamado "pa_seccion" si existe:
 if object_id('pa_seccion') is not null
  drop procedure pa_seccion;

--4- Cree un procedimiento almacenado llamado "pa_seccion" al cual le enviamos el nombre de una 
--sección y que nos retorne el promedio de sueldos de todos los empleados de esa sección y el valor 
--mayor de sueldo (de esa sección)
create procedure pa_seccion_promedio_suelo
@seccion varchar(max),
@promedio decimal(6,2) output,
@mayor decimal(6,2) output
as
select @promedio = AVG(sueldo) from empleados where seccion like @seccion;
select @mayor = MAX(sueldo) from empleados where seccion like @seccion;
GO


--5- Ejecute el procedimiento creado anteriormente con distintos valores.
declare @p decimal(6,2), @m decimal(6,2)
exec pa_seccion_promedio_suelo 'Contaduria', @p output, @m output;
select @p, @m 
GO
--6- Ejecute el procedimiento "pa_seccion" sin pasar valor para el parámetro "sección". Luego muestre 
--los valores devueltos por el procedimiento.
--Calcula sobre todos los registros porque toma el valor por defecto. 

--7- Elimine el procedimiento almacenado "pa_sueldototal", si existe y cree un procedimiento con ese 
--nombre que reciba el documento de un empleado y retorne el sueldo total, resultado de la suma del 
--sueldo y salario por hijo, que es $200 si el sueldo es menor a $500 y 1500 si es mayor o igual.
if OBJECT_ID('pa_sueldototal') is not null
drop procedure pa_sueldototal;
GO

create proc pa_sueldototal
@documento varchar(9) = '%',
@sueldoTotal decimal(6,2) output
as
select @sueldoTotal = 
	case 
	when sueldo < 500 then sueldo+(cantidadhijos*200)
	when sueldo >= 500 then sueldo+(cantidadhijos*100)
	end
from empleados where @documento like @documento
--8- Ejecute el procedimiento anterior enviando un documento existente.
	declare @st decimal(8,2)
	exec pa_sueldototal '22666666', @st output
	select @st;

--9- Ejecute el procedimiento anterior enviando un documento inexistente.
--Retorna "null".
declare @st decimal(8,2)
 exec pa_sueldototal '22999999', @st output
 select @st;
--10- Ejecute el procedimiento anterior enviando el documento de un empleado en cuyo campo "sueldo" 
--contenga "null".
--Retorna "null".
 declare @st decimal(8,2)
 exec pa_sueldototal '22555555', @st output
 select @st;
--11- Ejecute el procedimiento anterior sin enviar valor para el parámetro "documento".
--Retorna el valor calculado del último registro.
declare @st decimal(8,2)
 exec pa_sueldototal @sueldototal=@st output
 select @st;