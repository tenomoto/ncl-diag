load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$DIAGDIR/io_obs.ncl"
load "$DIAGDIR/io_geo.ncl"
load "$DIAGDIR/functions_transport.ncl"
load "./conf.ncl"
undef("calc_aht")

nbasins = 4
ny_obs = 64
basins = (/"Pacific Ocean","Atlantic Ocean","Indian Ocean","World Ocean"/)

function calc_oht(datadir:string,geodir:string)
local ssr, slr, sens, evap, geo, lat, fname, ny
begin
; read model
	geo = read_geo(geodir)

	fname = datadir+"/SSR"+ext
	ssr= read_model(fname, "SSR", 0, True)
	fname = datadir+"/SLR"+ext
	slr= read_model(fname, "SLR", 0, True)
	fname = datadir+"/SENS"+ext
	sens= read_model(fname, "SENS", 0, True)
	fname = datadir+"/EVAP"+ext
	evap= read_model(fname, "EVAP", 0, True)
	ny= dimsizes(ssr&lat)
	gw= gauswgt_txt(ny)

; calc transport
	oht= oht_model(gw,geo,ssr,slr,sens,evap)
	return oht
end

function calc_aht(datadir:string,oht[*][*]:numeric)
local fname, restoa, rht, gw
begin
	fname = datadir+"/OSR"+ext
	restoa = read_model(fname, "OSR", 0, True)
	fname = datadir+"/OLR"+ext
	restoa = (/restoa-read_model(fname, "OLR", 0, True)/)
	ny = dimsizes(restoa&lat)
	gw = gauswgt_txt(ny)
	aht = new((/3,ny/),"float")
	aht@long_name = "heat transport (PW)"
	aht(0,:) = rht_model(gw,restoa)
	aht(1,:) = (/aht(0,:)-oht(3,:)/)
	aht(2,:) = oht(3,:)
	return aht
end

begin
	oht_tst = calc_oht(rundir,georun)
	aht_tst = calc_aht(rundir,oht_tst)
	lat_tst = oht_tst&lat
	ny_tst  = dimsizes(lat_tst)
	ny_ctl = 0
  lctl = ctlid.ne.""
	if (lctl) then
		oht_ctl = calc_oht(ctldir,geoctl)
		aht_ctl = calc_aht(ctldir,oht_ctl)
		lat_ctl = oht_ctl&lat
		ny_ctl  = dimsizes(lat_ctl)
	end if

; read obs
	lat_obs = new((/ny_obs/),float)
	oht_obs = new((/nbasins,ny_obs/),float)
	oht_obs@_FillValue = obs_fillvalue
	aht_obs = new((/3,ny_obs/),float)
	aht_obs@_FillValue = obs_fillvalue
	read_obs_tr(obsdir+"/"+obsid+".ascii",lat_obs,oht_obs,aht_obs)

; plot
	wks = gsn_open_wks(dev,runid+"_O"+plotid+"_ANN")
	res = True
	res@xyMonoDashPattern = True
	res@xyLineColors = (/"black","red","blue"/)
	res@xyLineThicknessF = 3
	res@gsnDraw = False
	res@gsnFrame = False
	res@gsnYRefLine = 0.
	res@pmLegendSide = "Bottom"
	res@pmLegendWidthF = 0.15
	res@pmLegendHeightF = 0.1
	res@lgLabelFontHeightF = 0.02
	res@pmLegendParallelPosF = 0.8
	res@pmLegendOrthogonalPosF = -0.38

	ny = max((/ny_obs,ny_tst,ny_ctl/))
	tr = new((/3,ny/),"float")
	tr@long_name = "heat transport (PW)"
	lat = new((/3,ny/), "float")
	lat(0,0:ny_obs-1) = (/lat_obs/)
	lat(1,0:ny_tst-1) = (/lat_tst/)
	lat@long_name = "latitudes"
	if (lctl) then
		lat(2,0:ny_ctl-1) = (/lat_ctl/)
	end if

; ocean heat transport
	plot_oht = new((/nbasins/),"graphic")
	do i=0, nbasins-1
		res@gsnLeftString = basins(i)
		if (i.eq.nbasins-1) then
			res@pmLegendDisplayMode = "Always"
			if (lctl) then
				res@xyExplicitLegendLabels = (/"NCEP",runid,ctlid/)
			else
				res@xyExplicitLegendLabels = (/"NCEP",runid,""/)
			end if
		else
			res@pmLegendDisplayMode = "NoCreate"
		end if
		tr(0,0:ny_obs-1) = (/oht_obs(i,:)/)
		tr(1,0:ny_tst-1) = (/oht_tst(i,:)/)
		if (lctl) then
			tr(2,0:ny_ctl-1) = (/oht_ctl(i,:)/)
			plot_oht(i) = gsn_csm_xy(wks, lat, tr, res)
		else
			plot_oht(i) = gsn_csm_xy(wks, lat(:1,:), tr(:1,:), res)
		end if
	end do
	pres = True
	pres@txString = "Annual Implied Northward Ocean Heat Transport"
	gsn_panel(wks, plot_oht, (/2,2/), pres)

; atmospheric heat transport: -OSR-OLR-OHT
	delete(wks)
	wks = gsn_open_wks(dev,runid+"_A"+plotid+"_ANN")
	plot_aht = new((/2/),"graphic")
	res@pmLegendDisplayMode = "NoCreate"
	res@gsnLeftString = runid
	pres@txString = "Annual Implied Northward Heat Transport"
	plot_aht(0) = gsn_csm_xy(wks, lat_tst, aht_tst, res)
	res@gsnLeftString = "NCEP derived"
	delete(res@xyExplicitLegendLabels)
	res@pmLegendDisplayMode = "Always"
	res@xyExplicitLegendLabels = (/"-OSR-OLR","Atmosphere","Ocean"/)
	res@pmLegendParallelPosF = 0.75
	res@pmLegendOrthogonalPosF = -0.3
	plot_aht(1) = gsn_csm_xy(wks, lat_obs, aht_obs, res)
	gsn_panel(wks, plot_aht, (/1,2/), pres)
end
