function [t, P, g] = qswitch(TI, beta, I_s, R_p, tau_p)

    # Definicion de constante
    h = 6.62e-34; #J*s  - constante de Planck 
    k = 1.38e-23; #J/K  - constante de Bolztmann
    c = 3e8; #m/s   - velocidad de la luz 
    l_21 = 1064e-9; #m  - longitud de onda
    tau_2 = 230e-6; #s  tau_20 + 1/A_21     - constante de tiempo 
    tau_10 = 30e-9; #s  - constante de tiempo 
    sigma_21 = 2.8e-19; #m^2    - seccion eficaz


    # Propiedades de la cavidad
    R_1 = 0.99; #   - reflectividad del espejo trasero
    R_2 = 0.53; #   - reflectividad del espejo de salida
    T_1 = 0.98; #   - transmisividad
    T_2 = 0.98; #   - transmisividad
    L_c = 235e-3; #m        - largo de la cavidad
    L_g = 76.2e-3; #m        - largo del medio activo 

    # valores aproximados, hay que hacer bien los calculos
    S = 0.5; #  - fraccion de fotones que sobreviven un ida y vuelta
    tau_rt = 1.5e-9 #   - tiempo de round-trip
    tau_f = tau_rt/(1 - S); #s - tiempo de vida en la cavidad laser

    # Mas parametros
    # valores aproximados, hay que hacer bien los calculos
    a = 6.5e-6;

    # Bombeo
    # normalizacion aproximada, hay que hacer bien los calculos
    R_pn = R_p*4.5e-24;
    tau_pn = tau_p/tau_rt;

    # Condicion inicial
    P_0 = 0;
    g_0 = 0;
    VI_0 = [P_0; g_0];

    #Integracion
    #VI = [P; g]; #matriz de variable a integrar
    param = [beta, S, a, R_pn, tau_pn]; #listado de parametros

    #options = odeset("outputfcn", @odeplot);
#    [t, VI] = ode45(@(t, VI) dtqswitch(t, VI, param), [0:10:TI], VI_0);
#    [t, VI] = ode23(@(t, VI) dtqswitch(t, VI, param), [0 TI], VI_0);
#    [t, VI] = ode15s(@(t, VI) dtqswitch(t, VI, param), [0 TI], VI_0);
    t = (0:10:TI);
    lsode_options("integration method", "stiff");
    [VI, ~, ~] = lsode(@(VI, t) dtqswitch(t, VI, param), VI_0, t);

    t = tau_rt*t';
    P = VI(:,1);
    g = VI(:,2);

endfunction
