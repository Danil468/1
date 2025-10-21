#!/bin/bash

# Перевірка кількості параметрів
if [ $# -ne 2 ]; then
    echo "Використання: $0 <шлях_до_директорії> <ext|size>"
    exit 1
fi

DIR=$1
MODE=$2

# Перевірка чи директорія існує
if [ ! -d "$DIR" ]; then
    echo "Помилка: $DIR не є директорією!"
    exit 1
fi

cd "$DIR" || exit 1

# Виведення інформації
if [ "$MODE" = "size" ]; then
    echo "Sorting directory contents by file size:"
    echo "------------------------------------------"
    ls -lhS --group-directories-first
elif [ "$MODE" = "ext" ]; then
    echo "Sorting directory contents by extension:"
    echo "------------------------------------------"
    ls -lX --group-directories-first
else
    echo "Невідомий параметр: $MODE"
    echo "Використовуйте 'ext' або 'size'"
    exit 1
fi
