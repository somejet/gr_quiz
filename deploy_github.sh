#!/bin/bash

echo "🚀 Деплой Греческого Квиза на GitHub Pages..."
echo ""

# Проверяем, что мы в git репозитории
if [ ! -d ".git" ]; then
    echo "❌ Ошибка: Не найден git репозиторий"
    echo "Сначала выполните: git init"
    exit 1
fi

# Собираем production версию
echo "📦 Создание production сборки..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Ошибка при сборке приложения"
    exit 1
fi

# Создаем ветку gh-pages если её нет
echo "🌿 Настройка ветки gh-pages..."
git checkout -b gh-pages 2>/dev/null || git checkout gh-pages

# Копируем файлы из build/web в корень
echo "📁 Копирование файлов..."
cp -r build/web/* .

# Добавляем файлы в git
git add .

# Коммитим изменения
git commit -m "Deploy to GitHub Pages: $(date)"

# Пушим в GitHub
echo "☁️ Загрузка на GitHub..."
git push origin gh-pages

echo ""
echo "✅ Деплой завершен!"
echo ""
echo "📱 Ваше приложение будет доступно по адресу:"
echo "   https://[ваш-username].github.io/[название-репозитория]"
echo ""
echo "🔄 Для обновления просто запустите этот скрипт снова"
echo ""

# Возвращаемся на основную ветку
git checkout main
