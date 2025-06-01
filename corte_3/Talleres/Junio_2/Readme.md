# 📌 Disparadores (Triggers) en PostgreSQL

## ✅ ¿Qué son y para qué sirven?

Los **disparadores** (*triggers*) en PostgreSQL son mecanismos que permiten ejecutar automáticamente una función cuando ocurre un evento determinado en una tabla o vista, como:

- `INSERT`
- `UPDATE`
- `DELETE`
- `TRUNCATE`

Se usan para:

- Aplicar **reglas de negocio** de forma automática.
- Mantener la **integridad** y consistencia de los datos.
- Realizar **auditorías**.
- Automatizar tareas como actualización de otras tablas, envío de notificaciones, etc.

---

## ⚖️ Ventajas y desventajas

### ✅ Ventajas

- 🔁 Automatización de tareas.
- 🧩 Centralización de lógica de negocio en la base de datos.
- 🔐 Mejora la integridad de los datos.
- 📝 Útiles para auditoría y registro de cambios.

### ❌ Desventajas

- ⚠️ Añaden complejidad al sistema.
- 🐢 Pueden afectar el rendimiento si se usan en exceso.
- 🕵️ Dificultan la depuración y el rastreo de errores.
- 🔄 Puede haber efectos secundarios no evidentes.

---

## 🛠️ Sintaxis y uso

### 1. Crear una función de disparador

Antes de crear un disparador, se define una función que contiene la lógica a ejecutar. Esta debe retornar `trigger`.

```sql
CREATE OR REPLACE FUNCTION nombre_funcion()
RETURNS trigger AS $$
BEGIN
  -- Lógica del disparador
  RETURN NEW; -- o RETURN OLD;
END;
$$ LANGUAGE plpgsql;
```

### 2. Crear el disparador

Una vez definida la función, se crea el disparador asociado a la tabla.

```bash
CREATE TRIGGER nombre_disparador
{BEFORE | AFTER | INSTEAD OF} {INSERT | UPDATE | DELETE}
ON nombre_tabla
[FOR EACH ROW | FOR EACH STATEMENT]
[WHEN (condición)]
EXECUTE FUNCTION nombre_funcion();
```

### 📌 Parámetros clave:

- *BEFORE* o *AFTER*: cuándo se ejecuta el trigger.
- *INSERT*, *UPDATE*, *DELETE*: evento que activa el trigger.
- *FOR EACH ROW*: el trigger se ejecuta por cada fila afectada.
- *FOR EACH STATEMENT*: se ejecuta una vez por sentencia.
- *WHEN (condición)*: opcional, para aplicar lógica condicional.
