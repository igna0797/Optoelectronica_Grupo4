# Codigo correspondiente al TP2
close all;
clear all;

load mediciones1C2021.mat;
# tiene las variables Tiempo, Laser y Bombeo.
# [Tiempo] = s

# falta normalizar las variables a graficar
figure(1);
hold on;
plot(Tiempo/1e-6, Laser, "b");
plot(Tiempo/1e-6, Bombeo, "g");
grid on;
xlabel("t / us");
legend("Laser", "Bombeo");

TI = 3e5;
beta = 5e-3;
I_s = 1600; # W/m^2
R_p = 2e25; # m^-3 s^-1
tau_p = 100e-6;
[t, P, g] = qswitch(TI, beta, I_s, R_p, tau_p);
figure(2);
hold on;
plot(Tiempo/1e-6, Laser/max(Laser), "b");
plot(t/1e-6, P/max(P), "r", "linewidth", 2);
plot(t/1e-6, g/max(g), "g", "linewidth", 2);
grid on;
xlabel("t / us");
legend("Medido", "Simulado", "Ganancia");

