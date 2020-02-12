!
!    lee_files.f90
!
!  FUNCTIONS:
!
!    File_reading  - Reads Emission inventory and Mesh to interpolate
!       check      - in case of error prints error messages
!
!	Created by Agustin Garcia on 28/08/2012.
!
!****************************************************************************
!
!  PROGRAM: Interpola
!
!  PURPOSE:  Reads emissions inventory from wrfchemin.nc and wrfinput_d01
!            
!   version 0.1  27 agosto 2012
!
!***************************************************************************
subroutine file_reading
    use vars_dat
    use netcdf
    implicit none

! This is the name of the data file to read
character (len = *), parameter :: FILE_NAME = "wrfchemin.nc" !Inventory
integer :: i,j,l,it,ikk
integer :: ncid
integer :: lat_varid,lon_varid,btDimID
integer :: latVarId, lonVarId
integer :: land_catID
integer :: dimlon,dimlat,dimtime
integer,dimension(NDIMS):: dim,id_dim
integer,dimension(radm+1):: id_var
real,ALLOCATABLE :: ea(:,:,:,:)
character (len=20 ) :: name
character (len = *), parameter :: LAT_NAME = "XLAT"
character (len = *), parameter :: LON_NAME = "XLONG"
character (len = *), parameter :: REC_NAME = "Times"

! Open the file.
    print *,"Reading file:",FILE_NAME
    call check( nf90_open(FILE_NAME, nf90_nowrite, ncid) )
    call check( nf90_get_att(ncid, nf90_GLOBAL, "TITLE", TITLE))
    call check( nf90_get_att(ncid, NF90_GLOBAL, "START_DATE",iTime))
    call check( nf90_get_att(ncid, NF90_GLOBAL, "DAY",cday))
    call check( nf90_get_att(ncid, NF90_GLOBAL, "MECHANISM",mecha))
! Get the vars ID of the latitude and longitude coordinate variables.
    call check( nf90_inq_varid(ncid, LAT_NAME, lat_varid) )
    call check( nf90_inq_varid(ncid, LON_NAME, lon_varid) )
    call check( nf90_inq_varid(ncid, REC_NAME, id_var(radm+1)) )
!  Get dims ID and dimension values
    do i=1,NDIMS
        call check(nf90_inq_dimid(ncid, sdim(i), id_dim(i)))
        call check(nf90_inquire_dimension(ncid,id_dim(i),len=dim(i)))
    end do
    if(.not.ALLOCATED(XLON)) allocate (XLON(dim(3),dim(4),dim(1)))
    if(.not.ALLOCATED(XLAT)) allocate (XLAT(dim(3),dim(4),dim(1)))
    if(.not.ALLOCATED(elat)) allocate (elat(dim(3),dim(4)))
    if(.not.ALLOCATED(elon)) allocate (elon(dim(3),dim(4)))
    if(.not.ALLOCATED(ea)) allocate (ea(dim(3),dim(4),dim(6),dim(1)))
    if(.not.ALLOCATED(ei)) allocate(ei(dim(3),dim(4),dim(6),dim(1),radm))
!
!   Retrive initial Time
    call check(nf90_get_var(ncid, id_var(radm+1), Times,start = (/ 1, 1 /)))
    current_date(1:19)=Times(1,1)
    print *,current_date!,lat_varid,lon_varid

!
!   Get lat and lon values.
    print *,"* Get lat and lon values"
    call check(nf90_get_var(ncid, lat_varid, XLAT))
    call check(nf90_get_var(ncid, lon_varid, XLON,start = (/ 1, 1,1 /)))
!    print *,XLAT(1,1,1),XLAT(1,2,dim(1))
!    print *,XLON(1,1,1),XLON(2,1,1)
    do i=1,dim(3)
        do j=1,dim(4)
        elat(i,j)=XLAT(i,j,1)
        elon(i,j)=XLON(i,j,1)
        end do
    end do
!print *,elat(1,1),elat(1,2)
!print *,elon(1,1),elon(2,1)

