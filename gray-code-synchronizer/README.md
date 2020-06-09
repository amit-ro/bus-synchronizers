This synchronizer can only be used to synchronize incremental bus lines, like counters for example.

The risk when synchronizing a bus line is when individual bits synchronize at different times. By converting the bus to gray code, we can ensure that every time the value increment only one bit will change.

For example: 
* In binary 00 01 10 11, when the value changes from 01 to 10 there are two bits changing
* In gray code 00 01 11 10, only one bit changes every time.

In the simulation the two clock domains are in the same frequency but there is a phase between them.

