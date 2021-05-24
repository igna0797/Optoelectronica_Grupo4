# Codigo correspondiente al TP2
close all;
clear all;
format short e

load mediciones1C2021.mat;
# tiene las variables Tiempo, Laser y Bombeo.
# [Tiempo] = s

c=3e8;
h = 6.62e-34; %J.s  
lambda=1064e-9;
n=1.82;
sigma=2.8e-19 ;%cm2
tau_2=230e-6;
tau_1=30e-9;
tau_21=tau_2  ;%Esto no estoy seguro
v=c/lambda/n;
I_s = h*v/sigma/tau_2*(1+tau_1/tau_2*(1-tau_2/tau_21))^-1;  # W/m^2
L_c = 235e-3;
tau_rt = 2*L_c/c;
#ajuste R_p y tau_p 143 147 2101
corrimiento=147;
corrimiento=100;

Tiempo2=Tiempo(corrimiento:end,1).-Tiempo(corrimiento,1);;
Bombeo2=Bombeo(corrimiento:end,1);
parametros01 = fminsearch(@(param) err_quad_bombeo(param, [Tiempo2, Bombeo2]), [9,130e-6])#[1e19,100e-6])


#parametros01(2)=1.4383e-04;
R=parametros01(1).*(Tiempo2./parametros01(2)).^2.*exp(-2.*Tiempo2./parametros01(2));
figure();
hold on;
plot(Tiempo2/1e-6, R/max(R), "b");
plot(Tiempo2/1e-6, Bombeo2/max(Bombeo2), "g");
grid on;
xlabel("t / us");
legend("Laser", "Bombeo");
#
 #falta normalizar las variables a graficar
##figure();
##hold on;
##plot(Tiempo/1e-6, Laser/max(Laser), "b");
##plot(Tiempo/1e-6, Bombeo/max(Bombeo), "g");
##grid on;
##xlabel("t / us");
##legend("Laser", "Bombeo");

TI = 500e-6/tau_rt;
#tau_p= 1.1383e-04;
#tau_p= 1.4383e-04;
tau_p=  parametros01(2);
##beta = 0.014;
##R_p = 0.975e25;

beta =  18.2e-3
R_p =    1.1e+25
retardo=Tiempo(corrimiento,1);
[t, P, g] = qswitch(TI, beta, I_s, R_p, tau_p,retardo);
figure();
hold on;
plot(Tiempo/1e-6, Laser/max(Laser), "b");
plot(t/1e-6, P/max(P), "r", "linewidth", 2);
plot(t/1e-6, g/max(g), "g", "linewidth", 2);
grid on;
xlabel("t / us");
legend("Medido", "Simulado", "Ganancia");
xlim([0,500])

