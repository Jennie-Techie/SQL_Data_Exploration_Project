-- MovieNow wants to make some short term business/ operational decisions such as 'What movies to invest in?'  They also want to see the revenue to know how 
-- much to budget for the upcoming month. 
-- In order to achieve this, the accounts subdivision and the Customer Relationship Management subdivision have come up with some KPIs. 
-- For the accounts department, the main KPI is the Total number of rentals: revenue (For MovieNow, revenue is calculated as the sum of the prices for rented movies)
-- while for the CRM subdivision, the KPI are
-- 1. CUSTOMER SATISFACTION which is calculated below as:The average rating of all movies: customer satisfaction 
-- 2. CUSTOMER ENGAGEMENT which is calculated below as: Number of active customers in a certain time period 

-- As the data analyst, I am to help the CRM make sense of the data they have collected in the past few months. I am meant to help them see if their
-- data shows that they have met their KPIs. This insight would then be shared with the managers and the accounts department so they can make informed decisions. 

-- STEPS
-- The first thing I'm going to do is explore the Table for Renting. 
-- I would check to see if there are null values and if my data is clean

USE movie_now;
-- Check for null values in the rating column
-- Not sure if this code is good enough
-- The nut null is not working because in creating my table, I did not specify not null values. I need to work on my table creation
-- ------------------------------------------------------------------------
-- ------------------------------------EXPLORING THE DATA
-- 1. Choose only the columns which do not have a null value in their ratings. This is because the ratings have to be there in order to be able to measure
-- customer satisfaction. Use the WHERE clause to set the condition. In order words, I should say
-- Select only the records that have a rating
SELECT * 
FROM rentings
WHERE rating IS NOT NULL;
-- This returned 328 records

-- 2. Show all the customers in the renting database.   
SELECT DISTINCT (customer_id)
FROM rentings
ORDER BY customer_id;
-- ---------------------------------- 
-- 3. Count the total number of customers who have been active in the past 3 years (2017 - 2019)
SELECT COUNT( DISTINCT customer_id) AS Active_customers
FROM rentings;
-- The total number of customers who rented movies in the past 3 years are 116. 

-- ----
-- It is known that not all customers give a rating after watching a movie, hence we have missing values in the rating 
-- ---
--  --------------------------------------


-- 4. Check to see the total number of customers who gave the highest rating (10)
SELECT * 
FROM rentings
WHERE rating = 10;
-- TO COUNT THEM
SELECT COUNT(customer_id)
FROM rentings
WHERE rating = 10 ;

-- ----------------------------
-- 5. Check to see how many customers were 100% disatified with the movies
SELECT COUNT(customer_id)
FROM rentings 
WHERE rating = 1;
-- Only 1 customer was totally unsatisfied. 
-- ----------------------------
-- 6. Check to see how many customers had a rating less than 3
SELECT COUNT(customer_id)
FROM rentings
WHERE rating BETWEEN 1 AND 4;
-- Only 7 customers have poor movie satisfaction. 

-- ---------------------------
-- Let us look at the ratings in descending order
SELECT *
FROM rentings
WHERE rating >=1;

-- Check to see the whole table
SELECT *
FROM rentings;

-- --------------------------- JOINING TABLES
-- Here I should say that I have to formulate business questions 
-- Which movies have the highest rating? 
-- Who are the actors in those movies?
-- What is the renting price?
-- What genre are the movies?
-- What nationality are the actors?
-- What's the year of release?
-- All these questions are answered by using an inner join of 4 tables which are: the renting table, movies table, actsin table and actors table. 
-- From these query below, the most rated actors, movies and the year of release are seen. 

SELECT r.date_renting AS Renting_Date, 
	   m.title AS Movie_Title, 
       m.genre As Movie_Genre,
       a.name AS Actor_Name,
       a.nationality AS Actor_Nationality,
       m.year_of_release,
       m.renting_price,
       r.rating
FROM rentings r
JOIN movies m
	ON r.movie_id = m.movie_id
