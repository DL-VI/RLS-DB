-- Cree una transacción que permita clonar
-- las tareas y sean asignadas a otro usuario.

BEGIN;
INSERT INTO tasks (title, summary, status, created_date, "uid", pid)
SELECT
    title,
    summary,
    "status",
    created_date,
    "uid",
    pid
FROM tasks
WHERE "uid" = 2 AND tid = 6;
SELECT * FROM tasks;

UPDATE tasks SET "uid" = 3
WHERE "uid" = 2 AND tid = 21;
SELECT * FROM tasks;
ROLLBACK;
