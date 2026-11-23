-- This transaction adds a new training event and related attendance
-- records. The changes are shown before being rolled back so the
-- sample database remains unchanged after the demonstration.
PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- Step 1: Add a new required training event.
INSERT INTO TrainingEvent
    (EventID, EventName, EventDate, Location, EventType, Required)
VALUES
    (9, 'Mission Planning LLAB', '2026-11-05',
     'Alumni Memorial Building', 'LLAB', 1);

-- Step 2: Add related attendance records for the new event.
INSERT INTO Attendance
    (AttendanceID, CadetID, EventID, AttendanceStatus, Notes)
VALUES
    (64, 1, 9, 'Present', NULL),
    (65, 2, 9, 'Present', NULL),
    (66, 3, 9, 'Late', 'Arrived after accountability');

-- Show the changes while the transaction is active.
SELECT
    te.EventID,
    te.EventName,
    te.EventDate,
    c.FirstName,
    c.LastName,
    a.AttendanceStatus
FROM TrainingEvent AS te
INNER JOIN Attendance AS a
    ON te.EventID = a.EventID
INNER JOIN Cadet AS c
    ON a.CadetID = c.CadetID
WHERE te.EventID = 9;

-- Step 3: Undo the entire transaction so the sample database remains unchanged.
ROLLBACK;

-- Verify that the event no longer exists. Used for testing purposes.
SELECT
    EventID,
    EventName
FROM TrainingEvent
WHERE EventID = 9;