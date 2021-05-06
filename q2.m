clear all; close all; clc;
%Primero uso el algoritmo en espacio libre
%ABCD(z)= [ 1 z ]
%         [ 0 1 ]
%
%

w_o=453.3e-6;
lambda_o=632.8e-9;
##q_e=1/(-j*lambda_o/pi/w_o^2) %1/qe
##z=0:.1e-3:315e-3;
##A=1;
##B=z;
##C=0;
##D=1;
##
##q_s=1./((C.+D/q_e)./(A.+B/q_e));
##w=sqrt((-imag(1./q_s)).^(-1)*lambda_o/pi);
##w=w.*1e6;
##z=z.*1e3;
##load w_analitico
##fig= figure()
##hold on
##plot(z,w,'-r','linewidth',4);
##plot (z,wpromedio,'--b')
##plot(300,466.5,'r','Markersize',20);
##plot(305,465.4,'g','Markersize',20);
##plot(310,487.6,'c','Markersize',20);
##grid on
##xlabel('z [mm]');
##ylabel('w [\mum]');
##axis([0 350 440 510])
##legend ('w calculado con q' , ' w analitico')
L1=50e-3;
%trayectoria z=(0,L1)
z=0:.1e-3:L1;
A=1;
B=z;
C=0;
D=1;
q_e1=1/(-j*lambda_o/pi/w_o^2) 
q_s1=1./((C.+D/q_e1)./(A.+B/q_e1));

%interfaz con lente 1
f1=250e-3;
A=1;
B=0;
C=-1/f1;
D=1;
q_e2=q_s1(1,end);
q_s2=1./((C.+D/q_e2)./(A.+B/q_e2));

%trayectoria z=(L1,L1+L2)
f2=-6e-3;
L2=f1+f2;
z=L1:.1e-3:L1+L2;
A=1;
B=z;
C=0;
D=1;
q_e3=q_s2;
q_s3=1./((C.+D/q_e3)./(A.+B/q_e3));

%interfaz con lente 2
A=1;
B=0;
C=-1/f2;
D=1;
q_e4=q_s3(1,end);
q_s4=1./((C.+D/q_e4)./(A.+B/q_e4));

%trayectoria z=(L1+L2,L1+L2+10mm)
f2=-6e-3;
z=L1+L2:.1e-3:L1+L2+10e-3;
A=1;
B=z;
C=0;
D=1;
q_e5=q_s4;
q_s5=1./((C.+D/q_e5)./(A.+B/q_e5));

q_s=[q_s1,q_s3(1,2:end),q_s5(1,2:end)];
z=0:.1e-3:L1+L2+10e-3;
w=sqrt((-imag(1./q_s)).^(-1)*lambda_o/pi);
w=w.*1e6;
z=z.*1e3;

fig= figure()
hold on
plot(z,w,'-r','linewidth',4);
plot(300,466.5,'r','Markersize',20);
plot(305,465.4,'g','Markersize',20);
plot(310,487.6,'c','Markersize',20);
grid on
xlabel('z [mm]');
ylabel('w [\mum]');
axis([0 350 440 510])
legend ('w calculado con q')