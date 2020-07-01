!**********************************************************************
!
!    lee_files.f90
!
!> @brief Reads Emission inventory and the new Mesh to interpolate emissions
!> @details Reads from the emission wrfchemin file the variables and attributes
!> put emissions in @c ei array and coordinates in @c xlat, @c xlon.
!>
!> reads the new mesh from wrfinput, stores the new coordinates @c dlat, @c dlon
!>
!> @author Agustin Garcia
!> @date 28/08/2012.
!>   @version  2.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
!***************************************************************************
subroutine file_reading
!$  use omp_lib
    use vars_dat
    use netcdf
    implicit none

! This is the name of the data file to read
character (len = *), parameter :: FILE_NAME = "wrfchemin.nc" !Inventory
integer :: i,j,l,it,ikk
integer :: ncid,nvars,xtype
integer :: lat_varid,lon_varid,btDimID
integer :: lat_varid_stag,lon_varid_stag
integer :: latVarId, lonVarId
integer :: pobId
integer :: land_catID
integer :: dimlon,dimlat,dimtime
integer :: dimlos,dimlas !stagged variables
integer :: nglobalatts,ndimsv=0,dimids(NF90_MAX_VAR_DIMS)
integer,ALLOCATABLE:: id_var(:),dim(:),id_dim(:)
real :: rdx
real,ALLOCATABLE :: ea(:,:,:,:)
character (len= NF90_MAX_NAME ) :: name
character (len = *), parameter :: LAT_NAME = "XLAT"
character (len = *), parameter :: LON_NAME = "XLONG"
character (len = *), parameter :: LAT_STAG = "XLAT_V"
character (len = *), parameter :: LON_STAG = "XLONG_U"
character (len = *), parameter :: REC_NAME = "Times"
character (len = *), parameter :: POB_NAME = "POB"
tpob=.false.
!$omp parallel sections num_threads (2) private(ncid,i,j,ikk,l,it,lat_varid,lon_varid,nvars,XLAT,XLON,dimlon,dimlat,dimtime)
!$omp section
! Open the file.
    print *," *** Reading Emissions file:",FILE_NAME
    call check( nf90_open(FILE_NAME, nf90_nowrite, ncid) )
    call check( nf90_get_att(ncid, nf90_GLOBAL, "TITLE", TITLE))
    call check( nf90_get_att(ncid, NF90_GLOBAL, "START_DATE",current_date))
    call check( nf90_get_att(ncid, NF90_GLOBAL, "DAY",cday))
    call check( nf90_get_att(ncid, nf90_global, "GMT",gmt))
    call check( nf90_get_att(ncid, nf90_global, "JULYR",julyr))
    call check( nf90_get_att(ncid, nf90_global, "JULDAY",julday))
    if(nf90_get_att(ncid, NF90_GLOBAL, "MECHANISM",mecha).ne.nf90_noerr)mecha="UNKNOW"
    print *, "  * Mechanism: ",mecha
! Get the vars ID of the latitude and longitude coordinate variables.
    call check( nf90_inq_varid(ncid, LAT_NAME, lat_varid) )
    call check( nf90_inq_varid(ncid, LON_NAME, lon_varid) )

    if( nf90_inq_varid(ncid, POB_NAME, pobId).eq.nf90_noerr) then
       print *,"  * Contains Population density variable"
       tpob=.true.
    end if
!  Get dims ID and dimension values
    call check(nf90_inquire(ncid, ndims, nvars, nglobalatts, unlimdimid))
   ! call check( nf90_inq_varid(ncid, REC_NAME, unlimdimid) )
    if(.not.ALLOCATED(id_var)) allocate (id_var(nvars))
    if(.not.ALLOCATED(tvar))   allocate (tvar(nvars))
    if(.not.ALLOCATED(dim))    allocate (dim(ndims))
    if(.not.ALLOCATED(id_dim)) allocate (id_dim(ndims))
    if(.not.ALLOCATED(sdim))   allocate (sdim(ndims))
    tvar=.false.
    call check(nf90_inq_varids(ncid, nvars, id_var))
   ! nf90_inquire_variable(ncid, varid, name=sdim(i))
