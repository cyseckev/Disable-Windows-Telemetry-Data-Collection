# 🤝 Contributing Guidelines

Thank you for considering contributing to **Disable-Windows-Telemetry-Data-Collection**!  
We welcome pull requests, issue reports, and feature suggestions.

---

## 📌 How to Contribute
1. **Fork** the repository  
2. **Create a new branch** (`git checkout -b feature/new-feature`)  
3. **Commit your changes** (`git commit -m "Added new feature"`)  
4. **Push** to your branch (`git push origin feature/new-feature`)  
5. **Open a Pull Request**

---

## ✅ Rules
- Follow PowerShell best practices  
- Keep scripts **idempotent** (safe to run multiple times)  
- Use comments to explain registry keys and services being modified  
- Test changes on a **virtual machine** before submitting  

---

## 📖 Code Style
- Use `PascalCase` for functions  
- Use `camelCase` for variables  
- Always include inline comments for registry and service edits  

---

## 🛡️ Security Note
This repository is about **privacy and OPSEC**.  
Please do not submit code that introduces tracking, telemetry, or external dependencies.
