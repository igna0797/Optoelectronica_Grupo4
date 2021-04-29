close all;
clear all;


lambda_0 = 632.8e-9;
z_a = [0.3, 0.305, 0.31];
w_a = [557.47e-6, 550.12e-6, 560.61e-6];
z = 305e-3;
w_0_metro = sqrt(roots([1, -(w_a(2)^2), ((z^2)*(lambda_0^2))/(pi^2)]));
w_0 = w_0_metro(1)

z = 0:0.001:0.310; #m
q_0_inv = -1i*(lambda_0/(pi*(w_0^2)));
q_s_inv = [];
for i = 1:length(z)
#    matriz_abcd = arreglo_libre(z(i));
    matriz_abcd = arreglo_angosto(z(i), 0.05);
    q_s_inv(i,1) = (matriz_abcd(2,1) + matriz_abcd(2,2)*q_0_inv)/(matriz_abcd(1,1) + matriz_abcd(1,2)*q_0_inv);
endfor
radio_inv_libre = real(q_s_inv);
ancho_libre = sqrt(-lambda_0./(pi*(imag(q_s_inv))));

figure(20);
hold on;
plot(z_a, w_a*1e6, "xr", "linewidth", 2, "markersize", 9);
plot(z, ancho_libre*1e6, "r", "linewidth", 2);
grid on;
legend("Ajustes", "Calculo ABCD", "location", "northwest");
legend("boxoff");
xlabel("z / m");
ylabel("w(z) / um");
xlim([0, 0.32]);
