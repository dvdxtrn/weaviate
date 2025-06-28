# 🛠️ Post-Mortem: Shard Failures and Recovery Blocker During Load Test

## 📌 Incident Name:
prod_20250426_cloudai

## 🧑‍💼 Customer Name:
Cloud.ai

## 📍 Status:
Resolved

---

## 🗒️ Incident Summary:
Cloud.ai initiated load testing on their custom-tuned and provisioned environment on April 26, 2025. The complex workloads caused multiple shards to crash into an ERROR state and failovers to the replica shards occurred. This resulted in service instability ahead of the customer’s planned go-live.

Several database shards experienced failures on both the primary and replica shards. Auto-recovery processes entered a stuck `active-change-pending` state and could not recover using the AOF (Append Only File) and required manual intervention to restore the shard health and preload from the persistence files.

Investigation revealed that the `shard_mgr` configuration for `maxmemory` was incorrect, preventing initial recovery attempts.

Mitigation steps were promptly identified, thoroughly documented, and systematically applied to prevent further failures and restore service stability.

Ongoing remediation and preventive measures will be tracked and implemented through the related JIRA tickets.
---

## 💥 Customer Impact:
- Assessed as SEV2 / P2) Impact: Significant degradation, partial outage
- Continuous shard crashes disrupted load testing
- Stability risks ahead of production go-live
- Manual intervention required to restore service
- Temporary halting of load tests and writes to ensure data consistency

---

## 🔬 What Happened (Technical Detail):

### Failures:
- The following shards experienced crashes and failovers: `shard:43`, `shard:39`, `shard:22`, `shard:21`, `shard:40`.
- Shards were stuck in a `active-change-pending` state post-crash, unable to self-recover.

### AOF Restore Blocker:
- Attempts to restore from AOF files were blocked due to incorrect `maxmemory` settings by `shard_mgr`.
- The configuration prevented the shard from loading all necessary data into memory during recovery.

---

## 🧯 Workaround:

1. Identified affected node and stopped the `shard_mgr` process.
2. Preloaded the shard manually from backup (AOF).
3. Released the shard from the `active-change-pending` state.
4. Restarted the shard manually.
5. Validated that the shard was restored and functioning.

---

## 🧩 Root Cause:

Initial analysis points to **memory corruption or misconfiguration**. The root cause is under continued investigation, but improper `maxmemory` settings applied by `shard_mgr` during recovery are a contributing factor.

---

## 🕒 Timeline (UTC):

- **2025-04-26 03:29** – Shard crashes and failovers detected by monitoring system; SRE receives alert and begins triage and assessment 
- **2025-04-26 04:14** – SRE notified of ongoing Customer load test in internal POC channel for Cloud.ai 
- **2025-04-26 04:30** – Customer advised to halt load test due to instability as suggested to the Account teams
- **2025-04-26 05:00–06:00** – Customer paused test and backed up sync service  
- **2025-04-26 05:44** – Incident is declared; Slack channel and Zoom Bridge is opened; investigation initiated with R&D teams 
- **2025-04-26 05:50–08:40** – Technical team and Customer join Zoom Bridge to assess shard failures and `shard_mgr` configuration  
- **2025-04-26 07:00** – Customer restarted load test after interim stability observed  
- **2025-04-26 08:12** – Zoom Bridge ended; issue escalated via JIRA and Incident Slack channel  
- **2025-04-26 14:45** – Another shard failure occurs; workaround successfully applied  
- **2025-04-26 15:45** – Reconvened on Zoom Bridge with R&D team and attempted to fix module parameter errors from `shard_mgr`  
- **2025-04-26 19:25** – Deleted both conflicting parameters via `config-cli`; `shard_mgr` errors ceased  
- **2025-04-26 19:27** – R&D team requested database restart to purge potential memory corruption  
- **2025-04-26 20:01** – Database restarted  
- **2025-04-26 22:00** – Bridge closed; Customer informed that R&D will continue investigation

---

## 🔗 Related JIRA Tickets:

- JIRA-123890  
- VECTOR-456

---

## 📝 Next Steps / Action Items:

### ✅ Immediate
- [x] Continue root cause analysis of memory configuration conflict
- [x] Audit `shard_mgr` config templates used for shard restores
- [x] Document manual recovery steps and shard preload playbook

### 🔍 Near Term
- [ ] Validate `maxmemory` auto-tuning behavior across all environments
- [ ] Strengthen shard failover alerting and active-change-pending detection
- [ ] Add automated fallback on restore blockers

### 📚 Long Term
- [ ] Improve fault injection testing under load test conditions
- [ ] Evaluate safer defaults in `shard_mgr` for recovery operations
- [ ] Propose update to customer test planning playbooks to catch pre-prod issues

---

## 📣 Communication Summary:
Incident updates were shared regularly via Slack, Zoom, and internal JIRA threads. The issue did not result in a public incident report, but customer visibility was high due to direct involvement during the load test window.

---

*Report authored by: [David Tran – Cloud Operations/SRE Team leader]*  
*Date: June 26, 2025*
