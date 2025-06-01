-- Cree una transacción que permita cerrar
-- las tareas que ya ha expirado por fecha

BEGIN;
UPDATE tasks SET limit_date = '2025-06-02'
WHERE tid = 6;
UPDATE tasks SET limit_date = '2025-05-09'
WHERE tid = 9;
UPDATE tasks SET limit_date = '2025-06-09'
WHERE tid = 8;
UPDATE tasks SET limit_date = '2025-05-30'
WHERE tid = 7;

UPDATE tasks SET status = 'cerrada'
WHERE created_date > limit_date AND status != 'completada';
SELECT * FROM tasks;
ROLLBACK;
