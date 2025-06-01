-- Cree una tabla temporal con toda la información de las tareas. 

CREATE TEMPORARY TABLE informacion_tareas AS SELECT * FROM tasks;
SELECT * FROM informacion_tareas;
DROP TABLE informacion_tareas;
