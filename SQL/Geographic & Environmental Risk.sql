--Which countries have the highest number of accidents?

SELECT TOP 5 
    Country, 
    COUNT(*) AS Accident_Count
FROM airline_accidents_cleaned
GROUP BY Country
ORDER BY Accident_Count DESC;

--Which specific airports have the highest accident frequency?

SELECT TOP 5 
    [Airport_Name], 
    COUNT(*) AS Accident_Count
FROM airline_accidents_cleaned
WHERE [Airport_Name] NOT IN ('Unknown', 'NONE', 'None', 'PRIVATE', 'PRIVATE STRIP', 'PRIVATE AIRSTRIP', 'MUNICIPAL')
GROUP BY [Airport_Name]
ORDER BY Accident_Count DESC;

--What percentage of accidents occurred under VMC vs IMC weather conditions?
SELECT 
    [Weather_Condition],
    COUNT(*) AS Total_Accidents,
    ROUND(CAST(COUNT(*) AS FLOAT) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM airline_accidents_cleaned
WHERE [Weather_Condition] IN ('VMC', 'IMC')
GROUP BY [Weather_Condition];
--Is there a correlation between weather condition (IMC) and fatal injury severity?
SELECT 
    [Weather_Condition],
    COUNT(*) AS Total_Accidents,
    SUM(ISNULL([Total_Fatal_Injuries], 0)) AS Total_Fatalities,
    ROUND(AVG(CAST(ISNULL([Total_Fatal_Injuries], 0) AS FLOAT)), 2) AS Avg_Fatalities_Per_Accident
FROM airline_accidents_cleaned
WHERE [Weather_Condition] IN ('VMC', 'IMC')
GROUP BY [Weather_Condition];
--Which US states/locations show the highest accident concentration?

SELECT TOP 5
    Location AS State,
    COUNT(*) AS Accident_Count
FROM airline_accidents_cleaned
WHERE Country = 'United States' 
GROUP BY Location
ORDER BY Accident_Count DESC;

--What is the average fatality count for accidents occurring in poor weather vs good weather?

SELECT 
    Weather_Condition,
    COUNT(*) AS Total_Accidents,
    SUM(ISNULL(Total_Fatal_Injuries, 0)) AS Total_Fatalities,
    AVG(CAST(ISNULL(Total_Fatal_Injuries, 0) AS FLOAT)) AS AVG_FATALITY
FROM airline_accidents_cleaned
WHERE Weather_Condition IN ('VMC', 'IMC')
GROUP BY Weather_Condition;


--Which broad phase of flight (takeoff, landing, cruise, maneuvering) has the highest accident rate per country?

WITH RankedPhases AS (
    SELECT 
        Country,
        [Broad_Phase_of_Flight],
        COUNT(*) AS Phase_Count,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY COUNT(*) DESC) AS rnk
    FROM airline_accidents_cleaned
    WHERE [Broad_Phase_of_Flight]  NOT IN ('Unknown', 'UNKNOWN', '') 
      AND Country IS NOT NULL
    GROUP BY Country, [Broad_Phase_of_Flight] 
)
SELECT Country, [Broad_Phase_of_Flight] , Phase_Count
FROM RankedPhases
WHERE rnk = 1
ORDER BY Phase_Count DESC;



Select * from dbo.airline_accidents_cleaned