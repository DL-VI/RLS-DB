-- CASO 1: CONTROL AUTOMATICO DE INVENTARIO

/*
PROBLEMA:
Cuando se confirma una comanda (cambia de estado 'preparation' a 'served'), 
los ingredientes necesarios deben descontarse automaticamente del inventario 
(campo stock de la tabla ingredients). Sin esto, el inventario no refleja 
el consumo real y puede haber problemas de desabastecimiento.

SOLUCION:
Crear un trigger que se active cuando el estado de una comanda cambie a 'served'
y descuente automaticamente los ingredientes del stock.
*/

-- Funcion para descontar ingredientes del inventario
CREATE OR REPLACE FUNCTION descont_ingredients_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo procesa si el estado cambio a 'served'
    IF NEW.state = 'served' AND OLD.state != 'served' THEN
        -- Descontar ingredientes de todos los platos de la comanda
        UPDATE menu.ingredients 
        SET stock = stock - (
            SELECT COALESCE(SUM(di.quantity * dc.quantity), 0)
            FROM orders.dish_commands dc
            INNER JOIN menu.dish_ingredients di ON dc.dish_id = di.dish_id
            WHERE dc.command_id = NEW.command_id 
            AND di.ingredient_id = ingredients.ingredient_id
        )
        WHERE ingredient_id IN (
            SELECT DISTINCT di.ingredient_id
            FROM orders.dish_commands dc
            INNER JOIN menu.dish_ingredients di ON dc.dish_id = di.dish_id
            WHERE dc.command_id = NEW.command_id
        );
        
        -- Marcar ingredientes como no disponibles si stock <= 0
        UPDATE menu.ingredients 
        SET available = FALSE 
        WHERE stock <= 0;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trigger_update_inventory
    AFTER UPDATE ON orders.commands
    FOR EACH ROW
    EXECUTE FUNCTION descont_ingredients_stock();


-- CASO 2: CALCULO AUTOMATICO DE TOTALES EN FACTURAS

/*
PROBLEMA:
Cada vez que se crea una factura, se debe calcular automaticamente el total
sumando todos los platos de la comanda multiplicados por sus cantidades y precios.
Sin automatizacion, esto requiere calculos manuales propensos a errores y
puede generar inconsistencias en la facturacion.

SOLUCION:
Crear un trigger que calcule automaticamente el total de la factura
antes de insertarla, basandose en los platos de la comanda asociada.
*/

-- Funcion para calcular total de factura automaticamente
CREATE OR REPLACE FUNCTION calculate_invoice_total()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcular el total basado en los platos de la comanda
    SELECT COALESCE(SUM(d.price * dc.quantity), 0)
    INTO NEW.total
    FROM orders.dish_commands dc
    INNER JOIN menu.dishes d ON dc.dish_id = d.dish_id
    WHERE dc.command_id = NEW.command_id;
    
    -- Si no hay platos, establecer total en 0
    IF NEW.total IS NULL THEN
        NEW.total := 0;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trigger_calculate_invoice_total
    BEFORE INSERT ON billing.invoices
    FOR EACH ROW
    EXECUTE FUNCTION calculate_invoice_total();


-- CASO 3: GESTION AUTOMATICA DEL ESTADO DE MESAS

/*
PROBLEMA:
El estado de las mesas debe actualizarse automaticamente segun las comandas:
- Cuando se crea una comanda, la mesa debe marcarse como 'occupied'
- Cuando una comanda se cierra ('closed'), la mesa debe volver a 'free'
- Sin automatizacion, las mesas pueden quedarse marcadas como ocupadas
  indefinidamente o liberarse prematuramente, causando confusion operativa.

SOLUCION:
Crear triggers que actualicen automaticamente el estado de las mesas
cuando se crean nuevas comandas o cuando cambia el estado de comandas existentes.
*/

-- Funcion para actualizar estado de mesa cuando se crea comanda
CREATE OR REPLACE FUNCTION update_table_status_on_new_command()
RETURNS TRIGGER AS $$
BEGIN
    -- Marcar mesa como ocupada cuando se crea una nueva comanda
    UPDATE orders.tables 
    SET state = 'occupied' 
    WHERE table_id = NEW.table_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Funcion para actualizar estado de mesa cuando cambia estado de comanda
CREATE OR REPLACE FUNCTION update_table_status_on_command_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Si la comanda se cierra, liberar la mesa
    IF NEW.state = 'closed' AND OLD.state != 'closed' THEN
        UPDATE orders.tables 
        SET state = 'free' 
        WHERE table_id = NEW.table_id;
    END IF;
    
    -- Si se reabre una comanda cerrada, ocupar la mesa nuevamente
    IF OLD.state = 'closed' AND NEW.state != 'closed' THEN
        UPDATE orders.tables 
        SET state = 'occupied' 
        WHERE table_id = NEW.table_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER trigger_occupy_table_on_new_command
    AFTER INSERT ON orders.commands
    FOR EACH ROW
    EXECUTE FUNCTION update_table_status_on_new_command();

CREATE TRIGGER trigger_update_table_on_command_change
    AFTER UPDATE ON orders.commands
    FOR EACH ROW
    EXECUTE FUNCTION update_table_status_on_command_change();