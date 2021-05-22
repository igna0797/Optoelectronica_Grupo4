function dtVI = dtqswitch(t, VI, param)

    # Parametros pasados por el ode
    beta = param(1);	
    S = param(2);
    a = param(3);
    R_pn = param(4);
    tau_pn = param(5);

    P = VI(1);
    g = VI(2);

    # Bombeo
    R = R_pn*((t/tau_pn)^2)*exp(-2*t/tau_pn);

    # Ecuaciones a integrar
    dP = (S*exp(g) - 1)*P + beta*g;
    dg = a*(R - g*(1 + P));

    dtVI = [dP; dg];

endfunction
