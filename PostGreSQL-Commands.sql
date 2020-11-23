-- NOTE: We use Northwind db unless otherwise stated

-- Section 3: Simple Selection Of All Records
-- Lecture 6: Selecting All Data From A Table
    select * from customers

-- Lecture 7: Selecting specific fields
-- How to get the schema for a specific table (e.g. suppliers)
    select *
    from information_schema.columns
    where table_name = 'suppliers';

-- Get companyname, city and country fields from suppliers table
    select companyname, city, country from suppliers

-- Get categoryname and description fields from categories table
    select categoryname, description from categories

-- Lecture 8: Selecting Distinct Values
-- List all of the customers' countries (without duplicates)?
    select distinct country from customers
-- List all of the customers' city & countries (without duplicates)?
    select distinct city, country from customers
-- What are the unique regions our suppliers are in?
    select distinct region from suppliers

-- Lecture 9: Counting results
-- How many entries do we have in products table?
   select count(*) from products
-- How many orders have we had so far?
   select count(*) from orders
-- How many cities are our Suppliers in?
    select count(*) from (select distinct city from suppliers) as T   -- or
    select count(distinct city) from suppliers
-- How many distinct products have been ordered (hint. use order details table)
    select count(distinct productid) from order_details

-- Lecture 10: Combining fields in SELECT
-- List customerid and difference between shippeddate and orderdate for all our orders
select customerid, shippeddate - orderdate as delta from orders

-- List order_id and the amount spent using order_details (unitprice times quantity minus discount)
select orderid, ((unitprice * quantity) - discount) as amount_spent from order_details

-- Lecture 11: Practice what you learned
-- NOTE: At this lecture, we use pagila database

-- Select all fields, and all records from actor table
    select * from actor

-- Select all fields and records from film table
    select * from film

-- Select all fields and records from the staff table
    select * from staff

-- Select address and district columns from address table
    select address, district from address

-- Select title and description from film table
    select title, description from film

-- Select city and country_id from city table
    select city, country_id from city

-- Select all the distinct last names from customer table
    select distinct last_name from customer

-- Select all the distinct first_names from the actor table
    select distinct first_name from actor

-- Select all the distinct inventory_id values from rental table
    select distinct inventory_id from rental

-- Find the number of films ( COUNT ).
    select count(*) from film

-- Find the number of categories.
    select count(*) from category

-- Find the number of distinct first_names in actor table
    select count(distinct first_name) from actor
    -- Find the number of distinct (first_name, last_name) pairs
    select count(distinct(first_name, last_name)) from actor

-- Select rental_id and the difference between return_date and rental_date in rental table
    select rental_id, return_date - rental_date as diff from rental

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
    select count(*) from orders where employeeid = 3
-- Number of order details that had more than 20 items ordered
   select count(*) from order_details where quantity > 20
-- How many orders had a freight cost equal to or greater than 250$
   select count(*) from orders where freight >= 250

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
    select count(*) from orders where orderdate >= '1998-01-01'

-- How many orders shipped before July 5, 1997
    select count(*) from orders where shippeddate < '1997-07-05'

-- Lecture 16: WHERE using logical AND operator
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where condition 1 and condition 2 and condition 3 and ...

-- How many orders shipped to Germany with fright cost more than 100$
    select count(*) from orders where shipcountry='Germany' and freight>100

-- We want the distict customers where orders were shipped shipped via United Package (id = 2)
-- and the ship country is Brazil
    select distinct(customerid) from orders where shipvia=2 and shipcountry='Brazil'


-- Lecture 17: WHERE using logical OR operator
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where condition 1 or condition 2 or condition 3 or ...

-- How many customers do we have in USA and Canada
    select count(*) from customers where country='USA' or country='Canada'

-- How many suppliers do we have in Germany and Spain
    select count(*) from suppliers where country='Germany' or country='Spain'
-- How many orders shipped to USA, Brazil and Argentina
    select count(*) from orders where shipcountry in ('USA', 'Brazil', 'Argentina')

-- Lecture 18: WHERE using logical NOT operator
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where NOT <condition>

-- How many customers are not in France
   select count(*) from customers where not country='France'

-- How many suppliers are not in USA
    select count(*) from suppliers where not country='USA'
    select count(*) from suppliers where country!='USA'

-- Lecture 19: WHERE combining AND, OR and NOT
-- Basic Syntax:
-- select <colun1>, <column2>, ... from <table_name>
-- where not ((<condition1> and not <condition2>) or <condition3>)

-- How many orders are shipped to Germany and freight charges < 50 or > 175
    select count(*) from orders where shipcountry='Germany' and (freight < 50 or freight > 175)

-- How many orders shipped to Canada or Spain and shippeddate after May 1, 1997
    select count(*) from orders where (shipcountry='Canada' or shipcountry='Spain') and shippeddate > '1997-05-01'

-- Lecture 20 : Using BETWEEN
-- where freight between 50 and 100
-- This is the same as:
-- where fright >= 50 and freight <= 100

-- How many order details have a unit price between $10 and $20
    select count(*) from order_details where unitprice between 10 and 20

-- How many orders shipped between June 1, 1996 and Sept 30, 1996
    select count(*) from orders where shippeddate between '1996-06-01' and '1996-09-30'

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
    select * from data_src where journal='Food Chemistry'

