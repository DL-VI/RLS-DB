# 🎯 Disparadores (Triggers) en PostgreSQL  

## 📌 Introducción  
Los **triggers** en PostgreSQL permiten ejecutar automáticamente una función cuando ocurre un evento en una tabla o vista, como:  
✅ `INSERT`  
✅ `UPDATE`  
✅ `DELETE`  
✅ `TRUNCATE`  

### 🔎 ¿Por qué utilizarlos?  
✔ Automatización de reglas de negocio.  
✔ Integridad y consistencia de los datos.  
✔ Auditoría de cambios.  
✔ Automatización de procesos internos (notificaciones, actualización de otras tablas, etc.).  

---

## ⚖️ Pros y Contras  

| ✅ Ventajas | ❌ Desventajas |
|------------|--------------|
| 🔄 Automatización eficiente. | ⚠️ Aumenta la complejidad. |
| 🛠 Centralización de lógica de negocio. | 🐢 Puede afectar el rendimiento si se abusa. |
| 🔒 Mayor control sobre la integridad de datos. | 🔎 Dificulta la depuración. |
| 📜 Útil para auditorías. | 🔄 Puede generar efectos secundarios inesperados. |

---

## ⚙️ Implementación  

### 🔧 Paso 1: Crear una función de disparador  
La función contiene la lógica a ejecutar y debe retornar `trigger`.  

```sql
CREATE OR REPLACE FUNCTION nombre_funcion() 
RETURNS trigger AS $$
BEGIN
  -- Aquí va la lógica del disparador
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

- BEFORE | AFTER | INSTEAD OF → Indica cuándo se ejecuta el trigger.
- INSERT, UPDATE, DELETE → Define el evento que lo activa.
- FOR EACH ROW → Se ejecuta por cada fila afectada.
- FOR EACH STATEMENT → Se ejecuta una vez por sentencia.
- WHEN (condición) → Opcional, permite aplicar lógica condicional.
