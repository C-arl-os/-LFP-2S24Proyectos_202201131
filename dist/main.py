import tkinter as tk
from tkinter import filedialog, Menu
import subprocess

class PersonalDataWindow(tk.Toplevel):
    def __init__(self, master):
        super().__init__(master)
        self.title("Personal Data")
        self.geometry("400x200")
        self.configure(bg='#2e2e2e')  # Fondo oscuro

        # Crear un cuadro de texto de solo lectura para mostrar los datos personales
        self.data_text = tk.Text(self, width=40, height=10, bg='#3e3e3e', fg='white', insertbackground='white')
        self.data_text.pack()

        # Insertar datos personales en el cuadro de texto
        self.data_text.insert(tk.INSERT, "\n")
        self.data_text.insert(tk.INSERT, "Nombre: Carlos Emanuel Sancir Reyes\n")
        self.data_text.insert(tk.INSERT, "Carnet: 202201131\n")
        self.data_text.insert(tk.INSERT, "Sección: B-\n")

        # Hacer el cuadro de texto de solo lectura
        self.data_text.configure(state='disabled')

        # Botón para cerrar la ventana
        self.close_button = tk.Button(self, text="Cerrar", command=self.destroy, bg='#444444', fg='white')
        self.close_button.pack()


class MainWindow(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("202201131 ")
        self.geometry("1250x650")
        self.configure(bg='#1e1e1e')  # Fondo oscuro de la ventana principal

        # Crear el menú principal en la ventana
        menu_proyecto = Menu(self, bg='#444444', fg='white')
        self.config(menu=menu_proyecto)
        
        # Crear el menú del proyecto
        proyecto_menu = Menu(menu_proyecto, tearoff=0, bg='#444444', fg='white')
        menu_proyecto.add_cascade(label="Menu", menu=proyecto_menu)
        proyecto_menu.add_command(label="Abrir", command=self.abrir_archivo)
        proyecto_menu.add_command(label="Guardar", command=self.guardar_archivo)
        proyecto_menu.add_command(label="Guardar Como", command=self.guardar_archivo_como)
        
        # Crear el menú de Acerca de
        menu_acerca = Menu(menu_proyecto, tearoff=0, bg='#444444', fg='white')
        menu_proyecto.add_cascade(label="Acerca de", menu=menu_acerca)
        menu_acerca.add_command(label="Acerca de", command=self.open_personal_data_window)

        # Crear la opción Salir
        menu_salir = Menu(menu_proyecto, tearoff=0, bg='#444444', fg='white')
        menu_proyecto.add_cascade(label="Salir", menu=menu_salir)
        menu_salir.add_command(label="Salir", command=self.Cerrar)
        
        # Crear un marco para organizar las áreas de la ventana
        frame = tk.Frame(self, bg='#2e2e2e')
        frame.pack(fill=tk.BOTH, expand=True)
        
        # Crear una etiqueta sobre el cuadro de texto
        self.data_label = tk.Label(frame, text="Archivo de entrada", bg='#2e2e2e', fg='white')
        self.data_label.place(x=100, y=20, width=100, height=50)

        # Crear el área de texto izquierda para mostrar el contenido del archivo de entrada
        self.left_text_area = tk.Text(frame, bg='#3e3e3e', fg='white', insertbackground='white')
        self.left_text_area.place(x=10, y=60, width=400, height=500)
        
        # Crear los botones a un lado
        self.button_Generar_pdf = tk.Button(frame, text="Generar PDF", bg='#444444', fg='white')
        self.button_Generar_pdf.place(x=450, y=300, width=100, height=30)

        self.button_analisis = tk.Button(frame, text="Análisis", command=self.enviar_datos, bg='#444444', fg='white')
        self.button_analisis.place(x=450, y=200, width=100, height=30)
        
        # Crear el área de texto derecha para mostrar el contenido analizado
        self.text_area = tk.Text(frame, bg='#3e3e3e', fg='white', insertbackground='white')
        self.text_area.place(x=570, y=5, width=670, height=400)
        
        # Crear etiquetas que contienen el área de selección
        self.data_label1 = tk.Label(frame, text="Archivo de entrada1", bg='#2e2e2e', fg='white')
        self.data_label1.place(x=500, y=410, width=150, height=50)
        self.data_label2 = tk.Label(frame, text="Archivo de entrada5", bg='#2e2e2e', fg='white')
        self.data_label2.place(x=500, y=460, width=150, height=50)
        
        # Crear el área de texto donde se mostrará el país seleccionado
        self.img_area = tk.Text(frame, bg='#3e3e3e', fg='white', insertbackground='white')
        self.img_area.place(x=900, y=420, width=200, height=200)

    def abrir_archivo(self):
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
        self.text_area.delete("1.0", tk.END)
        data = self.left_text_area.get("1.0", tk.END)
        
        comando = subprocess.run(
            ["gfortran", "-o", "main.exe", "main.f90"],  
            check=True  
        )
        resultado = subprocess.run(
            ["./main.exe"],  
            input=data,  
            stdout=subprocess.PIPE,  
            text=True  
        )
        
        self.text_area.insert(tk.END, resultado.stdout)

    def guardar_archivo(self):
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
