load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$DIAGDIR/dict_xy.ncl"
load "$DIAGDIR/io_obs.ncl"

hemisphere = ""
lvec = False
ltrop = False
lmin = False
load "./conf.ncl"

begin

    l = lev@$plotid$
    seasons = (/"ANN", "MAM", "JJA", "SON", "DJF", "MON"/)
    if (lseasonal.eq.False) then
        tstr = sprinti("0.2%d", time)
        tlabel = "mon="+tstr
    else
        tstr = seasons(time)
        tlabel = tstr
    end if
;    if (plotid.eq."TTRP") then
;        ltrop = True
;    end if

; read data

    varname = varname@$plotid$
    tst_fname = rundir+"/"+varname+ext
    obs_fname = obsdir+"/"+obsid+"_"+tstr+"_climo.nc"
    lctl = ctlid.ne.""
    if (lvec) then
        varname_y = varname_y@$plotid$
        tst_fname_y = rundir+"/"+varname_y+ext
    end if
    if (lctl) then
        ctl_fname = ctldir+"/"+varname+ext
        if (lvec) then
            ctl_fname_y = ctldir+"/"+varname_y+ext
        end if
    end if
    if (l.eq.0) then
       	dtst = calc_model(rundir, varname, time, lseasonal)
        dtst@long_name = varname
        dobs = calc_obs_2d(obs_fname, varname, obsdir, tstr)
        if (lvec) then
            dtst_x = dtst
            dobs_x = dobs
            dtst_y = read_model(tst_fname_y, varname_y, time, lseasonal)
            dobs_y = read_obs_2d(obs_fname, varname_y)
            dtst@long_name = plotid
            dobs@long_name = plotid
        end if
        if (lctl) then
            dctl = calc_model(ctldir, varname, time, lseasonal)
            if (lvec) then
                dctl_x = dctl
                dctl_y = read_model(ctl_fname_y, varname_y, time, lseasonal)
                dctl@long_name = plotid
            end if
        end if
    else ; 3d
        buf = read_model(tst_fname, varname, time, lseasonal)
        dtst = buf({l*levfact_model},:,:)
        dtst@long_name = plotid
        if (lmin) then
            do j=0, dimsizes(buf&lat)-1
                do i=0, dimsizes(buf&lon)-1
                    dtst(j,i) = min(buf({50*levfact_model:200*levfact_model},j,i))
                end do
            end do
        end if
        delete(buf)
        buf = read_obs_3d(obs_fname, varname)
        dobs = buf({l},:,:)
        if (lmin) then
            do j=0, dimsizes(buf&lat)-1
                do i=0, dimsizes(buf&lon)-1
                    dobs(j,i) = min(buf({50*levfact_obs:200*levfact_obs},j,i))
                end do
            end do
        end if
        delete(buf)
        if (lctl) then
            buf = read_model(ctl_fname, varname, time, lseasonal)
            dctl = buf({l*levfact_model},:,:)
            if (lmin) then
                do j=0, dimsizes(buf&lat)-1
                    do i=0, dimsizes(buf&lon)-1
                        dctl(j,i) = min(buf({50*levfact_model:200*levfact_model},j,i))
                    end do
                end do
            end if
            delete(buf)
        end if
    end if
    dtst@units = dobs@units

; calculate maximum and minimum
; read Gaussian weights and calculate the global means

    if (lvec) then
        dtst = sqrt(dtst_x^2+dtst_y^2)
        dobs = sqrt(dobs_x^2+dobs_y^2)
        if (lctl) then
            dctl = sqrt(dctl_x^2+dctl_y^2)
        end if
    end if
    mxtst = max(dtst)
    mntst = min(dtst)
    mxobs = max(dobs)
    mnobs = min(dobs)
    nytst = dimsizes(dtst&lat)
    gwtst = gauswgt_txt(nytst)
    avtst = wgt_areaave(dtst,gwtst,1.,0)
;    gwobs = gauswgt_nc(obsdir+"/gw.nc")
    nyobs = dimsizes(dobs&lat)
    gwobs = gauswgt_txt(nyobs)
    avobs = wgt_areaave(dobs,gwobs,1.,0)
    if (lctl) then
        mxctl = max(dctl)
        mnctl = min(dctl)
        nyctl = dimsizes(dctl&lat)
        gwctl = gauswgt_txt(nyctl)
    end if

; regrid model

    dtstobs = dobs
    nxy = dimsizes(dtst)
    ntrunc = nxy(1)/3 - 1
    dtstobs = linint2(dtst&lon,dtst&lat,dtst,True,dobs&lon,dobs&lat,0)
    rmsetstobs = wgt_arearmse(dtstobs,dobs,gwobs,1.,0)
    dtstobs = (/ dtstobs - dobs /)
    mxtstobs = max(dtstobs)
    mntstobs = min(dtstobs)
    if (lvec) then
        dtstobs_x = dobs_x
        dtstobs_y = dobs_y
        dtstobs_x = linint2(dtst_x&lon,dtst_x&lat,dtst_x,True,dobs_x&lon,dobs_x&lat,0)
        dtstobs_y = linint2(dtst_y&lon,dtst_y&lat,dtst_y,True,dobs_y&lon,dobs_y&lat,0)
        dtstobs_x = dtstobs_x - dobs_x
        dtstobs_y = dtstobs_y - dobs_y
    end if
    if (lctl) then
        dctlobs = dtstobs
        dctlobs = linint2(dctl&lon,dctl&lat,dctl,True,dobs&lon,dobs&lat,0)
        rmsectlobs = wgt_arearmse(dctlobs,dobs,gwobs,1.,0)
        dctlobs = (/ dctlobs - dobs /)
        mxctlobs = max(dctlobs)
        mnctlobs = min(dctlobs)
        if (lvec) then
            dctlobs_x = dtstobs_x
            dctlobs_y = dtstobs_y
            dctlobs_x = linint2(dctl_x&lon,dctl_x&lat,dctl_x,True,dobs_x&lon,dobs_x&lat,0)
            dctlobs_y = linint2(dctl_y&lon,dctl_y&lat,dctl_y,True,dobs_y&lon,dobs_y&lat,0)
            dctlobs_x = dctlobs_x - dobs_x
            dctlobs_y = dctlobs_y - dobs_y
        end if
    end if

