#!/bin/sh
DIAGDIR=`dirname $0` 
. $DIAGDIR/html_util.sh
. $DIAGDIR/conf_util.sh
export DIAGDIR
echo $DIAGDIR

DEV=x11
RUNID=model
CTLID=
FFMT=grd

# switches

LERA15PS=1
LERA15CE=1
LPRCP=1
LLW=1
LNCEPCE=1
LNCEPPS=1
LNCEPVEC=1
LERBE=1
LISCCPFD=1
LCLDAMT=1
LHADISST=0
LYZ=1
LTY=1
LTR=1
LWEB=1

# define dset id

PRCPIDS="XIEARKIN GPCP TRMM"

# define plot id

ERA15PSIDS="Z500 U50"
ERA15CEIDS="TTRP EVAP T850 T200 Z500 Z300 U200"
LWIDS="T2"
#NCEPCEIDS="SFCG SENS SLP"
NCEPCEIDS="SENS SLP"
NCEPVECIDS="TAUXY UV10"
ERBEIDS="OSR OLR"
ISCCPFDIDS="SSRD SLRD SSR SLR"
YZIDS="UYZ TYZ QYZ OMGYZ"
TYIDS="U200 V200"

# define paths
RUNDIR=/Volumes/LaCie/diag/$RUNID
GEORUN=/Volumes/Lacie/research/Models/afes/data/geo/T119
CTLDIR=/Volumes/LaCie/diag/$CTLID
GEOCTL=/Volumes/Lacie/research/Models/afes/data/geo/T119
OBSDIR=/Volumes/LaCie/diag/obs_data
WEBDIR=/Volumes/LaCie/diag/$RUNID/web
PDFDIR=/Volumes/LaCie/diag/$RUNID/pdf

NCARG_ROOT=/usr/local/ncl
CONVERT="/opt/local/bin/convert -trim -density 128x128"

# --- do not edit below
export NCARG_ROOT
NCL=$NCARG_ROOT/bin/ncl
PLOTXY=$DIAGDIR/plot_xy.ncl
PLOTYZ=$DIAGDIR/plot_yz.ncl
PLOTTY=$DIAGDIR/plot_ty.ncl
PLOTTR=$DIAGDIR/plot_tr.ncl

# define season id

ANN=0
MAM=1
JJA=2
SON=3
DJF=4
MON=5

LSEASONAL=True

# implied heat transports

if [[ $LTR -eq 1 ]]; then
	DSET=ANNUAL_TRANSPORTS_1985_1989
	echo $DSET 
	TIME=$ANN
	PLOTID=HT
	echo $PLOTID
	makeconf
	$NCL $PLOTTR
fi

# pressure surface plots

# ERA polar

if [[ $LERA15PS -eq 1 ]]; then
    DSET=ECMWF
    echo $DSET $ERA15PSIDS
    for PLID in $ERA15PSIDS; do
        echo $PLID
        for TIME in $ANN $JJA $DJF; do
            PLOTID=${PLID}NH
            makeconf
            setpolar NH 20 90
            $NCL $PLOTXY > /dev/null
            PLOTID=${PLID}SH
            makeconf
            setpolar SH -90 -20
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# ERA lat-lon

if [[ $LERA15CE -eq 1 ]]; then
    DSET=ECMWF
    echo $DSET $ERA15CEIDS
    for PLOTID in $ERA15CEIDS; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            if [[ $PLOTID == "TTRP" ]]; then
                settrop
                setmin
            fi
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# Legates & Willmott

if [[ $LLW -eq 1 ]]; then
    DSET=LEGATES
    echo $DSET $LWIDS
    for PLOTID in $LWIDS; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# NCEP lat-lon

if [[ $LNCEPCE -eq 1 ]]; then
    DSET=NCEP
    echo $DSET
    for PLOTID in $NCEPCEIDS; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
          makeconf
              $NCL $PLOTXY > /dev/null 
        done
    done
fi

# NCEP vector lat-lon

if [[ $LNCEPVEC -eq 1 ]]; then
    DSET=NCEP
    echo $DSET
    for PLOTID in $NCEPVECIDS; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            setvec
            $NCL $PLOTXY > /dev/null 
        done
    done
fi

# NCEP SLP polar

if [[ $LNCEPPS -eq 1 ]]; then
    DSET=NCEP
    echo $DSET SLP
    for TIME in $ANN $JJA $DJF; do
    PLOTID=SLPNH
    makeconf
    setpolar NH 20 90
        $NCL $PLOTXY > /dev/null
    PLOTID=SLPSH
    makeconf
    setpolar SH -90 -20
        $NCL $PLOTXY > /dev/null 
    done
fi

# PRCP lat-lon

if [[ $LPRCP -eq 1 ]]; then
    for DSET in $PRCPIDS; do
        PLOTID=PRCP_$DSET
        echo $DSET
        for TIME in $ANN $JJA $DJF; do
            makeconf
            if [[ $DSET == "TRMM" ]]; then
                settrop
            fi
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# ERBE lat-lon

if [[ $LERBE -eq 1 ]]; then
    DSET=ERBE
    echo $DSET
    for PLOTID in $ERBEIDS; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# ISCCP FD

if [[ $LISCCPFD -eq 1 ]]; then
    DSET=ISCCPFD
    echo $DSET
    for PLOTID in $ISCCPFDIDS; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# CLDAMT

if [[ $LCLDAMT -eq 1 ]]; then
    DSET=ISCCP
    echo $DSET
    for PLOTID in CCOVER; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# HadISST

if [[ $LHADISST -eq 1 ]]; then
    DSET=HadISST
    echo $DSET
    for PLOTID in SST; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            $NCL $PLOTXY > /dev/null
        done
    done
fi

