program analizador
    use error
    use token

    implicit none
    integer :: len, fila, columna, estado, puntero
    integer :: ios, unidad
    character(len=100000) :: contenido, buffer
    character(len=1) :: char
    character(len=100) :: aux_tkn

    estado = 0
    puntero = 1
    columna = 0
    fila = 1
    aux_tkn = ""
    contenido = ""


    do
        read(*, '(A)', iostat=ios) buffer
        if (ios /= 0) exit  ! Salir del bucle al llegar al final del archivo
        contenido = trim(contenido) // trim(buffer) // new_line('a')
    end do


    len = len_trim(contenido)

    do while(puntero <= len)
        char = contenido(puntero:puntero)
        select case (estado)
            case (0)
                
                ! Verifica que el carácter sea una simbolo
                if (char == ';' .or. char == '-' .or. char == '.' .or. char == '(' .or. char == ')' .or. &
                char == ',' .or. char == '<' .or. char == '>' .or. char == '!') then
                    estado = 1
                    columna = columna + 1
                elseif ( char >= 'A' .and. char <= 'Z' .or. (char >= 'a' .and. char <= 'z') ) then
                    estado = 2
                
                elseif (char >= '0' .and. char <= '9' ) then
                    estado = 3

                elseif (char == '"') then
                    aux_tkn = trim(aux_tkn) // char
                    columna = columna + 1
                    puntero = puntero + 1 
                    estado = 4       

                elseif (ichar(char) == 10) then ! Actualizo la posicion
                    ! Salto de línea
                    columna = 0
                    fila = fila + 1
                    puntero = puntero + 1
                elseif (ichar(char) == 9) then
                    ! Tabulación
                    columna = columna + 4
                    puntero = puntero + 1
                elseif (ichar(char) == 32) then
                    ! Espacio en blanco
                    columna = columna + 1
                    puntero = puntero + 1  
            
                else
                    ! Reporta un error si el carácter no es válido
                    call agregar_error(char, 'Error Lexico', fila, columna)
                    columna = columna + 1
                    puntero = puntero + 1 

                end if
                
            case (1)
                if ( char == ';' ) then
                    call agregar_token(char, 'tk_pyc', fila, columna)
                    
                elseif ( char == '.' ) then
                    call agregar_token(char, 'tk_punto', fila, columna)

                elseif ( char == ',' ) then
                    call agregar_token(char, 'tk_coma', fila, columna)

                elseif ( char == '>') then
                    call agregar_token(char, 'tk_mayor', fila, columna)

                elseif ( char == '<') then
                    call agregar_token(char, 'tk_menor', fila, columna)

                elseif ( char == '(') then
                    call agregar_token(char, 'tk_par_izq', fila, columna)

                elseif ( char == ')') then
                    call agregar_token(char, 'tk_par_der', fila, columna)         
                
                elseif ( char == '-') then
                    call agregar_token(char, 'tk_guion', fila, columna)
                
                elseif ( char == '!') then
                    call agregar_token(char, 'tk_exp', fila, columna) 

                end if
                puntero = puntero + 1
                estado = 0

            case (2)
                if ( (char >= 'A' .and. char <= 'Z') .or. (char >= 'a' .and. char <= 'z') .or. &
                (char >= '0' .and. char <= '9' ) ) then
                    aux_tkn = trim(aux_tkn) // char
                    columna = columna + 1
                    puntero = puntero + 1
                    
                else
                    if ((aux_tkn == 'Contenedor')) then
                        call agregar_token(aux_tkn, 'tk_contenedor', fila, columna)

                    elseif ((aux_tkn == 'Etiqueta')) then
                        call agregar_token(aux_tkn, 'tk_etiqueta', fila, columna)
                    
                    elseif ((aux_tkn == 'Boton')) then
                        call agregar_token(aux_tkn, 'tk_boton', fila, columna)

                    elseif ((aux_tkn == 'Texto')) then
                        call agregar_token(aux_tkn, 'tk_texto', fila, columna)

                    elseif ((aux_tkn == 'Clave')) then
                        call agregar_token(aux_tkn, 'tk_clave', fila, columna)
                    
                    elseif ((aux_tkn == 'setAncho')) then
                        call agregar_token(aux_tkn, 'tk_setAncho', fila, columna)
                    
                    elseif ((aux_tkn == 'setAlto')) then
                        call agregar_token(aux_tkn, 'tk_setAlto', fila, columna)
                    
                    elseif ((aux_tkn == 'setColorFondo')) then
                        call agregar_token(aux_tkn, 'tk_setColorFondo', fila, columna)

                    elseif ((aux_tkn == 'setColorLetra')) then
                        call agregar_token(aux_tkn, 'tk_setColorLetra', fila, columna)
                    
                    elseif ((aux_tkn == 'setTexto')) then
                        call agregar_token(aux_tkn, 'tk_setTexto', fila, columna)

                    elseif ((aux_tkn == 'setPosicion')) then
                        call agregar_token(aux_tkn, 'tk_setPosicion', fila, columna)
                    
                    elseif (aux_tkn == 'this') then
                        call agregar_token(aux_tkn, 'tk_this', fila, columna)
                    
                    elseif (aux_tkn == 'add') then
                        call agregar_token(aux_tkn, 'tk_add', fila, columna)

                    else 
                        call agregar_token(aux_tkn, 'tk_id', fila, columna)

                    end if
                    aux_tkn = ""
                    estado = 0      
                        
                end if

            case (3)
                if (char >= '0' .and. char <= '9' ) then
                    aux_tkn = trim(aux_tkn) // char
                    columna = columna + 1
                    puntero = puntero + 1
                    
                else
                    call agregar_token(aux_tkn, 'tk_num', fila, columna)
                
                    aux_tkn = ""
                    estado = 0
                end if

            case (4)
                if (ichar(char) >= 0 .and. ichar(char) <= 255 .and. char .ne. '"') then
                    aux_tkn = trim(aux_tkn) // char
                    columna = columna + 1
                    puntero = puntero + 1 

                    estado = 6

                else if ( char == '"') then
                    
                    estado = 5

                else
                    call agregar_error(aux_tkn, 'Error lexico', fila, columna)

                    aux_tkn = ""
                    estado = 0
                
                end if

            case (5)
                
                aux_tkn = trim(aux_tkn) // char
                columna = columna + 1
                puntero = puntero + 1

                call agregar_token(aux_tkn, 'tk_literal', fila, columna)
                
                aux_tkn = ""
                estado = 0
                    
            case (6)
                if (ichar(char) >= 0 .and. ichar(char) <= 255 .and. char .ne. '"') then
                    aux_tkn = trim(aux_tkn) // char
                    columna = columna + 1
                    puntero = puntero + 1 

                elseif ( char == '"') then
                    estado = 5
                else
                    call agregar_error(aux_tkn, 'Error lexico', fila, columna)

                    aux_tkn = ""
                    estado = 0
                end if             

        end select
    end do
    
    call parser
    
    !call imprimir_errores

    
    
    !call imprimir_tokens

    !call imprimir_etiquetas
    
    !call imprimir_contenedores

    !call imprimir_botones

    !call imprimir_textos

    !call imprimir_claves

    call generar_css

    call imprimir_jerarquia

    call generar_html
        
    !call imprimir_tokens
    !call crear_txt_tokens
    call imprimir_errores