; set resources

    res = True

    res@gsnFrame = False
    res@gsnDraw = False
    lpolar = False
    if (hemisphere.ne."") then
        lpolar = True
    end if
    if (lpolar) then
        res@gsnPolar = hemisphere
        res@mpProjection = "Stereographic"
        res@mpMinLatF = minlat
        res@mpMaxLatF = maxlat
    else
        if (.not.lvec) then
            res@gsnZonalMean = True
            res@gsnZonalMeanXMinF = clevs@$plotid$(0)
            res@gsnZonalMeanXMaxF = clevs@$plotid$(nclev-1)
        end if
    end if

    if (ltrop) then
;    res@tiMainFontHeightF = 0.018
        res@mpMinLatF = -40.
        res@mpMaxLatF =  40.
    end if

    res@mpFillOn = False
    res@mpCenterLonF = 180.

    res@cnFillOn = True
    res@cnLevelSelectionMode = "ExplicitLevels"
    res@cnLinesOn = False
    res@cnLevels = clevs@$plotid$

    if (lvec) then
        res@gsnScalarContour = True
        res@vcRefAnnoOn = False
        res@vcRefLengthF = 0.06
        res@vcMinDistanceF = 0.015
        res@vcRefMagnitudeF = clevs@$plotid$(dimsizes(clevs@$plotid$)-1)
    end if

    res@txFontHeightF = 0.012
    res@tmXBLabelFontHeightF = 0.012
    res@tmYLLabelFontHeightF = 0.012
    res@lbTitleFontHeightF = 0.012
    res@lbLabelFontHeightF = 0.012
    if (.not.ltrop)
        res@lbOrientation = "vertical"
        res@lbBoxMinorExtentF = 0.15
    end if

    pres = True
    pres@txString = tlabel
    pres@gsnMaximize = True
    pres@gsnPaperOrientation = "portrait"

; draw plots

    wks = gsn_open_wks(dev, runid+"_"+plotid+"_"+tstr)
    gsn_define_colormap(wks, color)

    plot = new(4, "graphic")

    res@tiMainString = runid
    res@gsnCenterString = "mean="+sprintf("%7.2e",avtst)
    res@lbTitleString = "min="+sprintf("%7.2e",mntst)+" max="+sprintf("%7.2e", mxtst)
    if (lvec) then
        plot(0) = gsn_csm_vector_scalar_map(wks, dtst_x, dtst_y, dtst, res)
    else
        plot(0) = gsn_csm_contour_map(wks, dtst, res)
    end if
        res@tiMainString = obsid
        res@gsnCenterString = "mean="+sprintf("%7.2e",avobs)
        res@lbTitleString = "min="+sprintf("%7.2e",mnobs)+" max="+sprintf("%7.2e",mxobs)
    if (lvec) then
        plot(1) = gsn_csm_vector_scalar_map(wks, dobs_x, dobs_y, dobs, res)
    else
        plot(1) = gsn_csm_contour_map(wks, dobs, res)
    end if
    res@tiMainString = runid+"-"+obsid
    res@gsnCenterString = "rmse="+sprintf("%7.2e",rmsetstobs)
    res@cnLevels = dclevs@$plotid$
    res@lbTitleString = "min="+sprintf("%7.2e",mntstobs)+" max="+sprintf("%7.2e",mxtstobs)
    if (.not.(lpolar.or.lvec)) then
;        dtstobszm = dim_avg(dtstobs)
        res@gsnZonalMeanXMinF = dclevs@$plotid$(0)
        res@gsnZonalMeanXMaxF = dclevs@$plotid$(nclev-1)
    end if
    if (lvec) then
        res@vcRefMagnitudeF = mxtstobs
        plot(2) = gsn_csm_vector_scalar_map(wks, dtstobs_x, dtstobs_y, dtstobs, res)
    else
      plot(2) = gsn_csm_contour_map(wks, dtstobs, res)
    end if
    if (lctl) then
        res@tiMainString = ctlid+"-"+obsid
        res@gsnCenterString = "rmse="+sprintf("%7.2e",rmsectlobs)
        res@cnLevels = dclevs@$plotid$
        res@lbTitleString = "min="+sprintf("%7.2e",mnctlobs)+" max="+sprintf("%7.2e",mxctlobs)
        if (lvec) then
          res@vcRefMagnitudeF = mxctlobs
          plot(3) = gsn_csm_vector_scalar_map(wks, dctlobs_x, dctlobs_y, dctlobs, res)
        else
            plot(3) = gsn_csm_contour_map(wks, dctlobs, res)
        end if
    end if

    if (lctl) then
        gsn_panel(wks, plot, (/2,2/), pres)
    else
        if (lpolar) then
              gsn_panel(wks, plot(0:2), (/2,2/), pres)
        else
              gsn_panel(wks, plot(0:2), (/3,1/), pres)
        end if
    end if
end 
