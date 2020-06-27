## Interpola
Emission Interpolation to a new mesh by using a conservative flux method

Based on the wrfinput and wrfchem emissions inventory

input files:

            wrfchemin.nc  ! A 12 hours emission file to be interpolated (0 to 11 hour or 12 to 23 hour)
            wrfinput      ! Domain where emissions will be interpolated

output file:

            wrfchemi_00z_d01 or wrfchemi_12z_d01 ! 00z or 12z based on emissions file. 
                                                 ! d01, d02,... based on wrfinput
            
wrfchemin.nc - file contain emissions starting with "E_" 

![Area to interpolate emissions](/assets/images/domain2int.png "Terrain and domain to interpolate")

![Source emissions](/assets/images/input_wrfchem.png "Emissions domain")

![Emissions result](/assets/images/output.png "Emissions in new domain")

