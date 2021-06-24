%datasheet fotodiodo
S_min=0.65 %1550 [A/W]
S=0.8
I_d=20 %corriente de oscuridad [nA]
I_d_max=50
fc=0.9e9  %frecuencia de corte [Hz]
fc_min=0.9e9
G=30 %ganancia ,-30dBm
##NEP=%[W/Hz]
##NEP_max=
##D_min= %directividad especifica [m sqrt(HZ)/W]
##D=
I=G*P_recivida*S

%RUIDO
I_L=20e-6
q=1.602176634e-19
I_sL=sqrt(2*q*I_L*fc)

NEP=5e-12
Df=10e6
Isl_amp=NEP*sqrt(Df)

%corriente de ruido total
I_ruido=sqrt(Isl_amp^2+I_sL^2)

A=10e3 %kV/A
V_ruido_amp=46.9e-6
V_ruido=sqrt((I_sL*A)^2+V_ruido_amp^2)