<div align="center">

<!-- Title Block -->
<img src="https://img.shields.io/badge/%E2%9A%A1-BURP%20SUITE%20PRO-FF6633?style=for-the-badge&labelColor=1a1a2e" height="40"/>

# Burp Suite Professional — Multi-Platform Installer

**One-command installer & launcher for Burp Suite Professional on macOS and Linux**
<br/>
*Supports Apple Silicon (M1/M2/M3/M4), Intel Macs, and Linux (Kali, Ubuntu, Debian)*

<br/>

[![macOS](https://img.shields.io/badge/macOS-Sonoma%20|%20Ventura%20|%20Monterey-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Linux](https://img.shields.io/badge/Linux-Kali%20|%20Ubuntu%20|%20Debian-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.kali.org/)
[![Java](https://img.shields.io/badge/Java-21+-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://adoptium.net/)
[![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-Educational-blue?style=for-the-badge)](LICENSE)

<br/>

<img src="https://img.shields.io/github/stars/fenicnn/Burp-Suite-Professional?style=social" />
&nbsp;
<img src="https://img.shields.io/github/forks/fenicnn/Burp-Suite-Professional?style=social" />
&nbsp;
<img src="https://img.shields.io/github/watchers/fenicnn/Burp-Suite-Professional?style=social" />

</div>

<br/>

---

<br/>

## ✨ Highlights

<table>
<tr>
<td width="50%">

### 🚀 Zero-Config Setup
Single command to download, configure, and launch.
No manual JAR wrangling or classpath headaches.

</td>
<td width="50%">

### 💻 Cross-Platform Support
Native support for **macOS** (Apple Silicon & Intel) and **Linux** (Kali, Ubuntu, Debian).

</td>
</tr>
<tr>
<td width="50%">

### ☕ Modern Java Compatibility
Uses `--add-opens` JVM flags instead of the deprecated
`--illegal-access=permit` — works with **JDK 17, 21, 22+**.

</td>
<td width="50%">

### 🔄 Multi-Version Manager
Choose from pre-listed versions or enter any custom version.
Switch versions anytime by re-running the installer.

</td>
</tr>
</table>

<br/>

> [!WARNING]
> **Auto-Downloader Currently Broken**
> PortSwigger has changed their direct download links, so the automatic download step is currently failing.
>
> **Workaround:**
> 1. Download the Burp Suite Professional **JAR** file manually from [portswigger.net/burp/releases](https://portswigger.net/burp/releases).
> 2. Run the installer script and select **Option 7**.
> 3. Provide the path to the downloaded JAR file when prompted.

<br/>

---

<br/>

## 📋 Prerequisites

| Requirement | Minimum | Recommended |
|---|---|---|
| **macOS** | Monterey 12.0 | Sonoma 15+ |
| **Linux** | Any modern distro | Kali 2024+ / Ubuntu 22.04+ |
| **Java JDK** | **21** | 21+ (Temurin / Oracle / OpenJDK) |
| **Disk Space** | ~500 MB | 1 GB |
| **Architecture** | Intel x86_64 / Apple Silicon arm64 | Apple Silicon arm64 / Linux aarch64 |

<br/>

---

<br/>

## 🛠️ Installation

### 📱 Option 1 — macOS

#### Step 1 — Install Java

<details>
<summary><b>Option A: Homebrew (Recommended)</b></summary>

```bash
# Eclipse Temurin JDK 21+ (open-source, well-maintained)
brew install --cask temurin

# Verify
java -version
```

</details>

<details>
<summary><b>Option B: Oracle JDK</b></summary>

1. Download **JDK 21** for macOS from [Oracle](https://www.oracle.com/java/technologies/javase/jdk21-archive-downloads.html)
2. Open the `.dmg` → double-click `JDK 21.pkg`
3. Verify:

```bash
java -version
```

</details>

#### Step 2 — Clone & Run

```bash
git clone https://github.com/fenicnn/Burp-Suite-Professional.git
cd Burp-Suite-Professional
chmod +x run.sh
sudo ./run.sh
```

---

### 🐧 Option 2 — Linux (Kali / Ubuntu / Debian)

#### Step 1 — Download Burp Suite JAR

Download the latest Burp Suite Professional JAR file from:
👉 [https://portswigger.net/burp/releases](https://portswigger.net/burp/releases)

#### Step 2 — Install Java 21

```bash
sudo apt update && sudo apt install openjdk-21-jdk -y

# Verify
java -version
```

#### Step 3 — Clone & Run

```bash
git clone https://github.com/fenicnn/Burp-Suite-Professional.git
cd Burp-Suite-Professional
chmod +x run_linux.sh
sudo ./run_linux.sh
```

#### Step 4 — Select Option 7

When prompted, select **Option 7** to use the local JAR file you downloaded.

#### Step 5 — License Activation

1. From the keygen panel, copy the **License** key to Burp Suite's registration page
2. Select **Manual register** option
3. Copy the **Request** field from Burp Suite
4. Paste the Request into the keygen to get the **Response**
5. Copy the Response back to Burp Suite and complete registration

#### Step 6 — Configure Browser Proxy

Set your browser proxy to: `127.0.0.1:8080`

---

### 🚀 Launch Anytime

```bash
burp
```

> The launcher is installed to:
> - **macOS Apple Silicon**: `/opt/homebrew/bin/burp`
> - **macOS Intel**: `/usr/local/bin/burp`
> - **Linux**: `/usr/local/bin/burp`

<br/>

---

<br/>

## 📂 Project Structure

```
Burp-Suite-Professional/
│
├── run.sh                      # macOS installer & setup script
├── run_linux.sh                # Linux installer & setup script
├── run.ps1                     # Windows installer & setup script
├── loader.jar                  # Java agent loader
├── keygen.jar                  # License key generator
├── README.md                   # This file
├── _config.yml                 # GitHub Pages config
│
├── assets/
│   └── css/                    # Styling assets
│
└── (generated at runtime)
    ├── Burp_Suite_Pro_*.jar    # Downloaded Burp Suite JAR
    ├── Burp_Suite_Pro.jar      # Symlink → latest version
    └── burp                    # Launcher script
```

<br/>

---

<br/>

## 🔄 Updating / Switching Versions

Simply re-run the installer and pick a different version:

**macOS:**
```bash
sudo ./run.sh
```

**Linux:**
```bash
sudo ./run_linux.sh
```

The script automatically:
- Downloads the new version
- Updates the symlink to point to the latest JAR
- Rebuilds the launcher

> **Tip:** Previous JAR files are kept so you can manually switch back if needed.

<br/>

---

<br/>

## 🐛 Troubleshooting

<details>
<summary><b>❌ "Java is not installed"</b></summary>

**macOS:**
```bash
brew install --cask temurin
```

**Linux:**
```bash
sudo apt update && sudo apt install openjdk-21-jdk -y
```

Or download from [adoptium.net](https://adoptium.net/).

</details>

<details>
<summary><b>❌ UnsupportedClassVersionError (class file version 65.0)</b></summary>

This means Burp Suite was compiled for **Java 21** but you're running an older version.

**macOS:**
```bash
brew install --cask temurin
```

**Linux:**
```bash
sudo apt update && sudo apt install openjdk-21-jdk -y
```

After upgrading, verify:
```bash
java -version
# Should show: openjdk version "21.x.x" or higher
```

</details>

<details>
<summary><b>❌ "Permission denied"</b></summary>

Make sure the script is executable and you're running with `sudo`:

**macOS:**
```bash
chmod +x run.sh
sudo ./run.sh
```

**Linux:**
```bash
chmod +x run_linux.sh
sudo ./run_linux.sh
```

</details>

<details>
<summary><b>❌ Burp fails to start on Apple Silicon</b></summary>

Ensure you're running an **arm64-native** JDK, not an x86 one under Rosetta:

```bash
file $(which java)
# Should show: Mach-O 64-bit executable arm64
```

If not, reinstall with Homebrew:

```bash
brew install --cask temurin
```

</details>

<details>
<summary><b>❌ Burp fails to start on Linux (GUI error)</b></summary>

Burp Suite requires a graphical environment. If you're connected via SSH:

```bash
# Enable X11 forwarding in your SSH connection
ssh -X user@linux-ip

# Or set the DISPLAY environment variable
export DISPLAY=:0.0
```

</details>

<details>
<summary><b>❌ "burp: command not found"</b></summary>

The launcher wasn't added to your PATH. Run:

```bash
# Add the installation directory to your PATH
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

</details>

<br/>

---

<br/>

## ⚙️ How It Works

```
sudo ./run.sh (macOS)
sudo ./run_linux.sh (Linux)
       │
       ▼
┌──────────────┐     ┌─────────────────┐     ┌──────────────┐
│  Java Check  │────▶│  Download JAR    │────▶│  Keygen      │
│  + Arch Detect│     │  (curl from CDN) │     │  (background)│
└──────────────┘     └─────────────────┘     └──────┬───────┘
                                                     │
                                                     ▼
                     ┌─────────────────┐     ┌──────────────┐
                     │  Install to     │◀────│  Create      │
                     │  /opt/homebrew  │     │  Launcher    │
                     │  or /usr/local  │     │  Script      │
                     └─────────────────┘     └──────────────┘
```

<br/>

---

<br/>

## ⚠️ Disclaimer

> **This project is provided for educational and authorized security testing purposes only.**
>
> By using this software, you agree to comply with all applicable laws and
> [PortSwigger's licensing terms](https://portswigger.net/burp/pro).
> The authors assume no liability for misuse.

<br/>

---

<br/>

<div align="center">

## 👨‍💻 Author

**fenicnn** — [@fenicnn](https://github.com/fenicnn)

<br/>

[![GitHub](https://img.shields.io/badge/GitHub-fenicnn-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/fenicnn)

<br/>

---

<br/>

**If this project helped you, consider giving it a ⭐**

<br/>

<img src="https://img.shields.io/github/stars/fenicnn/Burp-Suite-Professional" />

</div>