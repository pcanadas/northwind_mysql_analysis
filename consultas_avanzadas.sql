-- Análisis de ventas por categoría de producto
-- Agrupamos las ventas por categoría de producto usando JOIN, GROUP BY y HAVING

SELECT 
    c.categoryName, 
    SUM(od.quantity * od.unitPrice) AS total_sales
FROM order_detail od
JOIN product p ON od.productId = p.entityId
JOIN category c ON p.categoryId = c.entityId
GROUP BY c.categoryName
HAVING total_sales > 10000  -- Solo categorías con ventas mayores a 10.000
ORDER BY total_sales DESC;


-- Clientes con más pedidos
-- Contamos los pedidos por cliente y ordenamos de mayor a menor

SELECT 
    c.entityId, 
    c.companyName, 
    COUNT(so.entityId) AS total_orders
FROM customer c
JOIN sales_order so ON c.entityId = so.customerId
GROUP BY c.entityId, c.companyName
ORDER BY total_orders DESC
LIMIT 10;  -- Top 10 clientes con más pedidos

-- Uso de CTE (Common Table Expressions)
-- Encontramos los productos más vendidos usando una CTE

WITH product_sales AS (
    SELECT 
        p.productName, 
        SUM(od.quantity) AS total_units_sold
    FROM order_detail od
    JOIN product p ON od.productId = p.entityId
    GROUP BY p.productName
)
SELECT * FROM product_sales 
ORDER BY total_units_sold DESC 
LIMIT 10;  -- Top 10 productos más vendidos

-- Análisis de ventas por mes
-- Agrupamos las ventas por mes y año

SELECT 
    EXTRACT(YEAR FROM so.orderDate) AS year, 
    EXTRACT(MONTH FROM so.orderDate) AS month, 
    SUM(od.quantity * od.unitPrice) AS total_sales
FROM sales_order so
JOIN order_detail od ON so.entityId = od.orderId
GROUP BY year, month;

-- Uso de Funciones de Ventana (WINDOW FUNCTIONS)
-- Obtenemos el ranking de empleados por total de ventas

SELECT 
    e.entityId, 
    e.firstname, 
    e.lastname, 
    e.title,
    SUM(od.quantity * od.unitPrice) AS total_sales,
    RANK() OVER (ORDER BY SUM(od.quantity * od.unitPrice) DESC) AS sales_rank
FROM employee e
JOIN sales_order so ON e.entityId = so.employeeId
JOIN order_detail od ON so.entityId = od.orderId
GROUP BY e.entityId, e.firstname, e.lastname, e.title
ORDER BY sales_rank asc;

-- Consulta con CASE WHEN
-- Clasificamos las categorías de productos en base a sus ventas totales

SELECT 
    c.categoryName, 
    SUM(od.quantity * od.unitPrice) AS total_sales,
    CASE 
        WHEN SUM(od.quantity * od.unitPrice) < 120000 THEN 'Baja'
        WHEN SUM(od.quantity * od.unitPrice) BETWEEN 100000 AND 200000 THEN 'Media'
        ELSE 'Alta'
    END AS sales_category
FROM order_detail od
JOIN product p ON od.productId = p.entityId
JOIN category c ON p.categoryId = c.entityId
GROUP BY c.categoryName
ORDER BY total_sales DESC;