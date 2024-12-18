-- Netflix Project 
CREATE TABLE netflix(
show_id varchar(6),
type varchar(10),
title varchar(200),
director varchar(400),
casts varchar(1000),
country varchar(200),
date_added varchar(50),
release_year INT,
rating varchar(20),
duration varchar(20),
listed_in varchar(100),
description varchar(250)
);
select * from netflix;

-- Business Problems
--1. Count the number of TV shows vs Movies
SELECT type, Count(*) as Total_Content
from netflix
group by type;

--2.Find the common genres and the number of titles in each genre
SELECT listed_in, COUNT(*) AS genre_count
FROM netflix
GROUP BY listed_in
ORDER BY genre_count DESC;

--3.Find how many movies/shows have a specific rating and the distribution of content across different ratings.
SELECT rating, COUNT(*) AS content_count
FROM netflix
GROUP BY rating
ORDER BY content_count DESC;

--4.Find how many shows/movies were added to Netflix each year.
SELECT release_year, COUNT(*) AS content_count
FROM netflix
GROUP BY release_year
ORDER BY release_year DESC;

--5.Identify the most frequent directors in Netflix content.
SELECT director, COUNT(*) AS content_count
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY content_count DESC
LIMIT 10;

--6.Finding which countries have the least content available on Netflix.
SELECT * 
FROM
(
	SELECT
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 10

--7.Correlation Between Content Duration and Popularity
SELECT duration, COUNT(*) FROM netflix GROUP BY duration ORDER BY COUNT(*) DESC;

--8. Finding the binge-worthy content based on duration or user interactions.
SELECT title, duration FROM netflix WHERE duration >= '60 min' ORDER BY release_year DESC LIMIT 10;

--9. Ananlyzing which types of content are popular in which countries.
SELECT country, type, COUNT(*) AS content_count
FROM (
    SELECT unnest(string_to_array(country, ',')) AS country, type
    FROM netflix
    WHERE country IS NOT NULL
) AS country_data
GROUP BY country, type
ORDER BY content_count DESC;

-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5

--11 Identify the time gaps between the release of content by year or by country 
SELECT release_year, COUNT(*) AS content_count
FROM netflix
GROUP BY release_year
HAVING COUNT(*) < 10
ORDER BY release_year;

--12  Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;



