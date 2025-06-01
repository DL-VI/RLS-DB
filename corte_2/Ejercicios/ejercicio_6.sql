-- Cree una vista materializada con usuarios que tengan tareas pendientes
CREATE MATERIALIZED VIEW usuarios_tareas_pendientes AS
SELECT users."name"
FROM users
INNER JOIN tasks ON users."uid" = tasks."uid"
WHERE tasks."status" = 'pendiente';

SELECT * FROM usuarios_tareas_pendientes;
DROP MATERIALIZED VIEW usuarios_tareas_pendientes;
