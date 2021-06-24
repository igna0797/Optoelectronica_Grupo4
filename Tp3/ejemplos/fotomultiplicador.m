%datasheet fotomultiplicador
S=12
ef_quantica=2 %min 1
I_d=40 %corriente de oscuridad [nA]
I_d_max=100

t_rise=3e-9
t_transito=23e-9
t_spread=1.5e-9
t=t_spread+t_rise
fc=1/t %frecuencia de corte [Hz]
%a -1500V grafico para otras alimentacions 
G=1e6 %ganancia 
G_min=5e5

Df=1/(t_rise+t_spread)
it=40e-9
ik=2e-6
I_sL=sqrt(2*q*(ik+it)*Df)