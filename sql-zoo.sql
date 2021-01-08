-- SQL zoo Tutorials
-- SELECT Basics exercises (at sql-zoo tutorial))
SELECT population FROM world
  WHERE name = 'Germany'

SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark');

SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

SELECT name, population FROM world
  WHERE population BETWEEN 1000000 AND 1250000

SELECT name FROM world
  WHERE name LIKE '%a' OR name LIKE '%l'

SELECT name, area, population FROM world
  WHERE area > 50000 AND population < 10000000

-- SELECT names exercises
SELECT name FROM world
  WHERE name LIKE 'Y%'

SELECT name FROM world
  WHERE name LIKE '%Y'

SELECT name FROM world
  WHERE name LIKE '%x%'

SELECT name FROM world
  WHERE name LIKE '%land'

SELECT name FROM world
  WHERE name LIKE 'C%ia'

SELECT name FROM world
  WHERE name LIKE '%oo%'

SELECT name FROM world
  WHERE name LIKE '_t%'
  ORDER BY name

SELECT name FROM world
  WHERE name LIKE '%o__o%'

-- More SELECT exercises (world at sql-zoo tutorial)
SELECT name, continent, population FROM world

SELECT name FROM world
  WHERE population >= 200000000

SELECT name, gdp/population FROM world
  WHERE population >= 200000000

SELECT name, population/1000000 FROM world
  WHERE continent = 'South America'

SELECT name, population FROM world
  WHERE name IN ('France', 'Germany', 'Italy')

SELECT name FROM world
  WHERE name LIKE '%United%'

SELECT name, population, area FROM world
  WHERE area > 3000000 OR population > 250000000

SELECT name, population, area FROM world
  WHERE area > 3000000 XOR population > 250000000

SELECT name, ROUND(population/1000000, 2), ROUND(gdp/1000000000, 2)
  FROM world
  WHERE continent = 'South America'

SELECT name, ROUND(gdp/population, -3) FROM world
  WHERE gdp >= 1000000000000

SELECT name, capital FROM world
  WHERE LENGTH(name) = LENGTH(capital)

SELECT name, capital FROM world
  WHERE LEFT(name, 1) = LEFT(capital, 1) AND name <> capital

SELECT name FROM world
  WHERE name NOT LIKE '% %'
  AND name LIKE '%a%'
  AND name LIKE '%e%'
  AND name LIKE '%i%'
  AND name LIKE '%o%'
  AND name LIKE '%u%'

-- More SELECT exercises (nobel at sql-zoo tutorial)
SELECT yr, subject, winner FROM nobel
  WHERE yr = 1950

SELECT winner FROM nobel
  WHERE yr = 1962 AND subject = 'Literature'

SELECT yr, subject FROM nobel
  WHERE winner = 'Albert Einstein'

SELECT winner FROM nobel
  WHERE subject = 'Peace' AND yr >= 2000

SELECT yr, subject, winner FROM nobel
  WHERE subject = 'Literature' AND yr >= 1980 AND yr <= 1989

SELECT * FROM nobel
  WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 
  'Jimmy Carter', 'Barack Obama')

SELECT winner FROM nobel
  WHERE winner LIKE 'John%'

SELECT yr, subject, winner FROM nobel
  WHERE subject = 'Physics' AND yr = 1980
  OR subject = 'Chemistry' AND yr = 1984

SELECT yr, subject, winner FROM nobel
  WHERE yr = 1980 AND subject NOT IN ('Chemistry', 'Medicine')

SELECT yr, subject, winner FROM nobel
  WHERE subject = 'Medicine' AND yr < 1910 
  OR subject = 'Literature' AND yr >= 2004

SELECT * FROM nobel
  WHERE winner = 'Peter Grünberg'

SELECT * FROM nobel
  WHERE winner = 'Eugene O''Neill'

SELECT winner, yr, subject FROM nobel
  WHERE winner LIKE 'Sir%' ORDER BY yr DESC, winner

SELECT winner, subject FROM nobel
  WHERE yr = 1984 ORDER BY subject IN ('Chemistry', 'Physics'), 
  subject, winner

-- More SELECT exercises (within SELECT at sql-zoo tutorial)
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

SELECT name FROM world
  WHERE continent = 'Europe' AND gdp/population >
    (SELECT gdp/population FROM world
    WHERE name = 'United Kingdom')

