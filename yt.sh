#!/bin/bash

# Проверка установки yt-dlp (лучше, чем youtube-dl)
if ! command -v yt-dlp &> /dev/null; then
    echo "Устанавливаем yt-dlp..."
    sudo apt update && sudo apt install -y python3-pip
    pip3 install yt-dlp
fi

# Временный файл для рабочих ссылок
TMP_FILE="working_links.txt"
touch "$TMP_FILE"

# Проверка каждой ссылки
while read -r url; do
    # Пропускаем пустые строки
    if [ -z "$url" ]; then
        continue
    fi

    echo "Проверяем: $url"
    
    # Пробуем получить информацию о видео (без скачивания)
    if yt-dlp --skip-download --quiet --no-warnings "$url" &> /dev/null; then
        echo "$url" >> "$TMP_FILE"
        echo "✅ Рабочая ссылка"
    else
        echo "❌ Удалено или недоступно"
    fi
done < "Link.txt"

# Перезаписываем исходный файл рабочими ссылками
mv "$TMP_FILE" "Link.txt"

echo "Готово! Неудалённые ссылки сохранены в Link.txt"
