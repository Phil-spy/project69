-- ============================================================
--  schema.sql — ระบบร้านอาหาร (นิสิตออกแบบและเขียนเอง)
--  กติกา: 1 ออเดอร์มีหลายเมนู (M:N: order × menu_item ผ่าน order_item),
--         เมนูชุด combo = M:N (menu_item × menu_item)
--  ต้องมี: PK ทุกตาราง, FK ครบ, ชื่อตรงกับ db.py, sample data
-- ============================================================
DROP TABLE IF EXISTS combo;
DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS food_order;
DROP TABLE IF EXISTS dining_table;
DROP TABLE IF EXISTS menu_item;
DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
    cust_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    member_tier ENUM('standard', 'silver', 'gold') DEFAULT 'standard'
);

CREATE TABLE menu_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE dining_table (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    seats INT NOT NULL DEFAULT 2,
    zone VARCHAR(50) DEFAULT 'Main Dining'
);

CREATE TABLE food_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    cust_id INT,
    table_id INT NOT NULL,
    order_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('open', 'paid') DEFAULT 'open',
    FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON DELETE SET NULL,
    FOREIGN KEY (table_id) REFERENCES dining_table(table_id) ON DELETE CASCADE
);

CREATE TABLE order_item (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    qty INT NOT NULL DEFAULT 1,
    note VARCHAR(255),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES food_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_item(item_id) ON DELETE CASCADE
);

CREATE TABLE combo (
    combo_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,       -- เมนูที่เป็นชุดเซตหลัก
    sub_item_id INT NOT NULL,   -- เมนูป่อยในเซต
    amount INT NOT NULL DEFAULT 1,
    FOREIGN KEY (item_id) REFERENCES menu_item(item_id) ON DELETE CASCADE,
    FOREIGN KEY (sub_item_id) REFERENCES menu_item(item_id) ON DELETE cascade
    
);

INSERT INTO customer (cust_id, name, phone, member_tier) VALUES
(1, 'สมชาย สายกิน', '0812345678', 'gold'),
(2, 'สมหญิง จริงใจ', '0898765432', 'silver'),
(3, 'กิตติพงษ์ วงศ์สว่าง', '0861112223', 'standard');

INSERT INTO dining_table (table_id, seats, zone) VALUES
(1, 2, 'Indoor'),
(2, 4, 'Indoor'),
(3, 4, 'Outdoor'),
(4, 8, 'VIP');

INSERT INTO menu_item (item_id, name, category, price, is_available) VALUES
(1, 'ข้าวผัดกุ้ง', 'Main Dish', 80.00, TRUE),
(2, 'ต้มยำกุ้ง', 'Main Dish', 150.00, TRUE),
(3, 'โค้ก', 'Beverage', 20.00, TRUE),
(4, 'น้ำเปล่า', 'Beverage', 10.00, TRUE),
(5, 'ไอศกรีมวานิลลา', 'Dessert', 40.00, TRUE),
(6, 'ชุดอิ่มคุ้มสุดเซต (Combo)', 'Combo', 220.00, TRUE);

INSERT INTO combo (item_id, sub_item_id, amount) VALUES
(6, 1, 1),
(6, 2, 1),
(6, 3, 1);

INSERT INTO food_order (order_id, cust_id, table_id, order_time, status) VALUES
(1, 1, 1, '2026-10-08 18:00:00', 'paid'),
(2, 2, 2, '2026-10-08 19:15:00', 'open');


INSERT INTO order_item (order_id, item_id, qty, note) VALUES
(1, 1, 2, 'เผ็ดน้อย'),
(1, 3, 2, 'ใส่น้ำแข็ง'),
(2, 6, 1, 'ไม่ใส่ผักชี'),
(2, 4, 1, 'เย็น');