JOIN actsin ac 
    ON r.movie_id = ac.movie_id
JOIN actors a 
	ON ac.actor_id = a.actor_id
 WHERE rating = 10
 ORDER BY renting_date DESC;

-- ------ HERE THE FOCUS IS ON THE MOVIES. The manager wants to see the top rated movies in 2019, the renting price, the movie genre, the actors and nationality
-- Check to see the top rated movies in 2019 only
SELECT DISTINCT m.title AS Top_Rated_Movies_2019,
       r.date_renting AS Renting_Date,
       m.genre As Movie_Genre,
       a.name AS Actor_Name,
       a.nationality AS Actor_Nationality,
       m.year_of_release,
       m.renting_price,
       r.rating
FROM rentings r
JOIN movies m
	ON r.movie_id = m.movie_id
JOIN actsin ac 
    ON r.movie_id = ac.movie_id
JOIN actors a 
	ON ac.actor_id = a.actor_id
 WHERE rating = 10 
 AND date_renting >= '2019-01-01';
-- Check how MovieNow has performed in each year 2017, 2018 and 2019

-- Check to see the Average renting price
SELECT AVG(renting_price)
FROM movies;


-- ----------------------- QUESTIONS
-- 1. What movie genres had the highest rating? In each year
-- 2. What movie genre had the lowest rating?  In each year
-- 3. Are there visible trends which can be reported to management?
-- 4. What genre of movies had the higest renting price? Who was the actor and how much was it?
-- 5. What's the average renting price?

-- -------------------------------- SOME NOTES
-- For decision making, we should be looking at summary of certain groups instead of individual records. 
-- What is the average rating for each year? each genre? 
SELECT AVG(rating)
FROM rentings
WHERE date_renting >= '2019-01-01';

-- What is the average price of renting a movie?
SELECT AVG(renting_price)
FROM rentings r
JOIN movies m
	ON r.movie_id = m.movie_id
JOIN actsin ac 
    ON r.movie_id = ac.movie_id
JOIN actors a 
	ON ac.actor_id = a.actor_id
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31';

-- ----------------
-- Let's Learn More about our Customers to improve marketing campaigns
-- Check the age demographics to see which age group really watches their movies, that way marketing campaigns can be targeted at them
SELECT *
FROM customers
ORDER BY date_of_birth;

-- How many customers does MovieNow have?
SELECT COUNT(customer_id)
FROM customers; -- Total number of customer is 123

-- Get the number of customers born in the 70s, 80s, 90s
-- ---------
-- Counting the customers born in the 70s
SELECT COUNT(customer_id)
FROM customers
WHERE date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'; -- Total customers customers born in the 70s are 38

-- Counting the customers born in the 80s
SELECT COUNT(customer_id)
FROM customers
WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31'; -- Total count is 34

-- Counting the customers born in the 90s
SELECT COUNT(customer_id)
FROM customers
WHERE date_of_birth BETWEEN '1990-01-01' AND '1999-12-31'; -- Total count is 51

-- Checking the customers data to see the country that has the highest customers

-- Count the total number of countries where MovieNow has customers
SELECT COUNT(DISTINCT country)
FROM customers; -- Total number of countries where MovieNow has customers is 11. 

-- List all the countries where MovieNow has customers
SELECT DISTINCT country
FROM customers;




-- ------ PREPARE A REPORT ABOUT THE DEVELOPMENT OF THE COMPANY
-- SPECIFICALLY, YOUR MANAGER IS INTERESTED IN THE TOTAL NUMBER OF MOVIE RENTALS, THE TOTAL NUMBER OF RATINGS AND THE AVERAGE RATING OF ALL MOVIES SINCE THE 
-- BEGINNING OF 2019
-- ------------------------ ANSWER: 
-- STEP 1:
-- Select all records of movie rentals since January 1st, 2019
SELECT * 
FROM rentings
WHERE date_renting BETWEEN '2019-01-01' AND '2019-12-31';

