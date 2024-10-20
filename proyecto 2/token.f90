MODULE token
    use error
    use etiqueta
    use contenedor
    use boton
    use texto
    use clave
    use jerarquia
    implicit none

    type :: Tkn
        CHARACTER(LEN = 100) :: lexema
        CHARACTER(LEN = 200) :: tipo 
        integer :: fila
        integer :: columna
    End type Tkn

    ! Declaración de un arreglo de Tkn para almacenar los tokens
    type(Tkn), ALLOCATABLE ::  token_array(:)
    

contains

    ! Subrutina para agregar tokens a la lista de token
    subroutine agregar_token(lexema, tipo, fila, columna)
        CHARACTER(LEN=*), INTENT(IN) :: lexema
        CHARACTER(LEN=*), INTENT(IN) :: tipo
        integer :: fila
        integer :: columna
        type(Tkn) :: nuevo_token
        integer :: n
        type(Tkn), ALLOCATABLE ::  temp_array(:)
        
        !Inicializo los datos del nuevo token
        nuevo_token%lexema = lexema
        nuevo_token%tipo = tipo
        nuevo_token%fila = fila
        nuevo_token%columna = columna

        ! Agrego el nuevo token a la lista de tokens
        if (.NOT. ALLOCATED(token_array)) then !Si esta vacia
            ALLOCATE(token_array(1)) ! Se le asigna memoria para un token de la lista
            token_array(1) =  nuevo_token !Se convierte en el token nuevo
        else
            n = size(token_array)
            ALLOCATE(temp_array(n+1))
            temp_array(:n) = token_array !Reservo memoria
            temp_array(n+1) = nuevo_token
            DEALLOCATE(token_array) !Libero memoria
            ALLOCATE(token_array(n+1)) !Reservo memoria de nuevo
            token_array = temp_array
        end if
    end subroutine agregar_token
!;;;;;;;;;;;;;;;;;
SUBROUTINE crear_txt_tokens()
    IMPLICIT NONE
    INTEGER :: i, unidad
    CHARACTER(LEN=100) :: nombre_archivo
    CHARACTER(LEN=20) :: fila_str, columna_str
    TYPE(Tkn) :: nuevo_token

    ! Asigna el nombre del archivo
    nombre_archivo = 'tokens.txt'

    ! Abre el archivo para escritura
    OPEN(UNIT=unidad, FILE=nombre_archivo, STATUS='REPLACE', ACTION='WRITE')

    ! Escribe la cabecera en el archivo
    WRITE(unidad, '(A)') 'lexema,tipo,fila,columna'

    ! Recorre el arreglo de tokens y escribe cada uno en el archivo
    DO i = 1, SIZE(token_array)
        nuevo_token = token_array(i)

        ! Convertir fila y columna a cadenas
        WRITE(fila_str, '(I0)') nuevo_token%fila
        WRITE(columna_str, '(I0)') nuevo_token%columna

        WRITE(unidad, '(A, A, I0, I0)') TRIM(nuevo_token%lexema) // ", " // &
                                           TRIM(nuevo_token%tipo) // ", " // &
                                           TRIM(fila_str) // ", " // &
                                           TRIM(columna_str)
    END DO

    ! Cierra el archivo
    CLOSE(unidad)

    PRINT *, "Tokens guardados en el archivo: ", nombre_archivo
END SUBROUTINE crear_txt_tokens




    ! Subrutina para imprimir el listado de tokens en html
