#   generates configuration file for NCL
makeconf() {
# Arguments
  cat > conf.ncl << EOF
load "$DIAGDIR/io_model_$FFMT.ncl"
dev = "$DEV"
plotid = "$PLOTID"
runid = "$RUNID"
obsid = "$DSET"
ctlid = "$CTLID"
rundir = "$RUNDIR"
obsdir = "$OBSDIR"
ctldir = "$CTLDIR"
georun = "$GEORUN"
geoctl = "$GEOCTL"
color = "amwg"
time = $TIME
lseasonal = $LSEASONAL
EOF
}

setpolar() {
# required for xy plots
# Arguments
#   1: flag to be set True for polar stereo plots
# 2,3: latitudes to be plotted
    cat >> conf.ncl << EOF
hemisphere = "$1"
minlat = $2
maxlat = $3
EOF
}

setvec() {
    cat >> conf.ncl << EOF
lvec = True
EOF
}

settrop() {
    cat >> conf.ncl << EOF
ltrop = True
EOF
}

setmin() {
    cat >> conf.ncl << EOF
lmin = True
EOF
}
