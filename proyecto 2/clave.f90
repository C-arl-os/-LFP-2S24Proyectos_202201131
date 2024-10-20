MODULE clave
    implicit none

    type :: Clv
        CHARACTER (LEN = 50) :: id
        CHARACTER (LEN = 20) :: tipo
        CHARACTER (LEN = 200) :: texto
        CHARACTER (LEN = 50) :: posicion_x
        CHARACTER (LEN = 50) :: posicion_y

    End type Clv

    ! Declaración de un arreglo de Clv para almacenar los claves
    type(Clv), ALLOCATABLE ::  clave_array(:)

contains

subroutine agregar_clave(id)

    CHARACTER(LEN=*), INTENT(IN) :: id
    type(Clv) :: nuevo_clave
    integer :: n
    type(Clv), ALLOCATABLE ::  temp_array(:)

    !Inicializo los datos del nuevo clave

    nuevo_clave%id = id
    nuevo_clave%tipo = 'Clave'
    nuevo_clave%texto = ""
    nuevo_clave%posicion_x = ""
    nuevo_clave%posicion_y = ""

    ! Agrego el nuevo clave a la lista de claves

    if (.NOT. ALLOCATED(clave_array)) then !Si esta vacia
        ALLOCATE(clave_array(1)) ! Se le asigna memoria para un clave de la lista
        clave_array(1) =  nuevo_clave !Se convierte en el clave nuevo
    else
        n = size(clave_array)
        ALLOCATE(temp_array(n+1))
        temp_array(:n) = clave_array !Reservo memoria
        temp_array(n+1) = nuevo_clave
        DEALLOCATE(clave_array) !Libero memoria
        ALLOCATE(clave_array(n+1)) !Reservo memoria de nuevo
        clave_array = temp_array
    end if

end subroutine agregar_clave

subroutine imprimir_claves()

    integer :: i

    ! Verifica si la memoria ha sido asignada para el arreglo
    if (.NOT. ALLOCATED(clave_array)) then
        print *, "No hay claves"
    else
        print *, "claves encontradas: ", size(clave_array)
        ! Recorre la lista de claves y genera una fila para cada clave
        DO i = 1, size(clave_array)
            print *, 'id: ', trim(clave_array(i)%id)
            print *, 'tipo: ', trim(clave_array(i)%tipo)
            print *, 'texto: ', trim(clave_array(i)%texto)
            print *, 'posicion_x: ', trim(clave_array(i)%posicion_x)
            print *, 'posicion_y: ', trim(clave_array(i)%posicion_y)
            print *, '---------------------------------'
        END DO
    end if

end subroutine imprimir_claves

subroutine clave_set_texto(id, texto)
    CHARACTER(LEN=*), INTENT(IN) :: id
    CHARACTER(LEN=*), INTENT(IN) :: texto
    integer :: i

    ! Verifica si la memoria ha sido asignada para el matriz
    if (.NOT. ALLOCATED(clave_array)) then
        print *, "No hay claves"
    else
        DO i = 1, size(clave_array)
            if (trim(clave_array(i)%id) == id) then
                clave_array(i)%texto = texto
            end if
        END DO
    end if

end subroutine clave_set_texto

subroutine clave_set_posicion(id, posicion_x, posicion_y)
    CHARACTER(LEN=*), INTENT(IN) :: id
    CHARACTER(LEN=*), INTENT(IN) :: posicion_x
    CHARACTER(LEN=*), INTENT(IN) :: posicion_y
    integer :: i

    ! Verifica si la memoria ha sido asignada para el matriz
    if (.NOT. ALLOCATED(clave_array)) then
        print *, "No hay claves"
    else
        DO i = 1, size(clave_array)
            if (trim(clave_array(i)%id) == id) then
                clave_array(i)%posicion_x = posicion_x
                clave_array(i)%posicion_y = posicion_y
            end if
        END DO
    end if

end subroutine clave_set_posicion

FUNCTION buscar_clave_por_id(id) RESULT(encontrado)
    CHARACTER(LEN=*), INTENT(IN) :: id
    logical :: encontrado
    integer :: i

    encontrado = .FALSE.

    if (.NOT. ALLOCATED(clave_array)) then
        print *, "No hay claves"
    else
        DO i = 1, size(clave_array)
            if (trim(clave_array(i)%id) == id) then
                encontrado = .TRUE.
            end if
        END DO
    end if
END FUNCTION buscar_clave_por_id

END MODULE clave