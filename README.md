# A Connectivity Strategy for the Evaluation of Smart Grid Models Based on the Ethernet Technology

A simulation strategy that enables data transmission between the modeled components of a Smart Grid is proposed in this paper. The proposed simulation strategy, referred to as the connectivity strategy, enables the integration of a physical communication network into Smart Grids simulations. The connectivity strategy comprises three steps: selection of Smart Grids functionality, data transmission over a TCP/IP network, and connectivity strategy evaluation. Each step is described to ensure transparency and reproducibility in Smart Grid simulations, addressing the limitations associated with the lack of specifications when a communication network is implemented into power systems simulations. Furthermore, a Hardware-in-the-loop (HIL) approach is presented for developing and evaluating the proposed connectivity strategy using the HIL technique. Through this approach, the strategy is validated by establishing the communication between simulation and embedded systems via a physical Ethernet network. In a case study, the use of the connectivity strategy to simulate a distribution system automation (DA) functionality is demonstrated. This simulation allows the evaluation of protection schemes in a Smart Grid using MATLAB/Simulink and a Texas Instruments development kit. Results show that the proposed connectivity strategy could estimate the communication delays for different simulation scenarios.

![GRAPHICAL_ABSTRACT](https://github.com/REPOSGICEPGREDYPGTT/COMUNICACIONES_SG_PAPER/assets/88640926/408eb632-e6a9-49e3-ba69-4c3c8f1c9038)

# What can you find in this repository?

In the folder PAPER_SMART_GRIDS you can find two folders, as follows.

IEEE_34B: this folder contains the source code for the implementation in Matlab/Simulink®.
* IEEE34BARRAS.slx: it's the Simulink® model of the power system used in the paper.
* libreria_comunicaciones_cliente1T.slx: this Simulink® library has the designed transmitter and receiver blocks. 
* libreria_medidores1T.slx: it has the monitoring IED model.
* script_ciclo_vs1.m: Matlab® script to run reading and writting operations between Simulink® and the communication network. 
* script_client_1_inicio1.m: Matlab® script to create and setup the client object and enable the communication with the server. This script is executed from InitFcn of the model IEEE34BARRAS.slx.
* tcpip_cliente_pc1.m: Matlab® script that has the class to create client side objects.

CODE_TI: this folder contains the source codes in C (HL_sys_main and lwip_functions) with the created functions described in the paper. Remember that the Hercules™ RM57Lx Launchpad™ development kit from Texas Instruments® was used to test this functions. If you have doubts about the ports/firmware configuration, there is a PDF file with the screenshots to make it.


