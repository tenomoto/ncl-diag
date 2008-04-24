load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$DIAGDIR/dict_ty.ncl"
load "$DIAGDIR/io_obs.ncl"
load "./conf.ncl"

begin

; read data

    nt = 12

    varname = varname@$plotid$
    tst_fname = rundir+"/"+varname+ext
    level = lev@$plotid$
    dtst = read_model_ty(tst_fname, varname, level)

    obs_fname = obsdir+"/"+obsid+"_"
    dobs = read_obs_ty(obs_fname, varname, level)

    lctl = ctlid.ne.""
    if (lctl) then
        ctl_fname = ctldir+"/"+varname+ext
        dctl = read_model_ty(ctl_fname, varname, level)
    end if

    dtst@long_name = varname
    dtst@units = dobs@units
    dobs@long_name = dtst@long_name

; calculate maximum and minimum
; read Gaussian weights and calculate the global means

    mxtst = sprintf("%7.2e",max(dtst))
    mntst = sprintf("%7.2e",min(dtst))
    mxobs = sprintf("%7.2e",max(dobs))
    mnobs = sprintf("%7.2e",min(dobs))

; regrid model

    dtstobs = dobs
    dtstobs = (/ linint1(dtst&lat, dtst, False, dobs&lat, 0) /)
    dtstobs = (/ dtstobs - dobs /)
    mxtstobs = sprintf("%7.2e",max(dtstobs))
    mntstobs = sprintf("%7.2e",min(dtstobs))
    if (lctl) then
        dctlobs = dobs
        dctlobs = (/ linint1(dctl&lat, dctl, False, dobs&lat, 0) /)
        dctlobs = (/ dctlobs - dobs /)
        mxctlobs = sprintf("%7.2e",max(dctlobs))
        mnctlobs = sprintf("%7.2e",min(dctlobs))
    end if

; set resources

    res = True

    res@gsnFrame = False
    res@gsnDraw = False

    res@cnFillOn = True
    res@cnLinesOn = False
    res@cnLevelSelectionMode = "ExplicitLevels"
    res@cnLevels = clevs@$plotid$

    res@lbOrientation = "vertical"
    res@lbTitleFontHeightF = 0.015
    res@lbBoxMinorExtentF = 0.15

    res@tmXBMode = "Explicit"
    res@tmXBValues = ispan(0,11,1)
    res@tmXBLabels = res@tmXBValues + 1

    pres = True
    pres@txString = "zonal-mean annual cycle"

; draw plots

    wks = gsn_open_wks(dev, runid+"_"+plotid+"_ANC")
    gsn_define_colormap(wks, color)

    plot = new(4, "graphic")

    res@tiMainString = runid
    res@lbTitleString = "min="+mntst+" max="+mxtst
    plot(0) = gsn_csm_contour(wks, dtst(lat|:,time|:), res)
    res@tiMainString = obsid
    res@lbTitleString = "min="+mnobs+" max="+mxobs
    plot(1) = gsn_csm_contour(wks, dobs(lat|:,time|:), res)
    res@tiMainString = runid+"-"+obsid
    res@cnLevels = dclevs@$plotid$
    res@lbTitleString = "min="+mntstobs+" max="+mxtstobs
    plot(2) = gsn_csm_contour(wks, dtstobs(lat|:,time|:), res)
    if (lctl) then
        res@tiMainString = ctlid+"-"+obsid
        res@cnLevels = dclevs@$plotid$
        res@lbTitleString = "min="+mnctlobs+" max="+mxctlobs
        plot(3) = gsn_csm_contour(wks, dctlobs(lat|:,time|:), res)
    end if

    if (lctl) then
        gsn_panel(wks, plot, (/2,2/), pres)
    else
        gsn_panel(wks, plot(0:2), (/2,2/), pres)
    end if
end 
