from flask import Flask, render_template, request
import sqlite3

app = Flask(__name__)

DATABASE = "afrotc.db"


def get_db_connection():
    conn = sqlite3.connect(DATABASE)
    #row by name, not number
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/cadets")
def cadets():
    search = request.args.get("search", "").strip()

    conn = get_db_connection()

    if search:
        cadet_rows = conn.execute(
            """
            SELECT
                c.CadetID,
                c.FirstName,
                c.LastName,
                c.ASClass,
                c.Major,
                c.ActiveStatus,
                f.FlightName
            FROM Cadet AS c
            LEFT JOIN Flight AS f
                ON c.FlightID = f.FlightID
            WHERE c.FirstName LIKE ?
               OR c.LastName LIKE ?
            ORDER BY c.LastName, c.FirstName
            """,
            (f"%{search}%", f"%{search}%")
        ).fetchall()
    else:
        cadet_rows = conn.execute(
            """
            SELECT
                c.CadetID,
                c.FirstName,
                c.LastName,
                c.ASClass,
                c.Major,
                c.ActiveStatus,
                f.FlightName
            FROM Cadet AS c
            LEFT JOIN Flight AS f
                ON c.FlightID = f.FlightID
            ORDER BY c.LastName, c.FirstName
            """
        ).fetchall()

    conn.close()

    return render_template(
        "cadets.html",
        cadets=cadet_rows,
        search=search
    )

@app.route("/cadets/<int:cadet_id>")
def cadet_details(cadet_id):
    conn = get_db_connection()

    cadet = conn.execute(
        """
        SELECT
            c.CadetID,
            c.FirstName,
            c.LastName,
            c.ASClass,
            c.Email,
            c.Major,
            c.ActiveStatus,
            f.FlightName
        FROM Cadet AS c
        LEFT JOIN Flight AS f
            ON c.FlightID = f.FlightID
        WHERE c.CadetID = ?
        """,
        (cadet_id,)
    ).fetchone()

    if cadet is None:
        conn.close()
        return "Cadet not found", 404

    fitness = conn.execute(
        """
        SELECT
            AssessmentDate,
            Pushups,
            Situps,
            RunTime,
            Score
        FROM FitnessAssessment
        WHERE CadetID = ?
        ORDER BY AssessmentDate DESC
        """,
        (cadet_id,)
    ).fetchall()

    positions = conn.execute(
        """
        SELECT
            lp.PositionName,
            cp.Semester,
            f.FlightName,
            cp.StartDate,
            cp.EndDate
        FROM CadetPosition AS cp
        INNER JOIN LeadershipPosition AS lp
            ON cp.PositionID = lp.PositionID
        LEFT JOIN Flight AS f
            ON cp.FlightID = f.FlightID
        WHERE cp.CadetID = ?
        ORDER BY cp.StartDate DESC
        """,
        (cadet_id,)
    ).fetchall()

    conn.close()

    return render_template(
        "cadet_details.html",
        cadet=cadet,
        fitness=fitness,
        positions=positions
    )

@app.route("/events/add", methods=["GET", "POST"])
def add_event():
    message = None
    error = None

    if request.method == "POST":
        event_name = request.form.get("event_name", "").strip()
        event_date = request.form.get("event_date", "").strip()
        location = request.form.get("location", "").strip()
        event_type = request.form.get("event_type", "").strip()
        required_value = request.form.get("required", "0")

        #input validation
        if not event_name:
            error = "Event name is required."

        elif not event_date:
            error = "Event date is required."

        elif not event_type:
            error = "Event type is required."

        elif required_value not in ("0", "1"):
            error = "Required value is invalid."

        else:
            required = int(required_value)

            conn = get_db_connection()

            try:
                conn.execute(
                    """
                    INSERT INTO TrainingEvent
                        (EventName, EventDate, Location, EventType, Required)
                    VALUES (?, ?, ?, ?, ?)
                    """,
                    (
                        event_name,
                        event_date,
                        location if location else None,
                        event_type,
                        required
                    )
                )

                conn.commit()
                message = "Training event added successfully."

            except sqlite3.IntegrityError:
                error = "The training event could not be added because of a database constraint."

            except sqlite3.DatabaseError:
                error = "A database error occurred while adding the training event."

            finally:
                conn.close()

    return render_template(
        "add_event.html",
        message=message,
        error=error
    )

