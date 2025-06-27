# 🩺 Automated Health Check System

## Overview
This system monitors the availability and performance of a web application's health endpoint.

## Features
- Async HTTP GET checks
- Configurable via `.env`
- Logs response time, status, and optional body fields
- Alerts on:
  - Slow responses
  - HTTP error codes
  - Failed health indicators (e.g., DB)

## Setup

### 1. Install dependencies
```bash
pip install -r requirements.txt
