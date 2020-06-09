# bus-synchronizers
Here are few designs for bus synchronizers, when synchronizing bus lines, the risk is when every bit synchronizes in different time.

The goal here is to synchronize values from one clock domain to another, please note that the values are not changing very often (except gray synchronizer for incremental values). 

Every design will include:

•	Block diagram.

•	System-Verilog code.

•	Testbench.

•	Brief explanation.

Please note that in order to simulate meta-stable states I used an uncertainty model. The model in use will be the same throughout the various synchronizers. The uncertainty model was created by one of my university teachers mr. Refael Gantz.

