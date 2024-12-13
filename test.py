import unittest
from func import Calculator

class TestCalculator(unittest.TestCase):

    def setUp(self):
        self.calc = Calculator()

    # Test basic arithmetic operations
    def test_add(self):
        self.assertEqual(self.calc.add(5, 3), 8)
        self.assertEqual(self.calc.add(-5, -3), -8)
        self.assertEqual(self.calc.add(5, -3), 2)

    def test_subtract(self):
        self.assertEqual(self.calc.subtract(10, 5), 5)
        self.assertEqual(self.calc.subtract(0, 5), -5)
        self.assertEqual(self.calc.subtract(-5, -5), 0)

    def test_multiply(self):
        self.assertEqual(self.calc.multiply(4, 3), 12)
        self.assertEqual(self.calc.multiply(-4, 3), -12)
        self.assertEqual(self.calc.multiply(0, 5), 0)

    def test_divide(self):
        self.assertEqual(self.calc.divide(10, 2), 5)
        with self.assertRaises(ValueError):
            self.calc.divide(10, 0)

    def test_modulus(self):
        self.assertEqual(self.calc.modulus(10, 3), 1)
        self.assertEqual(self.calc.modulus(10, 5), 0)

    # Test trigonometric functions
    def test_sine(self):
        self.assertAlmostEqual(self.calc.sine(30), 0.5, places=5)
        self.assertAlmostEqual(self.calc.sine(90), 1.0, places=5)

    def test_cosine(self):
        self.assertAlmostEqual(self.calc.cosine(60), 0.5, places=5)
        self.assertAlmostEqual(self.calc.cosine(0), 1.0, places=5)

    # Test power and roots
    def test_power(self):
        self.assertEqual(self.calc.power(2, 3), 8)
        self.assertEqual(self.calc.power(5, 0), 1)

    def test_square_root(self):
        self.assertEqual(self.calc.square_root(9), 3)
        with self.assertRaises(ValueError):
            self.calc.square_root(-4)

    # Test rounding functions
    def test_floor(self):
        self.assertEqual(self.calc.floor(4.7), 4)
        self.assertEqual(self.calc.floor(-4.7), -5)

    def test_ceil(self):
        self.assertEqual(self.calc.ceil(4.1), 5)
        self.assertEqual(self.calc.ceil(-4.1), -4)

    # Test memory functions
    def test_memory_functions(self):
        self.calc.memory_add(10)
        self.assertEqual(self.calc.memory_recall(), 10)
        self.calc.memory_clear()
        self.assertEqual(self.calc.memory_recall(), 0)

if __name__ == "__main__":
    unittest.main()
