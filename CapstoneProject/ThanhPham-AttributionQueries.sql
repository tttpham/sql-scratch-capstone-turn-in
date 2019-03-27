-- this query below finds  the number of campaigns that CoolTShirt use
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

-- this query below finds the number of  sources that CoolTShirt use
SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

/* the query below finds which source is used for each campaign:

I used DISTINCT on utm_campaign, utm_source columns because I want the query 
to return distinct values of the utm_campaign and the utm_source column.

*/
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;


/*the query below used DISTINCT on page_name column to return distinct 
values of the page_name column
*/

SELECT DISTINCT page_name
FROM page_visits;

/* the query below find the number of first touches (all users) for each campaign
*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
    ft_attr AS(
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
        pv.utm_campaign
       FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp 
order by utm_campaign
      )
SELECT utm_campaign, COUNT(ft_attr.user_id) AS numb_ft
FROM ft_attr
GROUP BY utm_campaign
ORDER BY 2;

/* the query below find the number of last touches for each campaign. 
The query is the same from previous slice except we change MIN(timestamp) 
to MAX(timestamp).

*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5;

-- the query below finds  the number of visitors make a purchase

SELECT COUNT(DISTINCT user_id), page_name
FROM page_visits
WHERE page_name = '4 - purchase';

/*query below  find  the number of last touches on the purchase page for each 
campaign.  I added the WHERE to last_touch table query. 
*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5;
