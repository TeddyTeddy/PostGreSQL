-- NOTE: We use Northwind db unless otherwise stated
-- How to list all the available tables in a database?
-- https://stackoverflow.com/questions/14730228/postgresql-query-to-list-all-table-names
    SELECT table_name
    FROM information_schema.tables
    WHERE table_type='BASE TABLE'
    AND table_schema='public';

-- Lecture 5:
DROP DATABASE "AdventureWorks" WITH (FORCE);

-- Section 3: Simple Selection Of All Records
-- Lecture 6: Selecting All Data From A Table
    select * from customers;

-- Lecture 7: Selecting specific fields
-- How to get the schema for a specific table (e.g. suppliers)
    select *
    from information_schema.columns
    where table_name = 'suppliers';

-- Get companyname, city and country fields from suppliers table
    select companyname, city, country from suppliers;

-- Get categoryname and description fields from categories table
    select categoryname, description from categories;

-- Lecture 8: Selecting Distinct Values
-- List all of the customers' countries (without duplicates)?
    select distinct country from customers
-- List all of the customers' city & countries (without duplicates)?
    select distinct city, country from customers
-- What are the unique regions our suppliers are in?
    select distinct region from suppliers

-- Lecture 9: Counting results
-- How many entries do we have in products table?
   select count(*) from products;
-- How many orders have we had so far?
   select count(*) from orders;
-- How many cities are our Suppliers in?
    select count(*) from (select distinct city from suppliers) as T;   -- or
    select count(distinct city) from suppliers;
-- How many distinct products have been ordered (hint. use order details table)
    select count(distinct productid) from order_details;

-- Lecture 10: Combining fields in SELECT
-- List customerid and difference between shippeddate and orderdate for all our orders
select customerid, shippeddate - orderdate as delta from orders;

-- List order_id and the amount spent using order_details (unitprice times quantity minus discount)
select orderid, ((unitprice * quantity) - discount) as amount_spent from order_details

-- Lecture 11: Practice what you learned
-- NOTE: At this lecture, we use pagila database

-- Select all fields, and all records from actor table
    select * from actor;

-- Select all fields and records from film table
    select * from film;

-- Select all fields and records from the staff table
    select * from staff;

-- Select address and district columns from address table
    select address, district from address;

-- Select title and description from film table
    select title, description from film;

-- Select city and country_id from city table
    select city, country_id from city;

-- Select all the distinct last names from customer table
    select distinct last_name from customer;

-- Select all the distinct first_names from the actor table
    select distinct first_name from actor;

-- Select all the distinct inventory_id values from rental table
    select distinct inventory_id from rental;

-- Find the number of films ( COUNT ).
    select count(*) from film;

-- Find the number of categories.
    select count(*) from category;

-- Find the number of distinct first_names in actor table
    select count(distinct first_name) from actor;
    -- Find the number of distinct (first_name, last_name) pairs
    select count(distinct(first_name, last_name)) from actor;

-- Select rental_id and the difference between return_date and rental_date in rental table
    select rental_id, return_date - rental_date as diff from rental;

-- Section 4: What if you dont want all records? Using WHERE to select records
-- Lecture 13: Searching for specific text
    where customer_name='David Brown'
-- What if your text contains single quotes itself?
    where title='Drop Can''t, Embrace Can'
-- NOTE: In PostGreSQL, you can't use double quotes to limit a string. Double quotes have other usage in PostGreSQL

-- NOTE: We use Northwind db unless otherwise stated
-- All my suppliers from Berlin
   select * from suppliers where city = 'Berlin'
-- Find all customer companynames and the lead contactnames in Mexico
    select companyname, contactname from customers where country='Mexico';

-- Lecture 14: Searching Numeric fields
-- Find the number of orders by employee with id of 3 (Janet Levering)
    select count(*) from orders where employeeid = 3;
-- Number of order details that had more than 20 items ordered
   select count(*) from order_details where quantity > 20;
-- How many orders had a freight cost equal to or greater than 250$
   select count(*) from orders where freight >= 250;

-- Lecture 15: Searching DATE fields
-- Basic Syntax for Date Fields
    where orderdate = '1996-07-04'
    where orderdate > '1996-07-04'
    where orderdate >= '1996-07-04'
    where orderdate < '1996-07-04'
    where orderdate <= '1996-07-04'

-- How to determine the current clock and the format of datetime based on your systems locale?
    select now()   --> 2020-10-19 15:33:12.096909+03

-- Find Number of Orders ordered on or after Jan 01, 1998
    select count(*) from orders where orderdate >= '1998-01-01';
    select count(*) from orders where orderdate >= date('Jan-01-1998');

-- How many orders shipped before July 5, 1997
    select count(*) from orders where shippeddate < '1997-07-05';
    select count(*) from orders where shippeddate < date('July-5-1997');


-- Lecture 16: WHERE using logical AND operator
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where condition 1 and condition 2 and condition 3 and ...

-- How many orders shipped to Germany with fright cost more than 100$
    select count(*) from orders where shipcountry='Germany' and freight>100;

-- We want the distict customers where orders were shipped shipped via United Package (id = 2)
-- and the ship country is Brazil
    select distinct(customerid) from orders where shipvia=2 and shipcountry='Brazil'


-- Lecture 17: WHERE using logical OR operator
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where condition 1 or condition 2 or condition 3 or ...

-- How many customers do we have in USA and Canada
    select count(*) from customers where country='USA' or country='Canada';
    select * from customers where country = 'USA' or country = 'Canada';

-- How many suppliers do we have in Germany and Spain
    select count(*) from suppliers where country='Germany' or country='Spain';
    select count(*) from suppliers where country in ('Germany', 'Spain');

-- How many orders shipped to USA, Brazil and Argentina
    select count(*) from orders where shipcountry in ('USA', 'Brazil', 'Argentina');

-- Lecture 18: WHERE using logical NOT operator
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where NOT <condition>

-- IMPORTANT: In postgres, unlike MySQL, string searching operations are case-sensitive by default
-- How many customers are not in France
   select count(*) from customers where not country='France';
   select count(*) from customers where country != 'France';

-- How many suppliers are not in USA
    select count(*) from suppliers where not country='USA'
    select count(*) from suppliers where country!='USA'

-- Lecture 19: WHERE combining AND, OR and NOT
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where not ((<condition1> and not <condition2>) or <condition3>)

-- How many orders are shipped to Germany and freight charges < 50 or > 175
    select count(*) from orders where shipcountry='Germany' and (freight < 50 or freight > 175);
    select count(*) from orders where shipcountry = 'Germany' and not (freight >= 50 and freight <= 175);

-- How many orders shipped to Canada or Spain and shippeddate after May 1, 1997
    select count(*) from orders where (shipcountry='Canada' or shipcountry='Spain') and shippeddate > '1997-05-01';
    select count(*) from orders where shipcountry in ('Canada', 'Spain') and shippeddate > date('May-1-1997');

-- Lecture 20 : Using BETWEEN
-- where freight between 50 and 100
-- This is the same as:
-- where fright >= 50 and freight <= 100

-- How many order details have a unit price between $10 and $20
    select count(*) from order_details where unitprice between 10 and 20;

-- How many orders shipped between June 1, 1996 and Sept 30, 1996
    select count(*) from orders where shippeddate between '1996-06-01' and '1996-09-30';
    select count(*) from orders where shippeddate between date('Jun-1-1996') and date('Sept-30-1996');


-- Lecture 21 : Using IN
-- Basic Syntax
-- where id in (22, 3, 5, 7)
-- or
-- where id = 22 or id = 3 or id = 5 or id = 7

-- How many suppliers are located in Germany, France, Spain or Italy
select count(*) from suppliers where country in ('Germany', 'France', 'Spain', 'Italy')

-- How many products do we have in categoryid 1,4,6 or 7
select count(*) from products where categoryid in (1, 4, 6, 7)

-- Lecture 22
-- Select all records from data_src which came from the journal named 'Food Chemistry'.
    select * from data_src where journal='Food Chemistry';

-- Select record from nutr_def where nutrdesc is Retinol.
    select * from nutr_def where nutrdesc = 'Retinol';

-- Find all the food descriptions (food_des) records for manufacturer Kellogg, Co.
-- (must include punctuation for exact match).
    select * from food_des where manufacname='Kellogg, Co.';

-- Find the number of records in data sources (data_src) that were published after year 2000 (it is numeric field).
    select count(*) from data_src where year > 2000;

-- Find the number of records in food description that have a fat_factor < 4.
    select count(*) from food_des where fat_factor < 4;

-- Select all records from weight table that have gm_weight of 190.
    select * from weight where gm_wgt = 190.0;

-- Find the number of records in food description table that have pro_factor greater than 1.5 and fat_factor less than 5.
    select * from food_des where pro_factor > 1.5 and fat_factor < 5;

-- Find the record in data source table that is from year 1990 and the journal Cereal Foods World.
    select * from data_src where year = 1990 and journal = 'Cereal Foods World';

-- Select count of weights where gm_wgt is greater than 150 and less than 200.
    select count(*) from weight where gm_wgt > 150 and gm_wgt < 200;

-- Select the records in nutr_def table (nutrition definitions) that have units of kj or kcal.
    select * from nutr_def where units in ('kj', 'kcal');

-- Select all records from data source table (data_src) that where from the year 2000 or the journal Food Chemistry.
    select * from data_src where year = 2000 and journal = 'Food Chemistry';

-- How many records in food_des are not about food group Breakfast Cereals.
-- The field fdgrp_cd is an id field and you will have to find it in fd_group for fddrp_desc = 'Breakfast Cereals'.
    select count(*) from food_des where fdgrp_cd != (select distinct fdgrp_cd from fd_group where fddrp_desc = 'Breakfast Cereals');
    select count(*) from food_des left join fd_group using(fdgrp_cd) where not fddrp_desc = 'Breakfast Cereals';

-- Find all the records in data sources that where between 1990 and 2000 and either 'J. Food Protection' or 'Food Chemistry'.
    select * from data_src where (year between 1990 and 2000) and (journal in ('J. Food Protection', 'Food Chemistry'))

-- Use BETWEEN syntax to find number of weight records that weight between 50 and 75 grams (gm_wgt).
    select * from weight where gm_wgt between 50 and 75;

-- Select all records from the data source table that were published
-- in years 1960,1970,1980,1990, and 2000.  Use the IN syntax.
    select * from data_src where year in (1960,1970,1980,1990, 2000);

-- Lecture 23 : Schema Basics
-- Q) What is PostgreSQL schema?
-- A) In PostgreSQL, a schema is a namespace that contains named database objects such as tables.
-- views, indexes, data types, functions, stored procedures and operators. To access an object in a schema, 
-- you need to qualify the object by using the following syntax: schema_name.object_name.
-- Reference: https://www.postgresqltutorial.com/postgresql-schema/

-- Select everything from product table in production schema
    select * from production.product

-- Select verything from the vendor table in purchasing schema
    select * from purchasing.vendor

-- Q) How to query vendor table's table schema?
    select column_name, data_type, character_maximum_length, column_default, is_nullable
    from INFORMATION_SCHEMA.COLUMNS where table_name = 'vendor';

-- Section 6: Using psql to connect to PostGres
-- Lecture 24: Connecting with psql
-- Basic syntax
   psql --port=5433 --host=localhost --dbname=northwind --username=postgres

-- Lecture 26 & 27: psql commands
-- listing databases: \l
-- clearing screen:   \! clear
-- how to switch to another database while logged in: \c AdventureWorks
-- See list of schemas: \dn
-- List all tables under a schema : \dt <schema name>. : e.g. \dt sales.
-- List entries inside a table under a schema: select * from sales.store limit 1;

-- Lecture 28: ORDER BY
-- Syntax:
-- select <column1>, <column2> from <table_name>
-- order by column1, column2, ... ASC|DESC

-- NOTE: We use Northwind db unless otherwise stated
-- List of countries of suppliers in ascending alphabetical order
    select distinct(country) from suppliers order by country asc
-- List of countries and their cities of suppliers in ascending alphabetical order
    select distinct country, city from suppliers order by country, city asc

-- Get a list of product names and unit prices
-- order by price highest to lowest
-- and the product names from a to z
    select productname, unitprice from products
    order by unitprice desc, productname asc;

-- Lecture 29: MIN & MAX
-- Syntax:
-- select min(column) from <table_name> where <condition>
-- select max(column) from <table_name> where <condition>

-- When was the first order ordered from Italy
    select min(orderdate) from orders where shipcountry='Italy';

-- When was the last order shipped to Canada?
    select max(shippeddate) from orders where shipcountry = 'Canada';

-- Find the longest period between ship date and order date:
    select max(shippeddate-orderdate) from orders where shipcountry = 'France' and shippeddate is not null and orderdate is not null;

-- Find the slowest order sent to France based on order date vs. ship date
    select * from orders where shipcountry = 'France' and shippeddate is not null and orderdate is not null
    order by (shippeddate-orderdate) desc limit 1;
    -- OR
    select * from orders
    where (shippeddate-orderdate) = (
        select max(shippeddate-orderdate) from orders where shipcountry = 'France' and shippeddate is not null and orderdate is not null
    ) and shipcountry = 'France';

-- Lecture 30: AVG and SUM
-- Syntax:
-- select avg(column) from <table_name> where <condition>
-- select sum(column) from <table_name> where <condition>

-- What was average freight of orders shipped to Brazil
    select avg(freight) from orders where shipcountry='Brazil';

-- How many individual items of Tofu (productid=14) were ordered
    select sum(quantity) from order_details where productid = (select productid from products where productname='Tofu');
    select sum(quantity) from products inner join order_details using(productid) where productname='Tofu';


-- What was the average number of Steeleye Stout (productid=35) per order
  select avg(quantity) as avg_quantity from order_details
    where productid = (
	    select productid from products where productname='Steeleye Stout'
    );
    -- OR
    select  avg(quantity) as avg_quantity from products inner join order_details using(productid)
    where productname='Steeleye Stout';

-- Lecture 31: LIKE to match patterns
-- Syntax:
-- select <column1>, <column2>, ... from <table_name>
-- where <column> LIKE <pattern>
    -- pattern is case sensitive
    -- % stands for zero, one or more characters
    -- _ stands for any single character

-- what customers have a contact whose first name starts with D?
    select * from customers where contactname like 'D%'

-- Which of our suppliers have 'or' as the 2.nd and 3.rd letters in the company name?
    select companyname from suppliers where companyname like '_or%'

-- Which customer company names end in 'er'?
    select companyname from customers where companyname like '%er'

-- Lecture 32: Renaming columns using AS alias
-- Syntax
-- Select <column1> as alias_name from <table_name>
    -- list the total amount spent per order details
    select ((unitprice*quantity)-discount) as total_amount_spent from order_details;

    -- list the total amount spent per order details & order it by total amount spent in asc fashion
    select ((unitprice*quantity)-discount) as total_amount_spent from order_details
    order by total_amount_spent asc;

-- calculate our inventory value of products
-- (need unitprice and unitsinstock fields)
-- and return as total_inventory
-- order by this column desc
    select productid, productname, unitprice*unitsinstock as inventory_value from products
    order by inventory_value desc;

-- Lecture 33: LIMIT the number of records returned
-- Syntax: select <column1>, <column2> ... from <table_name> limit number

-- Find 3 most expensive order details
   select *, ((unitprice*quantity)-discount) as total_spent from order_details order by total_spent desc limit 3;

-- List the 2 products with the least inventory in stock by total dollar amount of inventory
    select *, (unitprice*unitsinstock) as total_dollar_amount from products order by total_dollar_amount asc limit 2;

-- Lecture 34: NULL value
-- NULL is a special value that signifies unknown
-- not 0, not empty
-- Syntax for searching null:
-- select <column1>, <column2> from table_name where <columnX> is null
-- select <column1>, <column2> from table_name where <columnX> is not null

-- How many customers dont have a region value?
   select count(*) from customers where region is null;

-- How many suppliers have a region value?
    select count(*) from suppliers where region is not null;

-- How many orders did not have a ship region?
    select count(*) from orders where shipregion is null;

-- Lecture 35: Exercises
-- AdventureWorks database for Lecture 35
-- Return the name, weight, and productnumber of  all the products  ordered by weight from lightest to heaviest.
-- (Remember to use schema to reach table.  It is in production schema.)
    select
        product.name,
        product.weight,
        product.productnumber
    from production.product
    order by product.weight asc;

-- Return the records from purchasing.productvendor for productid = 407 in order of averageleadtime from shortest to longest.
    select * from purchasing.productvendor
    where productid = 407
    order by averageleadtime asc;

-- Find all the sales.salesorderdetail records for productid 799 and order them by largest orderqty to smallest.
    select * from sales.salesorderdetail where productid=799 order by orderqty desc;

-- What is the largest  discount percentage offered in the specialoffer table.
    select discountpct from sales.specialoffer order by discountpct desc limit 1;
    select max(discountpct) from sales.specialoffer;

-- Find the smallest number of sickleavehours for an employee.
    select sickleavehours from humanresources.employee order by sickleavehours asc limit 1
    select min(sickleavehours) from humanresources.employee

-- Find entry for the employee with the smallest sickleave hours
    select * from humanresources.employee order by sickleavehours asc limit 1

-- Find the largest rejected quantity in the purchaseorderdetail table
    select rejectedqty from purchasing.purchaseorderdetail order by orderqty desc limit 1
    select max(rejectedqty) as max_rejected_qty from purchasing.purchaseorderdetail

-- Find the average rate from employeepayhistory table.
    select avg(rate) as average_rate from humanresources.employeepayhistory;

-- Find the average standardcost in the productcosthistory table for productid 738.
    select avg(standardcost) as avg_std_cost from production.productcosthistory where productid = 738;

-- Find the sum of scrappedqty from the workorder table for productid 529.
    select sum(scrappedqty) as sum_scrapped_qty from production.workorder where productid = 529;

-- Find all vendor names with a name that starts with letter G.
    select distinct vendor.name from purchasing.vendor where vendor.name like 'G%'

-- Find all vendor names that have the word Bike in them.
    select distinct vendor.name from purchasing.vendor where vendor.name like '%Bike%';

-- Search the person table for every firstname that has t as a second letter.
    select * from person.person where person.firstname like '_t%';

-- Return the first 20 records from emailaddress table
    select * from person.emailaddress limit 20;

-- Return the first 2 records from productcategory table
    select * from production.productcategory limit 2;

-- How many product records have a missing weight value
    select count(*) from production.product where product.weight is null;

-- How many person records have an additionalcontactinfo field that has a value
    select count(*)  from person.person where additionalcontactinfo is not null;

-- Section 8: Joining multiple tables together
-- https://dataschool.com/how-to-teach-people-sql/full-outer-join-animated/
-- Keep in mind, we use Northwind as the database, and refer to 01-Northwind-A4-Size-for-Print.png
-- Lecture 37: Grabbing Info from Two tables
    -- Do you want records that only have data on both tables (inner join)
        -- e.g. only orders with order details
    -- Do you want all records from first table and any records from second (Left join)
        -- e.g. all customers and any orders they might have
    -- Do you want all records of one table matched with all records of second table? (cross join)

-- Inner Join Syntax:
   select <column1>, <column2>, ...
   from table1 inner join table2
   on table1.column_name = table2.column_name

-- List a table that gives customername, orderdate and shipcounty
select companyname, contactname, orderdate, shipcountry from customers inner join orders
on customers.customerid = orders.customerid

-- Connect employees to orders and pull back firstname, lastname and order date for all orders
select firstname, lastname, orderdate from employees inner join orders
on employees.employeeid = orders.employeeid;

-- connect products and suppliers and pull back companyname, unitprice and unitsinstock
select companyname, unitprice, unitsinstock from products inner join suppliers
on products.supplierid = suppliers.supplierid;

-- Lecture 38: Grabbing information from multiple tables
-- Syntax:
   select <column1>, <column2>, ...
   from table1 inner join table2 on table1.column_name = table2.column_name
               inner join table3 on table1.column_name = table3.column_name
               inner join table4 on table1.column_name = table4.column_name
               ...

-- Connect Customers, Orders, OrderDetails
-- Bring back companyname (Customers), orderdate (Orders),
-- productid (OrderDetails), unitprice (OrderDetails) and quantity (OrderDetails)
select companyname, orderdate, productid, unitprice, quantity
from orders inner join customers on customers.customerid = orders.customerid
            inner join order_details on orders.orderid = order_details.orderid;

-- Connect products to previous query and add product name to fiels returned
select customers.companyname, orders.orderdate, order_details.productid, order_details.unitprice, order_details.quantity,
	   products.productname
from orders inner join customers on customers.customerid = orders.customerid
            inner join order_details on orders.orderid = order_details.orderid
            inner join products on products.productid = order_details.productid

-- Connect categories to previous query and add categoryname to fields returned
select customers.companyname, orders.orderdate, order_details.productid, order_details.unitprice, order_details.quantity,
	   products.productname, categories.categoryname
from orders inner join customers on customers.customerid = orders.customerid
            inner join order_details on orders.orderid = order_details.orderid
            inner join products on products.productid = order_details.productid
            inner join categories on products.categoryid = categories.categoryid;

-- Take the previous query and add a WHERE clause selecting the category name of Seafood
-- and the amount spent >= 500
select customers.companyname, orders.orderdate, order_details.productid, order_details.unitprice, order_details.quantity,
	   products.productname, categories.categoryname
from orders inner join customers on customers.customerid = orders.customerid
            inner join order_details on orders.orderid = order_details.orderid
            inner join products on products.productid = order_details.productid
            inner join categories on products.categoryid = categories.categoryid
where categories.categoryname = 'Seafood' and order_details.unitprice * order_details.quantity >= 500;

select companyname, orderdate, productid, productname, order_details.unitprice, quantity
from orders inner join customers using(customerid)
            inner join order_details using(orderid)
			inner join products using(productid)
			inner join categories using(categoryid)
where categoryname = 'Seafood' and (order_details.unitprice * order_details.quantity) >= 500

-- Lecture 39: Left Joins
-- Pulls back all records in the first table and any matching records in the second table
-- Syntax:
   select <column1>, <column2>, ...
   from table1 left join table2 on table1.column_name = table2.column_name

-- Connect Customers table to Orders Table
-- Bring back company name and order id
select companyname, orderid from customers left join orders on customers.customerid = orders.customerid;

-- Take the previous query and look for customers without orders
select companyname from customers left join orders on customers.customerid = orders.customerid
where orderid is null;

-- Do a left join between products and order_details
select productname, orderid  from products left join order_details on products.productid = order_details.productid;

-- Use the previous query and look for products without orders
select productname, orderid  from products left join order_details on products.productid = order_details.productid
where orderid is null;

select * from products left join order_details using(productid)
where order_details.orderid is null;

-- Lecture 40: Right Joins
-- Pull back maching records from the first table and all records in the second table
-- Syntax:
   select <column1>, <column2>, ...
   from table1 right join table2 on table1.column_name = table2.column_name

-- Connect Orders to customers
-- Bring back companyname, orderid and use right join
select companyname, orderid from orders right join customers on orders.customerid = customers.customerid;
select companyname, orderid from orders right join customers using(customerid);

-- Lets look for orders without customers using right join
select orderid, customers.customerid from customers right join orders on customers.customerid = orders.customerid
where customers.customerid is null;

select orderid, orders.customerid from customers right join orders using(customerid)
where customers.customerid is null

-- Lets look for customers without orders using right join
select companyname from orders right join customers on orders.customerid = customers.customerid
where orderid is null;

select companyname from orders right join customers using(customerid)
where orders.orderid is null;

-- Do a right join between customercustomerdemo and customers
select customers.customerid, companyname, customertypeid
from customercustomerdemo right join customers on customercustomerdemo.customerid = customers.customerid;

select customers.customerid, companyname, customercustomerdemo.customertypeid
from customercustomerdemo right join customers using(customerid);

-- Lecture 41: Full joins
-- pulls all records in first table and all records in second table
-- even if there is null in one side or the other side
-- Syntax:
   select <column1>, <column2>, ...
   from table1 full join table2 on table1.column_name = table2.column_name
-- Documentation: https://www.postgresqltutorial.com/postgresql-full-outer-join/

-- Connect Orders to Customers via full join
-- Bring back companyname and orderid
select companyname, orderid from orders full join customers on orders.customerid = customers.customerid
select companyname, orderid from customers full join orders on orders.customerid = customers.customerid
select companyname, orderid from orders full join customers using(customerid);
    -- orders without customers + customers without orders + inner join of customers & orders

-- Do a full join between products and categories
select productname, categoryname from products full join categories on products.categoryid = categories.categoryid;
select productname, categoryname from products full join categories using(categoryid);

-- Lecture 42: Self joins
-- Connect a table back to itself
-- Applicable cases:
    -- Hierarchy - like employees who report to other employees
    -- Looking for similarities or dissimilarities same column
        -- everyone in the same city or same birthdate
-- Usage:
-- Since all the columns are the same, we must use aliases to rename the tables
-- so we can differentiate which version of table we are referring to
    -- Alias A : Employees + Alias B : Employees
    select column1, column2, ..
    from table1 as t1 join table1 as t2 on t1.column=t2.column
    where condition

-- Find customer pairs who are in the same city and order by city ascending
    select c1.companyname as customer_1, c2.companyname as customer_2, c1.city as city
    from customers as c1 join customers as c2 on c1.city = c2.city
    where c1.customerid != c2.customerid
    order by c1.city asc;

    select c1.companyname as customer_1, c2.companyname as customer_2, c1.city
    from customers as c1 join customers as c2 using(city)
    where c1.customerid <> c2.customerid
    order by c1.city asc;

    select
        c1.companyname as customer_1, c2.companyname as customer_2, c1.city
    from customers as c1 inner join customers as c2 using(city)
    where c1.customerid <> c2.customerid
    order by c1.city asc;

-- Find supplier pairs from same country and order by country
    select s1.companyname as supplier1, s2.companyname as supplier2, s1.country as country
    from suppliers as s1 join suppliers as s2 on s1.country = s2.country
    where s1.supplierid <> s2.supplierid
    order by s1.country;

    select
        s1.companyname as supplier1, s2.companyname as supplier2, s1.country
    from suppliers as s1 inner join suppliers as s2 using(country)
    where s1.supplierid <> s2.supplierid
    order by s1.country asc;

-- Lecture 43: using USING keyword in ON statements in joins
-- Usage:
-- on customers.customerid = orders.customerid
-- vs.
-- USING(customerid)

-- Do an inner join of order with order_details with USING
    select *
    from orders inner join order_details using(orderid)

-- add products to the previous join of orders and order_details
    select *
    from orders inner join order_details using(orderid)
                inner join products using(productid)

-- Lecture 44: NATURAL JOIN
-- NATURAL is a shorthand for USING with a list of all columns
-- that are the same in both tables
-- Syntax:
   from table1 natural join table2
   -- equals to
   from table1  inner join table2 using(column)
   -- equals to
   from table1 inner join table2 on table1.column = table2.column

-- join order and order_details using natural join
    select * from orders natural join order_details
    -- equals to
    select * from orders inner join order_details using(orderid)
    -- equals to
    select * from orders inner join order_details on orders.orderid = order_details.orderid

-- add customers to previous query using NATURAL join
-- you must order the joins correctly;
-- The NATURAL must connect previous table to the next table or
-- it will do a cross join connecting every row to every other row
    select * from customers natural join orders
                            natural join order_details

-- Lecture 45: Exercises
-- NOTE: Use the AdventureWorks database unless stated otherwise

-- Join (with inner join) together person, personphone, businessentity and phonenumbertype tables in the person schema.
-- Return first name, middle name, last name, phone number and the name of the phone number type (home, office, etc.)
-- Order by business entity id descending.
select person.firstname, person.middlename, person.lastname, personphone.phonenumber, phonenumbertype.name
from person.person inner join person.personphone using(businessentityid)
			       inner join person.businessentity using(businessentityid)
			       inner join person.phonenumbertype using(phonenumbertypeid)
order by person.businessentityid desc;

-- Join (Inner) productmodel, productmodelproductiondescriptionculture, productdescription and culture from the production schema.
-- Return the productmodel name, culture name, and productdescription description ordered by the product model name in ascending order.
select pm.name, pc.name, description
from production.productmodel as pm inner join production.productmodelproductdescriptionculture using(productmodelid)
						  		   inner join production.productdescription using(productdescriptionid)
						  		   inner join production.culture as pc using(cultureid)
order by pm.name asc;

-- Add a join to previous example to production.product and return the product name field in addition to other information.
select
	product.name,
	productmodel.name,
	culture.name,
	productdescription.description
from production.productmodel
inner join production.product using(productmodelid)
inner join production.productmodelproductdescriptionculture using(productmodelid)
inner join production.productdescription using(productdescriptionid)
inner join production.culture using(cultureid)
order by productmodel.name asc;


-- Join product and productreview in the schema table.  Include every record from product and any reviews they have.
-- Return the product name, review rating and comments.  Order by rating in ascending order.
select 	product.name,
		productreview.rating,
		productreview.comments
from production.product left join production.productreview using(productid)
order by productreview.rating asc;


-- Use a right join to combine workorder and product from production schema to bring back all products and any work orders they have.
-- Include the product name and workorder orderqty and scrappedqty fields.  Order by productid ascending
select
		product.name,
		workorder.orderqty,
		workorder.scrappedqty
from production.workorder right join production.product using(productid)
order by product.productid asc;

-- Section 9: Grouping and Aggregation
-- Lecture 46: GROUP BY
-- NOTE: Use the Northwind database unless stated otherwise
-- How many customers do we have in each county? ordered by # of customers in each country in descending order
select country, count(*) as num_of_customers
from customers group by country
order by num_of_customers desc;

-- You can use GROUP BY with joins
-- What is the # of products for each category? ordered by # of products in desc order
-- Teachers solution:
SELECT COUNT(*),categoryname
FROM categories
JOIN products ON categories.categoryid=products.categoryid
GROUP BY categoryname
ORDER BY COUNT(*) DESC;
    -- in the previous solution, we grouped by category name, but ideally we should group by categoryid
    -- we might also take into account categories without products
    -- we might also take into account products without categories
    select 	categories.categoryid,
            categories.categoryname,
            case
                when sum(productid) is null then 0
                else count(*)
            end as num_of_products
    from categories full join products using(categoryid)
    group by categories.categoryid
    order by num_of_products desc;

-- What is the total # of products sold for each category?
-- ordered by total # of products sold in desc order
select
        categories.categoryid,
		categories.categoryname,
		sum(od.quantity) as total_num_of_products_sold
from products inner join order_details as od using(productid)
			  inner join categories using(categoryid)
group by categories.categoryid
order by total_num_of_products_sold desc;

    -- if we had product categories that does not yet have products
    -- or if we had certain products that do not yet have order details then this solution would be better:
    select
        categories.categoryid,
        categories.categoryname,
        case
            when sum(products.productid) is null then 0
            when sum(order_details.orderid) is null then 0
            else sum(order_details.quantity)
        end as total_num_of_products_sold
    from categories
    left join products using(categoryid)
    left join order_details using(productid)
    group by categories.categoryid
    order by total_num_of_products_sold desc;

-- What is the average number of items ordered for products ordered by the average number of items
-- in descending order
-- close to teacher's solution:
select productname, avg(quantity) as avg_num_of_items_ordered
from products inner join order_details using(productid)
group by products.productid
order by avg_num_of_items_ordered desc
    -- we used inner join to select products with order details and vice versa.
    -- what if we have products with no order details? To take them into account:
    select
	products.productname,
	case
		when sum(order_details.orderid) is null then 0
		else avg(quantity)
	end as avg_num_products_ordered
    from products left join order_details using(productid)
    group by products.productid
    order by avg_num_products_ordered desc;

-- What is the average number of items ordered for all the products ordered by the average amount in descending order
-- if a product does not have any orders, then the average amount should be 0
select productname, COALESCE(avg(quantity),0) as avg_num_products_ordered
from products left join order_details using(productid)
group by products.productid
order by avg_num_products_ordered desc;
    -- Reference: https://www.postgresqltutorial.com/postgresql-coalesce/
    -- coalesce : unite
        select
        products.productname,
        case
            when avg(quantity) is null then 0
            else avg(quantity)
        end as avg_num_products_ordered
        from products left join order_details using(productid)
        group by products.productid
        order by avg_num_products_ordered desc;

-- How many suppliers do we have in each country? order it by # of suppliers desc
select country, count(*) as number_of_suppliers
from suppliers group by country
order by number_of_suppliers desc;

-- Total value of each product sold for year 1997 ordered by total value in descending form
-- Teachers solution: Note that we can use WHERE before GROUP BY
select
	productname,
	sum((od.unitprice*od.quantity)-od.discount) as total_sold
from products inner join order_details as od using(productid)
			  inner join orders using(orderid)
where extract(year from orderdate) = 1997
group by products.productid
order by total_sold desc;
    -- OR:
    select
        products.productname,
        sum((order_details.unitprice*order_details.quantity)-order_details.discount) as total_value
    from products
    inner join order_details using(productid)
    inner join orders using(orderid)
    group by productid, extract(year from orderdate)
    having extract(year from orderdate) = 1997
    order by total_value desc;

-- Lecture 47: Use HAVING to filter groups
-- Syntax:
   Select column_names
   from table1
   where condition
   group by column_name(s),
   having condition
   order by column_names

-- WHERE filters records before grouping
-- HAVING filters records after grouping

-- Find all products that sold less than 2000$ order by amount sold asc
select
	products.productid,
	products.productname,
	coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) as amount_sold
from products left join order_details as od using(productid)
group by productid
having coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) < 2000
order by amount_sold asc;
    -- coalesce (postgresql) ?= ifnull (mysql)

-- List customers that have bought more than 5000$ of products in descending order
select
	customers.customerid,
	customers.companyname,
	sum((od.unitprice*od.quantity)-od.discount) as total_amount_bought
from customers
inner join orders using(customerid)
inner join order_details as od using(orderid)
group by customers.customerid
having sum((od.unitprice*od.quantity)-od.discount) > 5000
order by total_amount_bought desc;

