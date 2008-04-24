load "$DIAGDIR/io_model_grd.ncl"
load "./conf.ncl"
undef("read_geo")

function read_geo(geodir:string)
; 0: ocean, 1: land, 2: sea ice (not used)
begin
	geofname = geodir+"/"+"Grads.ctl"
	geo = read_model(geofname,"IDSRF",0,False)
	geo = geo < 1
	return geo
end