-- STEP 2
-- Count the number of movie rentals and calculate the average rating since the beginning of 2019
SELECT COUNT(renting_id) AS Total_Movie_Rentals,
AVG(rating) AS Average_Rating
FROM rentings
WHERE date_renting >= '2019-01-01';

-- STEP 3
-- Count the number of ratings since the beginning of 2019
SELECT COUNT(renting_id) AS Total_Movie_Rentals,
AVG(rating) AS Average_Rating,
COUNT(rating) AS Total_Rating
FROM rentings
WHERE date_renting >= '2019-01-01';


-- --------- ANALYZING THE CUSTOMERS. 
-- What country has the highest customers?
-- How many countries does MovieNow operate in?
-- How many customers where born in the 70s, 80s or 90s? 



-- ----------- GROUPING MOVIES ------------------- 
-- -----------------------------------------------  
-- USING GROUP BY

-- We could group movies by genres, countries, 

-- Group by genre
SELECT *
FROM movies 
GROUP BY genre;

-- Average price of renting movies per genre
SELECT genre, AVG(renting_price) AS avg_price
FROM movies
GROUP BY genre
ORDER BY avg_price DESC;

-- How many movies are in each category?
SELECT genre, AVG(renting_price) AS avg_price, COUNT(*) AS number_of_movies
FROM movies
GROUP BY genre;

-- Using the HAVING CLAUSE to set a condition
SELECT genre, AVG(renting_price) AS avg_price, COUNT(*) AS number_of_movies
FROM movies
GROUP BY genre
HAVING COUNT(*) >2;

-- ----------------------------------------
-- ---------------------------------------
-- Conduct an analysis to see when the first customer accounts were created for each country
-- Step 1: Create a table with a row for each country and the date when the first customer account was created
-- Group by the country
-- Order the date by ascending order
SELECT MIN(date_account_start) AS First_Account, country
FROM customers
GROUP BY country
ORDER BY First_Account;

-- -----------------------------------
-- -----------------------------------
-- Report the average ratings, the number of ratings and the number of views for each movie.
-- Step 1: Grouping the data in the renting table by movie_id 
SELECT movie_id,
	AVG(rating) AS avg_rating,
    COUNT(rating) AS number_rating,
    COUNT(*) AS number_rentals
FROM rentings
GROUP BY movie_id;

-- Get the average movie ratings by customers, the number of ratings by customer and the number of rentals by customer for only customers 
-- who have above 7 movie rentals

SELECT customer_id,
	AVG(rating) AS avg_renting,
	COUNT(rating) AS number_rating,
    COUNT(*) AS number_rentals
FROM rentings
GROUP BY customer_id
HAVING COUNT(*) > 7
ORDER BY customer_id;


-- -------------------------- JOINS
-- -------------------LEFT JOINS
-- The management of MovieNow wants to report key performance indicators (KPIs) for the performance of the company in 2018. 
-- They are interested in measuring the financial successes as well as user engagement. 
-- Important KPIs are, therefore, the profit coming from movie rentals, the number of movie rentals and the number of active customers.

SELECT COUNT( DISTINCT customer_id) AS Active_customers
FROM rentings;
-- The total number of customers who rented movies in the past 3 years are 116. 

-- Step 1: Use a LEFT JOIN to join the rentings table and the movies table
SELECT *
FROM rentings r
LEFT JOIN movies m
ON r.movie_id = m.movie_id;

-- Step 2: Next is to write a query which calculates the revenue from movie rentals, the total number of active customers and the total number of rentals
SELECT SUM(m.renting_price) AS Total_Revenue,
		COUNT(DISTINCT r.customer_id) AS Active_Customers,
        COUNT(r.renting_id) AS Total_Rentals
FROM rentings r
LEFT JOIN movies m
ON r.movie_id = m.movie_id
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31';
-- The 2018 Report: 
-- Total Revenue is 687
-- Active Customers are 93
-- Total Rentals are 298

