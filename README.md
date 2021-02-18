# RstController
Predictive control using a polynomial representation. It is based on second order continuous plant with transport delay.
Project was prepared with Matlab 2020b and Simulink environment. 

## Example
For presentation purposes, below transfer function was analysed:
<p align="center">
  <img src="img/transfer_fcn.PNG">
</p>

Following design requirements were assumed:
 - sampling time **T<sub>s</sub> = 1s**
 - static gain **k<sub>s</sub> = 2**
 - rise time **T<sub>n</sub> = 5s**
 - max overshoot **M<sub>p</sub> < 10%**

With usage of *desgin_controller.m* below polynomials of predictive controller were calculated:
<p align="center">
  <img src="img/rst_polynomials.PNG">
</p>

File *simulation/simulink_model.slx* contains whole control system model with both continuous and discrete plants and RST controller. Moreover, there is possibility to add noise signal to model output. Schema of simulink model for above transfer function:
<p align="center">
  <img src="img/simulink_model.PNG">
</p>

Results of given example:
<p align="center">
  <img src="img/results.PNG">
</p>
