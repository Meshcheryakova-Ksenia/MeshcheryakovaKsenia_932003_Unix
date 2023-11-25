#!/bin/sh

# Функция для генерации случайного идентификатора
generate_id() {
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1
}

# Функция для получения следующего доступного имени файла
get_next_filename() {
exec 9</dev/null
flock -x 9

i=1
while [ -f "/shared_volume/$(printf "%03d" $i)" ]; do
i=$((i+1))
done

printf "%03d" $i
}

# Функция для создания и удаления файла с задержкой
operate_file() {

filename=$(get_next_filename)
id=$(generate_id)

echo "Контейнер $id создает файл $filename"
echo "$id $filename" > "/shared_volume/$filename"

# снятие блокировки после создания файла
exec 9<&-

sleep 1

echo "Контейнер $id удаляет файл $filename"
rm "/shared_volume/$filename"

sleep 1
}

# Основной цикл программы
while true; do
operate_file
done
