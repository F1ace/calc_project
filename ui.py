import tkinter as tk
from func import Calculator

class CalculatorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Calculator")
        self.calculator = Calculator()
        self.memory_value = 0

        # Entry widget for display
        self.display = tk.Entry(root, width=20, font=("Arial", 18), borderwidth=2, relief="solid", justify="right")
        self.display.grid(row=0, column=0, columnspan=4)

        # Buttons layout
        self.create_buttons()

    def create_buttons(self):
        button_texts = [
            ("7", 1, 0), ("8", 1, 1), ("9", 1, 2), ("/", 1, 3),
            ("4", 2, 0), ("5", 2, 1), ("6", 2, 2), ("*", 2, 3),
            ("1", 3, 0), ("2", 3, 1), ("3", 3, 2), ("-", 3, 3),
            ("0", 4, 0), (".", 4, 1), ("=", 4, 2), ("+", 4, 3),
            ("sin", 5, 0), ("cos", 5, 1), ("^", 5, 2), ("sqrt", 5, 3),
            ("MC", 6, 0), ("MR", 6, 1), ("M+", 6, 2), ("C", 6, 3)
        ]

        for (text, row, col) in button_texts:
            button = tk.Button(self.root, text=text, width=5, height=2, font=("Arial", 14),
                               command=lambda t=text: self.on_button_click(t))
            button.grid(row=row, column=col, padx=5, pady=5)

    def on_button_click(self, button_text):
        if button_text.isdigit() or button_text == ".":
            self.display.insert(tk.END, button_text)
        elif button_text in {"+", "-", "*", "/", "^"}:
            self.display.insert(tk.END, f" {button_text} ")
        elif button_text == "=":
            try:
                expression = self.display.get().replace("^", "**")
                result = eval(expression)
                self.display.delete(0, tk.END)
                self.display.insert(0, str(result))
            except Exception as e:
                self.display.delete(0, tk.END)
                self.display.insert(0, "Error")
        elif button_text == "C":
            self.display.delete(0, tk.END)
        elif button_text == "sin":
            try:
                value = float(self.display.get())
                result = self.calculator.sine(value)
                self.display.delete(0, tk.END)
                self.display.insert(0, str(result))
            except Exception as e:
                self.display.delete(0, tk.END)
                self.display.insert(0, "Error")
        elif button_text == "cos":
            try:
                value = float(self.display.get())
                result = self.calculator.cosine(value)
                self.display.delete(0, tk.END)
                self.display.insert(0, str(result))
            except Exception as e:
                self.display.delete(0, tk.END)
                self.display.insert(0, "Error")
        elif button_text == "sqrt":
            try:
                value = float(self.display.get())
                result = self.calculator.square_root(value)
                self.display.delete(0, tk.END)
                self.display.insert(0, str(result))
            except Exception as e:
                self.display.delete(0, tk.END)
                self.display.insert(0, "Error")
        elif button_text == "MC":
            self.calculator.memory_clear()
        elif button_text == "MR":
            self.display.delete(0, tk.END)
            self.display.insert(0, str(self.calculator.memory_recall()))
        elif button_text == "M+":
            try:
                value = float(self.display.get())
                self.calculator.memory_add(value)
                self.display.delete(0, tk.END)
            except Exception as e:
                self.display.delete(0, tk.END)
                self.display.insert(0, "Error")

if __name__ == "__main__":
    root = tk.Tk()
    app = CalculatorApp(root)
    root.mainloop()
