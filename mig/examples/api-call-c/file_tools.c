// Author:    Mitchell Larson


#include <stdio.h>
#include <stdlib.h>



unsigned int get_file_length(FILE * file)
{
  fseek(file, 0L, SEEK_END);
  unsigned long ret = ftell(file);
  fseek(file, 0L, SEEK_SET);

  return (unsigned int) ret;
}


char * file_tools_read_all(char * file_name)
{

  FILE * file;            /* File object */
  unsigned int file_size; /* Determined size of the file */
  char * return_string;   /* String to return */
  size_t read_length;     /* size of the string read from file */

  file = fopen(file_name, "rb");
  if (!file)
    return NULL;

  file_size = get_file_length(file);

  return_string = (char *) malloc(file_size + 1); /* one extra bit allocated for null terminator */

  read_length = fread(return_string, (size_t) 1, (size_t) file_size, file);
  fclose(file);

  if (read_length != file_size) /* if the read failed to complete entirely, return failure */
  {
    free(return_string);
    return NULL;
  }
  return_string [file_size] = '\0'; /* null terminator */

  return return_string;
}

void file_tools_delete_if_extant(char * file_name)
{
  remove(file_name);
}
