begin
    varname = ""
    lev = 0
    nclev = 15
    clevs = new(nclev, float)
    dclevs = clevs

    varname@V200 = "V"
    lev@V200 = 200
    clevs@V200 =  fspan(-3.5, 3.5, nclev)
    dclevs@V200 = (/-2., -1.5, -1.2, -0.8, -0.5, -0.2, -0.1, 0., \
                     0.1, 0.2,  0.5,  0.8,  1.2,  1.5,  2./)

    varname@U200 = "U" 
    lev@U200 = 200
    clevs@U200 = fspan(-25., 45., nclev)
    dclevs@U200 = (/-12., -10., -8., -6., -4., -2., -1., 0., \
                      1.,   2.,  4.,  6.,  8., 10., 12./)

    varname@PRCP = "PRCP"
    lev@PRCP =   0
    clevs@PRCP = (/0.5,  1.,  2.,  3.,  4.,  4.5, 5., 5.5, \
                   6.,  6.5,  7.,  7.5, 8., 8.5,  9./) 
    dclevs@PRCP = (/-2.5, -2., -1.5, -1., -0.7, -0.5, -0.3, 0, \
                     0.3,  0.5, 0.7,  1.,  1.5,  2.,   2.5/)

end
