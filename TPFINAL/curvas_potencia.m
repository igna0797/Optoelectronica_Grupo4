close all;clear all;
datos850=dlmread('potencia_850_datos.txt',';',0,0);	% '\t'="TAB"; como la primer fila es el encabezado, se omite esta fila en la lectura
datos940=dlmread('potencia_940_datos.txt',';',0,0);	% '\t'="TAB"; como la primer fila es el encabezado, se omite esta fila en la lectura
x=0:1:30e3;
m=0.003148;
b= -2.586 ;
y=m.*x+b;

figure()
plot(datos850(:,1),datos850(:,2),"b", "linewidth", 2)
hold on;
plot(x,sqrt(y),"r", "linewidth", 2)
xlim([0,15e3])
ylim([0,8])
grid on;
xlabel("Forward Current (mA)");
ylabel("Relative Radiant Intensity (A.U.)");
legend("Datasheet","Fit");
title("LED 850nm")


x=0:1:30e3;
m=0.001981;
b= -1.112;
y=m.*x+b;

figure()
plot(datos940(:,1),datos940(:,2),"b", "linewidth", 2)
hold on;
plot(x,sqrt(y),"r", "linewidth", 2)
xlim([0,15e3])
ylim([0,6])
grid on;
xlabel("Forward Current (mA)");
ylabel("Relative Radiant Intensity (A.U.)");
legend("Datasheet","Fit");
title("LED 940nm")