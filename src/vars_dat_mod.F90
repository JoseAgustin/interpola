!
!    vars_dat_mod.f90
!
!	Created by Agustin Garcia on 28/08/2012.
!
!****************************************************************************
!
!>	@brief
!>	Set up variables used during the process.
!>   @author  Jose Agustin Garcia Reynoso
!>  @date  28-08-2012
!****************************************************************************
!> @par Emissions Inventories Variables
!> @param nh Number of hours during the day
module vars_dat
integer,parameter :: nh =24
!> Number of dimension in wrfinput file
integer:: NDIMS!=6
!> Number of emissions layers  (1 to 8)
integer :: zlev
!> number of emissions classes
integer :: radm=0
!> emissions input file dimensions @c nx, @c ny,@c level, @c nh, @c radm
real,allocatable:: ei(:,:,:,:,:)
!> emissions in new DOMAIN file dimensions @c nx, @c ny,@c level, @c nh, @c radm
real,allocatable:: ed(:,:,:,:,:)
!> Latitudes from input file emissions
real,allocatable:: elat(:,:)
!> Longitudes from input file emissions
real,allocatable:: elon(:,:)
!> Density population from input file emissions
real,allocatable:: epob(:,:)
!> Latitudes in new domain @c nx, @c ny from new domain @c ed
real,allocatable:: dlat(:,:)
!> Longitudes in new domain @c nx, @c ny from new domain @c ed
real,allocatable:: dlon(:,:)
!> Density population in new domain @c nx, @c ny from new domain @c ed
real,allocatable:: dpob(:,:)
!> Longitudes in emissions domain @c nx, @c ny
real,allocatable ::xlon(:,:,:)
!> Longitudes staged in emissions domain @c nxs, @c ny
real,allocatable ::xlons(:,:,:)
!> Latitudes in emissions domain @c nx, @c ny
real,allocatable :: xlat(:,:,:)
!> Latitudes staged in emissions domain @c nx, @c nys
real,allocatable :: xlats(:,:,:)
!> Number of values in longitude in new file
integer :: dix
!> Number of values in latitude in new file
integer :: djx
!> Number of values in longitude in emissions file
integer :: eix
!> Number of values in latitude in emissions file
integer :: ejx
!> Domain number (d01, d02, etc.) from wrfinput
integer :: grid_id
!> Julian year in emissions file
integer:: julyr
!> Julian day in emissions file
integer:: julday
!> Map projection type
integer:: mapproj
!> Value for land use water
integer:: iswater
!> Value for land use lake
integer:: islake
!> Value for land use ice
integer:: isice
!> Value for land use urban
integer :: isurban
!> Value for land use ice
integer:: isoilwater
!> ID unlimit variable (time)
integer:: unlimdimid
!> Central latitude
real :: cenlat
!> Central longitude
real :: cenlon
!> Grid dimension in m output file @a x
real :: dx
!> Grid dimension in m output file @a y
real :: dy
!> Grid dimension in m emissions file @a x
real :: dxe
!> Grid dimension in m emissions file @a y
real :: dye
!> True latitud lower
real :: trulat1
!> True latitud higer
real :: trulat2
!> Mother of all domains center latitude
real :: moadcenlat
!>  Standard longitude
real :: stdlon
!> The pole latitude.
real :: pollat
!> The pole longitude.
real :: pollon
!> GMT time
real :: gmt
!> Number of land categories
real:: num_land_cat
!> Day type (lun, mar, mie, jue, vie, sab, dom)
character(len=3) :: cday
!> Land use input description
character(len=19)::mminlu
!> Map projection description
character(len=19):: map_proj_char
!> Counter for time in file
character(len=19):: iTime
!> Title description input/output files for V4 should have V4.0
character(len=38):: Title
!> Start date in input emissions file
character(len=19),dimension(1,1)::Times
!> Current date in input emissions file
character (len=19) :: current_date
!> Chemical mechanism name
character (len=19) :: mecha
!> Vector of dimensions descriptions
character (len=19),allocatable::sdim(:)
!> Emissions description long
character(len=11),allocatable ::ename(:)
!> Emissions name variable short
character(len=50),allocatable ::cname(:)
!> Units in emissions vars
character(len=50),allocatable ::cunits(:)
!> true if input var is an emissions variable
logical,allocatable :: tvar(:)
!> true if input emissions files contains density population
logical :: tpob
! Domain Variables
common /domain/ zlev, dix,djx,eix,ejx,dx,dy,dxe,dye,rama,Title
common /date/ id_grid,unlimdimid,Times,current_date,cday,mecha,tpob
common /wrf/ julyr,julday,mapproj,iswater,islake,isice,isurban,isoilwater,&
            cenlat,cenlon,trulat1, trulat2,moadcenlat,stdlon,pollat,pollon,&
            gmt,mminlu
end module vars_dat
