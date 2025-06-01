BEGIN;

CREATE TEMPORARY TABLE tasks_medium_priority AS
SELECT
    tasks.title,
    priorities.p_name
FROM tasks
INNER JOIN priorities ON tasks.pid = priorities.pid
WHERE priorities.pid = '2';

SELECT
    p_name AS priority,
    title AS title_task
FROM tasks_medium_priority;

ROLLBACK;
