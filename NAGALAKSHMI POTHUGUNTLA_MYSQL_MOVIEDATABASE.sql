use movie;        -- to access all the tables under the database movie

--
-- Q1.Write a SQL query to find the actors who were cast in the movie 'Annie Hall'. Return actor first name, last name and role.
--
SELECT ACT_FNAME,ACT_LNAME,ROLE AS 'ACTOR-ROLE'                          -- fetching the records of actor firstname,lastname,actor role
FROM ACTORS AS A
JOIN MOVIE_CAST AS MC ON A.ACT_ID = MC.ACT_ID                            -- by joining three tables actors,movie_cast,movie
JOIN MOVIE AS M ON MC.MOV_ID = M.MOV_ID AND M.MOV_TITLE='Annie Hall';    -- on condition of act_id,mov_id and mov_title is Annie Hall

--
-- Q2.Write a SQL query to find the director who directed a movie that casted a role for 'Eyes Wide Shut' and  
--    return director first name, last name and movie title.
--
SELECT D.DIR_FNAME,D.DIR_LNAME,M.MOV_TITLE                       -- fetching the records of director firstname,lastname,movie title
FROM  DIRECTOR AS D 
NATURAL JOIN MOVIE_DIRECTION AS MD                               -- by joining four tables directors,movie_direction,movie,movie_cast
NATURAL JOIN MOVIE AS M                                          -- using natural join to check conditions on common columns/keys without defining                                         
NATURAL JOIN MOVIE_CAST WHERE M.MOV_TITLE ='Eyes Wide Shut';     -- where movie title is Eyes Wide Shut from movie table 
--
-- Q3.Write a SQL query to find who directed a movie that casted a role as ‘Sean Maguire’. Return director first name, last name and movie title.
--
SELECT D.DIR_FNAME,D.DIR_LNAME,M.MOV_TITLE                                  -- fetching the records of director firstname,lastname,movie title
FROM DIRECTOR AS D 
JOIN MOVIE_DIRECTION AS MD ON D.DIR_ID = MD.DIR_ID                          -- by joining four tables directors,movie_direction,movie,movie_cast
JOIN MOVIE AS M ON MD.MOV_ID = M.MOV_ID
JOIN MOVIE_CAST AS MC ON M.MOV_ID = MC.MOV_ID AND MC.ROLE = 'Sean Maguire'; -- on condition of dir_id,mov_id and role is Sean Maguire from movie_cast table

--
-- Q4. Write a SQL query to find the actors who have not acted in any movie between1990 and 2000 (Begin and end values are included) and
-- return actor first name, last name, movie title and release year. 
--
SELECT A.ACT_FNAME,A.ACT_LNAME,M.MOV_TITLE,M.MOV_YEAR                           -- fetching the records of actor firstname,lastname,movie title,release year
FROM MOVIE AS M
JOIN MOVIE_CAST AS MC ON M.MOV_ID = MC.MOV_ID                                   -- by joing three tables movie,movie_cast,actors
JOIN ACTORS AS A ON MC.ACT_ID = A.ACT_ID                                        -- on condition of mov_id,act_id and mov_year between 1990 and 2000
WHERE M.MOV_YEAR NOT BETWEEN 1990 AND 2000;                                     -- including start and end values from movie table

--
-- Q5.Write a SQL query to find the directors with number of genres movies, group the result set on director first name, last name and generic title,
--    sort the result-set in ascending order by director first name and last name and return director first name, last name and number of genres movies.
--
SELECT D.DIR_FNAME,D.DIR_LNAME,COUNT(G.GEN_TITLE) AS 'NO._GENRES_MOVIES'  -- fetching the records of director firstname,lastname,number of genres movies
FROM DIRECTOR AS D                            
JOIN MOVIE_DIRECTION AS MD ON D.DIR_ID = MD.DIR_ID                         -- by joining four tables director,movie_direction,movie_genres,genres 
JOIN MOVIE_GENRES AS MG ON MD.MOV_ID = MG.MOV_ID
JOIN GENRES AS G ON MG.GEN_ID = G.GEN_ID                                   -- on condition of dir_id,mov_id,gen_id
GROUP BY D.DIR_FNAME,D.DIR_LNAME,G.GEN_TITLE                               -- by grouping the result set on director firstname,lastname,generic title
ORDER BY D.DIR_FNAME,D.DIR_LNAME;                                          -- and sorting the director firstname,lastname in ascending order

--
-- Q6. Write a SQL query to find the movies with year and genres and return movie title, movie year and generic title.
--
SELECT M.MOV_TITLE,M.MOV_YEAR,G.GEN_TITLE AS 'GENERIC_TITLE'     -- fetching the records of movie title,movie year,generic title
FROM MOVIE AS M
NATURAL JOIN MOVIE_GENRES AS MG                                  -- by joing three tables movie,movie_genres,genres
NATURAL JOIN GENRES AS G;                                        -- using natural join to map the common columns implicitly

--
-- Q7. Write a SQL query to find all the movies with year, genres and name of the director. 
--
SELECT M.MOV_TITLE,M.MOV_YEAR,G.GEN_TITLE AS 'GENERIC_TITLE',D.DIR_FNAME,D.DIR_LNAME   -- fetching the records of movie title,movie year,generic title
FROM MOVIE AS M                                                                        -- director firstname,lastname
NATURAL JOIN MOVIE_GENRES AS MG                                                        -- by joining five tables movie,movie_genres,genres,
NATURAL JOIN GENRES AS G                                                               -- movie_direction,director
NATURAL JOIN MOVIE_DIRECTION AS MD                                                     -- using natural join 
NATURAL JOIN DIRECTOR AS D ;

--
-- Q8. Write a SQL query to find the movies released before 1st January 1989,sort the result-set in descending order by date of release,
-- return movie title, release year, date of release, duration, and first and last name of the director. 
--
SELECT M.MOV_TITLE,M.MOV_YEAR,M.MOV_DT_REL,M.MOV_TIME,D.DIR_FNAME,D.DIR_LNAME   -- fetching the records of movie title,movie year,movie release date
FROM MOVIE AS M                                                                 -- duration of movie,director firstname,lastname
JOIN MOVIE_DIRECTION AS MD ON M.MOV_ID = MD.MOV_ID                              -- by joining three tables movie,movie_direction,director
JOIN DIRECTOR AS D ON MD.DIR_ID = D.DIR_ID                                      -- on condition of mov_id,dir_id
WHERE DATE_FORMAT(M.MOV_DT_REL,'%Y %M %D') <'1989 January 1st'                  -- and movie release date is before 1989 January 1st from movie table 
ORDER BY M.MOV_DT_REL DESC;                                                     -- sorting the date of release in decending order

-- write a SQL query to find those years, which produced at least one movie and that, 
-- received a rating of more than three stars. Sort the result-set in ascending order by movie year.

select distinct(mov_year) from movie where mov_id in (select mov_id from rating where rev_stars>3) order by mov_year;

-- write a query to find name of those movies where one or more actors acted in two or more movies

select mov_title from movie where mov_id in
(select mov_id from movie_cast where act_id in
(select act_id from movie_cast group by act_id having count(act_id)>1));

-- write a SQL query to find the lowest rated movies. Return reviewer name, movie title, and number of stars for those movies.

SELECT rev_name, mov_title,rev_stars
FROM reviewer r
join rating rr on r.rev_id = rr.rev_id
join movie m on rr.mov_id = m.mov_id
where rev_stars = (SELECT min(rev_stars) FROM rating where rev_stars != 0);



