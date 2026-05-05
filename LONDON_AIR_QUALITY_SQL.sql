select *
from london_air_data;

-- 1. ANNUAL AVERGAE MEASUREMENT (AAM)
-- The average concentration measured over the full year.alter
-- Used for WHO guideline compliance assesment.alter

SELECT 
'Annual Avergae Measurement (AAM)' AS analysis,
	ROUND(AVG(CO),3) AS CO_ug_m3,
	ROUND(AVG(NO2),  3)   AS NO2_ug_m3,
	ROUND(AVG(SO2),  3)   AS SO2_ug_m3,
	ROUND(AVG(O3),   2)   AS O3_ug_m3,
	ROUND(AVG(PM25), 3)   AS PM25_ug_m3,
	ROUND(AVG(PM10), 3)   AS PM10_ug_m3,
	ROUND(AVG(AQI),  3)   AS AQI_avg
FROM london_air_data;

-- 2. WHO GUIDELINE COMPLIANCE check
-- Compares annual average to WHO 2023 limits.
-- WHO annual limits: CO = 4000, NO2 = 10, SO2 = 40 , O3 = 60, PM2.5 = 5 AND PM10 = 15 ug/m3

WITH annual_avg AS ( 
SELECT 
	ROUND(AVG(CO),3) AS CO_ug_m3,
	ROUND(AVG(NO2),  3)   AS NO2_ug_m3,
	ROUND(AVG(SO2),  3)   AS SO2_ug_m3,
	ROUND(AVG(O3),   2)   AS O3_ug_m3,
	ROUND(AVG(PM25), 3)   AS PM25_ug_m3,
	ROUND(AVG(PM10), 3)   AS PM10_ug_m3,
	ROUND(AVG(AQI),  3)   AS AQI_avg
FROM london_air_data
)
SELECT 
pollutant,
annual_avg_ug_m3,
who_guideline_ug_m3,
	ROUND(annual_avg_ug_m3/who_guideline_ug_m3*100,1) AS pct_of_who_limit,
    CASE
		WHEN annual_avg_ug_m3/who_guideline_ug_m3 > 1 THEN 'Exceeds WHO limit'
        WHEN annual_avg_ug_m3/who_guideline_ug_m3> 0.8 THEN 'Near WHO limit'
        ELSE 'Within WHO limit'
	END AS compliance_status
FROM (
	SELECT 'CO' AS pollutant, CO_ug_m3 AS annual_avg_ug_m3, 4000 AS who_guideline_ug_m3 FROM annual_avg
    UNION ALL
	SELECT 'NO2',  NO2_ug_m3,  10   FROM annual_avg
    UNION ALL
    SELECT 'SO2',  SO2_ug_m3,  40   FROM annual_avg
    UNION ALL
    SELECT 'O3',   O3_ug_m3,   60   FROM annual_avg
    UNION ALL
    SELECT 'PM2.5',PM25_ug_m3, 5    FROM annual_avg
    UNION ALL
    SELECT 'PM10', PM10_ug_m3, 15   FROM annual_avg
) compliance_table
ORDER BY pct_of_who_limit DESC;

-- 3. HOURLY AVERAGE MEASUREMENT
-- Average concentration by hour of day (0-23)
-- Reveals diurnal cycles: rush_hour peaks, evening peaks
-- photochemical O3 patterns.

SELECT
	HOUR(hours) AS hour_of_day,
	CONCAT(LPAD(HOUR(hours),2,'0'),':00') AS hour_level,
	ROUND(AVG(CO),3) AS CO_ug_m3,
	ROUND(AVG(NO2),  3)   AS NO2_ug_m3,
	ROUND(AVG(SO2),  3)   AS SO2_ug_m3,
	ROUND(AVG(O3),   2)   AS O3_ug_m3,
	ROUND(AVG(PM25), 3)   AS PM25_ug_m3,
	ROUND(AVG(PM10), 3)   AS PM10_ug_m3,
	ROUND(AVG(AQI),  3)   AS AQI_avg,
	COUNT(*) AS reading_count
