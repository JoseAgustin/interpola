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
real,allocatable:: elat(:,:),elon(:,:)     ! by nx,ny from emissions domain
real,allocatable:: dlat(:,:),dlon(:,:)     ! by nx,ny from NEW DOMAIN
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
! Domain Variables
common /domain/ zlev, dix,djx,eix,ejx,dx,dy,dxe,dye,rama,Title
common /date/ id_grid,unlimdimid,Times,current_date,cday,mecha
common /wrf/ julyr,julday,mapproj,iswater,islake,isice,isurban,isoilwater,&
            cenlat,cenlon,trulat1, trulat2,moadcenlat,stdlon,pollat,pollon,&
            gmt,mminlu
end module vars_dat

!character (len=19),dimension(NDIMS) ::sdim=(/"Time               ",&
!& "DateStrLen         ","west_east          ","south_north        ",&
!&"bottom_top         ","emissions_zdim_stag"/)

!character(len=11),dimension(radm):: ename=(/'E_CO       ','E_NH3      ',&
!  'E_NO       ','E_SO2      ','E_ALD      ','E_CH4      ','E_CSL      ',&
!  'E_ETH      ','E_GLY      ','E_HC3      ','E_HC5      ','E_HC8      ',&
!  'E_HCHO     ','E_ISO      ','E_KET      ','E_MACR     ','E_MGLY     ',&
!  'E_MVK      ','E_OL2      ','E_OLI      ','E_OLT      ','E_ORA1     ',&
!  'E_ORA2     ','E_TOL      ','E_XYL      ','E_PM_10    ','E_PM25     ',&
!  'E_SO4I     ','E_NO3I     ','E_PM25I    ','E_ORGI     ','E_ECI      ',&
!  'E_SO4J     ','E_NO3J     ','E_PM25J    ','E_ORGJ     ','E_ECJ      ',&
!  'EBIO_ISO   ','EBIO_C10H16','EBIO_NO    ','EBIO_NOx   ','EBIO_OTHER '/)
!character(len= 16),dimension(radm):: cname=(/'Carbon Monoxide ',&
!'NH3             ','NO              ','SO2             ',&
!'ALDEHYDES       ','METHANE         ','CRESOL          ','Ethane          ',&
!'Glyoxal         ','HC3             ','HC5             ','HC8             ',&
!'HCHO            ','ISOPRENE        ','Acetone         ','Acrolein        ',&
!'MGLY            ','Methyl Vinil Ket','Alkenes         ','alkenes         ',&
!'Terminal Alkynes','Formic Acid     ','Acetic Acid     ','TOLUENE         ',&
!'XYLENE          ','PM_10           ','PM_25           ',&
!'Sulfates        ','Nitrates        ','PM25I           ','Organic         ',&
!'Elemental Carbon','SulfatesJ       ','NitratesJ       ','PM25J           ',&
!'Organic         ','Elemental Carbon','biog isoprene   ','biog monoterpene',&
!'biog NO         ','biog NOx        ','biog other VOCs '/)
