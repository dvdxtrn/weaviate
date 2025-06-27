# Weaviate SRE Technical Challenge

## 👋 Introduction

This repository contains my completed submission for the **Client-Focused SRE - Technical Challenge** provided by Weaviate. I approached this challenge with production-level quality and real-world SRE principles in mind — focusing on observability, automation, and clarity.

The technical challenge spans three areas — Terraform review, a coding automation task, and a post-mortem report.

Each represent an area of my experience beginning from familiarity to proficiency and ultimately expertise. 

For this reason, I would like to add that I really enjoyed working on this challenge and appreciate the thought and care that went into its design.

- **Post-mortems and incident analysis** are squarely within my domain of expertise. One of my primary responsibilities was Incident Management. As a technical leader, if the issue could be identify and resolved without needing the SME, I would have effectively saved valuable resources that could be spent on other high priority tasks for both operations and development teams. When this was not possible, the decision to declare an incident was swift and assumed the Incident Commander role end to end.
  
- **Terraform and Python scripting**, however, are not tools I use daily. I approached those parts of the challenge as a chance to **demonstrate my ability to learn quickly and adapt**. My goal wasn’t to be perfect, but to reflect how I would ramp up in a real environment — with production-quality practices, clean structure, and practical implementation.

This mindset is how I operate as an SRE: I lean into unfamiliar areas, ask the right questions, and aim for scalable, supportable solutions even when I’m not the domain expert. I applied those same principles here — treating each deliverable with care, structure, and the intent to grow.

---

## ✅ Challenge Overview

### 1. 🔍 Terraform Code Review

File: [`terraform_review.md`](./terraform_review.md)

I reviewed the provided Terraform code with a focus on:

- Infrastructure stability and correctness  
- Provider pinning and module design  
- Resource lifecycle considerations  
- Security, DRY principles, and tagging  

My suggestions are documented clearly with justification and practical improvements.

---

#### 🧠 Thought Process

I approached the Terraform review exactly as I would if it were assigned to me to complete as an engineer. This area of expertise was not in my daily usage, so I relied on AI to build on the fundamentals that I understand and sharpen it in the interest of time. If there was no time pressure, I approach with trial and error method in a testing environment to successfully provision the environment and then begin to refactor, improve, and find the best practices for reliability.


---

##### 🛠️ Practical Workflow

- **Version Control**: Created a dedicated Git repository and committed the provided code to a clean baseline branch.  
- **Pull Request Simulation**: Opened a review branch (`review/comments`) to simulate a peer-reviewed workflow.  
- **Tooling**: Ran `terraform validate`, `terraform fmt`, and `tflint` to identify syntax issues and linting problems.

---

##### 🔍 Review Dimensions

| Area               | Focus                                                                 |
|--------------------|-----------------------------------------------------------------------|
| **Security**        | Exposure of secrets, IAM role strictness, open network access        |
| **Stability**       | Lifecycle rules, resource drift, destroy prevention                  |
| **Maintainability** | Reusable modules, variable naming, DRY principle                     |
| **Scalability**     | Multi-environment support, tagging, backend state config             |
| **Best Practices**  | Provider pinning, version control, formatting, and code documentation|

---

##### 🧩 Assumptions and Limitations

- Where context was missing (e.g. usage of certain variables), I flagged those and suggested alternatives.  
- I assumed a production environment where infrastructure is shared by multiple services and teams.  
- I prioritized **incremental improvements** that balance clarity, team readability, and risk reduction.

---

##### ✅ Summary

This section reflects how I conduct infrastructure reviews in real workflows — focusing on quality, maintainability, and team alignment. My detailed comments and suggestions are documented in `terraform_review.md` and follow the same bar I hold for production infrastructure in my day-to-day responsibilities.

---

### 2. 💻 Coding Challenge: Automated Health Check System

Directory: [`healthcheck/`](./healthcheck/)

A Python script that performs automated health checks against a web application's endpoint. It measures response time, checks status codes, and logs errors with mock alerting capability.

#### Features

- ⏱ Configurable check interval and response threshold  
- 🔁 Retry logic for transient network issues  
- 🧪 Logs response time, status code, and health indicator states  
- ⚠️ Alerts triggered via a mock Slack/email notification  
- 🐳 Containerized using Docker

---

## ⚙️ Configuration

All configurable values are stored in `.env`:

```env
HEALTHCHECK_URL=https://your-app.com/health
CHECK_INTERVAL=300
RESPONSE_THRESHOLD=3
RETRY_COUNT=2
ALERT_CHANNEL=console
