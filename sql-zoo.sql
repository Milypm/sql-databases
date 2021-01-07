-- SQL zoo Tutorials
-- SELECT Basics exercises
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

-- SELECT from world exercises
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

-- SELECT from nobel
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

-- SELECT within SELECT exercises
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

-- SUM and COUNT exercises
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

-- JOIN I exercises
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

-- More JOIN exercises
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



