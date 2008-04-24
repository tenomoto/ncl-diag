load "$DIAGDIR/dict_model.ncl"
undef("read_model")
undef("read_model_ty")

levfact_model = 100
ext = ".nc"

function read_model(fname:string, v:string, t:integer, lseasonal:logical)
local f, l3d
begin
	f = addfile(fname, "r")
    l3d = False
    if (dimsizes(dimsizes(f->$v$)).eq.4) then
        l3d = True
    end if
	if (lseasonal) then
		if (t.eq.0) then
            if (l3d) then
                d = f->$v$(0,:,:,:)
                do i=1, 11
                    d = d + f->$v$(i,:,:,:)
                end do
            else
                d = f->$v$(0,:,:)
                do i=1, 11
                    d = d + f->$v$(i,:,:)
                end do
            end if
			d = d/12
		else
			if (t.eq.4) then ; DJF
                if (l3d) then
                    d = f->$v$(11,:,:,:)
                    d = (/ (d + f->$v$(0,:,:,:) + f->$v$(1,:,:,:))/3 /)
                else
                    d = f->$v$(11,:,:)
                    d = (/ (d + f->$v$(0,:,:) + f->$v$(1,:,:))/3 /)
                end if
			else
                if (l3d) then
                    d = f->$v$(3*t-1,:,:,:)
                    d = (/ (d + f->$v$(3*t,:,:,:) + f->$v$(3*t+1,:,:,:))/3 /)
                else
                    d = f->$v$(3*t-1,:,:)
                    d = (/ (d + f->$v$(3*t,:,:) + f->$v$(3*t+1,:,:))/3 /)
                end if
			end if
		end if
	else
        if (l3d) then
            d = f->$v$(t,:,:,:)
        else
		    d = f->$v$(t,:,:)
        end if
	end if
	d = scale@$v$ * d
	return d
	delete(f)
end

function read_model_ty(fname:string, v:string, l:integer)
local nt
begin
	nt = 12
	f = addfile(fname, "r")
	d = new((/nt, dimsizes(f->lat)/), "float")
	d!0 = "time"
	d!1 = "lat"
	d&lat = f->lat
	d&time = ispan(1, 12, 1)
	d@long_name = f->$v$@long_name
	d@units = f->$v$@units
	d@_FillValue = f->$v$@_FillValue
	do t=0, nt-1
		if (l.eq.0) then
			d(t,:) = (/ dim_avg(f->$v$(t,:,:)) /)
		else
			d(t,:) = (/ dim_avg(f->$v$(t,{l*levfact_model},:,:)) /)
		end if
	end do
	d = scale@$v$ * d
	return d
end
