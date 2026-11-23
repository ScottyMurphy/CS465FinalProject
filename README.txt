#Afrotc Cadet Training Readiness Tracker

#DBMS Used: SQLite3
#Language Used: Python using Flask

#Requirements:
- Python 3
- Flask
- SQLite database files included with project

#Installation
- Install flask using: pip install flask


#Set up database:
    a. Run:
        sqlite3 afrotc.db
    b. Run:
        .read schema.sql
    c. Run:
        .read insert_data.sql  
    SQLite stores the database in a local file afrotc.db 
    no separate database server, account, or password is required.

#Running the Application
1. Open terminal in the project directory
2. Install flask:
    python -m pip install flask
3. Run:
    python app.py
4. The server will start, open a web browse and go to:
    http://127.0.0.1:5000


#Application Operations
The below operations fulfill the operations listed on the assignment write
up in the same order. The operations are found on the home page unless otherwise indicated.

1. Browse/Search Cadets
    This page displays cadet information and allows the user to search by first
    or last name.

2. View Cadet Details
    From the Cadet list under Browse/Search Cadets, click a cadet's name. The details
    from this page is the information from the related database tables. It includes name,
    flight, fitness assessment history and leadership positions.

3. Add Training Event
    The User can enter a training event  name, date, location, event type, 
    and if the event is mandatory. This operation inserts a new event into the
    TrainingEvent table.

4. Update Cadet flight
    User selects a cadet and then a new flight assignment. The application updates the 
    cadet's FlightID in the database.

5. View Readiness Report
    The report uses the CadetReadiness view to display the following:
    1. Cadet name
    2. Flight
    3. Events Recorded
    4. Events Attended
    5. Attendance Percentage
    Cadets that have below a 90% attendance record are highlighted

6. Record attendance (additional meaningful operation)
    The user selects a cadet, training event and attendance status. There are multiple 
    status options including; present, late, excused and absent. The application will 
    prevent duplicate records for the same event.

7. Fitness History (Additional)
    Displays recorded fitness assessments for all Cadets. Report includes:
    1. Cadet name
    2. Flight
    3. Assessment date
    4. Pushups, situps, run time
    5. Fitness Score


#Parameterized SQL
Used in multiple locations of the application. For example in the cadet search function.

#Error Handling
User input validation is used before database operations. Including:
1. Required Events Field
2. Duplicate Attendance records
3. Cadet IDs 
4. Flight ID 
Errors are handled with error messages, not database errors.

#Known Limitations
1. The application has no known limitations other than certain operations
such as reporting attendance can be tedious. In future development I would 
make the application able to report multiple cadets at once to improve user
experience.




