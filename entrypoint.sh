#!/bin/bash

echo '[INFO] Initializing DB and running migrations.'

python3 -m flask db init
python3 -m flask db migrate
python3 -m flask db upgrade
python3 -m flask crontab add

# by using exec the bash script will exit and continue running the python program.
exec python3 -m gunicorn --workers 3 --bind $ADDRESS:$PORT -m 007 wsgi:app
