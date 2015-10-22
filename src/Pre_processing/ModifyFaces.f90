!----------------------------------------------------------------------------------------------------------------------------------
! SPHERA (Smoothed Particle Hydrodynamics research software; mesh-less Computational Fluid Dynamics code).
! Copyright 2005-2015 (RSE SpA -formerly ERSE SpA, formerly CESI RICERCA, formerly CESI-) 
!      
!     
!   
!      
!  

! This file is part of SPHERA.
!  
!  
!  
!  
! SPHERA is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
!  
!  
!  
!----------------------------------------------------------------------------------------------------------------------------------

!----------------------------------------------------------------------------------------------------------------------------------
! Program unit: ModifyFaces                   
! Description: To generate triangles from quadrilaterals (partitioning along the shortest diagonal)                 
!----------------------------------------------------------------------------------------------------------------------------------
subroutine ModifyFaces(NumberEntities)
!------------------------
! Modules
!------------------------ 
use Static_allocation_module
use Hybrid_allocation_module
use Dynamic_allocation_module
!------------------------
! Declarations
!------------------------
implicit none
integer(4),intent(IN),dimension(20) :: NumberEntities
integer(4) :: n,i,new
double precision :: d13, d24
!------------------------
! Explicit interfaces
!------------------------
!------------------------
! Allocations
!------------------------
!------------------------
! Initializations
!------------------------
new = NumberEntities(11)
!------------------------
! Statements
!------------------------
do n=1,NumberEntities(11)
   if (BoundaryFace(n)%Node(4)%name==-1) cycle
   new = new + 1
   d13 = zero
   d24 = zero
   do i=1,SPACEDIM
      d13 = d13 + (Vertice(i,BoundaryFace(n)%Node(1)%name) -                   &
            Vertice(i,BoundaryFace(n)%Node(3)%name)) *                         &
            (Vertice(i,BoundaryFace(n)%Node(1)%name) -                         &
            Vertice(i,BoundaryFace(n)%Node(3)%name))
      d24 = d24 + (Vertice(i,BoundaryFace(n)%Node(2)%name) -                   &
            Vertice(i,BoundaryFace(n)%Node(4)%name)) *                         &
            (Vertice(i,BoundaryFace(n)%Node(2)%name) -                         &
            Vertice(i,BoundaryFace(n)%Node(4)%name))
   enddo
   if (d13<d24) then
      BoundaryFace(new) = BoundaryFace(n)
      BoundaryFace(n)%Node(4)%name = -BoundaryFace(n)%Node(4)%name
      BoundaryFace(new)%Node(2)%name = BoundaryFace(new)%Node(3)%name
      BoundaryFace(new)%Node(3)%name = BoundaryFace(new)%Node(4)%name
      BoundaryFace(new)%Node(4)%name =-99999999
      else
         BoundaryFace(new) = BoundaryFace(n)
         i = BoundaryFace(n)%Node(1)%name
         BoundaryFace(n)%Node(1)%name = BoundaryFace(n)%Node(2)%name
         BoundaryFace(n)%Node(2)%name = BoundaryFace(n)%Node(3)%name
         BoundaryFace(n)%Node(3)%name = BoundaryFace(n)%Node(4)%name
         BoundaryFace(n)%Node(4)%name =-i
         BoundaryFace(new)%Node(3)%name = BoundaryFace(new)%Node(4)%name
         BoundaryFace(new)%Node(4)%name =-99999999
   endif
enddo
!------------------------
! Deallocations
!------------------------
return
end subroutine ModifyFaces

