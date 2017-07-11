// Author:   Mitchell Larson


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include <assert.h>

#include "cJSON.h"
#include "file_tools.h"


/* Available query types */
#define QUERY_TYPE_CITY 1
#define QUERY_TYPE_COORDINATES 2
#define QUERY_TYPE_ZIP_CODE 4



/* Change this value for city queries */
#define QUERY_STRING_CITY "osdjosdf"

/* Change these values for coordinate queries */
#define QUERY_STRING_COORDINATE_LAT "25"
#define QUERY_STRING_COORDINATE_LONG "15"

/* Change this value for zip code queries */
#define QUERY_STRING_ZIP_CODE "CURRENTLY API NOT RESPONDING AS EXPECTED DO. MAY NOT WORK WITH CANADIAN ZIP CODES"


/* DO NOT CHANGE THESE VALUES */
#define TEMP_FILE_NAME ".api_call_temp.json"
#define API_KEY_VALUE "0c5e74401870eaa1f6872f30f3d329d3"


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * ONLY CHANGE IF USING A SUBSTITUTE OF 'wget' IS NECCESSARY   *
 * Text me if you have questions                               *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
#define HTTP_CLIENT_CALL_FORMAT_STRING "wget -o wget.log -O %s %s"



/* Methods local to this file */
char * get_city_query_string();
char * get_coordinates_query_string();
char * get_zip_query_string();
int perform_download(char *);
char * fix_string_for_system_call(char *);

int main ( void )
{


  /* Change this according to the desired query type */
  int query_type = QUERY_TYPE_CITY;

  char
    * api_call_string, /* the URI call to the API */
    * response_string  /* the response from the API */
    ;

  cJSON
    * response = NULL  /* the parsed response as a JSON object */
    ;

  switch (query_type)
  {
    case QUERY_TYPE_CITY:
      api_call_string = get_city_query_string();
      break;
    case QUERY_TYPE_COORDINATES:
      api_call_string = get_coordinates_query_string();
      break;
    case QUERY_TYPE_ZIP_CODE:
      api_call_string = get_zip_query_string();
      break;
  }


  fprintf(stdout, "API Call: http://%s\n", api_call_string);


  /* Adjusts string for system call */
  api_call_string = fix_string_for_system_call(api_call_string);




  /*
   * Downloads the file from the API
   */
  if (!perform_download(api_call_string))
  {
    fprintf(stderr, "Error! Failed to download!\n");
    return 1;
  }


  /*
   * Reads the response string from the temporary file
   */
  response_string = file_tools_read_all(TEMP_FILE_NAME); /* Reads the entire file and creates a string */
  if (!response_string)
  {
    fprintf(stderr, "Error! Failed to read temp file\n");
    return 2;
  }

  /*
   * Parses the string into a JSON object
   */

  response = cJSON_Parse(response_string); /* Parses response into JSON object */
  if (!response)
  {
    fprintf(stderr, "Error! Failed to parse JSON data\n");
    return 4;
  }

  fprintf(stdout, "\n\n\nSuccessfully downloaded and parsed!\n\n");

  /*
   * Reads some sample data from the response
   */
  cJSON * coordinates = cJSON_GetObjectItem(response, "coord");
  assert(coordinates);
  cJSON * lon = cJSON_GetObjectItem(coordinates, "lon");
  cJSON * lat = cJSON_GetObjectItem(coordinates, "lat");
  assert(lon);
  assert(lat);
  cJSON * weather = cJSON_GetObjectItem(response, "weather");
  assert(weather);
  cJSON * first_descriptor = weather->child;
  assert(first_descriptor);
  cJSON * description = cJSON_GetObjectItem(first_descriptor, "description");
  assert(description);


  fprintf(stdout, "Got weather at coordinates [%f,%f]\n", lon->valuedouble, lat->valuedouble);
  fprintf(stdout, "API states weather is: '%s'\n", description->valuestring);



  /* Delete temp file */
  file_tools_delete_if_extant(TEMP_FILE_NAME);

  /* Free all data */
  cJSON_Delete(response);
  free(response_string);
  free(api_call_string);
  return 0;
}


char * get_city_query_string()
{
  char
    stack_string [1024],
    * heap_string
    ;
  unsigned int
    string_length
    ;

  sprintf(stack_string,
    "api.openweathermap.org/data/2.5/weather?q=%s&APPID=%s",
    QUERY_STRING_CITY,
    API_KEY_VALUE);

  string_length = strlen(stack_string);
  heap_string = (char *) malloc(string_length + 1); /* one added for null termination */

  memcpy(heap_string, stack_string, (size_t) (string_length + 1));

  return heap_string;
}
char * get_coordinates_query_string()
{
  char
    stack_string [1024],
    * heap_string
    ;
  unsigned int
    string_length
    ;

  sprintf(stack_string,
    "api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&APPID=%s",
    QUERY_STRING_COORDINATE_LAT,
    QUERY_STRING_COORDINATE_LONG,
    API_KEY_VALUE);

  string_length = strlen(stack_string);
  heap_string = (char *) malloc(string_length + 1); /* one added for null termination */

  memcpy(heap_string, stack_string, (size_t) (string_length + 1));

  return heap_string;
}
char * get_zip_query_string()
{
  char
    stack_string [1024],
    * heap_string
    ;
  unsigned int
    string_length
    ;

  sprintf(stack_string,
    "api.openweathermap.org/data/2.5/weather?zip=%s&APPID=%s",
    QUERY_STRING_ZIP_CODE,
    API_KEY_VALUE);

  string_length = strlen(stack_string);
  heap_string = (char *) malloc(string_length + 1); /* one added for null termination */

  memcpy(heap_string, stack_string, (size_t) (string_length + 1));

  return heap_string;
}
int perform_download(char * api_call)
{
  char
    system_call_string [strlen(api_call) + 1024]
  ;

  sprintf(system_call_string, HTTP_CLIENT_CALL_FORMAT_STRING, TEMP_FILE_NAME, api_call);
  int ret = system(system_call_string); /* call to download to temp file */

  return !ret;
}

char * fix_string_for_system_call(char * string)
{
  unsigned int
    string_length = strlen(string),
    new_string_length,
    insert_top = 0
    ;
  char
    stack_string [string_length * 2],
    * heap_string
    ;

  for (unsigned int k = 0; k < string_length; k++)
  {
    switch (string[k])
    {
      case '&':
        stack_string [insert_top++] = '\\';
#ifdef __unix__
        stack_string [insert_top++] = '&';
#elif defined __WIN32
        stack_string [insert_top++] = '^';
#endif
        break;
      default:
        stack_string [insert_top++] = string[k];
        break;
    }
  }

  new_string_length = insert_top;

  heap_string = (char *) malloc(new_string_length + 1);
  memcpy(heap_string, stack_string, new_string_length);
  heap_string [new_string_length] = '\0'; /* null terminator */

  free(string);

  return heap_string;
}
