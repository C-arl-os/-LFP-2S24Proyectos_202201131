module contenedor
    implicit none

    type :: Container
        character(len=50) :: id
        character(len=20) :: tipo
        character(len=20) :: alto
        character(len=20) :: ancho
        character(len=50) :: color_fondo_r
        character(len=50) :: color_fondo_g
        character(len=50) :: color_fondo_b
        character(len=50) :: posicion_x
        character(len=50) :: posicion_y 
    end type Container

    type(Container), ALLOCATABLE :: contenedor_array(:)

contains

    subroutine agregar_contenedor(id)
        character(len=*), intent(in) :: id
        type(Container) :: nuevo_contenedor
        integer :: n
        type(Container), ALLOCATABLE ::  temp_array(:)

        nuevo_contenedor%id = id
        nuevo_contenedor%tipo = 'Contenedor'
        nuevo_contenedor%alto = ""
        nuevo_contenedor%ancho = ""
        nuevo_contenedor%color_fondo_r = ""
        nuevo_contenedor%color_fondo_g = ""
        nuevo_contenedor%color_fondo_b = ""
        nuevo_contenedor%posicion_x = ""
        nuevo_contenedor%posicion_y = ""

        if (.not. allocated(contenedor_array)) then
            allocate(contenedor_array(1))
            contenedor_array(1) = nuevo_contenedor
        else
            n = size(contenedor_array)
            allocate(temp_array(n+1))
            temp_array(:n) = contenedor_array
            temp_array(n+1) = nuevo_contenedor
            deallocate(contenedor_array)
            contenedor_array = temp_array
        end if
    end subroutine agregar_contenedor

    subroutine contenedor_set_ancho(id, ancho)
        character(len=*), intent(in) :: id
        character(len=*), intent(in) :: ancho
        integer :: i
        if (.not. allocated(contenedor_array)) then
            print *, "No hay contenedores"
        else
            do i = 1, size(contenedor_array)
                if (contenedor_array(i)%id == id) then
                    contenedor_array(i)%ancho = ancho
                end if
            end do
        end if
    end subroutine contenedor_set_ancho

    subroutine contenedor_set_alto(id, alto)
        character(len=*), intent(in) :: id
        character(len=*), intent(in) :: alto
        integer :: i
        if (.not. allocated(contenedor_array)) then
            print *, "No hay contenedores"
        else
            do i = 1, size(contenedor_array)
                if (contenedor_array(i)%id == id) then
                    contenedor_array(i)%alto = alto
                end if
            end do
        end if
    end subroutine contenedor_set_alto

    subroutine contenedor_set_color_fondo(id, color_fondo_r, color_fondo_g, color_fondo_b)
        character(len=*), intent(in) :: id
        character(len=*), intent(in) :: color_fondo_r
        character(len=*), intent(in) :: color_fondo_g
        character(len=*), intent(in) :: color_fondo_b
        integer :: i
        if (.not. allocated(contenedor_array)) then
            print *, "No hay contenedores"
        else
            do i = 1, size(contenedor_array)
                if (contenedor_array(i)%id == id) then
                    contenedor_array(i)%color_fondo_r = color_fondo_r
                    contenedor_array(i)%color_fondo_g = color_fondo_g
                    contenedor_array(i)%color_fondo_b = color_fondo_b
                end if
            end do
        end if

    end subroutine contenedor_set_color_fondo

        subroutine contenedor_set_posicion(id, posicion_x,posicion_y)
        character(len=*), intent(in) :: id
        character(len=*), intent(in) :: posicion_x
        character(len=*), intent(in) :: posicion_y
        integer :: i
        if (.not. allocated(contenedor_array)) then
            print *, "No hay contenedores"
        else
            do i = 1, size(contenedor_array)
                if (contenedor_array(i)%id == id) then
                    contenedor_array(i)%posicion_x = posicion_x
                    contenedor_array(i)%posicion_y = posicion_y
                end if
            end do
        end if
    end subroutine contenedor_set_posicion


    ! Función para buscar un contenedor por su ID
    FUNCTION buscar_contenedor_por_id(id) RESULT(encontrado)
        CHARACTER(LEN=*), INTENT(IN) :: id
        logical :: encontrado
        integer :: i

        encontrado = .FALSE.

        if (.NOT. ALLOCATED(contenedor_array)) then
            print *, "No hay contenedores"
        else
            DO i = 1, size(contenedor_array)
                if (trim(contenedor_array(i)%id) == id) then
                    encontrado = .TRUE.
                    exit
                end if
            END DO
        end if

    end FUNCTION buscar_contenedor_por_id

    subroutine imprimir_contenedores()
    integer :: i

    if (.NOT. ALLOCATED(contenedor_array)) then
        print *, "No hay contenedores"
    else
        print *, "contenedores encontrados: ", size(contenedor_array)
        DO i = 1, size(contenedor_array)
            print *, 'id: ', trim(contenedor_array(i)%id)
            print *, 'alto: ', trim(contenedor_array(i)%alto)
            print *, 'ancho: ', trim(contenedor_array(i)%ancho)
            print *, 'color_fondo_r: ', trim(contenedor_array(i)%color_fondo_r)
            print *, 'color_fondo_g: ', trim(contenedor_array(i)%color_fondo_g)
            print *, 'color_fondo_b: ', trim(contenedor_array(i)%color_fondo_b)
            print *, 'posicion_x: ', trim(contenedor_array(i)%posicion_x)
            print *, 'posicion_y: ', trim(contenedor_array(i)%posicion_y)
            print *, '---------------------------------'
        END DO
    end if
    end subroutine imprimir_contenedores

end module contenedor