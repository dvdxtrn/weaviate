import os
import asyncio
import aiohttp
import time
from dotenv import load_dotenv
from utils import log_result
from alert import send_alert

load_dotenv()

HEALTH_ENDPOINT = os.getenv("HEALTH_ENDPOINT")
CHECK_INTERVAL = int(os.getenv("CHECK_INTERVAL", 300))
RESPONSE_THRESHOLD = float(os.getenv("RESPONSE_THRESHOLD", 3.0))
RETRIES = int(os.getenv("RETRIES", 3))
RETRY_DELAY = int(os.getenv("RETRY_DELAY", 2))

async def check_health(session):
    for attempt in range(1, RETRIES + 1):
        start = time.time()
        try:
            async with session.get(HEALTH_ENDPOINT) as response:
                resp_time = time.time() - start
                status = response.status
                body = await response.json()

                log_result(HEALTH_ENDPOINT, resp_time, status, body)

                if status != 200:
                    send_alert(f"❌ Error: Status code {status}")
                elif resp_time > RESPONSE_THRESHOLD:
                    send_alert(f"⚠️ Warning: Response time {resp_time:.2f}s exceeds threshold")

                if isinstance(body, dict) and body.get("database") != "healthy":
                    send_alert("❌ Error: Database health check failed")

                return
        except Exception as e:
            if attempt == RETRIES:
                send_alert(f"❌ Error: Health check failed after {RETRIES} retries: {e}")
            else:
                await asyncio.sleep(RETRY_DELAY)

async def scheduler():
    async with aiohttp.ClientSession() as session:
        while True:
            await check_health(session)
            await asyncio.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    asyncio.run(scheduler())