FROM london_air_data
GROUP BY hour_of_day,hour_level
ORDER BY hour_of_day;

-- 4. PEAK HOUR PER POLLUTANT
--    Which hour of the day has the highest average
--    concentration for each pollutant?

WITH hourly AS (
	SELECT
		HOUR(hours) AS hr,
        ROUND(AVG(CO),3) AS CO_ug_m3,
		ROUND(AVG(NO2),  3)   AS NO2_ug_m3,
		ROUND(AVG(SO2),  3)   AS SO2_ug_m3,
		ROUND(AVG(O3),   2)   AS O3_ug_m3,
		ROUND(AVG(PM25), 3)   AS PM25_ug_m3,
		ROUND(AVG(PM10), 3)   AS PM10_ug_m3,
		ROUND(AVG(AQI),  3)   AS AQI_avg
	FROM london_air_data
    GROUP BY hr
)

SELECT 'CO' AS pollutant,
	CONCAT(LPAD(hr,2,'0'),':00') AS peak_hour,
    CO_ug_m3 AS peak_value
FROM hourly WHERE CO_ug_m3 = ( SELECT MAX(CO_ug_m3) FROM hourly )
UNION ALL 

SELECT 'NO2' AS pollutant,
	CONCAT(LPAD(hr,2,'0'),':00') AS peak_hour,
    NO2_ug_m3 AS peak_value
FROM hourly WHERE NO2_ug_m3 = ( SELECT MAX(NO2_ug_m3) FROM hourly )
UNION ALL 

SELECT 'SO2' AS pollutant,
	CONCAT(LPAD(hr,2,'0'),':00') AS peak_hour,
    SO2_ug_m3 AS peak_value
FROM hourly WHERE SO2_ug_m3 = ( SELECT MAX(SO2_ug_m3) FROM hourly )
UNION ALL 

SELECT 'O3' AS pollutant,
	CONCAT(LPAD(hr,2,'0'),':00') AS peak_hour,
    O3_ug_m3 AS peak_value
FROM hourly WHERE O3_ug_m3 = ( SELECT MAX(O3_ug_m3) FROM hourly )
UNION ALL

SELECT 'PM25' AS pollutant,
	CONCAT(LPAD(hr,2,'0'),':00') AS peak_hour,
    PM25_ug_m3 AS peak_value
FROM hourly WHERE PM25_ug_m3 = ( SELECT MAX(PM25_ug_m3) FROM hourly )
UNION ALL

SELECT 'PM10' AS pollutant,
	CONCAT(LPAD(hr,2,'0'),':00') AS peak_hour,
    PM10_ug_m3 AS peak_value
FROM hourly WHERE PM10_ug_m3 = ( SELECT MAX(PM10_ug_m3) FROM hourly );

-- 5. MONTHLY AVERAGES
--    Month-by-month breakdown with deviation from annual avg.

WITH annual AS (
	SELECT
		ROUND(AVG(CO),3) AS CO_ann,
		ROUND(AVG(NO2),  3)   AS NO2_ann,
		ROUND(AVG(SO2),  3)   AS SO2_ann,
		ROUND(AVG(O3),   2)   AS O3_ann,
		ROUND(AVG(PM25), 3)   AS PM25_ann,
		ROUND(AVG(PM10), 3)   AS PM10_ann,
		ROUND(AVG(AQI),  3)   AS AQI_ann
	FROM london_air_data
),

monthly AS (
	SELECT
    months,
		CASE months
			WHEN 'January' THEN 1
			WHEN 'February' THEN 2
			WHEN 'March' THEN 3
			WHEN 'April' THEN 4
			WHEN 'May' THEN 5
			WHEN 'June' THEN 6
			WHEN 'July' THEN 7
			WHEN 'August' THEN 8
			WHEN 'September' THEN 9
			WHEN 'October' THEN 10
			WHEN 'November' THEN 11
			WHEN 'December' THEN 12
		END AS months_num,
        ROUND(AVG(CO),3) AS CO_ug_m3,
		ROUND(AVG(NO2),  3)   AS NO2_ug_m3,
		ROUND(AVG(SO2),  3)   AS SO2_ug_m3,
		ROUND(AVG(O3),   2)   AS O3_ug_m3,
		ROUND(AVG(PM25), 3)   AS PM25_ug_m3,
		ROUND(AVG(PM10), 3)   AS PM10_ug_m3,
		ROUND(AVG(AQI),  3)   AS AQI_avg,
        COUNT(*) AS hours_in_month
	FROM london_air_data
    GROUP BY months
)

