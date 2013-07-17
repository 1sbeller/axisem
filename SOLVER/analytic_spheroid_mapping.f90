!
!    Copyright 2013, Tarje Nissen-Meyer, Alexandre Fournier, Martin van Driel
!                    Simon Stähler, Kasra Hosseini, Stephanie Hempel
!
!    This file is part of AxiSEM.
!    It is distributed from the webpage <http://www.axisem.info>
!
!    AxiSEM is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    AxiSEM is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with AxiSEM.  If not, see <http://www.gnu.org/licenses/>.
!

!==================================
  module analytic_spheroid_mapping
!==================================
!
!	08/02/2002: This module contains the 
! machinery necessary to describe analytically
! the transformation of the reference element
! into its deformed image in the spheroidal 
! enveloppe. 
! 
  use global_parameters 
  use data_mesh, ONLY : router,min_distance_dim,min_distance_nondim

  implicit none
  public :: map_spheroid,compute_partial_d_spheroid
  private
  contains
!//////////////////////////////////////////

!--------------------------------------------------------------------------
!dk map_spheroid
double precision function map_spheroid(xil,etal,nodes_crd,idir)

  double precision,intent(in) :: xil, etal
  double precision, dimension(8,2),intent(in) :: nodes_crd
  integer,intent(in) :: idir
  logical :: oldway

  oldway=.false.

if (oldway) map_spheroid=map_spheroid2(xil,etal,nodes_crd,idir)
if (.not. oldway) map_spheroid=map_spheroid_new(xil,etal,nodes_crd,idir)

end function map_spheroid
!------------------------------------------------------------------------

subroutine compute_partial_d_spheroid(dsdxi,dzdxi,dsdeta,dzdeta,xil,&
                                      etal,nodes_crd)

  double precision, intent(out)               :: dsdxi,dzdxi,dsdeta,dzdeta
  double precision, intent(in)                :: xil,etal
  double precision, dimension(8,2),intent(in) :: nodes_crd
  logical :: oldway

  oldway=.false.

if (oldway) call compute_partial_d_spheroid2(dsdxi,dzdxi,dsdeta,dzdeta,xil,&
                                             etal,nodes_crd)
if (.not. oldway) call compute_partial_d_spheroid_new(dsdxi,dzdxi,dsdeta, &
                                                     dzdeta,xil,etal,nodes_crd)

end subroutine compute_partial_d_spheroid
!-------------------------------------------------------------------------

!dk map_spheroid2------------------------------------------------------
  double precision function map_spheroid2(xil,etal,nodes_crd,idir)
!
!	We are working in polar coordinates here: theta
! is the latitude. 
!
  double precision,intent(in) :: xil, etal
  double precision, dimension(8,2),intent(in) :: nodes_crd
  integer,intent(in) :: idir             

  double precision :: abot,bbot,atop,btop
  double precision :: thetabarbot,dthetabot 
  double precision :: thetabartop,dthetatop 
  double precision :: sbot,zbot,stop,ztop
  double precision :: sbar,ds,slope,intersect
!
  map_spheroid2 = zero
  call compute_parameters_sph(nodes_crd,abot,bbot,atop,btop,&
                              thetabarbot,dthetabot,thetabartop,dthetatop)

  call compute_sz_xi(sbot,zbot,xil,abot,bbot,thetabarbot,dthetabot)
  call compute_sz_xi(stop,ztop,xil,atop,btop,thetabartop,dthetatop)

  sbar = half*(sbot+stop); ds = stop-sbot
 
  if (idir == 1) then ! s
     map_spheroid2 = sbar+ds*etal*half

  elseif (idir == 2) then ! z
! TNM Nov 2006
     if (abs(ds)>1.d-10) then
!     if (abs(ds)>router*1.d-10) then
       intersect = (zbot*stop-ztop*sbot)/ds 
       slope = (ztop-zbot)/ds
       map_spheroid2 = slope*(sbar+half*ds*etal)+intersect
     else
       map_spheroid2 = half*(zbot+ztop)+etal*(ztop-zbot)*half
     end if
  end if

  end function map_spheroid2
!----------------------------------------------------------------------
!

!dk map_spheroid_new------------------------------------------------------
  double precision function map_spheroid_new(xil,etal,nodes_crd,idir)