-- Select record from nutr_def where nutrdesc is Retinol.
    select * from nutr_def where nutrdesc = 'Retinol'

-- Find all the food descriptions (food_des) records for manufacturer Kellogg, Co.
-- (must include punctuation for exact match).
    select * from food_des where manufacname='Kellogg, Co.'

-- Find the number of records in data sources (data_src) that were published after year 2000 (it is numeric field).
    select count(*) from data_src where year > 2000

-- Find the number of records in food description that have a fat_factor < 4.
    select count(*) from food_des where fat_factor < 4

-- Select all records from weight table that have gm_weight of 190.
    select * from weight where gm_wgt = 190

-- Find the number of records in food description table that have pro_factor greater than 1.5 and fat_factor less than 5.
    select * from food_des where pro_factor > 1.5 and fat_factor < 5

-- Find the record in data source table that is from year 1990 and the journal Cereal Foods World.
    select * from data_src where year = 1990 and journal = 'Cereal Foods World'

-- Select count of weights where gm_wgt is greater than 150 and less than 200.
    select count(*) from weight where gm_wgt > 150 and gm_wgt < 200

-- Select the records in nutr_def table (nutrition definitions) that have units of kj or kcal.
    select * from nutr_def where units in ('kj', 'kcal')

-- Select all records from data source table (data_src) that where from the year 2000 or the journal Food Chemistry.
    select * from data_src where year = 2000 and journal = 'Food Chemistry'

-- How many records in food_des are not about food group Breakfast Cereals.
-- The field fdgrp_cd is an id field and you will have to find it in fd_group for fddrp_desc = 'Breakfast Cereals'.
    select * from food_des where fdgrp_cd != (select fdgrp_cd from fd_group where fddrp_desc = 'Breakfast Cereals')

-- Find all the records in data sources that where between 1990 and 2000 and either 'J. Food Protection' or 'Food Chemistry'.
    select * from data_src where (year between 1990 and 2000) and (journal in ('J. Food Protection', 'Food Chemistry'))

-- Use BETWEEN syntax to find number of weight records that weight between 50 and 75 grams (gm_wgt).
    select * from weight where gm_wgt between 50 and 75

-- Select all records from the data source table that were published
-- in years 1960,1970,1980,1990, and 2000.  Use the IN syntax.
    select * from data_src where year in (1960,1970,1980,1990, 2000)

-- Lecture 23 : Schema Basics
-- Select everything from product table in production schema
    select * from production.product

-- Select verything from the vendor table in purchasing schema
    select * from purchasing.vendor

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
    order by unitprice desc, productname asc

-- Lecture 29: MIN & MAX
-- Syntax:
-- select min(column) from <table_name> where <condition>
-- select max(column) from <table_name> where <condition>

-- When was the first order ordered from Italy
    select min(orderdate) from orders where shipcountry='Italy'

-- When was the last order shipped to Canada?
    select max(orderdate) from orders where shipcountry='Canada'

-- Find the slowest order sent to France based on order date vs. ship date
    select max(shippeddate - orderdate) from orders where shipcountry='France'

-- Lecture 30: AVG and SUM
-- Syntax:
-- select avg(column) from <table_name> where <condition>
-- select sum(column) from <table_name> where <condition>

-- What was average freight of orders shipped to Brazil
    select avg(freight) from orders where shipcountry='Brazil'

-- How many individual items of Tofu (productid=14) were ordered
    select sum(quantity) from order_details where productid = (select productid from products where productname='Tofu')

-- What was the average number of Steeleye Stout (productid=35) per order
  select * from order_details where productid = (select productid from products where productname='Steeleye Stout')

-- Lecture 35: LIKE to match patterns
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
    select unitprice*quantity as total_spent from order_details

    -- list the total amount spent per order details & order it by total amount spent in asc fashion
    select unitprice*quantity as total_spent from order_details
    order by total_spent asc

-- calculate our inventory value of products
-- (need unitprice and unitsinstock fields)
-- and return as total_inventory
-- order by this column desc
    select productid, productname, unitprice*unitsinstock as inventory_value from products
    order by inventory_value desc

-- Lecture 33: LIMIT the number of records returned
-- Syntax: select <column1>, <column2> ... from <table_name> limit number

-- Find 3 most expensive order details
    select orderid, ((unitprice*quantity)-discount) as amount_spent from order_details order by amount_spent desc limit 3

-- List the 2 products with the least inventory in stock by total dollar amount of inventory
    select productname, (unitsinstock*unitprice) as total_inventory from products order by total_inventory asc limit 2

-- Lecture 34: NULL value
-- NULL is a special value that signifies unknown
-- not 0, not empty
-- Syntax for searching null:
-- select <column1>, <column2> from table_name where <columnX> is null
-- select <column1>, <column2> from table_name where <columnX> is not null

-- How many customers dont have a region value?
   select count(*) from customers where region is null

-- How many suppliers have a region value?
    select count(*) from suppliers where region is not null

-- How many orders did not have a ship region?
    select count(*) from orders where shipregion is null

-- Lecture 35: Exercises
-- Return the name, weight, and productnumber of  all the products  ordered by weight from lightest to heaviest.
-- (Remember to use schema to reach table.  It is in production schema.)
   select name, weight, productnumber from production.product order by weight asc

