load "$DIAGDIR/dict_obs.ncl"
undef("gauswgt_txt")
undef("gauswgt_nc")
undef("read_obs_2d")
undef("read_obs_3d")
undef("read_obs_ty")
undef("read_obs_tr")

levfact_obs = 1

function gauswgt_txt(ny)
local ns, fname
begin
    ns = (ny*2-1)/3
    fname = "T"+ns+"_wgt.txt"
    if (isfilepresent("T"+ns+"_wgt.txt")) then
      gw = asciiread(fname, ny, "float")
    else
      gauinfo = gaus(ny/2)
      gw = doubletofloat(gauinfo(:,1))
      asciiwrite(fname, gw)
    end if
    return gw
end

function gauswgt_nc(fname)
begin
    f = addfile(fname, "r")
    return f->gw
    delete(f)
end

function read_obs_2d(fname, varname)
local f
begin
    f = addfile(fname, "r")
    obs_varname = obs_varname@$varname$
    d = f->$obs_varname$(0,:,:)
    return d
    delete(f)
end

function read_obs_3d(fname, varname)
local f
begin
    f = addfile(fname, "r")
    obs_varname = obs_varname@$varname$
    d = f->$obs_varname$(0,:,:,:)
    return d
    delete(f)
end

function read_obs_ty(fname, varname, l)
local t, f
begin
    nt = 12
    obs_varname = obs_varname@$varname$
    f = addfile(fname+"01_climo.nc", "r")
    d = new((/nt,dimsizes(f->lat)/), "float")
    d!0 = "time"
    d!1 = "lat"
    d&lat = f->lat
    d&time = ispan(1, 12, 1)
    d@long_name = f->$obs_varname$@long_name
    d@units = f->$obs_varname$@units
    d@_FillValue = f->$obs_varname$@_FillValue
    delete(f)
    do t=0, nt-1
      f = addfile(fname+sprinti("%0.2i",t+1)+"_climo.nc", "r")
      if (l.eq.0) then
        d(t,:) = (/ dim_avg(f->$obs_varname$(0,:,:)) /)
      else
        d(t,:) = (/ dim_avg(f->$obs_varname$(0,{l*levfact_obs},:,:)) /)
      end if
      delete(f)
    end do
    return d
end

procedure read_obs_tr(fname:string,lat[*]:numeric,oht[*][*]:numeric,aht[*][*]:numeric)
local lat, ny, j65N, j65S, buf
begin
	j65S = 7
	j65N = 56
	ny = dimsizes(lat) 
	buf = asciiread(fname,(/ny,22/),"integer")
	lat = buf(::-1,0)*0.01
	lat!0 = "lat"
	lat&lat = lat	
	oht(0,:) = buf(::-1,8)*0.01    ; Pacific Ocean
	oht(1,:) = buf(::-1,7)*0.01    ; Atlantic Ocean
	oht(1,j65N:) = oht@_FillValue  ; Set to missing > 65N
	oht(2,:) = buf(::-1,9)*0.01    ; Indian Ocean
	oht(3,:) = buf(::-1,4)*0.01    ; World Ocean
	oht(3,:j65S) = oht@_FillValue	 ; Set to missing < 65S
	oht(3,j65N:) = oht@_FillValue	 ; Set to missing > 65N
	aht(0,:) = buf(::-1,1)*0.01    ; RHT (ERBE TOA)
	aht(1,:) = aht(0,:) - oht(3,:) ; AHT = RHT (ERBE TOA) - OHT
	aht(2,:) = oht(3,:)            ; OHT
end