! 
! The mapping for type (A) in paper 2.

  double precision,intent(in) :: xil, etal
  double precision, dimension(8,2),intent(in) :: nodes_crd
  integer,intent(in) :: idir
  double precision, dimension(8) :: theta_ser,r_ser

  map_spheroid_new = zero
  call compute_theta_r(theta_ser,r_ser,nodes_crd)

  if (idir == 1) then ! s
     map_spheroid_new = half*( (one+etal)* r_ser(7)* &
             dsin(half*( (one-xil)*theta_ser(7) +(one+xil)*theta_ser(5) ) ) + &
             (one-etal)* r_ser(1)* &
             dsin(half*( (one-xil)*theta_ser(1) +(one+xil)*theta_ser(3) ) ) )

  elseif (idir == 2) then ! z
     map_spheroid_new = half*( (one+etal)* r_ser(7)* &
             dcos(half*( (one-xil)*theta_ser(7) +(one+xil)*theta_ser(5) ) ) + &
             (one-etal)* r_ser(1)* &
             dcos(half*( (one-xil)*theta_ser(1) +(one+xil)*theta_ser(3) ) ) )
  end if

! mask round-off errors
  if (abs(map_spheroid_new) < min_distance_dim) map_spheroid_new = zero       

  end function map_spheroid_new
!----------------------------------------------------------------------

!dk compute_theta_r----------------------------------------------------
subroutine compute_theta_r(theta_ser,r_ser,nodes_crd)

double precision, dimension(8,2), intent(in) :: nodes_crd
double precision, dimension(8), intent(out)  :: theta_ser,r_ser
integer                                      :: i

do i=1,8
  r_ser(i) = sqrt(nodes_crd(i,1)**2 + nodes_crd(i,2)**2)

  if (r_ser(i)/= zero) then
     theta_ser(i)=dacos(nodes_crd(i,2)/r_ser(i))  
  else
     theta_ser(i)=zero
  end if
  if (theta_ser(i)< pi*min_distance_nondim) theta_ser(i)=zero
  if (theta_ser(i)==zero .and. nodes_crd(i,2)<zero) theta_ser(i)=pi
enddo

! Swap vertices 1,7 and 3,5 for the southern hemisphere
 if (minval(nodes_crd(:,2))<zero) then

    if (minval(theta_ser)<pi/2.d0-1.d-10) then
       write(6,*)
       write(6,*)'PROBLEM: computing theta & r for spheroidal mapping:'
       do i=1,8
          write(6,*)'inode,s,z:',i,nodes_crd(i,1),nodes_crd(i,2)
          write(6,*)'r,theta  :',r_ser(i),theta_ser(i)*180.d0/pi
       enddo
       stop
    endif
    
 endif

end subroutine compute_theta_r
!----------------------------------------------------------------------


!dk compute_partial_d_spheroid2-----------------------
  subroutine compute_partial_d_spheroid2(dsdxi,dzdxi,dsdeta,dzdeta,xil,etal,nodes_crd)
!
  double precision, intent(out)               :: dsdxi,dzdxi,dsdeta,dzdeta
  double precision, intent(in)                :: xil,etal
  double precision, dimension(8,2),intent(in) :: nodes_crd

  double precision :: abot,bbot,atop,btop
  double precision :: thetabarbot,dthetabot
  double precision :: thetabartop,dthetatop
  double precision :: sbot,zbot,stop,ztop
  double precision :: sbar,ds,dz,slope,intersect,sxieta
  double precision :: dsbotdxi,dzbotdxi
  double precision :: dstopdxi,dztopdxi
  double precision :: dsbardxi,ddsdxi
  double precision :: dzbardxi,ddzdxi
  double precision :: dslopedxi,dintersectdxi
!
  call compute_parameters_sph(nodes_crd,abot,bbot,atop,btop,&
                              thetabarbot,dthetabot,thetabartop,dthetatop)

  call compute_sz_xi(sbot,zbot,xil,abot,bbot,thetabarbot,dthetabot)
  call compute_sz_xi(stop,ztop,xil,atop,btop,thetabartop,dthetatop)

  sbar = half*(sbot+stop); ds = stop-sbot ; dz = ztop - zbot
  if (abs(ds)>1.d-10) then
