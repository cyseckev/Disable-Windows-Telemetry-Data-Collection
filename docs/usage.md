# 📖 Usage Guide

This guide explains how to use the scripts included in **Disable-Windows-Telemetry-Data-Collection**.
**Always run with Administrator privileges. Test in a VM before applying to production.**

---

## Prerequisites
- Windows 10 / 11 (tested)
- Administrative rights (Run PowerShell as Administrator)
- PowerShell execution policy that permits script execution (or run with `-ExecutionPolicy Bypass`)
- Optional: create a system restore point before running

---

## Quick start (recommended)
1. Clone repository or copy files to target host:
   ```powershell
   git clone https://github.com/<your-username>/Disable-Windows-Telemetry-Data-Collection.git
   cd Disable-Windows-Telemetry-Data-Collection\scripts
   ```

2. Run a **read-only audit** first:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\audit-telemetry.ps1 > telemetry-audit.json
   ```

3. Apply hardening (creates backups automatically):
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\disable-telemetry.ps1
   ```

4. Re-run the audit to verify changes:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\audit-telemetry.ps1 > telemetry-audit-after.json
   ```

---

## Optional: remove additional components
To remove optional telemetry-related apps/features (use with caution):
```powershell
powershell -ExecutionPolicy Bypass -File .\uninstall-telemetry.ps1
```

---

## Backup location
The main script exports registry backups and writes a change log to:
```
C:\ProgramData\DisableTelemetry_Backups\<timestamp>\
```

---

## Recommended order of operations
1. `audit-telemetry.ps1` (audit, non-destructive)
2. `disable-telemetry.ps1` (apply hardening)
3. `uninstall-telemetry.ps1` (optional, removes apps/features)
4. `audit-telemetry.ps1` again to confirm
