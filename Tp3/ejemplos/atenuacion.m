%pkg load control
clear all;close all;
Vd_max=2.5 %V
Id_max=10e-3 %A
duty=0.125
eff=0.3
L=50 %km
ancho_espectral=10%nm
perdidas_ins=0.18
lambda_0=1550%nm

lambda=lambda_0-ancho_espectral/2:.01:lambda_0+ancho_espectral/2+.01;

P_consumida=Vd_max*Id_max*duty
P_emitida=eff*P_consumida
P_insertada=(1-perdidas_ins)*P_emitida
P_insertada_dbm=mag2db(P_insertada)/2+30%dbm
atenuacion_db=mean(0.5.*(1+abs((lambda-lambda_0)./25)))*L %db

P_salida_dbW=mag2db(P_insertada)/2-atenuacion_db %dbW
P_salida_dbm=P_salida_dbW+30%dbm
P_salida=10^(P_salida_dbm/10)/1000