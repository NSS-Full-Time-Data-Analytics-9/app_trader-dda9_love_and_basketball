SELECT price, name
FROM app_store_apps
ORDER BY price DESC
LIMIT 10;
-- LAMP Words For Life $299.99

SELECT price, name
FROM play_store_apps
ORDER BY price ASC
LIMIT 10;
---Be the Expert in Phlebotomy- Professional Nursing $0.99

--Make a recommendation of 10 apps to buy with a sole focus on profitability/return on investment
SELECT p.price, a.price, a.name
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name)
ORDER BY p.price ASC
LIMIT 10;
-- I will recommend these 10 apps based soley on profitabililty:

-- Hitman GO
-- HItman Sniper
--Fruit Ninja Classic
-- sugar, sugar
--H*nest Meditation
--Where's My Water?
--True Skate
--Assassin's Creed Identity
--AJ Jump: Animal Jam Kangaroos!
--AnatomyMapp