#!/bin/bash

echo "🚀 Запуск standalone версии Греческого Квиза..."
echo ""

# Проверяем, есть ли production сборка
if [ ! -d "build/web" ]; then
    echo "📦 Создание production сборки..."
    flutter build web --release
    echo ""
fi

# Останавливаем предыдущий сервер если он запущен
echo "🛑 Остановка предыдущего сервера..."
lsof -ti:8080 | xargs kill -9 2>/dev/null || true

# Запускаем HTTP сервер
echo "🌐 Запуск веб-сервера..."
cd build/web
python3 -m http.server 8080 --bind 0.0.0.0 &

# Получаем IP адрес
IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -1 | awk '{print $2}')

echo ""
echo "✅ Приложение запущено!"
echo ""
echo "📱 Для доступа с телефона откройте в браузере:"
echo "   http://$IP:8080"
echo ""
echo "💻 Для доступа с компьютера откройте:"
echo "   http://localhost:8080"
echo ""
echo "🛑 Для остановки нажмите Ctrl+C"
echo ""

# Ждем завершения
wait
