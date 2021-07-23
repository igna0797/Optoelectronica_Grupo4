
close all;
clear all;

pkg load signal;
pkg load communications;

T_s = 1e-10;
t = 0:T_s:280e-9;

corriente = [zeros(size(0:T_s:30e-9)) ones(size(30e-9+T_s:T_s:250e-9)) zeros(size((250e-9+T_s):T_s:280e-9))];

sim_5A=dlmread('curvas\5A.txt','\t',1,0);	% '\t'="TAB"; como la primer fila es el encabezado, se omite esta fila en la lectura
sim_5A(:,1)=sim_5A(:,1)-4.985e-6;

#filtro pasa bajos primer orden continuo
# H = K/(tau s + 1)
# los polinomios son:
#   B = [K] = [1]
#   A = [tau, 1]
tau_f = 30e-9; #rise time
tau = tau_f/2.2;
f_c = 0.35/tau_f;
#filtro discreto desde la discretizacion de la ec diferencial
alfa = T_s/(tau + T_s);
led = filter([alfa], [1, (alfa - 1)], corriente);

#genero un FIR gaussiano
BT = f_c*T_s;
#para que la frecuencia de corte sea la de -3dB
delta = sqrt(log(2))/(2*pi*BT);
a = 1/delta;
m = ceil(6*delta);
w = (1/(sqrt(2*pi)*delta))*gaussian(m, a);

primer_punto=6;
ultimo_punto=330;
corriente_5A=cat(1, zeros(30,1), sim_5A(primer_punto:ultimo_punto,4),zeros(30,1));
t_5A=cat(1,(0:1e-9:29e-9)', sim_5A(primer_punto:ultimo_punto,1), (sim_5A(ultimo_punto,1):1e-9:sim_5A(ultimo_punto,1)+29e-9)')/1e-9;
led_gaus = conv(corriente, w, "same");
led_gaus_5A=conv(corriente_5A, w, "same");
led_1ord_5A=filter([alfa], [1, (alfa - 1)], corriente_5A);
figure()
plot(t_5A,corriente_5A)

figure(5);
hold on;
plot(t/1e-9, corriente, "b", "linewidth", 2);
plot(t_5A,2*corriente_5A/max(corriente_5A),"c","linewidth",2);
plot(t/1e-9, led, "r", "linewidth", 2);
plot(t_5A, led_1ord_5A/max(led_1ord_5A), "g", "linewidth", 2);
grid on;
xlabel("t / ns");
legend("Corriente sin sobrepico","Corriente con sobrepico", "LED sin sobrepico","LED con sobrepico");

###Agrego ruido gaussiano a la respuesta del laser con SNR de 20 dB
##laser_gaus_ruido = awgn(laser_gaus, 20, "measured");
##
##figure(7);
##hold on;
##plot(t/1e-9, laser_gaus_ruido, "g", "linewidth", 1);
##plot(t/1e-9, laser_gaus, "r", "linewidth", 2);
##grid on;
##xlabel("t / ns");
