!
!    Interpola.f90
!
!  FUNCTIONS:
!	Interpola      - Emission Interpolation to a new mesh.
!
!    File_reading  - Reads Emission inventory and Mesh to interpolate
!    conversion  - Interpolate EI in the new mesh
!    File_out      - Write results
!
!	Created by Agustin Garcia on 28/08/2012.
!
!****************************************************************************
!
!  PROGRAM: Interpola
!
!  PURPOSE:  Reads emissions from a especific File and interpolates to a new mesh.
!
!****************************************************************************

program Interpola

! Variables

! Body of Interpola

    Call file_reading

    Call conversion

    Call File_out

end program Interpola
