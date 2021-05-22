clc
close all
clear all
load mediciones1C2021.mat;

figure(1);
hold on;
plot(Tiempo/1e-6, Laser/mean(Laser), "b");
plot(Tiempo/1e-6, Bombeo/mean(Bombeo), "g");
grid on;
xlabel("t / us");
legend("Laser", "Bombeo");

%Parametros

TI = 3e5; %tiempo final?
c=3e8
h = 6.62e-34; %J.s  
lambda=1064e-9;
n=1.82;
sigma=2.8e-19 ;%cm2
tau_2=230e-6;
tau_1=30e-9;
tau_21=tau_2  ;%Esto no estoy seguro
v=c/lambda/n;
I_s = h*v/sigma/tau_2*(1+tau_1/tau_2*(1-tau_2/tau_21))^-1 ; # W/m^2
%parametros a variar para el ajuste 
beta = 5e-3;
R_p = 2e25; # m^-3 s^-1
tau_p = 100e-6;

[t, P, g] = qswitch(TI, beta, I_s, R_p, tau_p);
