-- 			============================================================
--   			LONDON AIR QUALITY 2023 — COMPLETE SQL ANALYSIS
--  			 Dataset: 8,760 hourly readings | 6 Pollutants + AQI
--   				Compatible with: PostgreSQL · MySQL · SQLite
--   				Author: MD NAJMUL ISLAM | Portfolio Project
-- 			============================================================




-- ============================================================
-- 						 TABLE SETUP
-- ============================================================


use london_air_quality;

create table if not exists london_air_quality.london_air_data
(
	dates Date,
    hours Time,
    city varchar(50),
    CO	integer,
    NO2 Decimal(6,2),
    SO2 Decimal(6,2),
    O3 integer,
    PM25 Decimal(6,2),
    PM10 Decimal(6,2),
    AQI Decimal(6,2),
    months Varchar(20)
); 
-- ADDING COMPUTED COLUMN FOR ANALYSIS

ALTER TABLE london_air_data
ADD COLUMN hour_num INT 
GENERATED ALWAYS AS (HOUR(hours)) STORED;

ALTER TABLE london_air_data
ADD COLUMN season VARCHAR(10)
GENERATED ALWAYS AS (
    CASE
        WHEN months IN ('December','January','February') THEN 'Winter'
        WHEN months IN ('March','April','May')           THEN 'Spring'
        WHEN months IN ('June','July','August')          THEN 'Summer'
        ELSE 'Autumn'
    END
) STORED;

ALTER TABLE london_air_data
ADD COLUMN aqi_category VARCHAR(30)
GENERATED ALWAYS AS(
	CASE 
		WHEN AQI <= 50 THEN 'Good'
        WHEN AQI <=100 THEN 'Moderate'
        WHEN AQI <=150 THEN 'Unhealthy for sensitive'
        WHEN AQI <=200 THEN 'Unhealthy'
        WHEN AQI <=300 THEN 'Worst'
        ELSE 'Hazardous'
	END
) STORED;