!  Get dimension values from id_dim
    do i=1,NDIMS
      id_dim(i)=i
      call check(nf90_inquire_dimension(ncid,id_dim(i),name=sdim(i),len=dim(i)))
    end do
    if(.not.ALLOCATED(XLON)) allocate (XLON(dim(3),dim(4),dim(1)))
    if(.not.ALLOCATED(XLAT)) allocate (XLAT(dim(3),dim(4),dim(1)))
    if(.not.ALLOCATED(elat)) allocate (elat(dim(3),dim(4)+1)) !stagged y
    if(.not.ALLOCATED(elon)) allocate (elon(dim(3)+1,dim(4))) !stagged x
    if(.not.ALLOCATED(ea))   allocate (ea(dim(3),dim(4),dim(6),dim(1)))
!
!   Retrive initial Time
  !  call check(nf90_get_var(ncid, unlimdimid, Times,start = (/ 1, 1 /)))
  !  current_date(1:19)=Times(1,1)
    print *,current_date!,lat_varid,lon_varid
    if (tpob) then
      print *,"* Get Population values"
      if(.not.ALLOCATED(epob)) allocate(epob(dim(3),dim(4)))
      call check(nf90_get_var(ncid, pobId, epob))
    end if
!
!   Get lat and lon values.
    print *,"* Get lat and lon values"
    call check(nf90_get_var(ncid, lat_varid, XLAT))
    call check(nf90_get_var(ncid, lon_varid, XLON,start = (/ 1, 1,1 /)))
!    print *,XLAT(1,1,1),XLAT(1,2,dim(1))
!    print *,XLON(1,1,1),XLON(2,1,1)
    do i=1,dim(3)
        do j=1,dim(4)-1
          rdx=0.5*(XLAT(i,j+1,1)-XLAT(i,j,1))
          elat(i,j)=XLAT(i,j,1)-rdx
          if(j.eq.dim(4)-1) then
            elat(i,j+1)=XLAT(i,j+1,1)-rdx
            elat(i,j+2)=XLAT(i,j+1,1)+rdx
          end if
        end do
    end do
    do j=1,dim(4)
      do i=1,dim(3)-1
          rdx=0.5*(XLON(i+1,j,1)-XLON(i,j,1))
          elon(i,j)=XLON(i,j,1)-rdx
          if(i.eq.dim(3)-1) then
            elon(i+1,j)=XLON(i+1,j,1)-rdx
            elon(i+2,j)=XLON(i+1,j,1)+rdx
          end if
        end do
    end do
!print *,elat(1,1),elat(1,2)
!print *,elon(dim(3),dim(4)),elon(dim(3)+1,dim(4)),XLON(dim(3),dim(4),1)
    if(.not.ALLOCATED(ei)) allocate(ei(dim(3),dim(4),dim(6),dim(1),nvars))
    if(.not.ALLOCATED(ename)) allocate(ename(nvars))
    if(.not.ALLOCATED(cname)) allocate(cname(nvars),cunits(nvars))

!     Get emissions names
    print *,"* Get emissions names and attributes "
    do ikk=1,nvars
    call check(nf90_inquire_variable(ncid,ikk,name))
    ename(ikk)=trim(name)
    if(name(1:2).eq."E_".or.name(1:2).eq."e_") then
        call check( nf90_get_att(ncid, ikk, "description", name))
        cname(ikk)=trim(name)
        call check( nf90_get_att(ncid, ikk, "units", name))
        cunits(ikk)=trim(name)
        tvar(ikk)=.true.
        !print *,cname(ikk)
    end if
    end do
!     Get emissions values
    print *,"* Get emissions values "
    do ikk=1,nvars
      if(tvar(ikk)) then
       ! print *,ikk,ename(ikk),id_var(ikk)
      call check(nf90_get_var(ncid, id_var(ikk),ea,start = (/1,1,1,1/)))
      do i=1, dim(3)
        do j=1, dim(4)
            do l=1,dim(6)
                do it=1,dim(1) !times in file
                ei(i,j,l,it,ikk)=ea(i,j,l,it)
                end do
            end do
        end do
      end do
        end if
    end do
   !print *,MAXVAL(ei)
    call check( nf90_get_att(ncid, nf90_global, "DX", dxe))
    call check( nf90_get_att(ncid, nf90_global, "DY", dye))
    eix= dim(3)
    ejx= dim(4)
    deallocate (XLAT,XLON,ea)
    call check( nf90_close(ncid) )
    print * ,'** Done reading Emissions file'