SELECT name, continent FROM world
  WHERE continent IN
    (SELECT continent FROM world
    WHERE name IN ('Argentina', 'Australia'))
      ORDER BY name

SELECT name, population FROM world
  WHERE population >
    (SELECT population FROM world
    WHERE name = 'Canada') AND population <
    (SELECT population FROM world
    WHERE name = 'Poland')

SELECT name, CONCAT(ROUND(population * 100/(SELECT population
  FROM world WHERE name = 'Germany')), '%') FROM world
  WHERE continent = 'Europe'

SELECT name FROM world
  WHERE gdp > ALL(SELECT gdp FROM world
  WHERE continent = 'Europe' AND gdp > 0)

SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent = x.continent)

SELECT continent, name FROM world x
  WHERE name <= ALL(SELECT name FROM world y
    WHERE y.continent = x.continent)

SELECT name, continent, population FROM world x
  WHERE 25000000 >= ALL(SELECT population FROM world y
    WHERE y.continent = x.continent);

SELECT name, continent FROM world x
  WHERE population >= ALL(SELECT population * 3 FROM world y
    WHERE y.continent = x.continent AND y.name <> x.name);

-- SUM and COUNT exercises (at sql-zoo tutorial)
SELECT SUM(population) FROM world

SELECT DISTINCT(continent) FROM world

SELECT SUM(gdp) FROM world
  WHERE continent = 'Africa'

SELECT SUM(1) FROM world
  WHERE area >= 1000000

SELECT SUM(population) FROM world
  WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

SELECT continent, COUNT(name) FROM world
  GROUP BY continent

SELECT continent, COUNT(name) FROM world
  WHERE population >= 10000000 GROUP BY continent

SELECT continent FROM world
  GROUP BY continent HAVING SUM(population) >= 100000000

-- JOIN exercises (at sql-zoo tutorial)
SELECT matchid, player FROM goal
  WHERE teamid = 'GER'

SELECT id,stadium,team1,team2 FROM game
  WHERE id = 1012

SELECT player, teamid, stadium, mdate
  FROM game JOIN goal ON (id = matchid)
    WHERE teamid = 'GER'

SELECT team1, team2, player
  FROM game JOIN goal ON (id=matchid)
    WHERE player LIKE 'Mario%'

SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON (teamid = id)
    WHERE gtime <= 10

SELECT mdate, teamname
  FROM game JOIN eteam ON (team1=eteam.id)
    WHERE coach = 'Fernando Santos'

SELECT player
  FROM game JOIN goal ON (id = matchid)
    WHERE stadium = 'National Stadium, Warsaw'

SELECT DISTINCT(player)
  FROM game JOIN goal ON matchid = id 
    WHERE (team1= 'GER' OR team2='GER') AND teamid!='GER'

SELECT teamname, COUNT(player)
  FROM eteam JOIN goal ON id=teamid GROUP BY teamname

SELECT stadium, COUNT(player)
  FROM game JOIN goal ON id = matchid
    GROUP BY stadium

SELECT matchid, mdate, COUNT(player)
  FROM game JOIN goal ON (matchid = id)
    WHERE (team1 = 'POL') OR (team2 = 'POL')
      GROUP BY mdate, matchid ORDER BY matchid

SELECT matchid, mdate, COUNT(teamid)
  FROM game JOIN goal ON (matchid = id)
    WHERE teamid = 'GER'
      GROUP BY mdate, matchid ORDER BY matchid

SELECT DISTINCT mdate, team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
    FROM game LEFT JOIN goal ON (game.id = goal.matchid)
      GROUP BY id, mdate, team1, team2
      ORDER BY mdate, matchid, team1, team2

-- More JOIN exercises (at sql-zoo tutorial)
SELECT id, title FROM movie
  WHERE yr = 1962

SELECT yr FROM movie
  WHERE title = 'Citizen Kane'

SELECT id, title, yr FROM movie
  WHERE title LIKE '%Star Trek%' ORDER BY yr

SELECT id FROM actor
  WHERE name = 'Glenn Close'

SELECT id FROM movie
  WHERE title = 'Casablanca'

SELECT name FROM actor JOIN casting ON actorid = id
  WHERE movieid = 11768

SELECT name FROM actor JOIN casting ON actorid = id
  WHERE movieid IN (SELECT id FROM movie
    WHERE title = 'Alien')

SELECT title FROM movie JOIN casting ON movieid = id
  WHERE actorid IN (SELECT id FROM actor
    WHERE name = 'Harrison Ford')