-- List customers that have bought more than 5000$ of products in descending order
-- with order date in first six months of the year 1997
    select column_name, data_type, character_maximum_length, column_default, is_nullable
    from INFORMATION_SCHEMA.COLUMNS where table_name = 'orders';

    select
        customers.customerid,
        customers.companyname,
        sum((od.unitprice * od.quantity) - od.discount) as total_purchase
    from customers
    inner join orders using(customerid)
    inner join order_details as od using(orderid)
    where orderdate between date('Jan-1-1997') and date('June-30-1997')
    group by customers.customerid
    having sum((od.unitprice * od.quantity) - od.discount) > 5000
    order by total_purchase desc;

-- Lecture 48 : Grouping Sets
-- What is the term "Grouping Set" ?
-- Any group of columns you are using in GROUP BY phrase
-- You already have been using this. For ex:
-- Grouping set = country
    select count(*), country
    from customers
    group by country
    order by count(*) desc

-- Before proceeding, read this tutorial & use practice_db
-- https://www.postgresqltutorial.com/postgresql-grouping-sets/  (1)

-- The GROUPING SETS allows you to define multiple grouping sets in the same query.
-- The general syntax of the GROUPING SETS is as follows:
    SELECT
        c1,
        c2,
        aggregate_function(c3)
    FROM
        table_name
    GROUP BY
        GROUPING SETS (
            (c1, c2),
            (c1),
            (c2),
            ()
    );

-- Use case: Referring to sales table in practice_db mentioned in (1), if we want to have an aggragate table
-- containing the following grouping sets:
    -- the number of products sold for all brands and segments
    -- the number of products sold by segment
    -- the number of products sold by a brand
    -- the number of products sold by brand and segment together

-- What if we wanted to do more than one column in a grouping set?
-- Then we can UNION ALL them together
-- We need to write more than one query : multiple passes through data : much slower
-- Proper way:
    group by grouping sets ((field1), (field2), (field3, field4))

-- Total sales grouped by category and then the product & category together
-- ordered by categoryname & productname in ascending order
select
	categories.categoryname,
	products.productname,
	sum((od.quantity*od.unitprice)-od.discount) as total_sales
from categories
inner join products using(categoryid)
inner join order_details as od using(productid)
group by grouping sets(
	(categories.categoryname),
	(products.productname, categories.categoryname)
)
order by categories.categoryname, products.productname;
    -- OR;
    select
            categories.categoryname as category,
            products.productname as product,
            sum((od.unitprice*od.quantity)-od.discount) as total_sales
    from products inner join order_details as od using(productid)
                inner join categories using(categoryid)
    group by grouping sets((category),(category, product))
    order by category, product;
    -- If we have categories without products OR
    -- If we have products without order details then to count the total sales properly for them, we use left join:
    select
        categories.categoryname,
        products.productname,
        coalesce(sum((od.quantity*od.unitprice)-od.discount), 0) as total_sales
    from categories
    left join products using(categoryid)
    left join order_details as od using(productid)
    group by grouping sets(
        (categories.categoryname),
        (products.productname, categories.categoryname)
    )
    order by categories.categoryname, products.productname asc;

-- customer's companyname renamed as buyer
-- supplier's companymame renamed as supplier
-- Find total purchase by:
    -- buyer
    -- buyer, supplier
-- order by buyer and supplier in ascending order
select
	customers.companyname as buyer,
	suppliers.companyname as supplier,
	sum((od.quantity*od.unitprice)-od.discount) as total_purchase
from customers
inner join orders using(customerid)
inner join order_details as od using(orderid)
inner join products using(productid)
inner join suppliers using(supplierid)
group by grouping sets(
	(buyer),
	(buyer, supplier)
)
order by buyer, supplier asc;
    -- note that in the previous solution (customers.companyname, suppliers.companyname) means for a particular buyer
    -- which supplier he ordered the products from.
    -- The previous solution is missing the fact that some customers may not have ordered any products.
    -- To take this into account, below is the given solution:
    select
        customers.companyname as buyer,
        suppliers.companyname as supplier,
        coalesce(sum((od.quantity*od.unitprice)-od.discount), 0) as total_purchase
    from customers
    left join orders using(customerid)
    left join order_details as od using(orderid)
    left join products using(productid)
    left join suppliers using(supplierid)
    group by grouping sets(
        (buyer),
        (buyer, supplier)
    )
    order by buyer, supplier asc;
        -- To prove that there ARE buyers who did not order any products, below is the query:
        select
            customers.companyname as buyer,
            suppliers.companyname as supplier,
            coalesce(sum((od.quantity*od.unitprice)-od.discount), 0) as total_purchase
        from customers
        left join orders using(customerid)
        left join order_details as od using(orderid)
        left join products using(productid)
        left join suppliers using(supplierid)
        group by grouping sets(
            (buyer),
            (buyer, supplier)
        )
        having coalesce(sum((od.quantity*od.unitprice)-od.discount), 0) = 0
        order by buyer, supplier asc;


-- customer companyname is called buyer
-- categories category name is called category
-- Find total sales grouped by
    -- buyer
    -- and then,
    -- buyer and category
        -- in other words, which customer ordered which category
-- order by companyname, category name with nulls first, all in ascending order
select
		customers.companyname as buyer,
		categories.categoryname as category,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join categories using(categoryid)
group by grouping sets((buyer), (buyer, category))
order by buyer asc nulls first, category asc nulls first;

-- Lecture on 49: ROLLUP(a, b) -- grouping sets ((a, b), (a), ())
-- https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUPING-SETS

-- Syntax:
    group by rollup(a, b, c)   -- is equivalent to:
    group by grouping sets ((), (a), (a, b), (a, b, c))

-- Use case: This is commonly used for analysis over hierarchical data; e.g.,
-- total salary by department, division, and company-wide total

-- Do a rollup with total_sales of customer, categories and products
-- order by  customer, categories and products in ascending order
-- Teachers solution:
select	companyname as customer,
		categoryname as category,
		productname as product,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join categories using(categoryid)
group by rollup(customer, category, product)
order by customer, category, product asc;
    -- My solution:
    	-- do we have customers with no orders?
	-- do we have orders with no products/productid?
	select
		customers.companyname as customer,
		categories.categoryname as category,
		products.productname as product,
		coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) as total_sales
	from customers
	left join orders using(customerid)
	left join order_details as od using(orderid)
	left join products using(productid)
	left join categories using(categoryid)
	group by rollup(customer, category, product)
	having coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) = 0
	order by customer, category, product asc;
        -- Acc.to the previous query, yes we do have customers with no orders. So, we need to take them into account
        -- by using left join:
        select
            customers.companyname as customer,
            categories.categoryname as category,
            products.productname as product,
            coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) as total_sales
        from customers
        left join orders using(customerid)
        left join order_details as od using(orderid)
        left join products using(productid)
        left join categories using(categoryid)
        group by rollup(customer, category, product)
        order by customer, category, product asc;


-- Using total_sales, do a rollup of suppliers, products and buyers
-- order by suppliers, products and buyers
select
		suppliers.companyname as supplier,
		products.productname as product,
		customers.companyname as buyer,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join suppliers using(supplierid)
group by rollup(supplier, product, buyer)
order by supplier, product, buyer
    -- Note that there are customers without orders, to prove this:
        select
            suppliers.companyname as supplier,
            products.productname as product,
            customers.companyname as buyer,
            coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) as total_sales
        from customers
        left join orders using(customerid)
        left join order_details as od using(orderid)
        left join products using(productid)
        left join suppliers using(supplierid)
        group by rollup(supplier, product, buyer)
        having coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) = 0
        order by supplier asc, product asc, buyer asc;
        -- to take into account the customers without orders, we use left join:
        select
            suppliers.companyname as supplier,
            products.productname as product,
            customers.companyname as buyer,
            coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) as total_sales
        from customers
        left join orders using(customerid)
        left join order_details as od using(orderid)
        left join products using(productid)
        left join suppliers using(supplierid)
        group by rollup(supplier, product, buyer)
        order by supplier asc, product asc, buyer asc;

-- Lecture 50 : Cube(a, b) -- grouping sets ((a, b), (a), (b), ())
-- Documentation: https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUPING-SETS

    CUBE ( a, b, c )  -- is equivalent to
    GROUPING SETS (
        ( a, b, c ),
        ( a, b    ),
        ( a,    c ),
        ( a       ),
        (    b, c ),
        (    b    ),
        (       c ),
        (         )
    )
   -- in short CUBE does all the combination of subsets of a, b, c

-- Lets do a cube of total sales by customer, categories and products
-- order by customer, categories and products
select
		customers.companyname as customer,
		categories.categoryname as category,
		products.productname as product,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join categories using(categoryid)
group by cube(customer, category, product)
order by customer, category, product

-- Do a cube of total sales by suppliers, buyer and products
-- Order by suppliers, products and customers (all of which nulls first)
select
		suppliers.companyname as supplier,
		customers.companyname as buyer,
		products.productname as product,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from customers inner join orders using(customerid)
               inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join suppliers using(supplierid)
group by cube(supplier, buyer, product)
order by supplier nulls first, buyer nulls first, product nulls first
    -- Note that in the previous solution, we use inner join. However, there are customers with no orders:
    -- wrong solution: output set contains repeated rows for all nulls
        select
			suppliers.companyname as supplier,
            customers.companyname as buyer,
            products.productname as product,
            coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) as total_sales
        from customers
        left join orders using(customerid)
        left join order_details as od using(orderid)
        left join products using(productid)
        left join suppliers using(supplierid)
        group by cube(supplier, buyer, product)
		having coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) = 0
        order by supplier nulls first, buyer nulls first, product nulls first;
        -- So, we actually need to use left join to take into customers without orders:
        -- wrong solution: output set contains repeated rows for all nulls
        select
			suppliers.companyname as supplier,
            customers.companyname as buyer,
            products.productname as product,
            coalesce(sum((od.unitprice*od.quantity)-od.discount), 0) as total_sales
        from customers
        left join orders using(customerid)
        left join order_details as od using(orderid)
        left join products using(productid)
        left join suppliers using(supplierid)
        group by cube(supplier, buyer, product)
        order by supplier nulls first, buyer nulls first, product nulls first;

   -- There is another more advanced solution:
    -- Do a cube of total sales by suppliers, buyer and products
    -- Order by suppliers, products and customers (all of which nulls first)
    with step_one as (
        select *
        from suppliers
        left join products using(supplierid)
    ), step_two as (
        select *
        from customers
        left join orders using(customerid)
        left join order_details as od using(orderid)
    ), step_three as (
        select
            step_one.supplierid,
            step_two.customerid,
            step_two.productid,
            coalesce(sum((step_two.unitprice*step_two.quantity)-step_two.discount), 0) as total_sales
        from step_one
        left join step_two using(productid)
        group by cube(step_one.supplierid, step_two.customerid, step_two.productid)
        order by step_one.supplierid nulls first, step_two.customerid nulls first, step_two.productid nulls first
    )
    select
        suppliers.companyname as supplier,
        customers.companyname as buyer,
        products.productname as product,
        total_sales
    from step_three
    left join suppliers using(supplierid)
    left join customers using(customerid)
    left join products using(productid)
    order by supplier nulls first, buyer nulls first, products nulls first
        -- step_one: suppliers may not have products yet -> left join
        -- step_two: customers may not have orders yet   -> left join
        -- step_three: step_one output set may not have any orders yet -> left join
        -- final select statement:
            -- if supplierid does not match (i.e. null due to cube) then it should be preserved
            -- if customerid does not match (i.e. null due to cube) then it should be preserved
            -- if productid  does not match (i.e. null due to cube) then it should be preserved
                --> left join


-- Section 10: Combining queries
-- Lecture 51: UNION
-- documentation: https://www.postgresql.org/docs/13/sql-select.html
-- Purpose of UNION: Combine the results of 2 or more queries
-- Syntax:
    select <column1>, <column2>, ...
    from table1

    union all/distinct  --> duplicates stay/removes duplicates

    select <column1>, <column2>
    from table2

    union

    ...

-- must have same number of columns
-- column types must line up
-- union will remove any duplicated rows (i.e. union distinct)


-- Get a list of all customer and supplier company names with duplicates removed
select companyname from customers
union distinct
select companyname from suppliers

-- Get a list of all customer and supplier company names with duplicates not removed
select companyname from customers
union all   --> duplicate rows not removed
select companyname from suppliers

-- Find cities of all our customers and suppliers
-- with only one record for each companies city (i.e. remove duplicate cities)
select distinct city from customers
union distinct
select distinct city from suppliers

-- distinct counties of all customers and suppliers in alphabetical order
select distinct country from customers
union distinct
select distinct country from suppliers
order by country asc

-- All list of country of suppliers and customers
-- with a record for each one (e.g. duplicates not removed)
-- ordered by country in asc order
select country from suppliers
union all
select country from customers
order by country asc

-- Lecture 52: INTERSECT
-- documentation: https://www.postgresql.org/docs/13/sql-select.html
-- Purpose of INTERSECT: find items that are in both queries
-- Syntax:
    select <column1>, <column2>, ...
    from table1

    intersect all/distinct --> keeps duplicates/removes duplicates

    select <column1>, <column2>, ...
    from table2

    intersect

    ...

-- must have same number of columns
-- column types must line up
-- intersect will remove any duplicated rows (i.e. intersect distinct)

-- Find all countries that we have both customers and suppliers in (without duplicates)
-- order by country in desc order
	select country from customers
	intersect distinct --> removes duplicates
	select country from suppliers
	order by country desc

-- Find all countries that we have both customers and suppliers in (with duplicates)
-- order by country in desc order
	select country from customers
	intersect all --> keeps duplicates
	select country from suppliers
	order by country desc

-- Q) ??? Find the number of customer & supplier pairs that are in the same country
-- Refer to the Q/A for Lecture 52, there is a Q with a title:
-- Finding the number of customer & supplier pairs that are in the same country
select count(*) from
(select country from customers
intersect all
select country from suppliers) as combined     -- (**)
    -- This Q is tricky. The way I understand the Q is as follows:
    -- Imagine you have 3 suppliers and 2 customers for Brazil. Altogether, we have 6 pairs for Brazil.
    -- The previous solution would yield 2 Brazil entries via intersect all, which is wrong. Here is the proof:
            -- Refer to Lecture-52 database:
            create table customers (
                country varchar(100)
            );

            create table suppliers (
                country varchar(100)
            );

            insert into customers(country)
            values('USA'),
                ('USA'),
                ('BRAZIL'),
                ('BRAZIL'),
                ('BRAZIL');

            insert into suppliers(country)
            values ('USA'),
                ('BRAZIL'),
                ('BRAZIL');

            -- pay attention to this one:
            select country from customers
            intersect all
            select country from suppliers;
                country
                USA
                BRAZIL
                BRAZIL

            select country from customers
            intersect distinct
            select country from suppliers;
                country
                USA
                BRAZIL
    -- So referring to the query (**) and our imaginary example, we would receive 2 pairs as BRAZIL, not 6!
    -- To be able to implement the imaginary example, we need to use:
    select count(*) as num_of_pairs, customers.country
    from customers inner join suppliers using(country)
    group by customers.country
    order by customers.country asc;

-- how many distinct countries, where we have both customers and suppliers
select count(*) from (
	select country from customers
	intersect distinct
	select country from suppliers
) as x
    -- another solution:
    select count(*) from (
        select distinct country from customers
        intersect distinct
        select distinct country from suppliers
    ) as x;
    -- another more advance solution:
    with step_one as (
        select count(*) as num_of_pairs, customers.country
        from customers inner join suppliers using(country)
        group by customers.country
        having count(*) <> 0
    )
    select count(*) from step_one;

-- how many distinct countries we have for customers and suppliers altogether
select count(*) from (
	select distinct country from customers
	union distinct
	select distinct country from suppliers
) as x;

-- Distinct cities that have customers and suppliers located in
-- e.g. NY has 2 customers & 3 suppliers
--      Helsinki has 4 customers & 1 supplier
--      Istanbul has 1 customer & 0 supplier
-- Outcome: cities -> Ny, Helsinki
select distinct city from customers
intersect distinct
select distinct city from suppliers

--(???) the count of number of customers and suppliers pairs that are in the same city
select count(*) from
(select city from customers
intersect all
select city from suppliers) as customer_supplier_pairs
    -- Imagine we have 2 customers and 3 suppliers in London, but the previous solution
    -- would return 2 as the number of customer/supplier pairs in London. However, we expect 6 as the number of pairs.
    -- The correct solution is likely this one:
    select count(*) as num_of_pairs, customers.city
    from customers inner join suppliers using(city)
    group by customers.city
    order by customers.city asc;

-- Lecture 53: EXCEPT
-- documenation: https://www.postgresql.org/docs/13/sql-select.html
-- EXCEPT operator
-- The EXCEPT operator returns DINSTINCT rows from the first (left) query that are not in the output of the second (right) query.
-- Documentation: https://www.postgresqltutorial.com/postgresql-except/
-- Documentation: https://stackoverflow.com/questions/43599511/psql-except-vs-except-all
-- Purpose: Find the items in the first query but not in the second one
-- Syntax:
    select <column1>, <column2>, ...
    from table1

    except

    select <column1>, <column2>
    from table2
-- must have same number of columns
-- column types must line up

-- Find all countries that we have customers in but no suppliers
-- order by country in asc
select distinct country from customers
except
select distinct country from suppliers
order by country asc;

-- ??? Find the number of customers within a country without suppliers
-- Teachers solution:
select count(*) from
(select country from customers
 except
 select country from suppliers
) as customers_without_suppliers
    --> returns 68.
    -- however, except all works such that if there are 2 customers and 1 supplier in Germany, it returns 1
    -- which isn't a country without suppliers. Proof:
            -- Refer to Lecture 52 database:
            select country from customers
            except all
            select country from suppliers;
    -- So, we need to utilize distinct to solve this issue:
    select count(*) from customers where country in
    (select distinct country from customers
    except
    select distinct country from suppliers);
        -- which returns 22
    -- Find the number of customers within a country without suppliers
    --Another solution is to use left join:
        select
            count(*) as num_of_customers
        from customers left join suppliers using(country)
        group by suppliers.country
        having suppliers.country is null;
        -- OR;
        select count(*) as num_of_customers from customers
        left join suppliers using(country)
        where suppliers.country is null;
    -- Find the number of customers within a country without suppliers
    with step_one as (
        select distinct country from customers
        except
        select distinct country from suppliers
    ), step_two as (
        select count(*) as num_customers, country from customers
        group by country
        having country in (select * from step_one)
        order by country asc
    )
    select sum(num_customers) as total_num_of_customers from step_two;
    -- another solution:
    with step_one as (
        select
            distinct customers.country
        from customers left join suppliers using(country)
        where suppliers.country is null
    ),  step_two as (
        select count(*) as num_customers, country from customers
        group by country
        having country in (select * from step_one)
        order by country asc
    )
    select sum(num_customers) as total_num_of_customers from step_two;

-- Cities which have a supplier with no customer
select city from suppliers
except distinct
select city from customers;  --> (1)
    -- it gives 24 cities having supplier(s) and no customer.
    -- Another equal way to implement this:
    select distinct city from suppliers
    except
    select distinct city from customers;    --> (2)
    -- Way 1 and way 2 are the same. Proof:
    (select distinct city from suppliers
    except
    select distinct city from customers)
    except all
    (select city from suppliers
    except distinct
    select city from customers);
        -- Note that The result of EXCEPT does not contain any duplicate rows unless the ALL option is specified.
        -- With ALL, a row that has m duplicates in the left table and n duplicates in the right table will appear max(m-n,0) times 
        -- in the result set.
-- How many customers do we have in cities without suppliers
-- My incorrect solution
select count(*) from
(select city from customers
 except all
 select city from suppliers) as cities_with_customers_without_suppliers
    -- Possibly the right solution:
    -- How many customers do we have in cities without suppliers
    select count(*) from customers where city in
    (select distinct city from customers
    except all
    select distinct city from suppliers
    );


-- Section 11: Subqueries
-- Lecture 54: EXISTS
-- tutorial: https://www.postgresqltutorial.com/postgresql-exists/
   -- and the database is dvdrental_db, which has the database diagram:
   -- file:///home/hakan/PostGreSQL/dvdrental_db/tables/customer.html
-- Syntax:
    select columnA, columnB, ...
    from table1
    where exists (select column1 from table2 where condition)
    -- it looks to see if the condition is met in the subquery
    -- then it pulls out the columnA, columnB, ... from table 1
        -- My interpretation: if any row in Table1 is related with a condition to any row in Table2,
        -- then pick that row in Table1. Note that in the condition your will define the relationship between columns
        -- of Table1 and Table2.

-- Find customers with orders made in April, 1997
-- order by company name ascending
select
	companyname
from customers as c
where exists(select orderid from orders as o
			where c.customerid = o.customerid and
			cast(orderdate as date) between cast('1997-04-01' as date) and cast('1997-04-30' as date))
order by companyname asc

    -- OR, it can be done this way:
    select
        distinct companyname
    from customers inner join orders using(customerid)
    where cast(orderdate as date) between cast('1997-04-01' as date) and cast('1997-04-30' as date)
    order by companyname asc

-- Find customers (with companyname and contactname) who did not make an order in April, 1997
-- ordered by companyname, contactname in ascending order
select
	companyname, contactname
from customers as c
where not exists(
	select orderid from orders as o
	where c.customerid = o.customerid and
	cast(orderdate as date) between cast('1997-04-01' as date) and cast('1997-04-30' as date)
)
order by companyname asc, contactname asc
    -- OR
    select companyname, contactname from customers
    where not exists (
        select orderid from orders
        where customers.customerid = orders.customerid and
        (orderdate between date('1-April-1997') and date('30-April-1997'))
    )
    order by companyname asc, contactname asc;


    -- or it can be done this way (??? does not work)
    select distinct companyname, contactname
    from customers left join orders using(customerid)
    where cast(orderdate as date) not between cast('1997-04-01' as date) and cast('1997-04-30' as date)
    order by companyname asc, contactname asc
        -- this would not work, because of 2 reasons:
        -- (1) the where clause skips NULL entries in the joined table
        -- essentially turning the left join into an inner join
        -- more info: https://stackoverflow.com/questions/3256304/left-join-turns-into-inner-join
        -- (2) imagine customer x had an order in April, 1997 and out of April, 1997. Then x gets picked,
        -- even though it should not be picked.

   -- works!
    select companyname, contactname from customers
    where customerid not in (
        select customerid from orders
        where orderdate::date between '1997-04-01'::date and '1997-04-30'::date
    )
    order by companyname asc, contactname asc;

-- What products did not have an order in April, 1997. order by productname ascending order
-- order by productname in asc (??? does not work)
-- https://stackoverflow.com/questions/64633363/left-join-vs-where-not-exits
select
	distinct productname
from products left join order_details using(productid)
			  left join orders using(orderid)
where cast(orderdate as date) not between cast('1997-04-01' as date) and cast('1997-04-30' as date)
order by productname asc;
    -- there are 2 reasons why it does not work:
    -- (1) the where clause skips NULL entries in the joined table
    -- essentially turning the left join into an inner join
    -- more info: https://stackoverflow.com/questions/3256304/left-join-turns-into-inner-join
    -- (2) imagine product x had an order in April, 1997 and out of April, 1997. Then x gets picked,
    -- even though it should not be picked.

    -- Solution 1: Using joins
    select
        productname
    from products left join (
        select distinct productid
        from products 
        inner join order_details using(productid)
        inner join orders using(orderid)
        where orderdate between date('1-April-1997') and date('30-April-1997')
    ) as products_ordered_in_april_1997
    using (productid)
    where products_ordered_in_april_1997.productid is null
    order by productname asc;

    -- or it can be done using WHERE NOT EXISTS (Correctly working!)
    -- Solution 2:
        select productname from products
        where NOT exists (
            select orders.orderid from orders
            inner join order_details using(orderid)
            where products.productid = order_details.productid
            and (orderdate::date between '1997-04-01'::date and '1997-04-30'::date)
        )
        order by productname asc;

    -- Solution 3: using NOT IN
    select productname from products
    where productid not in (
        select productid from orders
        inner join order_details using(orderid)
        where orderdate::date between cast('1997-04-01' as date) and cast('1997-04-30' as date)
    )
    order by productname asc;

    -- Solution 4: Using <> all == NOT IN
    select
        productname
    from products
    where productid <> all (
        select productid from orders
        inner join order_details using(orderid)
        where orderdate::date between cast('1997-04-01' as date) and cast('1997-04-30' as date)
    )
    order by productname asc;

-- Find all suppliers with a product that costs more than 200$
-- order by companyname ascending order
-- Solution 1:
select distinct companyname
from suppliers inner join products using(supplierid)
where unitprice > 200
order by companyname asc;

    -- Solution2:
    select companyname from suppliers
    where exists (
        select productid from products
        where products.supplierid = suppliers.supplierid AND
        unitprice > 200
    )
    order by companyname asc;



-- Find all suppliers that don't have an order in Dec 1996
-- order by companyname in ascending order
-- Solution 1 (will not work)
select distinct companyname
from suppliers left join products using(supplierid)
			   inner join order_details using(productid)
			   inner join orders using(orderid)
where cast(orderdate as date) not between cast('1996-12-01' as date) and cast('1996-12-31' as date)
order by companyname asc;
    -- the reason why it does not work:
    -- the where clause skips NULL entries in the joined table
    -- essentially turning the left join into an inner join
    -- more info: https://stackoverflow.com/questions/3256304/left-join-turns-into-inner-join
    -- Similar solution pattern using left JOIN: https://stackoverflow.com/questions/64633363/left-join-vs-where-not-exits
    -- Solution 2:
    select
        s.companyname
    from suppliers as s left join (
        select distinct supplierid from suppliers
                        inner join products using(supplierid)
                        inner join order_details using(productid)
                        inner join orders using(orderid)
        where orderdate::date between '1996-12-01'::date and '1996-12-31'::date
    ) as x using(supplierid)
    where x.supplierid is null
    order by s.companyname asc

    -- Solution 3:
    select companyname
    from suppliers left join (
	    select *
	    from products inner join order_details using(productid)
				      inner join orders using(orderid)
	    where orderdate::date between '1996-12-01'::date and '1996-12-31'::date
    ) as x using(supplierid)
    where x.productid is null
    order by companyname asc

    -- Solution 4: (Works) using NOT EXISTS
    select companyname from suppliers
    where not exists(
        select distinct supplierid from products
        inner join order_details using(productid)
        inner join orders using(orderid)
        where (orderdate between date('Dec-01-1996') and date('Dec-31-1996'))
        and (suppliers.supplierid = products.supplierid)
    )
    order by companyname asc;


-- Lecture 55: using ANY and ALL
-- Documentation for ANY: https://www.postgresqltutorial.com/postgresql-any/
-- The PostgreSQL ANY operator compares a value to a set of values returned by a subquery
-- Syntax:
    expresion operator ANY(subquery)
    -- The subquery must return exactly one column.
    -- The ANY operator must be preceded by one of the following comparison operator =, <=, >, <, > and <>
    -- The ANY operator returns true if any value of the subquery meets the condition, otherwise, it returns false

-- Syntax:
Select column_names
from table1
where column <operator> ANY (Select column_name from table_name where condition)
    -- <operator> must be =, >, <, <=, => or !=

-- Find customers with an order detail with more than 50 items in a single product
-- order by company name ascending
-- Solution 1: Using inner joins
select distinct companyname
from customers inner join orders using(customerid)
			   inner join order_details using(orderid)
where quantity > 50
order by companyname asc

    -- Solution 2 using ANY
    select distinct companyname
    from customers inner join orders using(customerid)
    where orderid = any(
        select orderid from order_details
        where quantity > 50
    )
    order by companyname asc

    -- Solution3: Using ANY
    select companyname
    from customers
    where customerid = any(
        select customerid
        from orders inner join order_details using(orderid)
        where quantity > 50
    )
    order by companyname asc

    -- Solution4: Using EXISTS
    select
        companyname
    from customers
    where exists (
        select orderid from orders
        inner join order_details using(orderid)
        where customers.customerid = orders.customerid AND
        quantity > 50
    )
    order by companyname asc;

-- Find all suppliers that have an order with 1 item
-- order by companyname in ascending order
-- Solution 1: using ANY
select companyname
from suppliers
where supplierid = any(
	select distinct supplierid
	from products inner join order_details using(productid)
	where quantity = 1
)
order by companyname asc

    -- Solution2: Using IN operator
    select companyname from suppliers
    where supplierid in (
        select distinct supplierid from products
        inner join order_details using(productid)
        where quantity = 1
    )
    order by companyname asc;

    -- Solution 3: Using joins only
    select distinct companyname
    from suppliers inner join products using(supplierid)
			   inner join order_details using(productid)
    where quantity = 1
    order by companyname asc

    -- Solution 4: Using EXISTS
    select companyname from suppliers
    where exists (
        select distinct supplierid from products
        inner join order_details using(productid)
        where suppliers.supplierid = products.supplierid and quantity = 1
    )
    order by companyname asc;

-- ALL
-- Documentation: https://www.postgresqltutorial.com/postgresql-all/
-- The PostgreSQL ALL operator allows you to query data by comparing a value with a list of values returned by a subquery.
-- Syntax:
    comparison_operator ALL (subquery)
    -- The ALL operator must be preceded by a comparison operator such as equal (=),
    -- not equal (!=), greater than (>), greater than or equal to (>=), less than (<), and less than or equal to (<=)

    -- The ALL operator must be followed by a subquery which also must be surrounded by the parentheses.
    -- With the assumption that the subquery returns some rows, the ALL operator works as follows:
        column_name > ALL (subquery) the expression evaluates to true if a value is greater than the biggest value returned by the subquery.
        column_name >= ALL (subquery) the expression evaluates to true if a value is greater than or equal to the biggest value returned by the subquery.
        column_name < ALL (subquery) the expression evaluates to true if a value is less than the smallest value returned by the subquery.
        column_name <= ALL (subquery) the expression evaluates to true if a value is less than or equal to the smallest value returned by the subquery.
        column_name = ALL (subquery) the expression evaluates to true if a value is equal to any value returned by the subquery.
        column_name != ALL (subquery) the expression evaluates to true if a value is not equal to any value returned by the subquery
    -- In case the subquery returns no row, then the ALL operator always evaluates to true

-- Extra (not in the course exercises): Find products which has order quantity that are
-- higher than the averages of all of the individual products
-- order by product name in ascending fashion
select
	productname, sum(quantity) as total_ordered_quantity
from products inner join order_details using(productid)
group by productid
having sum(quantity) > all(
	select round(avg(quantity),2) from order_details
	group by products.productid)
order by productname asc;


-- Extra: Find products which has total order AMOUNT ($) that are
-- higher than all individual product's average order amounts
-- order by product name in ascending fashion
select
	productname
from products inner join order_details using(productid)
group by products.productid
having sum((order_details.unitprice*quantity)-discount) > all(
	select avg((unitprice*quantity)-discount)
	from order_details group by productid
)
order by productname asc;


-- Find products which has least 1 order with AMOUNT ($) that is
-- higher than the average of all individual product's amounts
-- order by product name in ascending fashion
        select distinct productname from products
        inner join order_details as od using(productid)
        where ((od.unitprice*quantity)-discount) > all(
            select avg((unitprice*quantity)-discount) from order_details
            group by productid
        )
        order by productname asc;

-- Ambigious Task Description: Find all distinct customers that ordered more than 1 item
-- than the average order amount per item of all customers
select distinct companyname from customers
inner join orders using(customerid)
inner join order_details using(orderid)
where ((unitprice*quantity)-discount) > all (
	select avg((unitprice*quantity)-discount)
	from order_details inner join orders using(orderid)
	group by customerid
)
order by companyname asc;
    -- My interpretation:
    -- Find all customers, which made a purchase with
    -- an amount greater than that of the average total purchase amount
    -- of all the individual customers
    -- order by companyname asc

-- Lecture 56 : using IN
-- Documentation: https://www.postgresqltutorial.com/postgresql-in/
-- You use IN operator in the WHERE clause to check
-- if a value matches any value in a list of values
-- Syntax:
    value IN (value1,value2,...)
-- The IN operator returns true if the value matches any value
-- in the list i.e., value1 , value2 , …
 -- The list of values can be a list of literal values such as numbers,
 -- strings or a result of a SELECT statement like this:
    value IN (SELECT column_name FROM table_name);

-- Find Customers that are in the same countries as suppliers
-- order by company name asc
SELECT companyname
FROM customers
WHERE country IN (SELECT DISTINCT country FROM suppliers)
order by companyname asc;
    -- Solution 2: Using = ANY
    select companyname from customers
    where country = any (
	select distinct country from suppliers
    );

    -- Solution 3: Using where exists
    select companyname from customers
    where exists(
        select supplierid from suppliers
        where customers.country = suppliers.country
    )
    order by companyname asc;


-- Section 12: Modifying data in tables INSERT INTO, UPDATE, DELETE
-- Lecture 57: INSERT INTO
-- Syntax:

    INSERT INTO table_name(column1, column2, …)
    VALUES (value1, value2, …);

-- In this syntax:
-- First, specify the name of the table (table_name) that you want to insert data after
-- the INSERT INTO keywords and a list of comma-separated columns (colum1, column2, ....).
-- Second, supply a list of comma-separated values in a parentheses (value1, value2, ...)
-- after the VALUES keyword. The columns and values in the column and value lists must be in the same order.

-- creata a new order for customer VINET
    select max(orderid) from orders
    -- 11077

    INSERT INTO orders
    (orderid,customerid, employeeid, orderdate, requireddate, shipvia,
    freight, shipname, shipaddress, shipcity, shippostalcode,shipcountry)
    VALUES (11078, 'VINET', 4, '2017-09-16','2017-09-30',3,
            42.5, 'Vins et alcools Chevalier','59 rue de l''Abbaye', 'Reims','51100', 'France');

        -- Insert an order detail for the order we just created.
            -- orderid = 11078
        -- Make quantity 20 of Queso Cabrales with a price of $14
        select productid from products
        where productname = 'Queso Cabrales'

        -- productid = 11
        insert into order_details (orderid, productid, unitprice, quantity, discount)
                    values (11078, 11, 14, 20, 0);

-- Lecture 58: UPDATE
-- Documentation: https://www.postgresqltutorial.com/postgresql-update/
-- The PostgreSQL UPDATE statement allows you to modify data in a table.
-- Syntax:
UPDATE table_name
SET column1 = value1,
    column2 = value2,
    ...
WHERE condition;

