-- Requirement 1: Filtering and Sorting
-- Shows all active cadets in AS300 or above, sorted by
-- ASClass descending, then by last name and first name.
SELECT
    CadetID,
    FirstName,
    LastName,
    ASClass,
    Major
FROM Cadet
WHERE ActiveStatus = 1
  AND ASClass >= 300
ORDER BY ASClass DESC, LastName, FirstName;


-- Requirement 2: INNER JOIN
-- Shows each cadet and the flight they are assigned to.
SELECT
    c.CadetID,
    c.FirstName,
    c.LastName,
    c.ASClass,
    f.FlightName
FROM Cadet AS c
INNER JOIN Flight AS f
    ON c.FlightID = f.FlightID
ORDER BY f.FlightName, c.LastName;


-- Requirement 3: LEFT JOIN
-- Shows cadets who do not have any fitness assessments
-- recorded in the database.
SELECT
    c.CadetID,
    c.FirstName,
    c.LastName,
    c.ASClass
FROM Cadet AS c
LEFT JOIN FitnessAssessment AS fa
    ON c.CadetID = fa.CadetID
WHERE fa.AssessmentID IS NULL
ORDER BY c.LastName, c.FirstName;


-- Requirement 4: Three-Table Join
-- Shows each cadet's leadership assignments, including
-- their position, semester, and associated flight.
SELECT
    c.FirstName || ' ' || c.LastName AS CadetName,
    lp.PositionName,
    cp.Semester,
    f.FlightName,
    cp.StartDate,
    cp.EndDate
FROM Cadet AS c
INNER JOIN CadetPosition AS cp
    ON c.CadetID = cp.CadetID
INNER JOIN LeadershipPosition AS lp
    ON cp.PositionID = lp.PositionID
LEFT JOIN Flight AS f
    ON cp.FlightID = f.FlightID
ORDER BY cp.Semester DESC, lp.Rank, CadetName;


-- Requirement 5: Aggregate Query
-- Shows overall fitness assessment statistics for the
-- detachment.
SELECT
    COUNT(*) AS AssessmentsRecorded,
    ROUND(AVG(Score), 1) AS AverageScore,
    MIN(Score) AS LowestScore,
    MAX(Score) AS HighestScore
FROM FitnessAssessment;


-- Requirement 6: GROUP BY and HAVING
-- Shows flights with an average fitness score of at least
-- 90.0.
SELECT
    f.FlightName,
    COUNT(fa.AssessmentID) AS AssessmentsRecorded,
    ROUND(AVG(fa.Score), 1) AS AverageFitnessScore
FROM Flight AS f
INNER JOIN Cadet AS c
    ON f.FlightID = c.FlightID
INNER JOIN FitnessAssessment AS fa
    ON c.CadetID = fa.CadetID
GROUP BY f.FlightID, f.FlightName
HAVING AVG(fa.Score) >= 90.0
ORDER BY AverageFitnessScore DESC;


-- Requirement 7: Subquery
-- Shows fitness assessments that scored above the overall
-- average fitness score.
SELECT
    c.FirstName,
    c.LastName,
    fa.AssessmentDate,
    fa.Score
FROM Cadet AS c
INNER JOIN FitnessAssessment AS fa
    ON c.CadetID = fa.CadetID
WHERE fa.Score > (
    SELECT AVG(Score)
    FROM FitnessAssessment
)
ORDER BY fa.Score DESC;


-- Requirement 8: Set Operation
-- Shows cadets who were either absent or excused from at
-- least one required training event.
-- UNION removes duplicate cadets.
SELECT
    c.CadetID,
    c.FirstName,
    c.LastName
FROM Cadet AS c
INNER JOIN Attendance AS a
    ON c.CadetID = a.CadetID
INNER JOIN TrainingEvent AS te
    ON a.EventID = te.EventID
WHERE te.Required = 1
  AND a.AttendanceStatus = 'Absent'

UNION

SELECT
    c.CadetID,
    c.FirstName,
    c.LastName
FROM Cadet AS c
INNER JOIN Attendance AS a
    ON c.CadetID = a.CadetID
INNER JOIN TrainingEvent AS te
    ON a.EventID = te.EventID
WHERE te.Required = 1
  AND a.AttendanceStatus = 'Excused'

ORDER BY LastName, FirstName;


-- Requirement 9: View
-- Uses the CadetReadiness view to show cadets whose
-- attendance percentage is below 90 percent.
SELECT
    CadetID,
    FirstName,
    LastName,
    FlightName,
    EventsRecorded,
    EventsAttended,
    AttendancePercentage
FROM CadetReadiness
WHERE AttendancePercentage < 90.0
ORDER BY AttendancePercentage, LastName, FirstName;