end program analizador


subroutine generar_css()
    use etiqueta
    use contenedor
    use boton
    use texto
    use clave
    implicit none
    integer :: iunit
    character(len=255) :: control, posicion, color
    integer :: i

    ! Abrimos el archivo CSS para escritura
    open(unit=10, file='LFP_1.css', status='replace')

    do i = 1, size(etiqueta_array)
        control = "#"// trim(etiqueta_array(i)%id)
        posicion = "position: absolute; top: "// trim(etiqueta_array(i)%posicion_y) &
        //"px; left: "// trim(etiqueta_array(i)%posicion_x) //"px; width: "// &
        trim(etiqueta_array(i)%ancho) //"px; height: "// trim(etiqueta_array(i)%alto) //"px;"
        color = "color: rgb(" // trim(etiqueta_array(i)%color_texto_r) // "," &
        // trim(etiqueta_array(i)%color_texto_g) // "," // trim(etiqueta_array(i)%color_texto_b) // ");"
        call escribir_css(10, control, posicion, color)
    end do

    do i = 1, size(contenedor_array)
        control = "#"// trim(contenedor_array(i)%id)
        posicion = "position: absolute; top: "// trim(contenedor_array(i)%posicion_y) &
        //"px; left: "// trim(contenedor_array(i)%posicion_x) //"px; width: "// &
        trim(contenedor_array(i)%ancho) //"px; height: "// trim(contenedor_array(i)%alto) //"px;"
        color = "background-color: rgb(" // trim(contenedor_array(i)%color_fondo_r) // "," &
        // trim(contenedor_array(i)%color_fondo_g) // "," // trim(contenedor_array(i)%color_fondo_b) // ");"
        call escribir_css(10, control, posicion, color)
    end do

    do i = 1, size(boton_array)
        control = "#"// trim(boton_array(i)%id)
        posicion = "position: absolute; top: "// trim(boton_array(i)%posicion_y) &
        //"px; left: "// trim(boton_array(i)%posicion_x) //"px;"
        color = ""
        call escribir_css(10, control, posicion, color)
    end do

    do i = 1, size(texto_array)
        control = "#"// trim(texto_array(i)%id)
        posicion = "position: absolute; top: "// trim(texto_array(i)%posicion_y) &
        //"px; left: "// trim(texto_array(i)%posicion_x) //"px;"
        color = ""
        call escribir_css(10, control, posicion, color)
    end do

    do i = 1, size(clave_array)
        control = "#"// trim(clave_array(i)%id)
        posicion = "position: absolute; top: "// trim(clave_array(i)%posicion_y) &
        //"px; left: "// trim(clave_array(i)%posicion_x) //"px;"
        color = ""
        call escribir_css(10, control, posicion, color)
    end do


    ! Cerramos el archivo
    close(10)
