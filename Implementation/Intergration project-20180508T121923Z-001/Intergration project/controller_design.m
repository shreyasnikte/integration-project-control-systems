% Controller desing

%%sys = d2c(sys_2sines);

Kp = 0.2;
Ki = 0.1;
Kd = 0;
Tf = 10;


K = pid(Kp,Ki,Kd,Tf);

L = K*sys;

C = feedback(L,-1);

S = C/L;

bode(S)