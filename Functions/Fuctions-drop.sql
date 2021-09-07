/*
	Sintaxis:

	 drop function NOMBREPPROPIETARIO.NOMBREFUNCION;

	 Si la función que se intenta eliminar no existe, aparece un mensaje indicándolo, 
	 para evitarlo, podemos verificar su existencia antes de solicitar su eliminación 
	 (como con cualquier otro objeto):

	 if object_id('NOMBREPROPIETARIO.NOMBREFUNCION') is not null
	  drop function NOMBREPROPIETARIO.NOMBREFUNCION;
	Eliminamos, si existe, la función denominada "f_fechacadena":

	 if object_id('dbo.f_fechacadena') is not null
	  drop function dbo.f_fechacadena; 
*/





/* 
	MODIFY FUNCTIONS

		alter function PROPIETARIO.NOMBREFUNCION
	 NUEVADEFINICION;

	 Sintaxis para modificar funciones escalares:

	 alter function PROPIETARIO.NOMBREFUNCION
	 (@PARAMETRO TIPO=VALORPORDEFECTO) 
	  returns TIPO
	  as
	  begin
	   CUERPO
	   return EXPRESIONESCALAR
	  end


	  Sintaxis para modificar una función de varias instrucciones que retorna una tabla:

		 alter function NOMBREFUNCION
		  (@PARAMETRO TIPO=VALORPORDEFECTO) 
		  returns @VARIABLE table
		  (DEFINICION DE LA TABLA A RETORNAR)
		  as
		  begin
			CUERPO DE LA FUNCION
			return
		  end


		  Sintaxis para modificar una función con valores de tabla en línea

		 alter function NOMBREFUNCION
		 (@PARAMETRO TIPO) 
		 returns TABLE
		 as
		  return (SENTENCIAS SELECT) 
*/






/* 

	ENCRYPTION
	create function NOMBREFUNCION
	 (@PARAMETRO TIPO) 
	  returns TIPO
	  with encryption
	  as 
	  begin
	   CUERPO
	   return EXPRESION
	  end


*/