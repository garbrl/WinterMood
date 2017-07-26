/* File:    string_tools.c
 * Author:  Mitchell Larson
 */

#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>


bool string_tools_starts_with(char * str1, char * str2)
{
  assert(str1);
  assert(str2);

  unsigned int
    str1len = strlen(str1),
    str2len = strlen(str2);

  if (str2len > str1len)
    return false;

  for (unsigned int k = 0; k < str2len; k++)
  {
    if (str1[k] != str2[k])
      return false;
  }

  return true;
}

bool string_tools_ends_with(char * str1, char * str2)
{
  assert(str1);
  assert(str2);

  unsigned int
    str1len = strlen(str1),
    str2len = strlen(str2);

  if (str2len > str1len)
    return false;

  for (int k = str1len - 1; k >= str1len - str2len; k--)
  {
    if (str1[k] != str2[k - str1len + str2len])
      return false;
  }

  return true;
}

char * string_tools_substring(char * str, unsigned int start)
{
  assert(str);

  unsigned int length = strlen(str);

  assert(start <= length);

  char * ret = (char *) malloc(length - start + 1);

  memcpy(ret, str + start, length - start + 1);

  return ret;
}
