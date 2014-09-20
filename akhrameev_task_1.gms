* 09.2014 Akhrameev Pavel
* group 513 CMC MSU
* Practicum
* Task 1
* Optimization of nutrition and insulin injections for diabetes
*
sets
h / 0 * 1000 /

scalars
* healthy person scalars
a1_h /0.05/
a2_h /1.0/
a3_h /4.0/
a4_h /???/
b1_h /0.5/
b2_h /2.0/
b3_h /1.0/

* diabete scalars
a1_d /0.03/
a2_d /1.0/
a3_d /4.0/
a4_d /???/
b1_d /0.01/
b2_d /2.0/
b3_d /1.0/

variables
***************************** healthy person variables
x_h(h)
* x - sugar level in blood
y_h(h)
* y - deviation from the equilibrium level of insulin
z_h(h)
* z - meal level
***************************** diabete variables
x_d(h)
y_d(h)
z_d(h)
w(h)
* w - external insulin injections level (diabete only)
J
* J - in this task we need to minimize this key functional

