
# Manual de Usuario: Analizador Léxico con Interfaz Gráfica

Este manual te guiará a través de los pasos necesarios para usar el **Analizador Léxico** con una interfaz gráfica desarrollada en Python y un backend en Fortran. Asegúrate de seguir todas las instrucciones para garantizar el correcto funcionamiento del programa.

## Requisitos del Sistema

Antes de comenzar, asegúrate de que tu entorno cumple con los siguientes requisitos:

- **Python 3.6 o superior**: Instala Python desde [python.org](https://www.python.org/).
- **Tkinter**: Viene incluido con la mayoría de las instalaciones de Python, pero si es necesario, puedes instalarlo utilizando tu gestor de paquetes del sistema.
- **Pillow**: Biblioteca para manipulación de imágenes. Instálala usando `pip`:
  ```bash
  pip install Pillow
  ```
- **GNU Fortran (gfortran)**: Necesario para compilar el código Fortran. Puedes instalarlo desde el gestor de paquetes de tu sistema (por ejemplo, `apt install gfortran` en distribuciones basadas en Linux).

## Instrucciones de Uso

### 1. Ejecutar el Programa

Para iniciar el programa, simplemente abre una terminal o símbolo del sistema y navega a la carpeta donde se encuentra el archivo `main.py`. Ejecuta el siguiente comando:

```bash
python main.py
```

Esto abrirá la ventana principal de la interfaz gráfica del analizador léxico.

### 2. Interfaz Gráfica

La interfaz gráfica consta de varios componentes que interactúan entre sí:

#### 2.1 Menú Principal

En la parte superior de la ventana encontrarás el menú principal, que contiene las siguientes opciones:

- **Abrir**: Te permite seleccionar un archivo de texto desde tu sistema.
- **Guardar**: Guarda los cambios realizados en el archivo actual.
- **Guardar Como**: Te permite guardar el archivo con un nombre diferente.
- **Acerca de**: Muestra una ventana con tus datos personales.
- **Salir**: Cierra la aplicación.

#### 2.2 Área de Texto para Archivos de Entrada

Debajo del menú, a la izquierda de la ventana, hay un cuadro de texto de tamaño considerable. Aquí es donde se mostrará el contenido del archivo de texto que abras. También puedes escribir o modificar el contenido manualmente.

**Pasos**:
1. Selecciona `Abrir` en el menú principal.
2. Navega hasta el archivo que desees analizar (formato `.org` o `.txt` recomendado).
3. El contenido del archivo aparecerá en el cuadro de texto.

#### 2.3 Botón de Análisis

A la derecha del área de texto, encontrarás un botón etiquetado como **Análisis**. Este botón ejecuta el proceso de análisis léxico.

**Pasos**:
1. Asegúrate de que el archivo de entrada esté cargado o el texto esté escrito en el área de texto izquierda.
2. Haz clic en el botón **Análisis**. Esto ejecutará el código Fortran que procesará el contenido del archivo o texto.
3. Una vez finalizado, el programa mostrará una imagen (`graph.png`) generada en el panel de la derecha.

#### 2.4 Visualización de la Imagen

Una vez que el análisis léxico se complete, la imagen generada aparecerá en el área derecha de la ventana.

**Pasos**:
1. Asegúrate de haber presionado el botón **Análisis**.
2. El programa cargará y mostrará automáticamente la imagen `graph.png` que fue generada como resultado del análisis. La imagen se ajustará automáticamente al espacio disponible.

#### 2.5 Detalles del País Seleccionado

Debajo de la imagen, verás dos etiquetas que mostrarán información relacionada con el país que haya sido seleccionado durante el análisis.

**Pasos**:
1. Selecciona el país desde los datos presentados en el análisis.
2. Los detalles del país seleccionado se mostrarán automáticamente en las etiquetas y el cuadro de texto a la derecha.

### 3. Guardar Cambios

Si realizas modificaciones en el contenido de entrada y deseas guardar esos cambios:

- Selecciona `Guardar` para sobreescribir el archivo actual.
- Selecciona `Guardar Como` para guardar el contenido en un nuevo archivo con un nombre diferente.

### 4. Mostrar Datos Personales

El programa incluye una opción para mostrar los datos del desarrollador.

**Pasos**:
1. En el menú principal, selecciona la opción `Acerca de`.
2. Se abrirá una nueva ventana que mostrará los datos personales como nombre, carnet y otros datos relevantes.

### 5. Cerrar el Programa

Para cerrar la aplicación, selecciona la opción `Salir` en el menú principal o simplemente cierra la ventana principal.

---

## Solución de Problemas

### Problema: La Imagen no se Muestra

- Asegúrate de que el archivo `graph.png` fue generado correctamente por el programa Fortran.
- Verifica que el archivo se encuentre en la misma carpeta que el script `main.py`.
- Si estás en un entorno de Linux o Mac, revisa los permisos de ejecución del archivo `main.exe` generado por Fortran.

### Problema: El Código Fortran No se Ejecuta

- Asegúrate de que tienes instalado **gfortran** y que se encuentra correctamente en tu variable `PATH`.
- Verifica que el archivo Fortran (`main.f90`) esté en la misma carpeta que el script de Python.

---

## Conclusión

Este programa combina Python y Fortran para realizar un análisis léxico a través de una interfaz gráfica amigable. Sigue los pasos descritos en este manual para cargar archivos, ejecutar el análisis y guardar los resultados de manera eficiente.
