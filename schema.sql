PRAGMA foreign_keys = ON;



DROP VIEW IF EXISTS CadetReadiness;

DROP TABLE IF EXISTS CadetPosition;
DROP TABLE IF EXISTS Attendance;
DROP TABLE IF EXISTS FitnessAssessment;
DROP TABLE IF EXISTS TrainingEvent;
DROP TABLE IF EXISTS LeadershipPosition;
DROP TABLE IF EXISTS Cadet;
DROP TABLE IF EXISTS Flight;


CREATE TABLE Flight (
    FlightID INTEGER PRIMARY KEY,
    FlightName TEXT NOT NULL UNIQUE
);

CREATE TABLE Cadet (
    CadetID INTEGER PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    ASClass INTEGER NOT NULL
        CHECK (ASClass IN (100, 200, 250, 300, 400, 500)),
    Email TEXT UNIQUE,
    Major TEXT NOT NULL,
    ActiveStatus INTEGER NOT NULL DEFAULT 1
        CHECK (ActiveStatus IN (0, 1)),
    FlightID INTEGER,
    FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID)
        ON UPDATE CASCADE --Cascade updates val on all foreign keys
        ON DELETE SET NULL
);

CREATE TABLE TrainingEvent (
    EventID INTEGER PRIMARY KEY,
    EventName TEXT NOT NULL,
    EventDate TEXT NOT NULL,
    Location TEXT,
    EventType TEXT NOT NULL,
    Required INTEGER NOT NULL DEFAULT 0
        CHECK (Required IN (0, 1))
);

CREATE TABLE Attendance (
    AttendanceID INTEGER PRIMARY KEY,
    CadetID INTEGER NOT NULL,
    EventID INTEGER NOT NULL,
    AttendanceStatus TEXT NOT NULL
        CHECK (
            AttendanceStatus IN ('Present', 'Absent', 'Excused', 'Late')
        ),
    Notes TEXT,
    FOREIGN KEY (CadetID)
        REFERENCES Cadet(CadetID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (EventID)
        REFERENCES TrainingEvent(EventID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (CadetID, EventID)
);

CREATE TABLE FitnessAssessment (
    AssessmentID INTEGER PRIMARY KEY,
    CadetID INTEGER NOT NULL,
    AssessmentDate TEXT NOT NULL,
    Pushups INTEGER NOT NULL
        CHECK (Pushups >= 0),
    Situps INTEGER NOT NULL
        CHECK (Situps >= 0),
    RunTime INTEGER NOT NULL
        CHECK (RunTime > 0),
    Score REAL NOT NULL
        CHECK (Score >= 0 AND Score <= 100),
    FOREIGN KEY (CadetID)
        REFERENCES Cadet(CadetID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE LeadershipPosition (
    PositionID INTEGER PRIMARY KEY,
    PositionName TEXT NOT NULL,
    Rank INTEGER
        CHECK (Rank IS NULL OR Rank > 0),
    Description TEXT
);

CREATE TABLE CadetPosition (
    CadetPositionID INTEGER PRIMARY KEY,
    CadetID INTEGER NOT NULL,
    PositionID INTEGER NOT NULL,
    StartDate TEXT NOT NULL,
    EndDate TEXT,
    Semester TEXT NOT NULL,
    FlightID INTEGER,
    FOREIGN KEY (CadetID)
        REFERENCES Cadet(CadetID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (PositionID)
        REFERENCES LeadershipPosition(PositionID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CHECK (EndDate IS NULL OR EndDate >= StartDate)
);



-- Supports lookups of attendance records for a specific event.
CREATE INDEX idx_attendance_event
ON Attendance(EventID);

-- Supports retrieval of a cadet's fitness history by date.
CREATE INDEX idx_fitness_cadet_date
ON FitnessAssessment(CadetID, AssessmentDate);

-- Supports lookups of leadership assignments for a cadet.
CREATE INDEX idx_cadet_position_cadet
ON CadetPosition(CadetID);



-- Summarizes each cadet's flight and attendance record.
-- Present and Late are counted as attended.
CREATE VIEW CadetReadiness AS
SELECT
    c.CadetID,
    c.FirstName,
    c.LastName,
    f.FlightName,
    COUNT(a.AttendanceID) AS EventsRecorded,
    SUM(
        CASE
            WHEN a.AttendanceStatus IN ('Present', 'Late') THEN 1
            ELSE 0
        END
    ) AS EventsAttended,
    ROUND(
        CASE
            WHEN COUNT(a.AttendanceID) = 0 THEN NULL -- Avoid division by zero; no events recorded
            ELSE
                100.0 * SUM(
                    CASE
                        WHEN a.AttendanceStatus IN ('Present', 'Late') THEN 1
                        ELSE 0
                    END
                ) / COUNT(a.AttendanceID)
        END,
        1
    ) AS AttendancePercentage
FROM Cadet AS c
LEFT JOIN Flight AS f 
-- cadet can still appear in the view even if they are not assigned to a flight (cadet is in Wing-level position)
    ON c.FlightID = f.FlightID
LEFT JOIN Attendance AS a
    ON c.CadetID = a.CadetID
GROUP BY
    c.CadetID,
    c.FirstName,
    c.LastName,
    f.FlightName;
