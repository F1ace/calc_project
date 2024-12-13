#!/bin/bash

# Проверка аргументов
if [ -z "$1" ]; then
  echo "Не введен первый параметр, отвечающий за путь до директории с исходниками";
  exit 1
fi

if [ -z "$2" ]; then
  echo "Не введен второй параметр, отвечающий за версию проекта";
  exit 1
fi

# Установка переменных
srcdir=$1
version=$2
inputname=${srcdir##*/}
projname=${inputname}

# Печать путей для отладки
echo "Исходная директория: ${srcdir}"
echo "Название проекта: ${projname}"
echo "Версия: ${version}"

# Шаг 1: Загрузка актуального состояния с сервера (например, Git pull)
cd $srcdir
git pull origin main

# Шаг 2: Сборка проекта
# Здесь используем Python для сборки (для примера, в зависимости от вашего проекта, это может быть другой процесс)
echo "Сборка проекта..."
python3 setup.py build  # Или любой другой инструмент сборки

# Шаг 3: Сборка исполнимого файла с помощью PyInstaller
echo "Создание исполнимого файла с помощью PyInstaller..."
pyinstaller --onefile ui.py  # Генерация .exe файла

# Проверьте, что файл .exe был создан
#if [ ! -f "dist/$projname.exe" ]; then
echo "ЫъЫъЫъ!"
#  exit 1
#fi

# Шаг 4: Запуск юнит-тестов
echo "Запуск юнит-тестов..."
python -m unittest test.py  # Запуск тестов из конкретного файла

# Шаг 5: Создание установщика Inno Setup
echo "Создание установщика Inno Setup..."

# Указываем путь к файлу .iss (например, файл находится в D:/installer.iss)
innosetup_script="D:/installer.iss"

# В скрипте Inno Setup будут указаны пути к вашему проекту, а также версии
cat > $innosetup_script <<EOF
[Setup]
AppName=$projname
AppVersion=$version
DefaultDirName={pf}\\$projname
OutputDir=Output
OutputBaseFilename=$projname-$version

[Files]
Source: "D:/sosat/calc_project/func.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:/sosat/calc_project/test.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:/sosat/calc_project/ui.py"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:/sosat/calc_project/dist/$projname.exe"; DestDir: "{app}"; Flags: ignoreversion
EOF

# Запуск Inno Setup для создания .exe установщика
"C:/Program Files (x86)/Inno Setup 6/ISCC.exe" $innosetup_script

# Шаг 6: Создание Deb пакета
echo "Создание Deb пакета..."

# Подготовка структуры для Deb пакета
mkdir -p deb-package/DEBIAN
mkdir -p deb-package/usr/local/bin
mkdir -p deb-package/usr/local/lib/$projname

# Копируем все Python файлы в директорию пакета
cp $srcdir/main.py deb-package/usr/local/lib/$projname/
cp $srcdir/ui.py deb-package/usr/local/lib/$projname/
cp $srcdir/calc_operations.py deb-package/usr/local/lib/$projname/
cp $srcdir/calc_test.py deb-package/usr/local/lib/$projname/

# Создаем control файл для Deb пакета
cat > deb-package/DEBIAN/control <<EOF
Package: $projname
Version: $version
Architecture: amd64
Maintainer: Your Name <youremail@example.com>
Description: $projname - Калькулятор
Depends: python3
EOF

# Создаем deb пакет с помощью dpkg-deb
dpkg-deb --build deb-package

# Шаг 7: Установка приложения
echo "Установка приложения..."
OutputInstaller="Output/$projname-$version.exe"
if [ -f "$OutputInstaller" ]; then
  $OutputInstaller /S  # Установка в тихом режиме (silent mode)
else
  echo "Ошибка: установочный файл не найден!"
  exit 1
fi

DebPackage="deb-package.deb"
if [ -f "$DebPackage" ]; then
  sudo dpkg -i $DebPackage  # Установка Deb пакета
else
  echo "Ошибка: Deb пакет не найден!"
  exit 1
fi

echo "Процесс завершен успешно."
