-- Find the difference between the average rating of movies released before 1980 and 
-- the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, 
-- then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall 
-- average rating before and after 1980.) 

select avg(before_1980.movie_avg) - avg(after_1980.movie_avg)
from (
	select avg(stars) as movie_avg
    from Movie, Rating
    where Movie.mID = Rating.mID and Movie.year < 1980
    group by Rating.mID
) as before_1980, (
	select avg(stars) as movie_avg
    from Movie, Rating
    where Movie.mID = Rating.mID and Movie.year > 1980
    group by Rating.mID
) as after_1980;

-- For each director, return the director's name together with the title(s) of the movie(s) they directed 
-- that received the highest rating among all of their movies, and the value of that rating. 
-- Ignore movies whose director is NULL. 

select distinct Director, Title, stars
from (select *
from Rating join Movie using(mID)) m1
where not exists (select *
from Rating join Movie using(mID)
where m1.Director = Director and m1.stars < stars) and Director <> '';

-- Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 

select Movie.Title, avg(Rating.stars)
from Movie, Rating
where Movie.mID = Rating.mID
group by Rating.mID
having avg(Rating.stars) = (select min(avg_stars)
	from (select avg(stars) as avg_stars
		from Rating
        group by mID) x);
        
-- Some directors directed more than one movie. For all such directors, 
-- return the titles of all movies directed by them, along with the director name. 
-- Sort by director name, then movie title. 

select Director, Title
from Movie
where Director in (select Director from Movie
group by Director 
having count(Director) > 1)
order by Director, Title;

-- Find all years that have a movie that received a rating of 4 or 5, 
-- and sort them in increasing order.

select distinct Movie.year
from Movie, Rating
where Movie.mID = Rating.mID and (stars = 4 or stars = 5)
order by Movie.year;

-- Find the names of all reviewers who have contributed three or more ratings.
-- (As an extra challenge, try writing the query without HAVING or without COUNT.) 

select Name
from Reviewer r1
where (select count(rID) from Rating r2 where r2.rID = r1.rID) > 2;

-- For each rating that is the lowest (fewest stars) currently in the database, 
-- return the reviewer name, movie title, and number of stars. 

select Reviewer.Name, Movie.Title, Rating.stars
from Rating, Reviewer, Movie
where Rating.rID = Reviewer.rID 
	and Rating.mID = Movie.mID
    and stars = (select min(stars) from Rating);
    
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the 
-- names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and 
-- include each pair only once. For each pair, return the names in the pair in alphabetical order. 

select distinct a.Name, b.Name
from Rating x, Rating y, Reviewer a, Reviewer b
where x.rID = a.rID and y.rID = b.rID and x.mID = y.mID and x.rID != y.rID and a.Name < b.Name;

-- For any rating where the reviewer is the same as the director of the movie, 
-- return the reviewer name, movie title, and number of stars. 

select Reviewer.Name, Movie.Title, Rating.stars
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID and Reviewer.Name = Movie.Director;

-- Find the titles of all movies that have no ratings.

select Title 
from Movie
where mID not in (select mID from Rating);

-- Some reviewers didn't provide a date with their rating. 
-- Find the names of all reviewers who have ratings with a NULL value for the date. 

select Reviewer.Name
from Reviewer, Rating
where Reviewer.rID = Rating.rID and ratingDate is NULL;

-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select Reviewer.Name, Title, stars, ratingDate
from Movie, Reviewer, Rating
where Reviewer.rID = Rating.rID and Movie.mID = Rating.mID
order by Reviewer.Name, Title, stars;

-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
-- return the reviewer's name and the title of the movie. 

select Name, Title
from Movie 
inner join Rating rm using (mID)
inner join Rating rr using (rID)
inner join Reviewer using (rID)
where rm.mID = rr.mID and rm.ratingDate < rr.ratingDate and rm.stars < rr.stars;

-- For each movie that has at least one rating, find the highest number of stars that movie received. 
-- Return the movie title and number of stars. Sort by movie title.

select Title, max(stars)
from Movie, Rating 
where Movie.mID = Rating.mID
group by Title
order by Title;


