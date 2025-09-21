#!/bin/bash

# Скрипт для проверки статуса GitHub Actions деплоя
echo "🔍 Проверка статуса GitHub Actions..."

# Получаем информацию о последнем запуске
RESPONSE=$(curl -s "https://api.github.com/repos/somejet/gr_quiz/actions/runs?per_page=1")

# Извлекаем статус и результат
STATUS=$(echo "$RESPONSE" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
CONCLUSION=$(echo "$RESPONSE" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)
URL=$(echo "$RESPONSE" | grep -o '"html_url":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "📊 Статус: $STATUS"
echo "📋 Результат: $CONCLUSION"
echo "🔗 Ссылка: $URL"

if [ "$STATUS" = "completed" ] && [ "$CONCLUSION" = "success" ]; then
    echo "✅ Деплой успешен! Приложение доступно по адресу:"
    echo "🌐 https://somejet.github.io/gr_quiz/"
elif [ "$STATUS" = "completed" ] && [ "$CONCLUSION" = "failure" ]; then
    echo "❌ Деплой завершился с ошибкой"
    echo "🔍 Проверьте логи по ссылке выше"
elif [ "$STATUS" = "in_progress" ]; then
    echo "⏳ Деплой в процессе..."
else
    echo "❓ Неизвестный статус: $STATUS"
fi
