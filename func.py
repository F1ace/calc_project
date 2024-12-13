import math

class Calculator:
    def __init__(self):
        self.memory = 0

    # Basic arithmetic operations
    def add(self, a, b):
        return a + b

    def subtract(self, a, b):
        return a - b

    def multiply(self, a, b):
        return a * b

    def divide(self, a, b):
        if b == 0:
            raise ValueError("Division by zero is not allowed.")
        return a / b

    def modulus(self, a, b):
        return a % b

    # Trigonometric functions
    def sine(self, angle):
        return math.sin(math.radians(angle))

    def cosine(self, angle):
        return math.cos(math.radians(angle))

    # Power and roots
    def power(self, base, exponent):
        return math.pow(base, exponent)

    def square_root(self, number):
        if number < 0:
            raise ValueError("Cannot compute the square root of a negative number.")
        return math.sqrt(number)

    # Rounding functions
    def floor(self, number):
        return math.floor(number)

    def ceil(self, number):
        return math.ceil(number)

    # Memory functions
    def memory_add(self, value):
        self.memory += value

    def memory_clear(self):
        self.memory = 0

    def memory_recall(self):
        return self.memory

# Example usage
if __name__ == "__main__":
    calc = Calculator()
    print("Addition: ", calc.add(5, 3))
    print("Sin(30): ", calc.sine(30))
    calc.memory_add(100)
    print("Memory Recall: ", calc.memory_recall())
