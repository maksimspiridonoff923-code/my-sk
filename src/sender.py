import aiohttp
import asyncio
import random
import logging

# --- НАСТРОЙКИ (ЗАМЕНИ НА СВОИ) ---
ID_INSTANCE = ""
API_TOKEN_INSTANCE = ""
API_BASE_URL = ""
CHAT_ID = "-"

DELAY_MIN = 3
DELAY_MAX = 7
CONCURRENT = 1

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
logger = logging.getLogger(__name__)

class MassSender:
    def __init__(self):
        self.messages = []
        self.index = 0
        self.sent = 0
        self.errors = 0
        self.load_messages()

    def load_messages(self):
        try:
            with open('words.txt', 'r', encoding='utf-8') as f:
                self.messages = [line.strip() for line in f if line.strip()]
            logger.info(f"✅ Загружено {len(self.messages)} сообщений")
        except FileNotFoundError:
            logger.error("❌ Файл words.txt не найден!")

    def get_next_message(self):
        if not self.messages:
            return "Тест"
        msg = self.messages[self.index]
        self.index = (self.index + 1) % len(self.messages)
        return msg

    async def send_one(self, session):
        async with self.semaphore:
            await asyncio.sleep(random.uniform(DELAY_MIN, DELAY_MAX))
            url = f"{API_BASE_URL}/waInstance{ID_INSTANCE}/sendMessage/{API_TOKEN_INSTANCE}"
            payload = {"chatId": CHAT_ID, "message": self.get_next_message()}
            try:
                async with session.post(url, json=payload, timeout=15) as resp:
                    if resp.status == 200:
                        self.sent += 1
                        return True
                    else:
                        self.errors += 1
                        return False
            except:
                self.errors += 1
                return False

    async def run(self):
        self.semaphore = asyncio.Semaphore(CONCURRENT)
        logger.info("🚀 Запуск рассылки")
        async with aiohttp.ClientSession() as session:
            tasks = set()
            try:
                while True:
                    if len(tasks) < CONCURRENT:
                        task = asyncio.create_task(self.send_one(session))
                        tasks.add(task)
                        task.add_done_callback(tasks.discard)
                    await asyncio.sleep(0.1)
            except KeyboardInterrupt:
                logger.info(f"\n🛑 Отправлено: {self.sent}, Ошибок: {self.errors}")

async def main():
    sender = MassSender()
    await sender.run()

if __name__ == "__main__":
    asyncio.run(main())
