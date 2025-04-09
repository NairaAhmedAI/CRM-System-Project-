 -- Customers Table
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT,
    address TEXT
);

-- Products Table
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    price DECIMAL(10,2),
    stock_quantity INTEGER
);

-- Orders Table
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    status TEXT CHECK(status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    payment_date DATE,
    amount_paid DECIMAL(10,2),
    method TEXT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO Customers (customer_id, name, email, phone, address) VALUES
(1, 'Ahmed El-Sayed', 'ahmed@example.com', '01012345678', 'Cairo'),
(2, 'Sara Abdallah', 'sara@example.com', '01098765432', 'Alexandria'),
(3, 'Mohamed El-Gohary', 'mohamed@example.com', '01111222333', 'Mansoura'),
(4, 'Mona Khaled', 'mona@example.com', '01234567890', 'Tanta');

INSERT INTO Products (product_id, name, category, price, stock_quantity) VALUES
(1, 'Samsung A54 Phone', 'Mobiles', 8500.00, 20),
(2, 'HP Laptop i5', 'Electronics', 15000.00, 10),
(3, 'JBL Bluetooth Speaker', 'Accessories', 750.00, 30),
(4, 'Fast Charger Type-C', 'Accessories', 200.00, 50);

INSERT INTO Orders (order_id, customer_id, order_date, status) VALUES
(1, 1, '2024-03-15', 'Delivered'),
(2, 2, '2024-03-20', 'Shipped'),
(3, 3, '2024-03-25', 'Pending'),
(4, 4, '2024-03-28', 'Cancelled');

INSERT INTO OrderDetails (order_detail_id, order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1, 8500.00),
(2, 1, 4, 2, 200.00),
(3, 2, 2, 1, 15000.00),
(4, 3, 3, 2, 750.00);

INSERT INTO Payments (payment_id, order_id, payment_date, amount_paid, method) VALUES
(1, 1, '2024-03-15', 8900.00, 'Credit Card'),
(2, 2, '2024-03-21', 15000.00, 'Bank Transfer');

SELECT 
    c.name AS customer_name,
    SUM(od.quantity * od.price) AS total_sales
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY c.customer_id;


SELECT 
    p.name AS product_name,
    SUM(od.quantity) AS total_sold
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC;

SELECT 
    o.order_id,
    c.name AS customer_name,
    o.order_date,
    o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

SELECT 
    SUM(od.quantity * od.price) AS total_revenue
FROM OrderDetails od;

SELECT 
    o.order_id,
    o.status,
    COUNT(o.order_id) AS number_of_orders
FROM Orders o
GROUP BY o.status;

