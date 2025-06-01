-- iMPRIMIR POR  MEDIO DE UN CURSOR TODAS
-- LAS TAREAS QUE TENGA PRIORIDAD BAJA. HACER 
-- UNA DE MODO IMPLICITO Y OTRA EXPLICITO, DIGITANDO LA PRIORIDAD

-- ejercicios manera explicita
DO $$
DECLARE
  curs1 CURSOR FOR SELECT * FROM tasks WHERE pid = 2;
  fila RECORD;
BEGIN
  OPEN curs1;
  LOOP
    FETCH curs1 INTO fila;
    EXIT WHEN NOT FOUND;
    RAISE NOTICE 'tareas priodad baja: %', fila.title;
  END LOOP;
  CLOSE curs1;
END;
$$ LANGUAGE plpgsql;

-- ejercicio realizado de manera implicita
DO $$
DECLARE
  fila RECORD;
BEGIN
  FOR fila IN
     SELECT title, pid FROM tasks WHERE pid = 2
  LOOP
     RAISE NOTICE 'Título: %, PID: %', fila.title, fila.pid;
  END LOOP;
END;
$$ LANGUAGE plpgsql;
