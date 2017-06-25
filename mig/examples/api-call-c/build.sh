#!/bin/bash


gcc cJSON_Utils.c cJSON.c file_tools.c main.c -o api-example.out
exit $?
