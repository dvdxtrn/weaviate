from datetime import datetime

def log_result(endpoint, response_time, status, body=None):
    print(f"[{datetime.now()}] Endpoint: {endpoint} | Time: {response_time:.2f}s | Status: {status}")
    if body:
        print(f"    Response Body: {body}")
