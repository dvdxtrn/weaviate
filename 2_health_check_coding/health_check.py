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
    # Try up to RETRIES times if something goes wrong
    for attempt in range(1, RETRIES + 1):
        start = time.time()  # Start timing the request

        try:
            # Send an async GET request to the health endpoint
            async with session.get(HEALTH_ENDPOINT) as response:
                resp_time = time.time() - start  # Measure response time
                status = response.status  # Get the HTTP status code
                body = await response.json()  # Parse the JSON body

                # Log the result for visibility and auditing
                log_result(HEALTH_ENDPOINT, resp_time, status, body)

                # Alert if status code is anything other than 200 (OK)
                if status != 200:
                    send_alert(f"❌ Error: Status code {status}")

                # Alert if the response time exceeds the configured threshold
                elif resp_time > RESPONSE_THRESHOLD:
                    send_alert(f"⚠️ Warning: Response time {resp_time:.2f}s exceeds threshold")

                # Check application-level health indicator (e.g., database status)
                if isinstance(body, dict) and body.get("database") != "healthy":
                    send_alert("❌ Error: Database health check failed")

                # If everything is fine, exit the function early (no retries needed)
                return

        except Exception as e:
            # If this was the final retry, send an error alert with exception details
            if attempt == RETRIES:
                send_alert(f"❌ Error: Health check failed after {RETRIES} retries: {e}")
            else:
                # Wait before retrying
                await asyncio.sleep(RETRY_DELAY)


async def scheduler():
    # Create a single aiohttp client session to reuse across health checks
    # This is more efficient than creating a new session every time
    async with aiohttp.ClientSession() as session:
        
        # Start an infinite loop to continuously run health checks
        while True:
            # Perform a single health check using the shared session
            await check_health(session)

            # Wait for the configured interval before running the next check
            # This keeps the checks evenly spaced and non-blocking
            await asyncio.sleep(CHECK_INTERVAL)


if __name__ == "__main__":
    asyncio.run(scheduler())
