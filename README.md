## Interpola
Emission Interpolation to a new mesh by using a conservative flux method

The new mesh is provided by the wrfinput file and the original grid with emissions are provided from wrfchem file

input files:

            wrfchemin.nc  ! A 12 hours emission file to be interpolated (0 to 11 hour or 12 to 23 hour)
            wrfinput      ! Domain where emissions will be interpolated can be a ge_em.d0?.nc file but the name should be wrfinput. 

output file:

            wrfchemi_00z_d01 or wrfchemi_12z_d01 ! 00z or 12z based on emissions file. 
                                                 ! d01, d02,... and date based on wrfinput
                                                 ! for ge_em.d0?.nc the dates are provided from wrfchemin.nc
            
wrfchemin.nc - file contain emissions starting with "E_" 

![Area to interpolate emissions](/assets/images/domain2int.png "Terrain and domain to interpolate")

![Source emissions](/assets/images/input_wrfchem.png "Emissions domain")

![Emissions result](/assets/images/output.png "Emissions in new domain")

## Mass conservative interpolation in overlaping grids
Emissions Inventories are generatred for represent global, regional or local emissions, air quality models domains are displayed in a different grid (dimensions and location) than the emissions. On other hand, emissions are a flux and it is necesary to use a mass conservative interpolation in order to avoid inconsistencies in the emissions. An example of overlaping grids is presented in the followgin figure.

![Grids overlaped](/assets/images/malla1.png "Modeling domain and emissions domain")

Grid with letters represents the new domain (it has coordinates dlat,dlon) and grid with numbers is the emissions (it has coordinates elat,elon). For N emission there are N+1 coordinates in each axis. The following figure presents the locations of the coordinates in each mesh.

![Grids overlaped with coordinates](/assets/images/malla2.png "Modeling domain (dlat,dlon) and emissions domain (elat,elon)")

For the new domain to interpolate the emissions the following variables are set (when usign coordinates centred in the cell):
 
 |  New domain   |   Emissions domain     |
 |--- | ---|
 | `ylat1=0.5*(dlat(i,j-1)+dlat(i,j))` | `elat1= 0.5*(elat(ii,jj)+elat(ii,jj-1))` |
 | `ylat2=0.5*(dlat(i,j+1)+dlat(i,j))` | `elat2= 0.5*(elat(ii,jj)+elat(ii,jj+1))` |
 | `xlon1=0.5*(dlon(i-1,j)+dlon(i,j))` | `elon1= 0.5*(elon(ii,jj)+elon(ii-1,jj))` |
 | `xlon2=0.5*(dlon(i+1,j)+dlon(i,j))` | `elon2= 0.5*(elon(ii,jj)+elon(ii+1,jj))` |

 the following figure presents the locations of the coordinates in each mesh.

The following procedure is followed for obtainig the new emissions in the new grid:

            alat=(min(ylat2,elat2)-max(ylat1,elat1))
            alon=(min(xlon2,elon2)-max(xlon1,elon1))
            area=max(0.,alat*alon)

![Computation](/assets/images/mallado.gif "Emissions domain asignation")


Emissions in cell **A** are a flux emission fraction from 1, for **B** a flux  fractions from 1 and 2, and for **C** fluxes from 2, 3 and 4 (not show here), **F** fluxes from 1 and 6, **G** from 1, 2, 6 and 7 and **H** from 2, 3, 4, 7, 8 and 9, and so on.