! TNM: dimensions...
!  if (abs(ds)>router*1.d-10) then
     intersect = (zbot*stop-ztop*sbot)/ds
     slope = dz/ds
  end if

  call compute_dsdxi_dzdxi(dsbotdxi,dzbotdxi,xil,abot,bbot,thetabarbot,dthetabot)
  call compute_dsdxi_dzdxi(dstopdxi,dztopdxi,xil,atop,btop,thetabartop,dthetatop)

  dsbardxi = half*(dsbotdxi+dstopdxi)
  ddsdxi = (dstopdxi-dsbotdxi)
 
  dzbardxi = half*(dzbotdxi+dztopdxi)
  ddzdxi = (dztopdxi-dzbotdxi) 

!
  sxieta = sbar+ds*etal*half
!
!--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   dsdxi = dsbardxi + half*etal*ddsdxi
  dsdeta = half*ds
!--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>
!
!   if (dabs(ds)>router*1.d-10) then
! TNM: dimensios...
!  if (dabs(ds)>router*1.d-10) then
  if (dabs(ds)>router*1.d-10) then
!--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          dslopedxi = (ddzdxi*ds-ddsdxi*dz)/ds**2
      dintersectdxi = ((dzbotdxi*stop-dztopdxi*sbot     &
                       +zbot*dstopdxi-ztop*dsbotdxi)*ds &
                      -ddsdxi*(zbot*stop-ztop*sbot))/ds**2
     dzdxi = (dz/ds)*dsdxi+ sxieta*dslopedxi + dintersectdxi
    dzdeta = (dz/ds)*dsdeta  

!--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  else
!--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>
!    write(6,*)'DS SMALL IN CURVED ELEMENT!!!'; call flush(6)
     dzdxi = zero
     dzdeta = half*dz
!--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  end if

  end subroutine compute_partial_d_spheroid2
!--------------------------------------------------------------

!dk compute_partial_d_spheroid_new-----------------------
  subroutine compute_partial_d_spheroid_new(dsdxi,dzdxi,dsdeta,dzdeta,xil, &
                                        etal,nodes_crd)

! The partial derivatives \partial(s,z) / \partial(\xi,\eta)
! following the definitions for Type (A) in paper 2, App. A1.

  double precision, intent(out)               :: dsdxi,dzdxi,dsdeta,dzdeta
  double precision, intent(in)                :: xil,etal
  double precision, dimension(8,2),intent(in) :: nodes_crd
  double precision, dimension(8) :: theta_ser,r_ser

  call compute_theta_r(theta_ser,r_ser,nodes_crd)

! \partial_\xi s
    dsdxi = half*( (one+etal)* r_ser(7)* half * (theta_ser(5)-theta_ser(7))* &
             dcos(half*( (one-xil)*theta_ser(7) +(one+xil)*theta_ser(5) ) ) + &
             (one-etal)* r_ser(1)* half * (theta_ser(3)-theta_ser(1))* &
             dcos(half*( (one-xil)*theta_ser(1) +(one+xil)*theta_ser(3) ) ) )

    if ( minval(nodes_crd(:,1)) < min_distance_dim .and. dsdxi == zero .and. &
         minval(abs(nodes_crd(:,2))) /= zero) then 
       write(6,*)'PROBLEM: dsdxi vanishes at the axis!'
       write(6,*)'s,r,dsdxi:',minval(nodes_crd(:,1)),minval(r_ser),dsdxi
       stop
    endif

! \partial_\xi z
    dzdxi = -half*( (one+etal)* r_ser(7)* half * (theta_ser(5)-theta_ser(7))* &
             dsin(half*( (one-xil)*theta_ser(7) +(one+xil)*theta_ser(5) ) ) + &
             (one-etal)* r_ser(1)* half * (theta_ser(3)-theta_ser(1))*  &
             dsin(half*( (one-xil)*theta_ser(1) +(one+xil)*theta_ser(3) ) ) )

! \partial_\eta s = 1/2 (s_top - s_bot)
  dsdeta =  half * ( &
    r_ser(7)*dsin(half*( (one-xil)*theta_ser(7) + (one+xil)*theta_ser(5) ) ) -&
    r_ser(1)*dsin(half*( (one-xil)*theta_ser(1) + (one+xil)*theta_ser(3) ) ) )

