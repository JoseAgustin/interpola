!
!    vars_dat_mod.f90
!
!	Created by Agustin Garcia on 28/08/2012.
!
!****************************************************************************
!
!>   @brief
!>	Set up variables for the mass conservative interpolation process.
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 07/01/2020
!>   @version  3.1
!>   @copyright Universidad Nacional Autonoma de Mexico.
!****************************************************************************
!> @par Emissions Inventories Variables
module vars_dat
!> nh Number of hours during the day
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
!> Dimensions in emissions domain @c nx, @c nys
integer,ALLOCATABLE:: dim(:)
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
integer :: unlimdimid
!> number of emissions variables in wrfchemin file
integer :: nvars
!> Index of E_CO emission
integer :: L_CO
!> Central latitude new grid
real :: cenlat
!> Central longitude new grid
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

contains
!>   @brief Compara los valores para los maximos
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  03/06/2020
!>   @version  1.0
!>   @param indice indice del arreglo se usa si se cumple
!>   @param indx es el valor inicial del indice y se substituye por indice si se cumple la condicion
!>   @param  eval  valor a comparar entre dval1 y dval2
!>   @param  dval1  valor inferior del arreglo
!>   @param  dval2  valor superior del arreglo
!>   @param  maximo  verdadero para maximos, falso para minimos
!   ___ ___  _ __ ___  _ __   __ _ _ __ __ _
!  / __/ _ \| '_ ` _ \| '_ \ / _` | '__/ _` |
! | (_| (_) | | | | | | |_) | (_| | | | (_| |
!  \___\___/|_| |_| |_| .__/ \__,_|_|  \__,_|
!                     |_|
function compara(indice,indx,eval,dval1,dval2,maximo) result(val)
    integer           :: val
    integer,intent(in):: indice,indx
    real,   intent(in):: eval,dval1,dval2
    logical,intent(in):: maximo
    val=indx
  if (dval1 .le. eval.and.eval.le.dval2) then
    if (maximo) then
      val=max(indice,indx)
    else
      val=min(indice,indx)
    end if
  end if
end function compara
!>   @brief Obtiene los valores de los indices de la coordenada
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  03/06/2020
!>   @version  1.0
!        _     _   _
!   ___ | |__ | |_(_) ___ _ __   ___
!  / _ \| '_ \| __| |/ _ \ '_ \ / _ \
! | (_) | |_) | |_| |  __/ | | |  __/
!  \___/|_.__/ \__|_|\___|_| |_|\___|
!
subroutine obtiene(vmin,vmax,coordenada,numero,inicio,final)
implicit none
!> valor del indice inicial en el arreglo coordenda donde se ubuica vmin
integer,intent(inout):: inicio
!> valor del indice final en el arreglo coordenda donde se ubuica vmax
integer,intent(inout):: final
!> contador
integer :: i
!> valor medio
integer :: medio
!> indice a emplear en el arreglo coordenada 1: lon, 2: lat
integer,intent(IN):: numero
!> vmin valor minimo del arreglo a buscar
real,intent(IN)::vmin
!> vmax valor maximo del arreglo a buscar
real,intent(IN)::vmax
!> arreglo de coordenadas donde se busca el valor
real,intent(IN),dimension(:,:) :: coordenada
!> Identifica si se requiere calcular maximo=true o el minimo=flase
logical :: maximo=.true.,minimo=.false.
    medio=size(coordenada,numero)/2
    do i=1,size(coordenada,numero)-1
      if(numero.eq.1) then
        inicio=compara(i,inicio,vmin,coordenada(i,medio),coordenada(i+1,medio),minimo)
        final= compara(i,final ,vmax,coordenada(i,medio),coordenada(i+1,medio),maximo)
      else
        inicio=compara(i,inicio,vmin,coordenada(medio,i),coordenada(medio,i+1),minimo)
        final =compara(i,final, vmax,coordenada(medio,i),coordenada(medio,i+1),maximo)
      end if
    end do
   if (vmin.le.minval(coordenada).or. inicio.ge.size(coordenada,numero)-1) inicio=1
   if (final.eq.1) final=size(coordenada,numero)-1
   if (final.lt.inicio) inicio=1
end subroutine
end module vars_dat
