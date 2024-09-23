program analizador_lexico
    implicit none
    
     
    type :: ErrorInfo
        character(len=10) :: caracter  
        character(len=100) :: descripcion  
        integer :: columna      
        integer :: LECTURADELINEA      
    end type ErrorInfo

    integer :: i,j,k, len, LECTURADELINEA, columna, estado, puntero, numErrores, file_unit, ios,numToken, columnaToken
    integer :: espacio_texto
    logical :: cadena, porcentajesaturaciontaje 
    INTEGER :: num_reservadas
    integer :: poblacion_valor, saturacion_valor
    character (len=100) :: nombre_valor, bandera_valor
    
    type :: TokenType
        character(len=200) :: LEXEMATODO
        character(len=100) :: tipo_LEXEMATODO
        integer :: LECTURADELINEA
        integer :: columna
    end type TokenType

    ! Definición de un tipo que almacena la información de los tokens para las palabras reservadas
    type :: tokensA
        character(len=100) :: LEXEMATODO
    end type tokensA

    type :: tokens_reservadas
        character(len=100) :: nombre
        INTEGER :: poblacion
        character(len=100) :: bandera
        INTEGER :: saturacion
    end type tokens_reservadas

    ! Declaración de un arreglo de tokens de tipo TokenType
    type(TokenType), dimension(2000) :: tokens

    ! Declaración de un arreglo de tokens de tipo tokensaprobadoslexema
    type(tokensA), dimension(7) :: tokensaprobadoslexema

    !aqui va la comparacion de banderas

    integer :: menor_saturacion = 100
    character(len=100) :: pais_con_menor_saturacion
    character(len=100) :: nombre_pais
    integer :: poblacion_menor
    character(len=200) :: bandera_menor

    type(tokens_reservadas), dimension(2000) :: tok
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
    logical :: validarpais,agregarpaisContinete, acceso

    

    !variables de porcentajesaturaciontaje 
    character(len=100) :: validarsaturacion,val
    character(len=20) :: aguardarsaturacion
    logical :: porcentajesaturacion
    integer :: integervalue, suma
    integer :: saturacioncontinente
    integer :: sumarpaises

 
    character(len=1), dimension(10) :: N
    character(len=1) :: char_error
    character(len=3000) :: buffer, contenido
    character(len=10) :: str_codigo_ascii, str_columna, str_LECTURADELINEA
    ! Variables para el archivo HTML

    contenido = ''

    ! Lee el contenido desde la entrada estándar
    do
        read(*, '(A)', IOSTAT=ios) buffer
        if (ios /= 0) exit 
        contenido = trim(contenido) // trim(buffer) // new_line('a') ! concatenamos el 
        !contenido mas lo que viene en el buffer y como leemos por el salto de LECTURADELINEA al final
    end do

    A = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    M = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
    N = ['1','2','3','4','5','6','7','8','9','0']

    !guardamos en tokensaprobadoslexema las palabras reservadas
    tokensaprobadoslexema(1)%LEXEMATODO = 'grafica'
    tokensaprobadoslexema(2)%LEXEMATODO = 'nombre'
    tokensaprobadoslexema(3)%LEXEMATODO = 'continente'
    tokensaprobadoslexema(4)%LEXEMATODO = 'pais'



    !agregamos mas tokens
    tokensaprobadoslexema(5)%LEXEMATODO = 'poblacion'
    tokensaprobadoslexema(6)%LEXEMATODO = 'saturacion'
    tokensaprobadoslexema(7)%LEXEMATODO = 'bandera'

    j=0
    k=0
    pais_con_menor_saturacion = ''
    nombre_valor = ''
    bandera_valor = ''
    poblacion_valor = 0
    saturacion_valor = 0
    estado = 0
    puntero = 1
    columna = 1
    columnaToken = 0
    LECTURADELINEA = 1
    numErrores = 0
    numToken = 0
    num_reservadas = 0
    cadena = .FALSE.
    porcentajesaturaciontaje = .FALSE.
    tkn = ''
    ! :::::::::: para generara el graphiz
    acceso = .FALSE.
    nombregrafica = ''
    validarnombre = .TRUE. 
    validarpais = .FALSE.
    validarcontinente = .FALSE.
    nombrecontinente =''
    agregarcontinente = .FALSE.
    agregarpaisContinete = .FALSE.
    graf = ''
    nombrepais = ''
    axuxiliar = ''
    ! validar saturacion
    validarsaturacion = '' !aguarda los numero concatenadios
    aguardarsaturacion ='' !el que valida si viene porcentajesaturaciontaje
    porcentajesaturacion = .FALSE.    !cierra y abre la lectura

    len = len_trim(contenido) 

    do while (puntero <= len)
        char = contenido(puntero:puntero)
        !graphiz
        if (puntero == len) then
            suma = saturacioncontinente/sumarpaises
            if (suma <= 15) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table border="0" cellborder="1" ' // &
                'cellspacing="0"><tr><td bgcolor="white">' // trim(nombrecontinente) // '</td></tr><tr><td bgcolor="white">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
            elseif (suma <= 30) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table border="0" cellborder="1" ' // & 
                'cellspacing="0"><tr><td bgcolor="blue">' // trim(nombrecontinente) // '</td></tr><tr><td bgcolor="blue">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
            elseif (suma <= 45) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table border="0" cellborder="1" ' // &
                'cellspacing="0"><tr><td bgcolor="green">' // trim(nombrecontinente) // '</td></tr><tr><td bgcolor="green">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
            elseif (suma <= 60) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table border="0" cellborder="1" '// & 
                'cellspacing="0"><tr><td bgcolor="yellow">' // trim(nombrecontinente) // '</td></tr><tr><td bgcolor="yellow">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
            elseif (suma <= 75) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table border="0" cellborder="1" ' // & 
                'cellspacing="0"><tr><td bgcolor="red">' // trim(nombrecontinente) // '</td></tr><tr><td bgcolor="red">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
            elseif (suma <= 100) then
                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table border="0" cellborder="1" ' // & 
                'cellspacing="0"><tr><td bgcolor="red">' // trim(nombrecontinente) // '</td></tr><tr><td bgcolor="red">' // &
                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
            end if

            graf = trim(graf) // new_line('a')// "}"
            
            
        end if
        if (agregarcontinente) then    ! agrego el contiente
            graf = trim(graf) // new_line('a') // '"' // trim(nombregrafica) // '"' // &
       " -> " // '"' // trim(nombrecontinente) // '"'
                        
            
            agregarcontinente = .FALSE. !sino se queda abierto 
            saturacioncontinente = 0
            sumarpaises = 0
            
            
            !pasa a false
            
        end if
        if (agregarpaisContinete ) then
            if (len_trim(nombrepais) > 0) then
                if(porcentajesaturacion) then
                    validarsaturacion = trim(validarsaturacion) 
                    
                    read(validarsaturacion, *) integervalue
                    saturacioncontinente = saturacioncontinente + integervalue
                    sumarpaises = sumarpaises +1

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
                    validarsaturacion =''
                    nombrepais = trim(nombrepais) // achar(10) // trim(validarsaturacion)
                    graf = trim(graf) // new_line('a') // trim(nombrecontinente) // " -> " // trim(nombrepais)
                
                    nombrepais = ''
                    porcentajesaturacion = .FALSE.
                end if
                
            else
            
            end if

            ! Reinicializar la variable
            
            agregarcontinente = .FALSE.
            agregarpaisContinete = .FALSE.
        end if
        
        if (ichar(char) == 10) then
            ! salto de LECTURADELINEA
            columna = 1
            LECTURADELINEA = LECTURADELINEA + 1
            puntero = puntero + 1
        elseif (ichar(char) == 9) then
            ! tabulacion
            columna = columna + 4
            puntero = puntero + 1
        elseif (ichar(char) == 32) then
            ! espacio en blanco
            columna = columna + 1
            puntero = puntero + 1
        elseif (ichar(char) == 59) then
            !punto y coma
            if (porcentajesaturaciontaje .eqv. .TRUE.) then
                numToken = numToken + 1
                tokens(numToken) = TokenType(tkn, 'Cadena de Numeros', LECTURADELINEA, columna)
                porcentajesaturaciontaje = .FALSE.
            else if (tkn .eq. '') then

            else
                numToken = numToken + 1
                tokens(numToken) = TokenType(tkn, 'Cadena', LECTURADELINEA, columnaToken)
            end if
            columna = columna + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType(';', 'Punto y coma', LECTURADELINEA, columna)
            estado = 0
            puntero = puntero + 1
        else if (ichar(char) == 125) then
            !llave de cierre
            columna = columna + 1
            puntero = puntero + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType('}', 'Cierra Llave', LECTURADELINEA, columna)
            estado = 0
        else if (ichar(char) == 123) then
            !abrir llave
            columna = columna + 1
            puntero = puntero + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType('{', 'Abre Llave', LECTURADELINEA, columna)
            ! kkkkkk
            
            estado = 0
        else if (ichar(char) == 58) then
            !dos puntos
 
            if (cadena .eqv. .TRUE.) then
                columna = columna + 1
                tkn = trim(tkn) // char
                estado = 3
            else
                numToken = numToken + 1
                do i = 1, size(tokensaprobadoslexema)
                    if (trim(tokensaprobadoslexema(i)%LEXEMATODO) == trim(tkn)) then
                        tokens(numToken) = TokenType(tkn, 'Palabra Reservada', LECTURADELINEA, columnaToken)
                        exit
                        
                    end if
                end do
                columna = columna + 1
                numToken = numToken + 1
                !comparando grafica para iniciar el graphiz 
                if ('grafica' == trim(tkn)) then    !va a inciar el grafico
                        graf = 'digraph G {' 
                        !// new_line('a') // 'node [style = rounded,shape=invhouse];'

                        
                else if ('continente' == trim(tkn)) then
                        
                        axuxiliar = 'continente'
                        if (len_trim(nombrecontinente) > 0) then
                            suma = saturacioncontinente/sumarpaises

                            if (suma <= 15) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="white">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="white">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
                            elseif (suma <= 30) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="blue">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="blue">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
                            elseif (suma <= 45) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="green">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="green">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
                            elseif (suma <= 60) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="yellow">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="yellow">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
                            elseif (suma <= 75) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="orange">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="orange">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
                            elseif (suma <= 100) then
                                graf = trim(graf) // new_line('a') //trim(nombrecontinente) // '[label=<<table ' // &
                                'border="0" cellborder="1" cellspacing="0"><tr><td bgcolor="red">' // &
                                trim(nombrecontinente) // '</td></tr><tr><td bgcolor="red">' // &
                                trim(itoa(suma)) // '%</td></tr></table>>, shape=box3d];'
                            end if
                        end if
                        nombrecontinente =''
                        validarcontinente = .TRUE.
                        validarpais = .FALSE.  !solo para el pais
                        acceso = .FALSE.  !solo para el pais


                else if ('pais' == trim(tkn)) then
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
                
                tokens(numToken) = TokenType(':', 'Dos Puntos', LECTURADELINEA, columna)
                estado = 2
                tkn = ''   

            end if
            puntero = puntero + 1
        else if (ichar(char) == 37) then ! aqui debe guardar una cadena de numeros
            porcentajesaturacion = .TRUE.
            aguardarsaturacion =''
            numToken = numToken + 1
            tokens(numToken) = TokenType(tkn, 'Cadena de Numeros', LECTURADELINEA, columna)
            columna = columna + 1
            numToken = numToken + 1
            tokens(numToken) = TokenType('%', 'Por ciento', LECTURADELINEA, columna)
            puntero = puntero + 1
            estado = 0
            porcentajesaturaciontaje = .FALSE.
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
                        errores(numErrores) = ErrorInfo(char, "Error no pertenece al lenguaje M estado 0", columna, LECTURADELINEA)

                    end if
                    puntero = puntero + 1
                case (1)
                    
                    if (any(char == M)) then
                    
                        estado = 1
                        columna = columna + 1
                        tkn = trim(tkn) // char ! Agrega el caracter a la cadena
                    
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene a S O M estado 1", columna, LECTURADELINEA)
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

                            validarsaturacion = trim(validarsaturacion) // char
                        end if
                        columna = columna + 1
                        estado = 3
                        tkn = char ! Inicia la cadena de caracteres
                        columnaToken = columna   !se setea la columna donde empieza el token
                        porcentajesaturaciontaje = .TRUE.
                    else if (ichar(char) == 34) then ! si se lee una comilla doble empieza la cadena
                        columna = columna + 1
                        estado = 3  
                        tkn = char 
                        columnaToken = columna   
                        cadena = .TRUE.
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene a M y S estado 3", columna, LECTURADELINEA)
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
                            agregarpaisContinete = .TRUE.   !pasa true en el primer if 
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

                        end if
                        if (validarpais) then    !concatena el nombre
                            nombrepais = trim(nombrepais) // char
                        end if
                        if(aguardarsaturacion == 'saturacion') then
                            validarsaturacion = trim(validarsaturacion) // char 
                            
                        end if
                    end if
                    puntero = puntero + 1
                case (4)
                    if (validarcontinente) then
                            nombrecontinente = trim(nombrecontinente) // char !concatenar el nomre continente

                        end if
                        if (validarpais) then    !concatena el nombre
                            nombrepais = trim(nombrepais) // char
                        end if
                        if(aguardarsaturacion == 'saturacion') then
                            validarsaturacion = trim(validarsaturacion) // char 
                            
                        end if
            end select
        end if
    end do
    ! aqui busca la bandera
    do i = 1, numToken
        if (tokens(i)%tipo_LEXEMATODO == "Palabra Reservada") then
            if (tokens(i)%LEXEMATODO == "pais") then
                ! Iniciar búsqueda de nombre, población, bandera y saturación
                j = i + 1
                do while (j <= numToken)
                    if (tokens(j)%tipo_LEXEMATODO == "Palabra Reservada") then
                        if (tokens(j)%LEXEMATODO == "nombre") then
                            ! Guardar valor de nombre
                            k = j + 1
                            do while (k <= numToken .and. tokens(k)%tipo_LEXEMATODO /= "Punto y coma")
                                if (tokens(k)%tipo_LEXEMATODO == "Cadena") then
                                    ! Guardar valor de nombre
                                    nombre_valor = tokens(k)%LEXEMATODO
                                    exit
                                end if
                                k = k + 1
                            end do
                        elseif (tokens(j)%LEXEMATODO == "poblacion") then
                            ! Guardar valor de población
                            k = j + 1
                            do while (k <= numToken .and. tokens(k)%tipo_LEXEMATODO /= "Punto y coma")
                                if (tokens(k)%tipo_LEXEMATODO == "Cadena de Numeros") then
                                    ! Guardar valor de población
                                    read(tokens(k)%LEXEMATODO, *) poblacion_valor
                                    !poblacion_valor = itoa(trim(tokens(k)%LEXEMATODO))
                                    exit
                                end if
                                k = k + 1
                            end do
                        elseif (tokens(j)%LEXEMATODO == "bandera") then
                            ! Guardar valor de bandera
                            k = j + 1
                            do while (k <= numToken .and. tokens(k)%tipo_LEXEMATODO /= "Punto y coma")
                                if (tokens(k)%tipo_LEXEMATODO == "Cadena") then
                                    ! Guardar valor de bandera
                                    bandera_valor = tokens(k)%LEXEMATODO
                                    exit
                                end if
                                k = k + 1
                            end do
                        elseif (tokens(j)%LEXEMATODO == "saturacion") then
                            ! Guardar valor de saturación
                            k = j + 1
                            do while (k <= numToken .and. tokens(k)%tipo_LEXEMATODO /= "Punto y coma")
                                if (tokens(k)%tipo_LEXEMATODO == "Cadena de Numeros") then
                                    ! Guardar valor de saturación
                                    read(tokens(k)%LEXEMATODO, *) saturacion_valor
                                    !saturacion_valor = itoa(trim(tokens(k)%LEXEMATODO))
                                    exit
                                end if
                                k = k + 1
                            end do
                        end if
                    end if
                    j = j + 1
                end do
                ! Guardar valores en tokens_reservadas
                num_reservadas = num_reservadas + 1
                tok(num_reservadas)%nombre = nombre_valor
                tok(num_reservadas)%poblacion = poblacion_valor
                tok(num_reservadas)%bandera = bandera_valor
                tok(num_reservadas)%saturacion = saturacion_valor
            end if
        end if
    end do

    ! Iterar sobre la lista tokens_reservadas
    do i = 1, num_reservadas
        ! Compara el valor de saturacion de cada elemento de la lista tokens_reservadas
        if (tok(i)%saturacion < menor_saturacion) then
            ! Si el valor de saturacion es menor, actualiza menor_saturacion y pais_con_menor_saturacion
            menor_saturacion = tok(i)%saturacion
            pais_con_menor_saturacion = tok(i)%nombre
            nombre_pais = tok(i)%nombre
            poblacion_menor = tok(i)%poblacion
            bandera_menor = tok(i)%bandera
        end if
    end do

    ! Imprime el nombre del país con la menor saturación
    print *,  pais_con_menor_saturacion
    print *,  poblacion_menor
    print *, bandera_menor

    ! Si hay errores, se crea el archivo HTML
    if (numErrores > 0) then
        ! Se crea el archivo HTML con los errores
        call Generar_los_Errores(numErrores, errores)
        print *,numErrores
    else
        call generar_html_tokens(numToken, tokens)
        call generate_graphviz(graf)
        print *,0
    end if

