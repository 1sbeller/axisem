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

!=========================
 module global_parameters
!=========================
!
! This determines the precision for the memory-/CPU-intensive time loop. 
! Set the parameter realkind to either 
!   4: single precision (half memory compared to 8, faster on many systems)
!   8: double precision (more expensive (double memory), but more precise.
! The mesher is intrinsically double precision, as are all precomputed, mesh 
! related variables. This distinction is only relevant for the global 
! arrays used in the time evolution.

implicit  none
public

!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  integer, parameter          :: realkind = 4

! Do not change these unless problems with any of the accuracy tests arise.
  real(kind=4), parameter     :: smallval_sngl = 1e-7
  double precision, parameter :: smallval_dble = 1e-11

! Do not change these.
  double precision, parameter :: zero =0d0, half = 5d-1, third = 1d0/3d0
  double precision, parameter :: quart =25d-2, one = 1d0, sixth = 1d0/6d0
  double precision, parameter :: two = 2d0, three = 3d0, four = 4d0, five = 5.d0
  double precision, parameter :: fifth = 2.d-1
  double precision, parameter :: pi = 3.1415926535898D0
  double precision, parameter :: epsi = 1d-30

!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

!============================= 
 end module global_parameters
!=============================
