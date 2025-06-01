-- Cree una función que devuelva el nombre de la persona junto con su tarea. 

CREATE OR REPLACE FUNCTION mostrar_usuario_tarea(IN nombre_ingresado TEXT, OUT nombre TEXT, OUT tarea TEXT) AS $$
BEGIN
    SELECT
        users.name,
        tasks.title
    INTO nombre, tarea
    FROM users
    INNER JOIN tasks ON users."uid" = tasks."uid"
    WHERE users."name" = nombre_ingresado
    LIMIT 1;
END
$$ LANGUAGE plpgsql;

SELECT * FROM mostrar_usuario_tarea('Ana Torres');
