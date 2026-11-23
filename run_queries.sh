#example from assignment used

#!/bin/bash

DB="afrotc.db"

echo "Recreating database..."


rm -f "$DB"

sqlite3 -bail "$DB" < schema.sql
sqlite3 -bail "$DB" < insert_data.sql

echo
echo "Running queries..."

#change to box for readable output
sqlite3 -header -box -bail "$DB" < queries.sql

echo
echo "Running transaction..."

sqlite3 -header -box -bail "$DB" < transaction.sql
status=$?

echo

if [ "$status" -eq 0 ]; then
    echo "Transaction completed successfully."
else
    echo "Transaction failed."
    echo "Uncommitted changes were rolled back."
    exit "$status"
fi

echo
echo "Done."