SELECT m.months,
	m.CO_ug_m3,
    ROUND(m.CO_ug_m3 - a.CO_ann,2) AS co_vs_annual,
    
    m.NO2_ug_m3,
    ROUND(m.NO2_ug_m3 - a.NO2_ann,2) AS no2_vs_annual,

	m.SO2_ug_m3,
    ROUND(m.SO2_ug_m3 - a.SO2_ann,2) AS so2_vs_annual,
    
    m.O3_ug_m3,
    ROUND(m.O3_ug_m3 - a.O3_ann,2) AS o3_vs_annual,
    
    m.PM25_ug_m3,
    ROUND(m.PM25_ug_m3 - a.PM25_ann,2) AS pm25_vs_annual,

	m.PM10_ug_m3,
    ROUND(m.PM10_ug_m3 - a.PM10_ann,2) AS pm10_vs_annual,
    
    m.AQI_avg,
    ROUND(m.AQI_avg - a.AQI_ann,2) AS aqi_vs_annual
    
FROM monthly m
CROSS JOIN annual a
ORDER BY m.months_num;

-- 6. SEASONAL ANALYSIS

WITH seasonal_labelled AS (
  SELECT
    CASE
      WHEN months IN ('December','January','February') THEN 'Winter'
      WHEN months IN ('March','April','May')           THEN 'Spring'
      WHEN months IN ('June','July','August')          THEN 'Summer'
      ELSE 'Autumn'
    END AS season,
    CASE
      WHEN months IN ('December','January','February') THEN 1
      WHEN months IN ('March','April','May')           THEN 2
      WHEN months IN ('June','July','August')          THEN 3
      ELSE 4
    END AS season_order,
    CO, NO2, SO2, O3, PM25, PM10, AQI
  FROM london_air_data
)
SELECT
  season,
  ROUND(AVG(CO),   2) AS CO_avg,
  ROUND(AVG(NO2),  3) AS NO2_avg,
  ROUND(AVG(SO2),  3) AS SO2_avg,
  ROUND(AVG(O3),   2) AS O3_avg,
  ROUND(AVG(PM25), 3) AS PM25_avg,
  ROUND(AVG(PM10), 3) AS PM10_avg,
  ROUND(AVG(AQI),  3) AS AQI_avg,
  COUNT(*)             AS total_readings,
  ROUND(MIN(AQI),  2) AS min_AQI,
  ROUND(MAX(AQI),  2) AS max_AQI
FROM seasonal_labelled
GROUP BY season, season_order
ORDER BY season_order;

-- 7. AQI CATEGORY DISTRIBUTION
--    Count and percentage of hours in each AQI band.

WITH counts AS (
    SELECT
        aqi_category,
        COUNT(*) AS hours
    FROM (
        SELECT
            CASE
                WHEN AQI <= 50  THEN '1 - Good (0-50)'
                WHEN AQI <= 100 THEN '2 - Moderate (51-100)'
                WHEN AQI <= 150 THEN '3 - Unhealthy Sensitive (101-150)'
                WHEN AQI <= 200 THEN '4 - Unhealthy (151-200)'
                WHEN AQI <= 300 THEN '5 - Very Unhealthy (201-300)'
                ELSE                 '6 - Hazardous (301+)'
            END AS aqi_category
        FROM london_air_data
    ) t
    GROUP BY aqi_category
)

