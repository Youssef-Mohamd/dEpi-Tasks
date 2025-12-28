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






-----------------------------------------------------------------------

-- session 7

--1

CREATE NONCLUSTERED INDEX MyIndex 
ON sales.customers (email);


--2 

CREATE NONCLUSTERED INDEX idex_products
ON production.products (category_id, brand_id);

--3

CREATE NONCLUSTERED INDEX IndexOrders
ON sales.orders (order_date)
INCLUDE (customer_id, store_id, order_status);

--4

CREATE TRIGGER tr
ON sales.customers
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.customer_log (customer_id, message)
    SELECT customer_id, 'Welcome, new customer!'
    FROM inserted;
END;

--5

CREATE TABLE Production.Price_History (
    PriceHistoryID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    NewPrice DECIMAL(10,2) NOT NULL,
    OldPrice DECIMAL(10,2) NOT NULL,
    ChangeDate DATETIME NOT NULL DEFAULT GETDATE(),
   );


CREATE TRIGGER trg_Product_ListPrice_Update
ON Production.Products
AFTER UPDATE
AS
BEGIN
    INSERT INTO production.price_history (ProductID, OldPrice, NewPrice, ChangeDate)
    SELECT
        i.product_id,
        d.list_price AS OldPrice,
        i.list_price AS NewPrice,
        GETDATE() AS ChangeDate
    FROM inserted i
    INNER JOIN deleted d ON i.product_id = d.product_id
    WHERE ISNULL(i.list_price,0) <> ISNULL(d.list_price,0);
END;


--6  

CREATE TRIGGER trg_ProductCategory_PreventDelete
ON Production.Categories
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Production.products p
        JOIN deleted d ON p.category_id= d.category_id
    )
    BEGIN
        THROW 50000, 'Cannot delete category. There are one or more products associated with it.', 1;
        ROLLBACK TRANSACTION;
        RETURN;
    END

   
    DELETE pc
    FROM Production.Categories pc
    JOIN deleted d ON pc.category_id = d.category_id;
END;


--7 

CREATE TRIGGER trg_OrderItem_ReduceStock
ON sales.order_items
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET s.quantity = s.quantity - i.quantity
    FROM production.stocks s
    INNER JOIN inserted i 
        ON s.product_id = i.product_id
       AND s.store_id = (
           SELECT o.store_id
           FROM sales.orders o
           WHERE o.order_id = i.order_id
       );
END;


--8

CREATE TABLE sales.order_audit (
    audit_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    customer_id INT,
    order_status TINYINT NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date DATE,
    store_id INT NOT NULL,
    staff_id INT NOT NULL,
    audit_datetime DATETIME NOT NULL DEFAULT GETDATE()
);


CREATE TRIGGER trg_Order_Insert_Audit
ON sales.orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO sales.order_audit
        (order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id, audit_datetime)
    SELECT
        i.order_id,
        i.customer_id,
        i.order_status,
        i.order_date,
        i.required_date,
        i.shipped_date,
        i.store_id,
        i.staff_id,
        GETDATE()
    FROM inserted i;
END;
