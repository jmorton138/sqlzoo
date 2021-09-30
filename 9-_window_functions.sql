-- 1.
-- Show the lastName, party and votes for the constituency 'S14000024' in 2017.

SELECT lastName, party, votes
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC

-- Who won?
-- 2.
-- You can use the RANK function to see the order of the candidates. If you RANK using (ORDER BY votes DESC) then the candidate with the most votes has rank 1.

-- Show the party and RANK for constituency S14000024 in 2017. List the output by party

SELECT party, votes,
       RANK() OVER (ORDER BY votes DESC) as posn
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY party;

-- PARTITION BY
-- 3.
-- The 2015 election is a different PARTITION to the 2017 election. We only care about the order of votes for each year.

-- Use PARTITION to show the ranking of each party in S14000021 in each year. Include yr, party, votes and ranking (the party with the most votes is 1).

SELECT yr,party, votes,
      RANK() OVER (PARTITION BY yr ORDER BY votes DESC) as posn
  FROM ge
 WHERE constituency = 'S14000021'
ORDER BY party,yr

-- Edinburgh Constituency
-- 4.
-- Edinburgh constituencies are numbered S14000021 to S14000026.

-- Use PARTITION BY constituency to show the ranking of each party in Edinburgh in 2017. Order your results so the winners are shown first, then ordered by constituency.

SELECT constituency,party, votes,
RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017
ORDER BY posn, constituency ASC;

-- Winners Only
-- 5.
-- You can use SELECT within SELECT to pick out only the winners in Edinburgh.

-- Show the parties that won for each Edinburgh constituency in 2017.

SELECT constituency, party FROM
(SELECT constituency, party, votes,
RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017
ORDER BY posn, constituency) AS results
WHERE results.posn = 1

-- Scottish seats
-- 6.
-- You can use COUNT and GROUP BY to see how each party did in Scotland. Scottish constituencies start with 'S'

-- Show how many seats for each party in Scotland in 2017.

SELECT party, COUNT(constituency) FROM
(SELECT constituency, party, votes,
RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
  FROM ge
 WHERE constituency LIKE 'S%'
   AND yr  = 2017
ORDER BY posn, constituency) AS results
WHERE results.posn = 1
GROUP BY party;