subroutine imprimir_tokens()
    integer :: i
    character(len=20) :: str_fila, str_columna
    integer :: file_unit

    ! Abre el archivo HTML para escritura
    open(unit=file_unit, file='tokens.html', status='replace', action='write')

    ! Escribir la cabecera HTML
    write(file_unit, '(A)') '<html><head><title>Tokens</title></head><body>' // new_line('a')
    write(file_unit, '(A)') '<h1>Listado de Tokens</h1>' // new_line('a')
    
    ! Escribir la cabecera de la tabla
    write(file_unit, '(A)') '<table border="1"><tr><th>Lexema</th><th>Tipo</th><th>Fila</th><th>Columna</th></tr>' // new_line('a')

    ! Verifica si la memoria ha sido asignada para el arreglo
    if (.NOT. ALLOCATED(token_array)) then
        write(file_unit, '(A)') '<p>No hay tokens</p>' // new_line('a')
    else
        write(file_unit, '(A)') '<p>Tokens encontrados: ' // trim(itoa(size(token_array))) // '</p>' // new_line('a')
        
        ! Recorre la lista de tokens y genera una fila para cada token
        DO i = 1, size(token_array)
            write(str_fila, '(I0)') token_array(i)%fila
            write(str_columna, '(I0)') token_array(i)%columna
            
            ! Escribir cada fila directamente al archivo
            write(file_unit, '(A)') '<tr><td>' // trim(token_array(i)%lexema) // '</td><td>' // &
                trim(token_array(i)%tipo) // '</td><td>' // trim(str_fila) // '</td><td>' // &
                trim(str_columna) // '</td></tr>' // new_line('a')
        END DO
    end if

    ! Cerrar la tabla y el HTML
    write(file_unit, '(A)') '</table>' // new_line('a')
    write(file_unit, '(A)') '</body></html>' // new_line('a')
    
    close(file_unit)
    
    ! Función auxiliar para convertir un entero a cadena (esto puede variar según el compilador)
    contains
    function itoa(num) result(str)
        integer, intent(in) :: num
        character(len=20) :: str
        write(str, '(I0)') num
    end function itoa
