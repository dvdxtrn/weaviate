# 🩺 Automated Health Check System

A lightweight, configurable health check system designed to monitor web applications for availability, performance, and subsystem health. Built with production-grade practices using Python, async I/O, and optional Docker containerization.

---

## 📌 Features

- 🕒 **Configurable Interval**: Define how often checks run (default: every 5 minutes).
- 🌐 **HTTP Monitoring**: Sends async HTTP GET requests to a target `/health` endpoint.
- ⏱️ **Response Time Tracking**: Logs response time for each request.
- ✅ **Status Code Validation**: Alerts on non-200 responses.
- 🔍 **Optional Health Indicators**: Parses JSON response to validate custom health fields (e.g., `database: "healthy"`).
- 🔔 **Alert System (Mock)**: Simulates Slack/email alerting when failures are detected.
- 🐳 **Docker-Ready**: Containerized for portability and deployment ease.
- 🔁 **Retry Logic**: Handles transient failures with automatic retries.

---

## 📂 Project Structure

```
health\_check/
├── health\_check.py        # Main health check loop
├── utils.py               # Logging helper
├── alert.py               # Mock alert sender
├── config.env             # Environment variables
├── requirements.txt       # Python dependencies
├── Dockerfile             # Container config
└── README.md              # Project documentation
````

---

## ⚙️ Configuration

All settings are controlled via the `.env` or `config.env` file.

| Variable              | Description                                   | Default       |
|-----------------------|-----------------------------------------------|---------------|
| `HEALTH_ENDPOINT`     | Full URL of the health check endpoint         | *(required)*  |
| `CHECK_INTERVAL`      | Time between checks (in seconds)              | `300`         |
| `RESPONSE_THRESHOLD`  | Max acceptable response time (in seconds)     | `3.0`         |
| `RETRIES`             | Number of retry attempts on failure           | `3`           |
| `RETRY_DELAY`         | Delay between retries (in seconds)            | `2`           |

Example `config.env`:

```env
HEALTH_ENDPOINT=https://api.example.com/health
CHECK_INTERVAL=300
RESPONSE_THRESHOLD=3.0
RETRIES=3
RETRY_DELAY=2
````

---

## 🚀 Running Locally

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Set up environment

```bash
cp config.env .env
```

### 3. Run the health check

```bash
python health_check.py
```

---

## 🐳 Running in Docker

### 1. Build the Docker image

```bash
docker build -t health-check .
```

### 2. Run the container with environment config

```bash
docker run --env-file config.env health-check
```

> ℹ️ The container runs the script indefinitely, checking the target endpoint at the configured interval.

---

## 📊 Example Output

### Normal log

```
[2025-06-26 14:00:00] Endpoint: https://api.example.com/health | Time: 0.89s | Status: 200
```

### Alert log (mock)

```
[ALERT] ⚠️ Warning: Response time 4.23s exceeds threshold
[ALERT] ❌ Error: Status code 500
[ALERT] ❌ Error: Database health check failed
```

---

## 🔧 Extending Functionality

You can enhance this system further:

* ✅ Replace the mock `send_alert()` with:

  * Slack Webhooks
  * Email (SMTP)
  * PagerDuty / Opsgenie API
* 📈 Push metrics to:

  * Prometheus
  * Datadog
  * CloudWatch
* 🌍 Support multiple endpoints using a list + `asyncio.gather()`
* 🧪 Add unit tests for alerting, retry logic, and JSON parsing

---

## 🧪 Example `/health` Endpoint Payload

```json
{
  "status": "ok",
  "database": "healthy",
  "cache": "healthy"
}
```

The script will alert if any of these are `"unhealthy"`.

---

## 👷 Troubleshooting

| Problem                        | Solution                                              |
| ------------------------------ | ----------------------------------------------------- |
| `ModuleNotFoundError`          | Run `pip install -r requirements.txt`                 |
| Docker env vars not applied    | Check `.env` or `--env-file config.env` syntax        |
| No alerts firing               | Ensure endpoint returns 200+ JSON with `database` key |
| Docker logs not showing output | Use `docker logs <container_id>` to see live logs     |