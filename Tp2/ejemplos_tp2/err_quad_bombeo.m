# calcula el error cuadratico medio entre los puntos medidos y la expresion de bombeo para ajustar
function [err_cuad] = err_quad_bombeo(parametros, puntos)
   R_p = parametros(1);
   tau_p = parametros(2);

   t = puntos(:, 1);
   R = puntos(:, 2);
   err_cuad = sum((R - arrayfun(@(t) bombeo(t, R_p, tau_p), t)).^2);

endfunction