contains


subroutine Generar_los_Errores(numErrores, errores)
    implicit none
    integer, intent(in) :: numErrores
    type(ErrorInfo), intent(in) :: errores(numErrores)
    character(len=100000) :: html_content
    character(len=100) :: str_descripcion, str_columna, str_LECTURADELINEA, char_error
    integer :: i
    integer :: file_unit, ios

    if (numErrores > 0) then
        ! Abrir el archivo para escribir
        open(unit=file_unit, file="TOKENNOVALIDOS.html", status="replace", action="write", iostat=ios)
        if (ios /= 0) then

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

            do i = 1, numErrores
                write(str_descripcion, '(A)') trim(errores(i)%descripcion)
                write(str_columna, '(I0)') errores(i)%columna
                write(str_LECTURADELINEA, '(I0)')  errores(i)%LECTURADELINEA
                write(char_error, '(A)') trim(errores(i)%caracter)
                
                ! Escribir cada fila directamente al archivo
                write(file_unit, '(A)') '<tr><td>' // trim(itoa(i)) // '</td><td>' // trim(char_error) // '</td><td>' // &
                    trim(str_descripcion) // '</td><td>' // trim(str_columna) // '</td><td>' // &
                    trim(str_LECTURADELINEA) // '</td></tr>' // new_line('a')
            end do

            ! Cerrar la tabla y el HTML
            write(file_unit, '(A)') '</table></body></html>'
            close(file_unit)
        end if
    else
        
    end if
    
