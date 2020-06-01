!
!    vars_dat_mod.f90
!
!	Created by Agustin Garcia on 28/08/2012.
!
!****************************************************************************
!
!  FUNCTIONS:
!	Set up variables used during the process.
!
!
!****************************************************************************

module vars_dat
! Emissions Inventories Variables
integer,parameter :: nh =24
integer:: NDIMS!=6
integer :: zlev   ! Layer of emission (1 to 8)
integer :: radm=0   ! number of emissions classes
real,allocatable:: ei(:,:,:,:,:)  ! emissions by nx,ny,level,nh,radm
real,allocatable:: ed(:,:,:,:,:)  ! emissions by nx,ny,level,nh,radm from NEW DOMAIN
real,allocatable:: elat(:,:),elon(:,:),epob(:,:)! by nx,ny from emissions domain
real,allocatable:: dlat(:,:),dlon(:,:),dpob(:,:)! by nx,ny from NEW DOMAIN
real,allocatable ::xlon(:,:,:),xlat(:,:,:)! by nx,ny,nh emissions
integer:: dix,djx,eix,ejx,grid_id
integer:: julyr,julday,mapproj,iswater,islake,isice,isurban,isoilwater
integer:: unlimdimid
real :: cenlat,cenlon, dx,dy,dxe,dye
real :: trulat1, trulat2,moadcenlat,stdlon,pollat,pollon
real :: gmt,num_land_cat
character(len=3) :: cday
character(len=19)::mminlu,map_proj_char
character(len=19):: iTime
character(len=38):: Title
character(len=19),dimension(1,1)::Times
character (len=19) :: current_date,mecha
character (len=19),allocatable::sdim(:)
character(len=11),allocatable ::ename(:)
character(len=50),allocatable ::cname(:),cunits(:)
logical,allocatable :: tvar(:)
logical :: tpob
! Domain Variables
common /domain/ zlev, dix,djx,eix,ejx,dx,dy,dxe,dye,rama,Title
common /date/ id_grid,unlimdimid,Times,current_date,cday,mecha,tpob
common /wrf/ julyr,julday,mapproj,iswater,islake,isice,isurban,isoilwater,&
            cenlat,cenlon,trulat1, trulat2,moadcenlat,stdlon,pollat,pollon,&
            gmt,mminlu
end module vars_dat
