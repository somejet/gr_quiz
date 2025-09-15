#!/bin/bash

echo "🚀 Подготовка к деплою на Netlify..."
echo ""

# Собираем production версию
echo "📦 Создание production сборки..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Ошибка при сборке приложения"
    exit 1
fi

# Создаем архив для загрузки
echo "📁 Создание архива..."
cd build/web
zip -r ../../greek-quiz-app.zip .
cd ../..

echo ""
echo "✅ Архив создан: greek-quiz-app.zip"
echo ""
echo "📋 Инструкции для Netlify:"
echo "1. Зайдите на https://netlify.com"
echo "2. Нажмите 'Add new site' -> 'Deploy manually'"
echo "3. Перетащите файл greek-quiz-app.zip в область загрузки"
echo "4. Ваше приложение будет доступно по адресу типа:"
echo "   https://[случайное-имя].netlify.app"
echo ""
echo "🔄 Для обновления:"
echo "1. Запустите этот скрипт снова"
echo "2. Загрузите новый архив на Netlify"
echo ""
