%datasheet fotodiodo
S_min=0.85 %1550 [A/W]
S=1
I_d=0.3 %corriente de oscuridad [nA]
I_d_max=1.5
fc=300e6  %frecuencia de corte [Hz]
fc_min=150e6
G=1 %ganancia
NEP=5e-15 %[W/sqrt(Hz)] %NEP*
NEP_max=2e-14
D_min=1e12 %directividad especifica [m sqrt(HZ)/W]
D=5e12

I_L=1e-6
q=1.602176634e-19;
I_sL=sqrt(2*q*I_L*fc)

NEP_equ=NEP_max*sqrt(fc) %NEP
In=NEP_max*sqrt(fc)*S

%ampli transinpedancia
NEP=5e-12
Df=10e6
Isl_amp=NEP*sqrt(Df)

%corriente de ruido total
I_ruido=sqrt(Isl_amp^2+In^2)