select * from WorldCupMatches$
select * from WorldCups$
select * from WorldCupPlayers$

UPDATE  WorldCupMatches$
SET [Home Team Name] = 'Germany'
WHERE [Home Team Name] = 'Germany FR'

UPDATE  WorldCupMatches$
SET [Away Team Name] = 'Germany'
WHERE [Away Team Name] = 'Germany FR'

UPDATE  WorldCups$
SET Winner = 'Germany'
WHERE Winner = 'Germany FR'

UPDATE  WorldCups$
SET [Runners-Up] = 'Germany'
WHERE [Runners-Up] = 'Germany FR'


UPDATE  WorldCups$
SET Third = 'Germany'
WHERE Third = 'Germany FR'


UPDATE  WorldCups$
SET Fourth = 'Germany'
WHERE Fourth = 'Germany FR'


UPDATE  WorldCupPlayers$
SET [Player Name] = 'C.RONALDO'
WHERE [Player Name] = 'RONALDO' and [Team Initials]='POR'


--1.Most world cup winners and years

WITH TrophyCounts AS (
    SELECT Winner, COUNT(*) AS number_of_trophies
    FROM WorldCups$
    GROUP BY Winner
)
SELECT a.Winner, a.year,
       ROW_NUMBER() OVER (PARTITION BY a.Winner ORDER BY a.year) AS number_of_trophies
FROM WorldCups$ a
JOIN TrophyCounts b ON a.Winner = b.Winner
ORDER BY b.number_of_trophies DESC, a.Winner, a.year


--2.Retrieve the "Winner" and "Runners-Up" for a specific year.

select YEAR, 
       Country as Host_country,
       Winner,
	   [Runners-Up],
	   Third
from WorldCups$


--3.Find the total number of goals scored across all tournaments.

select distinct a.YEAR,
       b.Country,
	   sum([Home Team Goals]+[Away Team Goals]) as Goals
from WorldCupMatches$ a
left join WorldCups$ b on b.year=a.year
group by  a.YEAR,
         b.Country
order by Goals desc


--4.Find the world cups with the most attendance

select distinct a.YEAR,
       b.Country,
	   sum(a.Attendance) as Attendance
from WorldCupMatches$ a
left join WorldCups$ b on b.year=a.year
group by  a.YEAR,
          b.Country
order by Attendance desc


--5.Find the matches with the most attendance

select a.YEAR,
       b.Country,
	   [Home Team Name]+' VS '+[Away Team Name] as Match,
	   a.city as City,
	   a.stadium as Stadium,
	   a.Attendance
from WorldCupMatches$ a
left join WorldCups$ b on b.year=a.year
order by a.Attendance desc


--6.Most red cards by country

SELECT [Team Initials], 
       SUM(case when event like '%R%' then 1 else 0 end) AS total_red_cards
FROM WorldCupPlayers$
GROUP BY [Team Initials]
ORDER BY total_red_cards DESC


--7.Years with the most red cards

select distinct a.Year, 
       c.country,
       SUM(case when event like '%R%' then 1 else 0 end) AS total_red_cards
from WorldCupMatches$ a
left join WorldCupPlayers$ b on b.MatchID=a.MatchID
left join WorldCups$ c on c.year=a.year
group by a.Year,
         c.country
order by total_red_cards desc


--8.country with all world cup appearance

SELECT a.[Team Initials], 
       COUNT(DISTINCT b.year) AS world_cups
FROM WorldCupPlayers$ a
LEFT JOIN WorldCupMatches$ b ON b.MatchID = a.MatchID
GROUP BY a.[Team Initials]
HAVING COUNT(DISTINCT b.year) = (
    SELECT COUNT(DISTINCT year) FROM WorldCupMatches$
)
ORDER BY world_cups DESC


--9.Who are the most frequently appearing referees in World Cup history?

select referee, 
       count(distinct year) as Number_of_world_cups,
       count(*) as Numer_of_matches
from WorldCupMatches$
group by referee
order by Number_of_world_cups desc


--10.Matches with the most goals

select Year, 
       Stage,
	   [Home Team Initials],
	   [Home Team Goals],
	   [Away Team Goals],
	   [Away Team Initials],
       [Home Team Goals]+[Away Team Goals] as Goals
from WorldCupMatches$
order by Goals desc

--11.Matches with the most goal difference

SELECT Year, 
       Stage,
       [Home Team Initials],
       [Home Team Goals],
       [Away Team Goals],
       [Away Team Initials],
       [Home Team Goals] - [Away Team Goals] AS [Goal Difference]
FROM WorldCupMatches$
ORDER BY [Goal Difference] DESC


--12.Coatches with number the most number of world cups with different teams

select a.[Coach Name],
       count(distinct b.Year) as Number_of_world_cups,
       count(distinct a.[Team Initials]) as Number_of_teams
from WorldCupPlayers$ a
left join WorldCupMatches$ b on b.MatchID=a.MatchID
group by a.[Coach Name]
order by Number_of_world_cups desc, Number_of_teams desc


--13.Players with the most world cups and matches

select a.[Player Name],
       a.[team initials],
       count(distinct b.Year) as Number_of_world_cups,
	   count(distinct a.MatchID) as Number_of_matches
from WorldCupPlayers$ a
left join WorldCupMatches$ b on b.MatchID=a.MatchID
group by a.[Player Name],
a.[team initials]
order by Number_of_world_cups desc,  Number_of_matches desc


--14.Players with the most world cup goals

SELECT [Player Name], 
       SUM(LEN(event) - LEN(REPLACE(event, 'G', ''))) AS [Total Goals]
FROM WorldCupPlayers$
GROUP BY [Player Name]
ORDER BY [Total Goals] DESC