end subroutine Generar_los_Errores
subroutine generate_graphviz(graf)
    implicit none
    character(len=*), intent(in) :: graf  ! Recibe la estructura del gráfico como argumento
    integer :: ios
    character(len=400) :: comando
    open(unit=10, file="graph.dot", status="replace", iostat=ios)
    if (ios /= 0) then
        
        return  ! Termina si hay error
    end if

    write(10, '(A)') trim(graf)  ! Escribe la estructura contenida en graf
    close(10)  ! Cerramos el archivo

    comando = "dot -Tpng graph.dot -o graph.png"
    call system(comando)

end subroutine generate_graphviz

subroutine generar_html_tokens(numToken, tokens)
    implicit none
    integer, intent(in) :: numToken
    type(TokenType), intent(in) :: tokens(numToken)
    character(len=100000) :: html_content
    character(len=100) :: str_descripcion, str_columna, str_LECTURADELINEA, TLEXEMATODO
    integer :: i
    integer :: file_unit, ios

    if (numErrores == 0) then
        ! Abrir el archivo para escribir
        open(unit=file_unit, file="TOKENSVALIDOS.html", status="replace", action="write", iostat=ios)
        if (ios /= 0) then
            
        else
            ! Escribir la cabecera del HTML directamente al archivo
            write(file_unit, '(A)') '<!DOCTYPE html>' // new_line('a')
            write(file_unit, '(A)') '<html><head><style>' // new_line('a')
            write(file_unit, '(A)') 'table { font-family: Arial, sans-serif;'
            write(file_unit, '(A)') 'border-collapse: collapse; width: 100%; }' // new_line('a')
            write(file_unit, '(A)') 'td, th { border: 1px solid #dddddd; text-align: left; padding: 8px; }' // new_line('a')
            write(file_unit, '(A)') 'tr:nth-child(even) { background-color: #f2f2f2; }' // new_line('a')
            write(file_unit, '(A)') '</style></head><body><h2>Tabla de Tokens</h2>' // new_line('a')
            write(file_unit, '(A)') '<table><tr><th>No</th><th>LEXEMATODO</th><th>Descripcion' 
            write(file_unit, '(A)') '</th><th>Columna</th><th>Línea</th></tr>' // new_line('a')

            ! Bucle para formatear cada código ASCII y cada columna

            ! Bucle para agregar filas a la tabla
            do i = 1, numToken
            ! Obtener el LEXEMATODO del token

                
                write(str_descripcion, '(A)') trim(tokens(i)%tipo_LEXEMATODO)
                write(str_columna, '(I0)') tokens(i)%columna
                write(str_LECTURADELINEA, '(I0)')  tokens(i)%LECTURADELINEA
                write(TLEXEMATODO, '(A)') trim(tokens(i)%LEXEMATODO)
                
                ! Escribir cada fila directamente al archivo
                write(file_unit, '(A)') '<tr><td>' // trim(itoa(i)) // '</td><td>' // trim(TLEXEMATODO) // '</td><td>' // &
                    trim(str_descripcion) // '</td><td>' // trim(str_columna) // '</td><td>' // &
                    trim(str_LECTURADELINEA) // '</td></tr>' // new_line('a')
            end do

            ! Cerrar la tabla y el HTML
            write(file_unit, '(A)') '</table></body></html>'
            close(file_unit)
        end if
    else
        
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



end program analizador_lexico