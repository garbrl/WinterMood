#!/bin/bash

./wmi --db-path="../../db/development.sqlite3" --count=10 --id-start=20000 --user-id=0 --city="Vancouver" --start-time="17-07-23 17:14:00" --time-increment=5h
exit $?
