use walmartsales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select * from sales;

-- Add the time_of_day column --
select time,
(case when time between "00:00:00" and "12:00:00" then "Morning"
	 when time between "12:01:00" and "16:00:00" then "Afternoon"
     else "Evening"
end)
as "time_of_day"
from sales;

alter table sales add column time_of_day varchar(20);

select * from sales;

update sales
set time_of_day = case 
when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end;

select * from sales;

-- Add day_name column --
select date, dayname(date) from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

select * from sales;

-- Add month_name columns --

select date, monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);
select *
from sales;

-- How many unique cities does the data have?--
select distinct city
from sales;

-- In which city is each branch?--
select distinct city, branch
from sales;

-- How many unique product lines does the data have? --
select 
distinct product_line
from sales;

-- What is the most selling product line --
select sum(quantity) qty,
product_line
from sales
group by product_line
order by qty DESC;

-- what is the total revenue by month --
select 
month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue;

-- What month had the largest COGS? --
select month_name as month,
sum(cogs) as cogs
from sales
group by month
order by cogs;

-- What product line had the largest revenue? --
select
product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue;

-- What product line had the largest VAT? --
select 
product_line,
avg(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax;

-- What is the city with the largest revenue? --
select city, branch,
sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue;

-- Fetch each product line and add a column to those product --
select avg(quantity) as qty
from sales;

-- line showing "Good", "Bad". Good if its greater than average sales --
select product_line,
case 
When avg(quantity) > 6 then "Good"
else "Bad"
end as remark
from sales
group by product_line;

-- Which branch sold more products than average product sold? --
select branch,
sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender --
select gender,
product_line,
count(gender) as total_gender
from sales
group by gender, product_line
order by total_gender DESC;

-- What is the average rating of each product line --
select 
round(avg(rating), 2) as avg_rating, product_line
from sales
group by product_line
order by avg_rating DESC;

-- How many unique customer types does the data have? --
select 
distinct customer_type
from sales;

-- How many unique payment methods does the data have? --
select 
distinct payment
from sales;

-- What is the most common customer type? --
select
customer_type,
count(*) as count
from sales
group by customer_type
order by count DESC;

-- Which customer type buys the most?
select customer_type,
count(*)
from sales
group by customer_type; 

-- What is the gender of most of the customers? --
select gender,
count(*) as total_gender
from sales
group by gender 
order by total_gender DESC;


-- What is the gender distribution per branch? --
select 	
gender, count(*) as gender_total
from sales 
where branch = "C"
group by gender
order by gender_total DESC;

-- Which time of the day do customers give most ratings? --
select time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating DESC;

-- Which time of the day do customers give most ratings per branch? --
select time_of_day,
avg(rating) as avg_rating
from sales
where branch = "A"
group by time_of_day
order by avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
select day_name, 
count(day_name) total_sales
from sales
where branch = "C"
group by day_name
order by total_sales DESC;

-- Number of sales made in each time of the day per weekday --
select 
time_of_day,
count(*) as total_sales
from sales
where time_of_day = "Sunday"
group by time_of_day
order by total_sales;

-- Which day fo the week has the best avg ratings?
select day_name, 
avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating DESC;