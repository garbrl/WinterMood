/* File:     main.c
 * Author:   Mitchell Larson
 */


#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <baselib/baselib.h>
#include <string.h>

#include "mood.h"
#include "db_tools.h"
#include "string_tools.h"


int
  count = -1,
  id_start = -1,
  user_id = -1;
char
  * city = NULL,
  * db_path = NULL;
time_t
  start_time = 0,
  time_increment = 1;





void parse_arguments(int argc, char ** argv);
int insert_moods(List * moods);
void clean_up(List * moods);
void print_help();
time_t parse_time(char * str);
time_t parse_time_increment(char * str);

int mood_callback(int sleep, int exercise, int overcast);



int main ( int argc, char ** argv )
{
  List * moods;
  int failures;

  parse_arguments(argc, argv);

  if (db_path == NULL)
  {
    fprintf(stderr, "Must provide a 'db_path' argument\n");
    exit(2);
  }

  if (count == -1)
  {
    fprintf(stderr, "Must provide a 'count' argument\n");
    exit(2);
  }
  if (id_start == -1)
  {
    fprintf(stderr, "Must provide an 'id_start' argument\n");
    exit(2);
  }
  if (user_id == -1)
  {
    fprintf(stderr, "Must provide a 'user_id' argument\n");
    exit(2);
  }
  if (city == NULL)
  {
    fprintf(stderr, "Must provide a 'city' argument\n");
    exit(2);
  }
  if (start_time == 0)
  {
    fprintf(stderr, "Must provide a 'start-time' argument\n");
    exit(2);
  }
  if (time_increment == 0)
  {
    fprintf(stderr, "Must provide a 'time-increment' argument\n");
    exit(2);
  }

  printf("Connecting to database... ");
  if (!db_tools_open(db_path))
  {
    fprintf(stderr, "Failed to connect to database.\n");
    exit(4);
  }
  printf("Done\n");

  printf("Generating Moods... ");
  srand(time(NULL));
  moods = mood_form_range(
    count,
    id_start,
    user_id,
    city,
    start_time,
    time_increment,
    mood_callback
    );
  printf("Done\n");

  printf("Injecting moods into database... ");
  failures = insert_moods(moods);
  printf("Done\n");

  if (failures > 0)
  {
    fprintf(stderr, "WARNING; %d out of %d inserts failed\n", failures, list_size(moods));
  }

  clean_up(moods);

  free(city);
}

void parse_arguments(int argc, char ** argv)
{

  if (argc == 1)
  {
    print_help();
    exit(0);
  }


  for(unsigned int k = 1; k < argc; k++)
  {

    char
      * arg = argv[k],
      * substring;

    if (string_tools_starts_with(arg, "--db-path="))
    {
      db_path = string_tools_substring(arg, strlen("--db-path="));
    }
    else if (string_tools_starts_with(arg, "--count="))
    {
      substring = string_tools_substring(arg, strlen("--count="));
      count = strtol(substring, NULL, 0);
      if (errno || count <= 0)
      {
        fprintf(stderr, "Invalid Argument. Cannot parse '%s' as a positive integer\n", substring);
        exit(1);
      }
      free(substring);
    }
    else if (string_tools_starts_with(arg, "--id-start="))
    {
      substring = string_tools_substring(arg, strlen("--id-start="));
      id_start = strtol(substring, NULL, 0);
      if (errno)
      {
        fprintf(stderr, "Invalid Argument. Cannot parse '%s' as an integer\n", substring);
        exit(1);
      }
      free(substring);
    }
    else if (string_tools_starts_with(arg, "--user-id="))
    {
      substring = string_tools_substring(arg, strlen("--user-id="));
      user_id = strtol(substring, NULL, 0);
      if (errno)
      {
        fprintf(stderr, "Invalid Argument. Cannot parse '%s' as an integer\n", substring);
        exit(1);
      }
      free(substring);
    }
    else if (string_tools_starts_with(arg, "--city="))
    {
      city = string_tools_substring(arg, strlen("--city="));
    }
    else if (string_tools_starts_with(arg, "--start-time="))
    {
      substring = string_tools_substring(arg, strlen("--start-time="));
      start_time = parse_time(substring);
      if (start_time == 0)
      {
        fprintf(stderr, "Invalid Argument. Cannot parse '%s' as a date-time\n", substring);
        exit(1);
      }
      free(substring);
    }
    else if (string_tools_starts_with(arg, "--time-increment="))
    {
      substring = string_tools_substring(arg, strlen("--time-increment="));
      time_increment = parse_time_increment(substring);
      if (time_increment == 0)
      {
        fprintf(stderr, "Invalid Argument. Cannot parse '%s' as a date-time increment\n", substring);
        exit(1);
      }
      free(substring);
    }
    else
    {
      fprintf(stderr, "Failed to parse argument '%s'\n", arg);
      exit(1);
    }
  }

}