!$omp section
    print *," "
    print *,'* Start reading wrfinput file'
    call check(nf90_open("wrfinput", NF90_NOWRITE, ncid))
    call check(nf90_inq_dimid(ncid, "south_north", lat_varid))
    call check(nf90_inq_dimid(ncid, "west_east", lon_varid))
    call check( nf90_inq_dimid(ncid, "south_north_stag", lat_varid_stag) )
    call check( nf90_inq_dimid(ncid, "west_east_stag", lon_varid_stag) )
    if (nf90_inq_dimid(ncid, "bottom_top",btDimID).eq.nf90_noerr)then
        print *,'   Dimension bottom_top'
    else
        print *,"   NO dimension bottom_top"
    end if
    if(nf90_inq_dimid(ncid,"land_cat",land_catID).eq.nf90_noerr) then
        print *,'   Dimension land_cat'
    else
        call check(nf90_inq_dimid(ncid,"land_cat_stag",land_catID))
        print *,"   Dimension land_cat_stag"
    end if
    ! Dimensiones
    call check(nf90_inquire_dimension(ncid, lon_varid,name,dimlon))
    !print *,"LON_STAG"
    call check(nf90_inquire_dimension(ncid, lon_varid_stag,name,dimlos))
    !print *,dimlon,name
    call check(nf90_inquire_dimension(ncid, lat_varid,name,dimlat))
    !print *,"LAT_STAG"
    call check(nf90_inquire_dimension(ncid, lat_varid_stag,name,dimlas))
    !print *,dimlat,name
    if(.not.ALLOCATED(XLONS)) allocate(XLONS(dimlos ,dimlat,1))
    if(.not.ALLOCATED(XLATS)) allocate(XLATS(dimlon ,dimlas,1))
    if(.not.ALLOCATED(XLON)) allocate (XLON(dimlon ,dimlat,1))
    if(.not.ALLOCATED(XLAT)) allocate (XLAT(dimlon ,dimlat,1))
    if(.not.ALLOCATED(dlon)) allocate (dlon(dimlos ,dimlat))
    if(.not.ALLOCATED(dlat)) allocate (dlat(dimlon ,dimlas))
    if(.not.ALLOCATED(dpob)) allocate (dpob(dimlon, dimlat))
    if(nf90_inq_varid(ncid, "XLAT", latVarId).eq. nf90_noerr) then
     call check(nf90_get_var(ncid, latVarId,xlat,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
     !print *,"XLAT"
    else
     call check(nf90_inq_varid(ncid, "XLAT_M", latVarId))
     call check(nf90_get_var(ncid, latVarId,xlat,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
     print *,"XLAT_M"
    end if

    if(nf90_inq_varid(ncid, "XLONG", lonVarId).eq. nf90_noerr) then
     call check(nf90_get_var(ncid, lonVarId,xlon,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
     !print *,"XLONG"
    else
     call check(nf90_inq_varid(ncid, "XLONG_M", lonVarId))
     call check(nf90_get_var(ncid, lonVarId,xlon,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
     print *,"XLONG_M"
    end if

    if(nf90_inq_varid(ncid, "XLAT_V", latVarId).eq. nf90_noerr) then
    call check(nf90_get_var(ncid, latVarId,xlats,start=(/1,1,1/),count=(/dimlon,dimlas,1/)))
        print *,"XLAT_V"
    end if
    if(nf90_inq_varid(ncid, "XLONG_U", lonVarId).eq. nf90_noerr) then
    call check(nf90_get_var(ncid, lonVarId,xlons,start=(/1,1,1/),count=(/dimlos,dimlat,1/)))
        print *,"XLONG_U"
    end if

    print *,'*  Reading Global Attribiutes'
    call check( nf90_get_att(ncid, nf90_global, "DX", dx))
    call check( nf90_get_att(ncid, nf90_global, "DY", dy))
    call check( nf90_get_att(ncid, nf90_global, "CEN_LAT",cenlat))
    call check( nf90_get_att(ncid, nf90_global, "CEN_LON",cenlon))
    call check( nf90_get_att(ncid, nf90_global, "TRUELAT1",trulat1))
    call check( nf90_get_att(ncid, nf90_global, "TRUELAT2",trulat2))
    call check( nf90_get_att(ncid, nf90_global, "MOAD_CEN_LAT",moadcenlat))
    call check( nf90_get_att(ncid, nf90_global, "STAND_LON",stdlon))
    call check( nf90_get_att(ncid, nf90_global, "POLE_LAT",pollat))
    call check( nf90_get_att(ncid, nf90_global, "POLE_LON",pollon))
    call check( nf90_get_att(ncid, nf90_global, "MAP_PROJ",mapproj))
    if(nf90_get_att(ncid, nf90_global, "MAP_PROJ_CHAR",map_proj_char).eq. nf90_noerr) then
     print *,map_proj_char
     else
     map_proj_char="Lambert Conformal"
     end if
    call check( nf90_get_att(ncid, nf90_global, "MMINLU",mminlu))
    call check( nf90_get_att(ncid, nf90_global, "ISWATER",iswater))
    call check( nf90_get_att(ncid, nf90_global, "ISLAKE",islake))
    call check( nf90_get_att(ncid, nf90_global, "ISICE",isice))
    call check( nf90_get_att(ncid, nf90_global, "ISURBAN",isurban))
    call check( nf90_get_att(ncid, nf90_global,"ISOILWATER",isoilwater))
    if (nf90_get_att(ncid, nf90_global,"GRID_ID",grid_id).ne.nf90_noerr)then
    call check(nf90_get_att(ncid, nf90_global,"grid_id",grid_id))
    end if
    call check( nf90_get_att(ncid, nf90_global, "NUM_LAND_CAT",num_land_cat))
    if (nf90_get_att(ncid, nf90_global, "GMT",gmt).ne.nf90_noerr)&
   &    print *," Using wrfchemin GMT"
    if (nf90_get_att(ncid, nf90_global, "JULYR",julyr).ne.nf90_noerr)&
   &    print *," Using wrfchemin JULYR"
    if (nf90_get_att(ncid, nf90_global, "JULDAY",julday).ne.nf90_noerr)&
   &    print *," Using wrfchemin JULDAY"
   if (nf90_get_att(ncid, nf90_global, "START_DATE",current_date).ne.nf90_noerr)&
  &    print *," Using wrfchemin START_DATE"
!print *,XLAT(1,1,1),XLAT(1,2,1),XLAT(1,3,1)
!print *,XLON(1,1,1),XLON(2,1,1),XLON(3,1,1)
    call check( nf90_close(ncid) )
!$omp end parallel sections

    do i=1,dimlon
        do j=1,dimlas
            dlat(i,j)=xlats(i,j,1)
        end do
    end do
    do i=1,dimlos
        do j=1,dimlat
            dlon(i,j)=xlons(i,j,1)
        end do
    end do

    dix=dimlon
    djx=dimlat
    allocate(ed(dix,djx,dim(6),dim(1),nvars))
    ed=0
    print * ,'* Done reading wrfinput file'!,dimlos,dimlon
    deallocate (XLATS,XLONS)

end subroutine file_reading
!
!  CCCC  H   H  EEEEE   CCCC  K   K
! CC     H   H  E      CC     K K
! C      HHHHH  EEE   C       KK
! CC     H   H  E      CC     K K
!  CCCC  H   H  EEEEE   CCCC  K   K
!> @brief Evaluation of netcdf status
!> @details In case of error prints error message description
!> @param status An error status that might have been returned from a previous call to some netCDF function
!> @date 28/08/2012.
subroutine check(status)

    USE netcdf
    integer, intent ( in) :: status
    if(status /= nf90_noerr) then
        print *, trim(nf90_strerror(status))
        stop 2
    end if
end subroutine check
