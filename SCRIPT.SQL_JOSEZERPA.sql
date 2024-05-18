
CREATE DATABASE tienda_ropa_online;
USE tienda_ropa_online;


CREATE TABLE clientes (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(100),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20)
);


CREATE TABLE productos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion TEXT,
    precio DECIMAL(10, 2),
    categoria VARCHAR(50),
    stock INT
);


CREATE TABLE pedidos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    fecha DATE,
    estado VARCHAR(50),
    total DECIMAL(10, 2),
    FOREIGN KEY (ID_cliente) REFERENCES clientes(ID)
);


CREATE TABLE ventas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT,
    ID_producto INT,
    cantidad INT,
    precio_venta DECIMAL(10, 2),
    FOREIGN KEY (ID_pedido) REFERENCES pedidos(ID),
    FOREIGN KEY (ID_producto) REFERENCES productos(ID)
);


INSERT INTO clientes (nombre, apellido, direccion, correo_electronico, telefono) VALUES
('Juan', 'Perez', 'Calle Falsa 123', 'juan.perez@example.com', '123456789'),
('Maria', 'Gomez', 'Avenida Siempre Viva 456', 'maria.gomez@example.com', '987654321');

INSERT INTO productos (nombre, descripcion, precio, categoria, stock) VALUES
('Camiseta Blanca', 'Camiseta de algodón blanca', 20.00, 'Camisetas', 100),
('Pantalón Vaquero', 'Pantalón de mezclilla', 40.00, 'Pantalones', 50);

INSERT INTO pedidos (ID_cliente, fecha, estado, total) VALUES
(1, CURDATE(), 'Completado', 60.00),
(2, DATE_SUB(CURDATE(), INTERVAL 35 DAY), 'Pendiente', 40.00);

INSERT INTO ventas (ID_pedido, ID_producto, cantidad, precio_venta) VALUES
(1, 1, 2, 20.00),
(1, 2, 1, 40.00);




SELECT nombre, apellido, direccion, correo_electronico
FROM clientes
WHERE ID IN (SELECT ID_cliente FROM pedidos WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY));


SELECT productos.nombre, SUM(ventas.cantidad) AS total_vendido
FROM productos
JOIN ventas ON productos.ID = ventas.ID_producto
JOIN pedidos ON ventas.ID_pedido = pedidos.ID
WHERE pedidos.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY productos.nombre
ORDER BY total_vendido DESC;


SELECT clientes.nombre, clientes.apellido, COUNT(pedidos.ID) AS total_pedidos
FROM clientes
JOIN pedidos ON clientes.ID = pedidos.ID_cliente
WHERE pedidos.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY clientes.ID
ORDER BY total_pedidos DESC;


UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Camisetas';


DELETE FROM pedidos
WHERE ID NOT IN (SELECT ID_pedido FROM ventas);


CREATE VIEW vista_clientes_pedidos AS
SELECT clientes.nombre, clientes.apellido, pedidos.fecha, pedidos.total
FROM clientes
JOIN pedidos ON clientes.ID = pedidos.ID_cliente;