-- Return the records from productvendor for productid = 407 in order of averageleadtime from shortest to longest.
-- (You'll have to figure out which schema this is in.)
    select * from purchasing.productvendor where productid=407 order by averageleadtime asc

-- Find all the salesorderdetail records for productid 799 and order them by largest orderqty to smallest.
    select * from sales.salesorderdetail where productid=799 order by orderqty desc

-- What is the largest  discount percentage offered in the specialoffer table.
    select discountpct from sales.specialoffer order by discountpct desc limit 1
    select max(discountpct) from sales.specialoffer

-- Find the smallest number of sickleavehours for an employee.
    select sickleavehours from humanresources.employee order by sickleavehours asc limit 1
    select min(sickleavehours) from humanresources.employee

-- Find entry for the employee with the smallest sickleave hours
    select * from humanresources.employee order by sickleavehours asc limit 1

-- Find the largest rejected quantity in the purchaseorderdetail table
    select rejectedqty from purchasing.purchaseorderdetail order by orderqty desc limit 1
    select max(rejectedqty) as max_rejected_qty from purchasing.purchaseorderdetail

-- Find the average rate from employeepayhistory table.
    select avg(rate) as average_rate from humanresources.employeepayhistory

-- Find the average standardcost in the productcosthistory table for productid 738.
    select avg(standardcost) as avg_std_cost from production.productcosthistory where productid = 738

-- Find the sum of scrappedqty from the workorder table for productid 529.
    select sum(scrappedqty) as sum_scrapped_qty from production.workorder where productid = 529

-- Find all vendor names with a name that starts with letter G.
    select vendor.name from purchasing.vendor where vendor.name like 'G%'

-- Find all vendor names that have the word Bike in them.
    select name from purchasing.vendor where name like '%Bike%'

-- Search the person table for every firstname that has t as a second letter.
    select firstname from person.person where firstname like '_t%'

-- Return the first 20 records from emailaddress table
    select * from person.emailaddress limit 20

-- Return the first 2 records from productcategory table
    select * from production.productcategory limit 2

-- How many product records have a missing weight value
    select count(*) from production.product where weight is null

-- How many person records have an additionalcontactinfo field that has a value
    select count(*)  from person.person where additionalcontactinfo is not null

-- Section 8: Joining multiple tables together
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
on employees.employeeid = orders.employeeid

-- connect products and suppliers and pull back companyname, unitprice and unitsinstock
select companyname, unitprice, unitsinstock from products inner join suppliers
on products.supplierid = suppliers.supplierid

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
            inner join order_details on orders.orderid = order_details.orderid

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
            inner join categories on products.categoryid = categories.categoryid

-- Take the previous query and add a WHERE clause selecting the category name of Seafood
-- and the amount spent >= 500
select customers.companyname, orders.orderdate, order_details.productid, order_details.unitprice, order_details.quantity,
	   products.productname, categories.categoryname
from orders inner join customers on customers.customerid = orders.customerid
            inner join order_details on orders.orderid = order_details.orderid
            inner join products on products.productid = order_details.productid
            inner join categories on products.categoryid = categories.categoryid
where categories.categoryname = 'Seafood' and order_details.unitprice * order_details.quantity >= 500

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
select companyname, orderid from customers left join orders on customers.customerid = orders.customerid

-- Take the previous query and look for customers without orders
select companyname from customers left join orders on customers.customerid = orders.customerid
where orderid is null

-- Do a left join between products and order_details
select productname, orderid  from products left join order_details on products.productid = order_details.productid

-- Use the previous query and look for products without orders
select productname, orderid  from products left join order_details on products.productid = order_details.productid
where orderid is null

select * from products left join order_details using(productid)
where order_details.orderid is null

-- Lecture 40: Right Joins
-- Pull back maching records from the first table and all records in the second table
-- Syntax:
   select <column1>, <column2>, ...
   from table1 right join table2 on table1.column_name = table2.column_name

-- Connect Orders to customers
-- Bring back companyname, orderid and use right join
select companyname, orderid from orders right join customers on orders.customerid = customers.customerid
select companyname, orderid from orders right join customers using(customerid)

-- Lets look for orders without customers using right join
select orderid, customers.customerid from customers right join orders on customers.customerid = orders.customerid
where customers.customerid is null

select orderid, orders.customerid from customers right join orders using(customerid)
where customers.customerid is null

-- Lets look for customers without orders using right join
select companyname from orders right join customers on orders.customerid = customers.customerid
where orderid is null

select companyname from orders right join customers using(customerid)
where orders.orderid is null

-- Do a right join between customercustomerdemo and customers
select customers.customerid, companyname, customertypeid
from customercustomerdemo right join customers on customercustomerdemo.customerid = customers.customerid

select customers.customerid, companyname, customercustomerdemo.customertypeid
from customercustomerdemo right join customers using(customerid)

-- Lecture 41: Full joins
-- pulls all records in first table and all records in second table
-- even if there is null in one side or the other side
-- Syntax:
   select <column1>, <column2>, ...
   from table1 full join table2 on table1.column_name = table2.column_name

-- Connect Orders to Customers via full join
-- Bring back companyname and orderid
select companyname, orderid from orders full join customers on orders.customerid = customers.customerid
select companyname, orderid from customers full join orders on orders.customerid = customers.customerid
select companyname, orderid from orders full join customers using(customerid)
    -- orders without customers + customers without orders + inner join of customers & orders

-- Do a full join between products and categories
select productname, categoryname from products full join categories on products.categoryid = categories.categoryid

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

-- Find customer pairs who are in the same city and order by city
    select c1.companyname as customer_1, c2.companyname as customer_2, c1.city as city
    from customers as c1 join customers as c2 on c1.city = c2.city
    where c1.customerid != c2.customerid
    order by c1.city

    select c1.companyname as customer_1, c2.companyname as customer_2, c1.city
    from customers as c1 join customers as c2 on c1.city = c2.city
    where c1.customerid <> c2.customerid
    order by c1.city

-- Find supplier pairs from same country and order by country
    select s1.companyname as supplier1, s2.companyname as supplier2, s1.country as country
    from suppliers as s1 join suppliers as s2 on s1.country = s2.country
    where s1.supplierid <> s2.supplierid
    order by s1.country

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
order by person.businessentityid desc

-- Join (Inner) productmodel, productmodelproductiondescriptionculture, productdescription and culture from the production schema.
-- Return the productmodel name, culture name, and productdescription description ordered by the product model name.
select pm.name, pc.name, description
from production.productmodel as pm inner join production.productmodelproductdescriptionculture using(productmodelid)
						  		   inner join production.productdescription using(productdescriptionid)
						  		   inner join production.culture as pc using(cultureid)
order by pm.name asc

-- Add a join to previous example to production.product and return the product name field in addition to other information.
select p.name, pm.name, culture.name, productdescription.description
from production.productmodel as pm inner join production.productmodelproductdescriptionculture using(productmodelid)
						  		   inner join production.productdescription using(productdescriptionid)
						  		   inner join production.culture using(cultureid)
								   inner join production.productmodel using(productmodelid)
								   inner join production.product as p using(productmodelid)
order by pm.name asc


-- Join product and productreview in the schema table.  Include every record from product and any reviews they have.
-- Return the product name, review rating and comments.  Order by rating in ascending order.
select p.name, r.rating, r.comments
from production.product as p left join production.productreview as r using(productid)
order by r.rating asc


-- Use a right join to combine workorder and product from production schema to bring back all products and any work orders they have.
-- Include the product name and workorder orderqty and scrappedqty fields.  Order by productid ascending
select p.name, wo.orderqty, wo.scrappedqty
from production.workorder as wo right join production.product as p using(productid)
order by p.productid asc

-- Section 9: Grouping and Aggregation
-- Lecture 46: GROUP BY
-- NOTE: Use the Northwind database unless stated otherwise
-- How many customers do we have in each county? ordered by # of customers in each country in descending order
select country, count(*) as num_of_customers
from customers group by country
order by num_of_customers desc

-- You can use GROUP BY with joins
-- What is the # of products for each category? ordered by # of products in desc order
select
	categoryname,
	count(*) as num_of_products
from categories left join products using(categoryid)
group by categories.categoryid
order by num_of_products desc

-- What is the total # of products sold for each category?
-- ordered by total # of products sold in desc order
select
		categories.categoryname,
		sum(od.quantity) as total_num_sold
from products inner join order_details as od using(productid)
			  inner join categories using(categoryid)
group by categories.categoryid
order by total_num_sold desc

-- What is the average number of items ordered for products ordered by the average amount
-- in descending order
select productname, avg(quantity) as avg_num_of_items_ordered
from products inner join order_details using(productid)
group by products.productid
order by avg_num_of_items_ordered desc

-- What is the average number of items ordered for for all the products ordered by the average amount in descending order
-- if a product does not have any orders, then the average amount should be 0
select productname, COALESCE(avg(quantity),0) as avg_quantity
from products left join order_details using(productid)
group by products.productid
order by avg_quantity desc

-- How many suppliers do we have in each country? order it by # of suppliers desc
select country, count(*) as number_of_suppliers
from suppliers group by country
order by number_of_suppliers desc

-- Total value of each product sold for year 1997 ordered by total value in descending form
select
	productname,
	sum((od.unitprice*od.quantity)-od.discount) as total_sold
from products inner join order_details as od using(productid)
			  inner join orders using(orderid)
where extract(year from orderdate) = 1997
group by products.productid
order by total_sold desc

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
	productname,
	coalesce(sum((od.unitprice * od.quantity) - od.discount), 0) as amount_sold
from products left join order_details as od using(productid)
group by products.productid
having coalesce(sum((od.unitprice * od.quantity) - od.discount), 0) < 2000
order by amount_sold asc
    -- coalesce (postgresql) == ifnull (mysql)

-- List customers that have bought more than 5000$ of products in descending order
select
		customers.companyname as buyer,
		sum((od.unitprice*od.quantity)-od.discount) as total_purchase
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
group by customers.customerid
having sum((od.unitprice*od.quantity)-od.discount) > 5000
order by total_purchase desc

-- List customers that have bought more than 5000$ of products in descending order
-- with order date in first six months of the year 1997
select
		customers.companyname as buyer,
		sum((od.unitprice*od.quantity)-od.discount) as total_purchase
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
where cast(orderdate as date) between cast('1997-01-01' as date) and cast('1997-06-30' as date)
group by customers.customerid
having sum((od.unitprice*od.quantity)-od.discount) > 5000
order by total_purchase desc

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
-- ordered by categoryname & productname
select
		categories.categoryname as category,
		products.productname as product,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from products inner join order_details as od using(productid)
			  inner join categories using(categoryid)
group by grouping sets((category),(category, product))
order by category, product

-- customer's companyname renamed as buyer
-- supplier's companymame renamed as supplier
-- Find total purchase by:
    -- buyer
    -- buyer, supplier
-- order by buyer and supplier
select
		customers.companyname as buyer,
		suppliers.companyname as supplier,
		sum((od.unitprice * od.quantity) - od.discount) as total_purchase
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join suppliers using(supplierid)
group by grouping sets((buyer), (buyer, supplier))
order by buyer, supplier
    -- note that (customers.companyname, suppliers.companyname) means for a particular buyer
    -- which supplier he ordered the products from.

-- customer companyname is called buyer
-- categories category name is called category
-- Find total sales grouped by
    -- buyer
    -- and then,
    -- buyer and category
        -- in other words, which customer ordered which category
-- order by companyname, category name with nulls first
select
		customers.companyname as buyer,
		categories.categoryname as category,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join categories using(categoryid)
group by grouping sets((buyer), (buyer, category))
order by buyer nulls first, category nulls first

-- Lecture on 49: ROLLUP(a, b) -- grouping sets ((a, b), (a), ())
-- https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUPING-SETS

-- Syntax:
    group by rollup(a, b, c)   -- is equivalent to:
    group by grouping sets ((), (a), (a, b), (a, b, c))

-- Use case: This is commonly used for analysis over hierarchical data; e.g.,
-- total salary by department, division, and company-wide total

-- Do a rollup with total_sales of customer, categories and products
-- order by  customer, categories and products
select	companyname as customer,
		categoryname as category,
		productname as product,
		sum((od.unitprice*od.quantity)-od.discount) as total_sales
from customers inner join orders using(customerid)
			   inner join order_details as od using(orderid)
			   inner join products using(productid)
			   inner join categories using(categoryid)
group by rollup(customer, category, product)
order by customer, category, product


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


-- Section 10: Combining queries
-- Lecture 51: UNION
-- documentation: https://www.postgresql.org/docs/13/sql-select.html
-- Purpose of UNION: Combine the results of 2 or more queries
-- Syntax:
    select <column1>, <column2>, ...
    from table1

    union  --> removes duplicates

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
select city from customers
union distinct
select city from suppliers

-- distinct counties of all customers and suppliers in alphabetical order
select country from customers
union distinct
select country from suppliers
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

    intersect  --> removes duplicates

    select <column1>, <column2>
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

-- ??? Find the number of customer & supplier pairs that are in the same country
-- Refer to the Q/A for Lecture 52, there is a Q with a title:
-- Finding the number of customer & supplier pairs that are in the same country
select count(*) from
(select country from customers
intersect all
select country from suppliers) as combined

-- how many distinct countries have both customers and suppliers
select count(*) from (
	select country from customers
	intersect distinct
	select country from suppliers
) as x

-- Distinct cities that have customers and suppliers located in
-- e.g. NY has 2 customers & 3 suppliers
--      Helsinki has 4 customers & 1 supplier
--      Istanbul has 1 customer & 0 supplier
-- Outcome: cities -> Ny, Helsinki
select city from customers
intersect distinct
select city from suppliers

--(???) the count of number of customers and suppliers pairs that are in the same city
select count(*) from
(select city from customers
intersect all
select city from suppliers) as customer_supplier_pairs


-- Lecture 53: EXCEPT
-- documenation: https://www.postgresql.org/docs/13/sql-select.html
-- Purpose: Find the items in the first query but not in the second one
-- Syntax:
    select <column1>, <column2>, ...
    from table1

    except  --> removes duplicates (e.g. except distinct)

    select <column1>, <column2>
    from table2
-- must have same number of columns
-- column types must line up

-- Find all countries that we have customers in but no suppliers
-- order by country in asc
select country from customers
except distinct
select country from suppliers
order by country asc

-- Find the number of customers within a country without suppliers
select count(*) from
(select country from customers
 except all
 select country from suppliers
) as customers_without_suppliers

-- Cities which have a supplier with no customer
select city from suppliers
except distinct
select city from customers

-- How many customers do we have in cities without suppliers
select count(*) from
(select city from customers
 except all
 select city from suppliers) as cities_with_customers_without_suppliers


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
   select
	companyname, contactname
    from customers as c left join (
	    select distinct customerid from customers inner join orders using(customerid)
	    where orderdate::date between '1997-04-01'::date and '1997-04-30'::date
    ) as x using(customerid)
    where x.customerid is null
    order by companyname asc, contactname asc

-- What products did not have an order in April, 1997.
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
    select productname
    from products left join (
        select distinct productid
        from products inner join order_details using(productid)
                    inner join orders using(orderid)
        where orderdate::date between '1997-04-01'::date and '1997-04-30'::date
    ) as x using(productid)
    where x.productid is null
    order by productname asc

    -- or it can be done using WHERE NOT EXISTS (Correctly working!)
    -- Solution 2:
    select
        productname
    from products as p
    where not exists(
        select productid
        from order_details as od inner join orders using(orderid)
        where od.productid = p.productid and
        cast(orderdate as date) between cast('1997-04-01' as date) and cast('1997-04-30' as date)
    )
    order by productname asc;

-- Find all suppliers with a product that costs more than 200$
-- Solution 1:
select distinct companyname
from suppliers inner join products using(supplierid)
where unitprice > 200

    -- Solution2:
    select companyname
    from suppliers as s where exists(
	select productid from products as p
	where s.supplierid = p.supplierid and
	unitprice > 200
    )

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
    select companyname
    from suppliers as s
    where not exists(
        select distinct supplierid
        from products as p inner join order_details using(productid)
                    inner join orders using(orderid) 	
        where orderdate::date between '1996-12-01'::date and '1996-12-31'::date
        and s.supplierid = p.supplierid
    )
    order by companyname asc


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

    -- Solution 2: Using joins only
    select distinct companyname
    from suppliers inner join products using(supplierid)
			   inner join order_details using(productid)
    where quantity = 1
    order by companyname asc

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

-- Find products which has order quantity that are
-- higher than the average of all the products
-- order by product name in ascending fashion
select distinct productname
from products inner join order_details using(productid)
where quantity > all(
	select avg(quantity)
	from products as p inner join order_details using(productid)
	group by p.productid
)
order by productname asc

-- Find products which has order AMOUNT ($) that are
-- higher than the average of all the products
-- order by product name in ascending fashion
    select distinct productname
    from products inner join order_details as od using(productid)
    where (od.unitprice * quantity) > all (
        select round(cast(avg(od.unitprice * quantity) as numeric), 2)
        from products as p inner join order_details as od using(productid)
        group by p.productid
    )
    order by productname asc

-- Find all distinct customers that ordered more than 1 item
-- than the average order amount per item of all customers
select distinct companyname
from customers inner join orders using(customerid)
			   inner join order_details using(orderid)
where (unitprice*quantity) > all(
	select avg(unitprice*quantity)
	from orders inner join order_details using(orderid)
	group by customerid
)
    -- My interpretation:
    -- Find all the distinct customers, which made a purchase with
    -- an amount greater than that of the averages of all the customers

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
SELECT companyname
FROM customers
WHERE country IN (SELECT DISTINCT country FROM suppliers);


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
                    values (11078, 11, 14, 20, 0)

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
where orderid = 11078

-- update the order_details row we created in Lecture 57
    -- orderid= 11078 and quantity=20 and productid=11
-- They also want 40 Queso Cabrales instead of 20
-- and we are giving a discount of 0.05
update order_details
set quantity=40, discount=0.05
where orderid= 11078 and quantity=20 and productid=11

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
where orderid= 11078 and quantity=40 and productid=11

-- delete the order entry created in Lecture 57
delete from orders where orderid=11078

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
where country in ('USA', 'Canada')


-- Backup orders in the year 1997 to a new table orders_1997
select *
into table orders_1997
from orders
where orderdate::date between '1997-01-01'::date and '1997-12-31'::date

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
where country in ('Brazil', 'Argentina')

-- Add orders from December 2016 to the table orders_1997
insert into orders_1997
select *
from orders
where orderdate::date between '2016-12-01'::date and '2016-12-31'::date

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
returning unitprice, productid

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
-- Indexes are data structures attached to specific fields/columns
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
on employees(employeeid)

-- on orders create a single index on two fields customerid and orderid
create index idx_orders_customerid_orderid
on orders(customerid, orderid)

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
EXPLAIN ANALYZE SELECT *
FROM  performance_test
WHERE location LIKE 'df%' AND name LIKE 'cf%';

CREATE INDEX idx_performance_test_location_name
ON performance_test(location,name);

-- takes 55 ms
EXPLAIN SELECT *
FROM  performance_test
WHERE location LIKE 'df%' AND name LIKE 'cf%';

-- order matters with searches with one column
    -- this can't use index
    EXPLAIN ANALYZE SELECT *
    FROM  performance_test
    WHERE  name LIKE 'cf%';

    -- this can
    EXPLAIN ANALYZE SELECT *
    FROM  performance_test
    WHERE location LIKE 'df%';


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
EXPLAIN select *
from production.product
WHERE name LIKE 'Flat%';

-- this is back to sequential scan
-- "Seq Scan on product  (cost=0.00..17.56 rows=3 width=139)"
EXPLAIN select *
from production.product
WHERE UPPER(NAME) LIKE UPPER('Flat%');

-- create an expression scan
CREATE INDEX idx_product_upper_name
ON production.product (UPPER(name));

-- now we get a bitmap index scan
-- "  ->  Bitmap Index Scan on idx_product_upper_name  (cost=0.00..4.30 rows=3 width=0)"
EXPLAIN select *
from production.product
WHERE UPPER(NAME) LIKE UPPER('Flat%');

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

-- Northwind database
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

-- Northwind database
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

-- Lecture 95 : CHECK constraint
-- syntax:
create table table_name (
    column1 datatype,
    column2 datatype CONSTRAINT constraint_name CHECK (condition)
    ...
    constraint constraint_name check (condition)
)

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

-- add constraint to orders table that freight must be more than 0
alter table orders
add constraint orders_freight_check
check(freight > 0);

-- add a CHECK constraint that unitprice in products table must be positive
alter table products
add constraint products_unitprice_check
check(unitprice > 0);

-- Lecture 96: DEFAULT constraint
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
create table practices (
    practiceid int primary key,
    practice_field varchar(50) not null,
    employeeid int not null,
    cost int constraint practices_cost_check check(cost >= 0 and cost <= 1000) default 50,
    foreign key (employeeid) references employees(employeeid)
);

-- Re-create pets table with 4 fields:
-- petid integer that is the primary key with auto increment
-- name varchar(25) and must not have null values
-- customerid char(5) which cannot be null and a foreign key from customers table
-- wieght integer which has to be greater than 0 and less than 200, default 5
drop table if exists pets;
create table pets (
    petid serial primary key,
    name varchar(25) not null,
    customerid char(5) not null,
    weight integer default 5 constraint pets_weight_check check(weight > 0 and weight < 200),
    foreign key (customerid) references customers(customerid)
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
alter table products alter column discontinued drop not null

-- add a check constraint to table order_details column unitprice to make sure it is a positive number
alter table order_details add check(unitprice > 0)  --> creates order_details_unitprice_check constraint
   -- remove the constraint:
   alter table order_details drop constraint order_details_unitprice_check

-- add a not null constraint to discount column in order_details table
alter table order_details alter column discount set not null
    -- remove the constraint
    alter table order_details alter column discount drop not null

-- Section 17 : Sequences
-- Lecture 99:
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
    -- Lesson learned: If you want to set a default value to a field with the nextval from a sequence, you need to do 2 things in the following order:
        -- (1) attach the sequence to the field in the table; make the field own the sequence
        -- (2) make nextval of the sequence set the default value to the field

-- Docs: http://www.neilconway.org/docs/sequences/
-- Lesson learned:
-- serial = int + auto increment (+ not null)
-- to accomplish auto increment part in serial, postgresql creates a sequence behind the scenes:
    -- serial indicates that the values for the column will be generated by consulting the sequence
    -- therefore, it creates a new sequence object, and sets the default value for the column to be the next value produced by the sequence
    -- since a sequence always produces non-NULL values, it adds a NOT NULL constraint to the column
-- So, there is a relation between serial & automatically created sequence

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
    create sequence table_name_field_name_seq;
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

-- Section 18: Common Table Expressions (CTE) (i.e. With Queries)
-- Doc: https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-SELECT
-- Syntax:
with cte_name as (
    select statement
)
select statement that includes cte_name from with part
-- CTE creates temporary table that is used just for the current query

-- We want to find out the number of units ordered and amount of sales
-- for all the products from the top three categories by total_sales
-- grouped by category & product
-- ordered by category & product
-- The desired end result:
-- categoryname, productname, units_ordered, total_sales
with top_three_categories_by_total_sales as (
	select
		categories.categoryid,
		sum((od.quantity*od.unitprice)-od.discount) as total_sales
	from categories inner join products using(categoryid)
					inner join order_details as od using(productid)
	group by categories.categoryid
	order by total_sales desc limit 3
)
select categoryname, productname,
	   sum(quantity) as units_ordered,
	   sum((od.quantity*od.unitprice)-od.discount) as total_sales
from categories inner join products using(categoryid)
				inner join order_details as od using(productid)
where categories.categoryid in (select categoryid from top_three_categories_by_total_sales)
group by categoryname, productname
order by categoryname, productname
   -- Observation: you need to find top three categories by total_sales first;
   -- this is your subquery. CTE/With query enables you to name that subquery and refer
   -- to the temporary table CTE yields. In the main query,
   -- you can refer to the CTE (e.g. top_three_categories_by_total_sales )
   -- filter out the rows you need:
        where categoryname in (select categoryname from top_three_categories_by_total_sales)

-- we want a list of customers, who ordered the 2 least ordered products
-- (we want to see if we will loose any important customer if we quit
-- carrying those 2 products)
with two_least_ordered_products as (
	select products.productid,
		   sum(quantity) as units_ordered
	from products inner join order_details using(productid)
	group by products.productid
	order by units_ordered asc limit 2
)
select distinct companyname
from customers inner join orders using(customerid)
	 		   inner join order_details using(orderid)
where productid in (select productid from two_least_ordered_products)

-- Lecture 103: Using CTE to grab identity field from insert
-- Refer to Northwind Database
-- Common Problem: I just inserted a record with id field: inserted an order
-- and need orderid field for order_details records. How do i grab the orderid for the order
-- and use for further inserts into order_details records

-- below 3 lines re-starts orders_orderid_seq from the right value
select currval('orders_orderid_seq');  --> returns 200007
select max(orderid) from orders;       --> returns 11078
alter sequence orders_orderid_seq restart with 11079;

WITH new_order AS (
	INSERT INTO orders
	(customerid, employeeid, orderdate, requireddate)
	VALUES ('ALFKI', 1, '1997-03-10', '1997-03-25')
	RETURNING orderid
)
INSERT INTO order_details (orderid, productid, unitprice, quantity, discount)
SELECT orderid, 1, 20, 5, 0
FROM new_order;
    -- note: in order the insert to orders to work, you need to have orders_orderid_seq
    -- sequence attached to orders table's orderid field
    -- get the order we just inserted
    SELECT * FROM orders
    ORDER BY orderid DESC
    LIMIT 1;
    -- get the order_detail we just inserted
    SELECT * FROM order_details
    WHERE orderid = (SELECT MAX(orderid) FROM orders);


-- modify employees_employeeid_seq to point to the largest value in employeeid field in employees table
-- create a new employee record yielding employeeid
-- then use the returned employeeid in creating a new order
select max(employeeid)+1 from employees;  --> 11
alter sequence employees_employeeid_seq restart with 11;
with new_employee as (
    insert into employees(lastname, firstname, title, reportsto)
    values ('Doger', 'Roger', 'Assistant', 2)
    returning employeeid
)
insert into orders(customerid, employeeid, orderdate, requireddate)
select 'ALFKI', employeeid, '1997-03-10'::date, '1997-03-25'::date
from new_employee;
    -- get the latest employee just inserted
    select * from employees
    order by employeeid desc limit 1;
    -- get the latest order just inserted
    select * from orders where employeeid = (select max(employeeid) from employees);


-- Lecture 104 : Creating hierarchical data to use with recursive WITH queries
-- Using the Northwind database:
        delete from orders where employeeid = 11;  -- delete the order we created in the previous lecture

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
    -- Execute the non-recursive term to create the base result set (R0).
    -- Execute recursive term with Ri as an input to return the result set Ri+1 as the output.
    -- Repeat step 2 until an empty set is returned. (termination check)
   --  Return the final result set that is a UNION or UNION ALL of the result set R0, R1, … Rn

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
    select t-2 from my_set where t > 2
)
select * from my_set

-- Find everyone that the CEO is responsible for (employeeid = 200)
with recursive bosses as (
    select employeeid, firstname, lastname from employees
    where employeeid = 200
    union all
    select e.employeeid, e.firstname, e.lastname
    from employees as e inner join bosses as b on e.reportsto = b.employeeid
)
select * from bosses

-- Find the chain of command from Dudlye Kiona (employeeid = 218) up to the CEO (employeeid = 200)
with recursive reports_to as (
    select employeeid, reportsto, firstname, lastname
    from employees where employeeid = 218
    union all
    select boss.employeeid, boss.reportsto, boss.firstname, boss.lastname
    from employees as boss inner join reports_to on reports_to.reportsto = boss.employeeid
)
select * from reports_to;

-- Section 19: Views
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

-- create a view called suppler_order_details that shows all orders and order_details
-- Then select all the order_details for supplierid = 5
create view suppler_order_details as
select s.supplierid, s.companyname, s.contactname, s.contacttitle, s.address, s.city, s.region, s.postalcode, s.country, s.phone, s.fax, s.homepage,
       p.productid, p.productname, p.categoryid, p.quantityperunit, p.unitprice as product_unitprice, p.unitsinstock, p.unitsonorder, p.reorderlevel, p.discontinued,
       od.unitprice as order_unitprice, od.quantity, od.discount,
       o.orderid, o.customerid, o.employeeid, o.orderdate, o.requireddate, o.shippeddate, o.shipvia, o.freight, o.shipname,
       o.shipaddress, o.shipcity, o.shipregion, o.shippostalcode, o.shipcountry
from suppliers as s inner join products as p using(supplierid)
               inner join order_details as od using(productid)
               inner join orders as o using(orderid)
select * from suppler_order_details where supplierid = 5

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
CREATE VIEW north_america_customers AS
SELECT *
FROM customers
WHERE country in ('USA','Canada','Mexico');
    -- !!! OBSERVATION: data can be inserted via the updatable view to the table the view refers
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
    -- can do the update, otherwise not
    update protein_products set productname='Fake Nose' where productid=78;
    -- delete the newly created product; note that row with productid=78 has a categoryid of 6; included in the view;
    -- can do the deletion, otherwise not
    delete from protein_products where productid=78
    -- check that the newly created product is deleted
    select * from protein_products where productid = 78
-- Observations:
-- create view has a where clause, lets call it where_clause_1
    -- via the view, ANY row not belonging to where clause_1 can be inserted
        -- e.g. a product with categoryid is 1 can be inserted along with categoryid being 6
-- update view has a where clause, lets call it where_clause_2
-- delete view has a where clause, lets call it where_clause 3
    -- when updating a row(s) from the view, if where_clause_2 & where_clause_1 yields a row(s), then updating takes place. Otherwise, no updating takes place
        -- in other words, the to be updated rows must be part of the view in order the update to happen; the view acts as a filter
    -- when deleting a row(s) from the view, if where_clause_3 & where_clause_1 yields a row(s), then deletion takes place. Otherwise, no deletion takes place
        -- i.e. if the inserted product in (1) had a categoryid 1 (i.e. bad data), the product would not be part of the view (view expects categoryid to be 4,6,8)
        -- any update & delete operation via the view would do nothing for the product
            -- Observation: bad data can be inserted via the view, unless CHECK OPTION is added to the view. We will address the CHECK OPTION next

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
    SELECT FROM customers
    WHERE customerid=’CFDCM’;

-- How to prevent inserting data that does not belong to an updateable view via the view?
-- Answer: By using WITH CHECK OPTION
-- Syntax:
    with local check option    --> if the updatable view is not cascaded to another updatable view(s)
    with cascaded check option --> if the updatable view is cascaded to another updatable view(s)
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
           else default
end

-- Pull back orders with orderid, customerid and year1 of orderdate is 1996,
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
-- instead of null values:
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
