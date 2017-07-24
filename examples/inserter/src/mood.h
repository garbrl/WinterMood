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
    sleep,
    exercise,
    overcast;
  time_t entry_time;
  char * city;
}
Mood;



Mood * mood_new(
    int id,
    int user_id,
    char * city,
    int mood,
    int sleep,
    int exercise,
    int overcast,
    long entry_time
  );
void mood_destroy(Mood * mood);

char * mood_get_insert_string(Mood * mood, char * table_name);
char * mood_get_time_string(Mood * mood);
char * mood_to_string(Mood * mood);


List * mood_form_range(
    unsigned int count,
    int id_start,
    int user_id,
    char * city,
    time_t start,
    time_t jump,
    int (*mood_callback)(int sleep, int exercise, int overcast)
  );


#endif
