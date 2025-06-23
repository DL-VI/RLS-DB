-- Crear la base de datos
CREATE DATABASE restaurant_management;

-- Conectar a la base de datos
\c restaurant_management;

-- Crear los esquemas
CREATE SCHEMA IF NOT EXISTS menu;
CREATE SCHEMA IF NOT EXISTS orders;
CREATE SCHEMA IF NOT EXISTS billing;


-- ESQUEMA MENU

-- Tabla de categorías
CREATE TABLE menu.categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Tabla de ingredientes
CREATE TABLE menu.ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    stock INTEGER DEFAULT 0,
    available BOOLEAN DEFAULT TRUE,
    unit_cost DECIMAL(10,2)
);

-- Tabla de platos
CREATE TABLE menu.dishes (
    dish_id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES menu.categories(category_id)
);

-- Tabla de relación platos-ingredientes (muchos a muchos)
CREATE TABLE menu.dish_ingredients (
    dish_id INTEGER NOT NULL,
    ingredient_id INTEGER NOT NULL,
    quantity DECIMAL(8,2), -- cantidad del ingrediente necesaria para el plato
    PRIMARY KEY (dish_id, ingredient_id),
    FOREIGN KEY (dish_id) REFERENCES menu.dishes(dish_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES menu.ingredients(ingredient_id)
);


-- ESQUEMA ORDERS

-- Tabla de meseros/bartenders
CREATE TABLE orders.bartenders (
    bartender_id SERIAL PRIMARY KEY,
    document VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100)
);

-- Tabla de mesas
CREATE TABLE orders.tables (
    table_id SERIAL PRIMARY KEY,
    number INTEGER UNIQUE NOT NULL,
    capacity INTEGER NOT NULL,
    state VARCHAR(20) DEFAULT 'free' CHECK (state IN ('free', 'occupied', 'reserved'))
);

-- Tabla de comandas/órdenes
CREATE TABLE orders.commands (
    command_id SERIAL PRIMARY KEY,
    table_id INTEGER NOT NULL,
    bartender_id INTEGER NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    state VARCHAR(20) DEFAULT 'preparation' CHECK (state IN ('preparation', 'served', 'closed')),
    FOREIGN KEY (table_id) REFERENCES orders.tables(table_id),
    FOREIGN KEY (bartender_id) REFERENCES orders.bartenders(bartender_id)
);

-- Tabla de detalle de comandas (platos por comanda)
CREATE TABLE orders.dish_commands (
    dish_id INTEGER NOT NULL,
    command_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (dish_id, command_id),
    FOREIGN KEY (dish_id) REFERENCES menu.dishes(dish_id),
    FOREIGN KEY (command_id) REFERENCES orders.commands(command_id) ON DELETE CASCADE
);


-- ESQUEMA BILLING

-- Tabla de facturas
CREATE TABLE billing.invoices (
    invoice_id SERIAL PRIMARY KEY,
    command_id INTEGER NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL,
    payment_form VARCHAR(20) DEFAULT 'cash' CHECK (payment_form IN ('cash', 'credit_card', 'check')),
    FOREIGN KEY (command_id) REFERENCES orders.commands(command_id)
);


-- DATOS DE EJEMPLO

-- Insertar categorías de ejemplo
INSERT INTO menu.categories (name, description) VALUES
('Entradas', 'Platos para comenzar la comida'),
('Platos Principales', 'Platos fuertes del menú'),
('Postres', 'Dulces y postres'),
('Bebidas', 'Bebidas frías y calientes');

-- Insertar ingredientes de ejemplo
INSERT INTO menu.ingredients (name, stock, available, unit_cost) VALUES
('Tomate', 50, TRUE, 0.50),
('Lechuga', 30, TRUE, 0.30),
('Pollo', 20, TRUE, 5.00),
('Arroz', 100, TRUE, 0.20),
('Queso', 25, TRUE, 2.00);

-- Insertar mesas de ejemplo
INSERT INTO orders.tables (number, capacity, state) VALUES
(1, 4, 'free'),
(2, 2, 'free'),
(3, 6, 'free'),
(4, 4, 'occupied'),
(5, 8, 'reserved');

-- Insertar bartenders de ejemplo
INSERT INTO orders.bartenders (document, name, last_name, phone, email) VALUES
('12345678', 'Juan', 'Pérez', '555-0101', 'juan.perez@restaurant.com'),
('87654321', 'María', 'González', '555-0102', 'maria.gonzalez@restaurant.com'),
('11223344', 'Carlos', 'Rodríguez', '555-0103', 'carlos.rodriguez@restaurant.com');

-- Insertar platos de ejemplo
INSERT INTO menu.dishes (category_id, name, description, price, available) VALUES
(1, 'Ensalada César', 'Lechuga, pollo, queso parmesano y aderezo césar', 12.50, TRUE),
(2, 'Pollo a la Plancha', 'Pechuga de pollo con arroz y ensalada', 18.00, TRUE),
(2, 'Arroz con Pollo', 'Arroz amarillo con pollo y vegetales', 15.50, TRUE),
(3, 'Tiramisú', 'Postre italiano con café y mascarpone', 8.00, TRUE),
(4, 'Jugo Natural', 'Jugo de frutas frescas', 4.50, TRUE);

-- Insertar relaciones plato-ingrediente de ejemplo
INSERT INTO menu.dish_ingredients (dish_id, ingredient_id, quantity) VALUES
(1, 2, 100.00), -- Ensalada César - Lechuga
(1, 3, 150.00), -- Ensalada César - Pollo
(1, 5, 50.00),  -- Ensalada César - Queso
(2, 3, 200.00), -- Pollo a la Plancha - Pollo
(2, 2, 80.00),  -- Pollo a la Plancha - Lechuga
(2, 4, 150.00), -- Pollo a la Plancha - Arroz
(3, 3, 180.00), -- Arroz con Pollo - Pollo
(3, 4, 200.00), -- Arroz con Pollo - Arroz
(3, 1, 50.00);  -- Arroz con Pollo - Tomate

-- Crear una comanda de ejemplo
INSERT INTO orders.commands (table_id, bartender_id, date, state) VALUES
(1, 1, '2025-06-01 19:30:00', 'served');

-- Agregar platos a la comanda
INSERT INTO orders.dish_commands (dish_id, command_id, quantity) VALUES
(1, 1, 2), -- 2 Ensaladas César
(2, 1, 1), -- 1 Pollo a la Plancha
(5, 1, 3); -- 3 Jugos Naturales

-- Crear factura de ejemplo
INSERT INTO billing.invoices (command_id, date, total, payment_form) VALUES
(1, '2025-06-01 20:15:00', 56.50, 'credit_card');