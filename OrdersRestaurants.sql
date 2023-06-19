-- Inspect Data from two tables
SELECT * FROM RestaurantOrders.dbo.Orders

SELECT * FROM RestaurantOrders.dbo.Restaurants


-------------------- Section A: Data Cleaning and Inspection --------------------

--1. Inspect Columns and Values (Orders Table)

SELECT DISTINCT(Order_ID)
FROM RestaurantOrders.dbo.Orders
/* Each order has a distinct OrderNumber, no cleaning necessary */ 

SELECT DISTINCT(Customer_Name)
FROM RestaurantOrders.dbo.Orders
/* 21 distinct customers who ordered throughout the day on the app, no cleaning necessary */

SELECT DISTINCT(Restaurant_ID)
FROM RestaurantOrders.dbo.Orders
/* 20 participating restaurants, no cleaning necessary */

SELECT DISTINCT(Order_Date)
FROM RestaurantOrders.dbo.Orders
/* Orders made on 2022-01-01 between 11:10am and 11:58pm, no cleaning necessary */

SELECT DISTINCT(Quantity_of_Items)
FROM RestaurantOrders.dbo.Orders
/* Quantity between 1-7 items, no cleaning necessary */

SELECT DISTINCT(Order_Amount)
FROM RestaurantOrders.dbo.Orders
/* Order value between $3 and $1198, no cleaning necessary */

SELECT DISTINCT(Payment_Mode)
FROM RestaurantOrders.dbo.Orders
/* Three different payment modes, no cleaning necessary */

SELECT DISTINCT(Delivery_Time_Taken_mins)
FROM RestaurantOrders.dbo.Orders
/* Delivery time between 10mins and 50mins, no cleaning necessary */

SELECT DISTINCT(Customer_Rating_Food)
FROM RestaurantOrders.dbo.Orders
/* Rating between 1 to 5, no cleaning necessary */

SELECT DISTINCT(Customer_Rating_Delivery)
FROM RestaurantOrders.dbo.Orders
/* Rating between 1 to 5, no cleaning necessary */

--2. Inspect Columns and Values (Restaurants Table)

SELECT DISTINCT(RestaurantID)
FROM RestaurantOrders.dbo.Restaurants
/* 20 restaurants listed on the food delivery app, no cleaning necessary */ 

SELECT DISTINCT(RestaurantName)
FROM RestaurantOrders.dbo.Restaurants
/* 20 distinct restaurant names, no cleaning necessary */ 

SELECT DISTINCT(Cuisine)
FROM RestaurantOrders.dbo.Restaurants
/* 8 distinct cuisines, no cleaning necessary */

SELECT DISTINCT(Zone)
FROM RestaurantOrders.dbo.Restaurants
/* 4 distinct zones, A to D, no cleaning necessary */

SELECT DISTINCT(Category)
FROM RestaurantOrders.dbo.Restaurants
/* 2 distinct categories, Ordinary and Pro, no cleaning necessary */


-------------------- Section B: Exploring Customer Behaviour --------------------
SELECT * FROM RestaurantOrders.dbo.Orders
SELECT * FROM RestaurantOrders.dbo.Restaurants

--1. Exploring number of orders
;WITH numberoforders as 
(
SELECT Customer_Name, COUNT(Customer_Name) as Total_Orders
FROM RestaurantOrders.dbo.Orders
GROUP BY Customer_Name
--ORDER BY 2
 )
SELECT AVG(Total_Orders)
FROM numberoforders
/* Customers order between 14 to 34 times per day, with the average being 23 times */

--2. Exploring order value
SELECT AVG(Order_Amount) as Avg_Order_Amount
FROM RestaurantOrders.dbo.Orders
/* Avg_Order_Amount is $598*/

SELECT Customer_Name, SUM(Order_Amount) as Total_Order_Amount, COUNT(Customer_Name) as Number_Of_Orders, AVG(Order_Amount) as Avg_Spend_Person
FROM RestaurantOrders.dbo.Orders
GROUP BY Customer_Name
ORDER BY 4 desc
/*Avg spend per person based on total order amount and number of orders */ 

