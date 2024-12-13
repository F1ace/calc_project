#!/bin/bash

# Функция для обработки ошибок
handle_error() {
    echo "[ERROR] Произошла ошибка на шаге: $1"
    exit 1
}

# 1. Загрузка актуального состояния с сервера
echo "[INFO] Обновление репозитория..."
git pull origin main  handle_error "обновление репозитория"

echo "[INFO] Проверка и слияние веток..."
git checkout func  handle_error "переход на ветку func"
git merge ui  handle_error "слияние ветки ui в func"
git checkout main  handle_error "переход на ветку main"
git merge func  handle_error "слияние ветки func в main"

# 2. Сборка проекта и unittest
echo "[INFO] Установка необходимых зависимостей..."
pip install -r requirements.txt  handle_error "установка зависимостей"

# 3. Выполнение unittest
echo "[INFO] Запуск тестов..."
python -m unittest discover -s tests  handle_error "выполнение тестов"

# 4. Создание установщика
echo "[INFO] Создание установщика..."
pyinstaller --onefile --name calculator_app main.py  handle_error "создание установщика"

# 5. Установка приложения
echo "[INFO] Установка приложения..."
sudo cp dist/calculator_app /usr/local/bin/ || handle_error "установка приложения"

# Завершение скрипта
echo "[INFO] Непрерывная интеграция завершена успешно."