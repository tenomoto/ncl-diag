load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$DIAGDIR/dict_yz.ncl"
load "$DIAGDIR/io_obs.ncl"
load "./conf.ncl"

undef("common_vals")
function common_vals(a[*]:numeric,b[*]:numeric)
local na, nb, nc, i, j, k
begin
    na = dimsizes(a)
    nb = dimsizes(b)
    nc = min((/na,nb/))
    c = new(nc, typeof(a))
    i = 0
    j = 0
    k = 0
    do i=0, na-1
        do j=0, nb-1
            if (a(i).eq.b(j)) then
                c(k) = a(i)
                k = k + 1
            end if
        end do
    end do
    return c(0:k-1)
end

begin

    seasons = (/"ANN", "MAM", "JJA", "SON", "DJF", "MON"/)
    if (lseasonal.eq.False) then
        tstr = sprinti("0.2%i", time)
        tlabel = "mon="+tstr
    else
        tstr = seasons(time)
        tlabel = tstr
    end if

; read data

    varname = varname@$plotid$
    tst_fname = rundir+"/"+varname+ext
    obs_fname = obsdir+"/"+obsid+"_"+tstr+"_climo.nc"
    ctl_fname = ctldir+"/"+varname+ext
    buf = read_model(tst_fname, varname, time, lseasonal)
    lv = buf&lev
    lv!0 = "lev"
    lv&lev = lv
    dtst = dim_avg(buf({1000*levfact_model:lev@$plotid$*levfact_model},:,:))
    dtst!0 = "lev"
    dtst&lev = lv({1000*levfact_model:lev@$plotid$*levfact_model})
    dtst!1 = "lat"
    dtst&lat = buf&lat
    delete(lv)
    delete(buf)

    buf = read_obs_3d(obs_fname, varname)
    buf!0 = "lev"
    lv = buf&lev
    lv!0 = "lev"
    lv&lev = lv
    dobs = dim_avg(buf({1000*levfact_obs:lev@$plotid$*levfact_obs},:,:))
    dobs!0 = "lev"
    dobs&lev = lv({1000*levfact_obs:lev@$plotid$*levfact_obs})
    dobs!1 = "lat"
    dobs&lat = buf&lat
    dobs@units = buf@units
    delete(lv)
    delete(buf)

    lctl = ctlid.ne.""
    if (lctl) then
        buf = read_model(ctl_fname, varname, time, lseasonal)
        lv = buf&lev
        lv!0 = "lev"
        lv&lev = lv
        dctl = dim_avg(buf({1000*levfact_model:lev@$plotid$*levfact_model},:,:))
        dctl!0 = "lev"
        dctl&lev = lv({1000*levfact_model:lev@$plotid$*levfact_model})
        dctl!1 = "lat"
        dctl&lat = buf&lat
        delete(lv)
        delete(buf)
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

    levc = common_vals(dobs&lev, dtst&lev*levfact_obs/levfact_model)
    nz = dimsizes(levc)
    ny = dimsizes(dobs&lat)
    levo = dobs&lev
    levc!0 = "lev"
    levc&lev = levc
    levc@units = levo@units
    dtstobs = new((/nz,ny/),"float")
    dtstobs!0 = "lev"
    dtstobs&lev = levc
    dtstobs!1 = "lat"
    dtstobs&lat = dobs&lat
    dtstobs@units = dobs@units
    dobsc = dtstobs
    dobsc@long_name = dobs@long_name
    dobsc@units = dobs@units
    buf = dtst
    do i=0, nz-1
        buf(i,:) = dtst({levc(i)*levfact_model},:)
        dobsc(i,:) = dobs({levc(i)},:)
    end do
    dtstobs = (/ linint1(dtst&lat, buf(0:nz-1,:), False, dobs&lat, 0) /)
    dtstobs = (/ dtstobs - dobsc /)

    mxtstobs = sprintf("%7.2e",max(dtstobs))
    mntstobs = sprintf("%7.2e",min(dtstobs))
    if (lctl) then
        dctlobs = dtstobs
        buf = dctl
        do i=0, nz-1
            buf(i,:) = dctl({levc(i)*levfact_model},:)
        end do
        dctlobs = (/ linint1(dctl&lat, buf(0:nz-1,:), False, dobs&lat, 0) /)
        dctlobs = (/ dctlobs - dobsc /)
        mxctlobs = sprintf("%7.2e",max(dctlobs))
        mnctlobs = sprintf("%7.2e",min(dctlobs))
    end if
    delete(buf)
    delete(levc)
    delete(levo)

; set resources

    res = True

; res@gsnMaximize = True
    res@gsnFrame = False
    res@gsnDraw = False

    res@cnFillOn = True
    res@cnLinesOn = False
    res@cnLevelSelectionMode = "ExplicitLevels"
    res@cnLevels = clevs@$plotid$

    res@lbOrientation = "vertical"
    res@lbTitleFontHeightF = 0.015
    res@lbBoxMinorExtentF = 0.15

    res@tmYRMode = "Automatic"

    pres = True
    pres@txString = tlabel

; draw plots

    wks = gsn_open_wks(dev, runid+"_"+plotid+"_"+tstr)
    gsn_define_colormap(wks, color)

    plot = new(4, "graphic")

    res@tiMainString = runid
    res@lbTitleString = "min="+mntst+" max="+mxtst
    plot(0) = gsn_csm_pres_hgt(wks, dtst, res)
    res@tiMainString = obsid
    res@lbTitleString = "min="+mnobs+" max="+mxobs
    plot(1) = gsn_csm_pres_hgt(wks, dobs, res)
    res@tiMainString = runid+"-"+obsid
    res@cnLevels = dclevs@$plotid$
    res@lbTitleString = "min="+mntstobs+" max="+mxtstobs
    plot(2) = gsn_csm_pres_hgt(wks, dtstobs, res)
    if (lctl)
        res@tiMainString = ctlid+"-"+obsid
        res@cnLevels = dclevs@$plotid$
        res@lbTitleString = "min="+mnctlobs+" max="+mxctlobs
        plot(3) = gsn_csm_pres_hgt(wks, dctlobs, res)
    end if

    if (lctl)
        gsn_panel(wks, plot, (/2,2/), pres)
    else
        gsn_panel(wks, plot(0:2), (/2,2/), pres)
    end if
end 
