CREATE [OR REPLACE] FUNCTION
nombre_funcion([[argmodo][argnombre] argtipo [,...])
RETURN tipo AS $$
* argmodo como va a trabajar el argumento = (IN, OUT o INOUT)
entrada, salida o bidireccional por defecto es entrada.
* argnombre del parameto
* argtipo el tipo de dato
[DECLARE]
[declaraciones de variables]
BEGIN
codigo
END;
$$ LANGUAGE plpgsql
| IMMUTABLE | STABLE | VOLATILE
INMUTABLE = No se puede alterar la base de datos y no puede
hacer consultas
STABLE = No puede alterar la base de datos pero hacer consu
ltas
VOLATILE = Alterar y hacer consultas es por defecto
| CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT
CALLED ON NULL INPUT = es el valor por defecto. se ejecuta
sin los argumentos son nulos
RETURNS NULL ON NULL INPUT / STRICT = retorna nulo si algun
o de los argumentos son nulos
| [EXTERNAL] SECURITY INVOKER | [EXTERNAL] SECURITY DEFINER
SECURITY INVOKER = Es por defecto con que privilegios se va
a ejecutar el procedimiento - en este toma los privilegios de qui
en lo llama
SECURITY DEFINER = Toma los privilegios de quien lo creo
| COST execution_cost
| ROWS result_rows
| SET configuration_parameter { TO value | = value | FROM CURR
ENT }
