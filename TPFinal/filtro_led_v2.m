clc;
close all;
clear all;

pkg load signal;
pkg load communications;

T_s = 1e-10;
t = 0:T_s:280e-9;

Ip_cuad = [zeros(size(0:T_s:30e-9)) ones(size(30e-9+T_s:T_s:230e-9)) zeros(size((230e-9+T_s):T_s:280e-9))];

sim_5A=dlmread('curvas\7A_940_200.txt','\t',1,0);	% '\t'="TAB"; como la primer fila es el encabezado, se omite esta fila en la lectura
sim_5A(:,1)=sim_5A(:,1)-4.985e-6;
#revisar porque 4.985e-6

#-------------------------------Carga simulacion---------------------------
primer_punto=6;
ultimo_punto=330;
I_sim_940=cat(1, zeros(30,1), sim_5A(primer_punto:ultimo_punto,4),zeros(30,1));
t_sim_940=cat(1,(0:1e-9:29e-9)', sim_5A(primer_punto:ultimo_punto,1), (sim_5A(ultimo_punto,1):1e-9:sim_5A(ultimo_punto,1)+29e-9)')/1e-9;
I_sim_850=cat(1, zeros(30,1), sim_5A(primer_punto:ultimo_punto,4),zeros(30,1));
t_sim_850=cat(1,(0:1e-9:29e-9)', sim_5A(primer_punto:ultimo_punto,1), (sim_5A(ultimo_punto,1):1e-9:sim_5A(ultimo_punto,1)+29e-9)')/1e-9;


#-----------------------------------------calculo Kled----------------------%
function [trise,tfall] = tiempo_establecimiento (Pottr,Pottf,t)
#en la funcion de crecimiento se fija cuando pasa 10% y lo resta cuando pasa 90%
id9=find(Pottr/max(Pottr)>0.9);
id1=find(Pottr/max(Pottr)>0.1);
trise=t(id9(1))-t(id1(1));
#en la funcion de decrecimiento se fija cuando pasa 90% y lo resta cuando pasa 10%
id9=find(Pottf/max(Pottf)<0.9);
id1=find(Pottf/max(Pottf)<0.1);
tfall=t(id1(1))-t(id9(1));
endfunction

tr_940=10e-9;
tf_940=15e-9;
tr_850=30e-9;
tf_850=30e-9;
Pot_rise=@(Ip, kled)Ip.*tanh(sqrt(kled*Ip).*(t)).^2;
Pot_fall=@(Ip, kled)Ip./(sqrt(1/kled/Ip).+(t)).^2; #calculo la ecuacion con el kled anterior y comparo con el fall deseado
#--------------------------------940nm--------------------------%
disp('calculo kled 940')
trise=tr_940 %fabricante de 940
kled=1.49^2/trise^2/1
#despejo de la ecuacion, usando datos del fabricante
Ip=1
Pottr=Pot_rise(Ip,kled);
Pottf=Pot_fall(Ip,kled);
[tr_1A_940,tf_1A_940]=tiempo_establecimiento(Pottr,Pottf,t)
##trise=10e-9
##tfall=15e-9
##kled=2.11^2/trise^2/1
kled_940=kled
Pot=[zeros(size(0:T_s:30e-9)) Pottr(1:200e-9/T_s)/max(Pottr) Pottf(1:50e-9/T_s)/max(Pottf)];

figure() 
hold on
plot(t*1e9,Ip*Pot/max(Pot),'linewidth',3)
plot(t*1e9,Ip*Ip_cuad) # puse la cuadrada pero en realidad deberia ir la del pulso
grid minor
legend

#-----------------------------850nm-----------------------%
disp('calculo kled 850')
trise=tr_850
tfall=tf_850
%calculo con el trise y el tfall, no dan pero me da los limites entre los queue esta luego eligo a mano uno que me de un tfall y trise masmoenos equidistantes a 30