-- Give an overview of the actors in the movie
-- First use a left join to join the rentings table and the movies table. Then use another LEFT JOIN to join the ACTSIN table
SELECT m.title AS Movie_Title,
		m.year_of_release,
		ac.name AS Actor,
        ac.year_of_birth,
        ac.nationality
FROM rentings r
LEFT JOIN movies m
	ON r.movie_id = m.movie_id
LEFT JOIN actsin a 
	ON r.movie_id = a.movie_id
LEFT JOIN actors ac
	ON a.actor_id = ac.actor_id;

-- -----------------
-- -------------SUBQUERIES
-- Subssquent SELECT statements

-- How much money did each customer spend?
-- How much income did each movie generate?
-- Step 1: Join the movies table and the renting table (left join)
SELECT m.title AS Movie_Title,
	m.renting_price 
FROM renting r
LEFT JOIN movies m
ON r.movie_id = m.movie_id;
-- Step 2: Report the total income for each movie
-- order the result by decreasing income
SELECT rm.title,
	SUM(rm.renting_price) AS income_movie
FROM 
	(SELECT m.title,
			m.renting_price 
	FROM renting r
	LEFT JOIN movies m
	ON r.movie_id = m.movie_id) AS rm
GROUP BY rm.title
ORDER BY income_movie DESC;

-- Explore the ages of actors and actresses from America
-- Report the date of birth of the oldest and the youngest US actor and actress
-- Step 1:
-- Create a subsequent select statement for all the actors from the US
SELECT *
FROM actors
WHERE nationality = 'USA';

-- Step 2: Write a query to get the date of birth of the oldest and youngest us actor. Group by Gender
SELECT MAX(year_of_birth),
	   MIN(year_of_birth)
FROM (SELECT *
		FROM actors
		WHERE nationality = 'USA') AS a
GROUP BY a.gender;

-- FINDING WHO THE FAVOURITE ACTORS FOR CERTAIN CUSTOMER GROUPS ARE
-- Writing a query to combine (Left Join, Where, Group By, Having, Order By)
-- The question is ' WHO IS THE FAVOURITE CUSTOMER FOR A CERTAIN CUSTOMER GROUP?'

-- STEP 1: Join table renting with tables
-- customers
-- actsin
-- actors
SELECT *
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.Customer_id
LEFT JOIN actsin ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors a 
ON ai.actor_id = a.actor_id;

-- Step 2: From the Joined table. select only customers with the male gender
-- Next we group by actor's name. 
-- -- Actor being watched most often is used to determine the favourite actors. 
SELECT a.name,
	  COUNT(*)
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.Customer_id
LEFT JOIN actsin ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors a 
ON ai.actor_id = a.actor_id

WHERE c.gender = 'male'
GROUP BY a.name;

-- STEP 3: How do we decide who is the favourite actor? Is it by:
-- Best average rating when being watched?
-- The query below includes the best rating as a way to determine the favourite actors
SELECT a.name,
	  COUNT(*) AS number_views,
      AVG(r.rating) AS avg_rating
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.Customer_id
LEFT JOIN actsin ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors a 
ON ai.actor_id = a.actor_id

WHERE c.gender = 'male'
GROUP BY a.name
HAVING AVG(r.rating) IS NOT NULL
ORDER BY avg_rating DESC, number_views DESC;

-- WRITE A QUERY WHICH ANSWERS 'WHICH IS THE FAVOURITE MOVIE?'
-- Which is the favourite movie on MovieNow? Answer this question for a specific group of customers; for all customers born in the 70s. 
-- To get the favourite movie, I am going to use the most rated movies, as well as the most rented movies
SELECT m.title, 
		Avg(r.rating) AS Avg_rating,
        COUNT(*) AS Number_of_Views
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.Customer_id
LEFT JOIN movieS m
ON r.movie_id = m.movie_id
WHERE date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING avg_rating IS NOT NULL
ORDER BY Number_of_Views DESC, avg_rating DESC;
-- We can then choose the favourite movies either using the Average rating or the number of views. 




