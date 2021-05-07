clear all; close all; clc;
%Primero uso el algoritmo en espacio libre
%ABCD(z)= [ 1 z ]
%         [ 0 1 ]
%
%

w_0=453.3e-6;
lambda_0=632.8e-9;
L1=50e-3;
f1=250e-3;
f2=-6e-3;
L2=f1+f2;

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

figure(20);
hold on;
plot(z, ancho_libre*1e6, "r", "linewidth", 2);
grid on;
legend("Calculo ABCD", "location", "northwest");
legend("boxoff");
xlabel("z / m");
ylabel("w(z) / um");
xlim([0, 0.32]);

L2=z(1,find(ancho_libre==min(ancho_libre)))-L1;

w_0=453.3e-6;
lambda_0=632.8e-9;
L1=50e-3;
f1=250e-3;
f2=-6e-3;

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

figure(21);
hold on;
plot(z, ancho_libre*1e6, "r", "linewidth", 2);
grid on;
legend("Calculo ABCD", "location", "northwest");
legend("boxoff");
xlabel("z / m");
ylabel("w(z) / um");
xlim([0, 0.32]);
##
##
##
##%trayectoria z=(0,L1)
##z=0:.1e-3:L1;
##
##A=1;
##B=z;
##C=0;
##D=1;
##q_s1=1./((C.+D/q_e1)./(A.+B./q_e1));
##
##%trayectoria z=(L1,L1+L2)
##z=L1:.1e-3:L1+L2;
##
##
##A=1.-4.*z;
##B=4/5.*z.+1/20;
##C=-4;
##D=4/5;
##%q_e1=q_s1(1,end);
##q_s2=1./((C.+D/q_e1)./(A.+B/q_e1));
##
##%trayectoria z=(L1+L2,L1+L2+10mm)
##z=L1+L2:.1e-3:L1+L2+10e-3;
##A=-100/3.*z.-22/125;
##B=145/3.*z.+713/2500;
##C=-100/3;
##D=145/3;
##
##q_s3=1./((C.+D/q_e1)./(A.+B/q_e1));
##
##q_s=[q_s1,q_s2(1,2:end),q_s3(1,2:end)];
##
##w=sqrt((-imag(1./q_s)).^(-1)*lambda_o/pi);
##z=0:.1e-3:L1+L2+10e-3;  
##w=w.*1e6;
##z=z.*1e3;
##
##fig= figure()
##hold on
##plot(z,w,'-r','linewidth',4);
##plot(300,466.5,'r','Markersize',20);
##plot(305,465.4,'g','Markersize',20);
##plot(310,487.6,'c','Markersize',20);
##grid on
##xlabel('z [mm]');
##ylabel('w [\mum]');
##axis([0 350 0 510])
##legend ('w calculado con q')