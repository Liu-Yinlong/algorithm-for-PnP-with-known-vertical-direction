# Algorithm-for-PnP-with-known-vertical-direction
Algorithm for PnP with known vertical direction
***********

+ gen_data.m->octave/matlab code to generate synthetic data
+ main_test.m->octave/matlab code to test the bin file


+ main.c main.h->our algorithm
+ misc_func.c misc_func.h-> details for our algorithm
**************
```
1. To start, run compile.sh
2. Then run main_test.m in matlab/octave
```

## Note:

### The input data file struct is a little strange

**First line**: input number

**Second line**:[vertical direction in world coordinate, vertical direction in camera coordinate] seprated by comma

**Next**: [2D bear vector,3D point set] seprated by tab

**Next**: [2D bear vector,3D point set] seprated by tab

...


  >Author: Yinlong.Liu(at)TUM.de
  
  >Date:Feb. 2022


