!
!>	@brief
!>  Emission Interpolation from one mesh to a new mesh.
!>  @details
!>   Contains a call for tree subroutines that completes the procedure
!> \par file_reading
!>      Reads Emission inventory and the mesh to interpolate.
!> \par conversion
!>      Computations for emissions mass conservation into the new mesh.
!> \par file_out
!>      Create output file and write results
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  2012/06/20
!>   @version  2.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!

!
!	Created by Agustin Garcia on
!
!****************************************************************************
!
!  PROGRAM: Interpola
!
!  Reads emissions from a especific File and interpolates to a new mesh.
!
!****************************************************************************

program Interpola

! Variables

! Body of Interpola
    Call file_reading

    Call conversion

    Call File_out

end program Interpola
