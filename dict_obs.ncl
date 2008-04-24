begin
    obs_gwname = "gw"
    obs_varname = ""

; 3D variables

    obs_varname@T = "T"
    obs_varname@U = "U"
    obs_varname@V = "V"
    obs_varname@Z = "Z3"
    obs_varname@Q = "SHUM"
    obs_varname@OMG = "OMEGA"

; surface variables

    obs_varname@PRCP = "PRECT"
    obs_varname@SLP = "PSL"
    obs_varname@SFCG = "TS"
    obs_varname@SENS = "SHFLX"
    obs_varname@EVAP = "LHFLX"
    obs_varname@U10 = "U_SURF"
    obs_varname@V10 = "V_SURF"
    obs_varname@TAUX = "TAUX"
    obs_varname@TAUY = "TAUY"
    obs_varname@CCOVER = "CLDTOT"
    obs_varname@T2 = "TREFHT"
    obs_varname@SST = "SST"

; radiation

    obs_varname@OSR = "FSNTOA"
    obs_varname@OLR = "FLUT"
    obs_varname@SSR = "FSNS" 
    obs_varname@SLR = "FLNS"
    obs_varname@SSRD = "FSDS"
    obs_varname@SLRD = "FLDS"

; meridional heat transport

   obs_fillvalue = -9.99e33

end
