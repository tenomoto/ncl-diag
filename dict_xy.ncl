begin
    varname = ""
    varname_y = ""
    lev = 0
    nclev = 15
    clevs = new(nclev, float)
    dclevs = clevs

    varname@T850 = "T"
    lev@T850 = 850
    clevs@T850 = fspan(230., 300., nclev)
    dclevs@T850 = (/-8., -6., -5., -4., -3., -2., -1., 0., \
                     1.,  2.,  3.,  4.,  5.,  6.,  8./)

    varname@T200 = "T"
    lev@T200 = 200
    clevs@T200 = fspan(190., 232., nclev)
    dclevs@T200 = (/-10., -8., -6., -4., -3., -2., -1., 0., \
                      1.,  2.,  3.,  4.,  6.,  8., 10./)

    varname@TTRP = "T"
    lev@TTRP = 100 ; dummy. min T between 50-200 hPa 
    clevs@TTRP = fspan(186., 214., nclev)
    dclevs@TTRP = (/-8., -6., -4., -3., -2, -1., -0.5, 0., \
                     0.5, 1.,  2.,  3.,  4., 6., 8./)

    varname@U200 = "U" 
    lev@U200 = 200
    clevs@U200 = (/-20., -15., -10., -5.,  0.,  5., 10., 15., \
                    20.,  25.,  30., 40., 50., 60., 70./)
    dclevs@U200 = (/-28., -24., -20., -16., -12., -8., -4., 0., \
                      4.,   8.,  12.,  16.,  20., 24., 28./)

    varname@U850 = "U" 
    lev@U850 = 850
    clevs@U850 = (/-9., -6., -4., -3, -2.,  -1.,  0., 1., \
                    2.,  3.,  4.,  6., 9.,  12., 15./)
    dclevs@U850 = (/-12., -9., -6., -4., -3., -2., -1., 0., \
                      1.,  2.,  3.,  4.,  6.,  9., 12./)

    varname@U50NH = "U" 
    lev@U50NH = 50
    clevs@U50NH = (/-25., -20., -15., -10., -5.,  0.,  5., 10.,\
                     15.,  20.,  25.,  30., 35., 40., 50./)
    dclevs@U50NH = (/-20., -15., -10.,  -8.,  -6., -4., -2., 0., \
                     2.,   4.,   6.,   8.,  10., 15., 20./)
    varname@U50SH = "U"
    lev@U50SH = 50
    clevs@U50SH = clevs@U50NH
    dclevs@U50SH = dclevs@U50NH

    varname@Z500 = "Z" 
    lev@Z500 = 500  
    clevs@Z500 = (/4800., 4900., 5000., 5100., 5200., 5300., 5400., 5500., \
                   5600., 5700., 5800., 5850., 5900., 5950., 6000./)
    dclevs@Z500 = (/-120., -100., -80., -60., -40., -20., -10., 0., \
                      10.,   20.,  40.,  60.,  80., 100., 120./)
    varname@Z500NH = "Z"
    lev@Z500NH = 500
    clevs@Z500NH = clevs@Z500
    dclevs@Z500NH = dclevs@Z500
    varname@Z500SH = "Z"
    lev@Z500SH = 500
    clevs@Z500SH = clevs@Z500
    dclevs@Z500SH = dclevs@Z500

    varname@Z300 = "Z"
    lev@Z300 = 300
    clevs@Z300 = fspan(8300., 9700., nclev)
    dclevs@Z300 = (/-180, -150, -120, -90, -60, -30, -10, 0., \
                      10,   30,   60,  90, 120, 150, 180 /)

    varname@PRCP_GPCP = "PRCP"
    lev@PRCP_GPCP =   0
    clevs@PRCP_GPCP = (/0.2, 0.5,  1.,  2.,  3.,  4.,  5., 6., \
                        7.,  8.,   9., 10., 12., 14., 17./) 
    dclevs@PRCP_GPCP = (/-8., -6., -4., -3., -2., -1., -0.5, 0, \
                     0.5, 1.,  2.,  3.,  4.,  6.,  8./) 
    varname@PRCP_XIEARKIN = "PRCP"
    lev@PRCP_XIEARKIN =   0
    clevs@PRCP_XIEARKIN = clevs@PRCP_GPCP
    dclevs@PRCP_XIEARKIN = dclevs@PRCP_GPCP
    varname@PRCP_TRMM = "PRCP"
    lev@PRCP_TRMM =   0
    clevs@PRCP_TRMM = clevs@PRCP_GPCP
    dclevs@PRCP_TRMM = dclevs@PRCP_GPCP

    varname@SLP = "SLP"
    lev@SLP  =   0
    clevs@SLP = fspan(984., 1040., nclev)
    dclevs@SLP = (/-15., -10., -8., -6., -4., -2., -1., 0., \
                     1.,   2.,  4.,  6.,  8., 10., 15./)
    varname@SLPNH = "SLP"
    lev@SLPNH  =   0
    clevs@SLPNH = clevs@SLP
    dclevs@SLPNH = dclevs@SLP
    varname@SLPSH = "SLP"
    lev@SLPSH  =   0
    clevs@SLPSH = clevs@SLP
    dclevs@SLPSH = dclevs@SLP

    varname@SFCG = "SFCG"
    lev@SFCG = 0
    clevs@SFCG = (/210., 220., 230., 240., 250., 260., 270., 275., \
                   280., 285., 290., 295., 300., 305., 310. /)
    dclevs@SFCG = (/-12., -10., -8., -6., -4., -2., -1., 0., \
                        1.,   2.,  4.,  6.,  8., 10., 12./)

    varname@EVAP = "EVAP"
    lev@EVAP = 0
    clevs@EVAP = (/  0.,  15.,  30.,  60.,  90., 120., 150., 180., \
                   210., 240., 270., 300., 330., 360., 390./)
    dclevs@EVAP = (/-150., -120., -90., -60., -30., -20., -10., 0., \
                      10.,   20.,  30.,  60.,  90., 120., 150. /) 

    varname@SENS = "SENS"
    lev@SENS = 0
    clevs@SENS = (/-100., -75., -50., -25,  -10.,   0., 10., 25., \
                     50.,  75., 100., 125., 150., 175., 200. /)
    dclevs@SENS = (/-100., -80., -60., -40., -20., -10.,  -5., 0., \
                       5.,  10.,  20.,  40.,  60.,  80., 100. /) 

    varname@OSR = "OSR"
    lev@OSR  =   0
    clevs@OSR = fspan(0,420,nclev)
    dclevs@OSR = (/-80., -60., -40., -30., -20., -10., -5., 0., \
                     5.,  10.,  20.,  30.,  40.,  60., 80./)
 
    varname@OLR = "OLR"
    lev@OLR  =   0
    clevs@OLR = (/100., 115., 130., 145., 160., 175., 190., 205., \
                  220., 235., 250., 265., 280., 295., 310./)
    dclevs@OLR = (/-60., -50., -40., -30., -20., -10., -5., 0., \
                     5.,  10.,  20.,  30.,  40.,  50., 60./)
 
    varname@SSR = "SSR"
    lev@SSR = 0
    clevs@SSR = (/  0.,  25.,  50.,  75., 100., 125., 150., 175., \
                  200., 220., 240., 260., 280., 300., 320./) 
    dclevs@SSR = (/-100., -75., -50., -40., -30., -20., -10., 0., \
                     10.,  20.,  30.,  40.,  50.,  75., 100./)

    varname@SLR = "SLR"
    lev@SLR = 0
    clevs@SLR = fspan(10., 150., nclev)
    dclevs@SLR = (/-70., -50., -40., -30., -20., -10., -5., 0., \
                     5.,  10.,  20.,  30.,  40.,  50.,  70./)

    varname@SSRD = "SSRD"
    lev@SSRD = 0
    clevs@SSRD = fspan(25., 375., nclev)
    dclevs@SSRD = (/-90., -70., -50., -40., -30., -20., -10., 0., \
                     10.,  20.,  30.,  40.,  50.,  70.,  90./)

    varname@SLRD = "SLRD"
    lev@SLRD = 0
    clevs@SLRD = fspan(75., 425., nclev)
    dclevs@SLRD = (/-50., -40., -30., -20., -15., -10., -5., 0., \
                      5.,  10.,  15.,  20.,  30.,  40., 50./)

    varname@UV10 = "U10"
    varname_y@UV10 = "V10"
    lev@UV10 = 0
    clevs@UV10 = fspan(1., 15., nclev)
    dclevs@UV10 = fspan(-7., 7., nclev)

    varname@TAUXY = "TAUX"
    varname_y@TAUXY = "TAUY"
    lev@TAUXY = 0
    clevs@TAUXY = (/0.01, 0.02, 0.03, 0.04, 0.06, 0.08, 0.1, 0.12, \
                    0.14, 0.16, 0.18, 0.2,  0.24, 0.28, 0.32/)
    dclevs@TAUXY = (/-0.12, -0.09, -0.06, -0.04, -0.03, -0.02, -0.01, 0., \
                      0.01,  0.02,  0.03,  0.04,  0.06,  0.09,  0.12/)

    varname@CCOVER = "CCOVER"
    lev@CCOVER = 0
    clevs@CCOVER = (/ 5., 10., 15., 20., 25., 30., 40., 50., \
                     60., 70., 75., 80., 85., 90., 95./)
    dclevs@CCOVER = (/-50., -40., -30., -20., -15., -10., -5., 0., \
                        5.,  10.,  15.,  20.,  30.,  40., 50./)

    varname@T2 = "T2"
    lev@T2 = 0
    clevs@T2 = (/210.,220.,230.,240.,250.,260.,270.,275.,280.,285.,290.,295.,300.,305.,310./)
    dclevs@T2 = (/-12,-10., -8., -6., -4., -2., -1.,  0.,  1.,  2.,  4.,  6.,  8., 10., 12./)

    varname@SST = "SST"
    lev@SST = 0
    clevs@SST = (/-1.,  0.,  1.,  3.,  6.,  9., 12., 15., \
                   18., 20., 22., 24., 26., 28., 29. /)
    dclevs@SST = (/-5., -4., -3., -2., -1., -0.5, -0.2, 0., \
                    0.2, 0.5, 1.,  2.,  3.,  4.,   5./)
end