SELECT
    aqi_category,
    hours,
    ROUND(hours * 100.0 / SUM(hours) OVER(), 2) AS pct_of_year,
    REPEAT('█', CAST(hours * 50 / MAX(hours) OVER() AS SIGNED)) AS bar_chart
FROM counts
ORDER BY aqi_category;


-- 8. TOP 10 WORST AQI DAYS
--    Daily average AQI — identifies pollution episodes.


WITH daily AS (
    SELECT
        dates AS date,
        months AS month,
        CASE
            WHEN months IN ('December','January','February') THEN 'Winter'
            WHEN months IN ('March','April','May')           THEN 'Spring'
            WHEN months IN ('June','July','August')          THEN 'Summer'
            ELSE 'Autumn'
        END AS season,
        ROUND(AVG(AQI),  2) AS daily_avg_AQI,
        ROUND(MAX(AQI),  2) AS daily_max_AQI,
        ROUND(AVG(CO),   1) AS avg_CO,
        ROUND(AVG(NO2),  2) AS avg_NO2,
        ROUND(AVG(PM25), 2) AS avg_PM25,
        COUNT(*) AS hours_with_data
    FROM london_air_data
    GROUP BY dates, months
)

SELECT
    RANK() OVER (ORDER BY daily_avg_AQI DESC) AS rank_num,
    date,
    month,
    season,
    daily_avg_AQI,
    daily_max_AQI,
    avg_CO,
    avg_NO2,
    avg_PM25,
    hours_with_data
FROM daily
ORDER BY daily_avg_AQI DESC
LIMIT 10;

-- 9. NIGHT vs DAY COMPARISON
--     Night: 21:00–05:59 | Day: 06:00–20:59

SELECT
    period,
    ROUND(AVG(CO),   2) AS CO_avg,
    ROUND(AVG(NO2),  3) AS NO2_avg,
    ROUND(AVG(SO2),  3) AS SO2_avg,
    ROUND(AVG(O3),   2) AS O3_avg,
    ROUND(AVG(PM25), 3) AS PM25_avg,
    ROUND(AVG(PM10), 3) AS PM10_avg,
    ROUND(AVG(AQI),  3) AS AQI_avg,
    COUNT(*)             AS reading_count
FROM (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM hours) >= 6
             AND EXTRACT(HOUR FROM hours) <= 20 THEN 'Daytime (06:00-20:59)'
            ELSE 'Night-time (21:00-05:59)'
        END AS period
    FROM london_air_data
) t
GROUP BY period
ORDER BY period;

-- 10. POLLUTION SPIKE DETECTION
--     Hours where any pollutant exceeds 2× its annual average.
--     Identifies extreme pollution events for investigation.

WITH avgs AS (
    SELECT
        AVG(CO)   AS co_avg,  AVG(NO2) AS no2_avg,
        AVG(SO2)  AS so2_avg, AVG(O3)  AS o3_avg,
        AVG(PM25) AS pm25_avg,AVG(PM10) AS pm10_avg
    FROM london_air_data
)
SELECT
    l.dates, l.hours,
    l.CO, l.NO2, l.SO2, l.O3, l.PM25, l.PM10, l.AQI,
    CASE
        WHEN l.CO   > 2 * a.co_avg   THEN 'CO spike'
        WHEN l.NO2  > 2 * a.no2_avg  THEN 'NO2 spike'
        WHEN l.SO2  > 2 * a.so2_avg  THEN 'SO2 spike'
        WHEN l.PM25 > 2 * a.pm25_avg THEN 'PM2.5 spike'
        WHEN l.PM10 > 2 * a.pm10_avg THEN 'PM10 spike'
        ELSE 'Multi-pollutant spike'
    END AS spike_type
FROM london_air_data l, avgs a
WHERE
    l.CO   > 2 * a.co_avg   OR
    l.NO2  > 2 * a.no2_avg  OR
    l.SO2  > 2 * a.so2_avg  OR
    l.PM25 > 2 * a.pm25_avg OR
    l.PM10 > 2 * a.pm10_avg
ORDER BY l.AQI DESC
LIMIT 50;






