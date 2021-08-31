# Èasové promìnné
SELECT DISTINCT 
	`date`,
	CASE WHEN ((WEEKDAY(`date`))<5)
		THEN 0
		ELSE 1
	END AS 'weekend',
	CASE WHEN (MONTH(`date`)) IN ('1','2','12') THEN 0
		 WHEN (MONTH(`date`)) IN ('5','3','4') THEN 1
		 WHEN (MONTH(`date`)) IN ('6','7','8') THEN 2
		 ELSE 3
	END AS season
FROM covid19_basic cb
ORDER BY `date` DESC

# Promìnné specifické pro daný stát - tabulka countries
SELECT
	country,
	population_density,
	median_age_2018
FROM countries c 
WHERE 1=1
	AND country IS NOT NULL 
	AND median_age_2018 IS NOT NULL
	
# Promìnné specifické pro daný stát - tabulka economies
SELECT 
	country,
	#population,
	#GDP,
	ROUND((GDP/population),2) AS 'GDP/population',
	gini,
	mortaliy_under5 
FROM economies e 
WHERE 1=1
	AND country IS NOT NULL 
	#AND population IS NOT NULL 
	AND GDP IS NOT NULL	
	AND gini IS NOT NULL
	AND mortaliy_under5 IS NOT NULL
	
# Promìnné specifické pro daný stát - tabulka religions + economies
SELECT 
	r.country,
	#e.country,
	#e.population,
	#r.population,
	r.religion,
	ROUND(((r.population/e.population)*100),2) AS percentage_of_believers 
FROM religions r
RIGHT JOIN economies e 
ON r.country = e.country
AND r.`year` = e.`year` 
WHERE 1=1
	AND e.country IS NOT NULL
	AND r.country IS NOT NULL
	AND e.population IS NOT NULL 	
	
# Promìnné specifické pro daný stát - Rozdíl mezi oèekávanou dobou dožití v roce 2015 a 1965 - tabulka life_expectancy	
WITH year_2015 AS(
	SELECT 
		country,
		life_expectancy 
	FROM life_expectancy le
	WHERE `year` = '2015'
),
year_1965 AS (
	SELECT 
		country,
		life_expectancy 
	FROM life_expectancy le
	WHERE `year` = '1965'
)
SELECT DISTINCT 
	year_2015.country,
	ROUND((year_2015.life_expectancy-year_1965.life_expectancy),2) AS life_expectancy_differrence
FROM year_2015
INNER JOIN year_1965
ON year_2015.country = year_1965.country 

# Poèasí
SELECT	
	city,
	CASE WHEN w.city = 'Amsterdam' THEN 'Netherlands'
		 WHEN w.city = 'Athens' THEN 'Greece'
		 WHEN w.city = 'Belgrade' THEN 'Serbia'
		 WHEN w.city = 'Berlin' THEN 'Germany'
		 WHEN w.city = 'Bern' THEN 'Switzerland'
		 WHEN w.city = 'Bratislava' THEN 'Slovakia'
		 WHEN w.city = 'Brussels' THEN 'Belgium'
		 WHEN w.city = 'Bucharest' THEN 'Romania'
		 WHEN w.city = 'Budapest' THEN 'Hungary'
		 WHEN w.city = 'Chisinau' THEN 'Moldova'
		 WHEN w.city = 'Copenhagen' THEN 'Denmark'
		 WHEN w.city = 'Dublin' THEN 'Ireland'
		 WHEN w.city = 'Helsinki' THEN 'Finland'
		 WHEN w.city = 'Kiev' THEN 'Ukraine'
		 WHEN w.city = 'Lisbon' THEN 'Portugal'
		 WHEN w.city = 'Ljubljana' THEN 'Slovenia'
		 WHEN w.city = 'London' THEN 'United Kingdom'
		 WHEN w.city = 'Luxembourg' THEN 'Luxembourg'
		 WHEN w.city = 'Madrid' THEN 'Spain'
		 WHEN w.city = 'Minsk' THEN 'Belarus'
		 WHEN w.city = 'Moscow' THEN 'Russia' #není ve finální tabulce
		 WHEN w.city = 'Oslo' THEN 'Norway'
		 WHEN w.city = 'Paris' THEN 'France'
		 WHEN w.city = 'Prague' THEN 'Czech Republic' #není ve finální tabulce
		 WHEN w.city = 'Riga' THEN 'Latvia'
		 WHEN w.city = 'Rome' THEN 'Italy'
		 WHEN w.city = 'Skopje' THEN 'North Macedonia'
		 WHEN w.city = 'Sofia' THEN 'Bulgaria'
		 WHEN w.city = 'Stockholm' THEN 'Sweden'
		 WHEN w.city = 'Tallinn' THEN 'Estonia'
		 WHEN w.city = 'Tirana' THEN 'Albania'
		 WHEN w.city = 'Vienna' THEN 'Austria'
		 WHEN w.city = 'Vilnius' THEN 'Lithuania'
		 WHEN w.city = 'Warsaw' THEN 'Poland'
		 ELSE NULL
		 END AS country,
	`date`,
	ROUND((AVG(temp)),2) AS average_temperature,
	(COUNT(`time`)*3) AS rainy_hours,
	MAX(wind)
FROM weather w
WHERE 1=1
	AND `time` != '00:00'
	AND `time` != '03:00'
	AND `time` != '21:00'
	AND city IS NOT NULL
	AND SUBSTRING(rain,1,3) != '0.0' 
GROUP BY city, `date` 

SELECT * FROM economies e  