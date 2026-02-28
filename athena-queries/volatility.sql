-- Volatility Ranking (Standard Deviation of Rating): 
-- Purpose: Find the players with the most fluctuating ratings – the “high‑risk, high‑reward” players.
-- What it shows: The most volatile players in each performance category. Volatility (standard deviation) captures how much their rating jumps around.

SELECT 
    username,
    performance,
    COUNT(*) AS days_tracked,
    ROUND(STDDEV(rating), 2) AS rating_volatility,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    (MAX(rating) - MIN(rating)) AS range
FROM leaderboard
WHERE snapshot_date BETWEEN '2026-02-08' AND '2026-02-20'
GROUP BY username, performance
HAVING COUNT(*) >= 5
ORDER BY rating_volatility DESC
LIMIT 20;