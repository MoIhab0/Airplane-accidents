USE AirlineProject2;
GO

-- Dashboard 3 — Aircraft & Engine Analysis
-- Goal: Understand which aircraft types/configurations are most associated with accidents.
-- Target Audience: Aircraft manufacturers & maintenance/engineering teams


-- Q1: Which aircraft manufacturers (Make) have the highest number of recorded accidents?

SELECT TOP 10
    Make,
    COUNT(*) AS Accident_Count
FROM [airline_accidents_cleaned (1)]
GROUP BY Make
ORDER BY Accident_Count DESC;


-- Q2: Which specific aircraft models appear most frequently in fatal accidents?

SELECT TOP 10
    Model,
    COUNT(*) AS Fatal_Accident_Count
FROM [airline_accidents_cleaned (1)]
WHERE ISNULL(Total_Fatal_Injuries,0) > 0
GROUP BY Model
ORDER BY Fatal_Accident_Count DESC;


-- Q3: What percentage of accidents involve amateur-built aircraft vs certified aircraft?

SELECT
    Amateur_Built,
    COUNT(*) AS Accident_Count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),
        2
    ) AS Percentage
FROM [airline_accidents_cleaned (1)]
GROUP BY Amateur_Built;


-- Q4: Is there a relationship between number of engines and severity of aircraft damage?

SELECT
    Number_of_Engines,
    Aircraft_Damage,
    COUNT(*) AS Accident_Count
FROM [airline_accidents_cleaned (1)]
GROUP BY Number_of_Engines, Aircraft_Damage
ORDER BY Number_of_Engines;


-- Q5: Which engine type (Reciprocating, Turbine, etc.) has the highest fatality rate?

SELECT
    Engine_Type,
    COUNT(*) AS Total_Accidents,
    SUM(
        CASE
            WHEN ISNULL(Total_Fatal_Injuries,0) > 0 THEN 1
            ELSE 0
        END
    ) AS Fatal_Accidents,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN ISNULL(Total_Fatal_Injuries,0) > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Fatality_Rate
FROM [airline_accidents_cleaned (1)]
GROUP BY Engine_Type
ORDER BY Fatality_Rate DESC;


-- Q6: What is the distribution of Aircraft Damage severity (Destroyed/Substantial/Minor) by manufacturer?

SELECT
    Make,
    Aircraft_Damage,
    COUNT(*) AS Damage_Count
FROM [airline_accidents_cleaned (1)]
GROUP BY Make, Aircraft_Damage
ORDER BY Make;


-- Q7: Do amateur-built aircraft show a higher fatal injury rate compared to standard aircraft?

SELECT
    Amateur_Built,
    COUNT(*) AS Total_Accidents,
    SUM(
        CASE
            WHEN ISNULL(Total_Fatal_Injuries,0) > 0 THEN 1
            ELSE 0
        END
    ) AS Fatal_Accidents,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN ISNULL(Total_Fatal_Injuries,0) > 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Fatality_Rate
FROM [airline_accidents_cleaned (1)]
GROUP BY Amateur_Built;