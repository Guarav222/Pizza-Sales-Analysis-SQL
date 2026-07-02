-- QUESTIONS & ANSWERS

SELECT 
    *
FROM
    ORDER_DETAILS;


-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders;







-- Calculate the total revenue generated from pizza sales
SELECT 
    ROUND(SUM(quantity * price), 2) AS Total_Revenue
FROM
    order_details od
        JOIN
    pizzas AS p ON p.PIZZA_ID = od.PIZZA_ID
;
    




-- Identify the highest-priced pizza.
SELECT 
    MAX(price) AS Highest_priced_pizza
FROM
    PIZZAS;



-- Identify the most common pizza size ordered.
SELECT 
    size, COUNT(order_details_id) AS order_count
FROM
    pizzas AS p
        JOIN
    order_details AS o ON p.pizza_id = o.pizza_id
GROUP BY size
ORDER BY order_count DESC
LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities. 
SELECT 
    pizza_type_id AS Pizzas_Types, SUM(quantity) AS Orders
FROM
    pizzas AS p
        JOIN
    order_details AS o ON p.pizza_id = o.pizza_id
GROUP BY Pizzas_types
ORDER BY Orders DESC
LIMIT 5;


-- Intermediate
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    category, SUM(quantity) AS quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS o ON o.pizza_id = p.pizza_id
GROUP BY category
ORDER BY quantity DESC;


-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS Hours, COUNT(order_id) AS order_counts
FROM
    orders
GROUP BY Hours;



-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizzas_order
FROM
    (SELECT 
        order_date, SUM(quantity) AS quantity
    FROM
        orders AS o
    JOIN order_details AS od ON o.Order_id = od.Order_id
    GROUP BY order_date) AS order_quantity;
 
 
 
 --  Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_type_id AS pizza_types,
    SUM(quantity * price) AS Total_Revenue
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY pizza_types
ORDER BY Total_Revenue DESC
LIMIT 3;
 
 
 
 
 -- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    SUM(od.quantity * p.price)
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;


SELECT 
    pt.name AS pizza_type,
    ROUND(SUM(od.quantity * p.price) * 100 / (SELECT 
                    SUM(od2.quantity * p2.price)
                FROM
                    order_details od2
                        JOIN
                    pizzas p2 ON od2.pizza_id = p2.pizza_id),
            2) AS revenue_percentage
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue_percentage DESC;
 
 
 
 
 -- Analyze the cumulative revenue generated over time.
 select order_date, sum(revenue) over(order by order_date) as cum_revenue
 from
 (select order_date, sum(quantity* price) as Revenue
 from order_details as od
 join pizzas as p
 on p.pizza_id = od.pizza_id
 
 join orders as o
 on o.order_id = od.order_id
 group by  order_date) 
 as sales;
 

 
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue from
(select category, name, revenue ,
rank() over(partition by category order by revenue desc) as rn
from
(select category, name, sum(quantity * price) as revenue
from pizza_types as pt join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on od.pizza_id = p.pizza_id
group by category, name) as a) as b
where rn<=3
;
 
 
 
 
 


