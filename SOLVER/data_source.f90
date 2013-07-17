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

!> Variables describing anything related to the source
!===================
module data_source
!===================

use global_parameters

implicit none
public
include "mesh_params.h"

!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

 character(len=10)   :: src_type(2)
 double precision    :: t_0,magnitude
 character(len=12)   :: src_file_type
 character(len=7)    :: stf_type
 double precision    :: src_depth,zsrc,srccolat,srclon
 integer             :: iel_src,ipol_src,jpol_src
 integer             :: isim,num_simul
 logical             :: have_src
 real(kind=realkind), allocatable :: stf(:)
 logical             :: rot_src
 real(kind=realkind) :: Mij(6),rot_mom_tensor(3,3)

! discrete diracs
 real(kind=realkind) :: sampling_per_a,discrete_dirac_halfwidth
 integer             :: period_vs_discrete_halfwidth,it_src_shift 
 real(kind=realkind) :: dt_src_shift,shift_fact_discrete_dirac
 character(len=6)    :: discrete_choice
 logical             :: discrete_dirac

! elemental source term, maximally across 8 elements and 3 components
 real(kind=realkind) :: source_term_el(0:npol,0:npol,8,3)
 integer             :: nelsrc, ielsrc(8)

! How to deal with the source for kernel wavefield dumps
 character(len=4)    :: src_dump_type

! finite fault
  integer :: fflt_num
  character(len=30) :: fflt_stf_name
  real(kind=realkind), allocatable, dimension(:) :: fflt_lat,fflt_lon,fflt_depth
  real(kind=realkind), allocatable, dimension(:) :: fflt_strike,fflt_dip,fflt_rake
  real(kind=realkind), allocatable, dimension(:) :: fflt_theta,fflt_phi,fflt_r
  real(kind=realkind), allocatable, dimension(:,:) :: fflt_Mij
  real(kind=realkind) :: fflt_scalarmoment,fflt_nt,fflt_dt
!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

!===================
end module data_source
!===================
