MODULE jerarquia 
 implicit none
     type :: Jerar
        CHARACTER(LEN = 100) :: padre
        CHARACTER(LEN = 100) :: hijo
    End type Jerar

    type(Jerar), ALLOCATABLE :: jerarquia_array(:)

contains 

    subroutine set_jerarquia(padre , hijo)

        character(len=*), intent(in) :: padre
        character(len=*), intent(in) :: hijo

        type(Jerar) :: nueva
        integer :: n
        type (Jerar), ALLOCATABLE ::  temp_array(:)

        nueva%padre =  padre
        nueva%hijo = hijo

        if(.NOT. ALLOCATED(jerarquia_array) ) then
            ALLOCATE(jerarquia_array(1))
            jerarquia_array(1) = nueva
        else
         n = size(jerarquia_array)
         ALLOCATE(temp_array(n+1))
         temp_array(1:n) = jerarquia_array
         temp_array(n+1) = nueva
         DEALLOCATE(jerarquia_array)
         ALLOCATE(jerarquia_array(n+1))
         jerarquia_array = temp_array
        end if

    end subroutine set_jerarquia

    subroutine imprimir_jerarquia()
        integer :: i
        print *, 'jerarquias encontradas: ', size(jerarquia_array)
        do i = 1, size(jerarquia_array)
            print *, 'padre: ', trim(jerarquia_array(i)%padre)
            print *, 'hijo: ', trim(jerarquia_array(i)%hijo)
            print *, '---------------------------------'
        end do

    end subroutine imprimir_jerarquia

end module jerarquia