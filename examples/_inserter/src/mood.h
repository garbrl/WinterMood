/* File:     mood.h
 * Author:   Mitchell Larson
 */

#ifndef __MOOD_H
#define __MOOD_H

#include <time.h>
#include <baselib/baselib.h>

typedef struct Mood
{
  int
    id,
    user_id,
    mood,
    overcast;
  float
    sleep,
    exercise;
  time_t entry_time;
  char * city;
}
Mood;



Mood * mood_new(
    int id,
    int user_id,
    char * city,
    int mood,
    float sleep,
    float exercise,
    int overcast,
    time_t entry_time
  );
void mood_destroy(Mood * mood);

char * mood_get_insert_string(Mood * mood, char * table_name);
char * mood_get_insert_values_string(Mood * mood);
char * mood_get_time_string(Mood * mood);
char * mood_to_string(Mood * mood);


List * mood_form_range(
    unsigned int count,
    int id_start,
    int user_id,
    char * city,
    time_t start,
    time_t jump,
    time_t jump_variance,
    int (*mood_callback)(float sleep, float exercise, int overcast)
  );


#endif
