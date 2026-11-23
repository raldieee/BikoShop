DROP DATABASE IF EXISTS biko_ordering_inventory;
CREATE DATABASE biko_ordering_inventory
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE biko_ordering_inventory;


CREATE TABLE `Customer` (
    customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (customer_id),
    UNIQUE KEY uq_customer_phone (phone)
) ENGINE=InnoDB;

CREATE TABLE `Employee` (
    employee_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    PRIMARY KEY (employee_id)
) ENGINE=InnoDB;

CREATE TABLE `Category` (
    category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_category_name (category_name)
) ENGINE=InnoDB;

CREATE TABLE `Supplier` (
    supplier_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY (supplier_id)
) ENGINE=InnoDB;


CREATE TABLE `Product` (
    product_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_id INT UNSIGNED NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (product_id),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES `Category` (category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;



CREATE TABLE `Order` (
    order_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED NOT NULL,
    employee_id INT UNSIGNED NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) NOT NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES `Customer` (customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_order_employee
        FOREIGN KEY (employee_id)
        REFERENCES `Employee` (employee_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE `Order_Detail` (
    order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_detail_order
        FOREIGN KEY (order_id)
        REFERENCES `Order` (order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_order_detail_product
        FOREIGN KEY (product_id)
        REFERENCES `Product` (product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE `Payment` (
    payment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id INT UNSIGNED NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    PRIMARY KEY (payment_id),
    UNIQUE KEY uq_payment_order (order_id),
    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES `Order` (order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE `Inventory` (
    inventory_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id INT UNSIGNED NOT NULL,
    quantity_on_hand INT UNSIGNED NOT NULL DEFAULT 0,
    reorder_level INT UNSIGNED NOT NULL DEFAULT 0,
    last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (inventory_id),
    UNIQUE KEY uq_inventory_product (product_id),
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES `Product` (product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE `Purchase` (
    purchase_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    supplier_id INT UNSIGNED NOT NULL,
    employee_id INT UNSIGNED NOT NULL,
    purchase_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    purchase_status VARCHAR(30) NOT NULL,
    PRIMARY KEY (purchase_id),
    CONSTRAINT fk_purchase_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES `Supplier` (supplier_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_purchase_employee
        FOREIGN KEY (employee_id)
        REFERENCES `Employee` (employee_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;



CREATE TABLE `Purchase_Detail` (
    purchase_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (purchase_id, product_id),
    CONSTRAINT fk_purchase_detail_purchase
        FOREIGN KEY (purchase_id)
        REFERENCES `Purchase` (purchase_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_purchase_detail_product
        FOREIGN KEY (product_id)
        REFERENCES `Product` (product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO `Customer`
(customer_id, first_name, last_name, phone, address)
VALUES
(1, 'Maria', 'Santos', '09171234567', 'Legazpi City, Albay'),
(2, 'Juan', 'Dela Cruz', '09181234567', 'Daraga, Albay'),
(3, 'Ana', 'Reyes', '09191234567', 'Naga City, Camarines Sur'),
(4, 'Mark', 'Garcia', '09201234567', 'Ligao City, Albay'),
(5, 'Sofia', 'Cruz', '09211234567', 'Tabaco City, Albay');

INSERT INTO `Employee`
(employee_id, first_name, last_name, position)
VALUES
(1, 'Carlo', 'Mendoza', 'Cashier'),
(2, 'Bea', 'Villanueva', 'Sales Clerk'),
(3, 'Paolo', 'Ramos', 'Inventory Clerk'),
(4, 'Liza', 'Navarro', 'Manager');

INSERT INTO `Category`
(category_id, category_name)
VALUES
(1, 'Classic Biko'),
(2, 'Flavored Biko'),
(3, 'Biko Box'),
(4, 'Gift Package');

INSERT INTO `Supplier`
(supplier_id, supplier_name, phone, address)
VALUES
(1, 'Albay Rice Supply', '09170000001', 'Legazpi City, Albay'),
(2, 'Sweet Pantry Supplies', '09170000002', 'Daraga, Albay'),
(3, 'Bicol Packaging Hub', '09170000003', 'Naga City, Camarines Sur');

INSERT INTO `Product`
(product_id, category_id, product_name, description, unit_price)
VALUES
(1, 1, 'Classic Biko Slice', 'Traditional sticky rice cake', 45.00),
(2, 1, 'Classic Biko Tray', 'Family-size traditional biko', 250.00),
(3, 2, 'Ube Biko', 'Biko with ube flavor', 60.00),
(4, 2, 'Pandan Biko', 'Biko with pandan flavor', 60.00),
(5, 3, 'Mini Biko Box', 'Small individual biko box', 80.00),
(6, 3, 'Family Biko Box', 'Large biko box for sharing', 350.00),
(7, 4, 'Biko Gift Pack', 'Gift-ready biko package', 450.00),
(8, 4, 'Premium Biko Basket', 'Premium assorted biko package', 650.00);

INSERT INTO `Inventory`
(inventory_id, product_id, quantity_on_hand, reorder_level)
VALUES
(1, 1, 50, 10),
(2, 2, 25, 5),
(3, 3, 30, 8),
(4, 4, 30, 8),
(5, 5, 40, 10),
(6, 6, 20, 5),
(7, 7, 15, 5),
(8, 8, 10, 3);

INSERT INTO `Order`
(order_id, customer_id, employee_id, order_date, order_status)
VALUES
(1, 1, 1, '2026-09-20 09:15:00', 'Completed'),
(2, 2, 2, '2026-09-20 10:30:00', 'Completed'),
(3, 3, 1, '2026-09-21 11:00:00', 'Processing'),
(4, 4, 2, '2026-09-22 13:20:00', 'Completed'),
(5, 5, 4, '2026-09-23 15:10:00', 'Pending');

INSERT INTO `Order_Detail`
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 3, 45.00),
(1, 3, 2, 60.00),
(2, 2, 1, 250.00),
(2, 5, 2, 80.00),
(3, 4, 4, 60.00),
(3, 6, 1, 350.00),
(4, 7, 1, 450.00),
(4, 1, 2, 45.00),
(5, 8, 1, 650.00);

INSERT INTO `Payment`
(payment_id, order_id, payment_date, amount, payment_method)
VALUES
(1, 1, '2026-09-20 09:20:00', 255.00, 'GCash'),
(2, 2, '2026-09-20 10:35:00', 410.00, 'Cash'),
(3, 4, '2026-09-22 13:25:00', 540.00, 'GCash');

INSERT INTO `Purchase`
(purchase_id, supplier_id, employee_id, purchase_date, purchase_status)
VALUES
(1, 1, 3, '2026-09-18 08:00:00', 'Received'),
(2, 2, 3, '2026-09-19 09:30:00', 'Received'),
(3, 3, 3, '2026-09-21 08:45:00', 'Received'),
(4, 1, 4, '2026-09-24 10:00:00', 'Pending');

INSERT INTO `Purchase_Detail`
(purchase_id, product_id, quantity, unit_cost)
VALUES
(1, 1, 50, 30.00),
(1, 2, 25, 170.00),
(2, 3, 30, 40.00),
(2, 4, 30, 40.00),
(3, 5, 40, 50.00),
(3, 6, 20, 220.00),
(4, 7, 15, 300.00),
(4, 8, 10, 450.00);

-- ============================================================
-- VERIFICATION / TEST QUERIES
-- ============================================================

-- A. Show all tables
SHOW TABLES;

-- B. Check table structures
DESCRIBE `Customer`;
DESCRIBE `Employee`;
DESCRIBE `Category`;
DESCRIBE `Product`;
DESCRIBE `Order`;
DESCRIBE `Order_Detail`;
DESCRIBE `Payment`;
DESCRIBE `Inventory`;
DESCRIBE `Supplier`;
DESCRIBE `Purchase`;
DESCRIBE `Purchase_Detail`;

-- C. Check row counts
SELECT 'Customer' AS table_name, COUNT(*) AS rows_count FROM `Customer`
UNION ALL
SELECT 'Employee', COUNT(*) FROM `Employee`
UNION ALL
SELECT 'Category', COUNT(*) FROM `Category`
UNION ALL
SELECT 'Product', COUNT(*) FROM `Product`
UNION ALL
SELECT 'Order', COUNT(*) FROM `Order`
UNION ALL
SELECT 'Order_Detail', COUNT(*) FROM `Order_Detail`
UNION ALL
SELECT 'Payment', COUNT(*) FROM `Payment`
UNION ALL
SELECT 'Inventory', COUNT(*) FROM `Inventory`
UNION ALL
SELECT 'Supplier', COUNT(*) FROM `Supplier`
UNION ALL
SELECT 'Purchase', COUNT(*) FROM `Purchase`
UNION ALL
SELECT 'Purchase_Detail', COUNT(*) FROM `Purchase_Detail`;

-- D. Order report
SELECT
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    o.order_date,
    o.order_status,
    COALESCE(SUM(od.quantity * od.unit_price), 0) AS order_total
FROM `Order` o
JOIN `Customer` c ON c.customer_id = o.customer_id
JOIN `Employee` e ON e.employee_id = o.employee_id
LEFT JOIN `Order_Detail` od ON od.order_id = o.order_id
GROUP BY
    o.order_id, c.first_name, c.last_name,
    e.first_name, e.last_name,
    o.order_date, o.order_status
ORDER BY o.order_id;

-- E. Inventory report
SELECT
    i.inventory_id,
    p.product_id,
    p.product_name,
    c.category_name,
    i.quantity_on_hand,
    i.reorder_level,
    CASE
        WHEN i.quantity_on_hand <= i.reorder_level THEN 'REORDER'
        ELSE 'STOCK OK'
    END AS stock_status
FROM `Inventory` i
JOIN `Product` p ON p.product_id = i.product_id
JOIN `Category` c ON c.category_id = p.category_id
ORDER BY p.product_id;

-- F. Purchase report
SELECT
    pu.purchase_id,
    s.supplier_name,
    CONCAT(e.first_name, ' ', e.last_name) AS employee,
    pu.purchase_date,
    pu.purchase_status,
    COALESCE(SUM(pd.quantity * pd.unit_cost), 0) AS purchase_total
FROM `Purchase` pu
JOIN `Supplier` s ON s.supplier_id = pu.supplier_id
JOIN `Employee` e ON e.employee_id = pu.employee_id
LEFT JOIN `Purchase_Detail` pd ON pd.purchase_id = pu.purchase_id
GROUP BY
    pu.purchase_id, s.supplier_name,
    e.first_name, e.last_name,
    pu.purchase_date, pu.purchase_status
ORDER BY pu.purchase_id;

-- G. Confirm the 1:1 constraints
SELECT COUNT(*) AS products_without_inventory
FROM `Product` p
LEFT JOIN `Inventory` i ON i.product_id = p.product_id
WHERE i.product_id IS NULL;

SELECT product_id, COUNT(*) AS inventory_records
FROM `Inventory`
GROUP BY product_id
HAVING COUNT(*) > 1;

-- H. Confirm at most one payment per order
SELECT order_id, COUNT(*) AS payment_count
FROM `Payment`
GROUP BY order_id
HAVING COUNT(*) > 1;