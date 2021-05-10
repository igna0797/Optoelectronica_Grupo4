%lente pequeña
close all
clear all
w_0=453.3e-6;
lambda_0=632.8e-9;
q_0_inv = -1i*(lambda_0/(pi*(w_0^2)));
L1=50e-3;


function q_s_inv= recorrido (L1,L2,f1,f2,q_0_inv)
q_s_inv = [];

z = 0:0.1e-3:L1+L2+10e-3; 
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
endfunction

%HAZ NUMERO 1
f1=20e-3;
f2=-1e-3;
zo=  pi*w_0^2/lambda_0
wf1=lambda_0*f1/pi/w_0
zf1=f1/(1+(f1/zo)^2)
zo2=pi*25e-3^2/lambda_0
wf2=lambda_0*f2/pi/w_0
zf2=f2/(1+(f2/zo2)^2)
##L2=z(1,find(ancho_libre==min(ancho_libre)))-L1;
##L2=zf1+zf2
f_1=1/(lambda_0/w_0/pi/20e-6)

L2=zf1+zf2
##L2=zf1-1.8e-3
##L2=0.91
####L2=zf1-0.9e-3
##L2= zf1
z1 = 0:0.1e-3:L1+L2+10e-3; 
q_s_inv = recorrido(L1,L2,f1,f2,q_0_inv);
radio_inv_libre1 = real(q_s_inv);
ancho_libre = sqrt(-lambda_0./(pi*(imag(q_s_inv))));
q_s_inv(end)
[wmin,widx]=min(ancho_libre);
##w_fibra = ancho_libre(widx+99) % 100 marcas de z son 10mm

%HAZ NUMERO 2
f1=20e-3;
f2=-2e-3;
zo=  pi*w_0^2/lambda_0
wf1=lambda_0*f1/pi/w_0
zf1=f1/(1+(f1/zo)^2)
zo2=pi*25e-3^2/lambda_0
wf2=lambda_0*f2/pi/w_0
zf2=f2/(1+(f2/zo2)^2)
##L2=z(1,find(ancho_libre==min(ancho_libre)))-L1;
##L2=zf1+zf2
f_1=1/(lambda_0/w_0/pi/20e-6)
L2=zf1+zf2

q_s_inv2 = recorrido(L1,L2,f1,f2,q_0_inv);
radio_inv_libre2 = real(q_s_inv2);
ancho_libre2 = sqrt(-lambda_0./(pi*(imag(q_s_inv2))));
q_s_inv2(end)
[wmin,widx]=min(ancho_libre2);
w_fibra2= ancho_libre2(widx+99) % 100 marcas de z son 10mm
z2 = 0:0.1e-3:L1+L2+10e-3; 

%haz 3 completo
f1=20e-3;
f2=inf
L2=zf1
q_s_inv3 = recorrido(L1,L2,f1,f2,q_0_inv);
radio_inv_libre3 = real(q_s_inv3);
ancho_libre3 = sqrt(-lambda_0./(pi*(imag(q_s_inv3))));
q_s_inv2(end)
[wmin,widx]=min(ancho_libre2);
w_fibra3= ancho_libre3(widx+99) % 100 marcas de z son 10mm
z3 = 0:0.1e-3:L1+L2+10e-3; 

figure(22);
hold on;
plot(z3, ancho_libre3*1e6, "b", "linewidth", 2);
plot(z1, ancho_libre*1e6, "g", "linewidth", 2);
plot(z2, ancho_libre2*1e6, "r", "linewidth", 2);
plot(z1,ones(length(z1),1)*25)
##plot([L1+L2+10e-3,L1+L2+10e-3],[0,500]);

   
q_s_libre_inv =q_0_inv./(1+z1.*q_0_inv);
radio_inv_libre = real(q_s_libre_inv);
##radio_inv = real(q_s_inv);
##ancho_libre = sqrt(-lambda_0./(pi(imag(q_s_inv))));

grid on;
legend("f2=inf","f2=-1mm","f2=-2mm", "location", "northwest");
legend("boxoff");
xlabel("z / m");
ylabel("w(z) / um");
ylabel("1/R(z)")
xlim([0, 0.32]);
ylim([0,500]);

figure(21)
hold on;
grid on
grid minor
plot(z1,radio_inv_libre1,'g',"linewidth", 2)
plot(z2,radio_inv_libre2,'r',"linewidth", 2)
plot(z1,radio_inv_libre ,'b',"linewidth", 2)
legend("f2=-1mm","f2=-2mm","Camino libre", "location", "northwest");
legend("boxoff");
ylabel("1/R(z)")
xlabel("z / m");
