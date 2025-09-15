#!/bin/bash

echo "🔧 Исправление настроек GitHub..."
echo ""

# Проверяем, что мы в git репозитории
if [ ! -d ".git" ]; then
    echo "❌ Ошибка: Не найден git репозиторий"
    exit 1
fi

echo "📝 Введите правильные данные:"
echo ""

# Запрашиваем правильный username
read -p "Введите ваш GitHub username (НЕ email): " username

if [ -z "$username" ]; then
    echo "❌ Username не может быть пустым"
    exit 1
fi

# Запрашиваем название репозитория
read -p "Введите название репозитория: " repo_name

if [ -z "$repo_name" ]; then
    echo "❌ Название репозитория не может быть пустым"
    exit 1
fi

echo ""
echo "🔗 Подключение к правильному репозиторию..."
git remote add origin https://github.com/$username/$repo_name.git

echo "📤 Проверка подключения..."
git fetch origin

if [ $? -eq 0 ]; then
    echo "✅ Подключение успешно!"
    echo ""
    echo "📱 Ваш репозиторий: https://github.com/$username/$repo_name"
    echo "🌐 После настройки GitHub Pages приложение будет доступно по адресу:"
    echo "   https://$username.github.io/$repo_name"
    echo ""
    echo "🚀 Теперь можете запустить деплой:"
    echo "   ./deploy_github.sh"
else
    echo "❌ Ошибка подключения к репозиторию"
    echo "Проверьте:"
    echo "1. Правильность username"
    echo "2. Правильность названия репозитория"
    echo "3. Что репозиторий существует на GitHub"
    echo "4. Что репозиторий публичный"
    exit 1
fi
