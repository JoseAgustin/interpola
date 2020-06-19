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
!> uses emission area and thte fractional area between the original
!> and new grid to set the emissions.
!>
!> Computes the mass in the original mesh and compares against the new mesh,
!> if both domains cover the same area the ratio @c xemis/ @c xmas should be 1
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  28/08/2012.
!>   @version  2.0
!****************************************************************************
subroutine conversion
!$ use omp_lib
use vars_dat
implicit none
integer :: i,j,ii,jj,kl,l
integer :: ih
real*8   :: ylat1,ylat2,xlon1,xlon2
real*8   :: elat1,elat2,elon1,elon2
real*8   :: alat,alon,area,tot
real*8  ::  xmas,xemis

print *, "*****  Doing interpolations ****"
    do j= 2,djx-1
    do i=2,dix-1
        ylat1=.5*(dlat(i,j-1)+dlat(i,j))
        ylat2=.5*(dlat(i,j+1)+dlat(i,j))
        xlon1=.5*(dlon(i-1,j)+dlon(i,j))
        xlon2=.5*(dlon(i+1,j)+dlon(i,j))
        !$omp parallel do private(jj,area,ih,l,kl)
        do ii=2,eix-1
            do jj=2,ejx-1
            alat=0.0
            alon=0.0
            elat1= 0.5*(elat(ii,jj)+elat(ii,jj-1))
            elat2= 0.5*(elat(ii,jj)+elat(ii,jj+1))
            elon1= 0.5*(elon(ii,jj)+elon(ii-1,jj))
            elon2= 0.5*(elon(ii,jj)+elon(ii+1,jj))
            tot=(elat2-elat1)*(elon2-elon1)/((ylat2-ylat1)*(xlon2-xlon1))
            if(ylat1.le.elat2.and. ylat2.ge.elat1)alat=&
            &(min(ylat2,elat2)-max(ylat1,elat1))/(elat2-elat1)
            if(xlon1.le.elon2.and. xlon2.ge.elon1)  alon=&
            &      (min(xlon2,elon2)-max(xlon1,elon1))/(elon2-elon1)
            area=max(0.,alat*alon)* tot!
            if( area.gt.0.) then
            do  ih=1,size(ed,dim=4)
              do l=1,size(ed,dim=3)
                do  kl=1,size(ed,dim=5)
                if (tvar(kl)) ed(i,j,l,ih,kl)=ed(i,j,l,ih,kl)+ei(ii,jj,l,ih,kl)*area
                end do ! kl
              end do ! l
            end do  ! ih
            if(tpob)dpob(i,j)=dpob(i,j)+epob(ii,jj)*area
            end if
            end do  ! jj
        end do  ! ii
        !$omp end parallel do
        xmas=xmas+ed(i,j,1,1,8)*dx*dy/1000000
    end do     ! i
end do    !  j
    do i=1,eix
        do j=1,ejx
            xemis=xemis+ei(i,j,1,1,8) *dxe*dye/1000000
        end do
    end do
!
print *,'Mass balance'
print '(A20,F10.0,x,f7.0,x,f7.0)','Emissions Inventory:',xemis, dxe,dye
print '(A20,F10.0,x,f7.0,x,f7.0)','Emissions Domain:',xmas , dx,dy
print '(A20,x,f10.4,x,f10.4,"%")','Ratio EI/EDx100:', xemis/xmas,(xemis/xmas-1)*100
print '(A)','******   Done interpolation'
print *,"      ++++++++++++"
deallocate(elat,elon,dlon,dlat,ei)

end subroutine conversion
