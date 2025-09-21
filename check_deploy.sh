#!/bin/bash

# Скрипт для проверки статуса GitHub Actions деплоя
echo "🔍 Проверка статуса GitHub Actions..."

# Получаем информацию о последнем запуске
RESPONSE=$(curl -s "https://api.github.com/repos/somejet/gr_quiz/actions/runs?per_page=1")

# Извлекаем статус и результат
STATUS=$(echo "$RESPONSE" | jq -r '.workflow_runs[0].status // "unknown"')
CONCLUSION=$(echo "$RESPONSE" | jq -r '.workflow_runs[0].conclusion // "unknown"')
URL=$(echo "$RESPONSE" | jq -r '.workflow_runs[0].html_url // "unknown"')

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
    echo "❓ Статус: $STATUS, Результат: $CONCLUSION"
fi
