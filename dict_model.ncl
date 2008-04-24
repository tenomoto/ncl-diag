begin
    model_gwname = "gwgt"
    scale = 1.

; 3D variables

    scale@T = 1.
    scale@U = 1.
    scale@V = 1.
    scale@Z = 1.
    scale@OMG = 864.
    scale@Q = 1000.
    scale@RH = 100.

; surface scalar variables

    scale@SLP = 0.01
    scale@PRCP = 86400.
    scale@SFCG = 1.
    scale@SENS = 1.
    scale@EVAP = 1.
    scale@U10 = 1.
    scale@V10 = 1.
    scale@TAUX = -1.
    scale@TAUY = -1.
    scale@CCOVER = 100.
    scale@T2   = 1.
    scale@SST   = 1.

; radiation

    scale@OSR = -1.
    scale@OLR = 1.
    scale@SSR = -1.
    scale@SLR = 1.
    scale@SSRD = 1.
    scale@SLRD = 1.

; geo

		scale@IDSRF = 1.

end