SELECT Customer_Name, SUM(Order_Amount) as Total_Order_Amount, SUM(Quantity_of_Items) as Total_Items_Ordered, SUM(Order_Amount)/SUM(Quantity_of_Items) as Avg_Spend_Item
FROM RestaurantOrders.dbo.Orders
GROUP BY Customer_Name
ORDER BY 4 desc
/*Avg spend per item based on total order amount and number of items ordered */ 

--3. Exploring customer preference and restaurant popularity
SELECT Restaurant_ID, RestaurantName, COUNT(Restaurant_ID) as Restaurant_Freq
FROM RestaurantOrders.dbo.Orders
JOIN RestaurantOrders.dbo.Restaurants
ON Orders.Restaurant_ID = Restaurants.RestaurantID
GROUP BY Restaurant_ID, RestaurantName
ORDER BY Restaurant_Freq DESC
/* Most popular restaurants were The Cave Hotel and Ellora, ordered from 32 times each*/

SELECT Cuisine, COUNT(Restaurant_ID) as Restaurant_Freq
FROM RestaurantOrders.dbo.Orders
JOIN RestaurantOrders.dbo.Restaurants
ON Orders.Restaurant_ID = Restaurants.RestaurantID
GROUP BY Cuisine
ORDER BY Restaurant_Freq DESC
/* Most popular cuisines were Chinese and North Indian, ordered from 81 times each */

-------------------- Section C: Exploring Restaurant Performance --------------------
SELECT * FROM RestaurantOrders.dbo.Orders
SELECT * FROM RestaurantOrders.dbo.Restaurants

--1. Exploring restaurant sales
SELECT RestaurantName, SUM(Order_Amount) as Total_Sales
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY RestaurantName
ORDER BY 2 desc
/* Top selling restaurant is Veer Restaurant*/ 

SELECT Cuisine, SUM(Order_Amount) as Total_Sales
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY Cuisine
ORDER BY 2 desc 
/* Top selling cuisine is North Indian */ 

SELECT Zone, SUM(Order_Amount) as Total_Sales
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY Zone
ORDER BY 2 desc
/* Top selling zone is Zone D */ 

--2. Exploring restaurant ratings
SELECT RestaurantName, AVG(CAST(Customer_Rating_Food AS DECIMAL(10,2))) as Avg_Rating
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY RestaurantName
ORDER BY 2 desc
/* Top rated restaurant is Vrinda Bhavan*/ 

SELECT Cuisine, AVG(CAST(Customer_Rating_Food AS DECIMAL(10,2))) as Avg_Rating
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY Cuisine
ORDER BY 2 desc
/* Top rated cuisine is North Indian */ 

SELECT Zone, AVG(CAST(Customer_Rating_Food AS DECIMAL(10,2))) as Avg_Rating
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY Zone
ORDER BY 2 desc
/* Top rated zone is Zone C */ 

-------------------- Section D: Exploring Delivery Performance --------------------
SELECT * FROM RestaurantOrders.dbo.Orders
SELECT * FROM RestaurantOrders.dbo.Restaurants

--1. Exploring delivery ratings
SELECT RestaurantName, AVG(CAST(Customer_Rating_Delivery AS DECIMAL(10,2))) as Avg_Rating
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY RestaurantName
ORDER BY 2 desc
/* Top rated delivery by restaurant is The Cave Hotel */ 

SELECT Cuisine, AVG(CAST(Customer_Rating_Delivery AS DECIMAL(10,2))) as Avg_Rating
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY Cuisine
ORDER BY 2 desc
/* Top rated delivery by cuisine is South Indian */ 

SELECT Zone, AVG(CAST(Customer_Rating_Delivery AS DECIMAL(10,2))) as Avg_Rating
FROM RestaurantOrders.dbo.Restaurants
JOIN RestaurantOrders.dbo.Orders
ON Restaurants.RestaurantID = Orders.Restaurant_ID
GROUP BY Zone
ORDER BY 2 desc
/* Top rated delivery by zone is Zone C */ 