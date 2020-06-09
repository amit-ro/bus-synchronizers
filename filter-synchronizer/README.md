This synchronizer can be used when there is a need to synchronize a bus that its value is not changing very often.

In this design there is a use in some sort of a filter, the filter ensures that the bus is being synchronized correctly. Until then the output value will be the previous values sent through the synchronizer.  

The main drawback of this design is that there is a need for a lot of synchronizers, the number of synchronizers is the width of the bus.

In the simulation the two clock domains are in the same frequency but there is a phase between them.

