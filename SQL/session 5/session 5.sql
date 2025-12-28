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






-------------------------------------
--Session 5--
---------------


--1 Write a query that classifies all products into price categories:
 SELECT
  product_name,
   list_price,
    CASE
    WHEN list_price < 300 THEN 'Economy'
    WHEN list_price BETWEEN 300 AND 999 THEN 'Standard'
    WHEN list_price BETWEEN 1000 AND 2499 THEN 'Premium'
       ELSE 'Luxury'
    END AS price_category
FROM
    production.products
ORDER BY  list_price ASC;

	--2  Create a query that shows order processing information with user-friendly status descriptions:

  SELECT
 order_id,
 order_status,
    CASE order_status
        WHEN 1 THEN 'Order Received'
        WHEN 2 THEN 'In Preparation'
        WHEN 3 THEN 'Order Cancelled'
        WHEN 4 THEN 'Order Delivered'
        ELSE 'Unknown Status'
    END AS status_description
FROM  sales.orders

ORDER BY   order_date ;

--3 
SELECT 
    

	      CASE order_status
        WHEN 0 THEN 'New Staff'
        WHEN BETWEEN 1 AND 10 THEN 'Junior Staff'
        WHEN 3 THEN 'Order Cancelled'
        WHEN 4 THEN 'Order Delivered'
        ELSE 'Unknown Status'
    END AS status_description
FROM  sales.orders

--4 
--Use ISNULL to replace missing phone numbers with "Phone Not Available"

   SELECT 
    ISNULL (phone, 'Phone Not Available')
	FROM 
	sales.customers ;

	-- Use COALESCE to create a preferred_contact field (phone first, then email, then "No Contact Method")

	SELECT 
  COALESCE(phone, email, 'No Contact Method') AS preferred_contact
FROM sales.customers;

--5  Write a query that safely calculates price per unit in stock:

--Use NULLIF to prevent division by zero when quantity is 0
--Use ISNULL to show 0 when no stock exists
--Include stock status using CASE WHEN
--Only show products from store_id = 1

    
SELECT
    p.product_id,
    p.product_name,
    s.store_id,
    s.quantity,
    p.list_price,

    
    p.list_price / NULLIF(s.quantity, 0) AS price_per_unit,

    ISNULL(p.list_price / NULLIF(s.quantity, 0), 0) AS price_per_unit,

    --  CASE WHEN 
    CASE
        WHEN s.quantity = 0 THEN 'Out of Stock'
        WHEN s.quantity BETWEEN 1 AND 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status

FROM
    production.products p
JOIN
    production.stocks s ON p.product_id = s.product_id

WHERE
    s.store_id = 1

ORDER BY
    p.product_name;


	--6 


	SELECT
    customer_id,
    first_name,
    last_name,
    
    COALESCE(street, 'No Street') AS street,
    COALESCE(city, 'No City') AS city,
    COALESCE(state, 'No State') AS state,

COALESCE(street, '') + ' ' +
COALESCE(city, '') + ' ' +
 COALESCE(state, '') + ' ' +
 COALESCE(zip_code, '') AS formatted_address
 
FROM
    sales.customers
ORDER BY
    customer_id;


	--7 

	WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.list_price) AS total_spent
    FROM
        sales.orders o
    JOIN
        sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY
        o.customer_id
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    cs.total_spent
FROM
    customer_spending cs
JOIN
    sales.customers c ON cs.customer_id = c.customer_id
WHERE
    cs.total_spent > 1500
ORDER BY
    cs.total_spent DESC;

	--8
	--cte1
WITH category_revenue AS (
    SELECT
  c.category_id,
   c.category_name,
     SUM(oi.quantity * oi.list_price) AS total_revenue
    FROM
     production.categories c
    JOIN production.products p ON c.category_id = p.category_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY
     c.category_id, c.category_name
),

--CTE2
category_avg_order AS (
    SELECT
        c.category_id,
        AVG(oi.quantity * oi.list_price) AS avg_order_value
    FROM
        production.categories c
    JOIN production.products p ON c.category_id = p.category_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY
        c.category_id
)
--final select
SELECT
    cr.category_id,
    cr.category_name,
    cr.total_revenue,
    cao.avg_order_value,

    CASE
        WHEN cr.total_revenue > 50000 THEN 'Excellent'
        WHEN cr.total_revenue > 20000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_rating
FROM
 category_revenue cr
JOIN
 category_avg_order cao ON cr.category_id = cao.category_id
ORDER BY
  cr.total_revenue DESC;

  --9 

WITH monthly_sales AS (
    SELECT
   MONTH(o.order_date) AS sales_month,
   SUM(oi.quantity * oi.list_price) AS total_sales
    FROM
     sales.orders o
    JOIN
     sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY
     MONTH(o.order_date)
)

SELECT
curr.sales_month,
curr.total_sales,
 prev.total_sales AS prev_month_sales,

    ((curr.total_sales - prev.total_sales) * 100.0) /
    NULLIF(prev.total_sales, 0) AS growth_percentage

FROM
  monthly_sales curr
LEFT JOIN
monthly_sales prev
ON 
curr.sales_month = prev.sales_month + 1
ORDER BY
    curr.sales_month;


	--10


