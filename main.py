import os
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

        self.data_text = tk.Text(self, width=40, height=10, bg='gray', fg='white', font=('Arial', 12))
        self.data_text.pack()

        self.data_text.insert(tk.INSERT, "\nCarlos Emanuel Sancir Reyes\nCarnet: 2202201131\nLab Lenguajes Formales y de Programación\nSección: B-\n")
        self.data_text.configure(state='disabled')

        self.close_button = tk.Button(self, text="Cerrar", command=self.destroy, bg='gray', fg='white', font=('Arial', 12))
        self.close_button.pack()

class MainWindow(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Analizador lexico- 202201131")
        self.geometry("1400x800")
        self.configure(bg='black')

        menu_proyecto = Menu(self)
        self.config(menu=menu_proyecto)

        proyecto_menu = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Menu", menu=proyecto_menu)
        proyecto_menu.add_command(label="Abrir", command=self.abrir_archivo)
        proyecto_menu.add_command(label="Guardar", command=self.guardar_archivo)
        proyecto_menu.add_command(label="Guardar Como", command=self.guardar_archivo_como)

        menu_acerca = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Acerca de", menu=menu_acerca)
        menu_acerca.add_command(label="Acerca de", command=self.open_personal_data_window)

        menu_salir = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Salir", menu=menu_salir)
        menu_salir.add_command(label="Salir", command=self.Cerrar)

        frame = tk.Frame(self, bg='black')
        frame.pack(fill=tk.BOTH, expand=True)

        self.data_label = tk.Label(frame, text="Archivo de entrada", bg='black', fg='white', font=('Arial', 14))
        self.data_label.place(x=140, y=20, width=200, height=50)

        self.left_text_area = tk.Text(frame, bg='gray', fg='white', font=('Arial', 12))
        self.left_text_area.place(x=10, y=60, width=400, height=500)

        self.button_analisis = tk.Button(frame, text="Análisis", command=self.enviar_datos, bg='gray', fg='white', font=('Arial', 12))
        self.button_analisis.place(x=450, y=200, width=100, height=30)

        self.image_label = tk.Label(frame, bg='black')
        self.image_label.place(x=570, y=5, width=800, height=500)

        self.data_label1 = tk.Label(frame, text="Pais Seleccionado:", bg='black', fg='white', font=('Arial', 12))
        self.data_label1.place(x=540, y=410, width=200, height=50)
        self.data_label2 = tk.Label(frame, text="Aqui van los datos del pais:", bg='black', fg='white', font=('Arial', 12))
        self.data_label2.place(x=540, y=460, width=200, height=50)

        self.img_area = tk.Text(frame, bg='gray', fg='white', font=('Arial', 12))
        self.img_area.place(x=900, y=420, width=300, height=200)

        self.last_image_mod_time = None  # Variable para almacenar el tiempo de modificación de la imagen

    def abrir_archivo(self):
        archivo = filedialog.askopenfilename(title="Abrir archivo", filetypes=[("Archivos de texto", "*.org")])
        if archivo:
            with open(archivo, "r") as file:
                contenido = file.read()
                self.left_text_area.delete("1.0", tk.END)
                self.left_text_area.insert(tk.END, contenido)
                self.archivo_actual = archivo

    def enviar_datos(self):
        # Obtener el contenido del área de texto izquierda
        data = self.left_text_area.get("1.0", tk.END)

        # Compilar y ejecutar el código Fortran
        subprocess.run(["gfortran", "-o", "main.exe", "main.f90"], check=True)
        resultado = subprocess.run(["./main.exe"], input=data, stdout=subprocess.PIPE, text=True)

        # Verificar si la imagen ha cambiado
        self.mostrar_imagen()

    def mostrar_imagen(self):
        image_path = 'graph.png'
        mod_time = os.path.getmtime(image_path)  # Obtener el tiempo de modificación del archivo

        # Comparar el tiempo de modificación con el último guardado
        if self.last_image_mod_time is None or mod_time != self.last_image_mod_time:
            self.last_image_mod_time = mod_time  # Actualizar el tiempo de modificación

            # Cargar la imagen
            image = Image.open(image_path)

            # Redimensionar la imagen
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
            self.image_label.image = photo  # Para evitar que la imagen sea recogida por el GC
        else:
            self.image_label.config(image='')  # Limpiar la imagen si no ha cambiado

    def guardar_archivo(self):
        contenido = self.left_text_area.get("1.0", tk.END)
        if hasattr(self, 'archivo_actual') and self.archivo_actual:
            with open(self.archivo_actual, "w") as file:
                file.write(contenido)
        else:
            self.guardar_archivo_como()

    def guardar_archivo_como(self):
        archivo = filedialog.asksaveasfilename(title="Guardar archivo como", filetypes=[("Archivos de texto", "*.org")])
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
