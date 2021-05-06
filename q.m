clear all; close all; clc;
%Primero uso el algoritmo en espacio libre
%ABCD(z)= [ 1 z ]
%         [ 0 1 ]
%
%
w_o=453.3e-6;
lambda_o=632.8e-9;
q_e=1/(-j*lambda_o/pi/w_o^2) %1/qe
z=0:.1e-3:315e-3;
A=1;
B=z;
C=0;
D=1;

q_s=1./((C.+D/q_e)./(A.+B/q_e));
w=sqrt((-imag(1./q_s)).^(-1)*lambda_o/pi);
w=w.*1e6;
z=z.*1e3;
figure()
plot(z,w,'-r');
hold on
plot(300,466.5,'r','Markersize',20);
plot(305,465.4,'g','Markersize',20);
plot(310,487.6,'c','Markersize',20);
grid on
xlabel('z [mm]');
ylabel('w [\mum]');
axis([0 350 440 510])