#!/bin/bash


gcc src/*.c -o wmi -g -lbaselib -lpthread -lsqlite3
exit $?
