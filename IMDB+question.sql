USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM director_mapping;
-- [Saumya] -> Total number of rows in the DIRECTOR_MAPPING table is 3867.

SELECT COUNT(*) FROM genre;
-- [Saumya] ->  Total number of rows in the genre table is 14662.

SELECT COUNT(*) FROM movie;
-- [Saumya] -> Total number of rows in the movie table is 7997.

SELECT COUNT(*) FROM names;
-- [Saumya] -> Total number of rows in the names table is 25735.

SELECT COUNT(*) FROM  ratings;
-- [Saumya] -> Total number of rows in the rating table is 7997.

SELECT COUNT(*) FROM  role_mapping;
-- [Saumya] -> Total number of rows in the role_mapping table is 15615.



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- Query to count the number of null values in each column using case statement

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_count,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_count,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_count,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_count,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_count,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_count,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_count,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_count,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_count
FROM   movie; 

-- [Saumya] -> country, worlwide_gross_income, languages and production_company columns have NULL values.



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year

SELECT year,
       Count(title) AS number_of_movies
FROM   movie
GROUP  BY year;

-- Number of movies released each month (trend look month wise)

SELECT Month(date_published) AS month_num,
       Count(*)              AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

/*[Saumya] -> The highest number of movies were released in 2017.
   -----------------------------------------------------
   [Saumya] -> March is the month that produces the most movies.  
   */

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT id) AS num_of_movies, year
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%INDIA%' )
AND year = 2019; 

-- [Saumya] -> In the year 2019, 1059 movies were produced in the USA or India.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
-- I am finding unique list of the genres present in the data set using DISTINCT keyword.
SELECT DISTINCT genre
FROM   genre;

-- [Saumya] -> The dataset contains movies from 13 genres.




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
-- First solution
SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;

-- 2nd solution using CTE

WITH ranking AS(
SELECT genre, COUNT(genre) AS movie_count,
	RANK() OVER(ORDER BY COUNT(genre) DESC) AS genre_rank
FROM genre
GROUP BY genre
ORDER BY movie_count DESC)
SELECT genre, movie_count
FROM ranking
WHERE genre_rank=1;

-- [Saumya] -> The number of Drama movies produced is the highest among all genres, totaling 4285.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH single_genre AS(
SELECT movie_id, COUNT(genre) AS genre_count
FROM genre
GROUP BY movie_id
HAVING genre_count=1)
SELECT COUNT(movie_id) AS Only_one_genre_movie_count
FROM single_genre;

-- [Saumya] -> There are 3289 movies that belong to only one genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT     genre,
           Round(Avg(duration),2) AS avg_duration
FROM       movie                  AS m
INNER JOIN genre                  AS g
ON      g.movie_id = m.id
GROUP BY   genre
ORDER BY avg_duration DESC;

-- [Saumya] -> The action genre had the longest duration at 112,88 seconds, followed by romance and crime.


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH ranking AS(
SELECT genre, COUNT(movie_id) AS movie_count,
	RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre)
SELECT *
FROM ranking
WHERE genre='Thriller';

-- [Saumya] -> The movie count for thriller is 1484, and rank is 3.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS 'min_avg_rating',
    MAX(avg_rating) AS 'max_avg_rating',
    MIN(total_votes) AS 'min_total_votes',
    MAX(total_votes) AS 'max_total_votes',
    MIN(median_rating) AS 'min_median_rating',
    MAX(median_rating) AS 'max_median_rating'
FROM
    ratings;

-- [Anviksha] -> There are no outliers in the table.
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
select m.title, avg_rating, 
	RANK() OVER (order by avg_rating DESC) as 'movie_rank'
from ratings r inner join movie m 
	on r.movie_id=m.id
limit 10;

-- [Anviksha] -> Yes, we found Fan movie in top 10 movies with an average rating of 9.6.



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, COUNT(DISTINCT (movie_id)) AS 'movie_count'
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

-- [Anviksha] -> Maximum Median rating is 10 and Movies with a median rating of 7 is highest in number.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
       Count(DISTINCT( r.movie_id )) AS 'movie_count',
       Dense_rank()
         OVER(
           ORDER BY Count(DISTINCT(r.movie_id)) DESC) AS 'prod_company_rank'
FROM   ratings r
       INNER JOIN movie m
               ON r.movie_id = m.id
WHERE  r.avg_rating > 8
AND production_company IS NOT NULL
GROUP  BY m.production_company; 

-- [Anviksha] -> Dream Warrior Pictures and National Theatre Live with movie count 3 both gets the rank 1.



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, COUNT(g.movie_id) AS movie_count
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.country = 'USA'
        AND r.total_votes > 1000
        AND MONTH(m.date_published) = 3
        AND YEAR(m.date_published) = 2017
GROUP BY g.genre
ORDER BY movie_count DESC;

-- [Anviksha] -> Drama genre has release maximum no. of movies during March 2017 in the USA and has got more than 1,000 votes


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title, r.avg_rating, g.genre
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.title LIKE 'The%' AND avg_rating > 8
ORDER BY avg_rating DESC;

