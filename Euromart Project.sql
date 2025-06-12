Select * From OrderList
Select * From EachOrderBreakdown

--Q1 Establish the relationship the tables as per the ER diagram.
ALTER TABLE OrderList
ADD CONSTRAINT pk_orderid PRIMARY KEY (OrderID)

ALTER TABLE EachOrderBreakdown
ADD CONSTRAINT fk_orderid FOREIGN KEY (OrderID) REFERENCES OrderList (OrderID)


--Q2 Split City_State_Country into 3 individual columns namely 'City', 'State', 'Country'.
SELECT * FROM OrderList

ALTER TABLE OrderList
ADD City nvarchar(50),
	State nvarchar(50),
	Country nvarchar(50)

UPDATE OrderList
SET Country = PARSENAME(REPLACE(City_State_Country, ',', '.'), 1), 
	State = PARSENAME(REPLACE(City_State_Country, ',', '.'), 2),
	City = PARSENAME(REPLACE(City_State_Country, ',', '.'), 3)

ALTER TABLE OrderList
DROP Column City_State_Country



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


--Q4 Extract the characters after the hyphen from the PorductName Column.
UPDATE EachOrderBreakdown
SET ProductName = RIGHT(ProductName, LEN(ProductName) - CHARINDEX('-', ProductName))


--Q5 Remove duplicate rows from EachOrderBreakdown table, if all column values are matching.
SELECT *, ROW_NUMBER() OVER (PARTITION BY OrderID, ProductName, Discount, Sales, Profit, Quantity, SubCategory,
								Category ORDER BY OrderID) AS rn
FROM EachOrderBreakdown
WHERE OrderID = 'AZ-2011-6674300'


WITH CTE_duplicate AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY OrderID, ProductName, Discount, Sales, Profit, Quantity, SubCategory,
								Category ORDER BY OrderID) AS rn
FROM EachOrderBreakdown
)
DELETE FROM CTE_duplicate
WHERE rn > 1


--Q6 Replace Blank with NA in OrderPriority Column in OrdersList table.
SELECT * FROM OrderList

UPDATE OrderList
SET OrderPriority = 'NA'
WHERE OrderPriority IS NULL;