!
!     Get emissions values
    print *,"* Get emissions values"
    do ikk=1,radm
      if(nf90_inq_varid(ncid,ename(ikk), id_var(ikk)).eq.nf90_noerr)  then
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

    print *," "
    print *,'* Start reading wrfinput file'
    call check(nf90_open("wrfinput", NF90_NOWRITE, ncid))
    call check(nf90_inq_dimid(ncid, "south_north", lat_varid))
    call check(nf90_inq_dimid(ncid, "west_east", lon_varid))
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
    !print *,dimlon,name
    call check(nf90_inquire_dimension(ncid, lat_varid,name,dimlat))
    !print *,dimlat,name

    if(.not.ALLOCATED(XLON)) allocate (XLON(dimlon ,dimlat,1))
    if(.not.ALLOCATED(XLAT)) allocate (XLAT(dimlon ,dimlat,1))
    if(.not.ALLOCATED(dlon)) allocate (dlon(dimlon ,dimlat))
    if(.not.ALLOCATED(dlat)) allocate (dlat(dimlon ,dimlat))

    if(nf90_inq_varid(ncid, "XLAT_M", latVarId).eq. nf90_noerr) then
        print *,"XLAT_M"
    else
        call check(nf90_inq_varid(ncid, "XLAT", latVarId))
        print *,"XLAT"
    end if
    if(nf90_inq_varid(ncid, "XLONG_M", lonVarId).eq. nf90_noerr) then
        print *,"XLONG_M"
    else
        call check(nf90_inq_varid(ncid, "XLONG", lonVarId))
        print *,"XLONG"
    end if
    call check(nf90_get_var(ncid, latVarId,xlat,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
    call check(nf90_get_var(ncid, lonVarId,xlon,start=(/1,1,1/),count=(/dimlon,dimlat,1/)))
    print *,'  Reading Global Attribiutes'
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
    call check( nf90_get_att(ncid, nf90_global, "GMT",gmt))
    call check( nf90_get_att(ncid, nf90_global, "JULYR",julyr))
    call check( nf90_get_att(ncid, nf90_global, "JULDAY",julday))
    call check( nf90_get_att(ncid, nf90_global, "MAP_PROJ",mapproj))
    call check( nf90_get_att(ncid, nf90_global, "MAP_PROJ_CHAR",map_proj_char))
    call check( nf90_get_att(ncid, nf90_global, "MMINLU",mminlu))
    call check( nf90_get_att(ncid, nf90_global, "ISWATER",iswater))
    call check( nf90_get_att(ncid, nf90_global, "ISLAKE",islake))
    call check( nf90_get_att(ncid, nf90_global, "ISICE",isice))
    call check( nf90_get_att(ncid, nf90_global, "ISURBAN",isurban))
    call check( nf90_get_att(ncid, nf90_global,"ISOILWATER",isoilwater))
    call check( nf90_get_att(ncid, nf90_global,"GRID_ID",grid_id))
    call check( nf90_get_att(ncid, nf90_global, "NUM_LAND_CAT",num_land_cat))
!    call check( nf90_get_att(ncid, nf90_global, "START_DATE",current_date))
!print *,XLAT(1,1,1),XLAT(1,2,1),XLAT(1,3,1)
!print *,XLON(1,1,1),XLON(2,1,1),XLON(3,1,1)

    call check( nf90_close(ncid) )
    do i=1,dimlon
        do j=1,dimlat
            dlat(i,j)=xlat(i,j,1)
            dlon(i,j)=xlon(i,j,1)
        end do
    end do
    dix=dimlon
    djx=dimlat
    allocate(ed(dix,djx,dim(6),dim(1),radm))
    ed=0
    print * ,'* Done reading wrfinput file'
!    deallocate (XLAT,XLON)

end subroutine file_reading
!
!  CCCC  H   H  EEEEE   CCCC  K   K
! CC     H   H  E      CC     K K
! C      HHHHH  EEE   C       KK
! CC     H   H  E      CC     K K
!  CCCC  H   H  EEEEE   CCCC  K   K

subroutine check(status)
    USE netcdf
    integer, intent ( in) :: status
    if(status /= nf90_noerr) then
        print *, trim(nf90_strerror(status))
        stop 2
    end if
end subroutine check
