Take Transpose

```sql
-- Microsoft Access
SELECT
	DateValue([create_date]) AS [create_date],
	SUM(IIf(status = 'Success', 1, 0)) AS [success],
	SUM(IIf(status = 'Failed', 1, 0)) AS [failed],
	COUNT(*) AS [total]
FROM my_table
GROUP BY DateValue([create_date]);
```

Handle 3 level of hierarchy data

```sql
-- MySQL

-- Schema
CREATE TABLE order_quantities (
	id INT NOT NULL PRIMARY KEY,
	order_id INT NOT NULL,
	product_name VARCHAR(20) NOT NULL,
	quantity INT NOT NULL,
	UNIQUE KEY uk_order_id_product_name (order_id, product_name)
);

INSERT INTO order_quantities VALUES (1, 1, 'MacBook', 1);
INSERT INTO order_quantities VALUES (2, 1, 'iPhone', 3);
INSERT INTO order_quantities VALUES (3, 2, 'Android', 3);
INSERT INTO order_quantities VALUES (4, 3, 'iPhone', 2);

CREATE TABLE orders (
	id INT NOT NULL PRIMARY KEY,
	parent_order_id INT NULL
);

INSERT INTO orders VALUES (1, NULL);
INSERT INTO orders VALUES (2, NULL);
INSERT INTO orders VALUES (3, 1);

-- Output, with order_id in ASC and product_name in ASC
-- order_id, order_summary
-- 1, 5*iPhone+1*MacBook
-- 2, 3*Android
-- 3, 2*iPhone
SELECT
	g.order_id,
	GROUP_CONCAT(CONCAT(g.group_quantity, '*', g.product_name) ORDER BY g.product_name SEPARATOR '+') AS quantity_summary
FROM (
	SELECT map.root_id AS order_id, q.product_name, SUM(q.quantity) AS group_quantity
	FROM
		order_quantities q LEFT JOIN (
			SELECT id AS root_id, id AS leaf_id
			FROM orders
			UNION
			SELECT parents.id, childs.id
			FROM orders parents INNER JOIN orders childs ON parents.id = childs.parent_order_id
			UNION
			SELECT parents.id, grandchilds.id
			FROM
				orders parents
				INNER JOIN orders childs ON parents.id = childs.parent_order_id
				INNER JOIN orders grandchilds ON childs.id = grandchilds.parent_order_id
		) map ON q.order_id = map.leaf_id
	GROUP BY map.root_id, q.product_name
) g
GROUP BY order_id
ORDER BY order_id;
```