-- In this syntax:

   -- First, specify the name of the table that you want to update data after the UPDATE keyword.
   -- Second, specify columns and their new values after SET keyword.
   -- The columns that do not appear in the SET clause retain their original values.
   -- Third, determine which rows to update in the condition of the WHERE clause.

-- The WHERE clause is optional. If you omit the WHERE clause, the UPDATE statement will update all rows in the table.

-- update the order we created in lecture 57
    -- orderid= 11078
-- They need it by 2017-09-20 and the shipping cost is increased by 50$
update orders
set requireddate='2017-09-20'::date, freight = freight + 50
where orderid = 11078;

-- update the order_details row we created in Lecture 57
    -- orderid= 11078 and quantity=20 and productid=11
-- They also want 40 Queso Cabrales instead of 20
-- and we are giving a discount of 0.05
update order_details
set quantity=40, discount=0.05
where orderid=11078 and quantity=20 and productid=11

-- Lecture 59: DELETE
-- Doc: https://www.postgresqltutorial.com/postgresql-delete/
-- The PostgreSQL DELETE statement allows you to delete one
-- or more rows from a table. Syntax:
DELETE FROM table_name
WHERE condition

    -- First, specify the name of the table from which you want to delete data after the DELETE FROM keywords.
    -- Second, use a condition in the WHERE clause to specify which rows from the table to delete.
--The WHERE clause is optional. If you omit the WHERE clause, the DELETE statement will delete all rows in the table.

-- Delete the order_detail row created in Lecture 57
delete from order_details
where orderid= 11078 and quantity=40 and productid=11;

-- delete the order entry created in Lecture 57
delete from orders where orderid=11078;

-- Lecture 60: SELECT INTO TABLE : take selected rows & columns and slap it into a new table
-- Docs: https://www.postgresqltutorial.com/postgresql-select-into/
-- The PostgreSQL SELECT INTO statement creates a new table and inserts data returned from a query into the table.
-- Syntax:
SELECT
    select_list
INTO TABLE new_target_table_name
FROM
    source_table_name
WHERE
    search_condition;

-- The WHERE clause allows you to specify the rows from the original tables
-- that should be inserted into the new table. Besides the WHERE clause, you can use other
-- clauses in the SELECT statement for the SELECT INTO statement such as INNER JOIN, LEFT JOIN, GROUP BY, and HAVING.

-- Backup all suppliers in North America into suppliers_north_america table
select *
into table suppliers_north_america
from suppliers
where country in ('USA', 'Canada');


-- Backup orders in the year 1997 to a new table orders_1997
select *
into table orders_1997
from orders
where orderdate::date between '1997-01-01'::date and '1997-12-31'::date;

-- Lecture 61: INSERT INTO SELECT
-- Syntax:
insert into table2 (column1, column2, ...)
select column1, column2, ...
from table1
where condition
    -- table2 must pre-exist before the operation

-- or if all fields can be grabbed:
insert into table2
select * from table1
where condition

-- Add our suppliers in Brazil & Argentina to suppliers_north_america
insert into suppliers_north_america
select * from suppliers
where country in ('Brazil', 'Argentina');

-- Add orders from December 2016 to the table orders_1997
insert into orders_1997
select *
from orders
where orderdate::date between '2016-12-01'::date and '2016-12-31'::date;

-- Lecture 62: Returning data from UPDATE; INSERT INTO AND DELETE
-- Syntax for INSERT INTO:
    insert into table(field1, field2) values(value1, value2) returning id;

-- Insert a new employee returning the employeeid
INSERT INTO employees
(firstname,lastname,address,city,country,postalcode,homephone,title,employeeid,reportsto)
VALUES
('Bob','Smith','463-4613 Ipsum Street','New Orleans','USA','73-638','741-0423','Chief Strategy',50,NULL)
RETURNING employeeid;

-- Increase the unit price of Chai (productid=1) by 20%
-- and return the new price and the productid
update products
set
	unitprice = unitprice * 1.2
where productid = 1
returning unitprice, productid;

-- update order_details for orderid 10248 and productid 11
-- to double the quantity ordered and return the new quantity
update order_details
set quantity = quantity * 2
where orderid = 10248 and productid = 11
returning quantity as new_quantity

-- Syntax for DELETE:
DELETE FROM table_name
where condition
returning *

-- delete the order you entered (orderid=50)
-- returning all the fields
delete from orders
where orderid=50
returning *


-- Section 13 : Indexes and performance tuning
-- Northwind is a small db with relatively small # of tables
-- Once table size exceeds 10000 and when done multiple joins
-- the SQL statement takes long time.
-- The solution is to use indexes.

-- Lecture 63: What are indexes?
-- Indexes are data structures attached to specific columns
-- to improve the lookup speed

-- Penalty for attaching indexes for every column:
-- At each insert/update/delete, the index data structure must also be updated as well

-- Lecture 64: CREATE INDEX / CREATE UNIQUE INDEX
create index -- creates the index data structure using the given field
create unique index -- same as as create index, but adds a check that prevents
                    -- duplicates on that field being entered

-- Syntax:
create index index_name
on table1 (column1, ...);

-- or

create unique index index_name
on table1 (column1, ...);

-- create unique index on employeeid field of employees table
create unique index idx_employees_employeeid
on employees(employeeid);

-- on orders create a single index on two fields customerid and orderid
create index idx_orders_customerid_orderid
on orders(customerid, orderid);

-- Lecture 65: DROP INDEX
-- Syntax:
drop index index_name

-- drop idx_employees_employeeid on employees table
drop index idx_employees_employeeid

-- Lecture 66: How to kill stuck queries
-- Imagine: instead of typing this
insert into performance_test(location)
select 'Katmandu, Nepal' from generate_series(1, 500000)
-- you have typed by accident:
insert into performance_test(location)
select 'Katmandu, Nepal' from generate_series(1, 500000000)

drop table if exists performance_test;
create table performance_test (
    id serial,
    location text
);

-- you have typed by accident:
insert into performance_test(location)
select 'Katmandu, Nepal' from generate_series(1, 500000000);

-- See what is running
SELECT * FROM pg_stat_activity WHERE state = 'active';

-- polite way to stop
SELECT pg_cancel_backend(PID);

-- stop at all costs - can lead to full database restart
SELECT pg_terminate_backend(PID);


-- Lecture 67: Using EXPLAIN To See The QUERY PLAN
-- Lets have a large table called performance_test
DROP TABLE IF EXISTS performance_test;

CREATE TABLE performance_test (
  id serial,
  location text
);


INSERT INTO performance_test (location)
SELECT md5(random()::text) FROM generate_series(1,10000000);

-- a query that takes more than 1.3 seconds
select count(*) from performance_test
EXPLAIN select count(*) from performance_test     --> ANALYZE performance_test will cut the time it takes considerably
    -- EXPLAIN yields a QUERY PLAN showing the steps of performing the query showing the bottlenecks in performance
        -- Each time you see PARALLEL SEQ SCAN in the query plan, that is a slow operation

-- another query that takes more than 1.3 seconds
explain select * from performance_test
where id = 2000000
    -- EXPLAIN yields a QUERY PLAN showing the steps of performing the query showing the bottlenecks in performance
        -- Each time you see PARALLEL SEQ SCAN in the query plan, that is a slow operation

-- Lets create an index on performance_test table to see its effect on performance
CREATE INDEX idx_performance_test_id ON performance_test (id);

-- a query that takes 115 miliseconds rather than 1.3 seconds
explain select * from performance_test
where id = 2000000;

-- Lecture 68: ANALYZE table
-- Docs: https://www.postgresql.org/docs/9.3/sql-analyze.html
-- ANALYZE collects statistics (??) about the contents of tables in the database, and stores the results
-- in the pg_statistic (??) system catalog.
-- Subsequently, the query planner uses these statistics to help determine the most efficient execution plans for queries.
    -- My interpretation: ANALYZE is a db admin command. It allows db admin to
    -- create extra data about the table's content. This data helps the db server build faster query steps (a.k.a query plan)
-- Syntax:
analyze table_name

-- make future queries even faster on performance_test table
analyze performance_test
-- Re-run
explain select count(*) from performance_test  --> Total query runtime: 137 msec.

-- Rule of thumb: To keep the database up & running, run ANALYZE on the existing tables regularly

-- Lecture 70: Using Indexes on More Than One Field
ALTER TABLE performance_test
ADD COLUMN name text;

UPDATE performance_test
SET name = md5(location);

-- takes above 900ms after data cached
EXPLAIN SELECT *
FROM  performance_test
WHERE location LIKE 'df%' AND name LIKE 'cf%';


CREATE INDEX idx_performance_test_location_name
ON performance_test(location,name);
-- This index would NOT be used in:
    EXPLAIN SELECT *
    FROM  performance_test
    WHERE location LIKE 'df%' AND name LIKE 'cf%';
    -- Q: how to optimize the performance for where clauses like above?
    -- Answer: Index columns for LIKE in postgres:
    -- https://niallburkley.com/blog/index-columns-for-like-in-postgres/
    CREATE EXTENSION pg_trgm;
    create index trgm_idx_performance_test_location on performance_test using gin(location gin_trgm_ops);
    create index trgm_idx_performance_test_name on performance_test using gin(name gin_trgm_ops);
    -- Re-Run
    EXPLAIN SELECT *
    FROM  performance_test
    WHERE location LIKE 'df%' AND name LIKE 'cf%';
        -- You will see that the created indexes are being used in the query plan
        SELECT *
        FROM  performance_test
        WHERE location LIKE 'df%' AND name LIKE 'cf%';
        -- Runs now in about 113 msec, not 4 secs!


-- LECTURE 71: Expression Indexes
-- Expression indexes are like basic indexes, but utilizes functions (i.e. UPPER()) in them
-- This is for AdventureWorks database

--Make sure we don't have indexes to see the effect
DROP INDEX IF EXISTS production.idx_product_name;
DROP INDEX IF EXISTS production.idx_product_upper_name;

-- you should see a sequential scan
-- "Seq Scan on product  (cost=0.00..17.56 rows=3 width=139)"
EXPLAIN select *
from production.product
WHERE name LIKE 'Flat%';

-- create normal index
CREATE INDEX idx_product_name
ON production.product (name);

-- this becomes an bitmap index scan
-- "  ->  Bitmap Index Scan on idx_product_name  (cost=0.00..4.32 rows=5 width=0)"
    -- Second time study: no, idx_product_name is NOT used.
EXPLAIN select *
from production.product
WHERE name LIKE 'Flat%';
    -- Referring to:
    CREATE EXTENSION pg_trgm;
    create index trgm_idx_production_product_name
    on production.product using gin(name gin_trgm_ops);

    EXPLAIN select *
    from production.product
    WHERE product.name LIKE 'Flat%';
        -- This did not work either; trgm_idx_production_product_name is not in the query plan.
    -- Refer to indexing like query in postgresql:
    -- https://stackoverflow.com/questions/1566717/postgresql-like-query-performance-variations
    create index gist_trgm_idx_production_product_name
    on production.product using gist(name gist_trgm_ops);

    EXPLAIN select *
    from production.product
    WHERE product.name LIKE 'Flat%';
    "Bitmap Heap Scan on product  (cost=4.22..14.78 rows=10 width=139)"
    "  Recheck Cond: ((name)::text ~~ 'Flat%'::text)"
    "  ->  Bitmap Index Scan on gist_trgm_idx_production_product_name  (cost=0.00..4.22 rows=10 width=0)"
    "        Index Cond: ((name)::text ~~ 'Flat%'::text)"

-- this is back to sequential scan
-- "Seq Scan on product  (cost=0.00..17.56 rows=3 width=139)"
EXPLAIN select *
from production.product
WHERE UPPER(NAME) LIKE UPPER('Flat%');
    -- create an expression scan
    CREATE INDEX idx_product_upper_name
    ON production.product (UPPER(name));
        -- idx_product_upper_name is NOT used in the select expression!
        -- https://stackoverflow.com/questions/1566717/postgresql-like-query-performance-variations
        CREATE INDEX tbl_col_gist_trgm_idx ON tbl USING gist (col gist_trgm_ops);
        create index gist_trgm_idx_product_upper_name on production.product using gist(upper(name) gist_trgm_ops);

        EXPLAIN select *
        from production.product
        WHERE UPPER(NAME) LIKE UPPER('Flat%');
            "Bitmap Heap Scan on product  (cost=4.17..11.28 rows=3 width=139)"
            "  Recheck Cond: (upper((name)::text) ~~ 'FLAT%'::text)"
            "  ->  Bitmap Index Scan on gist_trgm_idx_product_upper_name  (cost=0.00..4.17 rows=3 width=0)"
            "        Index Cond: (upper((name)::text) ~~ 'FLAT%'::text)"
            -- gist_trgm_idx_product_upper_name index is indeed used in the query plan

--your turn
CREATE INDEX idx_person_fullname
ON person.person ( (firstname  || ' ' || lastname) );

--show that it uses the index
EXPLAIN SELECT *
FROM person.person
WHERE firstname || ' ' || lastname = 'Terri Duffy';

-- Lecture 72: Types of Indexes
-- Doc: https://www.postgresql.org/docs/current/indexes-types.html
-- Main idea: There are 6 types of indexes in Postgresql
-- For aach column type we need to pick the right index type.
-- Syntax:
CREATE INDEX index_name ON table_x USING index_type (column)

-- Section 14: Database Design & Normalization
-- Lecture 74: Design Process Overview
-- 3 phases in Database Design:
  -- 1. Requirements Analysis
  -- 2. Data Modeling
  -- 3. Normalization

-- Data VS. Information:
   -- Data: Will Bunker 60 Lake Village
   -- Information: Instructor: Will Bunker, Heart Rate: 60, Location: Lake Village
-- DB design process aims at turning data into information

  -- 1. Requirements Analysis:
        -- What is the db going to be used for (e.g. dating)
        -- Define fields
        -- Assign fields to tables
        -- Design primary keys
        -- Establish relationships via foreign keys
            -- show the above steps via Entity Relationship Diagrams (ER Diagrams)
                -- where each table represents an object (e.g. customer, supplier) etc
                -- or an event (e.g. order, cancellation, meeting)
        -- 3 types of Relationships:
            -- One-to-One: like profile and description (e.g. in a dating site)
            -- One-to-Many: order to order_details
            -- Many-to-Many: actors and movies
        -- 3 bad design signs:
            -- Multipart field (e.g. fullname)
            -- Multivalued field (e.g. array)
            -- calculated field (e.g. total spent = price * quantity)
    -- 3. Normalization
        -- Eliminating duplicate columns
        -- Breaking large tables into smaller ones
        -- Reduce redundancy:
            -- Example: Having 5 fields for phone numbers in customer table
            -- Solution: Putting phone numbers in a seperate table having a foreign key relationship
            -- to customer
        -- Protecting from mistakes that render data useless:
            -- Example: Deleting order leaving many order_details orphaned

-- Lecture 75: Database Terminology
-- Term: Tuples = rows
-- Term : Relation = Table
    -- Each table (relation) has many rows (tuples)
-- Term: Attributes = Fields = Columns
-- Term: primary key
    -- Field that uniquely identifies each record in a table
    -- PK is used in databased to link information back to the row in the table
-- Term: Foreign Key
    -- When the PK is added to another table
    -- It links the info back to the original table and to the record
-- Term: NULL values
    -- Missing/unknown values
    -- Not an empty string
    -- When used correctly, lets you know what you dont know
    -- Affects calculations (e.g. 2 + NULL is null)
-- Term: Data Tables vs. Validation Tables
    -- Data tables: normal tables with records that change frequently
    -- Validation tables: for static values, used to turn text into numerical data
       -- For ex: turn all cities into numbers in a validation table to improve performance
-- Term: Linking Tables / Associative Tables
    -- Used to create many-to-many relationships

-- Lecture 76: DB design
-- Book recommendation: Database Design for Mere Mortals

-- DB design : A 7 step process
-- 1. Define mission statement & objectives
        -- objectives are list of tasks to accomplish using the database
-- 2. Analyze the current database and workflow
        -- looking for info being used to run the business
        -- can be in any form (e.g. on paper, excel etc)
            -- paper forms
            -- data entry screens
            -- docs generated
            -- spreadsheets
            -- reports
            -- screens
        -- interviewing the employees
-- 3. Create the data structure
        -- Define tables (e.g. from object & events)
        -- define fields and assign them to tables
        -- define primary keys
        -- define field specifications
-- 4. Create table relationships
        -- which tables are related
        -- establish foreign keys
        -- ensure that relationships will have foreighn key constraint preventing orphan rows
-- 5. Handle business rules
        -- Use interviews to find company rules (e.g. an instagram photo can be liked once)
        -- use lookup tables, functions, triggers and constrains to enforce rules
            -- e.g. add a trigger to check if the photo has already been liked by the same user
            -- if so, throw an db exception
-- 6. Define views
        -- who should see what information
-- 7. Review data integrity
        -- ??? Do fields have domain integrity?
        -- ??? Do tables have entity integrity?
        -- ??? Do table relationships have referential integrity?
        -- ??? Are business rules enforced?

-- Lecture 77: Mission statement
-- Example Mission Statement: Match.com's database should allow customers to search and find other people to date
-- and allow the company to profitable advertise to find the customers
    -- Example Mission Objectives (tasks that db should support):
      -- (1) Ability to search for people in opposite sex, close to their age within
      -- 30 mins of their home
      -- (2) Neet to review profiles before going live

-- Lecture 78: Analyzing Current Sytems:
-- Interview Questions
    -- What different jobs do you do?
    -- Who do you interact with to get your job done?
        -- I answer to phone talking to a CUSTOMER that wants to
        -- book an APPOINTMENT with a STYLIST
           -- Nouns: Customer, Appointment and Stylist --> Become tables
           -- Each table will represent a noun or an event
    -- Once tables (nounns & events) are found, we need to drill into
    -- each table looking for its characteristics/fields. To do that, ask:
        -- What info do you need to fullfill a customer ORDER?
        -- What info do you need to fullfill an APPOINTMENT?
            -- e.g. address, postal code, delivery cost etc
                -- these CHARACTERISTICS become COLUMNS.

-- Lecture 83-85: Skipped
-- Section 15 : Creating and Modifying Tables
-- Lecture 86: CREATE TABLE
-- Basic Table Creation (we will show how to do constraints in Section 16)
-- Syntax:
CREATE TABLE table_name (
    column1 data_type,
    column2 data_type,
    ...
)

-- Example:
CREATE TABLE subscribers (
	firstname varchar(200),
	lastname varchar(200),
	email varchar(250),
	signup timestamp,
	frequency integer,
	iscustomer boolean
);

-- Example:
CREATE TABLE returns (
	returnrid serial,
	customerid char(5),
	returndate timestamp,
	productid integer,
	quantity smallint,
	orderid integer
);


-- Lecture 87: ALTER TABLE : Part 1/3
-- ALTER TABLE : Changing a column name in a table
-- Syntax:
ALTER TABLE table_name
RENAME column_oldname TO column_newname

ALTER TABLE subscribers
RENAME firstname TO first_name;

ALTER TABLE returns
RENAME returndate TO return_date;

--ALTER TABLE : Rename the table
-- Syntax:
alter table old_table_name
rename to new_table_name;

ALTER TABLE subscribers
RENAME TO email_subscribers;

ALTER TABLE returns
RENAME TO bad_orders;

-- Lecture 88: ALTER TABLE : Part 1/3
-- ALTER TABLE : Add a field to a table
-- Syntax:
alter table table_name
add column_name datatype

-- add new column last_visit_date (timestamp) to email_subscribers table
alter table email_subscribers
add last_visit_date timestamp;

-- on bad orders table add a text field called reason
alter table bad_orders
add column reason text;

-- ALTER TABLE : Drop a field from a table
-- Syntax:
alter table table_name
drop column column_name;

-- on email_subscribers, drop the column last_visit_date
alter table email_subscribers
drop column last_visit_date

-- on bad_orders table, remove the reason field
alter table bad_orders
drop column reason;

-- ALTER TABLE : Change Data Type of a Column
-- Syntax:
alter table table_name
alter column column_name set data type data_type;

-- resize the email field in email_subscribers table to varchar with a length of 225
alter table email_subscribers
alter column email set data type varchar(225);

-- on bad_orders table change the quantity field to int (current small int)
alter table bad_orders
alter column quantity set data type int;

-- What are we ignoring for now while altering tables
    -- constraints and triggers
-- Lecture 90 : DROP tables
-- Syntax:
drop table table_name

drop table email_subscribers;
drop table bad_orders;

-- Section 16 : Table Constraints
-- Purpose of Table Constains: constraints control the kind of data that goes into a table
-- Lecture 91: NOT NULL constraint
-- Data type is the most basic kind of constraint; Do i want text, integers, floats etc
-- other constraits, which we will see soon, enables us to further restrict the data going into a table
-- Types of Constraints
-- Lecture 92:
NOT NULL    -- Field must have a value
UNIQUE      -- Value must not already be in table
PRIMARY KEY -- Must have a value and be unique --> used to identify a value
FOREIGN KEY -- All values must exist in another table
CHECK  <condition> -- Check that all values meet the condition
DEFAULT    -- If no value provided, value is set to the default

-- Create a table called practices with one field practiceid that is NOT NULL
create table practices (
    practiceid int not null
);

-- Drop the practices table and re-create it with two fields
-- practiceid integer and practice_field varchar(50) with both being not null
drop table practices;
create table practices (
    practiceid int not null,
    practice_field varchar(50) not null
);

-- ALTER TABLE + NOT NULL
-- Syntax:
alter table table_name
alter column column_name set not null;

-- Add NOT NULL constraint to the unitprice field in the products table
alter table products
alter column unitprice set not null;

-- make the lastname field of employees table always have a value
alter table employees
alter column lastname set not null;

-- Lecture 93:
-- Drop the practices table and re-create it with:
-- one field practice id that is unique and fieldname practice_field with varchar(50) and
-- has NOT NULL constraint
drop table practices;
create table practices (
    practiceid int unique,
    practice_field varchar(50) not null
);

-- create a table called pets with 2 fields
-- petid integer that is unique and cannot be null
-- name varchar(25) and must not have null values
create table pets (
    petid int not null unique,
    name varchar(25) not null
);

-- ALTER TABLE + UNIQUE constraint
alter table table_name
add constraint contraint_name unique(column);

-- Add UNIQUE constraint to the regiondescription field in the region table
alter table region
add constraint unique_regiondescription unique(regiondescription);

-- Make the companyname of the shippers table unique
alter table shippers
add constraint unique_companyname unique(companyname);

-- Lectrue 93: Adding PRIMARY KEY
-- PRIMARY KEY = NOT NULL UNIQUE

-- Drop the practices table and re-create it with:
-- one field practiceid that is PRIMARY KEY and
-- fieldname practice_field with varchar(50) and
-- has NOT NULL constraint
drop table practices;
create table practices (
    practiceid int primary key,
    practice_field varchar(50) not null
);

-- drop old pets table and re-create it:
-- petid integer that is the primary key
-- name varchar(25) and must not have null values
drop table pets;
create table pets (
    petid int primary key,
    name varchar(25) not null
);

-- ALTER TABLE + PRIMARY KEY
-- Syntax:
ALTER TABLE table_name
add primary key (column);

-- ALTER TABLE + DROP CONSTRAINT
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;

alter table practices
drop constraint practices_pkey;

alter table practices
add primary key (practiceid);

-- drop the primary key for pets and re-create it
alter table pets
drop constraint pets_pkey;

alter table pets
add primary key(petid);  --> check constraints in pets table in the UI, you will see pets_pk constraint

-- Lecture 94 : Foreign Key constraint
-- Syntax:
create table table1(
    column1 datatype,
    column2 datatype,
    ...
    foreign key (column_name) references table2(column_name)
)

-- use northwind_2 database
-- drop the table practices and re-create it:
-- practiceid with the primary key
-- fieldname practicefield varchar(50) and has NOT NULL
-- employeeid integer which is never null and a foreign key from employees table
drop table practices;
create table practices (
    practiceid int primary key,  --> creates practices_pkey constraint
    practice_field varchar(50) not null,
    employeeid int not null,
    foreign key (employeeid) references employees(employeeid)  --> creates practices_employeeid_fkey
);

-- Northwind_2 database
-- Drop the old pets table and create table called pets with 3 fields:
-- petid integer that is the primary key with auto increment
-- name varchar(25) and must not have null values
-- customerid char(5) which cant be null and a foreign key from customers table
drop table if exists pets;
create table pets (
    petid serial primary key, --> creates pets_pkey constraint
    name varchar(25) not null,
    customerid char(5) not null,
    foreign key (customerid) references customers(customerid)  --> creates pets_customerid_fkey constaint
);

-- ALTER TABLE + FOREIGN KEY constraint
alter table table_name
add constraint constraint_name foreign key (column) references table2(column);

-- ALTER TABLE + DROP CONSTRAINT
alter table table_name
drop constraint constraint_name;

-- Drop & Recreate Foreign Key (constraint name: practices_employeeid_fkey) constraint in practices table
alter table practices
drop constraint practices_employeeid_fkey;
alter table practices
add constraint practices_employeeid_fkey foreign key(employeeid) references employees(employeeid);

-- Drop the foreign key for customerid (named: pets_customerid_fkey) in pets table and
-- recreate it
alter table pets
drop constraint pets_customerid_fkey;
alter table pets
add constraint pets_customerid_fkey foreign key (customerid) references customers(customerid);

-- Lecture 96 : CHECK constraint
-- syntax:
create table table_name (
    column1 datatype,
    column2 datatype CONSTRAINT constraint_name CHECK (condition)
    ...
    constraint constraint_name check (condition)
)

-- Use northwind_2 database
-- Re-create practices table:
-- practiceid is the primary key
-- fieldname practice_field with varchar(50) and cannot be null
-- employeeid is integer type & cannot be null and a foreign key from employees table
-- cost integer which must be between 0 and 1000
drop table if exists practices;
create table practices (
    practiceid int primary key,
    practice_field varchar(50) not null,
    employeeid int not null,
    cost int constraint practices_cost_check check(cost >= 0 and cost <= 1000),
    foreign key (employeeid) references employees(employeeid)   --> will create practices_employeeid_fkey
);

-- Re-create pets table with 4 fields:
-- petid integer that is the primary key which will have auto increment
-- name varchar(25) and must not have null values
-- customerid char(5) which cannot be null and a foreign key from customers table
-- weight integer which has to be greater than 0 and less than 200
drop table if exists pets;
create table pets (
    petid serial primary key,  --> serial: int + auto increment
    name varchar(25) not null,
    customerid char(5) not null,
    weight integer constraint pets_weight_check check(weight > 0 and weight < 200),
    foreign key (customerid) references customers(customerid)
);

-- ALTER TABLE + CHECK constraint
alter table table_name
add constraint constraint_name
check(condition)

alter table table_name
drop constraint constraint_name

-- Use northwind_2 database
-- add constraint to orders table that freight must be more than 0
alter table orders
add constraint orders_freight_check
check(freight > 0);

-- add a CHECK constraint that unitprice in products table must be positive
alter table products
add constraint products_unitprice_check
check(unitprice > 0);

-- Lecture 97: DEFAULT constraint
-- Syntax
create table table_name (
    column1 datatype,
    column2 datatype DEFAULT value/function
)

-- Re-create practices table:
-- practiceid is the primary key
-- fieldname practice_field with varchar(50) and cannot be null
-- employeeid is integer type & cannot be null and a foreign key from employees table
-- cost integer which must be between 0 and 1000 and default 50
drop table if exists practices;
create table practices(
	practiceid integer primary key,
	practice_field varchar(50) not null,
	employeeid integer not null,
	cost integer not null default 50,
	foreign key (employeeid) references employees(employeeid),
	constraint check_cost check(cost >= 0 and cost <= 1000)
);

-- Re-create pets table with 4 fields:
-- petid integer that is the primary key with auto increment
-- name varchar(25) and must not have null values
-- customerid char(5) which cannot be null and a foreign key from customers table
-- weight integer which has to be greater than 0 and less than 200, default 5
drop table if exists pets;
create table pets (
	petid serial primary key,
	name varchar(25) not null,
	customerid char(5) not null,
	weight integer not null default 5,
	foreign key (customerid) references customers(customerid),
	constraint check_pets_weight check(weight >= 0 and weight <= 200)
);

-- ALTER TABLE + DEFAULT constraint
alter table table_name
alter column column_name
set default value;

alter table table_name
alter column column_name
drop default;

-- add default shipvia field in orders table, it must default to 1
alter table orders
alter column shipvia
set default 1;

-- set the default value of reorderlevel in products table to 5
alter table products
alter column reorderlevel
set default 5;

-- Lecture 97: Changing a Column's Default Value
-- Syntax:
alter table table_name
alter column column_name
set default new_value

-- Lets add a default reorderlevel of 5 to products table
alter table products
alter column reorderlevel
set default 5;

-- ALTER TABLE + DROP DEFAULT
alter table table_name
alter column column_name
drop default;

alter table products
alter column reorderlevel
drop default;

-- Make the suppliers homepage a default of 'N/A' (not available)
alter table suppliers
alter column homepage
set default 'N/A';

-- Remove the homepage default on the suppliers table
alter table suppliers
alter column homepage
drop default;

-- LECTURE 98 : Adding and Removing a Column's Constraint to an existing table
-- Syntax For Adding Constrains:
alter table table_name add check (condition)
alter table table_name add constraint constraint_name unique(column)
alter table table_name add foreign key (column) references table2(column)
alter table table_name alter column column_name set not null


-- remove products_unitprice_check constraint and
-- add it again (to check on products to reorderlevel that it must be greater than 0)
alter table products
drop constraint products_unitprice_check;
alter table products add check (reorderlevel > 0)  -- (1)
    -- Expected error:
    -- ERROR:  check constraint "products_reorderlevel_check" of relation "products" is violated by some row
        -- Lesson learned: if an existing row already violates the constraint, that constraint is not
        -- added to the table

-- Set a not null constraint on products for the discontinued column
alter table products alter column discontinued set not null  -- (2)

-- Syntax For Removing Constrains:
alter table table_name drop constraint constraint_name
alter table table_name alter column column_name drop not null

-- drop the reorderlevel constraint_name (1)
alter table products drop constraint products_reorderlevel_check

-- drop the not null constraint on discontinued column we added (2)
alter table products alter discontinued drop not null

-- add a check constraint to table order_details column unitprice to make sure it is a positive number
alter table order_details add check(unitprice > 0)  --> creates order_details_unitprice_check constraint
   -- remove the constraint:
   alter table order_details drop constraint order_details_unitprice_check

-- add a not null constraint to discount column in order_details table
alter table order_details alter column discount set not null
    -- remove the constraint
    alter table order_details alter column discount drop not null

-- Section 17 : Sequences
-- Lecture 100:
-- Doc: http://www.neilconway.org/docs/sequences/
-- Note: Sequences in postgresql is the same as generators in Python
CREATE SEQUENCE test_sequence;      -- initialized to 0 by default

SELECT nextval('test_sequence');    -- yields 1
SELECT nextval('test_sequence');    -- yields 2

SELECT currval('test_sequence');    -- yields 2

SELECT lastval();                   -- yields 2; the last nextval() of the very last sequence called

-- set value from which next value will increment
SELECT setval('test_sequence',14);
SELECT nextval('test_sequence');    -- yields 15

-- set value and the next value will be what you set
SELECT setval('test_sequence',25,false);    -- skip the current value : false
SELECT nextval('test_sequence');            -- yields 25, uses the current value as the nextval

CREATE SEQUENCE IF NOT EXISTS test_sequence2 INCREMENT 5;  --> 0, 5, 10, etc

CREATE SEQUENCE IF NOT EXISTS test_sequence_3
INCREMENT 50 MINVALUE 350 MAXVALUE 5000 START WITH 550;

CREATE SEQUENCE IF NOT EXISTS test_sequence_4 INCREMENT 7 START WITH 33;

SELECT MAX(employeeid) FROM employees;  -- returns 9
    -- 9 + 1 = 10 is the next employeeid
    CREATE SEQUENCE IF NOT EXISTS employees_employeeid_seq
    START WITH 10 OWNED BY employees.employeeid;
        -- If you want to hardcode X=10 into start with X, then:
        -- https://stackoverflow.com/questions/37057643/postgresql-starting-a-sequence-at-maxthe-column1
        create sequence employees_employeeid_seq
        increment 1 owned by employees.employeeid;

        select setval('employees_employeeid_seq',
                     (select max(employeeid)+1 from employees),
                     false);

    --This insert will fail; note that employeeid is not passed: null
    INSERT INTO employees
    (lastname,firstname,title,reportsto)
    VALUES ('Smith','Bob', 'Assistant', 2); --> attempt to insert NULL to employeeid (has not null constraint!)

    --employeeid does not have a default constraint, we need to create one utilizing the employees_employeeid_seq
    ALTER TABLE employees
    ALTER COLUMN employeeid SET DEFAULT nextval('employees_employeeid_seq');

    --Now Insert will work; note that employeeid is not passed: null --> default
    INSERT INTO employees
    (lastname,firstname,title,reportsto)
    VALUES ('Smith','Bob', 'Assistant', 2)
    returning employeeid;  --> returns 10

SELECT MAX(orderid) FROM orders;  --> returns 11077
CREATE SEQUENCE IF NOT EXISTS orders_orderid_seq START WITH 11078 OWNED BY orders.orderid;  -- (1) attach the sequence to the field in the table
    ALTER TABLE orders
    ALTER COLUMN orderid SET DEFAULT nextval('orders_orderid_seq');      -- (2) make nextval of the sequence set the default value to the field
    INSERT INTO orders (customerid,employeeid,requireddate,shippeddate)  -- null orderid passed --> default constraint will be used
    VALUES ('VINET',5,'1996-08-01','1996-08-10') RETURNING orderid;      -- returns 11078
    -- Lesson learned: If you want to set a default value to a field with the nextval from a sequence,
    -- you need to do 3 things in the following order:
        -- (0) create the sequence and attached it to table.column via owned by
        -- (1) use "select setval('<seq_name>') to set the currval of the sequence
        -- (2) make nextval of the sequence set the default value to the field

-- Docs: http://www.neilconway.org/docs/sequences/
-- Lesson learned:
-- serial = int + auto increment (+ not null)
-- to accomplish auto increment part in serial, postgresql creates a sequence behind the scenes:
    -- serial indicates that the values for the column will be generated from the sequence
    -- therefore, it creates a new sequence object, and sets the default value for the column to be the next value produced by the sequence
    -- since a sequence always produces non-NULL values, it adds a NOT NULL constraint to the column
