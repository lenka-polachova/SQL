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

# Promìnné specifické pro daný stát - NEFUNKÈNÍ

SELECT
	c.country,
	c.population_density,
	e.population,
	e.GDP,
	ROUND((e.GDP/e.population,2) AS 'GDP/population'
FROM countries c
LEFT JOIN economies e 
ON c.country = e.country 
WHERE 1=1
	AND e.country IS NOT NULL 
	AND e.population IS NOT NULL 
	AND e.GDP IS NOT NULL

SELECT 
	country,
	population,
	GDP,
	ROUND((GDP/population),2) AS 'GDP/population'
FROM economies e 
WHERE 1=1
	AND country IS NOT NULL 
	AND population IS NOT NULL 
	AND GDP IS NOT NULL

# Poèasí
SELECT	
	city,
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