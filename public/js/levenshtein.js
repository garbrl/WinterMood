/*
 * File:     levenshtein.js
 * Author:   Mitchell Larson
 *
 * Purpose:
 *   Code file implementing the Wagner-Fischer
 *   algorithm for calculating the levenshtein
 *   distance between two strings
 */


/*
 * Generates an array of arrays
 * for use by the Matrix object
 */
function formMatrixArray(width, height) {

  var ret = [];

  for (var x = 0; x < width; x += 1) {

    var sub_array = [];
    for (var y = 0; y < height; y += 1) {
      sub_array.push(0);
    }

    ret.push(sub_array);
  }

  return ret;
}

/*
 * Returns the minimum value of the
 * specified array. The array is assumed
 * to be full of numbers
 */
function minimumOf(array) {

  best = array[0];

  for (var k = 1; k < array.length; k += 1)
  {
    if (array[k] < best)
      best = array[k];
  }

  return best;
}

/*
 * Object specification for a 'width'x'height' Matrix
 */
function Matrix(width, height) {

  this.width = width;
  this.height = height;

  this.array = formMatrixArray(width, height);

  /*
   * Gets the element in the specified row
   * and column of the matrix. If the specified
   * indices are out of bounds, an exception is
   * thrown
   */
  this.get = function(x, y) {
    if (x < 0 || y < 0 || x >= this.width || y >= this.height)
      throw "Matrix get out of range (" + x + ", " + y + ")";
    return this.array[x][y];
  }

  /*
   * Sets the element in the specified row
   * and column of the matrix to the specified
   * value. If the specified
   * indices are out of bounds, an exception is
   * thrown
   */
  this.set = function(x, y, val) {
    if (x < 0 || y < 0 || x >= this.width || y >= this.height)
      throw "Matrix set out of range (" + x + ", " + y + ")";
    this.array[x][y] = val;
  }

}


/*
 * Calculates the levenshtein distance between
 * the provided strings using an implementation
 * of the Wagner-Fischer algorithm
 */
function levenshteinDistance(str1, str2) {

  var matrix = new Matrix(str1.length + 1, str2.length + 1);


  for (var k = 0; k <= str1.length; k += 1) {
    matrix.set(k, 0, k);
  }
  for (var k = 0; k <= str2.length; k += 1) {
    matrix.set(0, k, k);
  }

  for (var j = 1; j <= str2.length; j += 1) {
    for (var i = 1; i <= str1.length; i += 1) {

      if (str1[i - 1] == str2[j - 1])
        matrix.set(i, j, matrix.get(i - 1, j - 1));
      else
        matrix.set(i, j, minimumOf([
          matrix.get(i - 1, j) + 1,
          matrix.get(i, j - 1) + 1,
          matrix.get(i - 1, j - 1) + 1
        ]));


    }
  }

  return matrix.get(str1.length, str2.length);
}


console.log("Finished loading levenshtein.js");
