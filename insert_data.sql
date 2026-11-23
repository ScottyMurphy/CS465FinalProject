
-- Flights
INSERT INTO Flight (FlightID, FlightName) VALUES
(1, 'A Flight'),
(2, 'C Flight'),
(3, 'G Flight'),
(4, 'H Flight');

-- Cadets
INSERT INTO Cadet
    (CadetID, FirstName, LastName, ASClass, Email, Major, ActiveStatus, FlightID)
VALUES
(1, 'Ethan', 'Brooks', 100, 'ebrooks@vols.utk.edu', 'Computer Science', 1, 1),
(2, 'Maya', 'Chen', 200, 'mchen@vols.utk.edu', 'Mechanical Engineering', 1, 1),
(3, 'Noah', 'Davis', 300, 'ndavis@vols.utk.edu', 'Political Science', 1, 2),
(4, 'Avery', 'Flores', 400, 'aflores@vols.utk.edu', 'Nursing', 1, 2),
(5, 'Liam', 'Grant', 200, 'lgrant@vols.utk.edu', 'Computer Engineering', 1, 3),
(6, 'Sophia', 'Hall', 300, 'shall@vols.utk.edu', 'Business Analytics', 1, 3),
(7, 'Jackson', 'Irwin', 100, 'jirwin@vols.utk.edu', 'Aerospace Engineering', 1, 4),
(8, 'Olivia', 'Jones', 400, 'ojones@vols.utk.edu', 'Supply Chain Management', 1, 4),
(9, 'Caleb', 'King', 250, 'cking@vols.utk.edu', 'Physics', 1, 2),
(10, 'Emma', 'Lewis', 500, 'elewis@vols.utk.edu', 'Mathematics', 0, NULL);


-- Training Events
INSERT INTO TrainingEvent
    (EventID, EventName, EventDate, Location, EventType, Required)
VALUES
(1, 'Fall Welcome LLAB', '2026-08-27', 'Alumni Memorial Building', 'LLAB', 1),
(2, 'PFA Preparation PT', '2026-09-02', 'Tom Black Track', 'PT', 1),
(3, 'Drill Practice', '2026-09-10', 'Humanities Plaza', 'LLAB', 1),
(4, 'CPR Training', '2026-09-17', 'Student Union', 'Training', 0),
(5, 'Commander''s Call', '2026-09-24', 'Alumni Memorial Building', 'Briefing', 1),
(6, 'Field Leadership Exercise', '2026-10-03', 'Cherokee Farms', 'FTX', 1),
(7, 'Cyber Career Brief', '2026-10-08', 'Min Kao Building', 'Briefing', 0),
(8, 'Fall Mock PFA', '2026-10-15', 'Tom Black Track', 'PT', 1);


-- Attendance
INSERT INTO Attendance
    (AttendanceID, CadetID, EventID, AttendanceStatus, Notes)
VALUES
(1, 1, 1, 'Present', NULL),
(2, 2, 1, 'Present', NULL),
(3, 3, 1, 'Present', NULL),
(4, 4, 1, 'Present', NULL),
(5, 5, 1, 'Late', 'Arrived after class ended'),
(6, 6, 1, 'Present', NULL),
(7, 7, 1, 'Excused', 'Academic conflict'),
(8, 8, 1, 'Present', NULL),
(9, 9, 1, 'Present', NULL),

(10, 1, 2, 'Present', NULL),
(11, 2, 2, 'Present', NULL),
(12, 3, 2, 'Present', NULL),
(13, 4, 2, 'Excused', 'Medical appointment'),
(14, 5, 2, 'Present', NULL),
(15, 6, 2, 'Late', 'Transportation delay'),
(16, 7, 2, 'Present', NULL),
(17, 8, 2, 'Present', NULL),
(18, 9, 2, 'Absent', NULL),

(19, 1, 3, 'Present', NULL),
(20, 2, 3, 'Present', NULL),
(21, 3, 3, 'Late', 'Arrived during accountability'),
(22, 4, 3, 'Present', NULL),
(23, 5, 3, 'Present', NULL),
(24, 6, 3, 'Present', NULL),
(25, 7, 3, 'Present', NULL),
(26, 8, 3, 'Excused', 'University event'),
(27, 9, 3, 'Present', NULL),

(28, 1, 4, 'Present', NULL),
(29, 3, 4, 'Present', NULL),
(30, 5, 4, 'Present', NULL),
(31, 6, 4, 'Present', NULL),
(32, 8, 4, 'Present', NULL),

