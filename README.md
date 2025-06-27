# Weaviate SRE Technical Challenge

## 👋 Introduction

This repository contains my completed submission for the **Client-Focused SRE - Technical Challenge** provided by Weaviate. I approached this challenge with production-level quality and real-world SRE principles in mind — focusing on observability, automation, and clarity.

The technical challenge spans three areas — Terraform review, a coding automation task, and a post-mortem report.

Each represent an area of my experience ranging from familiarity to proficiency and ultimately expertise. 

For this reason, I would like to add that I really enjoyed working on this challenge and appreciate the thought and care that went into its design.

- **Terraform and Python scripting** are not tools I use daily. I approached those parts of the challenge as a chance to **display my existing aptitude and demonstrate my ability to learn quickly and adapt**. My goal wasn’t to be perfect, but to reflect how I would ramp up in a real environment — with production-quality practices, clean structure, and practical implementation.

- **Post-mortems and incident analysis** are squarely within my domain of expertise. One of my primary responsibilities was Incident Management. As a technical leader, if the issue could be identifed and resolved without needing to involve the SME, I would have effectively saved valuable resources that could be spent on other high priority tasks for both operations and development teams. When this was not possible, the decision to declare an incident was swift and I assumed the Incident Commander role end to end.

This mindset is how I operate as an SRE and a leader: I lean into unfamiliar areas, ask the right questions, and aim for scalable, supportable solutions even when I’m not the domain expert. I applied those same principles here — treating each deliverable with care, structure, and the intent to grow.

---

## ✅ Challenge Overview

### 1. 🔍 Terraform Code Review

File: [`README.md`](./1_terraform_review/README.md)

I reviewed the provided Terraform code with a focus on:

- Infrastructure stability and correctness  
- Provider pinning and module design  
- Resource lifecycle considerations  
- Security, DRY principles, and tagging  

---

#### 🧠 Thoughts

I approached the Terraform review exactly as if a new and unfamiliar task was assigned to me to complete as an Principal/Senior Cloud Operations Engineer. This area of expertise was not in my daily usage, so I relied on AI to build on the fundamentals that I understand and sharpen it in the interest of time. If time pressure was not a factor, I would approach with trial and error method in a testing environment to successfully provision the environment and then begin to refactor, improve, and find the best practices for reliability.

---

### 2. 💻 Coding Challenge: Automated Health Check System

File: [`README.md`](./2_health_check_coding/README.md)

A Python script that performs automated health checks against a web application's endpoint. It measures response time, checks status codes, and logs errors with mock alerting capability. See the implementation and details in [`2_health_check_coding/`](./2_health_check_coding/).

#### Features

- ⏱ Configurable check interval and response threshold  
- 🔁 Retry logic for transient network issues  
- 🧪 Logs response time, status code, and health indicator states  
- ⚠️ Alerts triggered via a mock Slack/email notification  
- 🐳 Containerized using Docker

#### 🧠 Thoughts

Observability was a key focus of mine as the SME of Zabbix (open source). Zabbix was used to monitor all of production VMs on the system level while Prometheus/Grafana was used for the database and service level. 

As I deeply understood the limitations of Zabbix, Chronosphere and Observe.inc proof of concepts completed ZIP approval processes and were set to begin prior to my departure from Redis.

I am proficient with Python and other languages as part of automating tasks and reports. With my observability already on my mind and the need to convert existing scripts in Zabbix to work with Cloud Native platforms, this gave me an opportunity to find closure to my unfinished work.

---

### 3. 📝 Root Cause Analysis & Post-Mortem

File: [`README.md`](./3_post_mortem/README.md)

This section contains a detailed root cause analysis and post-mortem report for the provided incident scenario. I break down the timeline, contributing factors, detection, mitigation steps, and actionable recommendations for future prevention.

#### 🧠 Role & Leadership Context

During production incidents, **myself and my team were responsible for wearing many hats** — including serving as the incident commander, the technical resource, and the communications lead (both internal and external), while also coordinating escalation paths and paging.

To reduce the cognitive and operational overhead on the team, I **spearheaded a proof of concept to evaluate FireHydrant** as a way to incorporate **AI-driven workflows and automation** into our incident process. The goal was to streamline coordination and communication, allowing engineers to stay focused on **technical mitigation and facilitating resolution**. This initiative improved efficiency and set the foundation for more sustainable incident management practices in the long term.

It's successful deployment required **cross-functional buy-in from many Support and Development teams** to fully adopt. I led efforts to ensure their **on-call rotations and schedules were integrated into the system**, eliminating the need for outdated processes like **Excel-based paging and manual escalations**. As a result, teams could rely on a centralized, reliable, and automated escalation workflow during incidents.

The tool was successfully launched following a comprehensive rollout, which included presentations to introduce the tool to the relevant teams along with full training, documentation, and user enablement.