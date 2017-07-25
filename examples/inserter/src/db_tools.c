/* File:     db_tools.c
 * Author:   Mitchell Larson
 */

#include "db_tools.h"

#include <assert.h>
#include <sqlite3.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "mood.h"


#define TABLE_NAME "moods"

char * failure_message = NULL;
sqlite3 * db = NULL;

bool db_tools_insert(Mood * mood)
{
  assert(db);
  assert(mood);

  char * sql_string = mood_get_insert_string(mood, TABLE_NAME);

  if (failure_message)
  {
    sqlite3_free(failure_message);
    failure_message = NULL;
  }

  int ret = sqlite3_exec(
      db,
      sql_string,
      NULL,
      NULL,
      &failure_message
    );

  return ret == SQLITE_OK;
}

#include <stdio.h>

bool db_tools_insert_all(Mood ** moods, unsigned int moods_length)
{
  assert(db);
  assert(moods);

  if (moods_length == 0)
    return 0;

  char
    * sql_sub_string,
    sql_string [moods_length * 1024];

  sql_string[0] = 0;

  sql_sub_string = mood_get_insert_string(moods[0], TABLE_NAME);
  strcat(sql_string, sql_sub_string);
  free(sql_sub_string);


  for (unsigned int k = 1; k < moods_length; k++)
  {
    strcat(sql_string, ", ");
    sql_sub_string = mood_get_insert_values_string(moods[k]);
    strcat(sql_string, sql_sub_string);
    free(sql_sub_string);
  }

  int ret = sqlite3_exec(
      db,
      sql_string,
      NULL,
      NULL,
      &failure_message
    );

  return ret == SQLITE_OK;
}

bool db_tools_open(char * str)
{
  assert(!db);
  int ret = sqlite3_open(str, &db);

  return ret == SQLITE_OK;
}

bool db_tools_close()
{
  assert(db);

  int ret = sqlite3_close(db);
  db = NULL;

  if (failure_message)
  {
    sqlite3_free(failure_message);
    failure_message = NULL;
  }

  return ret == SQLITE_OK;
}



char * db_tools_get_failure_message()
{
  return failure_message;
}
