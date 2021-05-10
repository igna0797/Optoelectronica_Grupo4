%lente pequeña

w_0=453.3e-6;
lambda_0=632.8e-9;
L1=50e-3;
f1=20e-3;
f2=-2e-3;
##f2=inf

zo=  pi*w_0^2/lambda_0
wf1=lambda_0*f1/pi/w_0
zo2=pi*25e-3^2/lambda_0
zf1=f1/(1+(f1/zo)^2)
wf2=lambda_0*f2/pi/w_0
zf2=f2/(1+(f2/zo2)^2)
##L2=z(1,find(ancho_libre==min(ancho_libre)))-L1;
##L2=zf1+zf2
f_1=1/(lambda_0/w_0/pi/20e-6)

L2=zf1+zf2
##L2=0.91
####L2=zf1-0.9e-3
##L2= zf1

z = 0:0.1e-3:L1+L2+50e-3; 

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
##    q_s_inv(i)
endfor
radio_inv_libre = real(q_s_inv);
ancho_libre = sqrt(-lambda_0./(pi*(imag(q_s_inv))));
q_s_inv(end)
[wmin,widx]=min(ancho_libre);
w_fibra= ancho_libre(widx+100) % 100 marcas de z son 10mm
figure(22);
hold on;
plot(z,ones(length(z),1)*25)
plot(z, ancho_libre*1e6, "g", "linewidth", 2);
plot([L1+L2+10e-3,L1+L2+10e-3],[0,500]);
grid on;
legend("Calculo ABCD", "location", "northwest");
legend("boxoff");
xlabel("z / m");
ylabel("w(z) / um");
xlim([0, 0.32]);
ylim([0,500]);