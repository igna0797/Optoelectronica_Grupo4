# Codigo correspondiente al TP3
close all;
clear all;

pkg load signal;
pkg load communications;
source dispersiones.m

T_s = 10e-12;
t = 0:T_s:20e-9;

corriente = [zeros(size(0:T_s:9e-9)) ones(size(9e-9+T_s:T_s:11e-9)) zeros(size((11e-9+T_s):T_s:20e-9))];

tau_f = 0.5e-9; #rise time
tau = tau_f/2.2;
f_c = 0.35/tau_f;


#genero un FIR gaussiano
BT = f_c*T_s;
#para que la frecuencia de corte sea la de -3dB
delta = sqrt(log(2))/(2*pi*BT);
a = 1/delta;
m = ceil(6*delta);
w = (1/(sqrt(2*pi)*delta))*gaussian(m, a);


laser_gaus = conv(corriente, w, "same");

#genero el filtro de la fibra
Delta_tau = Dispersion*1e-12;
lmax=fminsearch(@(L) abs(f_Dispercion(L)-2*tau_f*1e12),[0])
f_c_f = 0.35/((2e-9 + Delta_tau)/2);
BT_f = f_c_f*T_s;
#para que la frecuencia de corte sea la de -3dB
delta_f = sqrt(log(2))/(2*pi*BT_f);
#delta_f = 1/(2*pi*BT_f);
a_f = 1/delta_f;
m_f = ceil(6*delta_f);
w_f = (1/(sqrt(2*pi)*delta_f))*gaussian(m_f, a_f);

laser_fibra = conv(laser_gaus, w_f, "same");

figure(5);
hold on;
plot(t/1e-9, corriente, "b", "linewidth", 2);
plot(t/1e-9, laser_gaus/max(laser_gaus), "r", "linewidth", 2);
plot(t/1e-9, laser_fibra/max(laser_fibra), "g", "linewidth", 2);
grid on;
xlabel("t / ns");
legend("Corriente", "Laser", "Laser + fibra");
