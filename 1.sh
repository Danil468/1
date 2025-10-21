#!/bin/bash

# ----- Налаштування -----
OUTPUT_FILE="$HOME/system_stat.txt"  # файл для збереження
N=5  # кількість секунд для вимірювання середнього навантаження

# ----- Статистика процесора -----
CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
CPU_CORES=$(grep -c "^processor" /proc/cpuinfo)

# Завантаження CPU
echo "Обчислення середнього завантаження CPU протягом $N секунд..."
CPU_USAGE_BEFORE=$(grep 'cpu ' /proc/stat)
sleep $N
CPU_USAGE_AFTER=$(grep 'cpu ' /proc/stat)

# Розрахунок середнього відсотка завантаження CPU
CPU_DELTA_USER=$(($(echo $CPU_USAGE_AFTER | awk '{print $2}') - $(echo $CPU_USAGE_BEFORE | awk '{print $2}')))
CPU_DELTA_SYSTEM=$(($(echo $CPU_USAGE_AFTER | awk '{print $4}') - $(echo $CPU_USAGE_BEFORE | awk '{print $4}')))
CPU_DELTA_IDLE=$(($(echo $CPU_USAGE_AFTER | awk '{print $5}') - $(echo $CPU_USAGE_BEFORE | awk '{print $5}')))
CPU_TOTAL=$((CPU_DELTA_USER + CPU_DELTA_SYSTEM + CPU_DELTA_IDLE))
CPU_USAGE_PERCENT=$((100 * (CPU_DELTA_USER + CPU_DELTA_SYSTEM) / CPU_TOTAL))

# Кількість системних переривань
INTERRUPTS=$(grep -c "" /proc/interrupts)

# ----- Статистика пам'яті -----
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2 " " $3}')
MEM_FREE=$(grep MemFree /proc/meminfo | awk '{print $2 " " $3}')
MEM_BUFFERS=$(grep Buffers /proc/meminfo | awk '{print $2 " " $3}')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2 " " $3}')
SWAP_TOTAL=$(grep SwapTotal /proc/meminfo | awk '{print $2 " " $3}')
SWAP_FREE=$(grep SwapFree /proc/meminfo | awk '{print $2 " " $3}')

# ----- Запис у файл -----
{
echo "===== СИСТЕМНА СТАТИСТИКА ($(date)) ====="
echo ""
echo "--- ПРОЦЕСОР ---"
echo "Модель CPU: $CPU_MODEL"
echo "Кількість ядер: $CPU_CORES"
echo "Середнє завантаження CPU: $CPU_USAGE_PERCENT%"
echo "Кількість переривань: $INTERRUPTS"
echo ""
echo "--- ПАМ'ЯТЬ ---"
echo "Загальна пам'ять: $MEM_TOTAL"
echo "Вільна пам'ять: $MEM_FREE"
echo "Буферизована пам'ять: $MEM_BUFFERS"
echo "Доступна пам'ять: $MEM_AVAILABLE"
echo "Swap загальний: $SWAP_TOTAL"
echo "Swap вільний: $SWAP_FREE"
echo "==========================================="
} > "$OUTPUT_FILE"

echo "✅ Статистику збережено у файл: $OUTPUT_FILE"
