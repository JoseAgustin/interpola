!>   @brief test function compara
!>   @author  Jose Agustin Garcia Reynoso
!>   @date 03/08/2021
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!
program test_compara
    use vars_dat, only :compara 
    implicit none
    integer,parameter:: nd=6
    integer :: i,inicial,final
    real,dimension(nd)::valor=(/20.,22.,24.,26.,28.,30./)
    inicial=nd
    final =1
    do i=1,nd-1
    print *,inicial,final
    inicial=compara(i,inicial,23.,valor(i),valor(i+1),.false.)
    final = compara(i,final,29.,valor(i),valor(i+1),.true.)
    end do
    print *,inicial, final
end program
