##Lente normal
clear all; 
##close all; 
clc;
%Primero uso el algoritmo en espacio libre
%ABCD(z)= [ 1 z ]
%         [ 0 1 ]
%
%
w_0=453.3e-6;
lambda_0=632.8e-9;
L1=50e-3;
f1=250e-3;
##f2=-6e-3
f2=inf
L2=f1
##L2=f1+f2

zo=  pi*w_0^2/lambda_0
wf1=lambda_0*f1/pi/w_0
zf1=f1/(1+(f1/zo)^2)
wf2=lambda_0*f2/pi/w_0
zf2=f2/(1+(f2/zo)^2)

z = 0:0.1e-3:L1+L2+10e-3; 
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

q_s_inv(end)
matriz_abcd
##ancho_libre(685:695)
[wmin,widx]=min(ancho_libre)

figure(21);
hold on;
plot(z, ancho_libre*1e6, "r", "linewidth", 3);
##plot([z(widx),z(widx)],[0,1000],"linewidth", 1.5)
##plot([L1+f1,L1+f1],[0,1000],"linewidth", 1.5)
grid on;
legend("Ancho del haz","Zf","f1", "location", "northwest");
legend("boxoff");
xlabel("z / m");
ylabel("w(z) / um");
xlim([0, 0.32]);
