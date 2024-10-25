CREATE DATABASE IF NOT EXISTS GlobalWeatherDB;
USE GlobalWeatherDB;


CREATE TABLE IF NOT EXISTS weather_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(255),
    location_name VARCHAR(255),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    timezone VARCHAR(255),
    last_updated_epoch BIGINT,
    last_updated DATETIME,
    temperature_celsius FLOAT,
    condition_text VARCHAR(255),
    wind_kph FLOAT,
    wind_degree INT,
    wind_direction VARCHAR(10),
    pressure_mb FLOAT,
    precip_mm FLOAT,
    humidity INT,
    cloud INT,
    feels_like_celsius FLOAT,
    visibility_km FLOAT,
    uv_index FLOAT,
    gust_kph FLOAT,
    air_quality_Carbon_Monoxide FLOAT,
    air_quality_Ozone FLOAT,
    air_quality_Nitrogen_dioxide FLOAT,
    air_quality_Sulphur_dioxide FLOAT,
    air_quality_PM2_5 FLOAT,
    air_quality_PM10 FLOAT,
    air_quality_us_epa_index INT,
    air_quality_gb_defra_index INT,
    sunrise TIME,
    sunset TIME,
    moonrise TIME,
    moonset TIME,
    moon_phase VARCHAR(255),
    moon_illumination FLOAT
);

    
SHOW TABLES;
DESCRIBE weather_data;
ALTER TABLE weather_data
MODIFY sunrise VARCHAR(80),
MODIFY sunset VARCHAR(80),
MODIFY moonrise VARCHAR(80),
MODIFY moonset VARCHAR(80);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_data.csv'
INTO TABLE weather_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    country,
    location_name,
    latitude,
    longitude,
    timezone,
    last_updated_epoch,
    last_updated,
    temperature_celsius,
    condition_text,
    wind_kph,
    wind_degree,
    wind_direction,
    pressure_mb,
    precip_mm,
    humidity,
    cloud,
    feels_like_celsius,
    visibility_km,
    uv_index,
    gust_kph,
    air_quality_Carbon_Monoxide,
    air_quality_Ozone,
    air_quality_Nitrogen_dioxide,
    air_quality_Sulphur_dioxide,
    air_quality_PM2_5,
    air_quality_PM10,
    air_quality_us_epa_index,
    air_quality_gb_defra_index,
    sunrise,
    sunset,
    moonrise,
    moonset,
    moon_phase,
    
    moon_illumination
);

#Top 5 Hottest unique locations by temperature in degrees celsius
SELECT location_name, MAX(temperature_celsius) AS highest_temp
FROM weather_data
GROUP BY location_name
ORDER BY highest_temp DESC
LIMIT 5;
#Top 5 Coldest unique locations by temperature in degrees celsius
SELECT location_name, MIN(temperature_celsius) AS coldest_temp
FROM weather_data
GROUP BY location_name
ORDER BY coldest_temp ASC
LIMIT 5;

#Select all instances of temperature being greater than 38C
SELECT *
FROM weather_data
WHERE temperature_celsius > 38;
#Select all instances of windspeed being greater than 60kph
SELECT *
FROM weather_data
WHERE wind_kph > 60;

#Average weather by country:
SELECT country, AVG(temperature_celsius) AS average_temperature
FROM weather_data
GROUP BY country
ORDER BY average_temperature DESC;

#End of SQL DB Opperations