(33, 1, 5, 'Present', NULL),
(34, 2, 5, 'Present', NULL),
(35, 3, 5, 'Present', NULL),
(36, 4, 5, 'Present', NULL),
(37, 5, 5, 'Excused', 'Lab conflict'),
(38, 6, 5, 'Present', NULL),
(39, 7, 5, 'Present', NULL),
(40, 8, 5, 'Present', NULL),
(41, 9, 5, 'Late', 'Traffic delay'),

(42, 1, 6, 'Present', NULL),
(43, 2, 6, 'Present', NULL),
(44, 3, 6, 'Present', NULL),
(45, 4, 6, 'Present', NULL),
(46, 5, 6, 'Present', NULL),
(47, 6, 6, 'Present', NULL),
(48, 7, 6, 'Absent', NULL),
(49, 8, 6, 'Present', NULL),
(50, 9, 6, 'Excused', 'Illness'),

(51, 1, 7, 'Present', NULL),
(52, 2, 7, 'Present', NULL),
(53, 5, 7, 'Present', NULL),
(54, 6, 7, 'Present', NULL),

(55, 1, 8, 'Present', NULL),
(56, 2, 8, 'Present', NULL),
(57, 3, 8, 'Present', NULL),
(58, 4, 8, 'Present', NULL),
(59, 5, 8, 'Present', NULL),
(60, 6, 8, 'Present', NULL),
(61, 7, 8, 'Present', NULL),
(62, 8, 8, 'Late', 'Arrived after warm-up'),
(63, 9, 8, 'Absent', NULL);


-- Fitness Assessments

INSERT INTO FitnessAssessment
    (AssessmentID, CadetID, AssessmentDate, Pushups, Situps, RunTime, Score)
VALUES
(1, 1, '2026-09-05', 52, 48, 690, 88.4),
(2, 1, '2026-10-15', 58, 52, 655, 93.1),
(3, 2, '2026-09-05', 41, 47, 735, 86.7),
(4, 2, '2026-10-15', 45, 51, 710, 90.2),
(5, 3, '2026-09-05', 55, 50, 665, 92.5),
(6, 4, '2026-09-05', 38, 44, 760, 83.8),
(7, 5, '2026-09-05', 60, 54, 625, 95.6),
(8, 5, '2026-10-15', 64, 58, 605, 97.4),
(9, 6, '2026-09-05', 46, 49, 700, 90.8),
(10, 7, '2026-10-15', 50, 46, 680, 89.9),
(11, 8, '2026-09-05', 42, 50, 720, 88.2),
(12, 9, '2026-10-15', 48, 45, 695, 89.0);


-- Leadership Positions
INSERT INTO LeadershipPosition
    (PositionID, PositionName, Rank, Description)
VALUES
(1, 'Wing Commander', 1, 'Leads the cadet wing and coordinates major wing activities.'),
(2, 'Vice Wing Commander', 2, 'Assists the Wing Commander and coordinates staff functions.'),
(3, 'Squadron Commander', 3, 'Leads a cadet squadron.'),
(4, 'A-Staff Lead', 4, 'Staff section leader within the wing.'),
(5, 'A-Staff Support', 5, 'Assists in staff Activities.'),
(6, 'Physical Fitness Officer', 6, 'Creates and implements physical fitness programs.');


-- Cadet Leadership Assignments
-- FlightID is NULL for wing-level positions.
INSERT INTO CadetPosition
    (CadetPositionID, CadetID, PositionID, StartDate, EndDate, Semester, FlightID)
VALUES
(1, 8, 1, '2026-08-20', NULL, 'Fall 2026', NULL),
(2, 4, 2, '2026-08-20', NULL, 'Fall 2026', NULL),
(3, 3, 4, '2026-08-20', NULL, 'Fall 2026', 2),
(4, 6, 4, '2026-08-20', NULL, 'Fall 2026', 3),
(5, 2, 4, '2026-08-20', NULL, 'Fall 2026', 1),
(6, 8, 4, '2026-01-15', '2026-05-05', 'Spring 2026', 4),
(7, 5, 5, '2026-08-20', NULL, 'Fall 2026', 3),
(8, 1, 6, '2026-08-20', NULL, 'Fall 2026', 1),
(9, 9, 6, '2026-08-20', NULL, 'Fall 2026', 2),
(10, 7, 6, '2026-08-20', NULL, 'Fall 2026', 4);