-- So, there is a direct relation between serial & automatically created sequence

-- Lecture 100: Alter & Delete sequences
-- Syntax:
alter sequence sequence_name restart with start_val
alter sequence sequence_name rename to new_seq_name
drop sequence sequence_name
-- When do you need to re-set the start val of a sequence?
-- When you imported data to table

-- Set the employees_employeeid_seq to start with 1000
alter sequence employees_employeeid_seq restart with 1000
select nextval('employees_employeeid_seq')  --> returns 1000

-- change the orders_orderid_seq to start with 200000
alter sequence orders_orderid_seq restart with 200000
select nextval('orders_orderid_seq')  -- yields 200000

-- change test_sequence to test_sequence_1
alter sequence test_sequence rename to test_sequence_1

-- drop sequence test_sequence_1
drop sequence test_sequence_1

-- Lecture 101: Using Serial Datatypes automatically creating sequences
-- smallserial -- small int that increments automatically
-- serial -- int that increments automatically
-- bigserial -- bigint that increments automatically
-- Syntax:
create table table_name (
    field_name serial
);
    -- is equivalent to
    create sequence table_name_field_name_seq increment 1 start with 1;
    create table table_name (
        field_name int not null default nextval('table_name_field_name_seq')
    );
    alter sequence table_name_field_name_seq owned by table_name.field_name

-- create a table called exes with two fields exid, name. Make exid a serial
drop table if exists exes;
create table exes (
    exid serial,
    name varchar(255) not null
);
insert into exes(name) values ('Sophie') returning exid;

-- create a table named pets. It should have an id field that increases automatically
-- with another field for the name of pet
drop table if exists pets;
create table pets (
    petid serial,
    petname varchar(255) not null
);
insert into pets(petname) values('Dobby') returning petid;

-- Section 18: Common Table Expressions (CTE) (i.e. WITH Queries)
-- Lecture 102: WITH Queries
-- Doc: https://www.postgresqltutorial.com/postgresql-cte/  (use dvdrental_db)
-- Syntax:
with cte_name as (
    select statement
)
select statement that includes cte_name
-- CTE creates temporary table that is used just for the current query
-- Usage: Common Table Expressions or CTEs are typically used to simplify complex joins and subqueries in PostgreSQL
-- Hint: if you have a complex join or a complex subquery, consider using CTE

-- Task: We want to find out the number of units ordered and amount of sales
-- for all the products from the top three categories by total_sales
-- grouped by categoryname & productname
-- ordered by categoryname & productname
-- The desired end result:
-- categoryname, productname, units_ordered, total_sales
-- Solution 1:
with top_three_categories_by_total_sales as (
	select
		categories.categoryid,
		sum((od.unitprice * od.quantity) - od.discount) as total_sales
	from categories
	inner join products using(categoryid)
	inner join order_details as od using(productid)
	group by categories.categoryid
	order by total_sales desc limit 3
)
select
	categoryname, productname,
	sum(od.quantity) as total_number_of_units_ordered,
	sum((od.unitprice * od.quantity)-od.discount) as total_sales
from categories
inner join products using(categoryid)
inner join order_details as od using(productid)
where products.categoryid in (select categoryid from top_three_categories_by_total_sales)
group by categoryname, productname
order by categoryname, productname;
   -- Observation: you need to find top three categories by total_sales first;
   -- this is your subquery. CTE/With query enables you to name that subquery and refer
   -- to the temporary table CTE yields. In the main query,
   -- you can refer to the CTE (e.g. top_three_categories_by_total_sales )
   -- filter out the rows you need:
        where categoryname in (select categoryname from top_three_categories_by_total_sales)
-- Solution 2:
with top_three_categories_by_total_sales as (
	select categoryid
	from products inner join order_details as od using(productid)
	group by categoryid
	order by sum((od.unitprice*od.quantity)-od.discount) desc
	limit 3
), products_in_top_three_categories as (
	select productid, categoryid,
		   sum(od.quantity) as units_ordered,
		   sum((od.unitprice*od.quantity)-od.discount) as total_sales
	from products inner join order_details as od using(productid)
	where categoryid in (select categoryid from top_three_categories_by_total_sales)
	group by productid, categoryid
)
select categoryname, productname, units_ordered, total_sales
from categories inner join products_in_top_three_categories using (categoryid)
				inner join products using(productid)
order by categoryname, productname;

-- we want a list of customers, who ordered the 2 least ordered products
-- order by customername in asc order
-- (we want to see if we will loose any important customer if we quit
-- carrying those 2 products)
-- Solution #1:
with two_least_ordered_products as (
	select products.productid,
		   sum(quantity) as units_ordered
	from products inner join order_details using(productid)
	group by products.productid
	order by units_ordered asc limit 2
)
select distinct customers.customerid, customers.companyname
from customers inner join orders using(customerid)
	 		   inner join order_details using(orderid)
where productid in (select productid from two_least_ordered_products)
order by customers.companyname asc;
    -- Solution #2:
    with two_least_ordered_products(productid) as (
        select
            productid,
            sum(quantity) as quantity_ordered
        from order_details
        group by productid
        order by quantity_ordered asc limit 2
    )
    select
        customers.customerid,
        customers.companyname
    from customers
    inner join orders using(customerid)
    inner join order_details as od using(orderid)
    where od.productid in (select productid from two_least_ordered_products)
    group by customers.customerid
    order by customers.companyname asc;

-- Extra: Not in the lecture:
-- we want a list of customers, who ordered the 2 least ordered products
-- in terms of units ordered
-- and who are in top 10 list based on the total order cost
-- order by customername in asc order
-- (we want to see if we will loose any important customer if we quit
-- carrying those 2 products)
with two_least_ordered_products as (
	select products.productid,
		   sum(quantity) as units_ordered
	from products inner join order_details using(productid)
	group by products.productid
	order by units_ordered asc limit 2
), top_10_buyers_by_total_order_cost as (
	select
		customers.customerid,
		sum((od.quantity * od.unitprice) - od.discount) as total_order_cost
	from customers
	inner join orders using(customerid)
	inner join order_details as od using(orderid)
	group by customers.customerid
	order by total_order_cost desc limit 10
)
select
	distinct customers.customerid, customers.companyname
from customers
inner join orders using(customerid)
inner join order_details as od using(orderid)
where customers.customerid in (select customerid from top_10_buyers_by_total_order_cost)
and od.productid in (select productid from two_least_ordered_products)
order by customers.companyname asc;


-- Lecture 103: Using CTE to grab identity field from insert
-- Refer to Northwind Database
-- Common Problem: I just inserted a record with id field: inserted an order
-- and need orderid field for order_details records. How do i grab the orderid for the order
-- and use it for a further insert into order_details

    -- note: in order the insert to orders to work, you need to have orders_orderid_seq
    -- sequence attached to orders table's orderid field this way:
    -- add a sequence for orderid in orders table
    create sequence orders_orderid_seq owned by orders.orderid;
    select setval('orders_orderid_seq', (select max(orderid)+1 from orders), false);
    alter table orders alter column orderid set default nextval('orders_orderid_seq');

WITH new_order AS (
	INSERT INTO orders
	(customerid, employeeid, orderdate, requireddate)
	VALUES ('ALFKI', 1, '1997-03-10', '1997-03-25')
	RETURNING orderid
)
INSERT INTO order_details (orderid, productid, unitprice, quantity, discount)
SELECT orderid, 1, 20, 5, 0
FROM new_order;
    -- get the order we just inserted
    SELECT * FROM orders
    ORDER BY orderid DESC
    LIMIT 1;
    -- get the order_detail we just inserted
    SELECT * FROM order_details
    WHERE orderid = (SELECT MAX(orderid) FROM orders);


-- modify employees_employeeid_seq to point 
-- to the largest value in employeeid field in employees table
-- create a new employee record yielding employeeid
-- then use the returned employeeid in creating a new order
create sequence employees_employeeid_seq owned by employees.employeeid;
select setval('employees_employeeid_seq', (
	select max(employeeid)+1 from employees
), false);
alter table employees alter column employeeid
set default nextval('employees_employeeid_seq');

with new_employee_creation as (
	insert into employees(lastname, firstname, title)
	values ('Cuzdan', 'Hakan', 'Test Automation Developer')
	returning employeeid
)
insert into orders(customerid,
				   employeeid,
				   orderdate,
				   requireddate,
				   shippeddate,
				   shipvia,
				   freight,
				   shipname,
				   shipaddress,
				   shipcity,
				   shipregion,
				   shippostalcode,
				   shipcountry
				  )
select 'ANTON', employeeid, '13-09-2021'::date, '23-09-2021'::date,
       '15-09-2021'::date, 3, 9.99, 'Test Monkeys Oy', 'Eerikinkatu 25B 31',
	   'Helsinki', 'Uusimaa', '00180', 'Finland'
from new_employee_creation
returning orderid;
    -- get the latest employee just inserted
    select * from employees
    order by employeeid desc limit 1;
    -- get the latest order just inserted
    select * from orders where employeeid = (select max(employeeid) from employees);


-- Lecture 104 : Creating hierarchical data to use with recursive WITH queries
-- Using the Northwind database:
        -- delete the order we created in the previous lecture:
        delete from orders where employeeid = (select max(employeeid) from employees);
        -- delete the employee created in the previous lecture:
        delete from employees where employeeid = (select max(employeeid) from employees);

        UPDATE employees
        SET reportsto = NULL
        WHERE employeeid= 2;

        DELETE FROM employees WHERE employeeid > 9;

        INSERT INTO employees (firstname,lastname,address,city,country,postalcode,homephone,title,employeeid,reportsto) VALUES
        ('Josephine','Boyer','463-4613 Ipsum Street','Saint-Prime','USA','73-638','741-0423','CEO',200,NULL),
        ('Marvin','Cole','P.O. Box 857, 9463 Et St.','Sauris','Philippines','91-806','717-0456','CFO',201,200),
        ('Lee','Hatfield','Ap #152-543 Facilisis. St.','Baden','Monaco','44981-785','990-7598','CTO',202,200),
        ('Chancellor','Hubbard','672-2470 Adipiscing Avenue','Chatteris','Macao','79613','1-655-930-7580','Head of Ops',203,200),
        ('Jakeem','Chaney','177 Mauris Road','Izmir','France','6729','1-849-661-5415','Ops Manager',204,203),
        ('Paul','Sutton','5572 Morbi St.','Fourbechies','United Kingdom','3072','1-664-924-2966','Ops Manager - Europe',205,203),
        ('Aaron','Erickson','2646 Sem, Avenue','Olen','USA','9656','1-713-526-0184','Ops Manager - USA',206,203),
        ('Azalia','Wagner','Ap #543-1195 Mi Av.','Swan Hills','USA','1481','544-1445','Warehouse USA',207,206),
        ('Elmo','Goodwin','Ap #609-977 Gravida Ave','Frascati','USA','5083','1-281-122-4910','Warehouse USA',208,206),
        ('Quon','Durham','523 Praesent Rd.','Lutsel K''e','USA','40535-562','951-4455','Warehouse USA',209,206),
        ('Keaton','Weber','Ap #228-2672 Nulla Av.','La Pintana','USA','6812','1-845-128-7756','Warehouse USA',210,206),
        ('Edward','Hahn','Ap #802-6505 Malesuada Rd.','Tuticorin','United Kingdom','017440','549-3727','Warehouse Europe',211,205),
        ('Ariana','Webster','7875 Tempus Avenue','Maltignano','United Kingdom','08573','137-2511','Warehouse Europe',212,205),
        ('Todd','Workman','3689 Ultrices Street','Northumberland','United Kingdom','8489','516-6304','Warehouse Europe',213,205),
        ('Zachery','May','Ap #995-8373 Urna. Ave','Malahide','Benin','60538','1-599-255-1156','Sales Assistant',214, 3),
        ('Bert','Hayden','Ap #302-641 Magna. Avenue','Erdemli','Netherlands','833743','699-3083','Sales Assistant',215, 6),
        ('Renee','Walter','P.O. Box 366, 9086 Molestie. Rd.','Spijkenisse','Turkey','24-954','1-346-528-1347','Sales Assistant',216, 3),
        ('Jessica','Moss','Ap #621-2177 Egestas. St.','Chépica','Ireland','2762','1-712-113-5307','Sales Assistant',217, 9),
        ('Kiona','Dudley','Ap #363-6364 Tincidunt Rd.','Antwerpen','Tonga','OL3H 6ZZ','1-365-255-0842','Sales Assistant',218, 4),
        ('Veronica','Sosa','Ap #261-3206 Tempus St.','Alcorcón','Malaysia','60804','479-1676','Sales Assistant',219, 8),
        ('Addison','Welch','P.O. Box 477, 206 Amet Avenue','Abbotsford','Zambia','34948-111','977-9391','Programmer',220, 202),
        ('Brendan','Parrish','Ap #875-923 In, Ave','Clovenfords','Ecuador','13168','949-4055','Data Analyst',221, 202),
        ('Dakota','Delgado','P.O. Box 653, 3364 Arcu Rd.','Valdivia','Antarctica','44623','1-206-971-7181','Accounting',222, 201),
        ('Kirby','Mullins','1166 Donec Rd.','Meridian','Mozambique','886609','807-6992','Accounting',223, 201),
        ('Stuart','Clarke','P.O. Box 177, 3565 Senectus St.','Viddalba','Libya','WS7 3JO','933-7681','Personal Assistant',224, 200);


        UPDATE employees
        SET reportsto = 200
        WHERE employeeid= 2;

-- Lecture 105 : Using recursion in CTEs : Using recursion in WITH clauses
-- Docs: https://www.postgresqltutorial.com/postgresql-recursive-query/
-- With recursion, questions like below are answered:
    -- Who are all the descendents of a specific person
    -- What are all the sub-products of a larger product (e.g. bill of materials)
    -- What is the organizational structure of a company?
-- Syntax:
with recursive recursion_name(field1, field2, ...) as (
    select statement that returns definite value  -- non-recursive term
    union all
    select statement that combines with first statement using field(s) from recursion_name -- recursive term
    where condition --> termination check to stop the recursion
)
-- A recursive CTE has 3 elements:
    -- Non-recursive term: the non-recursive term that forms the base result set
    -- Recursive term, which references the recursion_name itself
    -- Termination check: the recursion stops when no rows are returned
    -- from the previous iteration
-- PostgreSQL executes a recursive CTE in the following sequence:
    -- Execute the non-recursive term to create the base result set (R1 for iteration 1)
    -- For i = 2 to n:
        -- Execute the recursive term with Ri-1 as an input to recursion_name:
            -- Make termination check, if it passes union all the result set Ri+1
            -- if termination check fails at step n, stop.
    --  Return the final result set that is a UNION or UNION ALL of the result set R1, R2, … Rn-1

-- Create a set of 1 to 50 using recursion
with recursive my_set(t) as (
    select 1
    union all
    select t+1 from my_set where t < 50
)
select * from my_set

-- Write a recursive CTE that starts at 500
-- and counts down to 2 by even numbers
with recursive my_set(t) as (
    select 500
    union all
    select t-2 from my_set where t >= 4
)
select * from my_set
    -- Solution 2:
    with recursive count_down_from_500_by_2 as (
        select 500 as counter
        union all
        select counter-2 as counter from count_down_from_500_by_2 where counter >= 4
    )
    select * from count_down_from_500_by_2;
    -- Solution 3:
    with recursive count_down_from_500_by_2(counter) as (
        select 500
        union all
        select counter-2 from count_down_from_500_by_2 where counter >= 4
    )
    select * from count_down_from_500_by_2;

-- Task: Find everyone that the CEO is responsible for (employeeid = 200)
-- Find everyone that the CEO is responsible for (employeeid = 200)
with recursive everyone_under_CEO as (
	select employeeid, firstname, lastname, title from employees where reportsto = 200
	union all
	select e.employeeid, e.firstname, e.lastname, e.title from employees as e inner join everyone_under_CEO on e.reportsto = everyone_under_CEO.employeeid
)
select * from everyone_under_CEO;

-- Find the chain of command from Dudlye Kiona (employeeid = 218) up to the CEO (employeeid = 200)
with recursive chain_of_command as (
	select employeeid, firstname, lastname, title, reportsto from employees where employeeid = 218
	union all
	select boss.employeeid, boss.firstname, boss.lastname, boss.title, boss.reportsto
	from employees as boss inner join chain_of_command on boss.employeeid = chain_of_command.reportsto
)
select * from chain_of_command;

-- Section 19: Views
-- Documentation: https://www.postgresqltutorial.com/postgresql-views/
-- Lecture 106: What is a view? How to create one?
-- What is a view?
-- It acts like a stored query that you give a name
-- Once created, you can SELECT to pull information like a regular table
    -- Similar to CTE/With clause, but the view table is preserved for the future select statements
    -- it is not destroyed within the same query like in CTE/With clause.
-- Used to keep from having to type long queries again and again
-- Grant permissions. So that you can limit person/group from accessing all the fields
    -- This could be a suitable case for a tester, as he does not need full access to the database
-- Syntax:
create view view_name as
select statement

-- My additional task: create a view called
-- list_report_chain returning
-- employeeid, firstname, lastname, reportsto of all
-- employees starting from employeeid=218 up to the CEO
create recursive view list_report_chain(employeeid, firstname, lastname, reportsto) as
select
	employeeid, firstname, lastname, reportsto
from employees where employeeid=218
union all
select
	e.employeeid, e.firstname, e.lastname, e.reportsto
from employees as e inner join list_report_chain
on e.employeeid = list_report_chain.reportsto;
-- OR
create view list_report_chain as (
	with recursive subordinate as (
		select employeeid, firstname, lastname, reportsto from employees
		where employeeid = 218
		union all
		select e.employeeid, e.firstname, e.lastname, e.reportsto
		from employees as e inner join subordinate as s on e.employeeid = s.reportsto
	)
	select * from subordinate
);
select * from list_report_chain

-- create a view called customer_order_details that links customers, orders and order_details
CREATE VIEW customer_order_details AS
SELECT companyname, Orders.customerid, employeeid, orderdate, requireddate, shippeddate
Shipvia, freight, shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry,
order_details.*
FROM customers
JOIN orders on customers.customerid=orders.customerid
JOIN order_details on order_details.orderid=orders.orderid;
    -- use the customer_order_details view
    SELECT *
    FROM customer_order_details
    WHERE customerid='TOMSP';

-- create a view called supplier_order_details that shows all orders and order_details
-- Then select all the order_details for supplierid = 5
create view supplier_order_details as
select s.supplierid, s.companyname, s.contactname, s.contacttitle, s.address, s.city, s.region, s.postalcode, s.country, s.phone, s.fax, s.homepage,
       p.productid, p.productname, p.categoryid, p.quantityperunit, p.unitprice as product_unitprice, p.unitsinstock, p.unitsonorder, p.reorderlevel, p.discontinued,
       od.unitprice as order_unitprice, od.quantity, od.discount,
       o.orderid, o.customerid, o.employeeid, o.orderdate, o.requireddate, o.shippeddate, o.shipvia, o.freight, o.shipname,
       o.shipaddress, o.shipcity, o.shipregion, o.shippostalcode, o.shipcountry
from suppliers as s inner join products as p using(supplierid)
               inner join order_details as od using(productid)
               inner join orders as o using(orderid);
    -- Then select all the order_details for supplierid = 5
    select * from supplier_order_details where supplierid = 5;

-- Lecture 107: Modify a View
-- Syntax:
create or replace view view_name as
select modified_query
    -- Gotchas:
    -- cant remove an existing column in the view
        -- if you need to do so, then drop the view & re-create it
    -- must have the same columns with the same name, same datatypes, in the same order
    -- you can add column names only

-- Lecture 108: Creating updatable VIEWs
-- You can update, delete or insert records into a view if:
-- (1) only one table is referenced in from (could be another updatable view)
-- (2) cant have GROUP BY, HAVING, LIMIT, DISTINCT, UNION, INTERSECT and EXCEPT
-- in defining query
-- (3) cant have any window functions (???), set returning function (???), or any aggragate functions

-- example to an updatable view
-- create a view of customers called north_america_customers for all customers from USA, Canada and Mexico
    -- note that this view satisfies the constrains (1)-(3)
-- Use Norttwind database
CREATE VIEW north_america_customers AS
SELECT *
FROM customers
WHERE country in ('USA','Canada','Mexico');
    -- !!! OBSERVATION: data can be inserted via the updatable view to the base table the view refers
    -- Note that updatable view must satisfy the constrains (1)-(3)
    INSERT INTO north_america_customers
    (customerid,companyname,contactname,contacttitle,address,city,region,postalcode,country,phone,fax)
    VALUES ('CFDCM','Catfish Dot Com','Will Bunker','President','Old Country Road','Lake Village','AR','71653','USA','555-555-5555',null);
        -- if you check in customers table, the row is already added
        select * from customers where customerid = 'CFDCM';
-- !!! observation: Data can be updated via the updatable view
UPDATE north_america_customers SET fax='555-333-4141' WHERE customerid='CFDCM';
-- !!! observation: data can be deleted via the updatable view
DELETE FROM north_america_customers WHERE customerid='CFDCM';

-- Use northwind database
-- create an updateable view of all the products that are in dairy products
-- meat/poultry, and seafood categories (categoryid of 4,6 and 8)
-- call this view as protein_products
-- test that you can insert into, update andd delete a record using the view
create view protein_products as
select * from products where categoryid in (4,6,8);
    -- note that the view is an updatable view bcoz it satiffies (1)-(3)
-- At this point, having checked the products.productid, we see that it is a primary key
-- but it does not have a sequence attached to it. Lets create a sequence:
select max(productid)+1 from products;  -- yields 78
create sequence products_productid_seq start with 78;
alter sequence products_productid_seq owned by products.productid;  -- attach the seq to the products.productid
alter table products alter column productid set default nextval('products_productid_seq');

-- note that in the below insert, we do not provide the productid
insert into protein_products (productname, supplierid, categoryid, quantityperunit, unitprice,
unitsinstock, unitsonorder, reorderlevel, discontinued)
values ('new cool product', 1, 6, 1, 1, 1, 1, 0, 1);     -- (1)
    -- grab the newly created product
    select * from protein_products where productid = 78
    -- update the newly created product; note that row with productid=78 has a categoryid of 6; included in the view;
    -- can do the update, otherwise not (with check option)
    update protein_products set productname='Fake Nose' where productid=78;
    -- delete the newly created product; note that row with productid=78 has a categoryid of 6; included in the view;
    -- can do the deletion, otherwise not (with check option)
    delete from protein_products where productid=78
    -- check that the newly created product is deleted
    select * from protein_products where productid = 78
-- Observations:
-- create view has a where clause, lets call it where_clause_view
-- Note that the view does NOT have WITH CHECK OPTION
    -- via the view, ANY row not belonging to where_clause_view can be inserted
        -- e.g. a product with categoryid is 1 can be inserted along with categoryid 6
-- update view has a where clause, lets call it where_clause_update
-- delete view has a where clause, lets call it where_clause_delete
    -- when updating a row(s) from the view, if where_clause_update & where_clause_view yields a row(s), then updating takes place. Otherwise, no updating takes place
        -- in other words, the to be updated rows must be part of the view in order the update to happen; the view acts as a filter
    -- when deleting a row(s) from the view, if where_clause_delete & where_clause_view yields a row(s), then deletion takes place. Otherwise, no deletion takes place
        -- i.e. if the inserted product in (1) had a categoryid 1 (i.e. bad data), the product would not be part of the view (view expects categoryid to be 4,6,8)
        -- any update & delete operation via the view would do nothing for the product
            -- Observation: bad data can be inserted via the view, unless WITH CHECK OPTION is added to the view. We will address WITH CHECK OPTION next

-- Lecture 109: VIEWs WITH CHECK OPTION
-- Note: Northwind database is still used
-- So far, we can add bad data (e.g. a customer in Germany) into north_america_customers view:
-- Lets insert a bad customer via the north_america_customers view into the customers table
INSERT INTO north_america_customers
(customerid,companyname,contactname,contacttitle,address,city,region,postalcode,country,phone,fax)
VALUES ('CFDCM','Catfish Dot Com','Will Bunker','President','Old Country Road','Lake Village','AR','71653','Germany','555-555-5555',null);

SELECT FROM north_america_customers
WHERE customerid=’CFDCM’;   -- returns nothing
    -- returns the bad customer
    SELECT * FROM customers
    WHERE customerid=’CFDCM’;

-- How to prevent inserting data via a view that does not belong to an the view?
-- Answer: By using WITH CHECK OPTION
-- Syntax:
    with local check option    --> if the updatable view is not cascaded to other updatable view(s)
    with cascaded check option --> if the updatable view is cascaded to other updatable view(s)
        -- remember from lecture 106 that a views can casccade to another view and so on..

-- Change north_america_customers to check that the country is correct and test
-- in other words, the view should not allow bad customers to be inserted
-- Note that north_america_customers already exists, lets update it:
CREATE OR REPLACE VIEW north_america_customers AS
SELECT *
FROM customers
WHERE country in ('USA','Canada','Mexico')
with local check option;
    -- now the attempt to insert a bad customer (e.g. from Germany) via north_america_customers into customers table should fail:
    INSERT INTO north_america_customers
    (customerid,companyname,contactname,contacttitle,address,city,region,postalcode,country,phone,fax)
    VALUES ('CFDCM','Catfish Dot Com','Will Bunker','President','Old Country Road','Lake Village','AR','71653','Germany','555-555-5555',null);
        -- Expected error: ERROR:  new row violates check option for view "north_america_customers"

-- Modify protein_products to prevent bad data to be entered. Test it.
create or replace view protein_products as
select * from products where categoryid in (4,6,8)
with local check option;
    -- test that bad data (e.g. product with i.e. category id 1) can not be inserted into the products table via the protein_products view
    -- note that in the below insert, we do not provide the productid
    insert into protein_products (productname, supplierid, categoryid, quantityperunit, unitprice,
    unitsinstock, unitsonorder, reorderlevel, discontinued)
    values ('new cool product', 1, 1, 1, 1, 1, 1, 0, 1);
        -- Expected error: ERROR:  new row violates check option for view "protein_products"

-- Lecture 110: Deleting VIEWs
-- Syntax:
drop view view_name
drop view if exists view_name

-- drop the view customer_order_details
drop view if exists customer_order_details

-- delete the view suppler_order_details
drop view if exists suppler_order_details

-- Section 20: Conditional Expressions
-- Lecture 111: Conditional expression : CASE WHEN
-- Like IF / THEN statements in regular programming
-- Syntax:
select column1, column2, ..,
       case when condition1 then result1
            when condition2 then result2
            ...
            else default
        end as logical_column
from table_name where condition

-- Example; we want to return companyname, country and the continent our customers are coming from
-- Note that continent is a logical_column; it does not exist in the db directly, it needs to be calculated
-- calculation is to be done in CASE WHEN statements:
SELECT companyname,country,
CASE WHEN country IN ('Austria','Germany','Poland','France','Sweden','Italy','Spain',
             'UK','Ireland','Belgium','Finland','Norway','Portugal','Switzerland') THEN 'Europe'
     WHEN country IN ('Canada','Mexico','USA') THEN 'North America'
     WHEN country IN ('Argentina','Brazil','Venezuela') THEN 'South America'
     ELSE country
END AS continent
FROM customers;

-- A list of product names, unitprice and label corresponding to inexpensive
-- if the unitprice is below $10, mid-range if price $10 up to $50 and expensive if over $50
select productname, unitprice,
case when unitprice < 10 then 'inexpensive'
	 when unitprice <= 50 then 'mid-range'
	 else 'expensive'
end as price_range
from products;

-- Second Syntax for CASE WHEN: Same as switch statements in C++
case field when value1 then result1
           when value2 then result2
           else default_result
end

-- Pull back orders with orderid, customerid and year1 if orderdate is 1996,
-- year2 if orderdate is 1997 and year3 if orderdate is 1998
-- Hint: use date_part('year', orderdate) to select the year out of orderdate field
select orderid, customerid,
case date_part('year', orderdate) when 1996 then 'year1'
                                  when 1997 then 'year2'
                                  when 1998 then 'year3'
                                  else 'not in range'
end as year
from orders

-- Lecture 112: Coalesce (i.e. birlesmek) function
-- you supply a list of fields or values. It returns the first
-- non-null value. Often used to substitute a default value for a null value
-- Syntax:
coalesce(field1, field2, field3, ..., value1)
coalesce(field1, value1) -- Often used to substitute a default value for a null value

-- return 'N/A' for region from orders when the field is null
select orderid, coalesce(shipregion, 'N/A') as shipregion
from orders;

-- return a list of suppliers companyname and homepage.
-- if homepage is missing, then put in 'call to find' for the field
select companyname, coalesce(homepage, 'call to find') as homepage
from suppliers;

-- Lecture 113: NULLIF function
-- Sytnax:
nullif(field1, value1)
-- returns null if two values are equal, otherwise returns field1 value
-- usa case: imagine instead of having nulls in your tables, there are empty strings
-- instead of null values. You want to treat empty strings as nulls:
UPDATE suppliers
SET homepage = ''
WHERE homepage IS NULL;

UPDATE customers
SET fax = ''
WHERE fax IS NULL;

-- if you want to treat empty strings as nulls, then you can use NULLIF
nullif(homepage, '') --> returns null if homepage is empty string
-- which becomes handy in:
select supplierid, coalesce(nullif(homepage, ''), 'call to find') from suppliers

-- need a confirmation list of customers. return fax number if available or phone
-- number as the second option
select companyname, coalesce(nullif(fax, ''), phone, 'contact info missing') as contact_info
from customers

-- Section 21: Using Date/Time in PostgreSQL
-- Lecture 114: Date, time and Timestamp Data types
-- timestamp - both date and time
-- date - date only
-- time - time only
-- Timestamp/Time Options
-- You can specify the precision of the seconds value (number of digits after the decimal point)
-- from 0 to 6 digits
timestamp(3) --> 1/8/2017 12:22:22.321
time(4)      --> 02:12:01.4321

-- IMPORTANT!!! The SQL data types date, time, and timestamp are field based time values
-- which are intended to be zone offset independent:
-- they are actually, technically, floating time values!
-- The data type "timestamp with time zone" is the zone offset-dependent equivalent of timestamp in SQL.
-- you can allow time zones or not -- default is no TZ if not specified
    -- Use "timestamp" if you want to use floating times
    -- Use "timestamp with timezone" if you want to use local times
    timestamp  -- by default floating time, not attached to any TZ
    timestamp with time zone -- maps to an incremental time

-- Inputting Dates:
-- PostgreSQL accepts many styles/timestamp formats but there can be confusion around month and day order
    -- i.e. '2017-01-10' is Jan 10, 2017 (ISO 8601 style) but it could be Oct 1, 2017 in some countries
    -- 'Jan 8,2018' will always work
-- To ensure that we use the correct month and day order, use DATESTYLE setting
show datestyle  --> returns ISO, DMY  --> European style
    -- datestyle is stored in a PostgreSQL configuration file. When db server starts
    -- it reads datestyle from the config file and uses it. We can set datestyle for the session
    -- but next time we re-start PostgreSQL server, it will use the config file's datestyle value.
    set datestyle = 'ISO,MDY'  --> American style

-- Inputting Times:
-- Consists of time of day followed by optional TZ (covered in the next lecture)
04:05 AM
04:05 PM
04:04:06.789

-- Inputting Timestamp
-- Consists of the concetenation of a date and a time, followed by an optional TZ (covered in the next lecture)

-- Special Date/Time Inputs
-- Input,       DATA TYPE,                  VALUE
-- epoch,       date, timestamp             1970-01-01 00:00:00
-- infinity     date, timestamp             later than all other timestamps
-- -infinity    date, timestamp             earlier than all other timestamps
-- now          date, timestamp, timestamp  Current transaction's start time
-- today        date, timestamp             Midnight today
-- tomorrow     date, timestamp             Midnight tomorrow
-- yesterday    date, timestamp             Midnight yesterday
-- allballs     time                        00:00:00.0 UTC

CREATE TABLE test_time (
	startdate DATE,        --> floating time
	startstamp TIMESTAMP,  --> floating time
	starttime TIME         --> floating time
);

Insert INTO test_time (startdate, startstamp,starttime)
VALUES ('epoch','infinity','allballs');

Insert INTO test_time (startdate, startstamp)
VALUES ('NOW','today');

select * from test_time;

show datestyle;  --> ISO, DMY
insert into test_time (startdate, startstamp, starttime)
values ('27-04-1978', '27-04-1978 04:05:06', '04:05:06')

select * from test_time;

-- Lecture 115: Time Zones
-- Depend on geography (TZ) and politics (daylight savings)
-- PostgreSQL recommends using timestamps (date + time) when using time zones
-- SQL standard allows timezones with 'time' data type. Should try to avoid
-- because it can't handle daylight-saving-time.

-- ??? Avoid using a numeric offset (e.g. UTC+2) because it cant handle daylight-saving time either
    -- If the offset mentioned is zone/UTC offset, but not TZ identifier, then we do not know
    -- about the location, which in turn means we do not know about DST.

-- 3 different format for timezones:
-- 1. Full zone name: America/Los Angeles    <<< Focus of this lecture, maps to incremental time
-- 2. Abbreviation: EST (Eastern Standard Time)
-- POSIX-style: EST+5 or EST+5EDT  (Eastern Standard Time + daylight saving)
    -- Full names allow the db to calculate if daylight saving time is present
    -- depending on the date. The abbreviation does not let you do this (???)

-- How to see the available TZ names?
select * from pg_timezone_names   --> a pre-set view
    -- https://www.postgresql.org/docs/9.2/view-pg-timezone-names.html
select * from pg_timezone_abbrevs --> a pre-set view
    -- https://www.postgresql.org/docs/9.2/view-pg-timezone-abbrevs.html
    -- 

-- add new columns to test_time
alter table test_time
add column endtime time with time zone   --> ??? How to have time without date with time zone?

alter table test_time
add column endstamp timestamp with time zone --> handles DST correctly

