MODULE boton
    implicit none

    type :: Boto
        CHARACTER(LEN = 50) :: id
        CHARACTER(LEN = 20) :: tipo
        CHARACTER(LEN = 200) :: texto
        CHARACTER(LEN = 50) :: posicion_x
        CHARACTER(LEN = 50) :: posicion_y

    end type Boto

    ! Declaración de un arreglo de Boton para almacenar los botones
    type(Boto), ALLOCATABLE ::  boton_array(:)

contains

    ! Subrutina para agregar botones a la lista de botones
    subroutine agregar_boton(id)
        CHARACTER(LEN=*), INTENT(IN) :: id

        type(Boto) :: nuevo_boton
        integer :: n
        type(Boto), ALLOCATABLE ::  temp_array(:)
        
        !Inicializo los datos del nuevo boton
        nuevo_boton%id = id
        nuevo_boton%tipo = 'Boton'
        nuevo_boton%texto = ""
        nuevo_boton%posicion_x = ""
        nuevo_boton%posicion_y = ""

        ! Agrego el nuevo boton a la lista de botones
        if (.NOT. ALLOCATED(boton_array)) then !Si esta vacia
            ALLOCATE(boton_array(1)) ! Se le asigna memoria para un boton de la lista
            boton_array(1) =  nuevo_boton !Se convierte en el boton nuevo
        else
            n = size(boton_array)
            ALLOCATE(temp_array(n+1))
            temp_array(:n) = boton_array !Reservo memoria
            temp_array(n+1) = nuevo_boton
            DEALLOCATE(boton_array) !Libero memoria
            ALLOCATE(boton_array(n+1)) !Reservo memoria de nuevo
            boton_array = temp_array
        end if

    end subroutine agregar_boton

    subroutine boton_set_texto(id, texto)
        CHARACTER(LEN=*), INTENT(IN) :: id
        CHARACTER(LEN=*), INTENT(IN) :: texto
        integer :: i

        ! Verifica si la memoria ha sido asignada para el arreglo
        if (.NOT. ALLOCATED(boton_array)) then
            print *, "No hay botones"
        else
            DO i = 1, size(boton_array)
                if (trim(boton_array(i)%id) == id) then
                    boton_array(i)%texto = texto
                end if
            END DO
        end if

    end subroutine boton_set_texto

    subroutine boton_set_posicion(id, posicion_x, posicion_y)
        CHARACTER(LEN=*), INTENT(IN) :: id
        CHARACTER(LEN=*), INTENT(IN) :: posicion_x
        CHARACTER(LEN=*), INTENT(IN) :: posicion_y
        integer :: i

        ! Verifica si la memoria ha sido asignada para el matriz
        if (.NOT. ALLOCATED(boton_array)) then
            print *, "No hay botones"
        else
            DO i = 1, size(boton_array)
                if (trim(boton_array(i)%id) == id) then
                    boton_array(i)%posicion_x = posicion_x
                    boton_array(i)%posicion_y = posicion_y
                end if
            END DO
        end if

    end subroutine boton_set_posicion

    ! Función para buscar un boton por su ID
    FUNCTION buscar_boton_por_id(id) RESULT(encontrado)
        CHARACTER(LEN=*), INTENT(IN) :: id
        logical :: encontrado
        integer :: i

        encontrado = .FALSE.

        if (.NOT. ALLOCATED(boton_array)) then
            print *, "No hay botones"
        else
            DO i = 1, size(boton_array)
                if (trim(boton_array(i)%id) == id) then
                    encontrado = .TRUE.
                    exit
                end if
            END DO
        end if

    END FUNCTION buscar_boton_por_id

subroutine imprimir_botones()
    integer :: i

    if (.NOT. ALLOCATED(boton_array)) then
        print *, "No hay botones"
    else
        print *, "botones encontradas: ", size(boton_array)
        DO i = 1, size(boton_array)
            print *, 'id: ', trim(boton_array(i)%id)
            print *, 'texto: ', trim(boton_array(i)%texto)
            print *, 'posicion_x: ', trim(boton_array(i)%posicion_x)
            print *, 'posicion_y: ', trim(boton_array(i)%posicion_y)
            print *, '---------------------------------'
        END DO
    end if

end subroutine imprimir_botones
    
end MODULE boton