SELECT title FROM movie JOIN casting ON movieid = id
  WHERE actorid IN (SELECT id FROM actor
    WHERE name = 'Harrison Ford') AND ord != 1

SELECT title, name FROM actor JOIN casting ON (id = actorid)
  JOIN movie ON(movieid = movie.id)
    WHERE yr = 1962 AND casting.ord = 1

SELECT yr, COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

SELECT title, name FROM casting
  JOIN movie ON movie.id = movieid
  JOIN actor ON actor.id = actorid
WHERE ord = 1
AND movie.id IN
	(SELECT movie.id FROM movie
    JOIN casting ON movie.id = movieid
	  JOIN actor ON actor.id = actorid
      WHERE actor.name = 'Julie Andrews')

SELECT DISTINCT(name) FROM actor JOIN casting ON actorid = actor.id
  WHERE ord = 1 GROUP BY name
    HAVING COUNT(ord = 1) >= 15 ORDER BY name

SELECT title, COUNT(actorid) FROM casting JOIN movie ON movieid = movie.id
  WHERE yr = 1978 GROUP BY movieid, title
    ORDER BY COUNT(actorid) DESC, title

SELECT DISTINCT name FROM casting JOIN actor ON actorid = actor.id
  WHERE name != 'Art Garfunkel' AND movieid IN(SELECT movieid
	      FROM movie JOIN casting ON movieid = movie.id
	                 JOIN actor ON actorid = actor.id
	                  WHERE actor.name = 'Art Garfunkel')

-- NULL exercises (at sql-zoo tutorial)
SELECT name FROM teacher
  WHERE dept IS NULL

SELECT teacher.name, dept.name FROM teacher INNER JOIN dept
  ON (teacher.dept=dept.id)

SELECT teacher.name, dept.name FROM teacher LEFT JOIN dept
  ON (teacher.dept=dept.id)

SELECT teacher.name, dept.name FROM teacher RIGHT JOIN dept
  ON (teacher.dept=dept.id)

SELECT name, COALESCE(mobile, '07986 444 2266') FROM teacher

SELECT teacher.name, COALESCE(dept.name, 'None') FROM teacher
  LEFT JOIN dept ON dept.id = teacher.dept

SELECT COUNT(name), COUNT(mobile) FROM teacher

SELECT dept.name, COUNT(teacher.name) FROM teacher
  RIGHT JOIN dept ON dept.id = teacher.dept GROUP BY dept.name

SELECT name,
    CASE WHEN dept = 1 OR dept = 2 THEN 'Sci'
    ELSE 'Art'
    END
  FROM teacher

SELECT name,
    CASE WHEN dept = 1 OR dept = 2 THEN 'Sci'
    WHEN dept = 3 THEN 'Art'
    ELSE 'None'
    END
  FROM teacher

-- SELF JOIN exercises (at sql-zoo tutorial)
SELECT COUNT(name) FROM stops

SELECT id FROM stops
  WHERE name = 'Craiglockhart'

SELECT id, name FROM stops
  JOIN route ON stops.id = route.stop
    WHERE num = '4'
    AND company = 'LRT'

SELECT company, num, COUNT(*) AS routes FROM route
  WHERE stop=149 OR stop=53 GROUP BY company, num
    HAVING routes >= 2

SELECT a.company, a.num, a.stop, b.stop FROM route a 
  JOIN route b ON (a.company = b.company AND a.num = b.num)
    WHERE a.stop = 53 AND b.stop = (SELECT id FROM stops
      WHERE name = 'London Road')

SELECT a.company, a.num, stopa.name, stopb.name FROM route a
 JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
    WHERE stopa.name='Craiglockhart' and stopb.name = 'London Road'

SELECT DISTINCT a.company, a.num FROM route a, route b
 WHERE a.num = b.num
 AND (a.stop = 115 AND b.stop = 137)

SELECT a.company, a.num FROM route a
  JOIN route b ON (a.company = b.company AND a.num = b.num)
  JOIN stops stopa ON a.stop = stopa.id
  JOIN stops stopb ON b.stop = stopb.id
    WHERE stopa.name = 'Craiglockhart'
    AND stopb.name = 'Tollcross';

SELECT DISTINCT name, a.company, a.num FROM route a
  JOIN route b ON (a.company = b.company AND a.num = b.num)
  JOIN stops ON a.stop = stops.id
    WHERE b.stop = 53;
