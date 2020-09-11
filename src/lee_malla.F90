!**********************************************************************
!
!    lee_malla.F90
!
!> @brief Reads The new Mesh to interpolate emissions
!> @details Reads the new mesh from wrfinput,
!>
!>    stores the new coordinates @c dlat, @c dlon
!>
!>   @author Agustin Garcia
!>   @date 07/01/2020
!>   @version  3.1
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
!***************************************************************************
subroutine reads_grid
    use vars_dat
    use netcdf
    implicit none

! This is the name of the data file to read
character (len = *), parameter :: FILE_NAME = "wrfinput" !GRID
integer :: i,j
integer :: ncid,xtype
integer :: lat_varid,lon_varid,btDimID
integer :: lat_varid_stag,lon_varid_stag
integer :: latVarId, lonVarId
integer :: land_catID
integer :: dimlon,dimlat
integer :: dimlos,dimlas !stagged variables
character (len= NF90_MAX_NAME ) :: name
character (len = *), parameter :: LAT_STAG = "XLAT_V"
character (len = *), parameter :: LON_STAG = "XLONG_U"

    print *," "
    print *,'   ****** Start reading wrfinput file  *******'
    call check(nf90_open(FILE_NAME, NF90_NOWRITE, ncid))
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
     print *,"* New mesh lat var XLAT_M"
    end if

    if(nf90_inq_varid(ncid, "XLONG", lonVarId).eq. nf90_noerr) then
     call check(nf90_get_var(ncid, lonVarId,xlon,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
     !print *,"XLONG"
    else
     call check(nf90_inq_varid(ncid, "XLONG_M", lonVarId))
     call check(nf90_get_var(ncid, lonVarId,xlon,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
     print *,"* New mesh lon var XLONG_M"
    end if

    if(nf90_inq_varid(ncid, "XLAT_V", latVarId).eq. nf90_noerr) then
    call check(nf90_get_var(ncid, latVarId,xlats,start=(/1,1,1/),count=(/dimlon,dimlas,1/)))
        print *,"* New mesh lat var XLAT_V"
    end if
    if(nf90_inq_varid(ncid, "XLONG_U", lonVarId).eq. nf90_noerr) then
    call check(nf90_get_var(ncid, lonVarId,xlons,start=(/1,1,1/),count=(/dimlos,dimlat,1/)))
        print *,"* New mesh lon var XLONG_U"
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
    call check( nf90_close(ncid) )

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
    print * ,'* Done reading wrfinput file'
    if (allocated(XLATS)) deallocate (XLATS)
    if (allocated(XLONS)) deallocate (XLONS)

end subroutine reads_grid