! \partial_\eta z = 1/2 (z_top - z_bot)
  dzdeta =  half * ( &
    r_ser(7)*dcos(half*( (one-xil)*theta_ser(7) + (one+xil)*theta_ser(5) ) ) -&
    r_ser(1)*dcos(half*( (one-xil)*theta_ser(1) + (one+xil)*theta_ser(3) ) ) ) 

  end subroutine compute_partial_d_spheroid_new
!--------------------------------------------------------------


!dk compute_sz_xi------------------------------------------------------
  subroutine compute_sz_xi(s,z,xil,a,b,thetabar,dtheta)

  double precision, intent(out) :: s,z
  double precision, intent(in) :: xil, a, b, thetabar,dtheta
  
  s = a*dcos(thetabar+xil*half*dtheta)
  z = b*dsin(thetabar+xil*half*dtheta)

  end subroutine compute_sz_xi
!----------------------------------------------------------------------
!
!dk compute_dsdxi_dzdxi---------------------------
  subroutine compute_dsdxi_dzdxi(dsdxi,dzdxi,xil,a,b,thetabar,dtheta)

  double precision, intent(out) :: dsdxi,dzdxi
  double precision, intent(in) :: xil,a,b,thetabar,dtheta 

  dsdxi =-a*half*dtheta*dsin(thetabar+xil*half*dtheta)
  dzdxi = b*half*dtheta*dcos(thetabar+xil*half*dtheta)  
 
  end subroutine compute_dsdxi_dzdxi
!-------------------------------------------------
!
!dk compute_parameters_sph---------------------------------
  subroutine compute_parameters_sph(nodes_crd,abot,bbot,atop,btop,&
                              thetabarbot,dthetabot,thetabartop,dthetatop)

  double precision, dimension(8,2),intent(in) :: nodes_crd
  double precision,intent(out) :: abot,bbot,atop,btop
  double precision,intent(out) :: thetabarbot,dthetabot
  double precision,intent(out) :: thetabartop,dthetatop
  double precision :: s1,z1,s3,z3,s5,z5,s7,z7
  double precision :: theta1,theta3,theta5,theta7
!  
  s1 = nodes_crd(1,1) ; z1 = nodes_crd(1,2)
  s3 = nodes_crd(3,1) ; z3 = nodes_crd(3,2)
  s5 = nodes_crd(5,1) ; z5 = nodes_crd(5,2)
  s7 = nodes_crd(7,1) ; z7 = nodes_crd(7,2)
!
  call compute_ab(abot,bbot,s1,z1,s3,z3)
  call compute_theta(theta1,s1,z1,abot,bbot)
  call compute_theta(theta3,s3,z3,abot,bbot) 
!
  call compute_ab(atop,btop,s7,z7,s5,z5)
  call compute_theta(theta5,s5,z5,atop,btop) 
  call compute_theta(theta7,s7,z7,atop,btop) 
!
  thetabarbot = half*(theta1+theta3)
  dthetabot = theta3-theta1
  thetabartop = half*(theta7+theta5)
  dthetatop = theta5 -theta7
!
  end subroutine compute_parameters_sph
!----------------------------------------------------------
!
!dk compute_ab--------------------------------------
  subroutine compute_ab(a,b,s1,z1,s2,z2)

  double precision, intent(out) :: a,b
  double precision, intent(in) :: s1,z1,s2,z2
!
  a = dsqrt(dabs((s2**2*z1**2-z2**2*s1**2)/(z1**2-z2**2)))
  b = dsqrt(dabs((z1**2*s2**2-z2**2*s1**2)/(s2**2-s1**2))) 
  end subroutine compute_ab
!---------------------------------------------------
!
!dk compute_theta---------------------------
  subroutine compute_theta(theta,s,z,a,b)
!
!	This routine returns the latitude
! theta, given s and z.
!
  double precision, intent(out) :: theta
  double precision, intent(in) :: s,z,a,b
!
  if (s /= zero) then
     theta=datan(z*a/(s*b))  
  else
     if (z>0) theta=half*pi
     if (z<0) theta=-half*pi
  end if

  end subroutine compute_theta
!-----------------------------------
!//////////////////////////////////////////
!
!=======================================
  end module analytic_spheroid_mapping
!=======================================
