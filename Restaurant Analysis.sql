--popular meal types by total orders
SELECT mt.meal_type, COUNT(*) AS total_orders
FROM order_details od
JOIN meals m ON od.meal_id = m.id
JOIN meal_types mt ON m.meal_type_id = mt.id
GROUP BY mt.meal_type
ORDER BY total_orders DESC;

--top 5 restaurants by total orders
SELECT TOP 5 r.restaurant_name, COUNT(o.id) AS total_orders
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
GROUP BY r.restaurant_name
ORDER BY total_orders DESC;

--avg spending per member
SELECT m.first_name, m.surname, AVG(o.total_order) AS avg_spending
FROM members m
JOIN orders o ON m.id = o.member_id
GROUP BY m.first_name, m.surname
ORDER BY avg_spending DESC;

--monthly revenue by city
SELECT c.city, YEAR(o.date) AS year, MONTH(o.date) AS month, 
       SUM(o.total_order) AS total_revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
JOIN cities c ON r.city_id = c.id
GROUP BY c.city, YEAR(o.date), MONTH(o.date)
ORDER BY year, month, total_revenue DESC;


--frequent meals
SELECT TOP 10 m.meal_name, COUNT(od.id) AS times_ordered
FROM order_details od
JOIN meals m ON od.meal_id = m.id
GROUP BY m.meal_name
ORDER BY times_ordered DESC;


--revenue per restaurant type
SELECT rt.restaurant_type, SUM(o.total_order) AS total_revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
JOIN restaurant_types rt ON r.restaurant_type_id = rt.id
GROUP BY rt.restaurant_type
ORDER BY total_revenue DESC;

--member budget vs actual spending
SELECT m.first_name, m.surname, m.monthly_budget, 
       ISNULL(SUM(o.total_order), 0) AS total_spent,
       (m.monthly_budget - ISNULL(SUM(o.total_order), 0)) AS balance
FROM members m
LEFT JOIN orders o ON m.id = o.member_id
GROUP BY m.first_name, m.surname, m.monthly_budget
ORDER BY balance ASC; 

