%datasheet fotomultiplicador
% OJO ES A 1500 [mA/W] mostrar en el grafico que ahi es plana todavia
S=12
ef_quantica=2 %min 1
##S=6000 %sensibilidad del anodo [A/W]
%varia con la temperatura grafico
I_d=40 %corriente de oscuridad [nA]
I_d_max=100

t_rise=3e-9
t_transito=23e-9
t_spread=1.5e-9
t=t_spread+t_transito+t_rise
fc=1/t %frecuencia de corte [Hz]
%a -1500V grafico para otras alimentacions 
G=1e6 %ganancia 
G_min=5e5
NEP= %[W/Hz]
NEP_max=
D_min= %directividad especifica [m sqrt(HZ)/W]
D=
