--How has the number of accidents changed year over year?\

WITH YearlyAccidents AS (
    SELECT 
        YEAR(TRY_CAST([Event_Date] AS DATE)) AS [Year],
        COUNT(*) AS Total_Accidents
    FROM airline_accidents_cleaned
    WHERE [Event_Date] IS NOT NULL
    GROUP BY YEAR(TRY_CAST([Event_Date] AS DATE))
)
SELECT 
    [Year],
    Total_Accidents,
    LAG(Total_Accidents) OVER (ORDER BY [Year]) AS Previous_Year_Accidents,
    Total_Accidents - LAG(Total_Accidents) OVER (ORDER BY [Year]) AS YoY_Change
FROM YearlyAccidents
ORDER BY [Year];



--What percentage of accidents result in fatal injuries vs non-fatal?
SELECT 
    CASE 
        WHEN ISNULL([Total_Fatal_Injuries], 0) > 0 THEN 'Fatal'
        ELSE 'Non-Fatal'
    END AS Outcome_Type,
    COUNT(*) AS Total_Count,
    ROUND(CAST(COUNT(*) AS FLOAT) * 100.0 / (SELECT COUNT(*) FROM airline_accidents_cleaned), 2) AS Percentage
FROM airline_accidents_cleaned
GROUP BY 
    CASE 
        WHEN ISNULL([Total_Fatal_Injuries], 0) > 0 THEN 'Fatal'
        ELSE 'Non-Fatal'
    END;

--What is the trend in total fatalities per year?
SELECT 
    YEAR(TRY_CAST([Event_Date] AS DATE)) AS [Year],
    SUM(ISNULL([Total_Fatal_Injuries], 0)) AS Total_Fatalities
FROM airline_accidents_cleaned
WHERE [Event_Date] IS NOT NULL
GROUP BY YEAR(TRY_CAST([Event_Date] AS DATE))
ORDER BY [Year];

--Which years had the highest number of "Uninjured" outcomes (survivability trend)?
SELECT 
    YEAR(TRY_CAST([Event_Date] AS DATE)) AS [Year],
    SUM(ISNULL([Total_Uninjured], 0)) AS Total_Uninjured
FROM airline_accidents_cleaned
WHERE [Event_Date] IS NOT NULL
GROUP BY YEAR(TRY_CAST([Event_Date] AS DATE))
ORDER BY Total_Uninjured DESC;
--What is the ratio of "Accident" vs "Incident" investigation types over time?
SELECT 
    YEAR(TRY_CAST([Event_Date] AS DATE)) AS [Year],
    SUM(CASE WHEN [Investigation_Type] = 'Accident' THEN 1 ELSE 0 END) AS Accidents_Count,
    SUM(CASE WHEN [Investigation_Type] = 'Incident' THEN 1 ELSE 0 END) AS Incidents_Count,
    CAST(
        SUM(CASE WHEN [Investigation_Type] = 'Accident' THEN 1 ELSE 0 END) AS FLOAT
    ) / NULLIF(SUM(CASE WHEN [Investigation_Type] = 'Incident' THEN 1 ELSE 0 END), 0) AS Accident_to_Incident_Ratio
FROM airline_accidents_cleaned
WHERE [Event_Date] IS NOT NULL
GROUP BY YEAR(TRY_CAST([Event_Date] AS DATE))
ORDER BY [Year];
--How many accidents were reported with a significant delay between event date and report publication date?
SELECT 
    [Event_Id],
    [Event_Date],
    [Report_Publication_Date],
    DATEDIFF(DAY, TRY_CAST([Event_Date] AS DATE), TRY_CAST([Report_Publication_Date] AS DATE)) AS Delay_In_Days
FROM airline_accidents_cleaned
WHERE 
    [Event_Date] IS NOT NULL 
    AND [Report_Publication_Date] IS NOT NULL
    AND DATEDIFF(DAY, TRY_CAST([Event_Date] AS DATE), TRY_CAST([Report_Publication_Date] AS DATE)) > 365
ORDER BY Delay_In_Days DESC;

--What is the average number of total injuries per accident by year?
SELECT 
    YEAR(TRY_CAST([Event_Date] AS DATE)) AS [Year],
    ROUND(AVG(CAST(ISNULL([Total_Injuries], 0) AS FLOAT)), 2) AS Avg_Injuries_Per_Accident
FROM airline_accidents_cleaned
WHERE [Event_Date] IS NOT NULL
GROUP BY YEAR(TRY_CAST([Event_Date] AS DATE))
ORDER BY [Year];

