-- create database 
create  DataBase online bookstore ;
__Switch to the database
\c OnlineBookstore;
--create Tables
Drop Tables If Exists Books;
Create Table Books(
Book_ID	serial Primary key ,
Title Varchar(100),	
Author	Varchar(100),	
Genre	Varchar(100),	
Published_Year Int,	
Price	Numeric(10,2),
Stock Int	
);
select*from books;
Drop Tables If Exists Customer;
Create Table Customers(
Customer_ID Serial Primary Key,
Name Varchar(100),	
Email Varchar(100),	
Phone Varchar(100),	
City Varchar(100),	
Country Varchar(150)	
);
Drop Tables If Exists orders;
Create Table Orders(
Order_ID Serial Primary key,
Customer_ID INT References Customers( Customer_Id),
Book_ID INT References Books( Book_ID),
Order_Date Date,
Quantity INT,
Total_Amount Numeric(10,2)
);
select*from Books;
select* from Customers;
Select* from Orders;

__ impot data into Book Table

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\Books.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

__ Imort Data Into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:/Customers.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

__ Import Data Into Order Table
Copy Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
From 'D:\Orders.csv'
WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

__1)Retrive all books in the "Friction" genre;
 select*from Books
 where Genre='Fiction';
--2)find the book publish after the year  1950;
select*from books
where Published_year>1950;
--3)List all Customer from the canada;
select*from Customers
where country='Canada';
--4)show orders placed in november 2023;
select*from orders
where order_date BETWEEN '2023-11-01'and '2023-11-30';
--5)retrieve the total stock of book available;
select sum(stock)as total_stock
from Books;
--6) find the detail of the most Expensive book;
select*from Books order By Price DESC LIMIT 1;
--7 shows all customer who orderd more than 1 quantity of a book;
select*from orders
where quantity>1;
--8) Retrieve all orders where the total amount exceeds $20;
select*from orders
where total_amount>20;
--9) list all genres available in the book table;
select Distinct genre from Books;
--10)find the  book with the lowest stock;
select*from Books order by stock Limit 1;
--11) calculate the total revenue generated from all orders;
select SUM(total_amount) as Revenue from orders;

--Advance 
--1) retrieve the total number of books sold for each genre;
select*from orders;
select b.genre,SUM(o.quantity)as total_book_sold
from orders o
JOIN Books b ON o.book_id= b.book_id
Group By b.genre;
--2) find the average price of Books in the "Fantasy" genre;
select avg(price)as average_price 
from Books
Where genre='Fantasy';
--3) List customer who have placed at least 2 orders;
select o.customer_id,c.name,Count(o.order_id)as order_count
from orders o
JOIN customers c ON o.customer_id= c.customer_id
GROUP By o.customer_id,c.name
Having Count(order_id)>=2;
--4)find the atmost frequently orderd Book;
select book_id,count(order_id)as order_count
from orders
GROUP By Book_id
Order By order_count DESC Limit 1;
--5) show the top 3 most expensively of 'fantasy' genre;
select *from books
where genre='Fantasy'
order By price Desc Limit 3;
--6)retrieve the total quantity of book sold by each other;
select b.author, SUM(o.quantity)as total_Books_sold
From orders o
JOIN books b ON o.book_id=b.book_id
Group By b.Author;
--7)list the cities where customer whose spent over $30 are loacation;
select Distinct c.city, total_amount
from orders o
JOIN customers c ON o.customer_id=c.customer_id
where o.total_amount>30;

--8)find  the customer who spent the most orders;
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;
--9)calculate the stock reamaining after fulfilling all orders;
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
