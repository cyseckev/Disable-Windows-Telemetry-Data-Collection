# ✅ Telemetry Hardening Checklist

This checklist enumerates the modifications performed by `disable-telemetry.ps1`.

---

## Registry keys
- AllowTelemetry = 0
- TailoredExperiencesWithDiagnosticDataEnabled = 0
- DisabledByGroupPolicy = 1
- AllowCortana = 0
- DisableWebSearch = 1
- PublishUserActivities = 0
- DisableWindowsConsumerFeatures = 1
- Disabled = 1 (Windows Error Reporting)
- DODownloadMode = 0
- EnableMulticast = 0
- EnableActiveProbing = 0

---

## Services disabled
- DiagTrack
- dmwappushservice
- WerSvc
- DoSvc
- RemoteRegistry
- Xbox services (if present)

---

## Scheduled tasks disabled
- Microsoft Compatibility Appraiser
- ProgramDataUpdater
- AitAgent
- CEIP Consolidator
- USB CEIP
- DiskDiagnosticDataCollector
- DmClient
- DmClientOnScenarioDownload

---

## Optional removals
- Retail demo content
- Built-in apps: Xbox, GetHelp, GetStarted, Skype, etc.
- Windows Media Player

---

## Network hardening
- LLMNR disabled
- NetBIOS over TCP/IP disabled
- NCSI Active Probing disabled
