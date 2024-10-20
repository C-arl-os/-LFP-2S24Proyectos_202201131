import tkinter as tk
from tkinter import filedialog, Menu, messagebox, ttk
import subprocess
import os

class MainWindow(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Analizador léxico")
        self.geometry("1400x600")
        self.configure(bg='#2e2e2e')

        self.archivo_abierto = None

        # Crear el menú principal
        menu_proyecto = Menu(self)
        self.config(menu=menu_proyecto)

        archivo_menu = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Archivo", menu=archivo_menu)
        archivo_menu.add_command(label="Abrir", command=self.abrir_archivo)
        archivo_menu.add_command(label="Nuevo", command=self.nuevo_archivo)
        archivo_menu.add_command(label="Guardar", command=self.guardar_archivo)
        archivo_menu.add_command(label="Guardar como...", command=self.guardar_como)
        archivo_menu.add_separator()
        archivo_menu.add_command(label="Salir", command=self.salir)

        analisis_menu = Menu(menu_proyecto, tearoff=0)
        menu_proyecto.add_cascade(label="Análisis y Tokens", menu=analisis_menu)
        analisis_menu.add_command(label="Análisis", command=self.enviar_datos)
        analisis_menu.add_command(label="Ver Tokens", command=self.mostrar_tokens)

        frame = tk.Frame(self, bg='#2e2e2e')
        frame.pack(fill=tk.BOTH, expand=True)

        self.left_text_area = tk.Text(frame, bg='black', fg='white', font=('Arial', 12))
        self.left_text_area.place(x=10, y=10, width=500, height=400)

        self.button_analisis = tk.Button(frame, text="Análisis", command=self.enviar_datos, bg='gray', fg='white', font=('Arial', 12))
        self.button_analisis.place(x=600, y=200, width=100, height=30)

        self.right_text_area = tk.Text(frame, bg='black', fg='white', font=('Arial', 12))
        self.right_text_area.place(x=800, y=10, width=500, height=400)

        self.bottom_label = tk.Label(frame, bg='#2e2e2e', fg='white', font=('Arial', 12))
        self.bottom_label.place(x=10, y=450, width=1300, height=50)

        # Crear un marco para el Treeview
        self.token_frame = tk.Frame(self)
        self.token_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        self.tree = ttk.Treeview(self.token_frame, columns=("Número de fila", "Lexema", "Tipo", "Fila", "Columna"), show='headings')
        self.tree.heading("Número de fila", text="Número de fila")
        self.tree.heading("Lexema", text="Lexema")
        self.tree.heading("Tipo", text="Tipo")
        self.tree.heading("Fila", text="Fila")
        self.tree.heading("Columna", text="Columna")

        # Crear una barra de desplazamiento
        self.scrollbar = ttk.Scrollbar(self.token_frame, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=self.scrollbar.set)

        self.tree.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        self.protocol("WM_DELETE_WINDOW", self.salir)  # Manejar el cierre de la ventana

    def confirmar_guardar(self):
        """Pregunta al usuario si desea guardar los cambios."""
        if self.left_text_area.get("1.0", tk.END).strip():  # Si hay texto en el área de edición
            respuesta = messagebox.askyesno("Guardar Cambios", "¿Desea guardar los cambios?")
            return respuesta
        return False

    def abrir_archivo(self):
        if self.confirmar_guardar():
            self.guardar_como()

        archivo = filedialog.askopenfilename(title="Abrir archivo", filetypes=[("Archivos de texto", "*.txt")])
        if archivo:
            with open(archivo, "r") as file:
                contenido = file.read()
                self.left_text_area.delete("1.0", tk.END)
                self.left_text_area.insert(tk.END, contenido)
            self.archivo_abierto = archivo

    def nuevo_archivo(self):
        if self.confirmar_guardar():
            self.guardar_como()
        self.left_text_area.delete("1.0", tk.END)
        self.archivo_abierto = None

    def guardar_archivo(self):
        if self.archivo_abierto:
            with open(self.archivo_abierto, "w") as file:
                contenido = self.left_text_area.get("1.0", tk.END)
                file.write(contenido)
        else:
            self.guardar_como()

    def guardar_como(self):
        archivo = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Archivos de texto", "*.txt")], title="Guardar archivo como")
        if archivo:
            with open(archivo, "w") as file:
                contenido = self.left_text_area.get("1.0", tk.END)
                file.write(contenido)
            self.archivo_abierto = archivo

    def salir(self):
        if self.confirmar_guardar():
            self.guardar_como()
        self.quit()

    def enviar_datos(self):
        base_dir = os.path.dirname(os.path.abspath(__file__))
        programa_path = os.path.join(base_dir, "analizador.exe")

        # Verifica si el archivo existe
        if not os.path.exists(programa_path):
            messagebox.showerror("Error", f"No se encontró el archivo: {programa_path}")
            return

        data = self.left_text_area.get("1.0", tk.END)

        # Subproceso para compilar los módulos de Fortran
        subprocess.run(["gfortran", "-c", "error.f90"], check=True)
        subprocess.run(["gfortran", "-c", "etiqueta.f90"], check=True)
        subprocess.run(["gfortran", "-c", "contenedor.f90"], check=True)
        subprocess.run(["gfortran", "-c", "texto.f90"], check=True)
        subprocess.run(["gfortran", "-c", "clave.f90"], check=True)
        subprocess.run(["gfortran", "-c", "boton.f90"], check=True)
        subprocess.run(["gfortran", "-c", "jerarquia.f90"], check=True)
        subprocess.run(["gfortran", "-c", "token.f90"], check=True)
        subprocess.run(["gfortran", "-c", "analizador.f90"], check=True)

        # Subproceso para enlazar los módulos y el programa principal
        subprocess.run(["gfortran", "-o", "analizador.exe", "analizador.o", "error.o", "etiqueta.o", "contenedor.o", "texto.o", "clave.o", "boton.o", "jerarquia.o", "token.o"], check=True)

        # Ejecutar el programa Fortran
        resultado = subprocess.run(
            [programa_path],
            input=data,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding='latin-1'
        )

        if resultado.returncode == 0:
            if resultado.stdout:
                salida = resultado.stdout.strip()
                self.right_text_area.delete("1.0", tk.END)
                self.right_text_area.insert(tk.END, salida)
            else:
                self.right_text_area.delete("1.0", tk.END)
                self.right_text_area.insert(tk.END, "No se generó salida.")
        else:
            self.right_text_area.delete("1.0", tk.END)
            self.right_text_area.insert(tk.END, f"Error en la ejecución de Fortran:\n{resultado.stderr}")

    def mostrar_tokens(self):
        # Limpiar la tabla
        for item in self.tree.get_children():
            self.tree.delete(item)

        # Leer el archivo de tokens
        try:
            with open("tokens.txt", "r", encoding='utf-8') as file:
                lineas = file.readlines()

            print(f"Número de líneas leídas: {len(lineas)}")  # Para depuración

            # Agregar cada token a la tabla
            for idx, linea in enumerate(lineas):
                if linea.strip():  # Solo procesa líneas no vacías
                    try:
                        lexema, tipo, fila, columna = [campo.strip() for campo in linea.split(",")]
                        self.tree.insert("", "end", values=(idx + 1, lexema, tipo, fila, columna))
                    except ValueError:
                        print(f"Error al procesar la línea: {linea}")

        except FileNotFoundError:
            messagebox.showerror("Error", "No se encontró el archivo tokens.txt.")
        except Exception as e:
            print(f"Ocurrió un error: {e}")

if __name__ == "__main__":
    app = MainWindow()
    app.mainloop()
