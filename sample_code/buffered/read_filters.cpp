#include <fstream>
#include <string>
#include <iostream>
#include <sstream>
#include <math.h>

// read filters from file that jorge generates
// input:
//      filename        input text file
//      array           output array
//      size            size of array
//
// returns:
//      int                 number of filters read
int read_filters(char const * const filename, T * array, int size){
  std::ifstream is (filename);
  float f;
  int idx=0;

  while (is)
  {
    std::string s;
    if (!getline( is, s )) break;

    std::istringstream ss( s );

    while (ss)
    {
      std::string s;
      if ( ! getline( ss, s, ',' ) ) break;
      std::stringstream test(s);
      test >> f;
      if (test.fail()) break;

      if (idx >= size) {
        std::cout << "read_filters idx >= size\n";
        return false;
      }
      if (isnan(f)){
        std::cout << "read_filters idx=" << idx << " is NaN\n";
        return false;
      }

      if (idx >= size){
        std::cout << "WARNING: read_filters: file contains more filters than " << size << ", stopping.\n";
        return idx;
      }
      array[idx] = f;
      idx++;
    }
  }
  if ( idx != size ) {
        std::cout << "WARNING: read_filters: file contains " << idx << " filter values, expected " << size << "\n";
        return false;
  }
  if ( ! is.eof() )
  {
    std::cout << "WARNING: read_filters didn't reach the end of file\n";
  }
  return idx;
}
