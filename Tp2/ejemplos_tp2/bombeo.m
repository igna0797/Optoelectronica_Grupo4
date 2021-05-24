# funcion de bombeo para el ajuste
function [R_a] = bombeo(t, R_p, tau_p)
   
   R_a = R_p*(t/tau_p)^2*exp(-2*t/tau_p);

endfunction
