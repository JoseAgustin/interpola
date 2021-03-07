!****************************************************************************
!> @brief  finds the start and end of each domain for reducing search items
!> @details by using the dalt,dlon elat and elon values selects the
!>  indexes for start and end for each domain.
!>
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  03/06/2020
!>   @version  1.0
!****************************************************************************
!  _           _ _
! (_)_ __   __| (_) ___ ___  ___
! | | '_ \ / _` | |/ __/ _ \/ __|
! | | | | | (_| | | (_|  __/\__ \
! |_|_| |_|\__,_|_|\___\___||___/
!
subroutine indices(iid,ifd,jid,jfd,iie,ife,jie,jfe)
use vars_dat
implicit none
!> initial index model domain in dimension 1
integer,intent(out) :: iid
!> final index model domain in dimension 1
integer,intent(out) :: ifd
!> initial index model domain in dimension 2
integer,intent(out) ::jid
!> final index model domain  in dimension 2
integer,intent(out) ::jfd
!> initial index emissions domain in dimension 1
integer,intent(out) :: iie
!> final index emissions domain in dimension 1
integer,intent(out) :: ife
!> initial index emissions domain in dimension 2
integer,intent(out) ::jie
!> final index emissions domain in dimension 2
integer,intent(out) ::jfe
!> valor mínimo del arreglo a comparar
real :: elmin
!> valor maximo del arreglo a comparar
real :: elmax
    iid=dix
    ifd=1
    jid=djx
    jfd=1
    iie=eix
    ife=1
    jie=ejx
    jfe=1
print *,jid,jfd,iid,ifd,jie,jfe,iie,ife

! searchivg for indexes in latitudes for modeling domain
    elmin=minval(elat)
    elmax =maxval(elat)
   call obtiene(elmin,elmax,dlat,2,jid,jfd)

! searchivg for indexes in longitudes for modeling domain
    elmin=minval(elon)
    elmax=maxval(elon)
   call obtiene(elmin,elmax,dlon,1,iid,ifd)

! searchivg for indexes in latitudes for emissions domain
    elmin=minval(dlat)
    elmax =maxval(dlat)
    call obtiene(elmin,elmax,elat,1,jie,jfe)
! searchivg for indexes in longitudes for modeling domain
    elmin=minval(dlon)
    elmax =maxval(dlon)
    call obtiene(elmin,elmax,elon,2,iie,ife)
!print *,jid,jfd,iid,ifd,jie,jfe,iie,ife
    return
contains
!>   @brief Obtiene los valores de los indices de la coordenada
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  03/06/2020
!>   @version  1.0
!        _     _   _
!   ___ | |__ | |_(_) ___ _ __   ___
!  / _ \| '_ \| __| |/ _ \ '_ \ / _ \
! | (_) | |_) | |_| |  __/ | | |  __/
!  \___/|_.__/ \__|_|\___|_| |_|\___|
!
subroutine obtiene(vmin,vmax,coordenada,numero,inicio,final)
implicit none
!> valor del indice inicial en el arreglo coordenda donde se ubuica vmin
integer,intent(inout):: inicio
!> valor del indice final en el arreglo coordenda donde se ubuica vmax
integer,intent(inout):: final
!> contador
integer :: i
!> indice a emplear en el arreglo coordenada
integer,intent(IN):: numero
!> vmin valor minimo del arreglo a buscar
real,intent(IN)::vmin
!> vmax valor maximo del arreglo a buscar
real,intent(IN)::vmax
!> arreglo de coordenadas donde se busca el valor
real,intent(IN),dimension(:,:) :: coordenada
   !print *,vmin,minval(coordenada)
    do i=1,size(coordenada,numero)-1
      if(numero.eq.1) then
        inicio=compara(i,inicio,vmin,coordenada(i,1),coordenada(i+1,1),.false.)
        final= compara(i,final ,vmax,coordenada(i,1),coordenada(i+1,1),.true.)
      else
        inicio=compara(i,inicio,vmin,coordenada(1,i),coordenada(1,i+1),.false.)
        final =compara(i,final, vmax,coordenada(1,i),coordenada(1,i+1),.true.)
      end if
    end do
if (vmin.lt. minval(coordenada)) inicio=1
if (vmax.gt. maxval(coordenada)) final=size(coordenada,numero)
end subroutine
!>   @brief Compara los valores para los maximos
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  03/06/2020
!>   @version  1.0
!>   @param indice indice del arreglo se usa si se cumple
!>   @param indx es el valor inicial del indice y se substituye por indice si se cunple la condicion
!>   @param  eval  valor a comparar entre dval1 y dval2
!>   @param  dval1  valor inferior del arreglo
!>   @param  dval2  valor superior del arreglo
!>   @param  maximo  verdadero para maximos, falso para minimos
!   ___ ___  _ __ ___  _ __   __ _ _ __ __ _
!  / __/ _ \| '_ ` _ \| '_ \ / _` | '__/ _` |
! | (_| (_) | | | | | | |_) | (_| | | | (_| |
!  \___\___/|_| |_| |_| .__/ \__,_|_|  \__,_|
!                     |_|
integer function  compara(indice,indx,eval,dval1,dval2,maximo)
    integer indice,indx
    real :: eval,dval1,dval2
    logical :: maximo
    if (dval1 .le. eval.and.eval.le.dval2) then
       if(indice.gt.indx.and.maximo) then
            compara=indice
         else
         if(indice.lt.indx) compara=indice
        end if
    end if
end function
end subroutine
