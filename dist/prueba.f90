program acumulacion_texto
    implicit none
    character(len=100) :: graph

    ! Inicializa la variable graph con una cadena vacía
    graph = ""

    ! Acumular texto en la variable graph
    graph = trim(graph) // "hola" // char(10)  ! Añadir 'hola' seguido de un salto de línea
    graph = trim(graph) // "mundo" // char(10) ! Añadir 'mundo' seguido de un salto de línea
    graph = trim(graph) // "hola" // char(10)  ! Añadir 'hola' seguido de un salto de línea

    ! Imprimir la cadena
    print *, graph
end program acumulacion_texto

