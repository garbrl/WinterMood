#!/bin/bash


gcc src/*.c -o wmi -g -Wall -lbaselib -lpthread -lsqlite3
exit $?
