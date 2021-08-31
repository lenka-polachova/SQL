# �asov� prom�nn� - v�kend/pracovn� den
SELECT DISTINCT 
	`date`,
	CASE WHEN ((WEEKDAY(`date`))<5)
		THEN 0
		ELSE 1
	END AS 'weekend'
FROM covid19_basic cb
ORDER BY `date` DESC

# �asov� prom�nn� - ro�n� obdob� dan�ho dne 
SELECT DISTINCT
	`date`,
	CASE WHEN (MONTH(`date`)) IN ('1','2','12') THEN 0
		 WHEN (MONTH(`date`)) IN ('5','3','4') THEN 1
		 WHEN (MONTH(`date`)) IN ('6','7','8') THEN 2
		 ELSE 3
	END AS season
FROM covid19_basic cb 

/* NEFUNK�N� DOTAZ
SELECT 
	country,
	`date`,
	CASE WHEN (((YEAR(`date`))%4)>0)
		 THEN (
		 	WHEN ((DAYOFYEAR(`date`))<80) THEN 0
		 	WHEN ((DAYOFYEAR(`date`))<112) THEN 1
		 	WHEN ((DAYOFYEAR(`date`))<266) THEN 2
		 	WHEN ((DAYOFYEAR(`date`))<356) THEN 3
		 	ELSE 0
		 )
		 ELSE (
		 	WHEN ((DAYOFYEAR(`date`))<81) THEN 0
		 	WHEN ((DAYOFYEAR(`date`))<113) THEN 1
		 	WHEN ((DAYOFYEAR(`date`))<267) THEN 2
		 	WHEN ((DAYOFYEAR(`date`))<357) THEN 3
		 	ELSE 0
		 )
	END AS season
FROM covid19_basic cb 

SELECT DISTINCT 
	`date`,
	DAYOFYEAR(`date`)
FROM covid19_basic cb
GROUP BY `date` */

# Prom�nn� specifick� pro dan� st�t - hustota zalidn�n�
SELECT
	country,
	population_density 
FROM countries c 

# Prom�nn� specifick� pro dan� st�t - HDP na obyvatele
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

# Prom�nn� specifick� pro dan� st�t - gini koeficient
SELECT 
	country,
	gini 
FROM economies e
WHERE 1=1
	AND country IS NOT NULL 
	AND gini IS NOT NULL

# Prom�nn� specifick� pro dan� st�t - d�tsk� �mrtnost
SELECT 
	country,
	mortaliy_under5 
FROM economies e 
WHERE 1=1
	AND country IS NOT NULL 
	AND mortaliy_under5 IS NOT NULL 

# Prom�nn� specifick� pro dan� st�t - medi�n v�ku obyvatel v roce 2018
SELECT 
	country,
	median_age_2018 
FROM countries c
WHERE 1=1
	AND country IS NOT NULL 
	AND median_age_2018 IS NOT NULL

# Prom�nn� specifick� pro dan� st�t - Pod�ly jednotliv�ch n�bo�enstv�
# Tabulka religions je veden� a� do roku 2050?
# Vych�z� v�c ne� 100% v���c�ch - nespr�vn� hodnoty v tabulce
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

SELECT * FROM economies e 

# Prom�nn� specifick� pro dan� st�t - Rozd�l mezi o�ek�vanou dobou do�it� v roce 2015 a 1965
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
LEFT JOIN year_1965
ON year_2015.country = year_1965.country 


# Po�as� - pr�m�rn� denn� teplota
SELECT * FROM weather w 

SELECT
	city,
	`date`,
	AVG(temp) AS average_temperature
FROM weather w
WHERE 1=1
	AND `time` != '00:00'
	AND `time` != '03:00'
	AND `time` != '21:00'
	AND city IS NOT NULL
GROUP BY city, `date` 

# Po�as� - po�et hodin v dan�m dni, kdy byly sr�ky nenulov�
SELECT 
	city,
	`date`,
	(COUNT(`time`)*3) AS rainy_hours
FROM weather w 
WHERE city IS NOT NULL
	AND SUBSTRING(rain,1,3) != '0.0' 
GROUP BY city, `date` 

# Po�as� - Maxim�ln� s�la v�tru v n�razech/den
SELECT 
	city,
	`date`,
	MAX(wind)
FROM weather w 	
WHERE city IS NOT NULL
GROUP BY city, `date` 
