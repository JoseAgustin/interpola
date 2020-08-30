!>   @brief test subroutine reads_grid
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 08/28/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
program p_lee_grid
    use vars_dat
    use netcdf
    implicit none
    integer :: i
    character(len=32):: arg
    do i = 1, iargc()
       call getarg(i, arg)
       if(arg .eq."--version") print *,"1.0"
    end do
    nvars =3
    allocate(dim(6))
    dim=(/12,19,10,10,2,2/)

    call reads_grid

    deallocate(dim,ed)
end program p_lee_grid
