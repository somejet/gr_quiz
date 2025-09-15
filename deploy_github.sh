#!/bin/bash

echo "🚀 Деплой Греческого Квиза на GitHub Pages..."
echo ""

# Проверяем, что мы в git репозитории
if [ ! -d ".git" ]; then
    echo "❌ Ошибка: Не найден git репозиторий"
    echo "Сначала выполните: git init"
    exit 1
fi

# Проверяем, что есть remote origin
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "❌ Ошибка: Не настроен remote origin"
    echo "Сначала выполните: ./setup_github.sh"
    exit 1
fi

# Собираем production версию
echo "📦 Создание production сборки..."
flutter build web --release --base-href "/$REPO_NAME/"

if [ $? -ne 0 ]; then
    echo "❌ Ошибка при сборке приложения"
    exit 1
fi

# Получаем URL репозитория для отображения ссылки
REPO_URL=$(git remote get-url origin)
USERNAME=$(echo $REPO_URL | sed 's/.*github\.com[:/]\([^/]*\).*/\1/')
REPO_NAME=$(echo $REPO_URL | sed 's/.*\/\([^/]*\)\.git$/\1/')

# Создаем ветку gh-pages если её нет
echo "🌿 Настройка ветки gh-pages..."
git checkout -b gh-pages 2>/dev/null || git checkout gh-pages

# Копируем файлы из build/web в корень
echo "📁 Копирование файлов..."
cp -r build/web/* .

# Добавляем файлы в git
git add .

# Коммитим изменения
git commit -m "Deploy to GitHub Pages: $(date '+%Y-%m-%d %H:%M:%S')"

# Пушим в GitHub
echo "☁️ Загрузка на GitHub..."
git push origin gh-pages

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Деплой завершен успешно!"
    echo ""
    echo "📱 Ваше приложение доступно по адресу:"
    echo "   https://$USERNAME.github.io/$REPO_NAME"
    echo ""
    echo "🔄 Для обновления просто запустите этот скрипт снова"
    echo ""
    echo "⏱️  GitHub Pages может потребовать несколько минут для обновления"
else
    echo "❌ Ошибка при загрузке на GitHub"
    exit 1
fi

# Возвращаемся на основную ветку
git checkout main