end subroutine imprimir_tokens

    !;;;;;;;;;;;;;;,

    subroutine parser()

        integer :: i

        ! Verifica si la memoria ha sido asignada para el arreglo
        if (.NOT. ALLOCATED(token_array)) then
            print *, "No hay tokens"
        else

            DO i = 1, size(token_array)

                if (token_array(i)%tipo == 'tk_etiqueta') then
                    if (token_array(i+1)%tipo == 'tk_id' .and. token_array(i+2)%tipo == 'tk_pyc' ) then
                        call agregar_etiqueta(token_array(i+1)%lexema)
                    else
                        call agregar_error(token_array(i+1)%lexema, 'tk_id', &
                        token_array(i+1)%fila, token_array(i+1)%columna )
                    end if
                end if

                ! Manejo de contenedores
                if (token_array(i)%tipo == 'tk_contenedor') then
                    if (token_array(i+1)%tipo == 'tk_id' .and. token_array(i+2)%tipo == 'tk_pyc') then
                        call agregar_contenedor(token_array(i+1)%lexema)
                    else
                        call agregar_error(token_array(i+1)%lexema, 'tk_id', &
                        token_array(i+1)%fila, token_array(i+1)%columna)
                    end if
                end if

                ! Manejo de botones
                if (token_array(i)%tipo == 'tk_boton') then
                    if (token_array(i+1)%tipo == 'tk_id' .and. token_array(i+2)%tipo == 'tk_pyc') then
                        call agregar_boton(token_array(i+1)%lexema)
                    else
                        call agregar_error(token_array(i+1)%lexema, 'tk_id', &
                        token_array(i+1)%fila, token_array(i+1)%columna)
                    end if
                end if

                ! Manejo de textos
                if (token_array(i)%tipo == 'tk_texto') then
                    if (token_array(i+1)%tipo == 'tk_id' .and. token_array(i+2)%tipo == 'tk_pyc') then
                        call agregar_texto(token_array(i+1)%lexema)
                    else
                        call agregar_error(token_array(i+1)%lexema, 'tk_id', &
                        token_array(i+1)%fila, token_array(i+1)%columna)
                    end if
                end if

                ! Manejo de claves 
                if (token_array(i)%tipo == 'tk_clave') then
                    if (token_array(i+1)%tipo == 'tk_id' .and. token_array(i+2)%tipo == 'tk_pyc') then
                        call agregar_clave(token_array(i+1)%lexema)
                    else
                        call agregar_error(token_array(i+1)%lexema, 'tk_id', &
                        token_array(i+1)%fila, token_array(i+1)%columna)
                    end if
                end if

                if (token_array(i)%tipo == 'tk_id' .and. token_array(i+1)%tipo == 'tk_punto' ) then

                    if(token_array(i+2)%tipo == 'tk_setAncho') then
                        if (token_array(i+3)%tipo .ne. 'tk_par_izq') then
                            call agregar_error(token_array(i+3)%lexema, 'tk_par_izq', &
                            token_array(i+3)%fila,token_array(i+3)%columna )

                        elseif (token_array(i+4)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+4)%lexema, 'tk_num', &
                            token_array(i+4)%fila,token_array(i+4)%columna )
                        
                        elseif (token_array(i+5)%tipo .ne. 'tk_par_der') then
                            call agregar_error(token_array(i+5)%lexema, 'tk_par_der', &
                            token_array(i+5)%fila,token_array(i+5)%columna )

                        elseif (token_array(i+6)%tipo .ne. 'tk_pyc') then
                            call agregar_error(token_array(i+6)%lexema, 'tk_pyc', &
                            token_array(i+6)%fila,token_array(i+6)%columna )
                        
                        else
                            ! Identificar el tipo de control
                            select case (get_control_type(token_array(i)%lexema))
                                case ('Etiqueta')
                                    call etiqueta_set_ancho(token_array(i)%lexema, token_array(i+4)%lexema)
                                case ('Contenedor')
                                    call contenedor_set_ancho(token_array(i)%lexema, token_array(i+4)%lexema)
                                case default
                                    call agregar_error(token_array(i)%lexema, 'tipo_control_invalido', &
                                    token_array(i)%fila, token_array(i)%columna)
                            end select
                        end if


                    end if

                    if(token_array(i+2)%tipo == 'tk_setAlto') then
                        if (token_array(i+3)%tipo .ne. 'tk_par_izq') then
                            call agregar_error(token_array(i+3)%lexema, 'tk_par_izq', &
                            token_array(i+3)%fila,token_array(i+3)%columna )

                        elseif (token_array(i+4)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+4)%lexema, 'tk_num', &
                            token_array(i+4)%fila,token_array(i+4)%columna )
                        
                        elseif (token_array(i+5)%tipo .ne. 'tk_par_der') then
                            call agregar_error(token_array(i+5)%lexema, 'tk_par_der', &
                            token_array(i+5)%fila,token_array(i+5)%columna )

                        elseif (token_array(i+6)%tipo .ne. 'tk_pyc') then
                            call agregar_error(token_array(i+6)%lexema, 'tk_pyc', &
                            token_array(i+6)%fila,token_array(i+6)%columna )
                        
                        else
                            ! Identificar el tipo de control
                            select case (get_control_type(token_array(i)%lexema))
                                case ('Etiqueta')
                                    call etiqueta_set_alto(token_array(i)%lexema, token_array(i+4)%lexema)
                                case ('Contenedor')
                                    call contenedor_set_alto(token_array(i)%lexema, token_array(i+4)%lexema)
                                case default
                                    call agregar_error(token_array(i)%lexema, 'tipo_control_invalido', &
                                    token_array(i)%fila, token_array(i)%columna)
                            end select
                        end if

                    end if


                    if(token_array(i+2)%tipo == 'tk_setTexto') then
                        if (token_array(i+3)%tipo .ne. 'tk_par_izq') then
                            call agregar_error(token_array(i+3)%lexema, 'tk_par_izq', &
                            token_array(i+3)%fila,token_array(i+3)%columna )

                        elseif (token_array(i+4)%tipo .ne. 'tk_literal') then
                            call agregar_error(token_array(i+4)%lexema, 'tk_literal', &
                            token_array(i+4)%fila,token_array(i+4)%columna )
                        
                        elseif (token_array(i+5)%tipo .ne. 'tk_par_der') then
                            call agregar_error(token_array(i+5)%lexema, 'tk_par_der', &
                            token_array(i+5)%fila,token_array(i+5)%columna )

                        elseif (token_array(i+6)%tipo .ne. 'tk_pyc') then
                            call agregar_error(token_array(i+6)%lexema, 'tk_pyc', &
                            token_array(i+6)%fila,token_array(i+6)%columna )
                        
                        else
                            ! Identificar el tipo de control
                            select case (get_control_type(token_array(i)%lexema))
                                case ('Etiqueta')
                                    call etiqueta_set_texto(token_array(i)%lexema, token_array(i+4)%lexema)
                                case ('Boton')
                                    call boton_set_texto(token_array(i)%lexema, token_array(i+4)%lexema)
                                case ('Texto')
                                    call texto_set_texto(token_array(i)%lexema, token_array(i+4)%lexema)
                                case ('Clave')
                                    call clave_set_texto(token_array(i)%lexema, token_array(i+4)%lexema)
                                case default
                                    call agregar_error(token_array(i)%lexema, 'tipo_control_invalido', &
                                    token_array(i)%fila, token_array(i)%columna)
                            end select
                            
                        end if

                    end if

                    if(token_array(i+2)%tipo == 'tk_setColorLetra') then
                        if (token_array(i+3)%tipo .ne. 'tk_par_izq') then
                            call agregar_error(token_array(i+3)%lexema, 'tk_par_izq', &
                            token_array(i+3)%fila,token_array(i+3)%columna )

                        elseif (token_array(i+4)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+4)%lexema, 'tk_num', &
                            token_array(i+4)%fila,token_array(i+4)%columna )
                        
                        elseif (token_array(i+5)%tipo .ne. 'tk_coma') then
                            call agregar_error(token_array(i+5)%lexema, 'tk_coma', &
                            token_array(i+5)%fila,token_array(i+5)%columna )

                        elseif (token_array(i+6)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+6)%lexema, 'tk_num', &
                            token_array(i+6)%fila,token_array(i+6)%columna )

                        elseif (token_array(i+7)%tipo .ne. 'tk_coma') then
                            call agregar_error(token_array(i+7)%lexema, 'tk_coma', &
                            token_array(i+7)%fila,token_array(i+7)%columna )

                        elseif (token_array(i+8)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+8)%lexema, 'tk_num', &
                            token_array(i+8)%fila,token_array(i+8)%columna )

                        elseif (token_array(i+9)%tipo .ne. 'tk_par_der') then
                            call agregar_error(token_array(i+9)%lexema, 'tk_par_der', &
                            token_array(i+9)%fila,token_array(i+9)%columna )

                        elseif (token_array(i+10)%tipo .ne. 'tk_pyc') then
                            call agregar_error(token_array(i+10)%lexema, 'tk_pyc', &
                            token_array(i+10)%fila,token_array(i+10)%columna )
                        
                        else
                            call etiqueta_set_color_texto(token_array(i)%lexema,&
                            token_array(i+4)%lexema, token_array(i+6)%lexema, token_array(i+8)%lexema )
                            
                        end if

                    end if

                    if(token_array(i+2)%tipo == 'tk_setColorFondo') then
                        if (token_array(i+3)%tipo .ne. 'tk_par_izq') then
                            call agregar_error(token_array(i+3)%lexema, 'tk_par_izq', &
                            token_array(i+3)%fila,token_array(i+3)%columna )

                        elseif (token_array(i+4)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+4)%lexema, 'tk_num', &
                            token_array(i+4)%fila,token_array(i+4)%columna )
                        
                        elseif (token_array(i+5)%tipo .ne. 'tk_coma') then
                            call agregar_error(token_array(i+5)%lexema, 'tk_coma', &
                            token_array(i+5)%fila,token_array(i+5)%columna )

                        elseif (token_array(i+6)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+6)%lexema, 'tk_num', &
                            token_array(i+6)%fila,token_array(i+6)%columna )

                        elseif (token_array(i+7)%tipo .ne. 'tk_coma') then
                            call agregar_error(token_array(i+7)%lexema, 'tk_coma', &
                            token_array(i+7)%fila,token_array(i+7)%columna )

                        elseif (token_array(i+8)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+8)%lexema, 'tk_num', &
                            token_array(i+8)%fila,token_array(i+8)%columna )

                        elseif (token_array(i+9)%tipo .ne. 'tk_par_der') then
                            call agregar_error(token_array(i+9)%lexema, 'tk_par_der', &
                            token_array(i+9)%fila,token_array(i+9)%columna )

                        elseif (token_array(i+10)%tipo .ne. 'tk_pyc') then
                            call agregar_error(token_array(i+10)%lexema, 'tk_pyc', &
                            token_array(i+10)%fila,token_array(i+10)%columna )

                        else
                            call contenedor_set_color_fondo(token_array(i)%lexema,&
                            token_array(i+4)%lexema, token_array(i+6)%lexema, token_array(i+8)%lexema )
                            
                        end if

                    end if

                    if(token_array(i+2)%tipo == 'tk_setPosicion') then
                        if (token_array(i+3)%tipo .ne. 'tk_par_izq') then
                            call agregar_error(token_array(i+3)%lexema, 'tk_par_izq', &
                            token_array(i+3)%fila,token_array(i+3)%columna )

                        elseif (token_array(i+4)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+4)%lexema, 'tk_num', &
                            token_array(i+4)%fila,token_array(i+4)%columna )
                        
                        elseif (token_array(i+5)%tipo .ne. 'tk_coma') then
                            call agregar_error(token_array(i+5)%lexema, 'tk_coma', &
                            token_array(i+5)%fila,token_array(i+5)%columna )

                        elseif (token_array(i+6)%tipo .ne. 'tk_num') then
                            call agregar_error(token_array(i+6)%lexema, 'tk_num', &
                            token_array(i+6)%fila,token_array(i+6)%columna )

                        elseif (token_array(i+7)%tipo .ne. 'tk_par_der') then
                            call agregar_error(token_array(i+7)%lexema, 'tk_par_der', &
                            token_array(i+7)%fila,token_array(i+7)%columna )

                        elseif (token_array(i+8)%tipo .ne. 'tk_pyc') then
                            call agregar_error(token_array(i+8)%lexema, 'tk_pyc', &
                            token_array(i+8)%fila,token_array(i+8)%columna )
                        
                        else
                        ! Identificar el tipo de control
                            select case (get_control_type(token_array(i)%lexema))
                                case ('Etiqueta')
                                    call etiqueta_set_posicion(token_array(i)%lexema, &
                                    token_array(i+4)%lexema, token_array(i+6)%lexema)
                                case ('Contenedor')
                                    call contenedor_set_posicion(token_array(i)%lexema, &
                                    token_array(i+4)%lexema, token_array(i+6)%lexema)
                                case ('Boton')
                                    call boton_set_posicion(token_array(i)%lexema, &
                                    token_array(i+4)%lexema, token_array(i+6)%lexema)
                                case ('Texto')
                                    call texto_set_posicion(token_array(i)%lexema, &
                                    token_array(i+4)%lexema, token_array(i+6)%lexema)
                                case ('Clave')
                                    call clave_set_posicion(token_array(i)%lexema, &
                                    token_array(i+4)%lexema, token_array(i+6)%lexema)
                                case default
                                    call agregar_error(token_array(i)%lexema, 'tipo_control_invalido', &
                                    token_array(i)%fila, token_array(i)%columna)
                            end select
                        end if
                    end if

                    if (token_array(i+2)%tipo == 'tk_add') then
                        if (token_array(i+3)%tipo .ne. 'tk_par_izq') then
                            call agregar_error(token_array(i+3)%lexema, 'tk_par_izq', &
                            token_array(i+3)%fila,token_array(i+3)%columna )

                        elseif (token_array(i+4)%tipo .ne. 'tk_id') then
                            call agregar_error(token_array(i+4)%lexema, 'tk_id', &
                            token_array(i+4)%fila,token_array(i+4)%columna )
                        
                        elseif (token_array(i+5)%tipo .ne. 'tk_par_der') then
                            call agregar_error(token_array(i+5)%lexema, 'tk_par_der', &
                            token_array(i+5)%fila,token_array(i+5)%columna )

                        elseif (token_array(i+6)%tipo .ne. 'tk_pyc') then
                            call agregar_error(token_array(i+6)%lexema, 'tk_pyc', &
                            token_array(i+6)%fila,token_array(i+6)%columna )

                        else
                            call set_jerarquia(token_array(i)%lexema, token_array(i+4)%lexema)
                        end if
                    end if
                            
                end if
            END DO
        end if



    end subroutine parser

    function get_control_type(control_name) result(control_type)
    character(len=*), intent(in) :: control_name
    character(len=10) :: control_type

    select case (control_name)
        case ('passw', 'Nombre', 'Carnet')
            control_type = 'Etiqueta'
        case ('contlogin','contFondo','ContBody','ContLogo1','contlogo2')
            control_type = 'Contenedor'
        case ('cmdIngresar')
            control_type = 'Boton'
        case ('Texto0', 'TextoCarnet')
            control_type = 'Texto'
        case ('pswClave')
            control_type = 'Clave'
        case default
            control_type = 'tipo_control_invalido'
    end select
end function get_control_type
    
END MODULE token
