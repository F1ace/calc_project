#!/bin/bash

# Проверка аргументов
if [ -z "$1" ]; then
  echo "Не введен первый параметр, отвечающий за путь до директории с исходниками"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Не введен второй параметр, отвечающий за версию проекта"
  exit 1
fi

# Установка переменных
srcdir=$1
version=$2
projname="CalculatorApp"  # Название проекта
builddir="$srcdir/build"  # Каталог для сборки deb
debdir="$builddir/$projname-$version"  # Каталог структуры deb пакета
outputdir="$srcdir"       # Каталог, куда будет собран deb файл

echo "Исходная директория: $srcdir"
echo "Название проекта: $projname"
echo "Версия: $version"

# Проверка наличия необходимых инструментов
echo "Проверка наличия необходимых инструментов..."
for cmd in git pyinstaller dpkg-deb; do
  if ! command -v $cmd &>/dev/null; then
    echo "Ошибка: $cmd не установлен. Установите его перед запуском скрипта."
    exit 1
  fi
done

# Шаг 1: Обновление репозитория
cd $srcdir || exit
git pull origin main

# Шаг 2: Сборка исполняемого файла с помощью PyInstaller
echo "Создание исполнимого файла с помощью PyInstaller..."
pyinstaller --onefile --distpath "$builddir" --name "$projname" main.py

if [ ! -f "$builddir/$projname" ]; then
  echo "Ошибка: исполняемый файл не был создан!"
  exit 1
fi

echo "Исполняемый файл создан: $builddir/$projname"

# Шаг 3: Создание структуры для deb пакета
echo "Создание структуры deb пакета..."
mkdir -p "$debdir/DEBIAN" "$debdir/usr/local/bin"

# Файл control
cat <<EOF >"$debdir/DEBIAN/control"
Package: $projname
Version: $version
Section: utils
Priority: optional
Architecture: all
Maintainer: Your Name <your.email@example.com>
Description: $projname - простой калькулятор
EOF

# Перемещение файла
cp "$builddir/$projname" "$debdir/usr/local/bin/$projname"

# Шаг 4: Сборка deb пакета
echo "Сборка deb пакета..."
dpkg-deb --build "$debdir"

if [ ! -f "$debdir.deb" ]; then
  echo "Ошибка: deb пакет не был создан!"
  exit 1
fi

# Перемещение пакета в исходную директорию
mv "$debdir.deb" "$outputdir/${projname}_${version}.deb"
echo "DEB пакет создан: $outputdir/${projname}_${version}.deb"
