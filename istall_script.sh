#!/bin/bash

# Определение ОС
OS_TYPE=$(uname 2>/dev/null  echo "Windows")

# Функция обработки ошибок
handle_error() {
    echo "[ERROR] Произошла ошибка на шаге: $1"
    exit 1
}

# Функция установки приложения
install_app() {
    if [[ "$OS_TYPE" == "Linux" ]]; then
        echo "[INFO] Установка приложения для Linux..."
        sudo cp dist/calculator_app /usr/local/bin/  handle_error "установка приложения"
    elif [[ "$OS_TYPE" == "Windows" ]]; then
        echo "[INFO] Установка приложения для Windows..."
        mkdir -p "C:\\Program Files\\CalculatorApp"  handle_error "создание директории"
        cp dist\\calculator_app.exe "C:\\Program Files\\CalculatorApp\\"  handle_error "копирование приложения"
    else
        echo "[ERROR] Неизвестная ОС!"
        exit 1
    fi
}

# 1. Загрузка актуального состояния с сервера
echo "[INFO] Обновление репозитория..."
git pull origin main  handle_error "обновление репозитория"

echo "[INFO] Проверка и слияние веток..."
git checkout func  handle_error "переход на ветку func"
git merge ui  handle_error "слияние ветки ui в func"
git checkout main  handle_error "переход на ветку main"
git merge func  handle_error "слияние ветки func в main"

# 2. Установка зависимостей
echo "[INFO] Установка необходимых зависимостей..."
pip install -r requirements.txt  handle_error "установка зависимостей"

# 3. Запуск тестов
echo "[INFO] Запуск тестов..."
python -m unittest discover -s tests  handle_error "выполнение тестов"

# 4. Создание установщика
echo "[INFO] Создание установщика..."
if [[ "$OS_TYPE" == "Linux" ]]; then
    pyinstaller --onefile --name calculator_app main.py  handle_error "создание установщика"
elif [[ "$OS_TYPE" == "Windows" ]]; then
    pyinstaller --onefile --name calculator_app.exe main.py || handle_error "создание установщика"
fi

# 5. Установка приложения
install_app

# Завершение
echo "[INFO] Непрерывная интеграция завершена успешно."