# ERA lat-pres

if [[ $LYZ -eq 1 ]]; then
    DSET=ECMWF
    echo $DSET $YZIDS

    for PLOTID in $YZIDS; do
        echo $PLOTID
        for TIME in $ANN $JJA $DJF; do
            makeconf
            $NCL $PLOTYZ > /dev/null
        done
    done
fi

if [[ $LTY -eq 1 ]]; then
    LSEASONAL=False
    DSET=ECMWF
    echo $DSET $TYIDS
    for PLOTID in $TYIDS; do
        echo $PLOTID
    makeconf
      $NCL $PLOTTY > /dev/null
    done

# GPCP

    DSET=GPCP
    PLOTID=PRCP
      echo $DSET PRCP
    makeconf
    $NCL $PLOTTY > /dev/null
fi

#
# HTML
#

if [[ $LWEB -eq 1 ]]; then
    if [[ ! -d $WEBDIR ]]; then
        mkdir $WEBDIR
    fi
    if [[ ! -d $PDFDIR ]]; then
        mkdir $PDFDIR
    fi

# create HTML

    export HTML="$WEBDIR/index.html"
    html_header $RUNID 

    html_dataset "GPCP 1979-2002"
    html_row_begin PRCP
        html_entry "${RUNID}_PRCP_GPCP_DJF.png" DJF
        html_entry "${RUNID}_PRCP_GPCP_JJA.png" JJA
        html_entry "${RUNID}_PRCP_GPCP_ANN.png" ANN
    html_row_end
    html_dataset "CMAP (Xie and Arkin) 1979-1998"
    html_row_begin PRCP
        html_entry "${RUNID}_PRCP_XIEARKIN_DJF.png" DJF
        html_entry "${RUNID}_PRCP_XIEARKIN_JJA.png" JJA
        html_entry "${RUNID}_PRCP_XIEARKIN_ANN.png" ANN
    html_row_end
    html_dataset "TRMM (3B-43) Jan 1998-Aug 2003"
    html_row_begin PRCP
        html_entry "${RUNID}_PRCP_TRMM_DJF.png" DJF
        html_entry "${RUNID}_PRCP_TRMM_JJA.png" JJA
        html_entry "${RUNID}_PRCP_TRMM_ANN.png" ANN

    html_dataset "Legates & Willmott 1920-80"
    for PLOTID in $LWIDS; do
        html_row_begin ${PLOTID}
            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
        html_row_end
    done

    html_dataset "NCEP 1979-98"
    for HM in NH SH; do
        html_row_begin SLP${HM}
            html_entry "${RUNID}_SLP${HM}_DJF.png" DJF
            html_entry "${RUNID}_SLP${HM}_JJA.png" JJA
            html_entry "${RUNID}_SLP${HM}_ANN.png" ANN
        html_row_end
    done
    for PLOTID in $NCEPCEIDS $NCEPVECIDS; do
        html_row_begin ${PLOTID}
            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
        html_row_end
    done

    html_dataset "ERA 1979-93 polar"
    for PLOTID in $ERA15PSIDS; do
        for HM in NH SH; do
            html_row_begin ${PLOTID}${HM}
                html_entry "${RUNID}_${PLOTID}${HM}_DJF.png" DJF
                html_entry "${RUNID}_${PLOTID}${HM}_JJA.png" JJA
                html_entry "${RUNID}_${PLOTID}${HM}_ANN.png" ANN
            html_row_end
        done
    done

    html_dataset "ERA 1979-93 lat-lon"
    for PLOTID in $ERA15CEIDS; do
        html_row_begin ${PLOTID}
            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
        html_row_end
    done

    html_dataset "ERBE Feb1985-Apr1989 lat-lon"
    for PLOTID in $ERBEIDS; do
        html_row_begin ${PLOTID} 
            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
        html_row_end
    done

    html_dataset "ISCCP FD Jul1983-Dec2000"
    for PLOTID in $ISCCPFDIDS; do
        html_row_begin ${PLOTID}
            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
        html_row_end
    done

    html_dataset "ISCCP D2 Jul 1983-Sep 2001"
    for PLOTID in CCOVER; do
        html_row_begin ${PLOTID}
            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
        html_row_end
    done

#    html_dataset "HadISST/OI.v2 1982-2001"
#    for PLOTID in SST; do
#        html_row_begin ${PLOTID}
#            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
#            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
#            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
#        html_row_end
#    done

    html_dataset "ERA 1979-93 lat-pres"
    for PLOTID in $YZIDS; do
        html_row_begin ${PLOTID}
            html_entry "${RUNID}_${PLOTID}_DJF.png" DJF
            html_entry "${RUNID}_${PLOTID}_JJA.png" JJA
            html_entry "${RUNID}_${PLOTID}_ANN.png" ANN
        html_row_end
    done

    html_dataset "ERA 1979-93 time-lat"
    for PLOTID in $TYIDS; do
        html_row_begin ${PLOTID}
            html_entry "${RUNID}_${PLOTID}_ANC.png" ANC
        html_row_end
    done

    html_dataset "GPCP 1979-2002 time-lat"
    html_row_begin PRCP
        html_entry "${RUNID}_PRCP_ANC.png" ANC
    html_row_end

    html_dataset "NCEP derived heat transport"
    html_row_begin "HT"
      html_entry "{RUNID}_OHT_ANN.png" OHT
      html_entry "{RUNID}_AHT_ANN.png" AHT
    html_row_end

    html_footer

# convert

    for ITEM in `ls *.pdf`; do
        echo converting $ITEM to $WEBDIR/${ITEM%pdf}png
        $CONVERT $ITEM $WEBDIR/${ITEM%pdf}png
    done
    mv -f *.pdf $PDFDIR/
fi

