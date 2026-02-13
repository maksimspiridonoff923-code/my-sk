@echo off
chcp 65001 > nul
title MAX Sender
color 0A
echo ========================================
echo         MAX SENDER - ЗАПУСК
echo ========================================
echo.
echo [1/4] Проверка Python...
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [✗] Python не найден!
    echo     Скачай: https://python.org
    pause
    exit
)
echo [✓] Python найден
echo.
echo [2/4] Установка библиотек...
pip install aiohttp -q
echo [✓] Готово
echo.
echo [3/4] Проверка words.txt...
if not exist words.txt (
    echo Привет! Как сам? > words.txt
    echo Есть минутка? >> words.txt
    echo Скинул материалы, посмотри >> words.txt
    echo Го обсудим >> words.txt
    echo Жду ответ >> words.txt
    echo [✓] Создан words.txt с тестовыми сообщениями
) else (
    echo [✓] words.txt найден
)
echo.
echo [4/4] Запуск скрипта...
echo.
python src/sender.py
pause