INSERT INTO test_time
(endstamp,endtime)
VALUES ('01/20/2018 10:30:00 US/Pacific', '10:30:00+5');  --> shows local 2018-01-20 20:30:00+02
INSERT INTO test_time (endstamp,endtime)
VALUES ('06/20/2018 10:30:00 US/Pacific', '10:30:00+5');
    -- 06/20/2018 10:30:00 US/Pacific  -> TZ identifier = UTC-7h (DST applied)
    -- local machine geo location is Helsinki. On 06/20/2018, Helsinki TZ identifier was UTC+3h
    select * from test_time
    --> shows local 2018-06-20 20:30:00+03 (+03 is TZ identifier)

-- See Time zone for session
show time zone   --> 'Europe/Helsinki'

-- notice the offset of time
select * from test_time   --> Observation: note that endstamp & endtime values shown in local time zone
    --> shows local 2018-06-20 20:30:00+03 (+03 is TZ identifier)
set time zone 'US/Pacific'
select * from test_time   --> Observation: note that endstamp & endtime values shown in local time zone
    -- endstamp = 2018-06-20 10:30:00-07 (YYYY-MM-DD hh:mm:ssZZZZ)
set time zone 'Europe/Helsinki'

-- Lecture 116: Interval Data Type
-- Documentation: https://www.postgresql.org/docs/11/datatype-datetime.html#DATATYPE-INTERVAL-INPUT
-- Syntax used in a table schema:
interval
interval [fields][precision]

-- [fields] options
year
month
day
hour
minute
second
year to month
day to hour
day to minute
day to second
hour to minute
hour to second
minute to second

-- There are 3 different formatting we can use to input intervals:
-- (1) Interval Input - Postgres Format
    quantity unit [direction]
        -- where unit can be
        microsecond
        millisecond
        second
        minute
        hour
        day
        week
        month
        year
        decade
        century
        millenium
        -- using the plurals is also needed

        [direction] can be ago or blank. If ago is used, the interval is in the past. Otherwise it is in the future

        -- Examples:
        1 day 13 hours 20 minutes 10 seconds
        5 millenium 2 centuries ago

-- (2) Interval Input - SQL Standard Format
    YYYY-MM-DD HH:MM:SS
    -- Examples:
    200-10-4 32:12:10  --> 200 years, 10 months, 4 days, 32 hours, 12 minutes, 10 seconds
    1-2   --> 1 year, 2 months
    4 32:12:10  --> 4 days, 32 hours, 12 minutes, 10 seconds

-- (3) Interval Input - ISO 8601 Interval Input
    P [quantity unit]xn T [quantity unit]xn
    units: Y (years), M (months), D (days), H (hours), M (minutes), S (seconds)
    -- Example:
    P5Y3M4DT7H10M23S

-- At this point, we know 3 different formats to input intervals
    -- (1) Interval Input - Postgres Format
    -- (2) Interval Input - SQL Standard Format
    -- (3) Interval Input - ISO 8601 Interval Input

-- We can use any of these formats to input an interval to Postgres.

-- So, lets add a field of type interval to test_time table:
alter table test_time
add column span interval
-- Lets insert rows with span field using the 3 different format
    -- (1) Interval Input - Postgres Format
        insert into test_time (span)
        values ('5 decades 3 years 6 months 3 days')
    -- (2) Interval Input - SQL Standard Format
        insert into test_time (span)
        values ('4 32:12:10')
        insert into test_time (span)
        values ('1-2')
    -- (3) Interval Input - ISO 8601 Interval Input
        insert into test_time (span)
        values ('P5Y3MT7H3M')

        insert into test_time (span)
        values ('P25Y2M30DT17H33M10S')

-- Now we have test_time table's span field filled with timespan values.

-- We can use the following 3 different formats to input intervals:
    -- Interval Input - Postgres Format
    -- Interval Input - SQL Standard Format
    -- Interval Input - ISO 8601 Interval Input
-- Depending on the intervalstyle setting (show intervalstyle), Postgres will show the interval values
-- in one of the following formats:
    -- postgres             (set intervalstyle='postgres')
    -- postgres_verbose     (set intervalstyle='postgres_verbose')
    -- sql_standard         (set intervalstyle='sql_standard')
    -- iso_8601             (set intervalstyle='iso_8601')
    select span from test_time where span is not null;

-- Lecture 117: The interval/date/time arithmetic (???)
-- Observation: You can say that Postgres has calendars for all calendar years (e.g. 1999,2000,2001,etc)
-- Observation: The interval/date/time arithmetic presented in this lecture is made using floating times
-- Documentation: https://www.postgresql.org/docs/11/functions-datetime.html
-- To another interval, you can ADD date, time, timestamp, or interval
    SELECT DATE '2018-09-28' + INTERVAL '5 days 1 hour';  --> 2018-10-03 01:00:00 (timestamp without tz)
    SELECT TIME '5:30:10' + INTERVAL '70 minutes 80 seconds';  --> 06:41:30       (time without tz)
    SELECT TIMESTAMP '1917-06-20 12:30:10.222' +
    INTERVAL '30 years 6 months 7 days 3 hours 17 minutes 3 seconds'; --> 1947-12-27 15:47:13.222 (timestamp without tz)
    SELECT INTERVAL '5 hours 30 minutes 2 seconds' + INTERVAL '5 days 3 hours 13 minutes';  --> 5 days 08:43:02 (interval)
    SELECT DATE '2017-04-05' +  INTEGER '7';  --> 2017-04-12 (date)

-- subtracting intervals from date,time, timestamp
    SELECT DATE '2018-10-20' - INTERVAL '2 months 5 days';  --> ??? 2018-08-15 00:00:00 (timestamp without tz)
    SELECT TIME '23:39:17' - INTERVAL '12 hours 7 minutes 3 seconds'  --> 11:32:14 (time without tz)
    SELECT TIMESTAMP '2016-12-30' - INTERVAL '27 years 3 months 17 days 3 hours 37 minutes'; --> 1989-09-12 20:23:00 (timestamp without tz)

-- subtracting integer(days) from date
    SELECT DATE '2016-12-30' - INTEGER '300';  --> 2016-03-05 (date)

--subtracting 2 dates
    SELECT DATE '2016-12-30' - DATE '2009-04-7';  --> 2824 days as integer

-- subtracting 2 times
    SELECT TIME '17:54:01' - TIME '03:23:45';  --> 14:30:16 (interval)
-- subtracting  and 2 timestamps
    SELECT TIMESTAMP '2001-02-15 12:00:00' - TIMESTAMP '1655-08-30 21:33:05';  --> 126177 days 14:26:55 (interval)

--Multiply and divide intervals
    SELECT 5 * INTERVAL '7 hours 5 minutes';  --> 35:25:00 (interval)
    SELECT INTERVAL '30 days 20 minutes' / 2; --> 15 days 00:10:00 (interval)

-- How to calculate an age of a person/event?
SELECT age(TIMESTAMP '2025-10-03', TIMESTAMP '1999-10-03');  -- 26 years (interval)
SELECT age (TIMESTAMP '1978-04-27');                         --> 42 years 7 months 11 days

-- Observation: The interval/date/time arithmetic presented above so far is made using floating times
-- Question: Can Postgres do interval/date/time arithmetic in local times? The answer is yes:
    select timestamp with time zone '20-06-2018 10:30:00 US/Pacific' - interval '30 years 6 months 7 days 3 hours 17 minutes 3 seconds';
        -- 1987-12-13 17:12:57+02 (timestamp with time zone identifier, note that it is shown in my machines local time!)

-- Lecture 118: Pulling out parts of dates & times
-- This lecture uses northwind database
-- Documentation: https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT
-- 2 methods to use:
extract (field from source)
    field can be century, day, decade, dow, doy, hour, minute, month, second and timezone
    source must be a value expression of type timestamp, time, or interval
date_part('field', source)
    field can be century, day, decade, dow, doy, hour, minute, month, second and timezone

-- How many years are old the employees? Use extract
select employeeid, firstname, lastname, birthdate from employees
select employeeid, firstname, lastname, extract(years from age(birthdate)) as age_in_years from employees

select date_part('year', age('27-04-1978'::date));
select age('27-04-1978'::date);

-- Find the day part of the ship date on all orders. Use date_part
select shippeddate from orders
select date_part('day', shippeddate) as day_part from orders

-- using extract, find how many decades old each employee is
select extract(decade from age(birthdate)) as decades_old from employees

-- using date_part, find how many decades old each employee is
select date_part('decade', age(birthdate)) as decades_old from employees

-- Lecture 119: Converting one data type into another
-- Use Northwind database
-- Syntax:
cast(value as type)
value::type

-- cast hiredate as timestamp
select cast(hiredate as timestamp) from employees
select hiredate::timestamp from employees

-- For each order_details, print the total purchase amount as 'X dollars spent'
select ((unitprice*quantity)-discount)::text || ' dollars spent' from order_details

-- Convert the string '2015-10-03' to a date and 375 to text in one shot
-- Use CAST for the first one and :: syntax for the second
select cast('2015-10-03' as date), 375::text

-- Section 22: Window Functions
-- Lecture 120: Basic Window Function Example
-- Documentation: https://www.postgresqltutorial.com/postgresql-window-function/
    -- use practice database which has products & product_groups tables

-- What is a window?
-- A window is a set of rows returned by group by/partition by clause

-- Similar to an aggregate function, a window function operates on a set of rows.
-- However, it does not reduce the number of rows returned by the query.

-- The term window describes the set of rows on which the window function operates.
-- A window function returns values from the rows in a window.

-- What is a window function?
-- A function that operates on the window X and returns a value per row in X.
-- In other words, a window function returns values from the rows in X in a window Y.
-- (i.e. it does not reduce the number of rows in the window)
-- Note that aggregate functions operate on a window as well, but they produce a single row per window
-- (i.e. aggregate functions reduce the number of rows in the window to one row)

-- When to use Window Functions? Use Case Example:
-- Referring to the documentation, considering the products & product_groups tables join:
select  group_name,
        product_name,
        price,
	    avg(price) over (           --> avg() as window function over group_name
	   		partition by group_name
	    )
from products inner join product_groups using(group_id)
    -- if we want to print the price & avg(price) side by side for each product row
    -- then we need a window function, because per row in a window (i.e. per row in partition by group_name)
    -- the window function (i.e. avg(price)) will be calculated and placed into that row
    -- In this syntax, the PARTITION BY distributes the rows of the result set into groups/windows and
    -- the AVG() function is applied to each group to return the average price for each.

-- Lets find out product unitprices in a category
-- along with the average unitprice for each category
-- ordered by categoryname and unitprice in desc order
select
	categoryname,
	productname,
	unitprice,
	avg(unitprice) over (
		partition by categories.categoryid
	)  as avg_unitprice_for_category
from categories
inner join products using(categoryid)
order by categoryname desc, unitprice desc;

-- We are looking for orders of the product 'Alice Mutton'.
-- For this product, list all its order details' quantities
-- compared to the average order quantity
-- order by quantity in desc order
select productname, quantity,
	   avg(quantity) over(
	   		partition by productid
	   )
from products inner join order_details using(productid)
where productname = 'Alice Mutton'
order by quantity desc;
    -- OR:
    select
        productname,
        quantity,
        avg(quantity) over (
    ) as avg_order_quantity
    from products inner join order_details using(productid)
    where productname = 'Alice Mutton'
    order by quantity desc;

-- Lecture 121: Using Window functions Within Subqueries
-- Nesting Queries Gives You Great Power
-- Imagine that in Northwind company, we consider an order a fraud
-- if an order's total amount
-- is 5 times greater than the customers's average total order amount
-- Get a list of only fraud orders with companyname, orderid, orderamount and average
-- order amount for the customer
    --- Teachers incorrect solution:
    SELECT companyname, orderid, amount , average_order FROM
        ( SELECT companyname, orderid, amount ,AVG(amount) OVER (PARTITION BY companyname) AS average_order
        FROM
        (SELECT companyname,orders.orderid,SUM(unitprice*quantity) AS amount
        FROM customers
        JOIN orders ON orders.customerid=customers.customerid
        JOIN order_details ON orders.orderid=order_details.orderid
        GROUP BY companyname,orders.orderid) as order_amounts) as order_averages
        WHERE amount > 5 * average_order
        ORDER BY companyname
    -- A correct & simpler solution may be:
    	with step_one as (
            select
                customerid,
                avg((od.unitprice * od.quantity) - od.discount) as avg_total_order_amount
            from customers
            inner join orders using(customerid)
            inner join order_details as od using(orderid)
            group by customers.customerid
        ), step_two as (
            select
                companyname,
                orders.orderid,
                ((od.unitprice * od.quantity)-od.discount) as orderamount,
                avg_total_order_amount
            from customers
            inner join orders using(customerid)
            inner join order_details as od using(orderid)
            inner join step_one using(customerid)
        )
        select * from step_two
        where orderamount >= 5*avg_total_order_amount;
    -- Another correct solution utilizing a window function:
        with step_one as (
            select
                companyname, orders.orderid,
                ((unitprice*quantity)-discount) as orderamount,
                avg((unitprice*quantity)-discount) over (
                    partition by customers.customerid
                ) as avg_total_order_amount
            from customers
            inner join orders using(customerid)
            inner join order_details using(orderid)
        )
        select * from step_one
        where orderamount >= 5*avg_total_order_amount
        order by companyname asc;


