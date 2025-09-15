#!/bin/bash

echo "🚀 Настройка GitHub Pages для Греческого Квиза"
echo "=============================================="
echo ""

# Проверяем, что мы в git репозитории
if [ ! -d ".git" ]; then
    echo "❌ Ошибка: Не найден git репозиторий"
    echo "Сначала выполните: git init"
    exit 1
fi

# Проверяем, есть ли remote origin
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "📝 Настройка подключения к GitHub..."
    echo ""
    echo "Сначала создайте репозиторий на GitHub:"
    echo "1. Откройте https://github.com"
    echo "2. Нажмите 'New repository'"
    echo "3. Назовите репозиторий (например: greek-quiz-app)"
    echo "4. Сделайте его ПУБЛИЧНЫМ"
    echo "5. НЕ добавляйте README, .gitignore, license"
    echo ""
    read -p "Введите ваш GitHub username: " username
    read -p "Введите название репозитория: " repo_name
    
    if [ -z "$username" ] || [ -z "$repo_name" ]; then
        echo "❌ Username и название репозитория не могут быть пустыми"
        exit 1
    fi
    
    echo ""
    echo "🔗 Подключение к GitHub репозиторию..."
    git remote add origin https://github.com/$username/$repo_name.git
    git branch -M main
    
    echo "📤 Загрузка кода на GitHub..."
    git push -u origin main
    
    if [ $? -ne 0 ]; then
        echo "❌ Ошибка при загрузке на GitHub"
        echo "Проверьте, что репозиторий создан и доступен"
        exit 1
    fi
    
    echo "✅ Код успешно загружен на GitHub!"
    echo ""
    echo "🌐 Теперь включите GitHub Pages:"
    echo "1. Перейдите на https://github.com/$username/$repo_name"
    echo "2. Нажмите 'Settings'"
    echo "3. Найдите 'Pages' в левом меню"
    echo "4. Source: 'Deploy from a branch'"
    echo "5. Branch: 'gh-pages'"
    echo "6. Folder: '/ (root)'"
    echo "7. Нажмите 'Save'"
    echo ""
    read -p "Нажмите Enter когда настроите GitHub Pages..."
else
    echo "✅ GitHub репозиторий уже подключен"
fi

echo ""
echo "🚀 Запуск деплоя на GitHub Pages..."
./deploy_github.sh

echo ""
echo "🎉 Готово! Ваше приложение размещено в интернете!"
echo ""
echo "📱 Ссылка на приложение:"
git remote get-url origin | sed 's/github.com/[ваш-username].github.io/' | sed 's/\.git$//' | sed 's/https:\/\/github\.com/https:\/\/' | sed 's/\/[^\/]*$/\/[название-репозитория]/'
echo ""
echo "💡 Замените [ваш-username] и [название-репозитория] на реальные значения"
