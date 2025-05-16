
# 🔍 Ultimate Nmap Scanner

A powerful and modular Bash script that automates comprehensive or quick Nmap scans against a target host. Designed for security professionals, penetration testers, and network admins who need an efficient, repeatable scanning toolkit.

---

## 🚀 Features

- Supports **quick** and **full** scan modes
- Runs a variety of common and advanced Nmap scans
- Outputs results to a timestamped log file
- Gracefully handles interruptions and missing dependencies
- Automatically warns before running intrusive scans
- Organized output with helpful headings

---

## 📦 Requirements

- `nmap` must be installed  
  You can install it on Debian-based systems with:

  ```bash
  sudo apt update && sudo apt install nmap


## 🛠️ Usage

```bash
./nmap.sh <target> [-q | -f]
```

### Arguments:

| Flag       | Description                              |
| ---------- | ---------------------------------------- |
| `<target>` | IP address or hostname to scan           |
| `-q`       | Quick scan (only essential/basic scans)  |
| `-f`       | Full scan (default if no flag is passed) |
| `-h`       | Show help message                        |

---

## 🧪 Examples

### Quick Scan:

```bash
./nmap.sh 192.168.1.1 -q
```

### Full Scan:

```bash
./nmap.sh 192.168.1.1 -f
```

---

## 📋 Scan Types Included
### ✅ Quick Mode:
Aggressive Scan (-A)

Top 1000 Ports (--top-ports)

OS Detection (-O)

Service Version Detection (-sV)

Default NSE Scripts (-sC)

### 🔎 Full Mode (includes all of the above, plus):
Full Port Scan (-p-)

UDP Scan (-sU)

Traceroute

NSE Vulnerability Scripts (--script vuln)

Authentication NSE Scripts (--script auth)

Stealth and Firewall Evasion Scans:

SYN Scan (-sS)

FIN, NULL, XMAS, ACK, Window, Maimon Scans (-sF, -sN, -sX, -sA, -sW, -sM)

TCP Connect Scan (-sT)

---

## 📂 Output

Results are saved to a file named like:

```bash
nmap_scan_results_<target>_<timestamp>.txt
```

This allows you to retain historical scan logs without overwriting previous ones.

---

## ⚠️ Disclaimer

* This script is for **authorized testing** only.
* Some scans are **intrusive** and may trigger alerts or affect production systems.
* Always ensure you have permission to scan the target.

---

Feel free to fork, modify, and improve!
