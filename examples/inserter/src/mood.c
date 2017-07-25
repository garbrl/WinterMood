/* File:     mood.c
 * Authors:  Mitchell Larson, Vasundhara Gautam
 */

#include "mood.h"

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <baselib/baselib.h>


Mood * mood_new(
    int id,
    int user_id,
    char * city,
    int mood,
    int sleep,
    int exercise,
    int overcast,
    time_t entry_time
  )
{
  assert(city);

  Mood * ret = (Mood *) malloc(sizeof(Mood));
  assert(ret);

  ret->id = id;
  ret->user_id = user_id;
  ret->mood = mood;
  ret->sleep = sleep;
  ret->exercise = exercise;
  ret->overcast = overcast;
  ret->entry_time = entry_time;

  unsigned int city_length = strlen(city);

  ret->city = (char *) malloc(city_length + 1);
  assert(ret->city);

  memcpy(ret->city, city, city_length + 1);

  return ret;
}

void mood_destroy(Mood * mood)
{
  assert(mood);

  free(mood->city);
  free(mood);
}

char * mood_get_insert_string(Mood * mood, char * table_name)
{
  assert(mood);
  assert(table_name);

  char
    buffer [1024],
    * return_string,
    * time_string;

  time_string = mood_get_time_string(mood);

  sprintf(buffer,
    "INSERT INTO [%s] (id, userid, city, mood, sleep, exercise, overcast, created_at, updated_at) VALUES (%d, %d, '%s', %d, %d, %d, %d, '%s', '%s');",
    table_name,
    mood->id,
    mood->user_id,
    mood->city,
    mood->mood,
    mood->sleep,
    mood->exercise,
    mood->overcast,
    time_string,
    time_string
    );

  free(time_string);


  unsigned int string_length = strlen(buffer);

  return_string = (char *) malloc(string_length + 1);
  assert(return_string);

  memcpy(return_string, buffer, string_length + 1);

  return return_string;
}

char * mood_get_time_string(Mood * mood)
{
  char
    buffer [1024],
    * ret;

  struct tm * time_value = gmtime(&mood->entry_time);

  strftime(
    buffer,
    (size_t) 1023,
    "%Y-%m-%d %H:%M:%S.000000",
    time_value
    );

  unsigned int string_length = strlen(buffer);
  ret = (char *) malloc(string_length + 1);
  assert(ret);

  memcpy(ret, buffer, string_length + 1);


  return ret;
}

char * mood_to_string(Mood * mood)
{
  char
    buffer [1024],
    * ret;

  char * time_string = mood_get_time_string(mood);

  sprintf(
    buffer,
    "Mood:{id=%d, user_id=%d, mood=%d, sleep=%d, exercise=%d, overcast=%d, entry_time='%s', city='NYI'}",
    mood->id,
    mood->user_id,
    mood->mood,
    mood->sleep,
    mood->exercise,
    mood->overcast,
    time_string
    );

  free(time_string);

  unsigned int string_length = strlen(buffer);

  ret = (char *) malloc(string_length + 1);
  assert(ret);

  memcpy(ret, buffer, string_length + 1);

  return ret;
}



List * mood_form_range(
    unsigned int count,
    int id_start,
    int user_id,
    char * city,
    time_t start,
    time_t jump,
    int (*mood_callback)(int sleep, int exercise, int overcast)
  )
{
  assert(city);
  assert(mood_callback);

  List * ret = (List *) linked_list_new();

  int
    mood,
    sleep,
    exercise,
    overcast;

  for (unsigned int k = 0; k < count; k++)
  {
    /* technically monthly sunshine percentage which we will inverse to treat as overcast percentage */
    int overcastarr[12] = { 12,	32,	37,	45,	57,	67,	79,	92,	66,	36,	20,	12 };
    for (int i = 0; i < 12; i++)
    {
      overcastarr[i] = 100 - overcastarr[i];
    }

    /* uniform distribution between 6-8 hours */
    sleep = rand() % (2 * 60 + 1) + (6 * 60);

    /* uniform distribution between 0-1 hours */
    exercise = rand() % (1 * 60 + 1);

    /* overcast percentage based on month with noise */
    int overcastnoise = rand() % 11 + (-5);
    time_t entry_time_t = start + jump*k;
    struct tm * entry_time_struct = gmtime(&entry_time_t);
    int month = entry_time_struct->tm_mon;
    overcast = overcastnoise + overcastarr[month];

    mood = mood_callback(sleep, exercise, overcast);

    list_add(ret, (Any)(void *) mood_new(
        id_start + k,
        user_id,
        city,
        mood,
        sleep,
        exercise,
        overcast,
        start + jump * k
      ));

  }


  return ret;
}