@app.route("/attendance", methods=["GET", "POST"])
def record_attendance():
    message = None
    error = None

    conn = get_db_connection()

    cadets = conn.execute(
        """
        SELECT CadetID, FirstName, LastName
        FROM Cadet
        WHERE ActiveStatus = 1
        ORDER BY LastName, FirstName
        """
    ).fetchall()

    events = conn.execute(
        """
        SELECT EventID, EventName, EventDate
        FROM TrainingEvent
        ORDER BY EventDate DESC
        """
    ).fetchall()

    if request.method == "POST":
        cadet_id = request.form.get("cadet_id", "").strip()
        event_id = request.form.get("event_id", "").strip()
        status = request.form.get("status", "").strip()
        notes = request.form.get("notes", "").strip()

        if not cadet_id.isdigit():
            error = "Please select a valid cadet."

        elif not event_id.isdigit():
            error = "Please select a valid event."

        elif status not in ("Present", "Absent", "Excused", "Late"):
            error = "Please select a valid attendance status."

        else:
            try:
                conn.execute(
                    """
                    INSERT INTO Attendance
                        (CadetID, EventID, AttendanceStatus, Notes)
                    VALUES (?, ?, ?, ?)
                    """,
                    (
                        int(cadet_id),
                        int(event_id),
                        status,
                        notes if notes else None
                    )
                )

                conn.commit()
                message = "Attendance recorded successfully."

            except sqlite3.IntegrityError:
                error = (
                    "Attendance could not be recorded. "
                    "This cadet may already have an attendance record "
                    "for that event."
                )

            except sqlite3.DatabaseError:
                error = "A database error occurred."

    conn.close()

    return render_template(
        "attendance.html",
        cadets=cadets,
        events=events,
        message=message,
        error=error
    )

@app.route("/cadets/update-flight", methods=["GET", "POST"])
def update_cadet_flight():
    message = None
    error = None

    conn = get_db_connection()

    cadets = conn.execute(
        """
        SELECT
            CadetID,
            FirstName,
            LastName
        FROM Cadet
        ORDER BY LastName, FirstName
        """
    ).fetchall()

    flights = conn.execute(
        """
        SELECT
            FlightID,
            FlightName
        FROM Flight
        ORDER BY FlightName
        """
    ).fetchall()

    if request.method == "POST":
        cadet_id = request.form.get("cadet_id", "").strip()
        flight_id = request.form.get("flight_id", "").strip()

        if not cadet_id.isdigit():
            error = "Please select a valid cadet."

        elif not flight_id.isdigit():
            error = "Please select a valid flight."

        else:
            cadet = conn.execute(
                """
                SELECT CadetID
                FROM Cadet
                WHERE CadetID = ?
                """,
                (int(cadet_id),)
            ).fetchone()

            flight = conn.execute(
                """
                SELECT FlightID
                FROM Flight
                WHERE FlightID = ?
                """,
                (int(flight_id),)
            ).fetchone()

            if cadet is None:
                error = "Cadet not found."

            elif flight is None:
                error = "Flight not found."

            else:
                try:
                    conn.execute(
                        """
                        UPDATE Cadet
                        SET FlightID = ?
                        WHERE CadetID = ?
                        """,
                        (int(flight_id), int(cadet_id))
                    )

                    conn.commit()
                    message = "Cadet flight updated successfully."

                except sqlite3.DatabaseError:
                    error = "A database error occurred while updating the cadet."

    conn.close()

    return render_template(
        "update_flight.html",
        cadets=cadets,
        flights=flights,
        message=message,
        error=error
    )

@app.route("/readiness")
def readiness_report():
    conn = get_db_connection()

    readiness = conn.execute(
        """
        SELECT
            CadetID,
            FirstName,
            LastName,
            FlightName,
            EventsRecorded,
            EventsAttended,
            AttendancePercentage
        FROM CadetReadiness
        ORDER BY AttendancePercentage ASC, LastName, FirstName
        """
    ).fetchall()

    conn.close()

    return render_template(
        "readiness.html",
        readiness=readiness
    )

@app.route("/fitness")
def fitness_history():
    conn = get_db_connection()

    fitness = conn.execute(
        """
        SELECT
            c.FirstName,
            c.LastName,
            f.FlightName,
            fa.AssessmentDate,
            fa.Pushups,
            fa.Situps,
            fa.RunTime,
            fa.Score
        FROM FitnessAssessment AS fa
        INNER JOIN Cadet AS c
            ON fa.CadetID = c.CadetID
        LEFT JOIN Flight AS f
            ON c.FlightID = f.FlightID
        ORDER BY fa.AssessmentDate DESC, c.LastName, c.FirstName
        """
    ).fetchall()

    conn.close()

    return render_template(
        "fitness.html",
        fitness=fitness
    )


if __name__ == "__main__":
    app.run()