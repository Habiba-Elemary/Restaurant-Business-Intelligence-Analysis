--CREATE DATABASE FOOD;
USE FOOD;


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

----------------------------

--number of restaurant in each cities
SELECT c.city, COUNT(DISTINCT r.id) AS total_restaurants, COUNT(o.id) AS total_orders, 
       SUM(o.total_order) AS total_revenue
FROM cities c
JOIN restaurants r ON r.city_id = c.id
LEFT JOIN orders o ON o.restaurant_id = r.id
GROUP BY c.city
ORDER BY total_revenue DESC;

--the restaurant names in each city and the total number of orders for each restaurant
SELECT r.restaurant_name,c.city,COUNT(o.id) AS total_orders
FROM cities c
JOIN restaurants r ON r.city_id = c.id
JOIN orders o ON o.restaurant_id = r.id
GROUP BY c.city, r.restaurant_name
ORDER BY c.city, total_orders DESC;

--cities and restaurants have the highest number of unique members who placed orders
SELECT r.restaurant_name,c.city, COUNT(DISTINCT o.member_id) AS total_members
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
JOIN cities c ON r.city_id =c.id
GROUP BY c.city , r.restaurant_name
ORDER BY total_members DESC;

--number of orders by month for each restaurant
SELECT DATENAME(MONTH, o.date) AS month, r.restaurant_name,
    COUNT(o.id) AS total_orders, SUM(o.total_order) AS total_revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
GROUP BY r.restaurant_name, DATENAME(MONTH, o.date)
ORDER BY total_revenue DESC;

--serve type generates the highest order
SELECT  s.serve_type,COUNT(*) AS total_orders
FROM orders o
JOIN order_details od ON o.id = od.order_id
JOIN meals m ON od.meal_id = m.id
JOIN serve_types s ON m.serve_type_id = s.id
GROUP BY s.serve_type
ORDER BY total_orders DESC;

--the month with the highest number of orders
SELECT MONTH(o.date) AS order_month,r.restaurant_name,COUNT(*) AS total_orders
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.id
GROUP BY MONTH(o.date) ,r.restaurant_name 
HAVING COUNT(*) >= 200
ORDER BY total_orders DESC;

--restaurant type has the highest number of unique members ber month
SELECT rt.restaurant_type ,MONTH(o.date) AS order_month ,COUNT(DISTINCT o.member_id) AS total_members
FROM orders o
JOIN restaurants r ON o.restaurant_id=r.id
JOIN restaurant_types rt ON r.restaurant_type_id=rt.id
GROUP BY rt.restaurant_type,MONTH(o.date)
ORDER BY total_members DESC;

--is the number of orders for hot meals vs. cold meals
SELECT r.id AS restaurant_id,m.hot_cold,COUNT(*) AS total_orders
FROM order_details od
JOIN meals m ON od.meal_id = m.id
JOIN restaurants r ON m.restaurant_id = r.id
GROUP BY r.id, m.hot_cold
ORDER BY total_orders DESC;

--orders of meal types are offered by each restaurant type
SELECT rt.restaurant_type, mt.meal_type, COUNT(*) AS total_orders 
FROM order_details od
JOIN meals m ON od.meal_id = m.id
JOIN meal_types mt ON m.meal_type_id = mt.id
JOIN restaurants r ON m.restaurant_id = r.id
JOIN restaurant_types rt ON r.restaurant_type_id = rt.id
GROUP BY rt.restaurant_type, mt.meal_type
ORDER BY rt.restaurant_type, total_orders DESC;

--the top 10 total commission  
SELECT TOP 10 m.id AS member_id, m.first_name, m.surname, SUM(mm.commission) AS total_commission,
    SUM(mm.total_expense) AS total_expense,
    COUNT(o.id) AS total_orders
FROM monthly_member_totals mm
JOIN members m ON mm.member_id = m.id
LEFT JOIN orders o ON m.id = o.member_id
GROUP BY m.id, m.first_name, m.surname
ORDER BY total_commission DESC;

--number restaurants are in each city the type of each restaurant
SELECT c.city, rt.restaurant_type, COUNT(r.id) AS total_restaurants
FROM cities c
JOIN restaurants r ON r.city_id = c.id
JOIN restaurant_types rt ON r.restaurant_type_id = rt.id
GROUP BY c.city, rt.restaurant_type
ORDER BY c.city, total_restaurants DESC;

--serve types are offered by each restaurant type
SELECT rt.restaurant_type, st.serve_type, COUNT(DISTINCT m.id) AS total_meals
FROM restaurants r
JOIN restaurant_types rt ON r.restaurant_type_id = rt.id
JOIN meals m ON r.id = m.restaurant_id
JOIN serve_types st ON m.meal_type_id =st.id
GROUP BY rt.restaurant_type, st.serve_type
ORDER BY rt.restaurant_type, total_meals DESC;