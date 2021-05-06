clear all;close all;clc;
##pkg load symbolic

syms w wo lambda z
f=w^2==wo^2*(1+(z*lambda/pi/wo^2)^2)
%obtenemos las raices con los datos que ya tenemos de los ajustes
w1=466.5e-6;
z1=300e-3;
s1=double(vpa(solve(subs(f,[lambda,w,z],[632.8e-9, w1,z1]))))

w2=465.4e-6;
z2=305e-3;
s2=double(vpa(solve(subs(f,[lambda,w,z],[632.8e-9, w2,z2]))))

w3=487.6e-6;
z3=310e-3;
s3=double(vpa(solve(subs(f,[lambda,w,z],[632.8e-9, w3,z3]))))

wo_promedio=(s1(4,1)+s2(4,1)+s3(4,1))/3

%busco expresion de funcion a graficar
solve(f,w)

z=0:0.1e-3:315e-3;
w1=sqrt(632.8e-9^2.*z.^2.+pi^2*s1(4,1)^4)/pi/s1(4,1);
w2=sqrt(632.8e-9^2.*z.^2.+pi^2*s2(4,1)^4)/pi/s2(4,1);
w3=sqrt(632.8e-9^2.*z.^2.+pi^2*s3(4,1)^4)/pi/s3(4,1);
wpromedio=sqrt(632.8e-9^2.*z.^2.+pi^2*wo_promedio^4)/pi/wo_promedio;
%normalizo
w1=w1.*1e6;
w2=w2.*1e6;
w3=w3.*1e6;
wpromedio=wpromedio.*1e6;
z=z.*1e3;
figure()
plot(z,w1,'-r');
hold on
plot(z,w2,'-g');
plot(z,w3,'-c');
plot(z,wpromedio,'-b');
legend('Medicion 300mm','Medicion 305mm','Medicion 310mm','Promedio');
plot(300,466.5,'r','Markersize',20);
plot(305,465.4,'g','Markersize',20);
plot(310,487.6,'c','Markersize',20);
grid on
xlabel('z [mm]');
ylabel('w [\mum]');
axis([0 350 440 510])
save w_analitico "wpromedio"