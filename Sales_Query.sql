------CREATE NEW COLUMN 

---SPLIT THE CUSTOMER_NAME AS FIRST_NAME AND LAST_NAME
ALTER TABLE ListOfOrders
ADD First_Name VARCHAR(50), 
    Last_Name VARCHAR(50);  

UPDATE ListOfOrders
SET First_Name = SUBSTRING(Customer_Name, 1, CHARINDEX(' ', Customer_Name) - 1),
    Last_Name = SUBSTRING(Customer_Name, CHARINDEX(' ', Customer_Name) + 1, LEN(Customer_Name) - CHARINDEX(' ', Customer_Name));
	
---CUSTOMER_ID

ALTER TABLE ListOfOrders
ADD Customer_ID VARCHAR(20);

UPDATE ListOfOrders
SET Customer_ID = CONCAT(First_Name, RIGHT(CAST(Order_ID AS VARCHAR), 5));


----MERGE TWO TABLES AND CREATE VIEW

CREATE VIEW Sales AS
SELECT lo.*, ob.[Product_Name], ob.Discount, ob.Sales, ob.Profit, ob.Quantity, ob.Category, ob.[Sub_Category]
FROM ListOfOrders AS lo
INNER JOIN OrderBreakdown AS ob ON lo.[Order_ID] = ob.[Order_ID];

----TOP 10 CUSTOMERS

CREATE VIEW TOP_10_Customers AS
SELECT TOP 10 lo.Customer_ID, lo.Customer_Name, lo.Country, SUM(s.Sales) AS TotalSales, SUM(s.Profit) AS TotalProfit
FROM ListOfOrders lo
INNER JOIN Sales s ON lo.Customer_ID = s.Customer_ID
GROUP BY lo.Customer_ID, lo.Customer_Name ,lo.Country
ORDER BY SUM(s.Sales) + SUM(s.Profit) DESC;

CREATE VIEW TOP_10_Customers AS
SELECT TOP 10 lo.Customer_ID, lo.Customer_Name, lo.Country, SUM(s.Sales) AS TotalSales
FROM ListOfOrders lo
INNER JOIN Sales s ON lo.Customer_ID = s.Customer_ID
GROUP BY lo.Customer_ID, lo.Customer_Name ,lo.Country
ORDER BY TotalSales DESC;

SELECT TOP 10 lo.Customer_ID, lo.Customer_Name, lo.Country, SUM(s.Profit) AS Total_Profit
FROM ListOfOrders lo
INNER JOIN Sales s ON lo.Customer_ID = s.Customer_ID
GROUP BY lo.Customer_ID, lo.Customer_Name ,lo.Country
ORDER BY Total_Profit DESC;



select distinct country
from sales