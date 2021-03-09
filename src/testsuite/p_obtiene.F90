!>   @brief test subroutine obtiene
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 03/08/2021
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
program test_obtiene
use vars_dat
implicit none
integer,parameter ::ndi=7, ndj=5
integer,parameter ::nei=5, nej=8
integer :: jid,jfd,iid,ifd,jie,jfe,iie,ife
integer :: i,j
real :: elmin,elmax
allocate(dlat(ndi,ndj),dlon(ndi,ndj))
allocate(elat(nei,nej),elon(nei,nej))
iid=ndi
ifd=1
jid=ndj
jfd=1
iie=nei
ife=1
jie=nej
jfe=1

do i=1,ndi
  do j=1,ndj
   dlat(i,j)=18.0+0.5*real(j)
   dlon(i,j)=-101.5+0.5*real(i)
end do
end do
do i=1,nei
  do j=1,nej
   elat(i,j)=19.1+0.25*real(j)
   elon(i,j)=-99.9+0.25*real(i)
end do
end do

elmin=minval(elat)
elmax =maxval(elat)
call obtiene(elmin,elmax,dlat,2,jid,jfd)
elmin=minval(elon)
elmax =maxval(elon)
call obtiene(elmin,elmax,dlon,1,iid,ifd)
elmin=minval(dlat)
elmax =maxval(dlat)
call obtiene(elmin,elmax,elat,2,jie,jfe)
elmin=minval(dlon)
elmax =maxval(dlon)
call obtiene(elmin,elmax,elon,1,iie,ife)

print *,jid,jfd,iid,ifd
print *,jie,jfe,iie,ife

deallocate(dlat,dlon,elat,elon)
end program