contains
    subroutine escribir_css(iunit, control,posicion, color )
        integer, intent(in) :: iunit
        character(len=*), intent(in) :: control, posicion, color

        write(iunit, '(A)') trim(control) // " {" // trim(posicion) // trim (color) // "}"
    end subroutine escribir_css
end subroutine generar_css

subroutine generar_html()
    use etiqueta
    use contenedor
    use boton
    use texto
    use clave
    use jerarquia
    implicit none
    integer :: i, j
    logical :: encontrado

    ! Abrimos el archivo HTML para escritura
    open(unit=11, file='LFP_1.html', status='replace')

    ! Escribimos el encabezado del HTML
    write(11, '(A)') '<!DOCTYPE html>'
    write(11, '(A)') '<html lang="es">'
    write(11, '(A)') '<head>'
    write(11, '(A)') '    <meta charset="UTF-8">'
    write(11, '(A)') '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    write(11, '(A)') '    <title>LFP_1</title>'
    write(11, '(A)') '    <link rel="stylesheet" href="LFP_1.css">'
    write(11, '(A)') '</head>'
    write(11, '(A)') '<body>'

    ! Escribimos los contenedores principales (los que no son hijos de otros)
    do i = 1, size(contenedor_array)
        encontrado = .false.
        do j = 1, size(jerarquia_array)
            if (trim(contenedor_array(i)%id) == trim(jerarquia_array(j)%hijo)) then
                encontrado = .true.
                exit
            end if
        end do
        if (.not. encontrado) then
            call escribir_contenedor(contenedor_array(i)%id, 1)
        end if
    end do

    ! Cerramos el body y el html
    write(11, '(A)') '</body>'
    write(11, '(A)') '</html>'

    ! Cerramos el archivo
    close(11)

contains

    recursive subroutine escribir_contenedor(id, nivel)
        character(len=*), intent(in) :: id
        integer, intent(in) :: nivel
        character(len=100) :: indentacion
        integer :: k

        indentacion = repeat('    ', nivel)

        write(11, '(A)') trim(indentacion) // '<div id="' // trim(id) // '">'

        ! Escribimos los hijos de este contenedor
        do k = 1, size(jerarquia_array)
            if (trim(jerarquia_array(k)%padre) == trim(id)) then
                call escribir_elemento(trim(jerarquia_array(k)%hijo), nivel + 1)
            end if
        end do

        write(11, '(A)') trim(indentacion) // '</div>'
    end subroutine escribir_contenedor

    subroutine escribir_elemento(id, nivel)
        character(len=*), intent(in) :: id
        integer, intent(in) :: nivel
        character(len=100) :: indentacion
        integer :: k

        indentacion = repeat('    ', nivel)

        ! Buscar el elemento en los diferentes arrays y escribirlo
        do k = 1, size(contenedor_array)
            if (trim(contenedor_array(k)%id) == trim(id)) then
                call escribir_contenedor(id, nivel)
                return
            end if
        end do

        do k = 1, size(etiqueta_array)
            if (trim(etiqueta_array(k)%id) == trim(id)) then
                write(11, '(A)') trim(indentacion) // '<label id="' // &
                trim(id) // '">' // trim(adjustl(etiqueta_array(k)%texto &
                (2:len_trim(etiqueta_array(k)%texto)-1))) // '</label>'
                return
            end if
        end do

        do k = 1, size(boton_array)
            if (trim(boton_array(k)%id) == trim(id)) then
                write(11, '(A)') trim(indentacion) // '<button id="' // &
                trim(id) // '">' // trim(adjustl(boton_array(k)%texto &
                (2:len_trim(boton_array(k)%texto)-1))) // '</button>'
                return
            end if
        end do

        do k = 1, size(texto_array)
            if (trim(texto_array(k)%id) == trim(id)) then
                write(11, '(A)') trim(indentacion) // '<input type="text" id="' &
                // trim(id) // '" value="' // trim(texto_array(k)%texto) // '">'
                return
            end if
        end do

        do k = 1, size(clave_array)
            if (trim(clave_array(k)%id) == trim(id)) then
                write(11, '(A)') trim(indentacion) // '<input type="password" id="' &
                // trim(id) // '">'
                return
            end if
        end do
    end subroutine escribir_elemento
end subroutine generar_html