-- [Anviksha] -> Using Average rating we observe that there are movie titles which link to different genre with sme median rating. 
-- [Anviksha] -> The Brighton Miracle has the highest average rating for 9.5 in genre drama


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
SELECT 
    m.title, r.median_rating, g.genre
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.title LIKE 'The%'
        AND median_rating > 8
ORDER BY median_rating DESC;

-- [Anviksha] -> Using Median rating we observe that there are movie titles which link to different genre with sme median rating. 
-- [Anviksha] -> This concludes that one movie is categorised in multiple genre

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(DISTINCT (m.id)) AS movie_released
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN CAST('2018-04-01' AS DATE) AND CAST('2019-04-01' AS DATE)
        AND r.median_rating = 8;

-- [Anviksha] -> No. of Movie released between 1 April 2018 and 1 April 2019 with a median rating of 8 = 361

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
    m.languages, SUM(r.total_votes)
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.languages LIKE '%German%'
        OR m.languages LIKE '%Italian%'
GROUP BY m.languages;

-- [Anviksha] -> With the above query we cannot infer if german has more votes or italian as there are several movies released in multiple languages which has german and intalian seprtely and german and intalian together
-- [Anviksha] -> The solution provided below categories movies which includes german and includes italian category and a category which includes both german and italian which help us understand which has more votes.
Select * from (SELECT 
    (CASE
        -- WHEN m.languages LIKE '%Italian%' THEN 'IncludesItalian'
        WHEN (m.languages LIKE '%German%' and m.languages LIKE '%Italian%') THEN 'IncludesBoth'
        WHEN m.languages LIKE '%German%' THEN 'IncludesGerman'
		WHEN m.languages LIKE '%Italian%' THEN 'IncludesItalian'
		-- WHEN (m.languages LIKE '%German%' and m.languages LIKE '%Italian%') THEN 'IncludesBoth'
    END) AS movie_languages,
    SUM(r.total_votes) as total_votes
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
GROUP BY movie_languages) a
where movie_languages is not null
order by total_votes desc;

-- [Anviksha] -> Yes, Only German lanuages has more No. of Moviees

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select sum(case when 'name' IS NULL then 1 else 0 end) as name_nulls, 
	sum(case when height IS NULL then 1 else 0 end) as height_nulls, 
    sum(case when date_of_birth IS NULL then 1 else 0 end) as date_of_birth_nulls, 
    sum(case when known_for_movies IS NULL then 1 else 0 end) as known_for_movies_nulls
from names;

-- [Anviksha] -> Yes, There are no Null value in the column 'name'


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT     n.NAME,
           Count((g.movie_id)) AS movie_count
FROM       names n
INNER JOIN director_mapping dm
ON         dm.name_id=n.id
INNER JOIN movie m
ON         dm.movie_id=m.id
INNER JOIN genre g
ON         g.movie_id=m.id
INNER JOIN ratings r
ON         r.movie_id=m.id
WHERE      r.avg_rating > 8
AND        g.genre IN (WITH top3genre AS
                       (
                                  SELECT     g.genre,
                                             Count((g.movie_id))                                   AS movi,
                                             Dense_rank() OVER (ORDER BY Count((g.movie_id)) DESC) AS genre_rank
                                  FROM       genre g
                                  INNER JOIN movie m
                                  ON         g.movie_id=m.id
                                  INNER JOIN ratings r
                                  ON         m.id=r.movie_id
                                  WHERE      avg_rating > 8
                                  GROUP BY   g.genre )SELECT   genre
            FROM     top3genre
            WHERE    genre_rank<=3)
  GROUP BY n.NAME
  ORDER BY count((g.movie_id)) DESC limit 3;
  
-- [Anviksha] -> Yes, James Mangold can be hired as the director for RSVP's next project.







/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    n.name as actor_name , COUNT(DISTINCT (rm.movie_id)) AS movie_count
FROM
    role_mapping rm
        INNER JOIN
    names n ON n.id = rm.name_id
        INNER JOIN
    movie m ON rm.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    rm.category = 'actor'
        AND r.median_rating >= 8
GROUP BY n.name
ORDER BY COUNT(DISTINCT (m.id)) DESC
LIMIT 2;

