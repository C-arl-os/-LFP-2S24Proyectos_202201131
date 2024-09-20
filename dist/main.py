import tkinter as tk
from tkinter import filedialog, Menu
import subprocess

class PersonalDataWindow(tk.Toplevel):
    def __init__(self, master):
        super().__init__(master)
        self.title("Personal Data")
        self.geometry("400x200")

        # Create a read-only text box to display personal data
        self.data_text = tk.Text(self, width=40, height=10)
        self.data_text.pack()

        # Insert personal data into the text box
        self.data_text.insert(tk.INSERT, "\n")
        self.data_text.insert(tk.INSERT, "\n")
        self.data_text.insert(tk.INSERT, "\n")
        self.data_text.insert(tk.INSERT, "Nombre: Carlos Emanuel Sancir Reyes\n")
        self.data_text.insert(tk.INSERT, "Carnet: 202201131\n")
        self.data_text.insert(tk.INSERT, "\n")
        self.data_text.insert(tk.INSERT, "Sección: B-\n")

        # Make the text box read-only
        self.data_text.configure(state='disabled')

        # Add a button to close the window
        self.close_button = tk.Button(self, text="Close", command=self.destroy)
        self.close_button.pack()


class MainWindow(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Proyecto 1 - 202010035 ")
        self.geometry("1250x650")

        #Crear el menú principal en la ventana
        menu_proyecto = Menu(self)
        self.config(menu=menu_proyecto)
        
        #CRear el menú del proyecto
        proyecto_menu = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Menu", menu=proyecto_menu)
        proyecto_menu.add_command(label="Abrir", command= self.abrir_archivo)
        proyecto_menu.add_command(label="Guardar", command= self.guardar_archivo)
        proyecto_menu.add_command(label="Guardar Como", command= self.guardar_archivo_como)
        
        #Crear el menú de Acerca de
        menu_acerca = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Acerca de", menu=menu_acerca)
        menu_acerca.add_command(label="Acerca de", command=self.open_personal_data_window)
        #Crear la opción Salir
        menu_salir = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Salir", menu=menu_salir)
        menu_salir.add_command(label="Salir", command= self.Cerrar)
        
        #Crear un marco para organizar las áreas de la ventana
        frame = tk.Frame(self)
        frame.pack(fill=tk.BOTH, expand=True)
        
        # Create a label above the text box
        self.data_label = tk.Label(frame, text="Archivo de entrada")
        self.data_label.place(x=100, y=20, width=100, height=50)

        #Crear el área del texto izquerda para mostrar el contenido del archivo de entrada
        self.left_text_area = tk.Text(frame)
        self.left_text_area.place(x=10, y=60, width=400, height=500)
        #left_text_area.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        
        # Crear los botones que se encuentran a un lado
        self.button_Generar_pdf = tk.Button(frame, text="Generar pdf")
        self.button_Generar_pdf.place(x=450, y=300, width=100, height=30)  # top button

        self.button_analisis = tk.Button(frame, text="Analisis", command= self.enviar_datos)
        self.button_analisis.place(x=450, y=200, width=100, height=30)  # bottom button
        
        #Crear el área del texto izquerda para mostrar el contenido del archivo de entrada
        self.text_area = tk.Text(frame)
        self.text_area.place(x=570, y=5, width=670, height=400)
        #left_text_area.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        
        # Crear labels que contienen el Área de selección
        self.data_label1 = tk.Label(frame, text="Archivo de entrada1", bg=frame.cget('bg'), borderwidth=0, relief="flat")
        self.data_label1.place(x=500, y=410, width=150, height=50)
        self.data_label2 = tk.Label(frame, text="Archivo de entrada5", bg=frame.cget('bg'), highlightthickness=0)
        self.data_label2.place(x=500, y=460, width=150, height=50)
        
        #Crear el área del texto donde se mostrara el país seleccionado
        self.img_area = tk.Text(frame)
        self.img_area.place(x=900, y=420, width=200, height=200)
        #left_text_area.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)


    def abrir_archivo(self):
    # Abrir un cuadro de diálogo para seleccionar un archivo
        archivo = filedialog.askopenfilename(
            title="Abrir archivo",
            filetypes=[("Archivos de texto", "*.org")]
        )
    
        if archivo:
            with open(archivo, "r") as file:
                contenido = file.read()
                # Borrar el contenido anterior y cargar el archivo en el área de texto izquierda
                self.left_text_area.delete("1.0", tk.END)
                self.left_text_area.insert(tk.END, contenido)
                # Establecer el atributo archivo_actual
                self.archivo_actual = archivo

    def enviar_datos(self):
        # Limpiar el área de texto derecha antes de analizar
        self.text_area.delete("1.0", tk.END)
        
        # Obtener el contenido del área de texto izquierda
        data = self.left_text_area.get("1.0", tk.END)
        
        # Compilar y ejecutar el código Fortran
        comando = subprocess.run(
            ["gfortran", "-o", "main.exe", "main.f90"],  # compilación de Fortran
            check=True  # detener si hay un error en la compilación
        )
        resultado = subprocess.run(
            ["./main.exe"],  # Ejecutable de Fortran
            input=data,  # la data que se manda a Fortran
            stdout=subprocess.PIPE,  # la data que viene de Fortran   
            text=True  # la salida se maneja como texto
        )
        
        # Insertar la nueva salida en el área de texto derecha
        self.text_area.insert(tk.END, resultado.stdout)

    def guardar_archivo(self):
        # Obtener el contenido actual del área de texto izquierda
        contenido = self.left_text_area.get("1.0", tk.END)
        
        # Verificar si el archivo ya existe
        if hasattr(self, 'archivo_actual') and self.archivo_actual:
            # Si existe, sobreescribir el archivo
            with open(self.archivo_actual, "w") as file:
                file.write(contenido)
        else:
            # Si no existe, llamar a la función guardar como
            self.guardar_archivo_como()
    
    def guardar_archivo_como(self):
        # Abrir un cuadro de diálogo para seleccionar un archivo y guardar
        archivo = filedialog.asksaveasfilename(
            title="Guardar archivo como",
            filetypes=[("Archivos de texto", "*.org")]
        )
    
        if archivo:
            # Guardar el contenido actual del área de texto izquierda en el archivo seleccionado
            contenido = self.left_text_area.get("1.0", tk.END)
            with open(archivo, "w") as file:
                file.write(contenido)
            # Actualizar el atributo archivo_actual
            self.archivo_actual = archivo
    
    def open_personal_data_window(self):
        personal_data_window = PersonalDataWindow(self)
        personal_data_window.grab_set()  # Set focus on the new window
    
    def Cerrar(self):
        print("Sali")
        self.destroy()

if __name__ == "__main__":
    main_window = MainWindow()
    #main_window.iconbitmap('C:\\Users\\sanci\\Desktop\\-LFP-2S24Proyectos_202201131\\icono.ico')

    main_window.mainloop()