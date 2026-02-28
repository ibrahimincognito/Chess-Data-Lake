-- Most Improved Player (Overall Change)
-- Purpose: Find who gained the most rating from the first to the last snapshot.
-- What it shows: The players who climbed the most over the entire 13‑day period – a measure of long‑term momentum.


WITH first_day AS (
    SELECT username, performance, rating
    FROM leaderboard
    WHERE snapshot_date = (SELECT MIN(snapshot_date) FROM leaderboard)
),
last_day AS (
    SELECT username, performance, rating
    FROM leaderboard
    WHERE snapshot_date = (SELECT MAX(snapshot_date) FROM leaderboard)
)
SELECT 
    f.username,
    f.performance,
    f.rating AS first_rating,
    l.rating AS last_rating,
    (l.rating - f.rating) AS total_change
FROM first_day f
JOIN last_day l 
    ON f.username = l.username AND f.performance = l.performance
WHERE (l.rating - f.rating) > 0
ORDER BY total_change DESC
LIMIT 10;