!>   @brief test subroutine guarda
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 08/29/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
program test_guarda
    use vars_dat
    use netcdf
    implicit none
    integer ::istatus =0
    integer :: i
    character(len=32):: arg
    do i = 1, iargc()
       call getarg(i, arg)
       if(arg .eq."--version") print *,"1.0"
    end do

    call settingvars

    call File_out

  contains
subroutine settingvars()
  implicit none
  integer:: ih,ikk,i,j,l
  NDIMS=6
  current_date="2020-08-28_00:00:00"
  iTime=current_date
  grid_id=1
  allocate(dim(6),sdim(6))
  L_CO=1
  djx=6
  dix=6
  dx=5
  dy=5
  zlev =2
  nvars=2
  tpob=.false.
  allocate(tvar(nvars),ename(nvars),cname(nvars),cunits(nvars))
  tvar=.true.
  ename=(/"E_CO ","E_SO2"/)
  cname=(/"Monoxido de Carbono","Dioxido de azufre  "/)
  cunits=(/"ppm","ppb"/)
  dim=(/12,19,dix,djx,2,zlev/)
  sdim=(/'Time               ','DateStrLen         ','west_east          ',&
         'south_north        ','bottom_top         ','emissions_zdim_stag'/)
  allocate(dlat(dix,djx+1),dlon(dix+1,djx))
  allocate (ed(dix,djx,zlev,12,nvars))
  allocate(xlat(dix,djx,1),xlon(dix,djx,1),dpob(dix,djx))
  !allocate(ed(dim(3),dim(4),dim(6),dim(1),nvars))
  TITLE="TEST guarda v4.0"
  cday="Thu"
  trulat1=17.5
  trulat2=29.5
  do i=1,dix
    do j=1,djx
      xlat(i,j,1)=19.00 +(j-1)*dy/100.
      xlon(i,j,1)=-99.30 +(i-1)*dx/100.
      do ih=1,12
        do ikk=1,nvars
          do l=1,zlev
            ed(i,j,l,ih,ikk)=ikk*100500.*cos((i+j-4)/6.283)*sin((i+j)/6.28303)
          end do
        end do
      end do
    end do
  end do
  cenlat=xlat(dix/2,djx/2,1)
  cenlon=xlon(dix/2,djx/2,1)
  moadcenlat=cenlat
  stdlon=cenlon
  pollat=90.
  pollon=0.
  GMT=0
  JULYR=2020
  JULDAY=241
  mapproj=1
  mminlu="USGS"
  map_proj_char = "Lambert Conformal"
  ISWATER = 16
	ISLAKE = -1
	ISICE = 24
	ISURBAN = 1
  NUM_LAND_CAT = 24
  ISOILWATER = 14
  mecha="TEST_mechanism"
end subroutine
end program test_guarda
