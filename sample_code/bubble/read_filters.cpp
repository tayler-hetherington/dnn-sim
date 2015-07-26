#include <fstream>
#include <string>
#include <iostream>
#include <sstream>
#include <math.h>

bool read_filters(char const * const filename, T * array, int size){
  std::ifstream is (filename);
  std::string str;
  char c;

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

      array[idx] = f;
      idx++;
    }
  }
  if ( idx != size ) {
        std::cout << "read_filters read fewer numbers than size\n";
        return false;
  }
  if ( ! is.eof() )
  {
    std::cout << "read_filters didn't reach the end of file\n";
  }
  std::cout << "read " << idx << "/" << size << " synapses\n";
  return true;
}
