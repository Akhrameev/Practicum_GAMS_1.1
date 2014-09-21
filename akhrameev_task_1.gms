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
a4_h /0.0/
*Unknown
b1_h /0.5/
b2_h /2.0/
b3_h /1.0/

* diabete scalars
a1_d /0.03/
a2_d /1.0/
a3_d /4.0/
a4_d /0.0/
*Unknown
b1_d /0.01/
b2_d /2.0/
b3_d /1.0/

T /24.0/
* T - hours a day

deltaH;
* range form 0 to T devide by number of h dots + 1 (T/max(h))

deltaH = card(h) - 1;

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

equations
eqx_h(h)
* for dx/dt - dynamics of sugar in blood
eqy_h(h)
* for dy/dt - dynamics of insulin in blood
eqz(h)
* meal level for healthy person
eqx_d(h)
eqy_d(h)
* dynamics for diabete
functionalJ
* just key functional

* here I write for GAMS this multiconditional meal level function
* ord(h)*deltaH = current time during a day
eqz(h).. z_h(h) =e= 50 * sign(max(ord(h)*deltaH - 8.0,0))  *
                         sign(max(8.3 - ord(h)*deltaH,0))  +
*from 8.0 to 8.3
                   100 *(sign(max(ord(h)*deltaH - 13.0,0)) *
                         sign(max(13.3 - ord(h)*deltaH,0)) +
* from 13.0 to 13.3
                         sign(max(ord(h)*deltaH - 20.0,0)) *
                         sign(max(20.3 - ord(h)*deltaH,0)));
* from 20.0 to 20.3

