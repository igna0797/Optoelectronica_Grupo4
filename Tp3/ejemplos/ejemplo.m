# Codigo correspondiente al TP3
close all;
clear all;

pkg load signal;
pkg load communications;
source dispersiones.m

T_s = 10e-12;
t = 0:T_s:20e-9;

corriente = [zeros(size(0:T_s:9e-9)) ones(size(9e-9+T_s:T_s:11e-9)) zeros(size((11e-9+T_s):T_s:20e-9))];

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

figure(1);
hold on;
plot(t/1e-9, corriente, "b", "linewidth", 2);
plot(t/1e-9, laser, "r", "linewidth", 2);
plot(t/1e-9, laser_cont_disc, "g", "linewidth", 2);
grid on;
xlabel("t / ns");
legend("Corriente", "Laser 1ord", "Laser 1ord cont disc");
title("Laser con filtro de primer orden");

#genero un FIR gaussiano
BT = f_c*T_s;
#para que la frecuencia de corte sea la de -3dB
delta = sqrt(log(2))/(2*pi*BT);
a = 1/delta;
m = ceil(6*delta);
w = (1/(sqrt(2*pi)*delta))*gaussian(m, a);

laser_gaus = conv(corriente, w);
laser_gaus1 = filter(w, 1, corriente);

figure(2);
hold on;
plot(t/1e-9, corriente, "b", "linewidth", 2);
plot(t/1e-9, laser_gaus(1:length(t)), "r", "linewidth", 2);
plot(t/1e-9, laser_gaus1, "g", "linewidth", 2);
grid on;
xlabel("t / ns");
legend("Corriente", "Laser gauss conv", "Laser gauss filter");
title("Laser con filtro gaussiano");

#frecuencia de corte en exp(-1/2)
sigma = 1/(2*pi*BT);
a2 = 1/(sigma);
m2 = ceil(6*sigma);
w2 = (1/(sqrt(2*pi)*sigma))*gaussian(m2, a2);

laser_gaus = conv(corriente, w, "same");
laser_gaus2 = conv(corriente, w2, "same");
#laser_gaus2 = filter(w2, 1, corriente);

figure(3);
hold on;
plot(t/1e-9, corriente, "b", "linewidth", 2);
plot(t/1e-9, laser_gaus, "r", "linewidth", 2);
plot(t/1e-9, laser_gaus2, "c", "linewidth", 2);
grid on;
xlabel("t / ns");
legend("Corriente", "Laser gauss f_c -3dB", "Laser gauss f_c exp(-1/2)");
title("Laser con filtro gaussiano con diferentes f_c");

#filtro gaussiano armado a mano
sigma3 = sqrt(log(2))/(2*pi*f_c);
sz = 6*sigma3;
x1 = (-sz/2:T_s:sz/2);
gauss_filt = exp(-(x1.^2)/(2*(sigma3^2)));
gauss_filt = gauss_filt/sum(gauss_filt);

laser_gaus3 = conv(corriente, gauss_filt, "same");

figure(4);
hold on;
plot(t/1e-9, laser_gaus, "r", "linewidth", 2);
plot(t/1e-9, laser_gaus3, "xm", "linewidth", 2);
grid on;
xlabel("t / ns");
legend("Filtrado con gaussian", "Filtrado con el filtro a mano");
title("Comparacion implementacion filtros");


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
plot(t/1e-9, laser_gaus, "r", "linewidth", 2);
plot(t/1e-9, laser_fibra, "g", "linewidth", 2);
grid on;
xlabel("t / ns");
legend("Corriente", "Laser", "Laser + fibra");

N = 2048*4;
W = fft(w, N);
mod_W = abs(W)(1:N/2);
W2 = fft(w2, N);
mod_W2 = abs(W2)(1:N/2);
W_f = fft(w_f, N);
mod_W_f = abs(W_f)(1:N/2);
W_1ord = freqz([alfa], [1, (alfa - 1)], N, "whole");
#W_1ord = freqz(B_disc, A_disc, N, "whole");
mod_W_1ord = abs(W_1ord)(1:N/2);
mod_W_1ord = mod_W_1ord/max(mod_W_1ord);
f = (0:(N/2 - 1))/(T_s*N);
#f(1) = f(2); #para sacar el 0 de f
figure(6);
hold on;
semilogx(f(2:end)', 20*log10(mod_W(2:end)), "b", "linewidth", 2);
semilogx(f(2:end)', 20*log10(mod_W2(2:end)), "c", "linewidth", 2);
semilogx(f(2:end)', 20*log10(mod_W_1ord(2:end)), "m", "linewidth", 2);
semilogx(f(2:end)', -3*ones(size(f(2:end))), "r", "linewidth", 2);
semilogx(f(2:end)', 20*log10(mod_W_f(2:end)), "g", "linewidth", 2);
ylim([-10, 1]);
xlim([f(2), 1e10]);
grid on;
xlabel("f / Hz");
ylabel("|W| / dB");
legend("Filtro gaussiano -3dB", "Filtro gaussiano exp(-1/2)", "Filtro 1ord", "-3dB", "Fibra");

#Agrego ruido gaussiano a la respuesta del laser con SNR de 20 dB
laser_gaus_ruido = awgn(laser_gaus, 20, "measured");

figure(7);
hold on;
plot(t/1e-9, laser_gaus_ruido, "g", "linewidth", 1);
plot(t/1e-9, laser_gaus, "r", "linewidth", 2);
grid on;
xlabel("t / ns");
