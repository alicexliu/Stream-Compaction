CUDA Stream Compaction
======================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 2**

* Alice Liu
  * [LinkedIn](https://www.linkedin.com/in/aliceliuu/), [personal website](https://aliceliu.xyz/)
* Tested on: Windows 11, AMD Ryzen 5 7640HS @ 4.30GHz 16GB, RTX 4060 Laptop GPU 8GB (Personal Laptop)

## Overview

In this project, I implemented prefix sums scan and stream compaction on the CPU and GPU. The stream compaction implemented removes 0s from an array of integers. 

### Scan
CPU Implementation

Naive GPU Implementation

Work-Efficient GPU Implementation

### Stream Compaction
CPU Implementation

Work-Efficient GPU Implementation

## Performance Analysis

### Test Program Output (128 block size, 2<sup>8</sup> array size)
```

****************
** SCAN TESTS **
****************
    [  11   1   8  46  22  40  45  40  47  17   5  20  40 ...  38   0 ]
==== cpu scan, power-of-two ====
   elapsed time: 0.0006ms    (std::chrono Measured)
    [   0  11  12  20  66  88 128 173 213 260 277 282 302 ... 6226 6264 ]
==== cpu scan, non-power-of-two ====
   elapsed time: 0.0003ms    (std::chrono Measured)
    [   0  11  12  20  66  88 128 173 213 260 277 282 302 ... 6144 6189 ]
    passed
==== naive scan, power-of-two ====
   elapsed time: 0.099424ms    (CUDA Measured)
    passed
==== naive scan, non-power-of-two ====
   elapsed time: 0.093184ms    (CUDA Measured)
    passed
==== work-efficient scan, power-of-two ====
   elapsed time: 0.23552ms    (CUDA Measured)
    passed
==== work-efficient scan, non-power-of-two ====
   elapsed time: 0.124928ms    (CUDA Measured)
    passed
==== thrust scan, power-of-two ====
   elapsed time: 0.074752ms    (CUDA Measured)
    passed
==== thrust scan, non-power-of-two ====
   elapsed time: 0.0408ms    (CUDA Measured)
    passed

*****************************
** STREAM COMPACTION TESTS **
*****************************
    [   3   1   0   0   0   0   1   0   3   3   3   2   2 ...   0   0 ]
==== cpu compact without scan, power-of-two ====
   elapsed time: 0.0006ms    (std::chrono Measured)
    [   3   1   1   3   3   3   2   2   3   2   3   2   3 ...   3   1 ]
    passed
==== cpu compact without scan, non-power-of-two ====
   elapsed time: 0.0006ms    (std::chrono Measured)
    [   3   1   1   3   3   3   2   2   3   2   3   2   3 ...   3   1 ]
    passed
==== cpu compact with scan ====
   elapsed time: 0.0028ms    (std::chrono Measured)
    [   3   1   1   3   3   3   2   2   3   2   3   2   3 ...   3   1 ]
    passed
==== work-efficient compact, power-of-two ====
   elapsed time: 0.3328ms    (CUDA Measured)
    passed
==== work-efficient compact, non-power-of-two ====
   elapsed time: 0.136192ms    (CUDA Measured)
    passed
Press any key to continue . . .
```