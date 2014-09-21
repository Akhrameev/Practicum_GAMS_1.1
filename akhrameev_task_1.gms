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
a4_h /0.5/
*Unknown
b1_h /0.5/
b2_h /2.0/
b3_h /1.0/

* diabete scalars
a1_d /0.03/
a2_d /1.0/
a3_d /4.0/
a4_d /0.5/
*Unknown
b1_d /0.01/
b2_d /2.0/
b3_d /1.0/

T /24.0/
* T - hours a day

x0 /1.0/
*Unknown
y0 /0.0/
* values for edges

A /1.0/
*Unknown
B /0.5/
*Unknown

deltaH;
* range form 0 to T devide by number of h dots + 1 (T/max(h))

deltaH = T/(card(h) - 1);

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
functionalJ;
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


* here I write for GAMS my first (dy/dt) equation (for healthy person)
* w is for diabete only, so I missed it here
* H(ksi) replaced with just sign(max(ksi, 0)) function - they are equivalent
eqy_h(h-1).. y_h(h) =e=  y_h(h-1) +
             deltaH * (b1_h*(x_h(h-1)-x0) * sign(max(x_h(h-1)-x0,0))
                            - b2_h*y_h(h-1));


* here I write for GAMS my second (dx/dt) equation (for healthy person)
* again H(ksi) == sign(max(ksi,0)) trick
* two minuses multiplication made in mind to make equations clearer
eqx_h(h-1).. x_h(h) =e= x_h(h-1) +
             deltaH *(-a1_h*x_h(h-1)*y_h(h-1) +
                     a2_h*(x0-x_h(h-1))*sign(max(x0-x_h(h-1),0)) +
                     a4_h*(x0-x_h(h-1))*sign(max(x_h(h-1)-x0,0)) +
                     a3_h*z_h(h-1));

y_h.fx(h)$(ord(h) = 1)=y0;
x_h.fx(h)$(ord(h) = 1)=x0;
y_d.fx(h)$(ord(h) = 1)=y0;
x_d.fx(h)$(ord(h) = 1)=x0;
* edges

eqy_d(h-1).. y_d(h) =e=  y_d(h-1) +
             deltaH * (b1_d*(x_d(h-1)-x0) * sign(max(x_d(h-1)-x0,0))
                            - b2_d*y_d(h-1) + b3_d*w(h-1));
* as eqy_h, but with diabete koefficients and w

eqx_d(h-1).. x_d(h) =e= x_d(h-1) +
             deltaH *(-a1_d*x_d(h-1)*y_d(h-1) +
                     a2_d*(x0-x_d(h-1))*sign(max(x0-x_d(h-1),0)) +
                     a4_d*(x0-x_d(h-1))*sign(max(x_d(h-1)-x0,0)) +
                     a3_d*z_d(h-1));
* as eqx_h, but with diabete koefficients

functionalJ.. J =e= sum(h,
                 deltaH * (A*sqr(x_d(h)-x_h(h)) + B*sqr(w(h))));
* summ example from docs:
*    scalar totsupply total supply over all plants;
*    totsupply = sum(i, a(i));

model nutritionAndInsulinInjectionsForDiabetes_1 /all/;

solve nutritionAndInsulinInjectionsForDiabetes_1 using dnlp minimizing J;

Parameter PLOT_1 data for plotter;
PLOT_1("x_diabete-x_healthy",h,"y")=x_d.l(h)-x_h.l(h);
* .l (level) is used to get values (to make complilable)
PLOT_1("x_diabete-x_healthy",h,"x")=ord(h)*deltaH;
$libinclude gnuplotxyz PLOT_1 x y



