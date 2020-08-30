!**********************************************************************
!
!    lee_emiss.F90
!
!> @brief Reads Emission inventory to be interpolated
!> @details Reads from the emission wrfchemin file the variables and attributes
!> put emissions in @c ei array and coordinates in @c xlat, @c xlon.
!>
!> reads the new mesh from wrfinput, stores the new coordinates @c dlat, @c dlon
!>
!> @author Agustin Garcia
!> @date 07/01/2020, 08/28/2012.
!>   @version  3.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
!***************************************************************************
subroutine reads_emision
    use vars_dat
    use netcdf
    implicit none

! This is the name of the data file to read
character (len = *), parameter :: FILE_NAME = "wrfchemin.nc" !Inventory
integer :: i,j,l,it,ikk
integer :: ncid,xtype
integer :: lat_varid,lon_varid,btDimID
integer :: pobId
integer :: nglobalatts
integer,ALLOCATABLE:: id_var(:),id_dim(:)
real :: rdx
real,ALLOCATABLE :: ea(:,:,:,:)
real,ALLOCATABLE :: EXLON(:,:,:),EXLAT(:,:,:)
character (len= NF90_MAX_NAME ) :: name
character (len = *), parameter :: LAT_NAME = "XLAT"
character (len = *), parameter :: LON_NAME = "XLONG"
character (len = *), parameter :: REC_NAME = "Times"
character (len = *), parameter :: POB_NAME = "POB"
tpob=.false.

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
    if(.not.ALLOCATED(EXLON)) allocate (EXLON(dim(3),dim(4),dim(1)))
    if(.not.ALLOCATED(EXLAT)) allocate (EXLAT(dim(3),dim(4),dim(1)))
    if(.not.ALLOCATED(elat)) allocate (elat(dim(3),dim(4)+1)) !stagged y
    if(.not.ALLOCATED(elon)) allocate (elon(dim(3)+1,dim(4))) !stagged x
    if(.not.ALLOCATED(ea))   allocate (ea(dim(3),dim(4),dim(6),dim(1)))
!
    iTime=current_date
    print *,current_date!,lat_varid,lon_varid
    if (tpob) then
      print *,"* Get Population values"
      if(.not.ALLOCATED(epob)) allocate(epob(dim(3),dim(4)))
      call check(nf90_get_var(ncid, pobId, epob))
    end if
!
!   Get lat and lon values.
    print *,"* Get lat and lon values"
    call check(nf90_get_var(ncid, lat_varid, EXLAT))
    call check(nf90_get_var(ncid, lon_varid, EXLON,start = (/ 1, 1,1 /)))
!    print *,EXLAT(1,1,1),EXLAT(1,2,dim(1))
!    print *,EXLON(1,1,1),EXLON(2,1,1)
    do i=1,dim(3)
        do j=1,dim(4)-1
          rdx=0.5*(EXLAT(i,j+1,1)-EXLAT(i,j,1))
          elat(i,j)=EXLAT(i,j,1)-rdx
          if(j.eq.dim(4)-1) then
            elat(i,j+1)=EXLAT(i,j+1,1)-rdx
            elat(i,j+2)=EXLAT(i,j+1,1)+rdx
          end if
        end do
    end do
    do j=1,dim(4)
      do i=1,dim(3)-1
          rdx=0.5*(EXLON(i+1,j,1)-EXLON(i,j,1))
          elon(i,j)=EXLON(i,j,1)-rdx
          if(i.eq.dim(3)-1) then
            elon(i+1,j)=EXLON(i+1,j,1)-rdx
            elon(i+2,j)=EXLON(i+1,j,1)+rdx
          end if
        end do
    end do
!
    if(.not.ALLOCATED(ei)) allocate(ei(dim(3),dim(4),dim(6),dim(1),nvars))
    if(.not.ALLOCATED(ename)) allocate(ename(nvars))
    if(.not.ALLOCATED(cname)) allocate(cname(nvars),cunits(nvars))

!     Get emissions names
    print *,"* Get emissions names and attributes "
    do ikk=1,nvars
    call check(nf90_inquire_variable(ncid,ikk,name))
    ename(ikk)=trim(name)
    if(name(1:2).eq."E_".or.name(1:2).eq."e_") then
        if(trim(name).eq."E_CO".or.trim(name).eq."e_co")  L_CO=ikk
        call check( nf90_get_att(ncid, ikk, "description", name))
        cname(ikk)=trim(name)
        call check( nf90_get_att(ncid, ikk, "units", name))
        cunits(ikk)=trim(name)
        tvar(ikk)=.true.
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
    deallocate (ea,EXLAT,EXLON)
    call check( nf90_close(ncid) )
    print * ,'** Done reading Emissions file'
end subroutine reads_emision
