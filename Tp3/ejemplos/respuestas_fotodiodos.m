# Codigo correspondiente al TP3
close all;
clear all;

pkg load signal;
pkg load communications;
source dispersiones.m

T_s = 10e-12;
t = 0:T_s:100e-9;

corriente = [zeros(size(0:T_s:9e-9)) ones(size(9e-9+T_s:T_s:11e-9)) zeros(size((11e-9+T_s):T_s:100e-9))];

#filtro pasa bajos primer orden continuo
# H = K/(tau s + 1)
# los polinomios son:
#   B = [K] = [1]
#   A = [tau, 1]
tau_f = 0.5e-9; #rise time
tau = tau_f/2.2;
f_c = 0.35/tau_f;
#coeficientes para un IIR continuo
B_cont = [1];
A_cont = [tau, 1];
#convierto a un filtro discreto
[B_disc, A_disc] = impinvar(B_cont, A_cont, 1/T_s);
laser_cont_disc = filter(B_disc, A_disc, corriente);
#filtro discreto desde la discretizacion de la ec diferencial
alfa = T_s/(tau + T_s);
laser = filter([alfa], [1, (alfa - 1)], corriente);

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
### PIND

SNR_PIND=39.75; %db
f_c_amp_PIND=8e6; %Hz

#genero el filtro del amplificador
BT_f = f_c_amp_PIND*T_s;
#para que la frecuencia de corte sea la de -3dB
delta_f = sqrt(log(2))/(2*pi*BT_f);
#delta_f = 1/(2*pi*BT_f);
a_f = 1/delta_f;
m_f = ceil(6*delta_f);
w_f = (1/(sqrt(2*pi)*delta_f))*gaussian(m_f, a_f);

salida_PIND = filter(w_f, 1, laser_fibra);
salida_PIND_centrada=conv(laser_gaus, w_f, "same");
#Agrego ruido gaussiano a la respuesta de la fibra con SNR de 20 dB
salida_PIND_ruido = awgn(salida_PIND, SNR_PIND, "measured");
salida_PIND_centrada_ruido=awgn(salida_PIND_centrada, SNR_PIND, "measured");

### APD

SNR_APD=32.72; %db
f_c_amp_APD=35e6; %Hz

#genero el filtro del amplificador
BT_f = f_c_amp_APD*T_s;
#para que la frecuencia de corte sea la de -3dB
delta_f = sqrt(log(2))/(2*pi*BT_f);
#delta_f = 1/(2*pi*BT_f);
a_f = 1/delta_f;
m_f = ceil(6*delta_f);
w_f = (1/(sqrt(2*pi)*delta_f))*gaussian(m_f, a_f);

salida_APD = filter(w_f, 1, laser_fibra);
salida_APD_centrada=conv(laser_gaus, w_f, "same");
#Agrego ruido gaussiano a la respuesta de la fibra con SNR de 20 dB
salida_APD_ruido = awgn(salida_APD, SNR_APD, "measured");
salida_APD_centrada_ruido=awgn(salida_APD_centrada, SNR_APD, "measured");

### PMT

SNR_PMT=42.15; %db
f_c_PMT=222.22e6; %Hz

#genero el filtro del amplificador
BT_f = f_c_PMT*T_s;
#para que la frecuencia de corte sea la de -3dB
delta_f = sqrt(log(2))/(2*pi*BT_f);
#delta_f = 1/(2*pi*BT_f);
a_f = 1/delta_f;
m_f = ceil(6*delta_f);
w_f = (1/(sqrt(2*pi)*delta_f))*gaussian(m_f, a_f);

salida_PMT = filter(w_f, 1, laser_fibra);
salida_PMT_centrada=conv(laser_gaus, w_f, "same");

#Agrego ruido gaussiano a la respuesta de la fibra con SNR de 20 dB
salida_PMT_ruido = awgn(salida_PMT, SNR_PMT, "measured");
salida_PMT_centrada_ruido=awgn(salida_PMT_centrada, SNR_PMT, "measured");


figure(7);
hold on;
plot((t.+23e-9)/1e-9, salida_PMT_ruido/max(salida_PMT_ruido), "r", "linewidth", 1);
plot(t/1e-9, salida_APD_ruido/max(salida_APD_ruido), "b", "linewidth", 1);
plot(t/1e-9, salida_PIND_ruido/max(salida_PIND_ruido), "g", "linewidth", 1);
plot(t/1e-9, laser_fibra/max(laser_fibra), "k--", "linewidth", 2);
xlim([0,80])
legend("PMT", "APD", "PIND","i_{IN}","location","east");
grid on;
xlabel("t / ns");

figure(8);
hold on;
plot((t)/1e-9, salida_PMT_centrada_ruido/max(salida_PMT_centrada_ruido), "r", "linewidth", 1);
plot(t/1e-9, salida_APD_centrada_ruido/max(salida_APD_centrada_ruido), "b", "linewidth", 1);
plot(t/1e-9, salida_PIND_centrada_ruido/max(salida_PIND_centrada_ruido), "g", "linewidth", 1);
plot(t/1e-9, laser_fibra/max(laser_fibra), "k--", "linewidth", 2);
xlim([0,20])
legend("PMT", "APD", "PIND","i_{IN}","location","east");
grid on;
xlabel("t / ns");