program analizador_lexico
    implicit none
    integer :: i, len, linea, columna, estado, puntero, numErrores, file_unit, ios,numToken, columnaToken
    integer :: espacio_texto
    logical :: cadena, porcentaje !esta se utilizara para separa el contexto de : y %
     ! Definición de un tipo que almacena la información del error
    type :: ErrorInfo
        character(len=10) :: caracter  ! caracter
        character(len=100) :: descripcion  ! Descripción del error
        integer :: columna      ! Columna donde ocurrió el error
        integer :: linea        ! Línea donde ocurrió el error
    end type ErrorInfo

    ! Definición de un tipo que almacena la información de un token
    type :: TokenType
        character(len=200) :: lexema
        character(len=100) :: tipo_lexema
        integer :: linea
        integer :: columna
    end type TokenType

    ! Definición de un tipo que almacena la información de los tokens para las palabras reservadas
    type :: tokensA
        character(len=100) :: lexema
    end type tokensA

    ! Declaración de un arreglo de tokens de tipo TokenType
    type(TokenType), dimension(2000) :: tokens

    ! Declaración de un arreglo de tokens de tipo tokensAprobados
    type(tokensA), dimension(7) :: tokensAprobados


    ! Declaración de un arreglo de errores de tipo ErrorInfo
    type(ErrorInfo), dimension(2000) :: errores
    character(len=1) :: char 
    character(len=500) :: tkn
    character(len=100) :: name
    character(len=10000) :: graf
    character(len=1), dimension(26) :: A 
    character(len=1), dimension(26) :: M

    !caracter para el graphiz
    character(len=30) :: nombregrafica,axuxiliar 
    logical :: validarnombre
    character(len=50) :: nombrecontinente
    character(len=1000) :: nombrepais
    logical :: validarcontinente, agregarcontinente
    logical :: validarpais,agregarpais, acceso
    

    !variables de porcentaje 
    character(len=100) :: validarsaturacion,val
    character(len=20) :: aguardarsaturacion
    logical :: porcen
    integer :: integervalue, suma
    !variable para suma de saturación continente
    integer :: saturacioncontinente
    integer :: sumarpaises
    !convertir 
    !character(len=1), dimension(1) :: D 
    !character(len=1), dimension(1) :: P 
    !character(len=1), dimension(1) :: Y
    !character(len=1), dimension(1) :: C 
 
    character(len=1), dimension(10) :: N
    character(len=1) :: char_error
    !type(TokenType), dimension(5) :: T
    character(len=3000) :: buffer, contenido
    character(len=10) :: str_codigo_ascii, str_columna, str_linea
    ! Variables para el archivo HTML

    contenido = ''  ! Inicializa contenido vacío

    ! Lee el contenido desde la entrada estándar
    do
        read(*, '(A)', IOSTAT=ios) buffer
        if (ios /= 0) exit 
        contenido = trim(contenido) // trim(buffer) // new_line('a') ! concatenamos el 
        !contenido mas lo que viene en el buffer y como leemos por el salto de linea al final
    end do

    A = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    M = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
    !S = ['%','&','*','+',',','-', '.', '/', ';', '<', '=', '>', '?', '@', '[', '\', ']', '^', '_', '`', '{', '|', '}', '~']
    N = ['1','2','3','4','5','6','7','8','9','0']

    !guardamos en tokensAprobados las palabras reservadas
    tokensAprobados(1)%lexema = 'grafica'
    tokensAprobados(2)%lexema = 'nombre'
    tokensAprobados(3)%lexema = 'continente'
    tokensAprobados(4)%lexema = 'pais'
    tokensAprobados(5)%lexema = 'poblacion'
    tokensAprobados(6)%lexema = 'saturacion'
    tokensAprobados(7)%lexema = 'bandera'

    estado = 0
    puntero = 1
    columna = 1
    columnaToken = 0
    linea = 1
    numErrores = 0
    numToken = 0    
    cadena = .FALSE.
    porcentaje = .FALSE.
    tkn = ''
    ! :::::::::: para generara el graphiz
    acceso = .FALSE.
    nombregrafica = ''
    validarnombre = .TRUE. !nombre del grafico
    validarpais = .FALSE.
    validarcontinente = .FALSE.
    nombrecontinente =''
    agregarcontinente = .FALSE.
    agregarpais = .FALSE.
    graf = ''
    nombrepais = ''
    axuxiliar = ''
    ! validar saturacion
    validarsaturacion = '' !aguarda los numero concatenadios
    aguardarsaturacion ='' !el que valida si viene porcentaje
    porcen = .FALSE.    !cierra y abre la lectura

    len = len_trim(contenido) 

    do while (puntero <= len)
        char = contenido(puntero:puntero)
        !graphiz
        if (puntero == len) then
            suma = saturacioncontinente/sumarpaises
            if (suma <= 15) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="white">' // &
                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="white">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
            elseif (suma <= 30) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="blue">' // &
                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="blue">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
            elseif (suma <= 45) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="green">' // &
                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="green">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
            elseif (suma <= 60) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="yellow">' // &
                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="yellow">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
            elseif (suma <= 75) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="orange">' // &
                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="orange">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
            elseif (suma <= 100) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="red">' // &
                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="red">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
            end if
            print*,suma
            print*,nombrecontinente, "saturación", saturacioncontinente/sumarpaises

            graf = trim(graf) // new_line('a')// "}"
            
            !print*, graf
            
        end if
        if (agregarcontinente) then    ! agrego el contiente
            graf = trim(graf) // new_line('a') // '"' // trim(nombregrafica) // '"' // &
       " -> " // '"' // trim(nombrecontinente) // '"'
                        
            
            agregarcontinente = .FALSE. !sino se queda abierto 
            saturacioncontinente = 0
            sumarpaises = 0
            
            
            !pasa a false
            
        end if
        if (agregarpais ) then
            if (len_trim(nombrepais) > 0) then
                if(porcen) then
                    validarsaturacion = trim(validarsaturacion) 
                    
                    !print*, validarsaturacion
                    read(validarsaturacion, *) integervalue
                    saturacioncontinente = saturacioncontinente + integervalue
                    sumarpaises = sumarpaises +1
                    print*, saturacioncontinente
                    print*, sumarpaises
                    !print*, integervalue
                    !print*, nombrepais
                    if (integervalue <= 15) then
                        graf = trim(graf) // new_line('a') //trim(nombrepais) // '[label=<<table border="0" cellborder="1" ' // &
                    'cellspacing="0"><tr><td bgcolor="white">' // trim(nombrepais) // '</td></tr><tr><td bgcolor="white">' // &
                    trim(itoa(integervalue)) // '%</td></tr></table>>, shape=Msquare];'
                    elseif (integervalue <= 30) then
                        graf = trim(graf) // new_line('a') //trim(nombrepais) // '[label=<<table border="0" cellborder="1" ' // & 
                    'cellspacing="0"><tr><td bgcolor="blue">' // trim(nombrepais) // '</td></tr><tr><td bgcolor="blue">' // &
                    trim(itoa(integervalue)) // '%</td></tr></table>>, shape=Msquare];'
                    elseif (integervalue <= 45) then
                        graf = trim(graf) // new_line('a') //trim(nombrepais) // '[label=<<table border="0" cellborder="1" ' // &
                    'cellspacing="0"><tr><td bgcolor="green">' // trim(nombrepais) // '</td></tr><tr><td bgcolor="green">' // &
                    trim(itoa(integervalue)) // '%</td></tr></table>>, shape=Msquare];'
                    elseif (integervalue <= 60) then
                        graf = trim(graf) // new_line('a') //trim(nombrepais) // '[label=<<table border="0" cellborder="1" '// & 
                    'cellspacing="0"><tr><td bgcolor="yellow">' // trim(nombrepais) // '</td></tr><tr><td bgcolor="yellow">' // &
                    trim(itoa(integervalue)) // '%</td></tr></table>>, shape=Msquare];'
                    elseif (integervalue <= 75) then
                        graf = trim(graf) // new_line('a') //trim(nombrepais) // '[label=<<table border="0" cellborder="1" ' // & 
                    'ellspacing="0"><tr><td bgcolor="orange">' // trim(nombrepais) // '</td></tr><tr><td bgcolor="orange">' // &
                    trim(itoa(integervalue)) // '%</td></tr></table>>, shape=Msquare];'
                    elseif (integervalue <= 100) then
                        graf = trim(graf) // new_line('a') //trim(nombrepais) // '[label=<<table border="0" cellborder="1" ' // & 
                    'cellspacing="0"><tr><td bgcolor="red">' // trim(nombrepais) // '</td></tr><tr><td bgcolor="red">' // &
                    trim(itoa(integervalue)) // '%</td></tr></table>>, shape=Msquare];'
                    end if
                    !print *, validarsaturacion // nombrepais
                    validarsaturacion =''
                    nombrepais = trim(nombrepais) // achar(10) // trim(validarsaturacion)
                    !print*, 'Pais:', trim(nombrepais)
                    graf = trim(graf) // new_line('a') // trim(nombrecontinente) // " -> " // trim(nombrepais)
                
                    nombrepais = ''
                    porcen = .FALSE.
                end if
                
            else
            
            end if

            ! Reinicializar la variable
            
            agregarcontinente = .FALSE.
            agregarpais = .FALSE.
        end if
        
        if (ichar(char) == 10) then
            ! salto de linea
            columna = 1
            linea = linea + 1
            puntero = puntero + 1
        elseif (ichar(char) == 9) then
            ! tabulacion
            columna = columna + 4
            puntero = puntero + 1
        elseif (ichar(char) == 32) then
            ! espacio en blanco
            columna = columna + 1
            puntero = puntero + 1
            !numToken = numToken + 1
            !tokens(numToken) = TokenType(' ', 'Espacio', linea, columna)
        elseif (ichar(char) == 59) then
            !punto y coma
            if (porcentaje .eqv. .TRUE.) then
                numToken = numToken + 1
                tokens(numToken) = TokenType(tkn, 'Cadena de Numeros', linea, columna)
                porcentaje = .FALSE.
            else if (tkn .eq. '') then

            else
                numToken = numToken + 1
                tokens(numToken) = TokenType(tkn, 'Cadena', linea, columnaToken)
            end if
            columna = columna + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType(';', 'Punto y coma', linea, columna)
            estado = 0
            puntero = puntero + 1
        else if (ichar(char) == 125) then
            !llave de cierre
            columna = columna + 1
            puntero = puntero + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType('}', 'Cierra Llave', linea, columna)
            estado = 0
        else if (ichar(char) == 123) then
            !abrir llave
            columna = columna + 1
            puntero = puntero + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType('{', 'Abre Llave', linea, columna)
            ! kkkkkk
            
            estado = 0
        else if (ichar(char) == 58) then !aqui debe guardar un token palabra reservada
            !dos puntos
            
            
            
            if (cadena .eqv. .TRUE.) then
                columna = columna + 1
                tkn = trim(tkn) // char
                estado = 3
            else
                numToken = numToken + 1
                do i = 1, size(tokensAprobados)
                    if (trim(tokensAprobados(i)%lexema) == trim(tkn)) then
                        tokens(numToken) = TokenType(tkn, 'Palabra Reservada', linea, columnaToken)
                        exit
                        
                    end if
                end do
                columna = columna + 1
                numToken = numToken + 1
                !comparando grafica para iniciar el graphiz 
                if ('grafica' == trim(tkn)) then    !va a inciar el grafico
                        graf = 'digraph G {' 
                        !// new_line('a') // 'node [shape=component];'

                        
                else if ('continente' == trim(tkn)) then
                        
                        axuxiliar = 'continente'
                        if (len_trim(nombrecontinente) > 0) then
                            suma = saturacioncontinente/sumarpaises
                            !print*,nombrecontinente, "saturación", saturacioncontinente/sumarpaises
                            !print*, ""
                            if (suma <= 15) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="white">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="white">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
                            elseif (suma <= 30) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="blue">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="blue">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
                            elseif (suma <= 45) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="green">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="green">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
                            elseif (suma <= 60) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="yellow">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="yellow">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
                            elseif (suma <= 75) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="orange">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="orange">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
                            elseif (suma <= 100) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="red">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="red">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=tripleoctagon];'
                            end if
                        end if
                        nombrecontinente =''
                        validarcontinente = .TRUE.
                        validarpais = .FALSE.  !solo para el pais
                        acceso = .FALSE.  !solo para el pais


                else if ('pais' == trim(tkn)) then
                        ! validarcontinente = .FALSE.
                        !validarpais = .TRUE.
                        axuxiliar = 'pais'
                        acceso = .TRUE.
                
                else if (acceso) then
                        if ('nombre' == trim(tkn)) then
                            validarcontinente = .FALSE.
                            validarpais = .TRUE.
                            axuxiliar = 'pais'
                        else if('saturacion' == trim(tkn)) then
                            aguardarsaturacion = 'saturacion'
                        end if

                        
                
                
                end if
                
                tokens(numToken) = TokenType(':', 'Dos Puntos', linea, columna)
                estado = 2
                tkn = ''    !reiniciamos el tkn luego de agregarlo

            end if
            puntero = puntero + 1
        else if (ichar(char) == 37) then ! aqui debe guardar una cadena de numeros
            !porcentaje
            !print*, validarsaturacion
            porcen = .TRUE.
            aguardarsaturacion =''
            numToken = numToken + 1
            tokens(numToken) = TokenType(tkn, 'Cadena de Numeros', linea, columna)
            columna = columna + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType('%', 'Por ciento', linea, columna)
            puntero = puntero + 1
            estado = 0
            porcentaje = .FALSE.
            tkn = ''
        else
            select case (estado)
                case (0)
                    if (any(char == M)) then
                        estado = 1
                        columna = columna + 1
                        tkn = char! Inicia la cadena de caracteres
                        columnaToken = columna   !se setea la columna donde empieza el token
                
                    else
                        numErrores = numErrores + 1
                        columna = columna + 1
                        estado = 1
                        errores(numErrores) = ErrorInfo(char, "Error no pertenece al lenguaje M estado 0", columna, linea)

                    end if
                    puntero = puntero + 1
                case (1)
                    
                    if (any(char == M)) then
                    
                        estado = 1
                        columna = columna + 1
                        tkn = trim(tkn) // char ! Agrega el caracter a la cadena
                    
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene a S O M estado 1", columna, linea)
                        columna = columna + 1
                        estado = 1
                    end if
                    puntero = puntero + 1
                case (2)
                    if (any(char == M)) then ! si lee una minuscula empieza la cadena
                        estado = 1
                        columna = columna + 1
                        tkn = char
                        columnaToken = columna   !se setea la columna donde empieza el token
                    else if (any(char == N)) then ! si se lee un numero empieza la cadena
                        if (aguardarsaturacion == 'saturacion') then
                            !print*,char
                            validarsaturacion = trim(validarsaturacion) // char
                        end if
                        columna = columna + 1
                        estado = 3
                        tkn = char ! Inicia la cadena de caracteres
                        columnaToken = columna   !se setea la columna donde empieza el token
                        porcentaje = .TRUE.
                    else if (ichar(char) == 34) then ! si se lee una comilla doble empieza la cadena
                        columna = columna + 1
                        estado = 3  ! agregar a tabla de tokens el tkn y el char
                        tkn = char ! Inicia la cadena de caracteres
                        columnaToken = columna   !se setea la columna donde empieza el token
                        cadena = .TRUE.
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene a M y S estado 3", columna, linea)
                        columna = columna + 1
                        estado = 3
                    
                    end if
                    puntero = puntero + 1
                case (3)
                    if (ichar(char) == 34) then ! cierra comillas dobles
                        columna = columna + 1
                        tkn = trim(tkn) // char
                        estado = 0  ! agregar a tabla de tokens el tkn y el char
                        cadena = .FALSE.
                        !se valida la variable de la grafica el nombre una vez
                        validarnombre = .FALSE.  !validar nombre de graphizn

                        validarpais = .FALSE.
                        if (axuxiliar == 'continente') then 
                            agregarcontinente = .TRUE.  !aqui activa el primer if 
                        elseif (axuxiliar == 'pais') then
                            agregarpais = .TRUE.   !pasa true en el primer if 
                        end if 
                    else if (ichar(char) /= 34) then
                        
                        estado = 3
                        columna = columna + 1
                        tkn = trim(tkn) // char
                        !name = trim(name) // char
                        ! validamos una vez el nombre
                        if (validarnombre) then  !validar nombre de grafiz 
                            nombregrafica = trim(nombregrafica) // char
                        
                        end if 
                        if (validarcontinente) then
                            nombrecontinente = trim(nombrecontinente) // char !concatenar el nomre continente
                            !print*, nombrecontinente
                        end if
                        if (validarpais) then    !concatena el nombre
                            nombrepais = trim(nombrepais) // char
                        end if
                        if(aguardarsaturacion == 'saturacion') then
                            validarsaturacion = trim(validarsaturacion) // char 
                            
                        end if
                    end if
                    puntero = puntero + 1
            end select
        end if
    end do

    ! Si hay errores, se crea el archivo HTML
    if (numErrores > 0) then
    ! Se crea el archivo HTML con los errores
        call generar_html_errores(numErrores, errores)
        call generate_graphviz(graf)
    else
        call generar_html_tokens(numToken, tokens)
        call generate_graphviz(graf)
        print *, "No hay errores en el código."
end if

contains


subroutine generar_html_errores(numErrores, errores)
    implicit none
    integer, intent(in) :: numErrores
    type(ErrorInfo), intent(in) :: errores(numErrores)
    character(len=100000) :: html_content
    character(len=100) :: str_descripcion, str_columna, str_linea, char_error
    integer :: i
    integer :: file_unit, ios

    if (numErrores > 0) then
        ! Abrir el archivo para escribir
        open(unit=file_unit, file="reporte.html", status="replace", action="write", iostat=ios)
        if (ios /= 0) then
            print *, "Error al crear el archivo HTML."
        else
            ! Escribir la cabecera del HTML directamente al archivo
            write(file_unit, '(A)') '<!DOCTYPE html>' // new_line('a')
            write(file_unit, '(A)') '<html><head><style>' // new_line('a')
            write(file_unit, '(A)') 'table { font-family: Arial, sans-serif;'
            write(file_unit, '(A)') 'border-collapse: collapse; width: 100%; }' // new_line('a')
            write(file_unit, '(A)') 'td, th { border: 1px solid #dddddd; text-align: left; padding: 8px; }' // new_line('a')
            write(file_unit, '(A)') 'tr:nth-child(even) { background-color: #f2f2f2; }' // new_line('a')
            write(file_unit, '(A)') '</style></head><body><h2>Tabla de Errores</h2>' // new_line('a')
            write(file_unit, '(A)') '<table><tr><th>No</th><th>Carácter</th><th>Descripcion' 
            write(file_unit, '(A)') '</th><th>Columna</th><th>Línea</th></tr>' // new_line('a')

            ! Bucle para formatear cada código ASCII y cada columna

            ! Bucle para agregar filas a la tabla
            do i = 1, numErrores
                write(str_descripcion, '(A)') trim(errores(i)%descripcion)
                write(str_columna, '(I0)') errores(i)%columna
                write(str_linea, '(I0)')  errores(i)%linea
                write(char_error, '(A)') trim(errores(i)%caracter)
                
                ! Escribir cada fila directamente al archivo
                write(file_unit, '(A)') '<tr><td>' // trim(itoa(i)) // '</td><td>' // trim(char_error) // '</td><td>' // &
                    trim(str_descripcion) // '</td><td>' // trim(str_columna) // '</td><td>' // &
                    trim(str_linea) // '</td></tr>' // new_line('a')
            end do

            ! Cerrar la tabla y el HTML
            write(file_unit, '(A)') '</table></body></html>'
            close(file_unit)
        end if
    else
        print *, "No hay errores en el código."
    end if
end subroutine generar_html_errores

subroutine generar_html_tokens(numToken, tokens)
    implicit none
    integer, intent(in) :: numToken
    type(TokenType), intent(in) :: tokens(numToken)
    character(len=100000) :: html_content
    character(len=100) :: str_descripcion, str_columna, str_linea, Tlexema
    integer :: i
    integer :: file_unit, ios

    if (numErrores == 0) then
        ! Abrir el archivo para escribir
        open(unit=file_unit, file="reporte.html", status="replace", action="write", iostat=ios)
        if (ios /= 0) then
            print *, "Error al crear el archivo HTML."
        else
            ! Escribir la cabecera del HTML directamente al archivo
            write(file_unit, '(A)') '<!DOCTYPE html>' // new_line('a')
            write(file_unit, '(A)') '<html><head><style>' // new_line('a')
            write(file_unit, '(A)') 'table { font-family: Arial, sans-serif;'
            write(file_unit, '(A)') 'border-collapse: collapse; width: 100%; }' // new_line('a')
            write(file_unit, '(A)') 'td, th { border: 1px solid #dddddd; text-align: left; padding: 8px; }' // new_line('a')
            write(file_unit, '(A)') 'tr:nth-child(even) { background-color: #f2f2f2; }' // new_line('a')
            write(file_unit, '(A)') '</style></head><body><h2>Tabla de Tokens</h2>' // new_line('a')
            write(file_unit, '(A)') '<table><tr><th>No</th><th>Lexema</th><th>Descripcion' 
            write(file_unit, '(A)') '</th><th>Columna</th><th>Línea</th></tr>' // new_line('a')

            ! Bucle para formatear cada código ASCII y cada columna

            ! Bucle para agregar filas a la tabla
            do i = 1, numToken
            ! Obtener el lexema del token

                !print '(I10)', numToken
                write(str_descripcion, '(A)') trim(tokens(i)%tipo_lexema)
                write(str_columna, '(I0)') tokens(i)%columna
                write(str_linea, '(I0)')  tokens(i)%linea
                write(Tlexema, '(A)') trim(tokens(i)%lexema)
                
                ! Escribir cada fila directamente al archivo
                write(file_unit, '(A)') '<tr><td>' // trim(itoa(i)) // '</td><td>' // trim(Tlexema) // '</td><td>' // &
                    trim(str_descripcion) // '</td><td>' // trim(str_columna) // '</td><td>' // &
                    trim(str_linea) // '</td></tr>' // new_line('a')
            end do

            ! Cerrar la tabla y el HTML
            write(file_unit, '(A)') '</table></body></html>'
            close(file_unit)
        end if
    else
        print *, "No hay errores en el código."
    end if
end subroutine generar_html_tokens

    function itoa(num) result(str)
        implicit none
        integer, intent(in) :: num
        character(len=20) :: str

        write(str, '(I0)') num  ! Convierte el entero 'num' a cadena
    end function itoa

    function ftoa(num) result(str)
    implicit none
    real, intent(in) :: num
    character(len=20) :: str

    write(str, '(I0)') NINT(num)  ! Convierte el número decimal 'num' a entero redondeado y luego a cadena
end function ftoa

subroutine generate_graphviz(graf)
    implicit none
    character(len=*), intent(in) :: graf  ! Recibe la estructura del gráfico como argumento
    integer :: ios
    character(len=400) :: comando

    ! Abrimos el archivo para escribir el gráfico
    open(unit=10, file="graph.dot", status="replace", iostat=ios)
    if (ios /= 0) then
        print*, "Error abriendo el archivo: ", ios
        return  ! Termina si hay error
    end if

    ! Escribimos la estructura del gráfico en el archivo
    write(10, '(A)') trim(graf)  ! Escribe la estructura contenida en graf
    close(10)  ! Cerramos el archivo

    ! Comando para generar el archivo PNG usando Graphviz
    comando = "dot -Tpng graph.dot -o graph.png"
    call system(comando)

    print *, "Grafico generado correctamente"

end subroutine generate_graphviz

end program analizador_lexico
