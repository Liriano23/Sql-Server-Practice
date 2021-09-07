/*
	create function NOMBRE
	 (@PARAMETRO TIPO=VALORPORDEFECTO)
	  returns TIPO
	  begin
	   INSTRUCCIONES
	   return VALOR
	  end;

	  create function f_promedio
		 (@valor1 decimal(4,2),
		  @valor2 decimal(4,2)
		 )
		 returns decimal (6,2)
		 as
		 begin 
		   declare @resultado decimal(6,2)
		   set @resultado=(@valor1+@valor2)/2
		   return @resultado
		 end;
*/

--Una clínica almacena los turnos para los distintos médicos en una tabla llamada "consultas" y en 
--otra tabla "medicos" los datos de los médicos.
--1- Elimine las tablas si existen:
 if object_id('consultas') is not null
  drop table consultas;
 if object_id('medicos') is not null
  drop table medicos;
go

--2- Cree las tablas con las siguientes estructuras:
 create table medicos (
  documento char(8) not null,
  nombre varchar(30),
  constraint PK_medicos 
   primary key clustered (documento)
 );

 create table consultas(
  fecha datetime,
  medico char(8) not null,
  paciente varchar(30),
  constraint PK_consultas
   primary key (fecha,medico),
  constraint FK_consultas_medico
   foreign key (medico)
   references medicos(documento)
   on update cascade
   on delete cascade
 );
 go

--3- Ingrese algunos registros:
 insert into medicos values('22222222','Alfredo Acosta');
 insert into medicos values('23333333','Pedro Perez');
 insert into medicos values('24444444','Marcela Morales');

 insert into consultas values('2007/03/26 8:00','22222222','Juan Juarez');
 insert into consultas values('2007/03/26 8:00','23333333','Gaston Gomez');
 insert into consultas values('2007/03/26 8:30','22222222','Nora Norte');
 insert into consultas values('2007/03/28 9:00','22222222','Juan Juarez');
 insert into consultas values('2007/03/29 8:00','24444444','Nora Norte');
 insert into consultas values('2007/03/24 8:30','22222222','Hector Huerta'); 
 insert into consultas values('2007/03/24 9:30','23333333','Hector Huerta');
 go
--4- Elimine la función "f_nombreDia" si existe:
 if object_id('f_nombreDia') is not null
 drop function f_nombreDia;
 go


--5- Cree la función "f_nombreDia" que recibe una fecha (tipo string) y nos retorne el nombre del día 
--en español.
create function f_nombreDia(@fecha varchar(30))
	returns varchar(10)
	as 
		begin
			declare @nombre varchar(10)
			set @nombre = 'Fecha invalida'
			if (ISDATE(@fecha) = 1)
				begin
					set @fecha = CAST(@fecha as datetime)
					set @nombre = 
						case DATENAME(WEEKDAY, @fecha)
						when 'Monday' then 'Lunes'
						when 'Tuesday' then 'Martes'
						when 'Wednesday' then 'Miercoles'
						when 'Thursday' then 'Jueves'
						when 'Friday' then 'Viernes'
						when 'Saturday' then 'Sabado'
						when 'Sunday' then 'Domingo'
				end --case
		end
		return @nombre
	end; 
 go

--6- Elimine la función "f_horario" si existe:
 if object_id('f_horario') is not null
  drop function f_horario;
go
--7- Cree la función "f_horario" que recibe una fecha (tipo string) y nos retorne la hora y minutos.
create function f_horario (@fecha varchar(30))
  returns varchar(5)
  as
  begin
    declare @nombre varchar(5)
    set @nombre='Fecha inválida'   
    if (isdate(@fecha) = 1)
    begin
      set @fecha=cast(@fecha as datetime)
      set @nombre=rtrim(cast(datepart(hour,@fecha) as char(2)))+':'
      set @nombre=@nombre+rtrim(cast(datepart(minute,@fecha) as char(2)))
    end--si es una fecha válida
    return @nombre
 end;
go
--8- Elimine la función "f_fecha" si existe:
 if object_id('f_fecha') is not null
  drop function f_fecha;
go
--9- Cree la función "f_fecha" que recibe una fecha (tipo string) y nos retorne la fecha (sin hora ni 
--minutos)
create function f_fecha (@fecha varchar(30))
  returns varchar(12)
  as
  begin
    declare @nombre varchar(12)
    set @nombre='Fecha inválida'   
    if (isdate(@fecha)=1)
		begin
		  set @fecha=cast(@fecha as datetime)
		  set @nombre=rtrim(cast(datepart(day,@fecha) as char(2)))+'/'
		  set @nombre=@nombre+rtrim(cast(datepart(month,@fecha) as char(2)))+'/'
		  set @nombre=@nombre+rtrim(cast(datepart(year,@fecha) as char(4)))
		end--si es una fecha válida
    return @nombre
 end;
 GO
--10- Muestre todas las consultas del médico llamado 'Alfredo Acosta', incluyendo el día (emplee la 
--función "f_nombreDia", la fecha (emplee la función "f_fecha"), el horario (emplee la función 
--"f_horario") y el nombre del paciente.
select dbo.f_nombredia(fecha) as dia,
  dbo.f_fecha(fecha) as fecha,
  dbo.f_horario(fecha) as horario,
  paciente
  from consultas as c
  join medicos as m
  on m.documento=c.medico
  where m.nombre='Alfredo Acosta';
  go 

--11- Muestre todos los turnos para el día sábado, junto con la fecha, de todos los médicos.
select c.fecha, m.nombre from consultas as c
join medicos as m on m.documento = c.medico where dbo.f_nombreDia(c.fecha) = 'Sabado'
go


--12- Envíe a la función "f_nombreDia" una fecha y muestre el valor retornado:
 declare @valor char(30)
 set @valor='2007/04/09'
 select dbo.f_nombreDia(@valor);