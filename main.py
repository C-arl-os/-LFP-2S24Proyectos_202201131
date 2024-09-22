import tkinter as tk
from tkinter import filedialog, Menu
import subprocess
from PIL import Image, ImageTk

class PersonalDataWindow(tk.Toplevel):
    def __init__(self, master):
        super().__init__(master)
        self.title("Personal Data")
        self.geometry("400x200")
        self.configure(bg='black')

        # Crear un cuadro de texto de solo lectura para mostrar los datos personales
        self.data_text = tk.Text(self, width=40, height=10, bg='gray', fg='white', font=('Arial', 12))
        self.data_text.pack()

        # Insertar datos personales en el cuadro de texto
        self.data_text.insert(tk.INSERT, "\n")
        self.data_text.insert(tk.INSERT, "Carlos Emanuel Sancir Reyes\n")
        self.data_text.insert(tk.INSERT, "Carnet: 2202201131\n")
        self.data_text.insert(tk.INSERT, "Lab Lenguajes Formales y de Programación\n")
        self.data_text.insert(tk.INSERT, "Sección: B-\n")

        # Hacer el cuadro de texto de solo lectura
        self.data_text.configure(state='disabled')

        # Botón para cerrar la ventana
        self.close_button = tk.Button(self, text="Cerrar", command=self.destroy, bg='gray', fg='white', font=('Arial', 12))
        self.close_button.pack()


class MainWindow(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Analizador lexico- 202201131")
        self.geometry("1400x800")
        self.configure(bg='black')

        # Crear el menú principal en la ventana
        menu_proyecto = Menu(self)
        self.config(menu=menu_proyecto)

        # Crear el menú del proyecto
        proyecto_menu = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Menu", menu=proyecto_menu)
        proyecto_menu.add_command(label="Abrir", command=self.abrir_archivo)
        proyecto_menu.add_command(label="Guardar", command=self.guardar_archivo)
        proyecto_menu.add_command(label="Guardar Como", command=self.guardar_archivo_como)

        # Crear el menú de Acerca de
        menu_acerca = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Acerca de", menu=menu_acerca)
        menu_acerca.add_command(label="Acerca de", command=self.open_personal_data_window)

        # Crear la opción Salir
        menu_salir = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Salir", menu=menu_salir)
        menu_salir.add_command(label="Salir", command=self.Cerrar)

        # Crear un marco para organizar las áreas de la ventana
        frame = tk.Frame(self, bg='black')
        frame.pack(fill=tk.BOTH, expand=True)

        # Crear una etiqueta sobre el cuadro de texto
        self.data_label = tk.Label(frame, text="Archivo de entrada", bg='black', fg='white', font=('Arial', 14))
        self.data_label.place(x=140, y=20, width=200, height=50)

        # Crear el área de texto izquierda para mostrar el contenido del archivo de entrada
        self.left_text_area = tk.Text(frame, bg='gray', fg='white', font=('Arial', 12))
        self.left_text_area.place(x=10, y=60, width=400, height=500)

        # Botón de análisis
        self.button_analisis = tk.Button(frame, text="Análisis", command=self.enviar_datos, bg='gray', fg='white', font=('Arial', 12))
        self.button_analisis.place(x=450, y=200, width=100, height=30)

        # Etiqueta para mostrar la imagen
        self.image_label = tk.Label(frame, bg='black')
        self.image_label.place(x=570, y=5, width=800, height=500)

        # Crear labels para los datos del país
        self.data_label1 = tk.Label(frame, text="Pais Seleccionado:", bg='black', fg='white', font=('Arial', 12))
        self.data_label1.place(x=540, y=410, width=200, height=50)
        self.data_label2 = tk.Label(frame, text="Aqui van los datos del pais:", bg='black', fg='white', font=('Arial', 12))
        self.data_label2.place(x=540, y=460, width=200, height=50)

        # Crear el área de texto donde se mostrará el país seleccionado
        self.img_area = tk.Text(frame, bg='gray', fg='white', font=('Arial', 12))
        self.img_area.place(x=900, y=420, width=300, height=200)

    def abrir_archivo(self):
        # Abrir un cuadro de diálogo para seleccionar un archivo
        archivo = filedialog.askopenfilename(
            title="Abrir archivo",
            filetypes=[("Archivos de texto", "*.org")]
        )

        if archivo:
            with open(archivo, "r") as file:
                contenido = file.read()
                self.left_text_area.delete("1.0", tk.END)
                self.left_text_area.insert(tk.END, contenido)
                self.archivo_actual = archivo

    def enviar_datos(self):
        # Limpiar el área de imagen antes de analizar
        self.image_label.config(image='')

        # Obtener el contenido del área de texto izquierda
        data = self.left_text_area.get("1.0", tk.END)

        # Compilar y ejecutar el código Fortran
        subprocess.run(["gfortran", "-o", "main.exe", "main.f90"], check=True)
        resultado = subprocess.run(
            ["./main.exe"],
            input=data,
            stdout=subprocess.PIPE,
            text=True
        )

        # Mostrar la imagen al analizar
        self.mostrar_imagen()
        self.left_text_area.delete("1.0", tk.END)

    def mostrar_imagen(self):
        # Cargar la imagen desde la misma carpeta
        image_path = 'graph.png'
        image = Image.open(image_path)

        # Redimensionar la imagen para que se ajuste al label
        label_width = 800
        label_height = 500
        image_width, image_height = image.size
        aspect_ratio = image_width / image_height
        if aspect_ratio > label_width / label_height:
            new_width = label_width
            new_height = int(new_width / aspect_ratio)
        else:
            new_height = label_height
            new_width = int(new_height * aspect_ratio)

        image = image.resize((new_width, new_height))
        photo = ImageTk.PhotoImage(image)

        # Asigna la imagen al label
        self.image_label.config(image=photo)
        #self.image_label.image = photo  # Para evitar que la imagen sea recogida por el GC

    def guardar_archivo(self):
        # Obtener el contenido actual del área de texto izquierda
        contenido = self.left_text_area.get("1.0", tk.END)

        if hasattr(self, 'archivo_actual') and self.archivo_actual:
            with open(self.archivo_actual, "w") as file:
                file.write(contenido)
        else:
            self.guardar_archivo_como()

    def guardar_archivo_como(self):
        archivo = filedialog.asksaveasfilename(
            title="Guardar archivo como",
            filetypes=[("Archivos de texto", "*.org")]
        )

        if archivo:
            contenido = self.left_text_area.get("1.0", tk.END)
            with open(archivo, "w") as file:
                file.write(contenido)
            self.archivo_actual = archivo

    def open_personal_data_window(self):
        personal_data_window = PersonalDataWindow(self)
        personal_data_window.grab_set()

    def Cerrar(self):
        print("Saliendo")
        self.destroy()

if __name__ == "__main__":
    main_window = MainWindow()
    main_window.mainloop()
