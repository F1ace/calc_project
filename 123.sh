@echo off

:: Проверка аргументов
if "%~1"=="" (
  echo Не указан первый параметр: путь до директории с исходниками.
  exit /b 1
)
if "%~2"=="" (
  echo Не указан второй параметр: версия проекта.
  exit /b 1
)

:: Установка переменных
set srcdir=%~1
set version=%~2
set projname=CalculatorApp  :: Название проекта
set builddir=%srcdir%\build  :: Каталог для сборки
set outputdir=%srcdir%       :: Каталог, куда будет собран установщик

echo Исходная директория: %srcdir%
echo Название проекта: %projname%
echo Версия: %version%

:: Проверка наличия необходимых инструментов
echo Проверка наличия необходимых инструментов...
for %%C in (git pyinstaller zip) do (
  where %%C >nul 2>nul || (
    echo Ошибка: %%C не установлен. Установите его перед запуском скрипта.
    exit /b 1
  )
)

:: Шаг 1: Обновление репозитория
cd /d %srcdir%
echo Обновление репозитория...
git pull origin main || exit /b 1

:: Шаг 2: Сборка исполняемого файла с помощью PyInstaller
echo Создание исполняемого файла с помощью PyInstaller...
pyinstaller --onefile --distpath "%builddir%" --name "%projname%" main.py
if not exist "%builddir%\%projname%.exe" (
  echo Ошибка: исполняемый файл не был создан!
  exit /b 1
)
echo Исполняемый файл создан: %builddir%\%projname%.exe

:: Шаг 3: Создание структуры для установщика
echo Создание структуры установщика...
set installer_dir=%builddir%\installer
mkdir "%installer_dir%"

:: Копируем исполняемый файл
copy "%builddir%\%projname%.exe" "%installer_dir%" >nul

:: Создаём README файл
set readme_path=%installer_dir%\README.txt
echo %projname% - простой калькулятор.> "%readme_path%"
echo Версия: %version% >> "%readme_path%"
echo Запустите %projname%.exe, чтобы использовать приложение. >> "%readme_path%"

:: Шаг 4: Архивирование в zip
echo Архивирование установщика...
set zipfile=%outputdir%\%projname%_%version%.zip
cd "%installer_dir%"
zip -r "%zipfile%" * >nul

if not exist "%zipfile%" (
  echo Ошибка: zip архив не был создан!
  exit /b 1
)
echo Установочный zip архив создан: %zipfile%

:: Завершение
echo Скрипт завершён успешно.
exit /b 0
