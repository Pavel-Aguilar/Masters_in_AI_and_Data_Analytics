/*
La base de datos tienda_tx debe incluir, como mínimo:
Tabla productos con campos: id, nombre, stock, precio.
Tabla ordenes con campos: id, cliente, producto_id, cantidad, total, estados

Las Tablas tienen los siguientes atributos que deberàs tomar en cuenta al escribir la instrucción SQL.
🗂️ Tabla productos
id → Clave primaria, tipo INT, con AUTO_INCREMENT para que cada producto se identifique de forma única y automática.
nombre → Columna de tipo VARCHAR(50), almacena el nombre del producto (máximo 50 caracteres).
stock → Columna de tipo INT, guarda la cantidad disponible en inventario.
precio → Columna de tipo DECIMAL(10,2), permite manejar valores monetarios con hasta 10 dígitos en total y 2 decimales (ej. 12345678.90).
Motor de almacenamiento: InnoDB, que soporta transacciones, bloqueos a nivel de fila y claves foráneas.

Tabla ordenes
id → Clave primaria, tipo INT, con AUTO_INCREMENT para identificar cada orden de manera única.
cliente → Columna de tipo VARCHAR(50), almacena el nombre del cliente que realiza la compra (hasta 50 caracteres).
producto_id → Columna de tipo INT, actúa como clave foránea y enlaza con el campo id de la tabla productos, garantizando la integridad referencial.
cantidad → Columna de tipo INT, almacena el número de unidades solicitadas en la orden.
total → Columna de tipo DECIMAL(10,2), guarda el monto total de la compra (precio * cantidad).
estado → Columna de tipo VARCHAR(20), permite registrar el estado de la orden (ejemplo: creada, pagada, cancelada).

Restricción: FOREIGN KEY (producto_id) asegura que solo se puedan registrar órdenes de productos existentes en la tabla productos.

Motor de almacenamiento: InnoDB, lo que asegura soporte para transacciones y mantenimiento de la integridad referencial

Inserta un producto inicial en la tabla productos. Un producto llamado Laptop, con un stock disponible de 5 unidades y un precio unitario de 1200.00.
Verifica que el producto se haya insertado correctamente ejecutando con SELECT.
START TRANSACTION: 
Inicia una transacción con START TRANSACTION.
Simula una compra de 3 laptops para el cliente “Ana”:
Verifica que el stock actual sea suficiente y usa la sentencia FOR UPDATE para bloquear la transacción: (SELECT ...... FOR UPDATE;)
Si hay stock, inserta una fila en la tabla ordenes y descuenta el stock en productos. Los valores que deberás insertar en caso de que exista stock son: Ana (la persona que realiza la compra), 1 (Producto_id que corresponde al producto Laptop), 3 (cantidad del número de órdenes solicitadas), 3600 (total) y Confirmada (que indica el estado de que la orden ha sido validada).
Si no hay stock suficiente, haz un ROLLBACK.

Finaliza la transacción con COMMIT o ROLLBACK según corresponda.
ROLLBACK: Repite el proceso para otro cliente (“Luis”), intentando comprar 4 laptops. Observa qué ocurre con el stock y aplica ROLLBACK si es necesario.*/

create database tienda_ida;
use tienda_ida;

-- Se crea la tabla productos cumpliendo con los requisitos indicados
create table productos (
id int primary key auto_increment,
nombre varchar (50),
stock int, 
precio Decimal (10,2))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
select * from productos;

-- Ahora creamos la tabla ordenes con los requisitos indicados
create table ordenes (
id int primary key auto_increment,
cliente varchar (50),
producto_id int references productos(id),
cantidad int, 
total Decimal (10,2),
estado varchar (20),
Foreign key (producto_id) references productos(id))
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
select * from ordenes;
-- =========================================================================================================================================== --
-- Se insertan 5 Laptops de $1200.00 c/u en productos
INSERT INTO productos (nombre, stock, precio)
VALUES ('Laptop', 5, 1200.00);
select * from productos;
-- =========================================================================================================================================== --
-- se cambia el delimitador temporalmente por %% para que pueda correr el codigo sin problema, y al final se indica que vuelve a la normalidad. (;)
-- Se crea una función para que tome 3 parámetros, el nombre del cliente, el id del producto y la cantidad. El costo se toma de la tabla productos, para calcular el total a pagar.
-- De esta forma nos aseguramos que sea cual sea la cantidad que se pida, el costo va a ser correcto. Y para actualizarlo solo basta con un update.
DELIMITER $$
CREATE PROCEDURE compra(
    IN p_cliente VARCHAR(50),
    IN p_producto_id INT,
    IN p_cantidad INT)
    
BEGIN
    DECLARE stock_actual INT;
    DECLARE precio_unit DECIMAL(10,2);

    START TRANSACTION;
    
    -- Se localiza la fila del producto
    SELECT stock, precio INTO stock_actual, precio_unit
    FROM productos
    WHERE id = p_producto_id
    FOR UPDATE;
    
    IF stock_actual >= p_cantidad THEN
        -- Se inserta la orden
        INSERT INTO ordenes (cliente, producto_id, cantidad, total, estado)
        VALUES (p_cliente, p_producto_id, p_cantidad, precio_unit * p_cantidad, 'Confirmada');

        -- Se descuenta el stock en su caso, si no se aplica rollback
        UPDATE productos
        SET stock = stock - p_cantidad
        WHERE id = p_producto_id;

        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END$$
DELIMITER ;
CALL compra('Ana', 1, 3);
select * from ordenes;
select * from productos;

CALL compra('Luis', 1, 4);
select * from ordenes;
select * from productos;

-- No se acepta stock negativo, de ser así no se realiza la venta.
-- Probé cambiando de costo y agotando el stock con una venta extra
/*UPDATE productos SET precio = 1500 WHERE id = 1;
CALL compra('Javier', 1, 2);
select * from ordenes;
select * from productos;*/

-- La tabla de ordenes guarda el total historico que se paga por cada venta, por lo que si se hace un cambio a los costos no influye en los registros de ventas anteriores.
-- Drop database tienda_ida;