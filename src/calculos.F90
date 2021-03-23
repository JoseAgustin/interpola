!
!    calculos.f90
!
!	Created by Agustin Garcia on 28/08/2012.
!
!****************************************************************************
!
!  FUNCTIONS:
!
!> @brief  It does the interpolation into the new Mesh
!> @details   Interpolates the emissions into new mesh conserving mass
!> uses emission area and the fractional area between the original
!> and new grid to set the emissions.
!>
!> Computes the mass in the original mesh and compares against the new mesh,
!> if both domains cover the same area the ratio @c xemis/ @c xmas should be 1
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  07/01/2020
!>   @version  3.1
!****************************************************************************
subroutine conversion
!$ use omp_lib
use vars_dat
implicit none
integer :: i,j,ii,jj,kl,l
!>  hours in a day
integer :: ih
integer ::iid,ifd,jid,jfd,iie,ife,jie,jfe
real*8   :: ylat1,ylat2,xlon1,xlon2
real*8   :: elat1,elat2,elon1,elon2
real*8   :: alat,alon,area,tot
real*8  ::  xmas,xemis

call indices (iid,ifd,jid,jfd,iie,ife,jie,jfe)
print *, "   *******   Doing interpolations   *******"
!    do j=1,djx!-1
!    do i=1,dix!-1
    do j=jid,jfd
      do i=iid,ifd
        ylat1=dlat(i ,j )
        ylat2=dlat(i,j+1) !staged lat
        xlon1=dlon(i  ,j)
        xlon2=dlon(i+1,j) !staged long
!$omp parallel do private(area,tot,elat1,elat2,elon1,elon2,jj,ih,l,kl)
        do ii=iie,ife!1,eix
            do jj=jie,jfe!1,ejx
            alat=0.0
            alon=0.0
            elat1= elat(ii,jj)
            elat2= elat(ii,jj+1) !staged lat
            elon1= elon(ii,jj)
            elon2= elon(ii+1,jj)!staged long
            tot=(elat2-elat1)*(elon2-elon1)/((ylat2-ylat1)*(xlon2-xlon1))
            if(ylat1.le.elat2.and. ylat2.ge.elat1)alat=&
            & (min(ylat2,elat2)-max(ylat1,elat1))/(elat2-elat1)
            if(xlon1.le.elon2 .and. xlon2.ge.elon1)  alon=&
            & (min(xlon2,elon2)-max(xlon1,elon1))/(elon2-elon1)
            area=max(0.,alat*alon)* tot!
            if( area.gt.0.) then
             do l=1,size(ed,dim=3) ! altura
               do  ih=1,size(ed,dim=4) !hora
                 do  kl=1,size(ed,dim=5) ! compuesto
                 if (tvar(kl)) ed(i,j,l,ih,kl)=ed(i,j,l,ih,kl)+ei(ii,jj,l,ih,kl)*area
                 end do ! kl
               end do ! ih
             end do  ! l
             if(tpob)dpob(i,j)=dpob(i,j)+epob(ii,jj)*area
            end if  ! area
            end do  ! jj
        end do  ! ii
!$omp end parallel do
        xmas=xmas+ed(i,j,1,1,L_CO)*dx*dy/1e6
    end do     ! i
end do    !  j
!  Emissions inventory mass computation
    do ii=1,eix
        do jj=1,ejx
        xemis=xemis+ei(ii,jj,1,1,L_CO) *dxe*dye/1e6
        end do  ! jj
    end do  ! ii
!
print *,'     ***** Mass balance *****'
print '(A20,F10.0," dx= ",f5.0,"m dy= ",f5.0,"m")','Emissions Inventory:',xemis, dxe,dye
print '(A20,F10.0," dx= ",f5.0,"m dy= ",f5.0,"m")','New Model Domain:',xmas, dx,dy
print '(A20,x,f10.4,x,f10.4,"%")','Ratio EI/EDx100:', xemis/xmas,(xemis/xmas-1)*100
print '(A)','    ******   Done interpolation   ****** '
deallocate(elat,elon,dlon,dlat,ei)
end subroutine conversion
