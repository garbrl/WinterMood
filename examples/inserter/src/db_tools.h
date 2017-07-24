/* File:     db_tools.h
 * Author:   Mitchell Larson
 */

#ifndef __DB_TOOLS_H
#define __DB_TOOLS_H

#include <assert.h>
#include <sqlite3.h>
#include <stdlib.h>
#include <stdbool.h>
#include "mood.h"


bool db_tools_insert(Mood * mood);
int db_tools_insert_all(Mood ** moods, unsigned int moods_length);
bool db_tools_open(char * str);
bool db_tools_close();

char * db_tools_get_failure_message();

#endif
