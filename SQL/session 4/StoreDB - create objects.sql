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



--1  Count the total number of products in the database.

SELECT COUNT(*)
FROM production.products;



--2 Find the average, minimum, and maximum price of all products.

SELECT AVG(list_price) AS avg_price , MIN(list_price) AS Min_price,MAX(list_price) AS Max_price
FROM production.products;

--3 Count how many products are in each category.

SELECT  Category_id, COUNT(*) as count_product

FROM production.products
GROUP BY category_id;

--4 Find the total number of orders for each store.

SELECT order_id , COUNT (*) AS ORDERS_NUM
FROM sales.order_items
GROUP BY order_id;

--5 Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers

SELECT 
    UPPER(first_name) AS first_name_,
    LOWER(last_name) AS last_name
FROM sales.customers
ORDER BY customer_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY ;

--6 Get the length of each product name. Show product name and its length for the first 10 products.

SELECT 
    product_name,
    LEN(product_name) AS name_length
FROM production.products
ORDER BY product_id ASC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--7 
SELECT 
    customer_id,
    phone,
    LEFT(phone, 3) AS area_code
FROM sales.customers
WHERE customer_id BETWEEN 1 AND 15;


--8 Show the current date and extract the year and month from order dates for orders 1-10.

SELECT 
    GETDATE() AS currentdate, order_id, order_date,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month
FROM sales.orders
WHERE order_id BETWEEN 1 AND 10;

--9 Join products with their categories. Show product name and category name for first 10 products.
SELECT 
    p.product_name, c.category_name
FROM production.products p INNER JOIN production.categories c 
    ON p.category_id = c.category_id
	ORDER BY p.product_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--10  Join customers with their orders. Show customer name and order date for first 10 orders.

SELECT c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.orders o 
JOIN sales.customers c ON o.customer_id = c.customer_id
 ORDER BY order_id
 OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

 --11 

 SELECT ,
    p.product_name
    ISNULL(b.brand_name, 'No Brand') AS brand_name
FROM production.products p
LEFT JOIN production.brands b 
    ON p.brand_id = b.brand_id;

	--12  Find products that cost more than the average product price. Show product name and price.

	SELECT product_name, list_price
       FROM production.products
      WHERE list_price > (
    SELECT AVG(list_price)
    FROM production.products);

	--13.  Find customers who have placed at least one order. Use a subquery with IN. Show customer_id and customer_name.


	SELECT customer_id, first_name AS customer_name
FROM sales.customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM sales.orders
);

--14  For each customer, show their name and total number of orders using a subquery in the SELECT clause.


SELECT 
    first_name + ' ' + last_name AS customer_name,
    (SELECT COUNT(*) 
     FROM sales.orders o 
     WHERE o.customer_id = c.customer_id) AS total_orders
FROM sales.customers c;

--17
SELECT product_name, list_price
FROM production.products
WHERE list_price BETWEEN 50 AND 200
ORDER BY list_price ASC;



--18
SELECT state, COUNT(*) AS customer_count
FROM sales.customers
GROUP BY state
ORDER BY customer_count DESC;
--19


SELECT 
    c.category_name,
    p.product_name,
    p.list_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
ORDER BY c.category_name, p.list_price DESC;



--20
SELECT 
    s.store_name, s.city,
    (SELECT COUNT(*) 
     FROM sales.orders o 
     WHERE o.store_id = s.store_id) AS order_count
FROM sales.stores s;
