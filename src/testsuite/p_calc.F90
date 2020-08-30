!>   @brief test subroutine calculos
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 08/28/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
program  p_calculos
    use vars_dat
    use netcdf
    implicit none
    integer :: i,j,ih,ikk,l
    character(len=32):: arg
    do i = 1, iargc()
       call getarg(i, arg)
       if(arg .eq."--version") print *,"1.0"
    end do
    L_CO=1
    djx=6
    dix=6
    eix=5
    ejx=5
    dx=5
    dy=5
    dxe=4
    dye=4
    zlev =2
    nvars=2
    tpob=.false.

    allocate(dim(6),tvar(nvars))
    dim=(/12,19,eix,ejx,2,zlev/)
    allocate(dlat(dix,djx+1),dlon(dix+1,djx))
    allocate (ed(dix,djx,zlev,12,nvars))
    allocate(elat(eix,ejx+1),elon(eix+1,ejx))
    allocate(ei(dim(3),dim(4),dim(6),dim(1),nvars))
    tvar=.true.
    ed=0.
    do i=1,eix
        do j=1,ejx+1
            elat(i,j)= 19.05 +(j-1)*dxe/100.
        end do
    end do
    do i=1,eix+1
       do j=1,ejx
            elon(i,j)=-99.25 +(i-1)*dye/100.
        end do
    end do
!
    do i=1,eix
        do j=1,ejx
            do ih=1,12
                do ikk=1,nvars
                    do l=1,zlev
                        ei(i,j,l,ih,ikk)=ikk*100500.*mod(i+j,2)
                    end do
                end do
            end do
        end do
    end do

    do i=1,dix
        do j=1,djx+1
            dlat(i,j)=19.00 +(j-1)*dy/100.
        end do
    end do
    do i=1,dix+1
        do j=1,djx
            dlon(i,j)=-99.30 +(i-1)*dx/100.
        end do
    end do
	call conversion
    
    deallocate(ed)
end program
