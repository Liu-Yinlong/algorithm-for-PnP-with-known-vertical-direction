# Algorithm-for-PnP-with-known-vertical-direction
Algorithm for PnP with known vertical direction
>Y. Liu, G. Chen and A. Knoll, "[Absolute Pose Estimation with a Known Direction by Motion Decoupling](https://ieeexplore.ieee.org/document/10093787)," in IEEE Transactions on Circuits and Systems for Video Technology, doi: 10.1109/TCSVT.2023.3264451.
***********

+ **gen_data.m**->matlab code to generate synthetic data
+ **main_test.m**->matlab code to test the bin file


+ **main.c; main.h**->our algorithm
+ **misc_func.c; misc_func.h**-> details for our algorithm
**************
```
1. To start, run compile.sh
2. Then run main_test.py 
```

## Note:

### The input data file struct is a little strange

**First line**: input number

**Second line**:[vertical direction in world coordinate, vertical direction in camera coordinate] seprated by comma

**Next**: [2D bear vector,3D point set] seprated by tab

**Next**: [2D bear vector,3D point set] seprated by tab

...

### Save file is
[R[0]...R[8],t[0],t[1],t[2],run_time(ms)]

  >Author: Yinlong.Liu(at)TUM.de
  
  >Date:Feb. 2022


