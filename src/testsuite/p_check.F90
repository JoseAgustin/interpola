!>   @brief test subroutine reads_emision
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 08/28/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
program test_check
    use vars_dat
    use netcdf
    implicit none
    integer ::istatus =0
    integer :: i
    character(len=32):: arg
    do i = 1, iargc()
       call getarg(i, arg)
       if(arg .eq."--version") print *,"1.0"
    end do

        print *,"Status= ",istatus
        call check(istatus)

end program test_check

