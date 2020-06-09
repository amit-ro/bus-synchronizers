This synchronizer can be used when there is a need to synchronize a bus that its value is not changing very often.

In this design only one synchronizer is needed, by that we can save hardware. The input value is monitored for changes, and when one is detected a signal is sent. That signal is then synchronized with the other clock domain and after it was successfully synchronized the input value is passed.

In the simulation the two clock domains are in the same frequency but there is a phase between them.

