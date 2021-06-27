#doèasné view - èasové promìnné 
CREATE OR REPLACE VIEW tmp_v_lp_time AS
SELECT DISTINCT
	country,
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
WHERE country IS NOT NULL
ORDER BY country, `date` DESC

SELECT * FROM tmp_v_lp_time

# doèasné view - countries
CREATE OR REPLACE VIEW tmp_v_lp_countries AS 
SELECT
	tvlpt.*,
	#country,
	c.population_density,
	c.median_age_2018
FROM countries c 
RIGHT JOIN tmp_v_lp_time tvlpt
ON c.country = tvlpt.country
WHERE 1=1
	AND c.population_density IS NOT NULL
	AND c.country IS NOT NULL 
	AND c.median_age_2018 IS NOT NULL
	
SELECT * FROM tmp_v_lp_countries

#doèasné view - economies 
CREATE OR REPLACE VIEW tmp_v_lp_economies AS
SELECT 
	e.country,
	e.`year`,
	ROUND((e.GDP/e.population),2) AS 'GDP/population',
	e.gini,
	e.mortaliy_under5
FROM economies e 
WHERE 1=1
	AND e.country IS NOT NULL 
ORDER BY country, `year` DESC

	
SELECT * FROM tmp_v_lp_economies

# doèasné view - religions 
CREATE OR REPLACE VIEW tmp_v_lp_religions AS
SELECT 
	r.country,
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
	
SELECT * FROM tmp_v_lp_religions 

# doèasné view - spojení countries, economies, religions
CREATE OR REPLACE VIEW tmp_v_lp_almost_final AS
WITH economies_and_religions AS(
SELECT 
	tvle.*,
	tvlr.religion,
	tvlr.percentage_of_believers
FROM tmp_v_lp_economies tvle 
RIGHT JOIN tmp_v_lp_religions tvlr 
ON tvle.country = tvlr.country
)
SELECT 
	tvlc.*,
	ear.`GDP/population`,
	ear.gini,
	ear.mortaliy_under5,
	ear.religion,
	ear.percentage_of_believers
FROM economies_and_religions ear
LEFT JOIN tmp_v_lp_countries tvlc 
ON ear.country = tvlc.country
AND ear.`year` = YEAR(tvlc.`date`) 

SELECT * FROM tmp_v_lp_almost_final

# doèasné view - Rozdíl mezi oèekávanou dobou dožití v roce 2015 a 1965
CREATE OR REPLACE VIEW tmp_v_lp_life_expectancy_differrence AS
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
SELECT #DISTINCT 
	year_2015.country,
	ROUND((year_2015.life_expectancy-year_1965.life_expectancy),2) AS life_expectancy_differrence
FROM year_2015
LEFT JOIN year_1965
ON year_2015.country = year_1965.country 

SELECT * FROM tmp_v_lp_life_expectancy_differrence

# doèasné view - spojení almost final a life_expectancy_differrence
CREATE OR REPLACE VIEW tmp_v_lp_almost_almost_final AS
SELECT
	tvlaf.*,
	tvlled.life_expectancy_differrence
FROM tmp_v_lp_almost_final tvlaf 
RIGHT JOIN tmp_v_lp_life_expectancy_differrence tvlled 
ON tvlaf.country = tvlled.country
#WHERE tvlaf.country LIKE 'Poland'

SELECT * FROM tmp_v_lp_almost_almost_final 

# doèasné view - poèasí
CREATE OR REPLACE VIEW tmp_v_lp_weather AS 
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
		 WHEN w.city = 'Prague' THEN 'Czechia' #není ve finální tabulce
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

SELECT * FROM tmp_v_lp_weather

/*-------------NETESTOVANÝ KÓD-------------*/
# spojení almost_almost_final a weather
#CREATE TABLE t_lenka_polachova_projekt_SQL_final
SELECT 
	tvlaaf.*,
	tvlw.city,
	tvlw.`date`,
	tvlw.average_temperature,
	tvlw.`MAX(wind)`,
	tvlw.rainy_hours 
FROM tmp_v_lp_weather tvlw
LEFT JOIN tmp_v_lp_almost_almost_final tvlaaf 
ON tvlaaf.country = tvlw.country
AND DATE(tvlaaf.`date`) = DATE(tvlw.`date`)
ORDER BY tvlaaf.country, tvlw.city, tvlw.`date`
