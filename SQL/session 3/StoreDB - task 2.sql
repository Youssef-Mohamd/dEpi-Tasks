-- create db
CREATE DATABASE StoreDB
go

USE StoreDB
go

-- create schemas
CREATE SCHEMA production;
go

CREATE SCHEMA sales;
go

-- create tables
CREATE TABLE production.categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.brands (
	brand_id INT IDENTITY (1, 1) PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);

CREATE TABLE production.products (
	product_id INT IDENTITY (1, 1) PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sales.customers (
	customer_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);

CREATE TABLE sales.stores (
	store_id INT IDENTITY (1, 1) PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
);

CREATE TABLE sales.staffs (
	staff_id INT IDENTITY (1, 1) PRIMARY KEY,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active tinyint NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sales.orders (
	order_id INT IDENTITY (1, 1) PRIMARY KEY,
	customer_id INT,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES sales.customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sales.order_items (
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE production.stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
);



--1  
SELECT * 
FROM production.products
WHERE list_price > 1000;

--2
SELECT * FROM sales.customers
WHERE state IN ('CA', 'NY');

--3
SELECT * FROM sales.orders
WHERE YEAR  (order_date) = 2023;

--4


SELECT * 
FROM sales.customers
WHERE email LIKE '%@gmail.com';

--5 

SELECT * FROM sales.staffs
WHERE active =0;

--6 

SELECT TOP 5 * FROM production.products
ORDER BY list_price DESC;

--7 

SELECT TOP 10 * FROM sales.orders
ORDER BY order_date DESC;

--8

SELECT TOP 3 * 
FROM sales.customers
ORDER BY last_name ASC;

--9

SELECT * 
FROM sales.customers
WHERE phone IS NULL;


--10
SELECT * FROM sales.staffs
WHERE manager_id IS NOT NULL;


--12 Count number of customers in each state

SELECT first_name, last_name, state
FROM sales.customers;

-----
SELECT state, COUNT(customer_id) AS customer_count
FROM sales.customers
GROUP BY state;



--13 Get average list price of products per brand

SELECT p.product_name, p.list_price, b.brand_name
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
ORDER BY p.list_price;
----
SELECT b.brand_name, AVG(p.list_price)AS avg_price 
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
order BY avg_price DESC ;
--------
--14 Show number of orders per staff

SELECT s.staff_id, s.first_name, s.last_name, COUNT(o.order_id) AS order_count
FROM sales.staffs s
 JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

--15

--16 Products priced between 500 and 1500

SELECT * FROM production.products 
WHERE list_price BETWEEN 500 AND 1500;

--17 Customers in cities starting with "S"
SELECT * FROM sales.customers
WHERE city LIKE 'S%';

--18 Orders with order_status either 2 or 4

SELECT * FROM sales.orders 
WHERE order_status IN (2,4);

--19 Products from category_id IN (1, 2, 3)

SELECT * FROM production.products  
WHERE category_id IN (1, 2, 3);

--20 Staff working in store_id = 1 OR without phone number

SELECT * FROM sales.staffs 
WHERE store_id = 1 OR phone IS NULL;