-- Task 1:
-- Wrong task definition: Find any suppliers that had 3 times the normal quantity of orders over all their products
-- vs. the average order per month
-- Corrected task 1 definition:
-- Find suppliers that meets the following criteria:
-- Total order quantity for a particular month of a year for a particular supplier
-- must be three times more than the average total order quantity (company average) for a particular supplier (over all periods)
-- My question in Udemy about it: https://www.udemy.com/course/postgresql-from-zero-to-hero/learn/lecture/14284344#questions/13382268
        SELECT
                companyname,order_month,order_year,total_order_quantity,company_average
        FROM (
                SELECT
                    companyname, total_order_quantity, order_month, order_year,
                    AVG(total_order_quantity) OVER (PARTITION BY companyname) as company_average
                FROM (
                        SELECT companyname,SUM(quantity) as total_order_quantity,
                            date_part('month',orderdate) as order_month,
                            date_part('year',orderdate) as order_year
                        FROM order_details INNER JOIN products USING(productid)
                                        INNER JOIN suppliers USING(supplierid)
                                        INNER JOIN orders USING(orderid)
                        GROUP BY companyname,order_month,order_year
                )  as order_by_month
        ) as final_subquery
        WHERE total_order_quantity > 3 * company_average
		order by companyname asc, order_year asc, order_month asc;
            -- Observation: when you have a select statement being part of a more complex query,
            -- ask yourself, do you want to use the select statement as a subquery or CTE in that more complex query?
        -- Task 1 (Teacher's task):
        -- Corrected task definition:
        -- Find all suppliers that meets the following criteria:
        -- Total order quantity for a particular month of a year for a particular supplier
        -- must be three times more than the average total order quantity (supplier average)
        -- over all periods
        select
            distinct companyname
        from
        ( select
            supplierid,
            companyname,
            order_month,
            order_year,
            total_order_quantity,
            avg(total_order_quantity) over (
                partition by supplierid
            ) as avg_total_order_quantity
        from (
            select
                suppliers.supplierid,
                companyname,
                date_part('month', orderdate) as order_month,
                date_part('year', orderdate) as order_year,
                sum(quantity) as total_order_quantity
            from suppliers
            inner join products using(supplierid)
            inner join order_details using(productid)
            inner join orders using(orderid)
            group by suppliers.supplierid, date_part('month', orderdate), date_part('year', orderdate)
            order by suppliers.supplierid asc, order_month asc, order_year asc
        ) as step_one
        ) as step_two
        where total_order_quantity > 3 * avg_total_order_quantity
        order by companyname asc;


-- Task 2 (extra, not in the course):
-- Find any suppliers that had the total order
-- quantity over all their products (for all periods)
-- versus 3 times the average order quantity for an individual supplier for a particular month & year
-- order by companyname in ascending order
with step_one as (
	select
		suppliers.supplierid,
		companyname,
		date_part('month', orderdate) as order_month,
		date_part('year', orderdate) as order_year,
		avg(quantity) as avg_order_quantity
	from suppliers
	inner join products using(supplierid)
	inner join order_details using(productid)
	inner join orders using(orderid)
	group by suppliers.supplierid, date_part('month', orderdate), date_part('year', orderdate)
	order by suppliers.supplierid asc, date_part('month', orderdate) asc, date_part('year', orderdate) asc
), step_two as (
	select
		suppliers.supplierid,
		companyname,
		sum(quantity) as total_quantity_of_orders
	from suppliers
	inner join products using(supplierid)
	inner join order_details using(productid)
	group by suppliers.supplierid
), step_three as (
	select	s1.companyname,
			s1.order_month,
			s1.order_year,
			s1.avg_order_quantity,
			s2.total_quantity_of_orders
	from step_one as s1 inner join step_two as s2 using(supplierid)
)
select distinct companyname from step_three
where total_quantity_of_orders > 3 * avg_order_quantity
order by companyname asc;


-- Find any suppliers that fits per year per month, had the total
-- quantity of orders over all their products
-- versus three times the average order quantity
-- order by supplierid, year & month in ascending fashion
select supplierid, companyname, orderyear, ordermonth, totalquantity, avgtotalquantity
from
(select
	supplierid, companyname, orderyear, ordermonth, totalquantity,
	avg(totalquantity) over (
		partition by supplierid
	) as avgtotalquantity
from
( select
	suppliers.supplierid,
	companyname,
	date_part('year', orderdate) as orderyear,
	date_part('month', orderdate) as ordermonth,
	sum(quantity) as totalquantity
from suppliers
inner join products using(supplierid)
inner join order_details using(productid)
inner join orders using(orderid)
group by suppliers.supplierid, date_part('year', orderdate), date_part('month', orderdate)
order by suppliers.supplierid asc, orderyear asc, ordermonth asc
) as part_one
) as part_two
where totalquantity > 3 * avgtotalquantity;

-- Lecture 123: Using Rank() to Find First N / Last N Records in Join
-- Documentation: https://www.postgresqltutorial.com/postgresql-rank-function/
-- Use practice_db
-- Referring to the documentation:
-- Example Use Cases: The RANK() function can be useful for creating top-N and bottom-N reports.
   -- Top 2 most expensive totals for each order
   -- Top 2 most expensive products for each product group
   --
-- Syntax:
select  <column1>, <column2>, ...
        RANK() OVER (
            [PARTITION BY partition_expression, ... ]   --> optional, if not given the result_set is used as the partition
            ORDER BY sort_expression [ASC | DESC], ...
        )
From result_set

-- Example from the documentation:
SELECT
	product_id,
	product_name,
	group_name,
	price,
	RANK () OVER (
		PARTITION BY p.group_id
		ORDER BY price DESC
	) price_rank
FROM
	products as p INNER JOIN product_groups using(group_id);
    -- My interpretation of the documentation:
    -- The result set is the table returned by the enclosing from statement for rank()
        -- i.e. products as p INNER JOIN product_groups using(group_id)
    -- First, the PARTITION BY clause distributes rows of the result set into partitions
    -- Second, order by clause (i.e. ORDER BY price DESC --> based on descending price)
    -- is applied to each row WITHIN a partition.
        -- for each p.group_id partition, order the rows based on price in descending order
    -- Third, the RANK() function assigns a rank to every row within a partition (p.group_id)
    -- based on ORDER BY clause (i.e. ORDER BY price DESC --> based on descending price):
        -- (*) For each partition, the rank of the first row is 1.
        --     In addition, rows with the same values will get the same rank.
        --     The RANK() function adds the number of tied rows to the rank to
        --     calculate the rank of the next row, so the ranks may not be sequential.

    -- Use practice_db
    -- Based on this example, if we want to get:
    -- Top 2 most expensive products for each product group
        -- The definition of 2 most expensive products is unclear.
        -- Referring to the teacher's solution below, the 2 most expensive products
        -- are the ones with ranks 1 or 2.
    with step_one as(
        SELECT
	        product_id,
	        product_name,
            group_id,
	        group_name,
	        price,
	        RANK () OVER (
		        PARTITION BY pg.group_id
		        ORDER BY price DESC
	        ) price_rank
        FROM products as p INNER JOIN product_groups as pg using(group_id)
    )
    select * from step_one
    where price_rank <= 2


-- Extra Task 2: If we are interested
-- in the first two minimum ranked products in each partition
    -- For each partition, there can be multiple products in each rank.
    -- If many new entries are added to products table with the same price, static value 2 wont work,
    --> Because RANK() will give the rank of the 2.nd row a dynamic value (i.e. not 2) due to (*)
        -- Solution:
            with step_one as(
                SELECT
                    product_id,
                    product_name,
                    p.group_id,
                    group_name,
                    price,
                    RANK () OVER (
                        PARTITION BY pg.group_id
                        ORDER BY price DESC
                    ) price_rank
                FROM products as p INNER JOIN product_groups as pg using(group_id)
            ),
            step_two as(
                select
                        distinct group_id, 1 as price_rank
                from step_one
            ),
            step_three as(
                select group_id, min(price_rank) as price_rank from step_one
                where price_rank != 1
                group by group_id
            ),
            step_four as(
                select * from step_two
                union
                select * from step_three
            )
            select s1.product_id,
				   s1.product_name,
				   s1.group_id,
				   s1.group_name,
				   s1.price,
				   s1.price_rank
			from step_one as s1 inner join step_four as s4
			on ((s1.group_id = s4.group_id) and (s1.price_rank = s4.price_rank))
			order by group_name asc, price desc;

-- Back to the udemy course, lecture 122:
-- Use Northwind database
-- List the highest 2 ranks for order_details_total_price for each order:
with step_one as (
	select
		o.orderid,
		od.productid,
		((unitprice * quantity) - discount) as total_price,
		rank() over (
			partition by o.orderid
			order by ((unitprice * quantity) - discount) desc
		) as rank_by_total_price
	from orders as o
	inner join order_details as od using(orderid)
	order by o.orderid asc, total_price desc
), step_two as (
	select
		orderid,
		rank_by_total_price
	from step_one
	where rank_by_total_price = 1
), step_three as (
	select
		orderid,
		min(rank_by_total_price)
	from step_one
	where rank_by_total_price != 1
	group by orderid
), step_four as (
	select * from step_two
	union all
	select * from step_three
)
select
	s1.orderid,
	s1.productid,
	s1.total_price,
	s1.rank_by_total_price
from step_one as s1
inner join step_four as s4
on ((s1.orderid = s4.orderid) and (s1.rank_by_total_price = s4.rank_by_total_price))
order by orderid asc, total_price desc
      -- This is the teacher's solution:
      SELECT * FROM
            (SELECT orders.orderid, productid, unitprice, quantity,
 	                rank() OVER (PARTITION BY order_details.orderid ORDER BY (quantity*unitprice) DESC) AS rank_amount
            FROM orders
            NATURAL JOIN order_details) as ranked
      WHERE rank_amount <=2;
        -- I think, teacher's solution & task description is wrong:
        -- Question regarding this solution: https://www.udemy.com/course/postgresql-from-zero-to-hero/learn/lecture/14284344#questions/13412742


-- Find the 3 least expensive products from each supplier.
-- Return supplier name, product name, and price
with step_one as (
	select s.supplierid, companyname, productid, productname, unitprice,
		   rank() over(
		   		partition by s.supplierid
			    order by unitprice asc
		   ) as rank_by_unitprice
	from suppliers as s inner join products using(supplierid)
),
step_two as (
	select *
	from step_one
	where rank_by_unitprice = 1
),
step_three as (
	select supplierid, min(rank_by_unitprice) as min_rank_by_unitprice
	from step_one
	where rank_by_unitprice <> 1
	group by supplierid
),
step_four as (
	select
		*
	from step_one
	where rank_by_unitprice <> 1 and
		  rank_by_unitprice in (select min_rank_by_unitprice from step_three where step_one.supplierid = step_three.supplierid)
),
step_five as (
	select * from step_one
	except
	select * from step_two
	except
	select * from step_four
),
step_six as (
	select supplierid, min(rank_by_unitprice) as min_rank_by_unitprice
	from step_five
	group by supplierid
),
step_seven as (
	select *
	from step_one
	where rank_by_unitprice in (select min_rank_by_unitprice from step_six where step_one.supplierid = step_six.supplierid)
),
final_step as (
	select * from step_two
	union
	select * from step_four
	union
	select * from step_seven
)
select companyname, productname, unitprice from final_step
order by supplierid asc, unitprice asc;
    -- Teacher's solution (IMO, it is incorrect)
    SELECT companyname,productname,unitprice FROM
            (SELECT companyname,productname,unitprice,
            rank() OVER (PARTITION BY products.supplierid ORDER BY unitprice ASC) AS price_rank
    FROM suppliers NATURAL JOIN products) as ranked_products
    WHERE price_rank <=3;
        -- Made a Question about the issue: https://www.udemy.com/course/postgresql-from-zero-to-hero/learn/lecture/14284344#questions/13422826
    -- May be a better task description:
    -- Find the least expensive products by rank level 1,2,3 from each supplier.
    -- Return supplier name, product name, and price
    with least_expensive_products as (
        select
            companyname,
            productname,
            unitprice,
            rank() over (
                partition by suppliers.supplierid
                order by unitprice asc
            ) as rank_by_unitprice
        from suppliers
        inner join products using(supplierid)
        order by suppliers.supplierid asc, unitprice asc
    )
    select * from least_expensive_products
    where rank_by_unitprice <= 3;

-- Section 23 : Composite Types
-- What are composite types?
-- A composite type is a named list of field names and their data types:
-- Syntax:
create type composite_name as (
    field1  datatype,
    field2  datatype,
    ...
)
-- Important: no constraints, just field names & data types
-- A composite type can be used as column in a table
-- Also a composite type can be used in functions and procedures (???)

-- Use practice_db
-- Let's create an address composite type with:
-- street_address, street_address2, city, state_region, country and postalcode
create type address as (
	street_address 	varchar(50),
	street_address2 varchar(50),
	city			varchar(50),
	state_region	varchar(50),
	country			varchar(50),
	postalcode		varchar(15)
);
    -- under practice_db > Schemas > Types > address is created
-- create a table for friends and use the composite type address
create table friends (
    firstname varchar(100),
    lastname varchar(100),
    address address
)

-- How to remove a composite?
drop type if exists composite_name  --> if the composite_name is not used in any table yet
drop type if exists composite_name cascade --> if the composite_name is used in any table already
    -- NOTE! it will remove all the composite colums from the relevant tables
    drop type if exists address cascade;
    drop table if exists friends

-- task: create a composite called full_name that includes firstname, middlename and lastname
--       recreate the address composite type
--       add both to a new friends table
create type full_name as (
    firstname  varchar(100),
    middlename varchar(100),
    lastname varchar(100)
);
create type address as (
	street_address 	varchar(50),
	street_address2 varchar(50),
	city			varchar(50),
	state_region	varchar(50),
	country			varchar(50),
	postalcode		varchar(15)
);
create table friends (
    full_name full_name,
    address address
)

-- task: drop both composite types full_name and address, and drop table friends
drop type if exists full_name cascade;
drop type if exists address cascade;
drop table if exists friends;

-- Lecture 124: Using Composite Types in Queries
-- Use practice_db and create the following composite types and friends table
CREATE TYPE address AS (
	street_address 	varchar(50),
	street_address2 varchar(50),
	city			varchar(50),
	state_region	varchar(50),
	country			varchar(50),
	postalcode		varchar(15)
);

CREATE TYPE full_name AS (
	first_name varchar(50),
	middle_name varchar(50),
	last_name varchar(50)
);

CREATE TYPE dates_to_remember AS (
  birthdate date,
  age       integer,
  anniversary date
);

CREATE TABLE friends (
	full_name full_name,
	address	address,
  	specialdates dates_to_remember
);

-- How to insert data into composite types / How to construct composites in a table?
-- Syntax for composite type:
create type composite_name as (
    field1  datatype,
    field2  datatype,
    ...
)
-- Syntax for inserting data as composite:
insert into table_name(composite_name)
values(row(field1_value, field2_value, field3_value, ..))
    -- Example:
    insert into friends (full_name, address, specialdates)
    values(
        ROW('Boyd','M','Gregory'),
        ROW('7777','','Boise','Idaho','USA','99999'),
        ROW('1969-02-01',49,'2001-07-15')
    )

select * from friends
-- Accessing columns in a composite
-- Syntax:
select (composite_name).field1 from table_name
-- Pull back the city and birthdate from friends
select (address).city, (specialdates).birthdate from friends

-- Select all friends whose first name is Boyd
select full_name from friends where (full_name).first_name = 'Boyd'

-- Select state, middle_name and age of everyone whose last_name is Gregory
select (address).state_region, (full_name).middle_name, (specialdates).age
from friends where (full_name).last_name = 'Gregory'

-- Section 24: SQL Functions& Procedures
-- use Northwind database in this section
-- Lecture 126: Write your first function
-- Four kinds of functions:
-- 1. Functions written in SQL (what we are doing in this section)
-- 2. Functions written in PL/SQL (written in another section)
-- 3 & 4 irrelevant
-- Syntax for (1):
create or replace function function_name() returns void AS $$
  ...SQL statement...
$$ Language SQL

-- Write a function called fix_homepage that updates all suppliers
-- with null in homepage field to 'N/A'
create or replace function fix_homepage() returns void as $$
    update suppliers
    set homepage = 'N/A'
    where homepage is null
$$ Language SQL
select fix_homepage()

-- Create a function called set_default_photo to update any missing photopath
-- in employees table
-- to a default 'http://accweb/emmployees/default.bmp' and run the function
select photopath from employees;
create or replace function set_default_photo() returns void as $$
	update employees
	set photopath = 'http://accweb/emmployees/default.bmp'
	where photopath is null
$$ Language SQL;

select set_default_photo();

-- Lecture 126: Write a Function that returns a single value
-- Syntax:
create or replace function function_name() returns datatype AS $$
  ...Select statement that returns the datatype...
$$ Language SQL

-- Use Northwind database
-- Find the maximum price of any product
create or replace function max_price_of_any_product() returns real as $$
    select max(unitprice) from products
$$ Language SQL;
select max_price_of_any_product();

-- Write a function biggest_order() that returns the largest order in terms of total money spent
-- Q: return the whole order from the function
drop function if exists biggest_order;
create or replace function biggest_order() returns setof orders as $$
	with largest_order as (
		select
			orderid,
			sum((unitprice*quantity)-discount) as total_spent_per_order
		from order_details
		group by orderid
		order by total_spent_per_order desc limit 1
	)
	select
		orders.*
	from orders
	inner join largest_order using(orderid)

$$ Language SQL;
select * from biggest_order();

-- Write a function biggest_order() that returns the largest order in terms of total money spent
-- Solution 1: Using window functions
create or replace function biggest_order() returns setof orders as $$
	with step_one as(
		select
			  orderid, sum((unitprice*quantity)-discount) as total_spent_per_order
		from order_details
		group by orderid
	),
    step_two as(
		select
			  orderid, total_spent_per_order,
			  max(total_spent_per_order) over () as max_total_spent_per_order
		from step_one
	)
	select * from orders where orderid in 
	(
			select orderid
			from step_two
			where total_spent_per_order = max_total_spent_per_order
	)
$$ Language SQL;
select * from biggest_order();


-- Write a function biggest_order() that returns
-- the largest order in terms of total money spent
-- Q: return the whole order + the total_spent from the function
create type orders_extended as (
	orderid smallint,
    customerid bpchar,
    employeeid smallint,
    orderdate date,
    requireddate date,
    shippeddate date,
    shipvia smallint,
    freight real,
    shipname character varying(40),
    shipaddress character varying(60),
    shipcity character varying(15),
    shipregion character varying(15),
    shippostalcode character varying(10),
    shipcountry character varying(15),
	total_spent real
);

drop function if exists biggest_order;
create or replace function biggest_order() returns orders_extended  as $$
	with largest_order as (
		select
			orderid,
			sum((unitprice*quantity)-discount) as total_spent
		from order_details
		group by orderid
		order by total_spent desc limit 1
	)
	select
		(orders.*, total_spent)::orders_extended
	from orders
	inner join largest_order using(orderid)

$$ Language SQL;
select * from biggest_order();

-- Lecture 128: Functions with Parameters
-- Syntax:
create or replace function function_name(param1 data_type, param2 data_type, ...) returns data_type as $$
    SQL statment that returns data_type
$$ Language SQL
    -- 2 ways to reference parameters:
        -- By position: $1, $2 (older Postgres SQL only supports this)
        -- By name: param1, param2
            -- danger: If you name the parameter the same as column name the function gets confused
                -- customerid = customerid --> customerid = $1

-- Find the largest order amount given a specific customer(id)
reate or replace function largest_order_amount(customerid nchar(5)) returns real as $$
	with step_one as (
		select
			sum((unitprice * quantity) - discount) as orderamount
		from orders
		inner join order_details using(orderid)
		where orders.customerid = $1
		group by orders.orderid
	)
	select max(orderamount) from step_one
$$ Language SQL

select * from customers  --> pick a customerid from there (e.g. ANATR)

select largest_order_amount('ANATR')

-- Find the most ordered productname of a particular customer by
-- the number of items ordered. Call the function most_ordered_product
-- Solution 1:
create or replace function most_ordered_product(customerid nchar(5)) returns varchar(40) as $$
    with step_one as (
        select
            productid, sum(quantity) as num_of_items_ordered_per_product
        from orders inner join order_details using(orderid)
        where customerid = $1
        group by productid
    ),
    step_two as(
        select
            productid, num_of_items_ordered_per_product,
            max(num_of_items_ordered_per_product) over ( ) as max_num_of_items_ordered
        from step_one
    ),
    step_three as(
        select
            productid
        from step_two
        where num_of_items_ordered_per_product = max_num_of_items_ordered
        limit 1
    )
    select productname from products
    where productid = (select productid from step_three)
$$ Language SQL
select most_ordered_product('ANATR')
-- Solution 2:
create or replace function most_ordered_product(customerid nchar(5)) returns varchar(40) as $$
	with step_one as(
		select productid, sum(quantity) as number_of_items_ordered
		from orders inner join order_details using(orderid)
		where customerid = $1
		group by productid
		order by number_of_items_ordered desc
		limit 1
	)
	select productname from products
	where productid in (select productid from step_one)
$$ Language SQL
select most_ordered_product('ANATR')
    -- Teachers solution:
    CREATE OR REPLACE FUNCTION most_ordered_product(customerid bpchar) RETURNS varchar(40) AS $$
	    SELECT productname
	    FROM products
	    WHERE productid IN  (
            SELECT productid FROM (
                SELECT SUM(quantity) as total_ordered, productid
	            FROM order_details
	            INNER JOIN orders USING(orderid)
	            WHERE customerid = $1
	            GROUP BY productid
	            ORDER BY total_ordered DESC
	            LIMIT 1
            ) as ordered_products
        );
    $$ LANGUAGE SQL;

-- Lecture 129: Functions that have composite parameters
-- Documentation: https://www.postgresql.org/docs/11/xfunc-sql.html#XFUNC-SQL-COMPOSITE-FUNCTIONS
-- Note: a table is treated as a composite type in postgresql, so
-- you can pass a table_name as a composite parameter
-- to a function. The table_name is treated as a composite type that
-- is a single ROW with all the column names in order

-- Build a function that takes a product and price increase percentage as int
-- and returns the new price
create or replace function increase_unitprice(products, percentage int) returns real as $$
	select ($1).unitprice * (1.0::real + (percentage::real/100));
$$ Language SQL;
    -- a single row from products table as a composite as an argument
    -- given a row/composite in products table, new_price() operates on a single field
    -- returning a value forming a column for new price
select * from products
    --> returns all the data from products table, same as
    --> select * from products
select productid, productname, increase_unitprice(products.*, 20)
from products
where productid = 2;

-- create a function full_name() that takes employees and return
-- title, firstname and lastname concatenated together.
-- Then use this in a select statement
create or replace function full_name(employees) returns varchar(255) as $$
    select $1.title || ' ' || $1.firstname || ' ' || $1.lastname
$$ Language SQL
select employeeid, full_name(employees.*) from employees
    -- employees.*  returns all the columns
    -- full_name() concatanes title, firstname and lastname columns returning a new column

-- Lecture 129: Functions that return a composite
-- Documentation: https://www.postgresql.org/docs/11/xfunc-sql.html#XFUNC-SQL-COMPOSITE-FUNCTIONS
-- Used to return a single row of a table
-- order of the fields must be the same as the table
-- each type must match the corresponding composite column

-- Extra task: create a function full_name() that takes employees and returns
-- a composite consisting of title, firstname and lastname.
-- Then use the composite in a select statement
    create type outcome as (
        title varchar(30),
        firstname varchar(10),
        lastname varchar(20)
    );

    create or replace function get_full_name(employees) returns outcome as $$
        select (($1).title, ($1).firstname, ($1).lastname)::outcome;
    $$ Language SQL;

    select * from employees;

    select get_full_name(employees.*)
    from employees
    where employeeid = 4;

    select (get_full_name(employees.*)).*
    from employees
    where employeeid = 4;

-- return the most recent hire
create or replace function newest_hire() returns employees as $$
    select * from employees
    order by hiredate desc limit 1
$$ Language SQL

select (newest_hire()).lastname
    -- note that newest_hire() returns a composite called employees
    -- which is a row from employees table
    -- Postgres automatically creates a composite with the
    -- same name as a table. The composite corresponds to a row in that
    -- table

-- create a function called highest_inventory() that
-- returns the product that has the most amount of money tied up
-- in inventory (unitprice * unitsinstock)
create or replace function highest_inventory() returns products as $$
    with step_one as (
        select productid, (unitprice*unitsinstock) as inventory_total
        from products
		order by inventory_total desc limit 1
    )
    select * from products
    where productid = (select productid from step_one);
$$ Language SQL;

select highest_inventory()
    -- Teachers solution (Better!)
    CREATE OR REPLACE FUNCTION highest_inventory() RETURNS products AS $$
	    SELECT * FROM products
	    ORDER BY (unitprice*unitsinstock) DESC
	    LIMIT 1;
    $$ LANGUAGE SQL;

SELECT (highest_inventory()).*;
SELECT productname(highest_inventory());

-- Lecture 131: Functions with Output Parameters
-- Documentation: https://www.postgresql.org/docs/11/xfunc-sql.html#XFUNC-OUTPUT-PARAMETERS
-- Using IN, OUT, INOUT (both input and output)
-- Syntax:
create or replace function fn_name (in x int, in y int, out sum int, out product int) as $$
    .. Select statement returning sum & product
$$ Language SQL

--- Task: Create a function to both add and multiply two integers
create or replace function add_n_product (in x int, in y int, out sum int, out product int) as $$
    select (x+y), (x*y)
$$ Language SQL
select add_n_product(5,20)--> returns a composite (25, 100)
    -- other way of doing:
    create type sum_n_product as (
        sum int,
        product int
    )
    create or replace function add_n_product(x int, y int) returns sum_n_product as $$
        select x+y, x*y
    $$ Language SQL
select * from add_n_product(5,20)

-- Task: Create a function that takes a single number and returns the
-- square and the cumbe of that number using OUT parameters.
-- Call it square_n_cube
create or replace function square_n_cube(in x int, out square bigint, out cube bigint) as $$
    select x*x, x*x*x
$$ Language SQL
select (square_n_cube(3)).*

-- Lecture 131: Functions with default values
-- Documentation: https://www.postgresql.org/docs/11/xfunc-sql.html#XFUNC-SQL-PARAMETER-DEFAULTS
-- Functions with arguments having default values
-- Syntax:
create or replace function function_name(a int, b int default 2, c int default 7)
-- must have defaults after the first default

-- redo new_price() function with a default of %5 price increase
-- orig:
create or replace function new_price(products, price_increase_percentage int)
returns double precision as $$
    select  $1.unitprice * price_increase_percentage / 100
$$ Language SQL
    -- solution:
    create or replace function new_price(products, price_increase_percentage int default 105)
    returns double precision as $$
        select $1.unitprice * price_increase_percentage /100
    $$ Language SQL
    select productid, productname, unitprice, new_price(products.*) from products
    -- A bit more generic way:
    create or replace function new_price(in p products, in percentage int, out increased_unit_price real) as $$
        select (p).unitprice * (1.0::real + (percentage::real/100));
    $$ Language SQL;

    select * from products;

    select
        new_price(products.*, 5)
    from products
    where productid in (2, 3, 4);

-- Redo square_n_cube using OUT parameters. Give the input a default value 10
-- Run the function without any input
-- orig:
create or replace function square_n_cube(in x int, out square bigint, out cube bigint) as $$
    select x*x, x*x*x
$$ Language SQL
select (square_n_cube(3)).*
    -- solution:
    create or replace function square_n_cube(in x int default 10, out square bigint, out cube bigint) as $$
    select x*x, x*x*x
    $$ Language SQL
    select (square_n_cube()).*

-- Lecture 133: Using Functions as table sources
-- Documentation: https://www.postgresql.org/docs/11/xfunc-sql.html#XFUNC-SQL-TABLE-FUNCTIONS
-- Given that the function returns a composite, you can use the return value of the
-- function as table by using 'FROM function_name()' clause

-- Select firstname, lastname and hiredate from newest_hire()
select firstname, lastname, hiredate from most_recent_hire();

-- Use highest_inventory() to pull back productname, supplier companyname
select productname, companyname
from highest_inventory() inner join suppliers using(supplierid)

-- Lecture 133: Functions that return more than one row (i.e. a table)
-- Documentation: https://www.postgresql.org/docs/11/xfunc-sql.html#XFUNC-SQL-FUNCTIONS-RETURNING-SET
-- Syntax:
create or replace function function_name() returns setof datatype as $$
-- or or multiple parameters
create or replace function function_name(x int, out sum in, out product int)
returns setof datatype as $$
    -- note that datatype can be primitive type (e.g. int or bigint)
    -- or a composite

-- Lets return all products that have total sales greater than some input value.
-- Function name should be sold_more_than
create or replace function sold_more_than(threshold real)
returns setof products as $$
    with step_one as (
        select
            productid, sum((od.unitprice*od.quantity)-od.discount) as total_sales
        from products inner join order_details as od using(productid)
        group by productid
    ),
    step_two as (
        select productid from step_one
        where total_sales > threshold
    )
    select * from products
    where productid in (select productid from step_two)
$$ Language SQL
    --  OR:
    create or replace function sold_more_than(in min_total_sales real) returns setof products as $$
        with step_one as (
            select
                products.productid,
                sum((od.unitprice * od.quantity)-od.discount) as total_sales
            from products
            inner join order_details as od using(productid)
            group by products.productid
        )
        select
            products.*
        from products
        inner join step_one using(productid)
        where total_sales >= min_total_sales;
    $$ Language SQL;


SELECT * FROM sold_more_than(25000);
    -- Teachers solution:
    CREATE OR REPLACE FUNCTION sold_more_than(threshold real)
    RETURNS SETOF products AS $$
        SELECT * FROM products
        WHERE productid IN (
            SELECT productid FROM (
                SELECT  SUM(quantity*unitprice), productid
                FROM order_details
                GROUP BY productid
                HAVING SUM(quantity*unitprice) > threshold
            ) as qualified_products
        )
    $$ LANGUAGE SQL;

    SELECT productname, productid, supplierid
    FROM sold_more_than(25000);

-- Task: Create a function called next_birthday()
-- that return all employees next_birthday, firstname, lastname and hiredate
-- Solution: (more compact)
create type employee as (
	next_birthday date,
	firstname varchar(10),
	lastname varchar(20),
	hiredate date
);

drop function next_birthday();

create or replace function next_birthday() returns setof employee as $$
	with step_one as (
		select employeeid, (birthdate + interval '1 year') as upcoming_birthday
		from employees
	)
	select upcoming_birthday, firstname, lastname, hiredate
	from employees
	inner join step_one using(employeeid);
$$ Language SQL;

select * from next_birthday();
        -- Teachers solution: (produces the same result)
        -- Observation: next_birthday = birthdate + (current age + 1) * years
        create or replace function next_birthday()
        returns table (nextbirthdate date, birthdate date, firstname varchar(20), lastname varchar(20), hiredate date) as $$
            select (birthdate + interval '1 YEAR' * (extract(year from age(birthdate))+1))::date,
                   birthdate, firstname, lastname, hiredate
            from employees
        $$ Language SQL
		select (next_birthday()).*
            -- OBSERVATION: When you want to return a set of composites / a table, then use returns table construct

-- Task: Create a function that returns all suppliers that have products
-- that need to be ordered (units on hand plus units ordered is less than reorder level)
-- Use setof syntax. Call function: suppliers_to_reorder_from()
create or replace function suppliers_to_reorder_from() returns setof suppliers as $$
    with step_one as (
        select distinct(supplierid)
        from products
        where (unitsinstock + unitsonorder) < reorderlevel
    )
    select * from suppliers
    where supplierid in (select supplierid from step_one)
$$ Language SQL

select * from suppliers_to_reorder_from()
  -- Teachers solution:
    CREATE OR REPLACE FUNCTION suppliers_to_reorder_from()
            RETURNS SETOF suppliers AS $$
            SELECT * FROM suppliers
            WHERE supplierid IN (
                SELECT supplierid FROM products
            WHERE unitsinstock + unitsonorder < reorderlevel
    )
    $$ LANGUAGE SQL;

    SELECT * FROM suppliers_to_reorder_from()
        -- A bit better solution, which also tells what product to order from the suppliers
        create type products_to_reorder as (
        supplierid int,
        companyname varchar(40),
        productid int,
        productname varchar(40),
        categoryid int,
        quantityperunit varchar(20),
        unitprice real,
        unitsinstock smallint,
        unitsonorder smallint,
        reoderlevel smallint,
        discontinued int
        );


        create or replace function suppliers_to_reorder_from() returns setof products_to_reorder as $$
            with stepone as (
                select productid from products where ((unitsinstock + unitsonorder) < reorderlevel)
            )
            select
                supplierid,
                companyname,
                productid,
                productname,
                categoryid,
                quantityperunit,
                unitprice,
                unitsinstock,
                unitsonorder,
                reorderlevel,
                discontinued
            from suppliers inner join products using(supplierid)
            where productid in (select productid from stepone);
        $$ Language SQL;

        select * from suppliers_to_reorder_from();


-- Task: Crate a function that return the excess inventory, productid and productname
-- from products based on an input parameter of inventory threshold percent.
-- excess inventory is calculated as:
-- ceil((unitsinstock + unitsonorder)-(reoderlevel * inventory_threshold_percent/100))
-- Use returns table syntax
create or replace function get_access_inventory(inventory_threshold_percent int)
returns table (productid int, productname varchar(40), excess_inventory smallint)
as $$
	with step_one as (
		select 	productid, productname,
				ceil((unitsinstock + unitsonorder)-(reorderlevel * inventory_threshold_percent/100)) as excess_inventory
		from products
	)
	select * from step_one where excess_inventory > 0;
$$ Language SQL;

select * from get_access_inventory(1000);


-- Lecture 134: Procedures; Functions that return void
-- Documentation: https://www.postgresql.org/docs/current/sql-createprocedure.html
-- Documentation: https://www.postgresql.org/docs/11/xproc.html
-- Syntax:
create or replace procedure procedure_name(param1 int, param2 real, ...) as $$
    .. Select statement
$$ Language SQL
call procedure_name(3, 5.0)
-- is the same as:
create or replace function(param1 int, param2 real, ...) returns void as $$
  -- Select statement
$$ Language SQL

--Task: create a procedure that adds two numbers
create or replace procedure add_two_numbers(x int, y int) as $$
    select x + y
$$ Language SQL
call add_two_numbers(5, 10)


-- Create a procedure change_supplier_prices that takes
-- supplieid and amount and increases all the unit prices in products table for that supplier
-- run the procedure with supplierid 20 and raise prices by 0.5$
create or replace procedure change_supplier_prices(supplier_id int, increase_by real) as $$
    update products
    set unitprice = (unitprice + increase_by)
    where supplierid = supplier_id
$$ Language SQL
call change_supplier_prices(20, 0.5)

-- SECTION 25: Transactions & Concurrency Control
-- Lecture 136: ACID Transactions
-- Documentation: https://www.geeksforgeeks.org/acid-properties-in-dbms/
-- Consider a bank moving money from one account to another
-- This involves two queries; it substracts an amount from sources's debit sum and it adds the amount into the target's
-- debit sum. The set of these two queries is called a transaction.
-- Transaction is a set of queries that are performed together
-- In order a transaction to be successful all the statements in that transaction should be successfully executed.
-- There are 4 types of properties called ACID, each transaction should adhere to:
    -- Atomicity: All the operations in a transaction work or none of them work. Every transaction is a single unit.
    -- Consistency: All the Transactions change the database state properly
        -- e.g. All constraints must be satisfied
    -- Isolation: Transactions wont interfere with each other
        -- If you are reading a table, an update wont happen in the middle of reading
        -- changing the results. The read will occur either before the update or after the update
        -- but not during the update
    -- Durability: The changes or results wont be lost if there is a system failure
        -- e.g. If database crashes after commit, the effects will still be there
-- IMPORTANT!!!
    -- Every single statement has a transaction around it
    -- Like in the bank example, if you want to bundle more than
    -- one statement, you need to use transaction control statements
    -- which will be covered next


-- Lecture 136 : Simple Transaction Control
-- Documentation: https://www.postgresql.org/docs/11/tutorial-transactions.html
-- Documentation: https://www.postgresql.org/docs/current/sql-begin.html
-- Documentation: https://www.postgresql.org/docs/current/sql-start-transaction.html
-- Documentation: https://www.postgresql.org/docs/current/sql-commit.html
-- Documentation: https://www.postgresql.org/docs/current/sql-end.html
-- Use Northwind database
-- SQL Syntax:
start transaction;
    statement_1;
    statement_2;
    statement_3;
    ...
commit;

-- Postgres Syntax:
begin transaction;
    statement_1;
    statement_2;
    statement_3;
    ...
end transaction;

-- Task: Make a transaction: In products table, Let's update the reorder level by subtracting 5 and
-- find the count of items that need reordering in one transaction
start transaction;
    update products
    set reorderlevel=reorderlevel-5;

    select count(*)
    from products
    where unitsinstock + unitsonorder < reorderlevel;
commit;

-- Task: Create a single transaction to increase the requireddate in orders by
-- one day for december 2017 and decrease it by one day for november 2017
start transaction;
    update orders
    set requireddate = requireddate + interval '1 day'
    where extract(month from requireddate) = 12 and extract(year from requireddate) = 2017;

    update orders
    set requireddate = requireddate - interval '1 day'
    where extract(month from requireddate) = 11 and extract(year from requireddate) = 2017;
commit;
    -- Teachers solution:
    BEGIN TRANSACTION;
            UPDATE orders
            SET requireddate = requireddate + INTERVAL '1 DAY'
            WHERE orderdate BETWEEN '1997-12-01' AND '1997-12-31';

            UPDATE orders
            SET requireddate = requireddate - INTERVAL '1 DAY'
            WHERE orderdate BETWEEN '1997-11-01' AND '1997-11-30';
    END TRANSACTION;

-- Lecture 137: Rollbacks and Savepoints
-- Rollback Documentation: https://www.postgresql.org/docs/current/sql-rollback.html
-- ROLLBACK rolls back the current transaction and causes all the updates made by the transaction to be discarded.
-- Issuing ROLLBACK outside of a transaction block emits a warning and otherwise has no effect.
START TRANSACTION;
    UPDATE orders
    SET orderdate = orderdate + INTERVAL '1 YEAR';
ROLLBACK;

-- Savepoint documentation: https://www.postgresql.org/docs/current/sql-savepoint.html
-- SAVEPOINT establishes a new savepoint within the current transaction
-- A savepoint is a special mark inside a transaction that allows all commands that are executed
-- after it was established to be rolled back, restoring the transaction state to
-- what it was at the time of the savepoint.

-- Task: Start a transaction, insert a new employee, create a savepoint,
-- update hireddate and rollback to savepoint
START TRANSACTION;
    INSERT INTO employees (employeeid,lastname,firstname,title,birthdate,hiredate)
    VALUES (501,'Sue','Jones','Operations Assistant','1999-05-23','2017-06-13');

    SAVEPOINT inserted_employee;

    UPDATE employees
    SET birthdate='2025-07-11';

    ROLLBACK TO inserted_employee;

    UPDATE employees
    SET birthdate='1998-05-23'
    WHERE employeeid=501;
COMMIT;


SELECT * FROM employees WHERE employeeid=501;

-- Lecture 138: SQL Transaction Isolation
-- If you have run some statements in a transaction, can others see the partial results
-- before the transaction finished? (My initial answer is NO, a more correct answer is it depends on the transaction
-- isolation level)
-- Isolation is a property that defines how & when the changes made by one transaction
-- becomes visible to others
-- Documentation: https://www.geeksforgeeks.org/acid-properties-in-dbms/
-- Documentation: https://en.wikipedia.org/wiki/Isolation_(database_systems)
-- Tutorial: https://www.youtube.com/watch?v=4EajrPgJAk0  << This one first @17:45
-- Tutorial: https://www.youtube.com/watch?v=pomxJOFVcQs
-- Documentation: https://www.postgresql.org/docs/current/transaction-iso.html
-- Use practice_db
show transaction isolation level;  --> by default it returns read committed

set transaction isolation level read uncommitted;

create table accounts (
    id serial,
    owner varchar(100) not null,
    balance decimal(65, 2) not null default 0.0,
    currency varchar(10),
    created_at timestamp default now()
);

insert into accounts (owner, balance, currency)
values ('one', 100.0, 'USD'),
       ('two', 100.0, 'USD'),
       ('three', 100.0, 'USD');

-- Section 26: Array Data Type
-- Lecture 140: Declaring Arrays
-- Documentation: https://www.postgresql.org/docs/11/arrays.html#ARRAYS-DECLARATION
-- SQL Standard Syntax:
array_name  contained_data_type  array  --> size of the array is not defined, variable size
array_name  contained_data_type  array[4]  --> Postgres ignores the array size
-- Postgres Syntax For Arrays:
array_name  contained_data_type[]
pay_by_quarted int[]
schedule timestamp[]

-- Use practice_db for this lecture
-- Task: Re-create friends table and add children array
drop table if exists friends;
create table friends (
    fullname full_name,
    address address,
    specialdates dates_to_remember,
    children varchar(50) array
)

-- Task: Create a table called salary_employees with 3 fields;
-- name a varchar of size 100
-- pay_by_quarter which is an integer with one dimension and 4 values
-- schedule which should be text field with 2 dimensions of no particular size
create table salary_employees (
    name varchar(100),
    pay_by_quarter int array[4],
    schedule text[][]
)

-- Lecture 141: Inputting Array Values
-- Documentation: https://www.postgresql.org/docs/11/arrays.html#ARRAYS-INPUT
-- Syntax:
'{ value1, value2, ... }'
    -- if you have text:
    '{ "value1", "value2", ... }'
-- Another Easier Syntax:
array[value1, value2,...]
    -- with text:
    array['value1', 'value2', ...]

-- Task:
-- Lets insert some values into friends
insert into friends(fullname, address, specialdates, children)
VALUES (ROW('Boyd','M','Gregory'),
		ROW('7777','','Boise','Idaho','USA','99999'),
		ROW('1969-02-01',49,'2001-07-15'),
	   '{"Austin","Ana Grace"}');
INSERT INTO friends (fullname, address, specialdates, children)
VALUES (ROW('Scott','X','Levy'),
 		ROW('357 Page Road','','Austin','TX','USA','88888'),
 		ROW('1972-03-01',46,'2002-01-30'),
 		ARRAY['Ben','Jill']);

-- Task:
-- Add a row into salary_employees; Bill who made 20000 each quarter
-- and had 2 different schedule records of "meeting", "training", and
-- "lunch", "sales call"
    INSERT INTO salary_employees (name,pay_by_quarter,schedule)
    VALUES ('Bill',
                    '{20000, 20000, 20000, 20000}',
                    '{{"meeting", "training"},{"lunch", "sales call"}}')
    -- or (better):
    INSERT INTO salary_employees (name,pay_by_quarter,schedule)
    VALUES ('Bill',
            ARRAY[20000, 20000, 20000, 20000],
            ARRAY[['meeting', 'training'],['lunch', 'sales call']])  --> How to enter a two dimensional array values?

-- Lecture 142: Accesing Arrays
-- Documentation: https://www.postgresql.org/docs/11/arrays.html#ARRAYS-ACCESSING
-- Use [] for each dimension; multi dimentions need more than one (e.g. schedule[2][1])
-- INDEXING IN ARRAYS: indexing starts from 1, not from 0
-- Syntax for range of elements
-- To get more than one element in an array, use slice notation [lower-bound:upper-bound]
-- Ex: schedule[1:2][1:1]
    -- can leave of one of the bounds to start from beginning or go to end
    -- ex: schedule[:3][2:]

-- Task: Grab 2nd child of all the friends
create table friends (
    fullname full_name,
    address address,
    specialdates dates_to_remember,
    children varchar(50) array
)
select children[2] from friends

-- Task: grab the 2nd and 3rd elements of pay_by_quarter using range syntax from
-- salary_employees
create table salary_employees (
    name varchar(100),
    pay_by_quarter int array[4],
    schedule text[][]
)
select pay_by_quarter[2:3] from salary_employees

-- How to find dimensions of an array?
array_dims()
-- How to find lenght of a dimension of an array?
array_lenght(field, dimension_index) --> dimension_index starts from 1
    -- get the length of dimension_index.th dimension
    -- get the length of 2.nd dimension

-- Find the dimension & length of schedule in salary_employees
select array_dims(schedule) from salary_employees
select array_lenght(schedule, 1), array_lenght(schedule, 2) from salary_employees

-- Lecture 143: Modifying arrays
-- Documentation: https://www.postgresql.org/docs/11/arrays.html#ARRAYS-MODIFYING
-- Replace the children of Boyd in friends table
    create table friends (
        fullname full_name,
        address address,
        specialdates dates_to_remember,
        children varchar(50) array
    )
    insert into friends(fullname, address, specialdates, children)
    VALUES (ROW('Boyd','M','Gregory'),
            ROW('7777','','Boise','Idaho','USA','99999'),
            ROW('1969-02-01',49,'2001-07-15'),
        '{"Austin","Ana Grace"}');
update friends
set children = ARRAY['Jule','Verne','Tommy']
where  (fullname).first_name = 'Boyd' and
       (fullname).middle_name = 'M' and
       (fullname).last_name = 'Gregory'

-- Task: Replace Boyd's 2nd child
update friends
set children[2] = 'John'
where  (fullname).first_name = 'Boyd' and
       (fullname).middle_name = 'M' and
       (fullname).last_name = 'Gregory';

-- Task: Replace Boyd's 2nd and 3rd child
update friends
set children[2:3] = ARRAY['Silly','Willy']
where  (fullname).first_name = 'Boyd' and
       (fullname).middle_name = 'M' and
       (fullname).last_name = 'Gregory';

-- Task: Replace Bill's pay_by_quarter with values 22000, 25000, 27000 and 22000
    -- salary_employees table:
    create table salary_employees (
        name varchar(100),
        pay_by_quarter int array[4],
        schedule text[][]
    )
    INSERT INTO salary_employees (name,pay_by_quarter,schedule)
    VALUES ('Bill',
            ARRAY[20000, 20000, 20000, 20000],
            ARRAY[['meeting', 'training'],['lunch', 'sales call']])
update salary_employees
set pay_by_quarter = array[22000, 25000, 27000, 22000]
where name='Bill';

-- Task: Update Bill's 4th pay_by_quarter to 26000
update salary_employees
set pay_by_quarter[4]=26000
where name='Bill';

-- Task: Update Bill's 2nd and 3rd quarter to 24000 and 25000
update salary_employees
set pay_by_quarter[2:3] = array[24000, 25000]
where name='Bill';

-- Lecture 144: Searching through arrays
-- Documentation: https://www.postgresql.org/docs/current/arrays.html#ARRAYS-SEARCHING
-- The tedious way: You have to look at each value in the array
    -- e.g. does any of my friends have a child named Willy
select * from friends
where children[1] ='Willy' OR children[2] = 'Willy' OR children[3] = 'Willy'
-- Shorter way:
value = ANY(array_name)
select * from friends
where 'Willy' = any(children);

-- Task: search salary_employees for anyone with 'sales call'
-- in the schedule
    -- salary_employees table:
    create table salary_employees (
        name varchar(100),
        pay_by_quarter int array[4],
        schedule text[][]
    )
    INSERT INTO salary_employees (name,pay_by_quarter,schedule)
    VALUES ('Bill',
            ARRAY[20000, 20000, 20000, 20000],
            ARRAY[['meeting', 'training'],['lunch', 'sales call']])

select * from salary_employees
where 'sales call'= any(schedule[1][:]) or 'sales call'= any(schedule[2][:]);
    -- or
    select * from salary_employees
    where 'sales call'= any(schedule);

-- Lecture 145: Array operators & containment & overlaps
-- Documentation: https://www.postgresql.org/docs/current/functions-array.html
-- =, <>, <, >, <=, >=
-- They go one element at a time an check
-- Lets go through examples one at a time

-- first, lets create an array
select array[1, 2, 3, 4] = array[1, 2, 3, 4]  --> returns true
select array[1, 2, 4, 3] = array[1, 2, 3, 4]  --> returns false

select array[1, 2, 3, 4] > array[1, 2, 3, 4]   --> false
select array[1, 2, 4, 3] > array[1, 2, 3, 4]   --> true
select array[1, 2, 3, 4] > array[1, 2, 4, 2]   --> false

@> contains
<@ is contained by
select array[1, 2, 3, 5] @> array[3, 5]  -- true
select array[1, 2, 3, 5] @> array[3, 5, 7] -- false
select array[1, 2, 3, 5] <@ array[2, 5, 7, 1] -- false
select array[1, 2, 3, 5] <@ array[2, 5, 7, 1, 3] -- true

&& return true if arrays containing elements in common, false otherwise
select array[1, 2, 13, 17] && array[2,5,7,1]  -- true
select array[13,17] && array[3, 5, 10] -- false

-- Task: find anyone with a child named Willy, use overlaps && operator
    create table friends (
        fullname full_name,
        address address,
        specialdates dates_to_remember,
        children varchar(50) array
    )
    insert into friends(fullname, address, specialdates, children)
    VALUES (ROW('Boyd','M','Gregory'),
            ROW('7777','','Boise','Idaho','USA','99999'),
            ROW('1969-02-01',49,'2001-07-15'),
        '{"Austin","Ana Grace"}');

select * from friends
where children && array['Willy'::varchar];

-- Task: Use overlap operator && to find anyone with 'sales call' in schedule
-- in salary_employees
    create table salary_employees (
        name varchar(100),
        pay_by_quarter int array[4],
        schedule text[][]
    )
    INSERT INTO salary_employees (name,pay_by_quarter,schedule)
    VALUES ('Bill',
            ARRAY[20000, 20000, 20000, 20000],
            ARRAY[['meeting', 'training'],['lunch', 'sales call']])

select * from salary_employees
where schedule && array['sales call'];
    -- or
    select * from salary_employees
    where 'sales call'=any(schedule);

-- Section 27: PL/pgSQL - SQL procedural language
-- Lecture 146: Build your first PL/pgSQL Function
-- Documentation: https://www.postgresql.org/docs/11/plpgsql-structure.html
-- Documentation: https://www.postgresql.org/docs/11/plpgsql-control-structures.html#PLPGSQL-STATEMENTS-RETURNING
create function function_name (param1 int, param2 real, ...) returns var type as $$
BEGIN
    ... PL/PGSQL statements (not SQL statements)
END;
$$ LANGUAGE plpgsql;

-- Use return to send value
-- Do:
-- return x+y
-- instead of
-- select x+y
    -- Observation: PLPGSQL is a language like Python designed for Postgres server

-- Use Northwind database unless otherwise stated
-- Task: Let's redo max_price as PL/PGSQL function
    -- SQL function implementation:
    create or replace function max_price_of_any_product() returns real as $$
        select max(unitprice) from products
    $$ Language SQL
    select max_price_of_any_product()
-- PLPGSQL implementation
create or replace function max_price_of_any_product() returns real as $$
begin
    return max(unitprice) from products;
end;
$$ language plpgsql;

-- Task: Drop biggest_order() and redo as a PLPGSQL function.
-- It returns the largest_order_amount
create or replace function biggest_order() returns int as $$
begin
	return orderid
	from order_details
	group by orderid
	order by sum((unitprice * quantity) - discount) desc limit 1;
end;
$$ language plpgsql;

select biggest_order();

-- Extra task: create a function called biggest_order_total() that
-- returns the total of biggest order
drop function biggest_order_total();

create or replace function biggest_order_total() returns real as $$
begin
	return sum((unitprice * quantity) - discount) as total
	from order_details
	group by orderid
	order by total desc limit 1;
end;
$$ language plpgsql;

select biggest_order_total();
    -- Teacher's solution utilizing a subquery
    create or replace function biggest_order_total() returns real as $$
    begin
        return max(total) from (
            select orderid, sum((unitprice * quantity) - discount) as total
            from order_details
            group by orderid
        ) as subquery;
    end;
    $$ language plpgsql;

    select biggest_order_total();

-- Lecture 147: Handling PLPGSQL Functions With Output Variables
-- Documentation: https://www.postgresql.org/docs/11/plpgsql-statements.html#PLPGSQL-STATEMENTS-ASSIGNMENT
-- Imagine a SQL function:
create or replace function add_n_product (in x int, in y int, out sum int, out product int) as $$
    select (x+y), (x*y)
$$ Language SQL
-- The PLPGSQL equivalent of this function is:
drop function if exists add_n_product;
create or replace function add_n_product(in x int, in y int, out sum int, out product int) as $$
begin
    sum := (x+y);
    product := (x*y);
    return;
end;
$$ language plpgsql;
    -- So, in plpgsql equivalent the syntax is:
    output_variable1 := value1;
    output_variable  := expression1; --> (x*y)
    return;  --> must exist in the end of the function
select (add_n_product(5,20)).*;     --> the function returns composite having the sum & product values
select (add_n_product(5,20)).sum;

-- Use Northwind database
-- Task: replace square_n_cube with PLPGSQL function
drop function if exists square_n_cube(in n int, out square bigint, out cube bigint);

create or replace function square_n_cube(in n int, out square bigint, out cube bigint) as $$
begin
	square = n * n;
	cube = n * n * n;
	return;
end;
$$ language plpgsql;

select (square_n_cube(3)).*;

-- Lecture 148: Returning More than one row (i.e. a table ) in PLPGSQL functions
-- Documentation: https://www.postgresql.org/docs/11/plpgsql-control-structures.html#PLPGSQL-STATEMENTS-RETURNING
-- Syntax:
create or replace function function_name(param1 int, param2 real, ...) returns setof table_name as $$
begin
    return query select ...
end;
$$ language plpgsql;

-- Task: Redo sold_more_than to plpgsql. Returns all products that
-- sold more than an input amount
    -- in plain SQL function:
    drop function if exists sold_more_than;
    create or replace function sold_more_than(total_sales real) returns setof products as $$
        with step_one as(
            select productid
            from order_details
            group by productid
            having sum((unitprice*quantity)-discount) > total_sales
        )
        select * from products where productid in (select productid from step_one);
    $$ language SQL;
    select (sold_more_than(1000.0)).*;
-- in plpgsql language:
drop function if exists sold_more_than;
create or replace function sold_more_than(total_sold real) returns setof products as $$
begin
	return query select * from products where productid in (
		select productid from order_details
		group by productid
		having sum((unitprice*quantity)-discount) > total_sold
	);
    return;
end;
$$ language plpgsql;

select (sold_more_than(25000.0)).*;
    -- Observation: if you try to implement this using WITH clauses, it wont work
    -- Observation: CTE/With Clauses wont work with PLPGSQL functions
    -- instead of CTE/With clauses use subqueries in PLPGSQL functions


-- Task: Redo suppliers_to_reorder_from(). It returns suppliers that have
-- unitsinstock + unitsinorder that are less than reorderlevel
-- due to transaction in line 4511, we corrupted the products table
-- Lets drop Northwind database here and re-create it before we implement our solution
drop function if exists suppliers_to_reorder_from;
create or replace function suppliers_to_reorder_from() returns setof suppliers as $$
begin
    return query select * from suppliers
    where supplierid in (
        select distinct supplierid
        from products
        where (unitsinstock + unitsonorder) < reorderlevel
    );
end;
$$ language plpgsql;
select (suppliers_to_reorder_from()).*;

-- Lecture 149: Declaring variables in PLPGSQL functions
-- Documentation: https://www.postgresql.org/docs/11/plpgsql-declarations.html
-- If you need variables inside a PLPGSQL function, syntax:
declare
    name varchar(50);  --> uninitialized
    startdate timestamp := now();
begin
...
end;

-- Use Northwind database
-- Task: Find products between 75% and 125% of the average priced item
create or replace function products_in_price_range() returns setof products as $$
declare
    avg_unit_price real := (select avg(unitprice) from products);
    min_unit_price real := avg_unit_price * 0.75;
    max_unit_price real := avg_unit_price * 1.25;
begin
    return query select * from products
    where unitprice between min_unit_price and max_unit_price;
end;
$$ language plpgsql;

select (products_in_price_range()).*;  --> select * from products_in_price_range();
    -- Teachers solution:
    CREATE OR REPLACE FUNCTION middle_priced()
    RETURNS SETOF products AS $$

        DECLARE
            average_price real;
            bottom_price real;
            top_price real;
        BEGIN
            SELECT AVG(unitprice) INTO average_price
            FROM products;

            bottom_price := average_price * .75;
            top_price := average_price * 1.25;

            RETURN QUERY SELECT * FROM products
            WHERE unitprice between bottom_price AND top_price;
        END;
    $$ LANGUAGE plpgsql;

-- Task: Build a function that determines the average order size (in $) and returns all orders
-- that are between %75 and %130 of that order
create or replace function orders_in_range() returns setof orders as $$
declare
    average_order_amount real = (select avg(order_amount) from (
        select orderid, sum((unitprice*quantity)-discount) as order_amount
        from order_details
        group by orderid) as subquery
    );
    min_order_amount real = average_order_amount * 0.75;
    max_order_amount real = average_order_amount * 1.3;
begin
    return query select * from orders
    where orderid in (
        select orderid from order_details
        group by orderid
        having sum((unitprice*quantity)-discount) between min_order_amount and max_order_amount
    );
end;
$$ language plpgsql;

select * from orders_in_range();
    -- Teachers Solution (modified):
    create or replace function orders_in_range() returns setof orders as $$
    declare
        avg_order_amount real;
        min_order_amount real;
        max_order_amount real;
    begin
        select avg(order_amount) into avg_order_amount from (
            select orderid, sum((unitprice*quantity)-discount) as order_amount from order_details
            group by orderid
        ) as orders_with_order_amount;
        min_order_amount := avg_order_amount * 0.75;
        max_order_amount := avg_order_amount * 1.3;
        return query select * from orders where orderid in (
            select orderid from order_details
            group by orderid
            having sum((unitprice*quantity)-discount) between min_order_amount and max_order_amount
        );
    end;
    $$ language plpgsql;
    select * from orders_in_range();

-- Lecture 151: Looping through results in PLPGSQL functions
-- Documentation: https://www.postgresql.org/docs/current/plpgsql-control-structures.html#PLPGSQL-RECORDS-ITERATING
-- Syntax:
for variable_name in select_statement loop
    ... PLPGSQL statements ...
end loop;

-- Use Northwind database
-- Task: Starting from an employee, build an array of reportsto from employees table using recursive query
-- Note that CEO has reportsto as null
-- Hint: create a function called get_report_chain that returns the reportsto chain as a query set,
-- then use get_report_chain in another function called get_report_chain_array utilizing FOR loop
-- to form the array of reportsto values
create or replace function get_report_chain(in eid int) returns setof int as $$
    with recursive boss as (
		select reportsto from employees where employeeid = eid
		union all
		select e.reportsto
		from boss as b inner join employees as e on e.employeeid = b.reportsto
    )
    select * from boss where reportsto is not null;
$$ language sql;
    -- Important: b.reportsto is the employeeid of previous boss which is fetched from employees table e
select * from get_report_chain(218);

create or replace function get_report_chain_array(in eid int) returns int[] as $$
declare
    r record;
    report_chain_array int[];
begin
    for r in select get_report_chain from get_report_chain(eid) loop
        report_chain_array := array_append(report_chain_array, r."get_report_chain");
    end loop;
    return report_chain_array;
end;
$$ language plpgsql;

select get_report_chain_array(218);
select firstname, lastname, employeeid, get_report_chain_array(employeeid)
from employees;

-- Task: Build a function that returns the average of the square of products' unitprices
-- Use FOR loop
create or replace function average_of_square_of_unitprices() returns real as $$
declare
    square_total real := 0.0;
    total_count int := 0;
    product record;
begin
    for product in select * from products loop
        square_total := square_total + (product.unitprice) * (product.unitprice);
        total_count := total_count + 1;
    end loop;
    return square_total / total_count;
end;
$$ language plpgsql;
    -- Observation: var_name for for loop (i.e. product) is of type record always. It needs to be declared so (i.e. product record;)
select average_of_square_of_unitprices();

-- Lecture 151 : Using If-Then satements
-- Use Northwind database
-- Syntax for If:
if boolean_expression then
    ... Statements...
end if;
-- Syntax for if then else:
if boolean_expression then
    ... Statements...
else
    ... Statements...
end if;
-- Syntax for if then elsif else:
if boolean_expression then
    ... Statements...
elsif boolean_expression then
    ... Statements...
else
    ... Statements...
end if;

-- Task: Let's categorize our products by price range into bargain, middleclass and luxury
-- Detailed description: Given a product's unitprice, write a function
-- product_price_category that returns a text
-- (i.e. either bargain, middleclass > 25.0 or luxury > 50.0)
create or replace function product_price_category(in unitprice real) returns text as $$
begin
    if unitprice > 50.0 then
        return 'luxury';
    elsif unitprice > 25.0 then
        return 'middleclass';
    else
        return 'bargain';
    end if;
end;
$$ language plpgsql;

select product_price_category(unitprice), * from products;

-- Task: Build a function called time_of_year to return
-- Spring for dates between March and May
-- Summer for June to August
-- Fall for September to November
-- Winter for December through February
-- Use a single parameter date
-- Use time_of_year against orderdate in orders table
create or replace function time_of_year(in ts timestamp) returns text as $$
declare
	m int = extract(month from ts);
begin
	if m in (3, 4, 5) then
		return 'Spring';
	elsif m in (6, 7, 8) then
		return 'Summer';
	elsif m in (9, 10, 11) then
		return 'Autumn';
	else
		return 'Winter';
	end if;
end;
$$ language plpgsql;

select time_of_year('27-04-1978 04:00:00'::timestamp);
select time_of_year(orderdate::timestamp), * from orders;

-- Lecture 152: Returning query results continued
-- Documentation: https://www.postgresql.org/docs/current/plpgsql-control-structures.html#PLPGSQL-STATEMENTS-RETURNING
-- Recap: Lecture 148 : Returning Query Results:
-- Syntax:
create or replace function function_name(param1 int, param2 real, ...) returns setof table_name as $$
begin
    return query select ...
end;
$$ language plpgsql;

-- In this lecture, we focus on functions that returns set of some_type/composite
-- In this case we do not use RETURN scalar_type (e.g. return 'Winter';) which would return from the function immediately.
-- We have 2 commands for this case:
    RETURN NEXT expression;  -- (e.g. return next row_of_table; return product;)
    RETURN QUERY query;      -- (e.g. return query select flightid from flights where flightdate >= $1 and flightdate < ($1 + 1);)
-- RETURN NEXT and RETURN QUERY do not actually return from the function —
-- they simply append zero or more rows to the function's result set.
-- Execution then continues with the next statement in the PL/pgSQL function.
-- As successive RETURN NEXT or RETURN QUERY commands are executed, the result set is built up.
-- A final RETURN, which should have no argument, causes postgres to exit the function (or execution reaches the end of the function)
    -- Observation: For functions that return a setof some_type, postgres lets you build the result set
    -- part by part by calling RETURN NEXT and RETURN QUERY, which wont exit the function

-- Task: Lets raise an error in sold_more_than as "no products were found that had total sales more than X"
    -- How to figure out if there are no products found?
        -- Builtin variable FOUND: it has a value true, if the current result set has any rows in it
    -- How to raise an error?
        raise exception 'string to format %', variable_to_substitute
-- original sold_more_than():
create or replace function sold_more_than(total_sold real) returns setof products as $$
begin
	return query select * from products where productid in (
		select productid from order_details
		group by productid
		having sum((unitprice*quantity)-discount) > total_sold
	);
end;
$$ language plpgsql;
-- solution:
create or replace function sold_more_than(total_sales real) returns setof products as $$
begin
    return query select * from products where productid in (
        select productid from order_details
        group by productid
        having sum((unitprice*quantity)-discount) > total_sales
    );
    if not found then
        raise exception 'no products were found that had total sales more than %', total_sales;
    end if;
end;
$$ language plpgsql;
select * from sold_more_than(15000.0);  --> returns some products
select * from sold_more_than(500000.0); --> returns an error/exception

-- Task: lets create a variable pricing for after_christmas_sale()
CREATE OR REPLACE FUNCTION after_christmas_sale() RETURNS SETOF products AS $$
DECLARE
	product record;
BEGIN
	FOR product IN
		SELECT * FROM products
	LOOP
		IF product.categoryid IN (1,4,8) THEN
			product.unitprice = product.unitprice * .80;
		ELSIF product.categoryid IN (2,3,7) THEN
			product.unitprice = product.unitprice * .75;
		ELSE
			product.unitprice = product.unitprice * 1.10;
		END IF;
		RETURN NEXT product;
	END LOOP;

	RETURN;

END;
$$ LANGUAGE plpgsql;

select * from products;    --> orig product table with untouched unitprices
SELECT * FROM after_christmas_sale();  --> a new result set, a set of products with modified unitprices
select * from products;    --> orig product table with untouched unitprices
    -- Observation: If a function returns a setof table_name, it means it returns a COPY of some processed rows from table_name, not the original table_name.

-- Lecture 154: Loop and While Loops
-- Documentation: https://www.postgresql.org/docs/current/plpgsql-control-structures.html#PLPGSQL-CONTROL-STRUCTURES-LOOPS
-- Syntax:
LOOP
    IF condition_one then
        exit
    elsif condition_two then
        continue;
    end if;
    ... more statements ...
END LOOP;

-- Syntax:
LOOP
    exit when condition_one;
    continue when condition_two;
    ... more statements ...
END LOOP;

-- While loop Syntax:
while condition loop
    ... statements ...
end loop;

-- Task: Using a while loop, write a function to calculate the factorial of a given number
-- Example: 5! = 5 * 4 * 3 * 2 * 1
create or replace function factorial(in n int) returns bigint as $$
declare
    i int := n;
    f bigint := 1;
begin
    while i >= 1 loop
        f := f * i;
        i := i - 1;
    end loop;
	return f;
end;
$$ language plpgsql;

select factorial(5);


-- Lecture 154 : Looping over array elements in PLPGSQL functions
-- Documentation: https://www.postgresql.org/docs/current/plpgsql-control-structures.html#PLPGSQL-FOREACH-ARRAY
-- Syntax:
foreach variable in array array_name loop
    ... statements ...
end loop;

-- Task: User has two columns:
-- path which has a url
-- and additional which is an array field with values like sm:/url2, md: /url3 etc
-- Write a function called select_url to return url from additional
-- if the specific url is available otherwise return the default path
-- Here are a couple of calls to select_url and return values
select select_url('sm', ARRAY['sm: /url2', 'md: url3'], '/url1'); --> /url2
select select_url('md', ARRAY['sm: /url2', 'md: url3'], '/url1'); --> url3
select select_url('md', ARRAY['sm: /url2'], '/url1');             --> /url1

create or replace function select_url(url_to_search text, urls text[], default_url text) returns text as $$
declare
	u text;
	p integer;
begin
	foreach u in array urls loop
		p := position(url_to_search in u);
		if p != 0 then
			return substring(u, p+length(url_to_search)+2);
		end if;
	end loop;
	return default_url;
end;
$$ language plpgsql;

select select_url('sm', ARRAY['sm: /url2', 'md: url3'], '/url1'); --> /url2
select select_url('md', ARRAY['sm: /url2', 'md: url3'], '/url1'); --> url3
select select_url('md', ARRAY['sm: /url2'], '/url1');             --> /url1

-- Task: Build a function named first_multiple that takes an array of numbers
-- and a single number as the divisor.
-- Return the first number that divides evenly in the list.
-- My addition: if no number in the array evenly divides with the divisor, then function throws an exception
-- Hint: modulo operator %, returns the remainder of division.
-- You are looking for a modulo with a zero result.
create or replace function first_multiple(numbers integer[], divisor integer) returns integer as $$
declare
	n integer;
begin
	foreach n in array numbers loop
		if n%divisor = 0 then
			return n;
		end if;
	end loop;
	raise exception '% does not divide any of % evenly', divisor, numbers;
end;
$$ language plpgsql;

select first_multiple(ARRAY[13, 12, 64, 10], 32);
select first_multiple(ARRAY[13, 12, 64, 10], 11);
    -- Teacher's solution:
    -- Teachers addition: if no number in the array evenly divides with the divisior, then return null
    CREATE OR REPLACE FUNCTION first_multiple(x int[], y int) RETURNS int AS $$
    DECLARE
        test_number int;
    BEGIN
        FOREACH test_number IN ARRAY x LOOP
            IF test_number % y = 0 THEN
                RETURN test_number;
            END IF;
        END LOOP;
        RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;

-- Section 28: Building Triggers
-- Documentation 1: https://www.postgresqltutorial.com/postgresql-triggers/    <-- Read this first
-- Documentation 2: https://www.postgresql.org/docs/11/plpgsql-trigger.html    <-- Read this second
-- Documentation 2: Use practice_db
        CREATE TABLE emp (
            empname text,
            salary integer,
            last_date timestamp,
            last_user text
        );

        CREATE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
            BEGIN
                -- Check that empname and salary are given
                IF NEW.empname IS NULL THEN
                    RAISE EXCEPTION 'empname cannot be null';
                END IF;
                IF NEW.salary IS NULL THEN
                    RAISE EXCEPTION '% cannot have null salary', NEW.empname;
                END IF;

                -- Who works for us when they must pay for it?
                IF NEW.salary < 0 THEN
                    RAISE EXCEPTION '% cannot have a negative salary', NEW.empname;
                END IF;

                -- Remember who changed the payroll when
                NEW.last_date := current_timestamp;
                NEW.last_user := current_user;
                RETURN NEW;
            END;
        $emp_stamp$ LANGUAGE plpgsql;

        CREATE TRIGGER emp_stamp BEFORE INSERT OR UPDATE ON emp
        FOR EACH ROW EXECUTE FUNCTION emp_stamp();

        insert into emp(empname, salary)
        values ('Hakan', 3500);

        select * from emp;

        DROP TABLE emp_audit;
        CREATE TABLE emp_audit(
            operation         char(1)   NOT NULL,
            stamp             timestamp NOT NULL,
            userid            text      NOT NULL,
            empname           text      NOT NULL,
            salary integer
        );

        CREATE VIEW emp_view AS
            SELECT e.empname,
                e.salary,
                max(ea.stamp) AS last_updated
            FROM emp e
            LEFT JOIN emp_audit ea ON ea.empname = e.empname
            GROUP BY e.empname, e.salary;

        CREATE OR REPLACE FUNCTION update_emp_view() RETURNS TRIGGER AS $$
            BEGIN
                --
                -- Perform the required operation on emp, and create a row in emp_audit
                -- to reflect the change made to emp.
                --
                IF (TG_OP = 'DELETE') THEN
                    DELETE FROM emp WHERE empname = OLD.empname;
                    IF NOT FOUND THEN RETURN NULL; END IF;

                    OLD.last_date = now();
                    INSERT INTO emp_audit(operation, stamp, userid, empname, salary) VALUES('D', now(), user, OLD.empname, OLD.salary);
                    RETURN OLD;
                ELSIF (TG_OP = 'UPDATE') THEN
                    UPDATE emp SET salary = NEW.salary WHERE empname = OLD.empname;
                    IF NOT FOUND THEN RETURN NULL; END IF;

                    NEW.last_updated = now();
                    INSERT INTO emp_audit(operation, stamp, userid, empname, salary) VALUES('U', now(), user, NEW.empname, NEW.salary);
                    RETURN NEW;
                ELSIF (TG_OP = 'INSERT') THEN
                    INSERT INTO emp VALUES(NEW.empname, NEW.salary);

                    NEW.last_updated = now();
                    INSERT INTO emp_audit(operation, stamp, userid, empname, salary) VALUES('I', now(), user, NEW.empname, NEW.salary);
                    RETURN NEW;
                END IF;
            END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER emp_audit
        INSTEAD OF INSERT OR UPDATE OR DELETE ON emp_view
            FOR EACH ROW EXECUTE FUNCTION update_emp_view();

        UPDATE emp_view SET salary = 10000 WHERE empname = 'David';  --> Observation: updating a view updates its table!
        select * from emp;
        select * from emp_view;

        CREATE OR REPLACE FUNCTION process_emp_audit() RETURNS TRIGGER AS $emp_audit$
            BEGIN
                --
                -- Create a row in emp_audit to reflect the operation performed on emp,
                -- making use of the special variable TG_OP to work out the operation.
                --
                IF (TG_OP = 'DELETE') THEN
                    INSERT INTO emp_audit SELECT 'D', now(), user, OLD.empname, OLD.salary;
                ELSIF (TG_OP = 'UPDATE') THEN
                    INSERT INTO emp_audit SELECT 'U', now(), user, NEW.empname, NEW.salary;
                ELSIF (TG_OP = 'INSERT') THEN
                    INSERT INTO emp_audit SELECT 'I', now(), user, NEW.empname, NEW.salary;
                END IF;
                RETURN NULL; -- result is ignored since this is an AFTER trigger
            END;
        $emp_audit$ LANGUAGE plpgsql;

        CREATE TRIGGER emp_audit
        AFTER INSERT OR UPDATE OR DELETE ON emp
        FOR EACH ROW EXECUTE FUNCTION process_emp_audit();

        insert into emp(empname, salary)
        values ('David', 2000);

        update emp set salary = 3000 where empname = 'David';

        delete from emp where empname = 'David';

        select * from emp;
        select * from emp_audit;

-- What is a trigger?
-- A PostgreSQL trigger is a function invoked automatically whenever an event
-- such as insert, update, or delete occurs

-- Task: One simple task that triggers are used for is to update timestamps
-- every time a record gets changed. Lets build one for employees table
alter table employees
add column last_updated timestamp;

-- Step 1: Build a PLPGSQL function that returns trigger
create or replace function employees_timestamp() returns trigger as $$
begin
	new.last_updated := now();
	return new;   --> (???) why do we return new here as trigger
end;
$$ language plpgsql;

drop trigger if exists employee_timestamp on employees;

-- Step 2: create trigger mapping using the table (i.e. employees)
-- calling the function employees_timestamp
create trigger employees_timestamp before insert or update on employees
for each row execute function employees_timestamp();

select last_updated, * from employees where employeeid = 1;  --> null/old timestamp for last_updated

update employees
set address = '33 West Spring Road'
where employeeid = 1;

select last_updated, * from employees where employeeid = 1;  --> new timestamp for last_updated

-- Task: Add a last_updated & updating_user to products table and create a trigger function
-- and a trigger that updates the fields every time there is a change
alter table products
add column last_updated timestamp;

alter table products
add column updating_user text;

create or replace function products_timestamp() returns trigger as $$
begin
    new.last_updated := now();
    new.updating_user := current_user;
    return new;
end;
$$ language plpgsql;

create trigger products_timestamp before insert or update on products
for each row execute function products_timestamp();

-- test that an insert indeed updates last_updated & updating_user fields
select max(productid) from products;  --> 77

insert into products(productid, productname, supplierid, categoryid, quantityperunit, unitprice,
unitsinstock, unitsonorder, reorderlevel, discontinued)
values (78, 'new cool product', 1, 6, 1, 1, 1, 1, 0, 1);     -- (1)

select * from products where productid = 78;

update products set productname='puppy toy' where productid = 78;
select * from products where productid = 78;
delete from products where productid = 78;

-- Lecture 157: Statement Triggers
-- Syntax:
create trigger trigger_name before insert on table_name
referencing new table as new_table
for each statement execute function trigger_function_name();

create trigger trigger_name before update on table_name
referencing old table as old_table
referencing new table as new_table
for each statement execute function trigger_function_name();

create trigger trigger_name before delete on table_name
referencing old table as old_table
for each statement execute function trigger_function_name();
    -- OLD & NEW wont work at the statement level
    -- the trigger function must refer to the new & old tables
    -- using new_table & old_table
    -- In trigger function, use TG_OP variable to check
    -- which operation (i.e. insert, update or delete) was called

-- Task: Lets create an audit table called order_details_audit for order_details
-- and insert the changed information to it when insert, delete and update happens
create table order_details_audit (
    operation varchar(1),
    username text,
    stamp timestamp,
    orderid smallint NOT NULL,
    productid smallint NOT NULL,
    unitprice real NOT NULL,
    quantity smallint NOT NULL,
    discount real NOT NULL
);

create or replace function audit_order_details() returns trigger as $$
begin
    if (tg_op = 'DELETE') then
        insert into order_details_audit
        select 'D', user, now(), * from old_table;
    elsif (tg_op = 'UPDATE') then
        insert into order_details_audit
        select 'U', user, now(), * from new_table;
    elsif (tg_op = 'INSERT') then
        insert into order_details_audit
        select 'I', user, now(), * from new_table;
    end if;
    return null;
end;
$$ language plpgsql;
    -- refer to insert into select Lecture 61

create trigger delete_order_details after delete on order_details
referencing old table as old_table
for each statement execute function audit_order_details();
    -- Observation: old_table contains the rows that have been deleted.
    -- old_table does not contain all the rows before the delete operation.
    -- You can rename old_table as rows_deleted

create trigger update_order_details after update on order_details
referencing old table as old_table new table as new_table
for each statement execute function audit_order_details();
    -- Observation: new_table contains only the updated rows. Not all the rows after the update operation.
    -- You can rename new_table as updated_rows

create trigger insert_order_details after insert on order_details
referencing new table as new_table
for each statement execute function audit_order_details();
    -- Observation: new_table contains only the order_details rows that have been inserted.
    -- new_table does not contain all the rows after the insert operation.
    -- You can rename the new_table as inserted_rows

select orderid from orders; --> pick order id: 10250
select productid from products; --> pick product id: 1
insert into order_details
values (10250, 1, 10.0, 3, 0);
select * from order_details_audit;

update order_details
set discount = 0.05
where orderid = 10250 and productid = 1;

select * from order_details_audit;

delete from order_details
where orderid = 10250 and productid = 1;

select * from order_details_audit;
select * from order_details
where orderid = 10250 and productid = 1;

-- Task create an audit trail for orders using the same three steps
-- of creating table, trigger function and the triggers
create table orders_audit (
    operation varchar(1),
    username text,
    stamp timestamp,
    orderid smallint NOT NULL,
    customerid bpchar,
    employeeid smallint,
    orderdate date,
    requireddate date,
    shippeddate date,
    shipvia smallint,
    freight real,
    shipname character varying(40),
    shipaddress character varying(60),
    shipcity character varying(15),
    shipregion character varying(15),
    shippostalcode character varying(10),
    shipcountry character varying(15)
);

create or replace function audit_orders() returns trigger as $$
begin
    if (tg_op = 'DELETE') then
        insert into orders_audit
        select 'D', user, now(), * from old_table;
    elsif (tg_op = 'UPDATE') then
        insert into orders_audit
        select 'U', user, now(), * from new_table;
    elsif(tg_op = 'INSERT') then
        insert into orders_audit
        select 'I', user, now(), * from new_table;
    end if;
    return null;
end;
$$ language plpgsql;
    -- refer to insert into select Lecture 61

create trigger delete_orders after delete on orders
referencing old table as old_table
for each statement execute function audit_orders();

create trigger update_orders after update on orders
referencing new table as new_table old table as old_table
for each statement execute function audit_orders();

create trigger insert_orders after insert on orders
referencing new table as new_table
for each statement execute function audit_orders();

select max(orderid)+1 from orders; --> next orderid: 11078
select customerid from customers; --> pick customerid: 'ANTON'
select employeeid from employees; --> pick employeeid: 3
select shipperid from shippers;   --> pick shippperid : 6
insert into orders
values(11078, 'ANTON', 3, now()::date,
       now()::date + interval '7 days',
       now()::date + interval '2 days' ,
       6, 10.0, 'David Brown', '333 Road CA', 'Los Angeles','California', '00180', 'USA');
select * from orders_audit;

update orders
set shippostalcode = '12345'
where orderid = 11078;

delete from orders
where orderid = 11078;

select * from orders_audit;

-- Section 29 : Importing CSV
-- Lecture 157: Importing CSV
-- Syntax:
copy table_name(field1, field2, ...)
from 'path\to\file' delimiter ',' csv header;
    -- delimter can be any string, but in our case, the file contains comma as delimiters
    -- if csv header is present in the file, then include it in the statement
    -- fields must be in the same order as in the file

-- Task: create airports table & import data to it using airports.csv from https://ourairports.com/data/
-- Use https://ourairports.com/data/
    -- airports.csv (8,938,583 bytes, last modified Jan 5, 2021)
        -- Large file, containing information on all airports on this site.
    -- airport-frequencies.csv (1,218,201 bytes, last modified Jan 5, 2021)
        -- Large file, listing communication frequencies for the airports in airports.csv.
    -- runways.csv (3,051,462 bytes, last modified Jan 5, 2021)
        -- Large file, listing runways for the airports in airports.csv.
    -- navaids.csv (1,526,491 bytes, last modified Jan 5, 2021)
        -- Large file, listing worldwide radio navigation aids.
    -- countries.csv (20,663 bytes, last modified Jan 5, 2021)
        -- A list of the world's countries. You need this spreadsheet to interpret the country codes in the airports and navaids files.
    -- regions.csv (369,879 bytes, last modified Jan 5, 2021)
        -- A list of all countries' regions (provinces, states, etc.). You need this spreadsheet to interpret the region codes in the airport file.

create database airports_db;

CREATE TABLE airports (
	id int NOT NULL,
	ident varchar(255),
	type text,
	name text,
	latitude_deg float,
	longitude_deg float,
	elevation_ft int,
	continent text,
	iso_country varchar(10),
	iso_region varchar(10),
	municipality text,
	scheduled_service text,
	gps_code varchar(10),
	iata_code varchar(20),
	local_code varchar(20),
	home_link text,
	wikipedia_link text,
	keywords text
);

-- open psql in command prompt:
psql --port=5433 --host=localhost --dbname=airports_db --username=postgres

-- in psql command prompt:
\copy airports (id,ident,type,name,latitude_deg,longitude_deg,elevation_ft,continent,iso_country,iso_region,municipality,scheduled_service,gps_code,iata_code,local_code,home_link,wikipedia_link,keywords) FROM '/home/hakan/PostGreSQL/Lecture_157/airports.csv' DELIMITER ',' CSV HEADER;


-- Task: create airport-frequencies table & import data to it using airport-frequencies.csv from https://ourairports.com/data/
CREATE TABLE airport_frequencies (
	id int,
	airport_ref int,
	airport_ident varchar(10),
	type varchar(20),
	description text,
	frequency_mhz float
);

\copy airport_frequencies (	id,airport_ref,airport_ident,type,description,frequency_mhz) FROM '/home/hakan/PostGreSQL/Lecture_157/airport-frequencies.csv' DELIMITER ',' CSV HEADER;

-- Lecture 158: Practice CSV importing
CREATE TABLE navaids (
	id int,
	filename text,
	ident varchar(10),
	name text,
	type varchar(10),
	frequency_khz float,
	latitude_deg float,
	longitude_deg float,
	elevation_ft int,
	iso_country varchar(10),
	dme_frequency_khz float,
	dme_channel varchar(10),
	dme_latitude_deg float,
	dme_longitude_deg float,
	dme_elevation_ft int,
	slaved_variation_deg float,
	magnetic_variation_deg float,
	usageType char(10),
	power char(10),
	associated_airport varchar(10)
)

\copy navaids (id,filename, ident, name, type, frequency_khz, latitude_deg, longitude_deg, elevation_ft, iso_country, dme_frequency_khz, dme_channel, dme_latitude_deg, dme_longitude_deg, dme_elevation_ft, slaved_variation_deg,magnetic_variation_deg, usageType, power, associated_airport) FROM '/home/hakan/PostGreSQL/Lecture_157/navaids.csv' DELIMITER ',' CSV HEADER;

--2
CREATE TABLE regions (
	id int,
	code varchar(10),
	local_code varchar(10),
	name text,
	continent char(2),
	iso_country varchar(10),
	wikipedia_link text,
	keywords text
);

\copy regions (id,code, local_code, name, continent, iso_country, wikipedia_link, keywords) FROM '/home/hakan/PostGreSQL/Lecture_157/regions.csv' DELIMITER ',' CSV HEADER;

--3 country

CREATE TABLE countries (
	id int,
	code varchar(10),
	name text,
	continent char(2),
	wikipedia_link text,
	keywords text
);

\copy countries ( id,code, name, continent, wikipedia_link, keywords) FROM '/home/hakan/PostGreSQL/Lecture_157/countries.csv' DELIMITER ',' CSV HEADER;

--4
CREATE TABLE runways (
	id int,
	airport_ref int,
	airport_ident varchar(10),
	length_ft int,
	width_ft int,
	surface text,
	lighted boolean,
	closed boolean,
	le_ident varchar(10),
	le_latitude_deg float,
	le_longitude_deg float,
	le_elevation_ft int,
	le_heading_degT float,
	le_displaced_threshold_ft int,
	he_ident varchar(10),
	he_latitude_deg float,
	he_longitude_deg float,
	he_elevation_ft int,
	he_heading_degT float,
	he_displaced_threshold_ft int
);

\copy runways ( id,airport_ref, airport_ident, length_ft, width_ft, surface, lighted, closed ,le_ident, le_latitude_deg, le_longitude_deg, le_elevation_ft, le_heading_degT, le_displaced_threshold_ft, he_ident, he_latitude_deg, he_longitude_deg, he_elevation_ft, he_heading_degT, he_displaced_threshold_ft)  FROM '/home/hakan/PostGreSQL/Lecture_157/runways.csv' DELIMITER ',' CSV HEADER;

-- Section 30: JSON and JSONB Data Types
-- Lecture 159: What is JSON & how to store it in database
-- Documentation: https://www.postgresql.org/docs/current/datatype-json.html
-- json vs jsonb: jsonb is faster since it is parsed and it is in binary format. JSONB also supports indexing.
-- Use practice_db
CREATE TABLE books (
	id serial,
	bookinfo jsonb
)
    -- Observation: a field in a table can be in json/jsonb format

-- How to insert a json/jsonb field value as a part of a row into a table?
INSERT INTO books (bookinfo)
VALUES
('{"title": "Introduction To Data Mining",
  "author": ["Pang-ning Tan", "Michael Steinbach", "Vipin Kumar"],
  "publisher":"Addison Wesley", "date": 2006}'),
('{"title": "Deep Learning with Python", "author": "Francois Chollet", "publisher":"Manning", "date": 2018}'),
('{"title": "Neural Networks - A Visual Intro for Beginners", "author": "Michael Taylor", "publisher":"self", "date": 2017}'),
('{"title": "Big Data In Practice", "author": "Bernard Marr", "publisher":"Wiley", "date": 2016}');

-- How to access an item from a JSON field in a table?
-- Use select json_field_name->'item_name' from table_name
-- Note that json field contains many items (e.g. bookinfo json field contains author item)
 SELECT bookinfo->'author' FROM books;  --> returns a jsonb result

-- Lecture 160: Create JSON From Tables using jsonb_build_object()
-- Syntax:
select jsonb_build_object('field1', value1, 'field2', value2, ...) from table_name or a join

-- Task: Lets create a simple version of airports into json, which does not contains arrays
SELECT jsonb_build_object(
	'id', air.id,
	'ident', air.ident,
	'name', air.name,
	'latitude_deg', air.latitude_deg,
	'elevation_ft', air.elevation_ft,
	'continent', air.continent,
	'iso_country', air.iso_country,
	'iso_region', air.iso_region,
	'airport_home_link', air.home_link,
	'airport_wikipedia_link', air.wikipedia_link,
	'municipality', air.municipality,
	'scheduled_service', air.scheduled_service,
	'gps_code', air.gps_code,
	'iata_code', air.iata_code,
	'airport_local_code', air.local_code
)
FROM airports AS air;

-- How to export array of items (e.g. an array of authors) into JSONB from a table?
-- Task: Lets create a full version of airports into json, which contains array called airport_keywords
SELECT jsonb_build_object(
	'id', air.id,
	'ident', air.ident,
	'name', air.name,
	'latitude_deg', air.latitude_deg,
	'elevation_ft', air.elevation_ft,
	'continent', air.continent,
	'iso_country', air.iso_country,
	'iso_region', air.iso_region,
	'airport_home_link', air.home_link,
	'airport_wikipedia_link', air.wikipedia_link,
	'municipality', air.municipality,
	'scheduled_service', air.scheduled_service,
	'gps_code', air.gps_code,
	'iata_code', air.iata_code,
	'airport_local_code', air.local_code,
	'airport_keywords', to_jsonb(string_to_array(air.keywords, ','))
)
FROM airports AS air;

-- Task: Add to the previous statement by joining countries and regions
-- using iso_region and iso_country from airports table.
-- Pull back the name, wikipedia_link and array of keywords for both tables
-- use inner join
SELECT jsonb_build_object(
	'id', air.id,
	'ident', air.ident,
	'name', air.name,
	'latitude_deg', air.latitude_deg,
	'elevation_ft', air.elevation_ft,
	'continent', air.continent,
	'iso_country', air.iso_country,
	'iso_region', air.iso_region,
	'airport_home_link', air.home_link,
	'airport_wikipedia_link', air.wikipedia_link,
	'municipality', air.municipality,
	'scheduled_service', air.scheduled_service,
	'gps_code', air.gps_code,
	'iata_code', air.iata_code,
	'airport_local_code', air.local_code,
	'airport_keywords', to_jsonb(string_to_array(air.keywords, ',')),
	'country_name', countries.name,
	'country_wikipedia_link', countries.wikipedia_link,
	'country_keywords', to_jsonb(string_to_array(countries.keywords, ',')),
	'region_name', regions.name,
	'region_wikipedia_link', regions.wikipedia_link,
	'regions_keywords', to_jsonb(string_to_array(regions.keywords, ','))
)
FROM airports AS air
INNER JOIN regions ON air.iso_region=regions.code
INNER JOIN countries ON air.iso_country = countries.code;
    -- Observation: if you have a text (e.g. airports.keywords) containing items seperated by a seperator (e.g. comma)
    -- and if you want to convert the items into a json/jsonb array, use to_jsonb(string_to_array(airports.keywords, ','))

-- How to strip nulls from the exported JSON/JSONB?
-- use jsonb_strip_nulls() function
SELECT JSONB_STRIP_NULLS (
	 jsonb_build_object(
	'id', air.id,
	'ident', air.ident,
	'name', air.name,
	'latitude_deg', air.latitude_deg,
	'elevation_ft', air.elevation_ft,
	'continent', air.continent,
	'iso_country', air.iso_country,
	'iso_region', air.iso_region,
	'airport_home_link', air.home_link,
	'airport_wikipedia_link', air.wikipedia_link,
	'municipality', air.municipality,
	'scheduled_service', air.scheduled_service,
	'gps_code', air.gps_code,
	'iata_code', air.iata_code,
	'airport_local_code', air.local_code,
	'airport_keywords', to_jsonb(string_to_array(air.keywords, ',')),
	'country_name', countries.name,
	'country_wikipedia_link', countries.wikipedia_link,
	'country_keywords', to_jsonb(string_to_array(countries.keywords, ',')),
	'region_name', regions.name,
	'region_wikipedia_link', regions.wikipedia_link,
	'regions_keywords', to_jsonb(string_to_array(regions.keywords, ','))
))
FROM airports AS air
INNER JOIN regions ON air.iso_region=regions.code
INNER JOIN countries ON air.iso_country = countries.code;

-- Lecture 161: Aggregating JSON Fields : How write the result of a query into a json?
-- Way #1: Use jsonb_build_object() method as specified in the previous lecture
-- Way #2: Use to_json() with subquery that pull back the records to a result set
select to_json(subquery_name) from (
... subquery that pulls back the records to a result set
) as subquery_name

select to_jsonb(subquery_name) from (
... subquery that pulls back the records to a result set
) as subquery_name

-- Task: Lets pull back the runways that belong to airport JRA (9 in total)
-- Way #1: Using jsonb_build_object() method
CREATE TABLE runways (
	id int,
	airport_ref int,
	airport_ident varchar(10),
	length_ft int,
	width_ft int,
	surface text,
	lighted boolean,
	closed boolean,
	le_ident varchar(10),
	le_latitude_deg float,
	le_longitude_deg float,
	le_elevation_ft int,
	le_heading_degT float,
	le_displaced_threshold_ft int,
	he_ident varchar(10),
	he_latitude_deg float,
	he_longitude_deg float,
	he_elevation_ft int,
	he_heading_degT float,
	he_displaced_threshold_ft int
);
select * from runways where airport_ident = 'JRA';
select jsonb_build_object(
    'runway_id', r.id,
    'airport_ref', r.airport_ref,
    'length_ft', r.length_ft,
    'width_ft', r.width_ft,
    'surface', r.surface,
    'lighted', r.lighted,
    'closed', r.closed,
    'le_ident', r.le_ident,
    'le_latitude_deg', r.le_latitude_deg,
    'le_longitude_deg', r.le_longitude_deg,
    'le_elevation_ft', r.le_elevation_ft,
    'le_heading_degT', r.le_heading_degT,
    'le_displaced_threshold_ft', r.le_displaced_threshold_ft,
    'he_ident', r.he_ident,
    'he_latitude_deg', r.he_latitude_deg,
    'he_longitude_deg', r.he_longitude_deg,
    'he_elevation_ft', r.he_elevation_ft,
    'he_heading_degT', r.he_heading_degT,
    'he_displaced_threshold_ft', r.he_displaced_threshold_ft
)
from runways  as r where airport_ident = 'JRA';
    -- Observation: jsonb_build_object() gives you a result set of jsonb rows

-- Way #2: Using to_json() / to_jsonb() with a subquery:
select to_json(subquery_name) from (
... subquery that pulls back the records to a group
) as subquery_name
-- the subquery returns a query set, where the individual fields' names are used as the item names for JSON
select to_json(JRA_runways) from (
    select * from runways where airport_ident = 'JRA'
) as JRA_runways

-- How to aggragate JSON rows into a JSON array
-- Syntax:
json_agg()

-- Task: Aggregate all airport JRA's runways into a JSON array
select json_agg(to_json(JRA_runways)) from (
    select * from runways where airport_ident = 'JRA'
) as JRA_runways;

-- Task: Do the same aggregation for the navaids table
-- where associated_airport='CYYZ'
CREATE TABLE navaids (
	id int,
	filename text,
	ident varchar(10),
	name text,
	type varchar(10),
	frequency_khz float,
	latitude_deg float,
	longitude_deg float,
	elevation_ft int,
	iso_country varchar(10),
	dme_frequency_khz float,
	dme_channel varchar(10),
	dme_latitude_deg float,
	dme_longitude_deg float,
	dme_elevation_ft int,
	slaved_variation_deg float,
	magnetic_variation_deg float,
	usageType char(10),
	power char(10),
	associated_airport varchar(10)
)
select * from navaids where associated_airport='CYYZ';
select json_agg(to_json(CYYZ_navaids)) from (
    select * from navaids where associated_airport='CYYZ'
) as CYYZ_navaids;


-- Lecture 162: Building a JSON table : Building airports_json table; a table that contains a jsonb as a whole row
CREATE TABLE airports_json AS (
    SELECT JSONB_STRIP_NULLS (
        jsonb_build_object(
            'id', air.id,
            'ident', air.ident,
            'name', air.name,
            'latitude_deg', air.latitude_deg,
            'elevation_ft', air.elevation_ft,
            'continent', air.continent,
            'iso_country', air.iso_country,
            'iso_region', air.iso_region,
            'airport_home_link', air.home_link,
            'airport_wikipedia_link', air.wikipedia_link,
            'municipality', air.municipality,
            'scheduled_service', air.scheduled_service,
            'gps_code', air.gps_code,
            'iata_code', air.iata_code,
            'airport_local_code', air.local_code,
            'airport_keywords', to_jsonb(string_to_array(air.keywords, ',')),
            'country_name', countries.name,
            'country_wikipedia_link', countries.wikipedia_link,
            'country_keywords', to_jsonb(string_to_array(countries.keywords, ',')),
            'region_name', regions.name,
            'region_wikipedia_link', regions.wikipedia_link,
            'regions_keywords', to_jsonb(string_to_array(regions.keywords, ',')),
            'runways', (SELECT JSONB_AGG(to_jsonb(runway_json)) FROM
                (SELECT le_ident, he_ident, length_ft, width_ft, surface,
                    lighted AS is_lighted,closed AS is_closed,
                    le_latitude_deg, le_longitude_deg,le_elevation_ft,le_displaced_threshold_ft,
                    he_latitude_deg,he_longitude_deg,he_elevation_ft, he_heading_degt,he_displaced_threshold_ft
                FROM runways
                WHERE airport_ident = air.ident) as runway_json
                ),
            'navaids', (SELECT JSONB_AGG(to_jsonb(nav)) FROM
                        (SELECT name, filename, ident, type, frequency_khz,
                            latitude_deg, longitude_deg, elevation_ft, dme_frequency_khz,
                            dme_channel, dme_latitude_deg, dme_latitude_deg,dme_elevation_ft,
                            slaved_variation_deg, magnetic_variation_deg,usagetype, power
                        FROM navaids
                        WHERE associated_airport = air.ident) AS nav
                ),
            'frequencies', (SELECT JSONB_AGG(to_jsonb(nav)) FROM
                        (SELECT type, description, frequency_mhz
                        FROM airport_frequencies
                        WHERE airport_ident = air.ident) AS nav
                )
        )
    ) as airport
    FROM airports AS air
    INNER JOIN regions ON air.iso_region=regions.code
    INNER JOIN countries ON air.iso_country = countries.code
);
    -- Observation: create table table_name as (subquery);  e.g. create table airports_json as (subquery)
        -- The subquery gets executed and its result set is saved as a table
    -- Observation: In the subquery, per row in the join, i.e. per airport, we create a json object containing fields from the row.
    --              We store the jsonb airport into airports_json table as a row
    -- Observation: If we want to create a JSON array, such as runways for the airport, we run a subquery returning the array
    --              The subquery uses jsonb_agg() and to_jsonb() to produce the array
                    -- to_jsonb() uses a subquery to produce a jsonb runway per each row in the subquery
                    -- jsonb_agg() creates a jsonb array from the jsonb result set (runways)

-- Lecture 163: Selecting Information Out Of JSON fields in a table : -> and ->> operators
-- Selecting a JSON element Out Of JSON fields in a table : Syntax:
operator ->
select based on key
jsonb_field->'key'

select based on array index (index starts from 0)
jsonb_field->number

-- Because they are returning JSON, they can be chained:
airport->'runways'->2    --> 3rd runway in each airport

-- Use airports_db > airports_json table
-- Task: select the first runway of each record as jsonb and country_name as jsonb
select airport->'runways'->0 as first_runway, airport->'country_name' as country_name
from airports_json;

-- Selecting Text Out of JSON fields in a table : Syntax
jsonb_field->>int for selecting array element
jsonb_field->>key for selecting by field name

-- Use airports_db > airports_json table
-- Task: select the first runway of each record as text and country_name as text
select airport->'runways'->>0 as first_runway, airport->>'country_name' as country_name
from airports_json;

-- Select based on path : Syntax
jsonb_field #> path_in_json   -- return JSON object at path
jsonb_field #>> path_in_json  -- return text of JSON object at path

-- Task:
select '{"a": {"b": [3,2,1]}}'::jsonb #> '{a, b}'  --> [3, 2, 1]
select '{"a": {"b": [3,2,1], "c": {"d": 5}}}'::jsonb #> '{a, c, d}'  --> 5 as jsonb
    --Observation: Imagine a json tree containing other jsons in their elements and so on
    -- Postgres can surgically get the json/text version of any part of the json tree using:
        jsonb_field #> return JSON object at path
        jsonb_field #>> return text of JSON object at path

-- Task: return the 2nd frequency_khz of each airport as jsonb
-- and the region_name as text from airports_json table
-- order by frequencies asc
select  airport->'frequencies'->1 as second_frequency,
        airport->>'region_name' as region_name
from airports_json
order by second_frequency asc;

-- Lecture 164: Searching for JSON data in a JSON field
-- Way # 1: Containment operator: is the value on the right contained in the json field on the left
where jsonb_field @> '{"iso_country": "BR"}'
-- Way #2: Grab the field, will only return rows that have the field
where jsonb_field->>'iso_country' = 'BR'   -- note that ->> returns text

-- Use airports_db
-- Task: Using the airports_json table, Find all the airports in Brazil
select *
from airports_json
where airport->>'iso_country' = 'BR';
    -- Another solution
    select *
    from airports_json
    where airport @> '{"iso_country": "BR"}';


-- Use airports_db
-- Task: Using the airports_json table, Find the count of all the airports in Brazil
    select count(*)
    from airports_json
    where airport @> '{"iso_country": "BR"}';


-- Use airports_db
-- Task: Using the airports_json table, how many airports are in USA Arkansas Region?
-- iso_region USA-AR
select count(*) from airports_json where airport @> '{"iso_region": "US-AR"}';
select count(*) from airports_json where airport->>'iso_region' = 'US-AR';

-- Select Based On Nested Attribute
-- i.e. Selecting rows based on part of a json tree
-- Syntax:
where jsonb_field->'field1'->>'field2' = "value"
or
where jsonb_field @> '{"field1": {"field2": "value"}}'

-- Use airports_db > airports_json table
-- Task: Find the number of airports with the first runway being 2000 feet long
select count(*) from airports_json where airport->'runways'->0->>'length_ft' = '2000';
    -- Another solution
    SELECT COUNT(*) FROM airports_json
    WHERE airports->'runways'-> 0 @> '{"length_ft": 2000}';

-- Use airports_db > airports_json table
-- Task: Find the number of airports in which the 2nd navaid has a frequency of 400
select count(*) from airports_json where airport->'navaids'->1->>'frequency_khz' = '400';
    -- Another solution
    select count(*) from airports_json where airport->'navaids'->1 @> '{"frequency_khz" : 400}';

-- Lecture 165: Updating and Deleting Information inside JSON Fields
-- Updating existing json using || operator
    -- This will add a new field or replace an existing value of a field
select airport->'nearby_lakes' as nearby_lakes
from airports_json
where airport->>'iso_region'='US-AR' and airport->>'municipality'='Lake Village';
    -- Note that ATM, we do not have nearby_lakes
update airports_json
set airport = airport || '{"nearby_lakes": ["Lake Chicot", "Lake Providence"]}'
where airport->>'iso_region'='US-AR' and airport->>'municipality'='Lake Village';

-- Remobing existing json, we have 2 operators
-- - to delete key/value pairs
-- #- to delete based on path

-- Use airports_db > airports_json table
-- Task lets delete the fields (i.e. nearby_lakes) we just created in the previous task
update airports_json
set airport = airport - 'nearby_lakes'
where airport->>'iso_region'='US-AR' and airport->>'municipality'='Lake Village';
    -- Another solution
    update airports_json
    set airport = airport || '{"nearby_lakes": ["Lake Chicot", "Lake Providence"]}'
    where airport->>'iso_region'='US-AR' and airport->>'municipality'='Lake Village';

    update airports_json
    set airport = airport #- '{"nearby_lakes", 1}' --> deleting "Lake Providence"
    where airport->>'iso_region'='US-AR' and airport->>'municipality'='Lake Village';

    select airport->'nearby_lakes' as nearby_lakes
    from airports_json
    where airport->>'iso_region'='US-AR' and airport->>'municipality'='Lake Village';

-- Use airports_db > airports_json table
-- Task: Add a new field good_restaurants that is an array of 'La Terraza'
-- and 'McDonalds' to the airports with id 20426.
-- Then remove 'McDonalds' from the array
update airports_json
set airport = airport || '{"good_restaurants": ["La Terraza", "McDonalds"]}'
where (airport->>'id')::integer = 20426;

select airport->'good_restaurants'
from airports_json
where (airport->>'id')::integer = 20426;

update airports_json
set airport = airport #- '{"good_restaurants", 1}'
where (airport->>'id')::integer = 20426;

select airport->'good_restaurants'
from airports_json
where (airport->>'id')::integer = 20426;

-- Section 31 : Creating & Droping Databases
-- Lecture 166 : Create Database
-- Syntax:
create database database_name;  --> in PGAdmin
createdb database_name;     --> in psql command line

-- Lecture 167: Dropping a database
drop database if exists database_name; --> in PGAdmin
dropdb database_name;     --> in psql command line

-- Section 32 : Database Backup and Database Recovery
-- Lecture 168: Import/Export with Copy command
-- Documentation: https://www.postgresql.org/docs/current/sql-copy.html

psql --port=5433 --host=localhost --dbname=northwind
-- export a table to a file
\copy table_name to 'file/location'
    -- Important: If the file exists already, it appends to it! It does not overwrite
-- e.g.
\COPY customers TO '/home/hakan/PostGreSQL/Lecture_168/customers.txt';

\h copy  --> help options for copy command
    -- FORMAT  --> i.e. csv / ? JSON
    -- HEADER  --> i.e. csv header
    -- QUOTE   --> What you want to surround text
    -- DELIMITER
    -- FORCE_QUOTE  --> force text delimiter

-- Use northwind database
-- Task: Save customers table with CSV format, header and different text delimiter
\COPY customers TO '/home/hakan/PostGreSQL/Lecture_168/customers.csv' WITH (FORMAT CSV, HEADER, QUOTE '"');
    -- Observation: Can export a table into CSV using psql's \copy command

-- How to export the result set of a query to a JSON file, where each row is a json?
\copy (select row_to_json(subquery) from (select ...) as subquery) to '/home/hakan/PostGreSQL/Lecture_168/your_query_file_name.json';

-- How to export a table as JSON file, where each row is a json?
\copy (select row_to_json(subquery) from (select * from customers) as subquery) to '/home/hakan/PostGreSQL/Lecture_168/customers.json';

-- How to export a table as JSON file, where each row is a json, and the file contains an array of json rows?
\copy (select json_agg(row_to_json(subquery)) from (select * from customers) as subquery) to '/home/hakan/PostGreSQL/Lecture_168/customers_json_array.json';

-- Use northwind database
-- Task: Export orders from 1996 into orders_in_1996.csv
\copy (select * from orders where extract(year from orderdate) = 1996) to '/home/hakan/PostGreSQL/Lecture_168/orders_in_1996.csv' with (format csv, header);

-- Use northwind database
-- Task: Export order_details for productid 11 in a CSV file with a header
\copy (select * from order_details where productid = 11) to '/home/hakan/PostGreSQL/Lecture_168/orders_details_with_productid_11.csv' with (format csv, header);

-- Observation: using \copy command in psql command line, one can export a table as JSON or as CSV into a file

-- Lecture 169: Basic pg_dump and restore
-- plain linux bash shell command:
pg_dump database_name > /file/location      --> in plain command line as postgres user: sudo su - postgres

pg_dump northwind > /home/hakan/PostGreSQL/Lecture_169/northwind.sql

-- How to restore a database from a .sql file?
createdb database_name;         --> in plain command line as postgres user
psql database_name < /file/path --> in plain command line as postgres user


-- Task: Create northwind2 database and restore the contents from
-- /home/hakan/PostGreSQL/Lecture_169/northwind.sql

createdb northwind2             --> in plain command line as postgres user
psql northwind2 < /home/hakan/PostGreSQL/Lecture_169/northwind.sql  --> in plain command line as postgres user

-- Task: Make a backup of the usda database and restore to usda_bak database
pg_dump usda > /home/hakan/PostGreSQL/Lecture_169/usda.sql    --> in plain command line
createdb usda_bak                                             --> in plain command line
psql usda_bak < /home/hakan/PostGreSQL/Lecture_169/usda.sql   --> in plain command line
dropdb usda_bak                                               --> in plain command line

-- Lecture 170: Custom format dumps
-- Documentation: https://www.postgresql.org/docs/current/app-pgrestore.html
-- it allows you to make a dump in custom format for a database
-- Advantages: the data is compressed and it allows you to do partial restore of a database (i.e. restoring triggers, a table etc)
-- Syntax ( in plain command line as postgres user: sudo su - postgres)
pg_dump -Fc database_name > /file/location/dump_file.fc

-- Task: do a custom format dump of northwind into northwind.fc
pg_dump -Fc northwind > /home/hakan/PostGreSQL/Lecture_170/northwind.fc

-- How to see what is in the custom format dump file?
-- Syntax ( in plain command line as postgres user: sudo su - postgres)
pg_restore --list /file/location

-- Task: lets see the contents of the /home/hakan/PostGreSQL/Lecture_170/northwind.fc
pg_restore --list /home/hakan/PostGreSQL/Lecture_170/northwind.fc

-- How to restore a database from a custom format dump file?
-- Syntax ( in plain command line as postgres user: sudo su - postgres)
pg_restore -j 2 -d database_name /home/hakan/PostGreSQL/Lecture_170/northwind.fc

-- Task: Restore /home/hakan/PostGreSQL/Lecture_170/northwind.fc into northwind2 database
dropdb northwind2
createdb northwind2
pg_restore -j 2 -d northwind2 /home/hakan/PostGreSQL/Lecture_170/northwind.fc

-- How to restore a table from a .fc (custom format dump) file?
pg_restore -j 2 -d database_name -t table_name /home/hakan/PostGreSQL/Lecture_170/northwind.fc

-- Task: drop usstates table from northwind2 database and do a partial restore
pg_restore -j 2 -d northwind2 -t usstates /home/hakan/PostGreSQL/Lecture_170/northwind.fc

-- Task: Make a custom format backup of usda
-- and do a partial restore of table weight to original database
-- Make sure to drop weight in the database
pg_dump -Fc usda > /home/hakan/PostGreSQL/Lecture_170/usda.fc
pg_restore -j 2 -d usda -t weight /home/hakan/PostGreSQL/Lecture_170/usda.fc

-- Observation: pg_dump/pg_restore command pair allows us to dump & restore custom format dump files (i.e. .fc files)
-- Advantages: the data is compressed and it allows you to do partial restore of a database (i.e. restoring triggers, a table etc)

-- Section 33: Security Using Roles, Users and Permissions
-- Lecture 171: Roles and Users
-- Users are roles with passwords and able to login
-- Groups have become an alias for the roles
-- There are 2 levels when it comes to backing up a database:
-- a database level and an database instance level
    -- roles belong to the database instance level
        -- so when you \copy a database at database level, you do not copy the roles
        -- if you wanna copy the roles at well, you need to the backup at database
        -- instance level (How to do that???)
-- Roles can be nested: every role can contain other role
    -- This allows you to add permissions to other roles
        -- i.e. imagine role X with certain permissions
        -- create a role Y with new permissions and we can make Y contain X

-- Proper Way to Set Up roles
    -- create roles that CANT login and are named for jobs: hr, accounting
    -- Create users (i.e. roles with logins) and add them to the roles they need to get the job done

-- 6 Layers of Security in PostGreSQL
    1. Instance level (covers all databases), handles can you login, create databases, roles etc
    2. Database level - can you connect to a db and create roles
    3. Schema level - can you create or use particular schemas
    4. Table level - what operations can you perform on a table
    5. Column level - what operations can you perform on a specific column
    6. Row level - which rows in database can you perform operations on


-- Lecture 172: Instance Level Security
-- Instance Level Security is the topmost level : applies to all databases,handles can you login, create databases, roles of instance
-- Controls the following PERMISSIONS:
    -- SUPERUSER - can do anything (i.e. my postgres user ?)
    -- CREATEDB - make databases
    -- CREATEROLE - make more roles
    -- LOGIN - can login into database
    -- REPLICATION - can be used for replication (???)
-- The above permissions can be reversed with a NO in front
-- e.g. NOSUPERUSER

-- Task: Using northwind database, lets create two roles: hr and accounting
CREATE ROLE accounting NOCREATEDB NOLOGIN NOSUPERUSER;
CREATE ROLE hr NOCREATEDB NOLOGIN NOSUPERUSER;
    -- try logining in with hr and accounting roles
    psql -U hr
    psql -U accounting

-- Lets make users that have login permissions
CREATE ROLE with LOGIN
-- or
CREATE USER

CREATE ROLE suzy NOCREATEDB LOGIN NOSUPERUSER PASSWORD 'pass123';
CREATE USER bobby NOCREATEDB LOGIN NOSUPERUSER PASSWORD 'pass123';
    -- We didnt give them permissions to Northwind database but they can connect to psql
    sudo useradd suzy
    sudo passwd suzy (pwd h1a2k3a4)
    sudo su - suzy
    psql -U suzy -d northwind

-- IMPORTANT: there is a role called public which has access to all databases
-- cancel public's access to northwind using PgAdmin UI
revoke all on database northwind from public;

-- Add users to roles:
    grant accounting to suzy;
    grant hr to boby;

-- Task: create a role for sales that cant login or create db
-- Then add user jill having role sales
drop role jill;
create role sales nosuperuser nocreatedb CREATEROLE nologin replication;  --> instance level
create role jill login PASSWORD 'pass123';
grant sales to jill;
    -- What is missing here in order jill to be able to login via psql?
        -- jill needs to have an account on ubuntu and jill must have logged in via the account in ubuntu
        -- after that, jill can login to pgsql
            sudo useradd jill
            sudo passwd jill (pwd h1a2k3a4)
            sudo su - jill
            psql -U jill -d northwind
                -- psql: error: FATAL:  permission denied for database "northwind"
                -- DETAIL:  User does not have CONNECT privilege

-- What we have accomplished at Lecture 172:
    -- Created generic roles without logins that users can be granted to (e.g. sales)
    -- Removed all permissions for the role public on Northwind database
    -- Assigned users to generic roles (i.e. jill)

-- Next Steps: Work on Database permissions so suzy and boby can reach northwind database

-- Lecture 173 : Database Level Security
-- Controls the following permissions:
create - make new schemas
connect - connect to database
temporary - create temporary tables

-- Task: Lets add permissions for connection for hr and accounting to northwind database
grant connect on database northwind to accounting;
grant connect on database northwind to hr;
    sudo su - suzy
    psql -d northwind
    -- At this stage, suzy can connect to northwind database
    -- But it cannot a create schema
    create schema suzy_schema;

-- Task: Lets add create permission for making new schemas on northwind database
grant create on database northwind to accounting;
    psql> create schema suzy_schema;  --> succeeds

-- Task: Give your sales role the ability to connect to northwind and create schemas
grant connect on database northwind to sales;
grant create on database northwind to sales;
    sudo su - jill
    psql -d northwind
    create schema jills_schema;

-- Lecture 175 : Schema Level Security
-- controls the following permissions:
create - put objects like tables, functions into the schema
usage - look in the schema and see what is present

-- Task: As boby tries to create a table, it goes into public schema
-- First, lets review what has been done for boby so far:
    CREATE ROLE hr NOCREATEDB NOLOGIN NOSUPERUSER;      -- as admin user, in PgAdmin
    CREATE USER bobby NOCREATEDB LOGIN NOSUPERUSER PASSWORD 'pass123';  -- as admin user, in PgAdmin
    grant hr to boby;                                   -- as admin user, in PgAdmin
    grant connect on database northwind to hr;
            sudo useradd boby                   -- as hakan in command line
            sudo passwd boby (pwd h1a2k3a4)     -- as hakan in command line
            sudo su - boby
        -- at this stage;
            -- we have linux user boby & logged in as boby in command line
            -- we have boby role defined in Postres
                -- we CAN login to northwind database as boby, because we have granted
                -- database level connect privilige to to hr role, to which boby is granted
psql -d northwind -u boby
psql northwind=> create table bobys_table (
                        name varchar(255),
                        age integer
                 );
-- check public schema under northwind database, you will see that there is bobys_table under public schema > tables
-- We did not give boby to create a table under public schema
revoke all on schema public from public;
drop table bobys_table;
    -- Observation: public role is a default role that has the ability to edit public schema under a database X.
    -- For example, with public role, we can add a table under public schema.
    -- Observation: All users are granted with public role by default
    -- Related Q/A:
    -- I see from section 33 that we need to take care of removing privileges of the public role to avoid security holes.
    -- Is the public role assigned automatically to any new added user? YES
    -- Is it possible to revoke or even delete this role? Deleting is not possible, revoking is possible:
        revoke all on schema public from public;  --> at schema level !
    -- How can i check which users have such role attached? You can't run a query and see it anywhere
    -- Public is used to indicate the default privileges that are granted to all roles automatically.
    -- It is an implicitly defined group so you can't see it listed anywhere.
    -- So you are restricting the default privileges by
        revoke all on schema public from public;  --> public role cant create any table on public schema

northwind=> create table bobys_table (
name varchar(255),
age integer
);
    -- ERROR:  no schema has been selected to create in
    -- LINE 1: create table bobys_table (
    --                      ^

northwind=> create table public.bobys_table (
name varchar(255),
age integer
);
    -- ERROR:  permission denied for schema public
    -- LINE 1: create table public.bobys_table (
    --                      ^

-- IMPORTANT: When you create a new database, do run
revoke all on schema public from public;
-- to ensure that no user will be able to edit the public schema automatically
-- You need to grant schema level create and/or usage rights per role (e.g. hr)

-- Task: Give accounting create and usage right to public schema
grant all on schema public to accounting;  -- all = create + usage on schema level
    -- equals to:
    grant create on schema public to accounting;
    grant usage on schema public to accounting;
    -- note that we did the following earlier
    grant accounting to suzy;  --> suzy can create tables, functions, triggers etc to public schema & see public schema

-- Task: Give hr usage rights to public schema
grant usage on schema public to hr;
    -- note that we did the following earlier
    grant hr to boby;          --> boby can only see the contents of public schema under northwind database

-- Task: give usage permission to sales for public schema
grant usage on schema public to sales;
    -- note that we did the following earlier
    grant sales to jill;  --> jill can only see the contents of public schema under northwind database

-- Observation: For any database under test, we need to have a tester role
    -- At instance level & at OS side, we need to create the tester role:
        create role testing nosuperuser nocreatedb NOCREATEROLE nologin noreplication;
        create role the_monkey login PASSWORD 'h1a2k3a4';
        grant testing to the_monkey;
        sudo useradd the_monkey
        sudo passwd the_monkey (pwd h1a2k3a4)
        sudo su - the_monkey
        psql -d northwind       --> Login action of the_monkey
        -- psql: error: FATAL:  permission denied for database "northwind"
        -- DETAIL:  User does not have CONNECT privilege.
    -- At database level, grand testing access to northwind database
    grant connect on database northwind to tester;
        psql -d northwind  --> connected to psql console for northwind database
        -- the_monkey as a testing can only connect to northwind database
        -- it cannot create schemas nor it can create temporary tables
    -- note that we revoked all permissions on the public schema from the role public
    -- note also that the_monkey automatically got granted the public role's schema level priviliges
    -- we need to grant usage permission on public schema for testing, so that the_monkey
    -- can have the usage permission on the public schema as well
    grant usage on schema public to tester;  --> schema level permission
        -- note that tester role can only view the contents of public schema of northwind
        -- note that tester CANT add tables, functions, triggers etc to the public schema
    -- At this moment, considering the_monkey, we got covered instance level, database level and
    -- schema level. Now, we need to learn about table level, column level and row level security
    -- Lets pause it for now for the_monkey

-- Lecture 175: Table level security
-- controls the following:
select - read rows in the table
insert - write data to the table
update - change data in the table
delete - delete data
truncate - remove all data at once
reference - allows user to create foreign key constraints
trigger - create triggers on the table
    -- the above permissions are per table
    -- so do we have to adjust the permissions for every table?
        -- No. Can use ALL TABLES clause to apply the desired permissions to every table at once
-- Task: Give accounting SELECT all tables
grant select on all tables in schema public to accounting;  --> suzy

-- Task: Give hr SELECT; UPDATE and INSERT to employees table
grant insert on table employees to hr;  --> boby
grant select on table employees to hr;  --> boby
grant update on table employees to hr;  --> boby

-- Task: grant sales the ability to see customers table and
-- see and insert into orders and order_details table
grant select on table customers to sales;  --> jill
grant select on table orders to sales;  --> jill
grant insert on table orders to sales;  --> jill
grant select on table order_details to sales;  --> jill
grant insert on table order_details to sales;  --> jill

-- Observation: On table level security, we decide who (e.g. sales) should be able to do what (e.g. select)
-- on what table (e.g. orders)

-- Lecture 176: Column Level Security
-- Controls the following:
select - read the column
insert - insert data into the column
update - update data into the column
references - permission to refer to the column in foreign keys

-- Referring to the previous lecture, we did give accounting to SELECT all tables
grant select on all tables in schema public to accounting;  --> suzy
    -- i.e. accounting can read all the tables (and all the columns) under public schema
-- Task: we want accounting to be able to see employees table, but hide some
-- sensitive data such as homephone, address and birthdate
revoke select on column homephone on table employees from accounting;
-- First we try to restrict
GRANT SELECT (employeeid, lastname, firstname, title, titleofcourtesy, hiredate, country, extension, photo, photopath)
ON employees
TO accounting; --> suzy
    -- if you login to psql as suzy, you will see that homephone. address and birthdate are shown
-- revoke the select (i.e. read) permission at table level first
REVOKE SELECT ON TABLE employees FROM accounting;
-- Now only grant what accounting needs to see on employees table:
GRANT SELECT (employeeid, lastname, firstname, title, titleofcourtesy, hiredate, country, extension, photo, photopath)
ON employees
TO accounting;
    select * from employees; --> wont work (*) means every column in the table
    select employeeid, lastname, firstname, title, titleofcourtesy, hiredate, country, extension, photo, photopath from employees;
        -- it works!

-- Task: Give sales the ability to update customers table
-- but only contactname, contacttitle and phone fields (i.e. column level security)
grant update (contactname, contacttitle, phone) on customers to sales;

-- Lecture 178: Row Level Security
-- Must be turned on at table level, not turned on by default
alter table table_name enable row level security;
-- default row level security is to deny a role to see any rows
-- so when this feature is enabled, you need to add access to rows

-- Task: on orders table, lets give accounting access to orders table
-- and then set some row level security (?)
-- remember we did, on Lecture 175:
grant select on all tables in schema public to accounting;  --> suzy
alter table orders enable row level security;
    -- at this moment, in psql, if suzy does:
    select * from orders;  --> 0 rows! default row level security is to deny a role to see any rows!
create policy policy_name
on table_name
for select | insert | update | delete
to role_name
using (expression)
    -- Lets make a policy that lets accounting see all orders that are later than Jan 1, 1998
    create policy orders_after_jan_1_1998
    on orders
    as permissive
    for select
    to accounting
    using (orderdate > '1998-01-01'::date);
        -- at this moment, in psql, if suzy does:
        select * from orders;  --> many rows!

-- Q: What happens if more than one policy
    -- default is more rows are added where expressions are combined with OR
    -- This is called permissive policy
--Task: Lets add another policy for accounting to see orderdate for 1996
    create policy orders_in_1996
    on orders
    as permissive
    for select
    to accounting
    using (extract(year from orderdate)::int = 1996);

-- Q: How to AND the expressions on the several policies for a specific role on a specific table?
    create policy accounting_orders_customers on orders
    as restrictive
    for select to accounting
    using (customerid like 'A%');

-- Task: Add a policy for sales to be able to only update sales that
-- have not shipped (i.e. order.shippeddate is null)
-- Note that in Lecture 175, we did:
grant select on table orders to sales;  --> jill
-- but what we did not do then, which we need to do now
grant usage on schema public to sales;
    -- at this moment, if jill on psql does
    select * from orders;  --> 0 rows, because default row level security is to deny a role to see any rows

create policy not_shipped_orders_for_sales on orders
for select to sales
using (shippeddate is null);

create policy not_shipped_orders_for_sales_updating on orders
for update to sales
using (shippeddate is null);









