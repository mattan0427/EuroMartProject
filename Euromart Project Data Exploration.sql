--1 List the top 10 orders with the highest sales form the EachOrderBreakdown table.
SELECT * FROM EachOrderBreakdown

SELECT TOP 10 *
FROM EachOrderBreakdown
ORDER BY Sales DESC
--This lists the top 10 orders with the highest sales.


--2 Show the number of orders for each product category in the EachOrderBreakdown table.
SELECT Category, COUNT(*) AS TotalOrders
FROM EachOrderBreakdown
GROUP BY Category
--This lists the total number of orders based on category using an aggregate function.


--3 Find the total profit for each sub-category in the EachOrderBreakdown table.
SELECT SubCategory, SUM(Profit) AS TotalProfit
FROM EachOrderBreakdown
GROUP BY SubCategory
--This lists the total profit based on subcategories.


--4 Identify the customer with the highest total sales across all orders.
SELECT * FROM OrderList
SELECT * FROM EachOrderBreakdown

SELECT CustomerName, SUM(Sales) AS TotalSales
FROM OrderList ol
JOIN EachOrderBreakdown eo
ON ol.OrderID = eo.OrderID
GROUP BY CustomerName
ORDER BY TotalSales DESC
--Ans: Angie Massengill had the highest total sales.
--By joining the two tables, I can pull the total sales grouped by each customer.


--5 Find the month with the highest average sales in the OrderList table.
SELECT MONTH(OrderDate) AS MonthOrder, AVG(Sales) AS AvgSales
FROM OrderList ol
JOIN EachOrderBreakdown eo
ON ol.OrderID = eo.OrderID
GROUP BY MONTH(OrderDate)
ORDER BY AvgSales DESC
--Ans: July had the highest average sales.
--Joining the two tables to find which month had the highest average sales.


--6 Find out the average quantity ordered by customers whose first name starts with an alphabet 'S'?
SELECT AVG(Quantity) AS AvgQuantity
FROM OrderList ol
JOIN EachOrderBreakdown eo
ON ol.OrderID = eo.OrderID
WHERE LEFT(CustomerName, 1) = 'S'
--Ans: The average quantity of customers whose first name starts with 'S' is 3.
--I can determine the average quantity ordered for customers whose first name starts with 'S'.


--7 Find out how many new customer were acquired in the year 2014?
SELECT * FROM OrderList

SELECT COUNT(*) AS NumberofNewCustomers
FROM(
	SELECT CustomerName, MIN(OrderDate) AS FirstOrderDate
	FROM OrderList
	GROUP BY CustomerName
	HAVING YEAR(MIN(OrderDate)) = '2014'
) AS Customer2014
--Ans: There were 204 new customers acquired in 2014.
--The subquery first determines the first order each customer has made if it is in 2014.
--Using the subquery, I can find the number of customers, which represent the new customers in 2014.


--8 Calculate the percentage of total profit contributed by each sub-category to the overall profit.
SELECT * FROM EachOrderBreakdown

SELECT SubCategory, SUM(Profit) AS TotalProfit,
		SUM(Profit)/(SELECT SUM(Profit) FROM EachOrderBreakdown) * 100 AS PercentOfTotal
FROM EachOrderBreakdown
GROUP BY SubCategory
--Using aggregate functions, I first find the total profit.
--Then I find the total profit of each category and find the percentage of each compared to the total profit.


--9 Find the average sales per customer, considering only customers who have made more than three order.
WITH CustomerAvgSales AS(
	SELECT ol.CustomerName, COUNT(DISTINCT ol.OrderID) AS NoOfOrders, AVG(eo.Sales) AS AvgSales
	FROM OrderList ol
	JOIN EachOrderBreakdown eo
	ON ol.OrderID = eo.OrderID
	GROUP BY CustomerName
)
SELECT CustomerName, AvgSales, NoOfOrders
FROM CustomerAvgSales
WHERE NoOfOrders > 3
--Creating a CTE, find the number of orders and average sales per customer.
--Using the CTE created to find the customers that have more than 3 orders.


--10 Identify the top-performing subcategory in each category based on total sales.
--Include the sub-category name, total sales, and a ranking of sub-category within each category.
WITH TopPerformers AS(
	SELECT Category, SubCategory, SUM(Sales) AS TotalSales,
		RANK() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS SubCategoryRank
	FROM EachOrderBreakdown
	GROUP BY Category, SubCategory
)
SELECT *
FROM TopPerformers
WHERE SubCategoryRank = 1
--Creating another CTE with a windows function to rank each subcategory for each category.
--Then pulling each subcategory that are ranked 1 from each category.