WITH ranked_products AS (
    SELECT
    c.category_name,
	p.product_name,
    p.list_price,

        ROW_NUMBER() OVER (
      PARTITION BY c.category_i
	  ORDER BY p.list_price DESC
        ) AS row_number,

        RANK() OVER (
            PARTITION BY c.category_id
            ORDER BY p.list_price DESC
        ) AS rank_position,

        DENSE_RANK() OVER (
            PARTITION BY c.category_id
            ORDER BY p.list_price DESC
        ) AS dense_rank_position
    FROM
        production.products p
    JOIN
        production.categories c ON p.category_id = c.category_id
)

SELECT *
FROM ranked_products
WHERE row_number <= 3
ORDER BY category_name, row_number;

--11
WITH customer_spending AS (
SELECT 
SC.customer_id,
SC.first_name,

SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent

FROM
  sales.customers SC

    JOIN
      sales.orders o ON SC.customer_id = o.customer_id
    JOIN
     sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY
      SC.customer_id, SC.first_name
),
--CTE2
ranked_customers AS (
    SELECT*,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank,
    NTILE(5) OVER (ORDER BY total_spent DESC) AS spending_group
    FROM customer_spending
)
SELECT
  customer_id,   first_name,
   total_spent,
   spending_rank,
   spending_group,
    CASE spending_group
	WHEN 1 THEN 'VIP'
      WHEN 2 THEN 'Gold'
	  WHEN 3 THEN 'Silver'
      WHEN 4 THEN 'Bronze'
      ELSE 'Standard'
   END AS spending_tier
FROM ranked_customers
ORDER BY total_spent DESC;

--12

WITH store_stats AS (
    SELECT
        s.store_id,
        s.store_name,
        COUNT(o.order_id) AS total_orders,
        SUM(oi.quantity * oi.list_price) AS total_revenue
    FROM sales.stores s
    JOIN sales.orders o ON s.store_id = o.store_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY s.store_id, s.store_name
)

SELECT
   store_id,
  store_name,    total_orders,
    total_revenue,

   RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
   RANK() OVER (ORDER BY total_orders DESC) AS orders_rank,
    PERCENT_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_percentile

FROM store_stats;

--13


SELECT *
FROM (
    SELECT 
        c.category_name,
        b.brand_name
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name IN ('Electra', 'Haro', 'Trek', 'Surly')
) AS source_data
PIVOT (
    COUNT(brand_name)
    FOR brand_name IN ([Electra], [Haro], [Trek], [Surly])
) AS pivot_table;

--14 

SELECT 
    store_name,
    ISNULL([January], 0) AS Jan,
    ISNULL([February], 0) AS Feb,
    ISNULL([March], 0) AS Mar,
    ISNULL([April], 0) AS Apr,
    ISNULL([May], 0) AS May,
    ISNULL([June], 0) AS Jun,
    ISNULL([July], 0) AS Jul,
    ISNULL([August], 0) AS Aug,
    ISNULL([September], 0) AS Sep,
    ISNULL([October], 0) AS Oct,
    ISNULL([November], 0) AS Nov,
    ISNULL([December], 0) AS Dec,

   --SUM OF YEAR
    ISNULL([January], 0) + ISNULL([February], 0) + ISNULL([March], 0) +
    ISNULL([April], 0) + ISNULL([May], 0) + ISNULL([June], 0) +
    ISNULL([July], 0) + ISNULL([August], 0) + ISNULL([September], 0) +
    ISNULL([October], 0) + ISNULL([November], 0) + ISNULL([December], 0) AS Total

FROM (
    SELECT 
        s.store_name,
        DATENAME(MONTH, o.order_date) AS month_name,
        oi.quantity * oi.list_price AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
) AS raw_data

PIVOT (
    SUM(revenue)
    FOR month_name IN (
        [January], [February], [March], [April], [May], [June],
        [July], [August], [September], [October], [November], [December]
    )
) AS pivot_table;

--15

SELECT *
FROM (
    SELECT 
        s.store_name,
        CASE o.order_status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Processing'
            WHEN 3 THEN 'Completed'
            WHEN 4 THEN 'Rejected'
        END AS status_name
    FROM sales.orders o
    JOIN sales.stores s ON o.store_id = s.store_id
) AS source_table

PIVOT (
    COUNT(status_name)
    FOR status_name IN ([Pending], [Processing], [Completed], [Rejected])
) AS pivot_table;




SELECT 
    p.product_id,
    p.product_name,
    'In Stock' AS status
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.quantity > 0
UNION
SELECT 
    p.product_id,
    p.product_name,
    'Out of Stock' AS status
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.quantity = 0 OR s.quantity IS NULL

UNION

SELECT 
    p.product_id,
    p.product_name,
    'Discontinued' AS status
FROM production.products p
LEFT JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;


--18

WITH loyal_customers AS (
    SELECT DISTINCT customer_id
    FROM sales.orders
    WHERE YEAR(order_date) = 2017
    INTERSECT
    SELECT DISTINCT customer_id
    FROM sales.orders
    WHERE YEAR(order_date) = 2018
)
SELECT 
  c.customer_id,
	c.first_name + ' ' + c.last_name AS customer_name,
  COUNT(o.order_id) AS total_orders
FROM loyal_customers lc
JOIN sales.customers c ON lc.customer_id = c.customer_id
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;



