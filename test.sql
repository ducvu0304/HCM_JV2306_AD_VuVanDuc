CREATE DATABASE test;
USE test;

CREATE TABLE categories(
	id  		INT AUTO_INCREMENT PRIMARY KEY,
    `name` 		VARCHAR(100) NOT NULL UNIQUE,
	`status`	TINYINT DEFAULT 0 
);

CREATE TABLE products(
	id  		INT AUTO_INCREMENT PRIMARY KEY,
    `name` 		VARCHAR(200) NOT NULL,
	price		FLOAT NOT NULL,
    image	 	VARCHAR(200),
    category_id INT,
    CONSTRAINT fk_products_categories FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE customers(
	id  		INT AUTO_INCREMENT PRIMARY KEY,
    `name` 		VARCHAR(100) NOT NULL,
	email		VARCHAR(100) NOT NULL UNIQUE,
    image		VARCHAR(200),
    birthday	DATE,
    gender		TINYINT
);

CREATE TABLE orders(
	id  		INT AUTO_INCREMENT PRIMARY KEY,
    customer_id	INT,
    created		TIMESTAMP DEFAULT NOW(),
    `status`	TINYINT	DEFAULT 0,
	CONSTRAINT fk_orders_customers FOREIGN KEY(customer_id) REFERENCES customers(id)
);

CREATE TABLE order_details(
	order_id  	INT,
    product_id	INT,
    quantity 	INT NOT NULL,
    price		FLOAT NOT NULL,
    PRIMARY KEY(order_id, product_id),
	CONSTRAINT fk_OrderDetails_Orders FOREIGN KEY(order_id) REFERENCES orders(id),
    CONSTRAINT fk_OrderDetails_Products FOREIGN KEY(order_id) REFERENCES products(id)
);

INSERT INTO categories 	(`name` 	, `status`)
VALUES	("Áo", 1), ("Quần", 1), ("Mũ", 1), ("Giày", 1);

INSERT INTO products 	(`name`, category_id, price)
VALUES	("Áo sơ mi", 1, 150000), ("Áo khoác dạ", 1, 500000),  ("Quần Kaki", 2, 200000), ("Giầy tây", 4, 1000000), ("Mũ bảo hiểm A1", 3, 100000);  

INSERT INTO customers 	(`name`, email, birthday, gender)
VALUES	("Nguyễn Minh Khôi"	, "khoi@gmail.com"	, "2021-12-21", 1), 
		("Nguyễn Khánh Linh", "linh@gmail.com"	, "2001-12-12", 0), 
        ("Đỗ Khánh Linh"	, "linh2@gmail.com"	, "1999-01-01", 0);
        
INSERT INTO orders 	(customer_id, created, `status`)
VALUES	(1, "2023-11-08", 0), 
		(2, "2023-11-09", 0), 
        (1, "2023-11-09", 0),
        (3, "2023-11-09", 0);
        
INSERT INTO order_details (order_id, product_id, quantity, price)
VALUES	(1, 1, 1, 149000), (1, 2, 1, 449000), (2, 2, 2, 449000), (3, 2, 1, 449000), (4, 1, 1, 149000); 

-- 1. Hiển thị danh sách danh mục gồm id,name,status (3đ).
SELECT id, `name`, `status` FROM categories;

-- 2. Hiển thị danh sách sản phẩm gồm id,name,price,sale_price,category_name(tên danh mục) (7đ).
SELECT p.id, p.`name`, p.price, c.`name` category_name
FROM products p
INNER JOIN  categories c ON c.id = p.category_id;

-- 3. Hiển thị danh sách sản phẩm có giá lớn hơn 200000 (5đ).
SELECT * FROM products WHERE price > 200000;

-- 4. Hiển thị 3 sản phẩm có giá cao nhất (5đ).
SELECT * FROM products ORDER BY price DESC LIMIT 3;

-- 5. Hiển thị danh sách đơn hàng gồm id,customer_name,created,status.(5đ)
SELECT o.id, c.id cusid, o.created, o.`status`, c.`name`customer_name   
FROM orders o
INNER JOIN customers c ON c.id = o.customer_id;

-- 6. Cập nhật trạng thái đơn hàng có id là 1 (5đ)
UPDATE orders SET `status` = 1 WHERE id = 1;

-- 7. Hiển thị chi tiết đơn hàng của đơn hàng có id là 1, bao gồm
-- order_id,product_name,quantity,price,total_money là giá trị của (price * quantity) (10đ)
SELECT od.order_id, od.quantity, od.price, (od.price * od.quantity) total_money, p.`name` 
FROM order_details od 
INNER JOIN products p ON p.id = od.product_id;

-- 8. Danh sách danh mục gồm, id,name, quantity_product(đếm trong bảng product) (20đ)
SELECT c.id, c.`name`, c.`status`, COUNT(p.category_id) quantity_product
FROM categories c 
INNER JOIN products p ON p.category_id = c.id
GROUP BY c.id;
