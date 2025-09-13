<div align="center">

# 🛡️ Disable-Windows-Telemetry-Data-Collection  
**Hardening Windows by disabling telemetry, data collection, and unnecessary services**

</div>

---

## 📖 Overview
This repository provides a set of **PowerShell scripts** to harden Windows installations by:
- Disabling telemetry and diagnostic data collection  
- Stopping unnecessary background services  
- Disabling scheduled tasks that collect or send user data  
- Preventing network leaks (LLMNR, NetBIOS, NCSI Active Probing)  
- Reducing attack surface (e.g., SMBv1 removal, Xbox services, Remote Registry)  

The goal is to **maximize privacy, security, and OPSEC** while keeping the system stable.

---

## 📂 Repository Structure
Disable-Windows-Telemetry-Data-Collection/
│── README.md
│── LICENSE
│── .gitignore
│── CONTRIBUTING.md
│── CHANGELOG.md
│
├── scripts/
│ ├── disable-telemetry.ps1
│ ├── uninstall-telemetry.ps1
│ └── audit-telemetry.ps1
│
├── docs/
│ ├── usage.md
│ ├── rollback.md
│ └── checklist.md
│
└── metadata/
└── repo_description.txt

yaml
Code kopieren

---

## 🚀 Quick Start
```powershell
# Clone the repo
git clone https://github.com/<your-username>/Disable-Windows-Telemetry-Data-Collection.git
cd Disable-Windows-Telemetry-Data-Collection/scripts

# Run the main hardening script (requires admin rights)
powershell -ExecutionPolicy Bypass -File .\disable-telemetry.ps1
⚙️ Scripts
disable-telemetry.ps1 – Apply recommended privacy and telemetry restrictions

uninstall-telemetry.ps1 – Remove additional Microsoft telemetry components (optional)

audit-telemetry.ps1 – Verify system state and log telemetry-related settings

📝 Documentation
Usage Guide – Step-by-step execution

Rollback Instructions – How to revert changes safely

Checklist – What exactly is disabled

⚠️ Disclaimer
This project is provided for educational and security research purposes only.
Use at your own risk – certain features like Windows Error Reporting and Cortana will be disabled permanently.
Always test in a virtual machine or lab environment before applying on production systems.

<div align="center">
🔒 Hardening Windows – One script at a time.

</div>