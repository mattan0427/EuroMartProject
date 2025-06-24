Select * From OrderList
Select * From EachOrderBreakdown

--Q1 Establish the relationship the tables as per the ER diagram.
ALTER TABLE OrderList
ADD CONSTRAINT pk_orderid PRIMARY KEY (OrderID)

ALTER TABLE EachOrderBreakdown
ADD CONSTRAINT fk_orderid FOREIGN KEY (OrderID) REFERENCES OrderList (OrderID)
--First altering the tables to create a rule where the OrderID is the primary key in OrderList and foreign key in EachOrderBreakdown.


--Q2 Split City_State_Country into 3 individual columns namely 'City', 'State', 'Country'.
SELECT * FROM OrderList

ALTER TABLE OrderList
ADD City nvarchar(50),
	State nvarchar(50),
	Country nvarchar(50)
--Altering table to add three new columns.

UPDATE OrderList
SET Country = PARSENAME(REPLACE(City_State_Country, ',', '.'), 1), 
	State = PARSENAME(REPLACE(City_State_Country, ',', '.'), 2),
	City = PARSENAME(REPLACE(City_State_Country, ',', '.'), 3)

ALTER TABLE OrderList
DROP Column City_State_Country
--Parsing the City_State_Country column to separate the city, state, and country and adding each to the three new columns.


--Q3 Add a new Category Column using the following mapping as per the first 3 characters in the ProductName Column
--TEC - Technology
--OFS - Office Supplies
--FUR - Furniture
SELECT * FROM EachOrderBreakdown

ALTER TABLE EachOrderBreakdown
ADD Category nvarchar(50)

UPDATE EachOrderBreakdown
SET Category = CASE WHEN LEFT(ProductName, 3) = 'OFS' Then 'Office Supplies'
					WHEN LEFT(ProductName, 3) = 'TEC' Then 'Technology'
					WHEN LEFT(ProductName, 3) = 'FUR' Then 'Furniture'
				END
--Adding another column named Category and using the first three characters in ProductName to determine which category they fit in.


--Q4 Extract the characters after the hyphen from the PorductName Column.
UPDATE EachOrderBreakdown
SET ProductName = RIGHT(ProductName, LEN(ProductName) - CHARINDEX('-', ProductName))
--Deleting the first few characters in ProductName before the hyphen.


--Q5 Remove duplicate rows from EachOrderBreakdown table, if all column values are matching.
SELECT *, ROW_NUMBER() OVER (PARTITION BY OrderID, ProductName, Discount, Sales, Profit, Quantity, SubCategory,
								Category ORDER BY OrderID) AS rn
FROM EachOrderBreakdown
WHERE OrderID = 'AZ-2011-6674300'
--First checking one OrderID to see if it has duplicates.

WITH CTE_duplicate AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY OrderID, ProductName, Discount, Sales, Profit, Quantity, SubCategory,
								Category ORDER BY OrderID) AS rn
FROM EachOrderBreakdown
)
DELETE FROM CTE_duplicate
WHERE rn > 1
--Using a windows function to label each row partioned by each column.
--Creating a CTE and deleting every row that is greater than 1 in the rn column.
--This gets rid of all duplicate rows.


--Q6 Replace Blank with NA in OrderPriority Column in OrdersList table.
SELECT * FROM OrderList

UPDATE OrderList
SET OrderPriority = 'NA'
WHERE OrderPriority IS NULL;
--This updates the OrderList table to replace and row that is Null with NA in the OrderPriority column.
