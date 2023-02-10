-- App Trader
-- Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made available
-- through the Apple App Store and Android Play Store.   

-- App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchases. 
-- The apps' developers retain all money from users purchasing the app from the relevant app store, and they retain half of the money made from in-app purchases. 
-- App Trader will be solely responsible for marketing any apps they purchase the rights to.

-- Unfortunately, the data for Apple App Store apps and the data for Android Play Store apps are located in separate tables with no referential integrity.

-- 1. Loading the data
-- 	a. Launch PgAdmin and create a new database called app_trader.

-- 	b. Right-click on the app_trader database and choose Restore...

-- 	c. Use the default values under the Restore Options tab.

-- 	d. In the Filename section, browse to the backup file app_store_backup.backup in the data folder of this repository.

-- 	e. Click Restore to load the database.

-- 	f. Verify that you have two tables:
-- 		- app_store_apps with 7197 rows
-- 		- play_store_apps with 10840 rows

-- 2. Assumptions
--    Based on research completed prior to launching App Trader as a company, you can assume the following:

-- 	a. App Trader will purchase the rights to apps for 10,000 times the list price of the app on the Apple App Store/Google Play Store,
--     however the minimum price to purchase the rights to an app is $25,000. For example, a $3 app would cost $30,000 (10,000 x the price)
--     and a free app would cost $25,000 (The minimum price). NO APP WILL EVER COST LESS THEN $25,000 TO PURCHASE.

-- 	b. Apps earn $5000 per month on average from in-app advertising and in-app purchases regardless of the price of the app.

-- 	c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app.
--     If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

-- 	d. For every quarter-point that an app gains in rating, its projected lifespan increases by 6 months, in other words,
--     an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years,
--     and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.25 to evaluate an app's likely longevity.

-- 	e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same
--     $1000 per month.

-- 3. Deliverables
-- 	a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

-- Price range
-- I would highly recommend any of the free apps that can be found in both the Apple Play Store and the Google Play Store.

-- Genre
-- Games, Food, Health and Fitness, all favor really well in the ratings category.

-- Content Rating
-- Apps rated for "Everyone" or "4+" would be my recommendation.


-- 	b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

-- 	c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate
--     for next months's Pi Day themed campaign.

-- 	c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits.
--     All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.


SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;

-- Profititability formula
SELECT ROUND(((rating/0.25)*6+12)*4000-25000,2) AS profitability

-- PROFITABILITY FORMULA FOR ONE APP ON ONE TABLE
SELECT ROUND(((rating/0.25)*6+12)*1500-25000,2) AS profitability

-- apps that appear in both google play and apple play store with the same rating
(SELECT name, rating
FROM app_store_apps)
INTERSECT
(SELECT name, rating
FROM play_store_apps)
ORDER BY rating DESC;

WITH both_tables AS ((SELECT name
					  FROM app_store_apps)
				      INTERSECT
					  (SELECT name
					  FROM play_store_apps))
SELECT *
FROM both_tables

-- app store apps with ratings with at least a 4.5 rating, content_rating of 4+, and over 100000 reviews
SELECT DISTINCT name AS app_store, review_count::numeric, rating, primary_genre, price, content_rating
FROM app_store_apps
WHERE rating >=4.5
	AND price = 0.00
	AND review_count::numeric > 100000
	AND content_rating = '4+'
ORDER BY rating DESC
LIMIT 50;

-- play store apps with at least 4.5 rating, free, rated for everyone, and review_count over 100000
SELECT DISTINCT name AS play_store, rating, genres, price, content_rating
FROM play_store_apps
WHERE rating >=4.5
	AND price = '0'
	AND review_count > 100000
	AND content_rating = 'Everyone'
ORDER BY rating DESC
LIMIT 50;

--joined table to look at all of the app names that are free with a rating 4.0
SELECT name, p.type, p.review_count, a.primary_genre
FROM play_store_apps AS p FULL JOIN app_store_apps AS a USING(name)
WHERE p.type = 'Free'
	AND a.price = '0.00'
	AND p.rating > 4.0
	AND a.rating > 4.0
GROUP BY DISTINCT name, p.type, p.review_count, a.primary_genre
ORDER BY p.review_count DESC;

-- Average rating for free apps in the google play store
SELECT ROUND(AVG(rating),2)
FROM play_store_apps
WHERE type = 'Free';
-- 4.25

-- AVERAGE rating for free apps in the apple play store
SELECT ROUND(AVG(rating),2)
FROM app_store_apps
WHERE price = 0.00
-- 3.38


SELECT *
FROM app_store_apps
WHERE rating > (SELECT ROUND(AVG(rating),2)
				FROM app_store_apps)
	AND content_rating = '4+'
	AND price = 0.00
	AND primary_genre IN ('Games','Health & Fitness','Food & Drink')
ORDER BY review_count::numeric DESC, rating DESC;


-- PROFITABILITY FORMULA FOR ONE APP ONE TABLE
SELECT ROUND(((rating/0.25)*6+12)*1500-25000,2) AS profitability
FROM app_store_apps;













