/* File:    string_tools.h
 * Author:  Mitchell Larson
 */

#ifndef __STRING_TOOLS_H
#define __STRING_TOOLS_H

#include <stdbool.h>


bool string_tools_starts_with(char * str1, char * str2);
bool string_tools_ends_with(char * str1, char * str2);

char * string_tools_substring(char * str, unsigned int start);



#endif
