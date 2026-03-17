-- Creating and Using Database videogame_sales

CREATE DATABASE videogame_sales;
USE videogame_sales;

-- Creating Table sales_data
CREATE TABLE sales_data (
    sales_id BIGINT PRIMARY KEY,
    title VARCHAR(255),
    console VARCHAR(50),
    genre VARCHAR(100),
    publisher VARCHAR(255),
    developer VARCHAR(255),
    total_sales FLOAT,
    na_sales FLOAT,
    jp_sales FLOAT,
    pal_sales FLOAT,
    other_sales FLOAT,
    release_date DATE,
    release_year INT,
    release_month VARCHAR(20)
);

-- Importing Data From Cleaned CSV File 

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Downloads/Video+Game+Sales/Cleaned_VideoGameSalesData.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
sales_id,
title,
console,
genre,
publisher,
developer,
total_sales,
na_sales,
jp_sales,
pal_sales,
other_sales,
@release_date,
release_year,
release_month
)
SET release_date = STR_TO_DATE(TRIM(@release_date), '%d-%m-%Y');

-- CHECKING IMPORTED DATA

SELECT * FROM sales_data LIMIT 100;


-- Video Game Sales Analysis

-- OVERALL MARKET ANALYSIS
-- 1.What is the total global sales of all games?

SELECT ROUND(SUM(total_sales), 2) 
AS total_global_sales
FROM sales_data;

-- 2.Which are the top 10 best-selling games globally?

SELECT title, console, ROUND(SUM(total_sales),2) AS total_sales
FROM sales_data
GROUP BY title, console
ORDER BY total_sales DESC
LIMIT 10;

-- REGIONAL INSIGHTS

-- Which region contributes the most to total sales?
SELECT 
    ROUND(SUM(na_sales),2) AS NA_sales,
    ROUND(SUM(jp_sales),2) AS JP_sales,
    ROUND(SUM(pal_sales),2) AS PAL_sales,
    ROUND(SUM(other_sales),2) AS Other_sales
FROM sales_data;

-- Which games are top-selling in each region?
-- North America
SELECT title, ROUND(SUM(na_sales),2) AS na_sales
FROM sales_data
GROUP BY title
ORDER BY na_sales DESC
LIMIT 5;

-- JAPAN
SELECT title, ROUND(SUM(jp_sales),2) AS jp_sales
FROM sales_data
GROUP BY title
ORDER BY jp_sales DESC
LIMIT 5;

-- EUROPE(PAL)
SELECT title, ROUND(SUM(pal_sales),2) AS pal_sales
FROM sales_data
GROUP BY title
ORDER BY pal_sales DESC
LIMIT 5;


-- PLATFORM / CONSOLE ANALYSIS
-- 5.Which consoles have the highest total sales?
SELECT console, ROUND(SUM(total_sales),2) AS total_sales
FROM sales_data 
WHERE total_sales> 0
GROUP BY console
ORDER BY total_sales DESC;

-- 6.Which consoles have the highest average sales per game?
SELECT console, ROUND(AVG(total_sales),2) AS avg_sales
FROM sales_data
GROUP BY console
ORDER BY avg_sales DESC
LIMIT 10;


-- GENRE ANALYSIS

-- Which genres generate the highest total sales?

SELECT genre, ROUND(SUM(total_sales),2) AS total_sales
FROM sales_data
GROUP BY genre
ORDER BY total_sales DESC
LIMIT 10;

-- Which genre is most popular in each region?

SELECT genre,
       ROUND(SUM(na_sales),2) AS NA,
       ROUND(SUM(jp_sales),2) AS JP,
       ROUND(SUM(pal_sales),2) AS PAL
FROM sales_data
GROUP BY genre
ORDER BY NA DESC
LIMIT 10;

-- TIME-BASED ANALYSIS

-- How have total game sales changed over the years?
SELECT release_year, ROUND(SUM(total_sales),2) AS total_sales
FROM sales_data
GROUP BY release_year
ORDER BY release_year;

-- Which year had the highest total sales?
SELECT release_year, ROUND(SUM(total_sales),2) AS total_sales
FROM sales_data
GROUP BY release_year
ORDER BY total_sales DESC
LIMIT 1;

-- PUBLISHER ANALYSIS

-- Which publishers generate the highest total sales?
SELECT publisher, ROUND(SUM(total_sales),2) AS total_sales
FROM sales_data
GROUP BY publisher
ORDER BY total_sales DESC
LIMIT 10;

-- Which publisher has the highest average sales per game?
SELECT publisher, ROUND(AVG(total_sales),2) AS avg_sales
FROM sales_data
GROUP BY publisher
ORDER BY avg_sales DESC
LIMIT 5;

-- TOP DEVELOPERS

SELECT developer, ROUND(SUM(total_sales),2) AS total_sales
FROM sales_data
GROUP BY developer
ORDER BY total_sales DESC
LIMIT 5;

