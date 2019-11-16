#!/bin/sh

# golfo.sh
#  
#
#  Created by Agustin Garcia on 16/11/2019.
#
echo $PWD
let dian=0
while [ $dian -lt  3 ]
do
export mes=`date -d "$dian days" +%m`
export dia=`date -d "$dian days" +%d`
if [ $dian == 0  ]; then
   export outfile=wrfchemi.d01.RADM2.2019-${mes}-${dia}_00:00:00
   export outfil2=wrfchemi.d01.RADM2.2019-${mes}-${dia}_12:00:00
   echo $outfile
fi
ln -sf /LUSTRE/OPERATIVO/modelos/WRF-CHEM/DOMAINS/golfo/wrfprd/wrfinput_d01 wrfinput
ln -sf /LUSTRE/OPERATIVO/modelos/WRF-CHEM/Emiss_mexico/10_storage/$outfile wrfchemin.nc
ln -sf /LUSTRE/OPERATIVO/modelos/WRF-CHEM/DOMAINS/golfo/wrfprd/wrfchemi_00z_d01 wrfchemi_00z_d01
./interpola.exe
ln -sf /LUSTRE/OPERATIVO/modelos/WRF-CHEM/DOMAINS/golfo/wrfprd/wrfinput_d01 wrfinput
ln -sf /LUSTRE/OPERATIVO/modelos/WRF-CHEM/Emiss_mexico/10_storage/$outfil2 wrfchemin.nc
ln -sf /LUSTRE/OPERATIVO/modelos/WRF-CHEM/DOMAINS/golfo/wrfprd/wrfchemi_12z_d01 wrfchemi_12z_d01
./interpola.exe
dian=$[$dian+1]
done
echo $outfile
echo "DONE  interpola Golfo"