-- [Anviksha] -> We find Mohanlal in the list, we also see Mammootty with more no. of movies with median rating as 8.





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     production_company,
           Sum(total_votes)                             AS vote_count,
           Rank() OVER (ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
GROUP BY   production_company limit 3;

-- [Anviksha] -> Yes Marvel Studios rules the movie world and we have got Twentieth Century Fox and Warner Bros on 2nd and 3rd repectively


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name                                                           AS
       actor_name,
       SUM(r.total_votes)                                               AS
       total_votes,
       Count(m.id)                                                      AS
       movie_count,
       Round(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS
       actor_avg_rating,
       Rank()
         over (
           ORDER BY Round(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes), 2)
         DESC)
                                                                        AS
       actor_rank
FROM   names n
       inner join role_mapping rm
               ON n.id = rm.name_id
       inner join movie m
               ON rm.movie_id = m.id
       inner join ratings r
               ON r.movie_id = m.id
WHERE  rm.category = 'actor'
       AND n.name IN (WITH actorwith5indimovie
                           AS (SELECT n.name,
                                      Count(m.id),
                                      m.country AS count1
                               FROM   names n
                                      inner join role_mapping rm
                                              ON n.id = rm.name_id
                                      inner join movie m
                                              ON rm.movie_id = m.id
                               GROUP  BY n.name
                               HAVING m.country = 'India'
                                      AND Count(m.id) >= 5
                               ORDER  BY Count(m.id) DESC)
                      SELECT name
                       FROM   actorwith5indimovie)
GROUP  BY n.name; 

-- [Anviksha] -> Top actor is Vijay Sethupathi with movie count of 5, maximum votes and actor raiting as 8.42


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top5actress
     AS (SELECT n.NAME
                AS
                actress_name
                   ,
                Sum(r.total_votes)
                   AS total_votes,
                Count(m.id)
                AS
                   movie_count,
                Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2)
                AS
                actress_avg_rating,
                Rank()
                  OVER (
                    ORDER BY
                  Round(Sum(r.avg_rating*r.total_votes)/Sum(r.total_votes), 2)
                  DESC)
                                                                      AS
                actress_rank
         FROM   names n
                INNER JOIN role_mapping rm
                        ON n.id = rm.name_id
                INNER JOIN movie m
                        ON rm.movie_id = m.id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  rm.category = 'actress'
                AND n.NAME IN (WITH actorwith5indimovie
                                    AS (SELECT n.NAME,
                                               Count(m.id),
                                               m.country,
                                               m.languages AS count1
                                        FROM   names n
                                               INNER JOIN role_mapping rm
                                                       ON n.id = rm.name_id
                                               INNER JOIN movie m
                                                       ON rm.movie_id = m.id
                                        GROUP  BY n.NAME
                                        HAVING m.country = 'India'
                                               AND Count(m.id) >= 3
                                               AND m.languages = 'Hindi'
                                        ORDER  BY Count(m.id) DESC)
                               SELECT NAME
                                FROM   actorwith5indimovie)
         GROUP  BY n.NAME)
SELECT *
FROM   top5actress
WHERE  actress_rank <= 5; 

-- [Anviksha] -> Top actress is Taapsee Pannu with movie count of 5, maximum votes and actress raiting as 7.7



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH category
     AS (SELECT r.movie_id,
                ( CASE
                    WHEN r.avg_rating > 8 THEN 'Superhit movies'
                    WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
                    WHEN r.avg_rating BETWEEN 5 AND 7 THEN
                    'One-time-watch movies'
                    WHEN r.avg_rating < 5 THEN 'Flop movies'
                  END ) AS Movie_category
         FROM   genre g
                INNER JOIN ratings r
                        ON r.movie_id = g.movie_id
         WHERE  g.genre = 'Thriller')
SELECT movie_category,
       Count(DISTINCT( movie_id )) AS Movie_count
FROM   category
GROUP  BY movie_category;

-- [Anviksha] -> in Total there are 39 Superhit Thriller Movies, this gives me a list of movies to watch :)



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
       avg_duration,
       running_total,
       Round(moving_avg,2) AS moving_avg
FROM   (WITH gendata AS
       (
                  SELECT     g.genre,
                             Round(Avg(duration),2) AS avg_duration
                  FROM       genre g
                  INNER JOIN movie m
                  ON         g.movie_id =m.id
                  GROUP BY   g.genre)SELECT   *,
         sum(avg_duration) OVER w1 AS running_total,
         avg(avg_duration) OVER w1 AS moving_avg
FROM     gendata window w1         AS (ORDER BY avg_duration rows UNBOUNDED PRECEDING)) a;

-- [Anviksha] -> This is a good output table to build trend lines and visuals over it.

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH summary AS(
select *,CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT)  as converted 
FROM       movie m
           INNER JOIN genre g
           ON         g.movie_id=m.id
           WHERE      genre IN
                      (with top3_genre as (
SELECT     genre ,
           Count(id)                             AS movie_count ,
           Rank() OVER(ORDER BY Count(id) DESC ) AS genre_rank
FROM       movie m
INNER JOIN genre g
ON         g.movie_id=m.id
GROUP BY   g.genre
)  select genre from top3_genre where genre_rank <= 3
                         )),
ranking_summary AS
(
         SELECT   genre,
                  year,
				  title AS movie_name ,
                  worlwide_gross_income ,
                  dense_rank() OVER(partition BY year ORDER BY converted DESC) AS movie_rank
         FROM     summary )
SELECT *
FROM   ranking_summary
WHERE  movie_rank <= 5;

-- Top 3 Genres based on most number of movies


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_summary
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                inner join ratings AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
LIMIT 2; 



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)      AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;