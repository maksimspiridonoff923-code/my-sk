#!/bin/bash
# MAX Sender - Запуск для Linux/Mac

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================"
echo "         MAX SENDER - ЗАПУСК"
echo "========================================"
echo ""

# Проверка Python
echo "[1/4] Проверка Python..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}[✗] Python3 не найден!${NC}"
    echo "    Установи: sudo apt install python3 (или brew install python3)"
    exit 1
else
    echo -e "${GREEN}[✓] Python3 найден${NC}"
fi

# Установка библиотек
echo ""
echo "[2/4] Установка библиотек..."
pip3 install aiohttp -q 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] Библиотеки установлены${NC}"
else
    pip3 install aiohttp --user -q
    echo -e "${GREEN}[✓] Библиотеки установлены (локально)${NC}"
fi

# Проверка config.json
echo ""
echo "[3/4] Проверка config.json..."
if [ ! -f "config.json" ]; then
    echo -e "${BLUE}[!] Первый запуск. Создаём config.json...${NC}"
    cat > config.json << 'EOL'
{
    "ID_INSTANCE": "",
    "API_TOKEN_INSTANCE": "",
    "API_BASE_URL": "https://api.green-api.com",
    "CHAT_ID": "",
    "DELAY_MIN": 3,
    "DELAY_MAX": 7,
    "CONCURRENT": 1
}
EOL
    echo -e "${RED}⚠️  Открой config.json и вставь свои данные!${NC}"
    echo "    nano config.json"
    echo ""
    read -p "Нажми Enter после редактирования..."
else
    echo -e "${GREEN}[✓] config.json найден${NC}"
fi

# Проверка words.txt
echo ""
echo "[4/4] Проверка words.txt..."
if [ ! -f "words.txt" ]; then
    echo -e "${BLUE}[!] Создаём words.txt...${NC}"
    cat > words.txt << 'EOL'
Привет! Как сам?
Есть минутка?
Скинул материалы, посмотри
Го обсудим
Жду ответ
EOL
    echo -e "${GREEN}[✓] Создан words.txt${NC}"
    echo "    Отредактируй: nano words.txt"
else
    echo -e "${GREEN}[✓] words.txt найден${NC}"
fi

echo ""
echo "========================================"
echo -e "${GREEN}[✓] Запуск скрипта...${NC}"
echo "========================================"
echo ""

python3 src/sender.py