int insert_moods(List * moods)
{
  unsigned int length = list_size(moods);
  ListTraversal * traversal = list_get_traversal(moods);
  int index = 0, failures = 0;

  while (!list_traversal_completed(traversal))
  {

    printf("%02d%%", index * 100 / length);
    fflush(stdout);
    Mood * mood = (Mood *) list_traversal_next(traversal).ptr;

    if(!db_tools_insert(mood))
      failures++;

    printf("\033[3D");
    fflush(stdout);

    index++;

  }

}


void clean_up(List * moods)
{
  ListTraversal * traversal = list_get_traversal(moods);


  while (!list_traversal_completed(traversal))
  {
    mood_destroy( (Mood *) list_traversal_next(traversal).ptr );
  }

  list_destroy(moods);

  db_tools_close();
}

time_t parse_time(char * str)
{
  struct tm datetime;

  /* expects format 'YY-MM-DD hh:mm:ss' */
  /*                 01234567890123456  */
  if (strlen(str) != 17)
  {
    return (time_t) 0;
  }

  if (
      str[2] != '-' ||
      str[5] != '-' ||
      str[8] != ' ' ||
      str[11] != ':' ||
      str[14] != ':'
    )
    return (time_t) 0;

  str[2] = 0;
  str[5] = 0;
  str[8] = 0;
  str[11] = 0;
  str[14] = 0;

  int
    year,
    month,
    day,
    hour,
    minute,
    second,
    errno_ag = 0;

  year = strtol(str, NULL, 10);
  errno_ag |= errno;

  month = strtol(str + 3, NULL, 10);
  errno_ag |= errno;

  day = strtol(str + 6, NULL, 10);
  errno_ag |= errno;

  hour = strtol(str + 9, NULL, 10);
  errno_ag |= errno;

  minute = strtol(str + 12, NULL, 10);
  errno_ag |= errno;

  second = strtol(str + 15, NULL, 10);
  errno_ag |= errno;


  str[2] = '-';
  str[5] = '-';
  str[8] = ' ';
  str[11] = ':';
  str[14] = ':';

  if (errno_ag)
  {
    return (time_t) 0;
  }

  datetime.tm_year = 100 + year;
  datetime.tm_mon = month - 1;
  datetime.tm_mday = day;

  datetime.tm_hour = hour;
  datetime.tm_min = minute;
  datetime.tm_sec = second;

  return mktime(&datetime);
}

time_t parse_time_increment(char * str)
{
  unsigned int length = strlen(str);
  time_t ret;

  if (string_tools_ends_with(str, "m"))
  {
    str[length - 1] = 0;
    ret = (time_t) (60 * strtol(str, NULL, 10));
    str[length - 1] = 'm';
    if (errno)
    {
      return (time_t) 0;
    }
  }
  else if (string_tools_ends_with(str, "h"))
  {
    str[length - 1] = 0;
    ret = (time_t) (60 * 60 * strtol(str, NULL, 10));
    str[length - 1] = 'h';
    if (errno)
    {
      return (time_t) 0;
    }
  }
  else if (string_tools_ends_with(str, "d"))
  {
    str[length - 1] = 0;
    ret = (time_t) (24 * 60 * 60 * strtol(str, NULL, 10));
    str[length - 1] = 'd';
    if (errno)
    {
      return (time_t) 0;
    }
  }
  else
  {
    ret = (time_t) strtol(str, NULL, 10);
    if (errno)
    {
      return (time_t) 0;
    }
  }

  return ret;
}

void print_help()
{
  printf("WinterMood Inserter\n");
  printf("\n");
  printf("Usage:\n");
  printf(" wmi --db_path=<db_path> --count=<count> --id-start=<id_start> --user-id=<user_id> --city=<city> --start-time=<start_time> --time-increment=<time_increment>\n");
  printf(" wmi --help\n");
  printf("\n");
  printf("Notes:\n");
  printf(" the argument value 'start-time' must be of the form 'YY-MM-DD hh:mm:ss'\n");
  printf(" the argument value 'time-increment' may be appended by 'd', 'h', or 'm' to consider the value in days, hours, or minutes, respectively. (default is seconds)");
  printf("\n");

}



int mood_callback(int sleep, int exercise, int overcast)
{
  double ag =
    ((double) sleep) / (60 * 8) +
    ((double) exercise) / 30 +
    ((double) overcast) / 70;

  ag += (double) (rand() % 20) / 10;

  if (ag < 1)
    return 1;
  else if (ag > 4)
    return 4;
  else
    return (int) ag;


}
