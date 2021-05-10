clear all; close all; clc;

w_0=453.3e-6;

lambda_0=632.8e-9;
L1=50e-3;
f1=250e-3;
f2=-6e-3;
L2=f1+f2;

z = 0:0.01e-3:L1+L2+10e-3; 
q_0_inv = -j*(lambda_0/(pi*(w_0^2)));
q_s_inv = [];
for i = 1:length(z)
    if (z(1,i) <= L1)
        matriz_abcd = [1, z(1,i); 0, 1];
    elseif ((z(1,i) > L1) && (z(1,i) <= (L1 + L2)))
        matriz_abcd = [1, (z(1,i) - L1); 0, 1]*[1, 0; (-1/f1), 1]*[1, L1; 0, 1];
    else
        matriz_abcd= [1, 0; (-1/f2), 1]*[1, L2; 0, 1]*[1, 0; (-1/f1), 1]*[1, L1; 0, 1];
        matriz_abcd = [1, (z(1,i) - L1 - L2); 0, 1]*matriz_abcd;
    endif
 
    q_s_inv(i,1) = (matriz_abcd(2,1) + matriz_abcd(2,2)*q_0_inv)/(matriz_abcd(1,1) + matriz_abcd(1,2)*q_0_inv);

    endfor
radio_inv_libre = real(q_s_inv);
ancho_libre = sqrt(-lambda_0./(pi*(imag(q_s_inv))));
[1, 0; (-1/f2), 1]*[1, L2; 0, 1]*[1, 0; (-1/f1), 1]*[1, L1; 0, 1]
figure(20);
hold on;
plot(z, ancho_libre*1e6, "r", "linewidth", 2);
grid on;
xlabel("z / m");
ylabel("w(z) / um");
xlim([0, 320e-3]);
%L2+L1-find(ancho_libre==min(ancho_libre))
L2=z(1,find(ancho_libre==min(ancho_libre)))-L1;%buscamos el punto w_f y ponemos ahi la segunda lente
ancho_libre(1,end)


z = 0:0.01e-3:L1+L2+10e-3; 
q_0_inv = -1i*(lambda_0/(pi*(w_0^2)));
q_s_inv = [];
for i = 1:length(z)
    if (z(1,i) <= L1)
        matriz_abcd = [1, z(1,i); 0, 1];
    elseif ((z(1,i) > L1) && (z(1,i) <= (L1 + L2)))
        matriz_abcd = [1, (z(1,i) - L1); 0, 1]*[1, 0; (-1/f1), 1]*[1, L1; 0, 1];
    else
        matriz_abcd = [1, (z(1,i) - L1 - L2); 0, 1]*[1, 0; (-1/f2), 1]*[1, L2; 0, 1]*[1, 0; (-1/f1), 1]*[1, L1; 0, 1];
    endif
 
    q_s_inv(i,1) = (matriz_abcd(2,1) + matriz_abcd(2,2)*q_0_inv)/(matriz_abcd(1,1) + matriz_abcd(1,2)*q_0_inv);
endfor
radio_inv_libre = real(q_s_inv);
ancho_libre = sqrt(-lambda_0./(pi*(imag(q_s_inv))));
[1, 0; (-1/f2), 1]*[1, L2; 0, 1]*[1, 0; (-1/f1), 1]*[1, L1; 0, 1]

plot(z, ancho_libre*1e6, "b", "linewidth", 2);
legend("Calculo ABCD","Calculo ABCD con lente 2 en w_{f_1}", "location", "northwest");
legend("boxoff");
ylim([0,600]);
ancho_libre(1,end)