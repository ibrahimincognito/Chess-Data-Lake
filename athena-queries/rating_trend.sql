-- Daily Top Gainers (Day‑over‑Day Rating Change)
-- Purpose: Identify which players gained the most rating from one day to the next. This is the “stock market movers” of chess ratings.
-- What it shows: The top 10 players who improved their rating the most between the last two days. You can adjust the dates to any consecutive pair.

WITH yesterday AS (
    SELECT username, rating, performance
    FROM leaderboard
    WHERE snapshot_date = '2026-02-19'
),
today AS (
    SELECT username, rating, performance
    FROM leaderboard
    WHERE snapshot_date = '2026-02-20'
)
SELECT 
    t.username,
    t.performance,
    y.rating AS yesterday_rating,
    t.rating AS today_rating,
    (t.rating - y.rating) AS gain
FROM today t
JOIN yesterday y 
    ON t.username = y.username 
    AND t.performance = y.performance
WHERE (t.rating - y.rating) > 0
ORDER BY gain DESC
LIMIT 10;

