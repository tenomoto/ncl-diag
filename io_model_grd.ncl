load "$HOME/local/lib/ncarg/nclscripts/grads/grads.ncl"
load "$DIAGDIR/dict_model.ncl"
undef("read_model")
undef("read_model_ty")
undef("calc_model")

levfact_model = 100
ext = ".ctl"

function read_model(fname:string, v:string, t:integer, lseasonal:logical)
local f
begin
		setfileoption("bin","ReadByteOrder","BigEndian")
    f = grads_addfile(fname)
    if (lseasonal) then
      if (t.eq.0) then
              d = grads_read(f, v, 0)
        do i=1, 11
          d = d + grads_read(f,v,i)
        end do
        d = d/12
      else
        if (t.eq.4) then ; DJF
          d = grads_read(f,v,11)
                  d = grads_read(f, v, 11)
          d = (/ (d + grads_read(f,v,0) + grads_read(f,v,1))/3 /)
        else
          d = grads_read(f,v,3*t-1)
          d = (/ (d + grads_read(f,v,3*t) + grads_read(f,v,3*t+1))/3 /)
        end if
      end if
    else
      d = grads_read(f,v,t)
    end if
    d = scale@$v$ * d
      d@_FillValue = f@undef
    return d
    delete(f)
end

function read_model_ty(fname:string, v:string, l:integer)
local nt, buf
begin
    nt = 12
    f = grads_addfile(fname)
    d = new((/nt, dimsizes(f@lat)/), "float")
    d!0 = "time"
    d!1 = "lat"
    d&lat = f@lat
    d&time = ispan(1, 12, 1)
    d@_FillValue = f@undef
    do t=0, nt-1
        buf = grads_read(f,v,t)
      if (l.eq.0) then
        d(t,:) = (/ dim_avg(buf) /)
      else
        d(t,:) = (/ dim_avg(buf({l*levfact_model},:,:)) /)
      end if
    end do
    d = scale@$v$ * d
    return d
end

function calc_model(datadir:string,varname:string,time:integer,lseasonal:logical)
begin
	if (varname.eq."RT") then
		fname = datadir+"/"+"OSR"+ext
		rt = read_model(fname, "OSR", time, lseasonal); reads -OSR
		fname = datadir+"/"+"OLR"+ext
		rt = (/rt-read_model(fname, "OLR", time, lseasonal)/)
		return rt
	end if
	if (varname.eq."FS") then
		fname = datadir+"/"+"SSR"+ext
		fs = read_model(fname, "SSR", time, lseasonal); reads -SSR
		fname = datadir+"/"+"SLR"+ext
		fs = (/-fs+read_model(fname, "SLR", time, lseasonal)/)
		fname = datadir+"/"+"EVAP"+ext
		fs = (/fs+read_model(fname, "EVAP", time, lseasonal)/)
		fname = datadir+"/"+"SENS"+ext
		fs = (/fs+read_model(fname, "SENS", time, lseasonal)/)
		return fs
	end if
	if (varname.eq."RTFS") then
		fname = datadir+"/"+"OSR"+ext
		rtfs = read_model(fname, "OSR", time, lseasonal); reads -OSR
		fname = datadir+"/"+"OLR"+ext
		rtfs = (/rtfs-read_model(fname, "OLR", time, lseasonal)/)
		fname = datadir+"/"+"SSR"+ext
		rtfs = (/rtfs-read_model(fname, "SSR", time, lseasonal)/); reads -SSR
		fname = datadir+"/"+"SLR"+ext
		rtfs = (/rtfs+read_model(fname, "SLR", time, lseasonal)/)
		fname = datadir+"/"+"EVAP"+ext
		rtfs = (/rtfs+read_model(fname, "EVAP", time, lseasonal)/)
		fname = datadir+"/"+"SENS"+ext
		rtfs = (/rtfs+read_model(fname, "SENS", time, lseasonal)/)
		return rtfs
	end if
	fname = datadir+"/"+varname+ext
	return read_model(fname, varname, time, lseasonal)
end
