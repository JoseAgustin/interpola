!>   @brief test subroutine reads_emision
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 08/28/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
program p_lee
    use vars_dat
    use netcdf
    implicit none
    integer :: i
    character(len=32):: arg
    do i = 1, iargc()
       call getarg(i, arg)
       if(arg .eq."--version") print *,"1.0"
    end do

    call reads_emision

end program
