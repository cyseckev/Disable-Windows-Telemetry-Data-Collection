# 🔄 Rollback / Restore Instructions

This document describes how to safely revert changes applied by the telemetry hardening scripts.

---

## Important notes
- Some removals (uninstalled apps/features) require reinstallation; these steps focus on restoring registry keys, services and scheduled tasks.
- Always check the backup folder produced by `disable-telemetry.ps1` before attempting restore.

---

## 1) Locate backup folder
Backups are saved under:
```
C:\ProgramData\DisableTelemetry_Backups\<YYYYMMDD-HHMMSS>\
```
This folder contains `.reg` exports and `change_log.txt`.

---

## 2) Restore registry exports
```powershell
reg import "C:\ProgramData\DisableTelemetry_Backups\<timestamp>\*.reg"
```

---

## 3) Re-enable services
```powershell
Set-Service -Name DiagTrack -StartupType Automatic
Start-Service -Name DiagTrack
Set-Service -Name dmwappushservice -StartupType Automatic
Start-Service -Name dmwappushservice
```

---

## 4) Re-enable scheduled tasks
```powershell
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Enable
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Enable
```

---

## 5) Reinstall removed features/apps
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -All -NoRestart
Get-AppxPackage -AllUsers Microsoft.XboxApp | ForEach-Object {
  Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"
}
```

---

## 6) Verify
```powershell
powershell -ExecutionPolicy Bypass -File .\audit-telemetry.ps1 > telemetry-audit-restored.json
```
