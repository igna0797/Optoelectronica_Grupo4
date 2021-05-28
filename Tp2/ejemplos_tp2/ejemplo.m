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
L_g = 76.2e-3; #m        - largo del medio activo 

tau_rt = 2*(L_c-L_g)/c + 2*L_g*n/c; 
#ajuste R_p y tau_p 143 147 2101
corrimiento=125;

Tiempo2=Tiempo(corrimiento:end,1).-Tiempo(corrimiento,1);;
Bombeo2=Bombeo(corrimiento:end,1);
##parametros01 = fminsearch(@(param) err_quad_bombeo(param, [Tiempo2, Bombeo2]), [9,130e-6])#[1e19,100e-6])
##
##
parametros01(2)=1.1728e-04;
parametros01(1)= 0.85e+25;
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

##tau_p=  parametros01(2);
%ESTOS SON LOS BUENOS
tau_p= 1.1728e-04;
beta =  23e-3;
R_p = 3.13e+25;
%%
##tau_p=  1.4683e-04;
##beta =  10.2e-3;
##R_p =   1e+25;#corrimiento 45

retardo=Tiempo(corrimiento,1);
[t, P, g] = qswitch(TI, beta, I_s, R_p, tau_p,retardo);

Laser2=Laser(corrimiento:end,1);
figure();
hold on;
plot(Tiempo2/1e-6, Laser2/max(Laser2), "b");
plot(t/1e-6, P/max(P), "r", "linewidth", 2);
plot(t/1e-6, g/max(g), "g", "linewidth", 2);
grid on;
xlabel("t / us");
legend("Medido", "Simulado", "Ganancia");
xlim([0,500])

normp=max(P);
normg=max(g);
figure()
hold on
grid on
grid minor
plot(t/1e-6,P/normp,"r","linewidth",1);
##plot(t/1e-6, g/normg, "g", "linewidth", 1);
[t, P, g] = qswitch(TI, beta, I_s, R_p/2, tau_p,retardo);
plot(t/1e-6,P/normp ,"b","linewidth",1);
##plot(t/1e-6, g/normg, "m", "linewidth", 1);
xlabel("t / us");
##legend("Rp= 3.13e+25", "ganancia Rp", "Rp/2","Ganancia Rp/2");
[t, P, g] = qswitch(TI, beta, I_s, 2*R_p, tau_p,retardo);
plot(t/1e-6,P/normp ,"g","linewidth",1);
legend("R_p", "R_p/2","2R_p");
text(300,1.5,"R_P=3.13e+25","fontsize",15,"fontweight","bold")

figure()
hold on
grid on
[t, P, g] = qswitch(TI, beta, I_s, R_p, tau_p,retardo);
plot(t/1e-6,P/max(P),"r","linewidth",2);

[t, P, g] = qswitch(TI, beta/2, I_s, R_p, tau_p,retardo);
plot(t/1e-6,P/max(P),"b","linewidth",1);

[t, P, g] = qswitch(TI, 2*beta, I_s, R_p, tau_p,retardo);
plot(t/1e-6,P/max(P),"g","linewidth",1);
legend("\\beta", "\\beta/2","2\\beta");
xlabel("t / us");
text(350,0.6,"\\beta=23e-3","fontsize",15,"fontweight","bold")

