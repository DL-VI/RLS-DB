# 📘 Consulta de Operadores Lógicos y Relacionales en MongoDB

Este documento tiene como propósito facilitar la comprensión y aplicación práctica de los operadores lógicos y relacionales en MongoDB, pilares fundamentales del lenguaje de consultas en este motor NoSQL ampliamente utilizado a nivel global.

A través del uso de estos operadores, se podrán construir filtros precisos, realizar búsquedas avanzadas y manejar múltiples condiciones dentro de documentos en formato JSON.

---

## 🔹 Operadores Lógicos

Los operadores lógicos permiten combinar múltiples condiciones en una sola consulta.

| Operador | Descripción | Ejemplo |
|----------|-------------|---------|
| `$and`   | Devuelve los documentos que cumplen todas las condiciones especificadas. | `{ $and: [ { edad: { $gt: 18 } }, { activo: true } ] }` |
| `$or`    | Devuelve los documentos que cumplen al menos una de las condiciones. | `{ $or: [ { ciudad: "Bogotá" }, { ciudad: "Medellín" } ] }` |
| `$nor`   | Devuelve los documentos que no cumplen ninguna de las condiciones. | `{ $nor: [ { estado: "activo" }, { edad: { $lt: 18 } } ] }` |
| `$not`   | Niega el resultado de una expresión. Se usa junto con operadores relacionales. | `{ edad: { $not: { $gt: 30 } } }` |

---

## 🔸 Operadores Relacionales (Comparación)

Se utilizan para comparar valores dentro de los documentos.

| Operador | Descripción | Ejemplo |
|----------|-------------|---------|
| `$eq`    | Igual a. Devuelve documentos donde el valor sea igual al especificado. | `{ edad: { $eq: 25 } }` |
| `$ne`    | Distinto de. Devuelve documentos donde el valor no sea igual al especificado. | `{ estado: { $ne: "activo" } }` |
| `$gt`    | Mayor que. | `{ salario: { $gt: 1000000 } }` |
| `$gte`   | Mayor o igual que. | `{ edad: { $gte: 18 } }` |
| `$lt`    | Menor que. | `{ edad: { $lt: 30 } }` |
| `$lte`   | Menor o igual que. | `{ stock: { $lte: 10 } }` |
| `$in`    | El valor está en un arreglo de posibles valores. | `{ ciudad: { $in: ["Cali", "Barranquilla"] } }` |
| `$nin`   | El valor **no** está en un arreglo de posibles valores. | `{ tipo: { $nin: ["admin", "moderador"] } }` |

---

## 📦 Backup

Se incluyen archivos `.json` exportados desde **MongoDB Compass** para las siguientes colecciones:

- `operadores`: operadores lógicos individuales.
- `combinaciones`: combinaciones de operadores (lógicos y de comparación).

---

## 🔄 Restaurar la Base de Datos desde MongoDB Compass

### ✅ Pasos:

1. Crea una nueva base de datos.
2. Crea las colecciones necesarias:
   - `operadores`
   - `combinaciones`
3. En cada colección:
   - Haz clic en **"Import Data"**
   - Selecciona el archivo `.json` correspondiente
   - Asegúrate de que la extension sea de tipo **JSON**
   - Repite para cada colección

---

## 🔍 Consultas de ejemplo

### 📌 1. Consultar un operador lógico específico

```js
db.operadores.findOne({ operador: "$and" })
```

---

### 📌 2. Consultar todos los operadores lógicos disponibles

```js
db.operadores.find({})
```

---

### 📌 3. Consultar una combinación específica de operadores lógicos

```js
db.operadoresCombinaciones.find({
  operadores: { $all: ["$and", "$or"] }
})
```

---

## 💡 Ejemplo de documento en la colección `operadores`

```json
{
  "operador": "$and",
  "descripcion": "Devuelve true si TODOS los subcriterios se cumplen",
  "sintaxis": {
    "forma": "$and: [ <cond1>, <cond2>, ... ]"
  },
  "ejemplo": {
    "consulta": {
      "$and": [
        { "edad": { "$gt": 18 } },
        { "activo": true }
      ]
    },
    "explicación": "Personas mayores de 18 y activas"
  }
}
```

---

## 💡 Ejemplo de documento en la colección `combinaciones`

```json
{
  "operadores": ["$gt", "$lt"],
  "descripcion": "Rango entre dos valores",
  "sintaxis": {
    "forma": "{ campo: { $gt: valor1, $lt: valor2 } }"
  },
  "ejemplo": {
    "consulta": { "edad": { "$gt": 18, "$lt": 30 } },
    "explicación": "Personas entre 19 y 29 años"
  }
}
```