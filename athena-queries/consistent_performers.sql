-- Most Consistent Top Performers (Average Rank)
-- Purpose: Identify players who consistently placed in the top ranks
-- What it shows: The players with the best average rank over the period – the true elite who stay near the top.

SELECT 
    username,
    performance,
    COUNT(*) AS days_in_top_100,
    ROUND(AVG(ranking), 2) AS avg_rank,
    ROUND(AVG(rating), 2) AS avg_rating
FROM leaderboard
GROUP BY username, performance
HAVING COUNT(*) >= 7   -- appeared at least half the days
ORDER BY avg_rank ASC
LIMIT 10;