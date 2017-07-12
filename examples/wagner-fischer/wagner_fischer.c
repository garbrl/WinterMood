/*
 * File:     wagner_fischer.c
 * Purpose:  A test of the Wagner-Fischer algorithm
 *           for determining the Levenshtein difference
 *           between two strings
 * Author:   Mitchell Larson
 */


#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>

/*  TYPE: MATRIX  */

struct Matrix
{
  int * array;
  int width, height;
};

struct Matrix matrix_new(int m, int n)
{
  struct Matrix ret;

  ret.array = (int *) malloc(m * n * sizeof(int));
  assert(ret.array);

  ret.width = m;
  ret.height = n;

  return ret;
}

void matrix_destroy(struct Matrix matrix)
{
  free(matrix.array);
}



void matrix_set(struct Matrix matrix, int x, int y, int value)
{
  assert(x >= 0);
  assert(x < matrix.width);
  assert(y >= 0);
  assert(y < matrix.height);

  int pos = x + y * matrix.width;

  matrix.array[pos] = value;
}

int matrix_get(struct Matrix matrix, int x, int y)
{
  assert(x >= 0);
  assert(x < matrix.width);
  assert(y >= 0);
  assert(y < matrix.height);

  int pos = x + y * matrix.width;

  return matrix.array[pos];
}



/* === MATRIX === */



int minimumOf(int a, int b, int c) {

  if (a <= b && a <= c)
    return a;
  else if (b <= a && b <= c)
    return b;
  else if (c <= a && c <= b)
    return c;
  else
    assert(0);

}






int levenshtein_distance(char * s, char * t)
{
  unsigned int s_len = strlen(s), t_len = strlen(t);

  /* generate 2d array/matrix */
  struct Matrix matrix = matrix_new(s_len + 1, t_len + 1);

  for (int k = 0; k <= s_len; k++)
  {
    matrix_set(matrix, k, 0, k);
  }

  for (int k = 0; k <= t_len; k++)
  {
    matrix_set(matrix, 0, k, k);
  }



  for (int j = 1; j <= t_len; j++)
  {
    for (int i = 1; i <= s_len; i++)
    {
      if (s[i -1] == t[j - 1])
        matrix_set(matrix, i, j, matrix_get(matrix, i - 1, j - 1));
      else
        matrix_set(matrix, i, j, minimumOf(
          matrix_get(matrix, i - 1, j) + 1,
          matrix_get(matrix, i, j - 1) + 1,
          matrix_get(matrix, i - 1, j - 1) + 1
        ));
    }
  }

  int ret = matrix_get(matrix, s_len, t_len);
  matrix_destroy(matrix);
  return ret;

}


int main ( int argc, char ** argv )
{

  char * string_1 = "test";
  char * string_2 = "expiriment";

  if (argc < 3)
  {
    printf("Insufficient arguments provided. Using default of '%s' and '%s'\n", string_1, string_2);
  }
  else if (argc == 3)
  {
    string_1 = argv[1];
    string_2 = argv[2];
  }
  else
  {
    printf("Too many arguments! Requires two\n");
    return 1;
  }

  struct timeval start, end;
  long time;

  printf("Calculating Levenshtein distance between '%s' and '%s'...\n", string_1, string_2);

  gettimeofday(&start, NULL);
  int distance = levenshtein_distance(string_1, string_2);
  gettimeofday(&end, NULL);

  time = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);

  printf("Done\n");

  printf("Levenshtein distance: %d\n", distance);
  printf("Computation time:     %ld microseconds\n", time); 


  return 0;
}



