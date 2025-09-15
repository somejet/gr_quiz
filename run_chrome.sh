#!/bin/bash
# Скрипт для быстрого запуска Flutter приложения

echo "🚀 Запуск Greek Quiz App..."

# Проверяем, запущено ли уже приложение
if pgrep -f "flutter run" > /dev/null; then
    echo "📱 Приложение уже запущено. Выполняем горячую перезагрузку..."
    echo "r" | flutter run -d chrome
else
    echo "🌐 Запускаем приложение в Chrome..."
    flutter run -d chrome
fi
