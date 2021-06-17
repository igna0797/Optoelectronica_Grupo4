clc
clear all
lambda=1,550; %en um
a=4; %en um
L=50; %Km
D_lambda = 10; %nm
n2=1.4556;
Dm=20;
Dw=-83.76*lambda/a^2/n2;
Dp=1;
Dpmd=0.5;

Disp_material=Dm*D_lambda
Disp_guia=Dw*D_lambda
Disp_perfil=Dp*D_lambda
f_Disp_crom=@(L)abs((Disp_material+Disp_guia+Disp_perfil)*L);
Disp_crom=f_Disp_crom(L)

f_Disp_pol=@(L)Dpmd*sqrt(L);
Disp_pol=f_Disp_pol(L)

f_Dispercion=@(L) f_Disp_pol(L)+f_Disp_crom(L);
Dispersion=Disp_pol+Disp_crom