##kled=1.49^2/trise^2/1
##Ip=1
##Pottr=Pot_rise(Ip,kled);
##Pottf=Pot_fall(Ip,kled);
##[tr_1A_850,tf_1A_850]=tiempo_establecimiento(Pottr,Pottf,t)
###dan 30n y 42n,2.46e15
##kled=2.11^2/tfall^2/1
##Pottr=Pot_rise(Ip,kled);
##Pottf=Pot_fall(Ip,kled);
##[tr_1A_850,tf_1A_850]=tiempo_establecimiento(Pottr,Pottf,t)
###da 21n y 30n,4.9e15
##kled=(2.11^2/tfall^2/1+1.49^2/trise^2/1)/2
##Pottr=Pot_rise(Ip,kled);
##Pottf=Pot_fall(Ip,kled);
##[tr_1A_850,tf_1A_850]=tiempo_establecimiento(Pottr,Pottf,t)
###24.5n y 34.7n , kled=3.7e15
kled=3.3e15
Pottr=Pot_rise(Ip,kled);
Pottf=Pot_fall(Ip,kled);
[tr_1A_850,tf_1A_850]=tiempo_establecimiento(Pottr,Pottf,t)
#A prueba y error consigo un rise de 25.9n y 37.7n 
Pot=[zeros(size(0:T_s:30e-9)) Pottr(1:200e-9/T_s)/max(Pottr) Pottf(1:50e-9/T_s)/max(Pottf)];

figure() 
hold on
plot(t*1e9,Ip*Pot/max(Pot),'linewidth',3)
plot(t*1e9,Ip*Ip_cuad) 
grid minor
legend

kled_850=kled
#----------------------Con pulso 940------------------------#
disp('calculo para Ipulso elevado 940 ')

ancho_pulso=200e-9;
Ip=7
Ipr=max(I_sim_940)
Ipf=Ip+abs(min(I_sim_940))
Pottr=Pot_rise(Ipr,kled_940);
Pottf=Pot_fall(Ipf,kled_940);
#junto la de potencia de subida con la bajada para grficar
Pot=[zeros(size(0:T_s:30e-9)) Pottr(1:200e-9/T_s)/max(Pottr) Pottf(1:50e-9/T_s)/max(Pottf)];
[tr,tf]=tiempo_establecimiento(Pottr,Pottf,t)
ancho_emitido=ancho_pulso-tr+tf

Pot_emitida=2 %poner aca  el valor de la tabla de la potencia emitida a 7A


figure()
ax=plotyy(t_sim_940-8,I_sim_940,t*1e9,Pot_emitida*Pot/max(Pot));
lim2=axis(ax(2));
ylim(ax(2),[-lim2(4)*1.5 lim2(4)*1.5])
xlabel('Tiempo (ns)')
ylabel(ax(1),'Corriente (A)')
ylabel(ax(2),'Potencia (W)')
lim=axis;
ylim(ax(1),[-lim(4) lim(4)])
legend
grid minor


#----------------------Con pulso 850------------------------#
disp('calculo para Ipulso elevado 850 ')
ancho_pulso=200e-9;
Ip=7
Ipr=max(I_sim_850)
Ipf=Ip+abs(min(I_sim_850))
Pottr=Pot_rise(Ipr,kled_850);
Pottf=Pot_fall(Ipf,kled_850);
[tr,tf]=tiempo_establecimiento(Pottr,Pottf,t)
ancho_emitido=ancho_pulso-tr+tf
#junto la de potencia de subida con la bajada para grficar
Pot=[zeros(size(0:T_s:30e-9)) Pottr(1:200e-9/T_s)/max(Pottr) Pottf(1:50e-9/T_s)/max(Pottf)];



Pot_emitida=2 %poner aca  el valor de la tabla de la potencia emitida a 7A
figure()
ax=plotyy(t_sim_850-8,I_sim_850,t*1e9,Pot_emitida*Pot/max(Pot));
lim2=axis(ax(2));
ylim(ax(2),[-lim2(4)*1.5 lim2(4)*1.5])
xlabel('Tiempo (ns)')
ylabel(ax(1),'Corriente (A)')
ylabel(ax(2),'Potencia (W)')
lim=axis;
ylim(ax(1),[-lim(4) lim(4)])
legend
grid minor
#detalles a agregar poner los axes de manera que la potencia maxima a la que llega este igual que corriente del pulso larga
