USE AirlineProject2;
GO

-- Dashboard 4 — Flight Purpose & Injury Impact
-- Goal: Analyze how the purpose of the flight relates to injury outcomes.
-- Target Audience: Insurance & Risk Management Teams


-- Q1: Which Purpose of Flight categories have the highest accident counts?

SELECT
    Purpose_of_Flight,
    COUNT(*) AS Accident_Count
FROM [airline_accidents_cleaned (1)]
GROUP BY Purpose_of_Flight
ORDER BY Accident_Count DESC;


-- Q2: Which flight purpose has the highest fatality rate?

SELECT
    Purpose_of_Flight,
    ROUND(
        100.0 *
        SUM(CASE WHEN Total_Fatal_Injuries > 0 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Fatality_Rate
FROM [airline_accidents_cleaned (1)]
GROUP BY Purpose_of_Flight
ORDER BY Fatality_Rate DESC;


-- Q3: What is the average number of serious injuries per accident by flight purpose?

SELECT
    Purpose_of_Flight,
    ROUND(
        AVG(CAST(Total_Serious_Injuries AS FLOAT)),
        2
    ) AS Avg_Serious_Injuries
FROM [airline_accidents_cleaned (1)]
GROUP BY Purpose_of_Flight
ORDER BY Avg_Serious_Injuries DESC;


-- Q4: Is there a difference in injury severity between instructional and personal flights?

SELECT
    Purpose_of_Flight,
    ROUND(
        AVG(
            Total_Fatal_Injuries
            + Total_Serious_Injuries
            + Total_Minor_Injuries
        ),
        2
    ) AS Avg_Injury_Count
FROM [airline_accidents_cleaned (1)]
WHERE Purpose_of_Flight IN ('Instructional','Personal')
GROUP BY Purpose_of_Flight;


-- Q5: Which flight purpose category has the highest number of Uninjured outcomes?

SELECT
    Purpose_of_Flight,
    SUM(Total_Uninjured) AS Total_Uninjured
FROM [airline_accidents_cleaned (1)]
GROUP BY Purpose_of_Flight
ORDER BY Total_Uninjured DESC;




-- Q6: What is the total injury count (Fatal + Serious + Minor) broken down by FAR Description?

SELECT
    FAR_Description,
    SUM(
        Total_Fatal_Injuries
        + Total_Serious_Injuries
        + Total_Minor_Injuries
    ) AS Total_Injuries
FROM [airline_accidents_cleaned (1)]
GROUP BY FAR_Description
ORDER BY Total_Injuries DESC;


-- Q7: Which regulatory part (FAR Description) is associated with the most fatal accidents?

SELECT
    FAR_Description,
    COUNT(*) AS Fatal_Accidents
FROM [airline_accidents_cleaned (1)]
WHERE Total_Fatal_Injuries > 0
GROUP BY FAR_Description
ORDER BY Fatal_Accidents DESC;