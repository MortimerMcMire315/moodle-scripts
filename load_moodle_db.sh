#!/bin/bash

if [ ! $# -eq 2 ]; then
    cat << END
Usage: $0 DIR SQL
Imports a SQL file to the MySQL database referenced by the config.php file
inside DIR.
END
    exit 0
fi

CONFIGF="$1/config.php"
SQL="$2"

if [ ! -f "$CONFIGF" ]; then
    echo "No config.php file found in the given directory."
    exit 1
fi


DBTYPE=$(grep -m 1 '\$CFG->dbtype' "$CONFIGF" | awk -F= '{print $2}' | sed -re "s/[^']*?'([^']+)'.*$/\1/g")
DBHOST=$(grep -m 1 '\$CFG->dbhost' "$CONFIGF" | awk -F= '{print $2}' | sed -re "s/[^']*?'([^']+)'.*$/\1/g")
DBNAME=$(grep -m 1 '\$CFG->dbname' "$CONFIGF" | awk -F= '{print $2}' | sed -re "s/[^']*?'([^']+)'.*$/\1/g")
DBUSER=$(grep -m 1 '\$CFG->dbuser' "$CONFIGF" | awk -F= '{print $2}' | sed -re "s/[^']*?'([^']+)'.*$/\1/g")
DBPASS=$(grep -m 1 '\$CFG->dbpass' "$CONFIGF" | awk -F= '{print $2}' | sed -re "s/[^']*?'([^']+)'.*$/\1/g")

if [ ! "$DBTYPE" = "mysqli" ]; then
    echo "Not a MySQL database."
    exit 1
fi

pv $SQL | mysql -h "$DBHOST" -u "$DBUSER" -p"$DBPASS" -D"$DBNAME"

#DBNAME=$(grep -m 1 '\$CFG->dbname' "$CONFIGF")
#DBNAME=$(grep -m 1 '\$CFG->dbname' "$CONFIGF")
