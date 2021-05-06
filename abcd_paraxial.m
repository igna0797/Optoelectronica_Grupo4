clc
clear all 
close all

##pkg load optics
##pkg load symbolic

%primera lente a 50mm
## f1=1
## f2=2
## n1=1
## n2=1
## L1=50e-3
## L2=200e-3

 syms f1 f2 L2 L1;
M1=[[1 L1];[ 0 1] ];
m21= [1 0];
m22=[-1/f1 1];
M2=[m21 ; m22];
##M2=[1 0 ; -1/f1 1]
m31= [1 L2];
M3=[m31 ; [0 1]];
m42=[-1/f2 1];
M4 = [[1 0] ; m42];
ABCD=M4*M3*M2*M1

##C=-1/f1+(L2/n2/f1+1)*1/f2

L1=50   %todas estan en mm
##f=-L1/f1+1-(L1+(L1+l2)*(-L1/f1+1))/f2
## A=1-L1/f1/n1;
A=1/25e-3
##f2=[-6 -9 -12 -15 -18  -24 -25]
f2=-6
##f1=-f2*A#800
f1=250
L2=f1+f2
M1=[[1 L1];[ 0 1] ];
m21= [1 0];
m22=[-1/f1 1];
M2=[m21 ; m22];
##M2=[1 0 ; -1/f1 1]
m31= [1 L2];
M3=[m31 ; [0 1]];
m42=[-1/f2 1];
M4 = [[1 0] ; m42];
ABCD=M4*M3*M2*M1
save ('ABCD', "M1","M2","M3","M4")
s=abcd('propagation',L1,'thin-lens',f1,'propagation',L2,'thin-lens',f2,'propagation',25)
##
rin=[0 , 1 , 0.5 ;0 0 0]
rout=trace(s,rin,true)
%gauusseano hacce mas ancho segun f (lo queres mas pequeño)


