#!/bin/bash

./wmi --db-path="../../db/development.sqlite3" --count=370 --id-start=10000 --user-id=1 --city="Vancouver" --start-time="15-05-23 17:14:00" --time-increment=48h --time-increment-variance=5h
exit $?
