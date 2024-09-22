
# Manual Técnico - Sistema de Análisis Léxico con Interfaz Gráfica (Python y Fortran)

## 1. Introducción

Este sistema combina una interfaz gráfica desarrollada en Python usando Tkinter con un backend en Fortran para realizar el análisis léxico. Su función principal es procesar el contenido de archivos y visualizar el análisis en formato gráfico.

---

## 2. Requisitos del Sistema

### 2.1 Hardware
- Computadora con procesador de 2 núcleos o más.
- Al menos 2 GB de RAM.

### 2.2 Software
- **Python 3.x**: Interfaz gráfica.
- **gfortran**: Compilador de Fortran.
- **Graphviz**: Para generar gráficos a partir de archivos DOT.

### 2.3 Bibliotecas Python
- `tkinter`: Crear la interfaz gráfica.
- `PIL`: Mostrar imágenes.

---

## 3. Instalación

### 3.1 Python
1. Descargar e instalar Python desde [python.org](https://www.python.org/downloads/).

### 3.2 gfortran
Instalar `gfortran` usando:

- **Linux (Debian/Ubuntu)**:
   ```bash
   sudo apt-get install gfortran
   ```

### 3.3 Graphviz
Instalar `Graphviz` usando:

- **Linux**:
   ```bash
   sudo apt-get install graphviz
   ```

### 3.4 Instalar bibliotecas Python
Ejecutar:
```bash
pip install pillow
```

---

## 4. Arquitectura del Sistema

### 4.1 Frontend (Python)
Interfaz gráfica para cargar archivos, ejecutar el análisis y mostrar resultados.

### 4.2 Backend (Fortran)
Analiza el archivo cargado y genera un archivo DOT para crear un gráfico del análisis.

---

## 5. Descripción del Código

### 5.1 Código Python (`main.py`)
- **Clase `MainWindow`**: Define la ventana principal y su funcionalidad.
- **Clase `PersonalDataWindow`**: Ventana secundaria para mostrar información del desarrollador.

#### 5.1.1 Fragmento del Código Python
```python
class MainWindow(tk.Tk):
    def __init__(self):
        # Inicialización de la ventana principal
        ...
```

### 5.2 Código Fortran (`lexer.f90`)
- Analiza el archivo de entrada y genera un archivo DOT.
- **Módulo `ErrorInfo`**: Registra tokens válidos y errores.

#### 5.2.1 Fragmento del Código Fortran
```fortran
module ErrorInfo
    implicit none
    type :: ErrorData
        ...
end module ErrorInfo
```

---

## 6. Proceso de Ejecución

1. Abrir un archivo de texto desde la interfaz.
2. Ejecutar el análisis léxico.
3. Mostrar los resultados gráficos en la ventana.

---

## 7. Mantenimiento

### 7.1 Modificaciones en Fortran
Agregar nuevos tokens o reglas en el módulo `ErrorInfo`.

### 7.2 Modificaciones en Python
Modificar la clase `MainWindow` para ampliar la funcionalidad de la interfaz.

---

## 8. Conclusión

El sistema permite realizar análisis léxicos simples con visualización gráfica. Es fácilmente ampliable y modificable en ambas capas: frontend y backend.
