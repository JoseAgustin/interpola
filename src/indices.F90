!****************************************************************************
!> @brief  finds the start and end of each domain for reducing search items
!> @details by using the dalt,dlon elat and elon values selects the
!>  indexes for start and end for each domain.
!>
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  03/06/2020
!>   @version  1.0
!****************************************************************************
!  _           _ _
! (_)_ __   __| (_) ___ ___  ___
! | | '_ \ / _` | |/ __/ _ \/ __|
! | | | | | (_| | | (_|  __/\__ \
! |_|_| |_|\__,_|_|\___\___||___/
!
subroutine indices(iid,ifd,jid,jfd,iie,ife,jie,jfe)
use vars_dat
implicit none
!> initial index model domain in dimension 1
integer,intent(out) :: iid
!> final index model domain in dimension 1
integer,intent(out) :: ifd
!> initial index model domain in dimension 2
integer,intent(out) ::jid
!> final index model domain  in dimension 2
integer,intent(out) ::jfd
!> initial index emissions domain in dimension 1
integer,intent(out) :: iie
!> final index emissions domain in dimension 1
integer,intent(out) :: ife
!> initial index emissions domain in dimension 2
integer,intent(out) ::jie
!> final index emissions domain in dimension 2
integer,intent(out) ::jfe
!> valor mínimo del arreglo a comparar
real :: elmin
!> valor maximo del arreglo a comparar
real :: elmax
    iid=dix
    ifd=1
    jid=djx
    jfd=1
    iie=eix
    ife=1
    jie=ejx
    jfe=1
! searchivg for indexes in latitudes for modeling domain
    elmin=minval(elat)
    elmax =maxval(elat)
   call obtiene(elmin,elmax,dlat,2,jid,jfd)

! searchivg for indexes in longitudes for modeling domain
    elmin=minval(elon)
    elmax=maxval(elon)
   call obtiene(elmin,elmax,dlon,1,iid,ifd)

! searchivg for indexes in latitudes for emissions domain
    elmin=minval(dlat)
    elmax =maxval(dlat)
    call obtiene(elmin,elmax,elat,2,jie,jfe)
! searchivg for indexes in longitudes for modeling domain
    elmin=minval(dlon)
    elmax =maxval(dlon)
    call obtiene(elmin,elmax,elon,1,iie,ife)
    print '(8I4)',jid,jfd,iid,ifd,jie,jfe,iie,ife
    return
end subroutine
