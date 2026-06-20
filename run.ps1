# ---------------------------------------------------------
#  Burp Suite Professional - Windows Installer & Launcher
# ---------------------------------------------------------

$ErrorActionPreference = "Stop"

Clear-Host
Write-Host " +----------------------------------------------+ " -ForegroundColor Cyan
Write-Host " |  ____                  ____        _ _       | " -ForegroundColor Cyan
Write-Host " | | __ ) _   _ _ __ _ __/ ___| _   _(_) |_ ___ | " -ForegroundColor Cyan
Write-Host " | |  _ \| | | | '__| '_ \___ \| | | | | __/ _ \ | " -ForegroundColor Cyan
Write-Host " | | |_) | |_| | |  | |_) |__) | |_| | | ||  __/ | " -ForegroundColor Cyan
Write-Host " | |____/ \__,_|_|  | .__/____/ \__,_|_|\__\___| | " -ForegroundColor Cyan
Write-Host " |                  |_|                         | " -ForegroundColor Cyan
Write-Host " |            P R O F E S S I O N A L           | " -ForegroundColor Cyan
Write-Host " +----------------------------------------------+ " -ForegroundColor Cyan
Write-Host " |               Windows Installer              | " -ForegroundColor Cyan
Write-Host " +----------------------------------------------+ " -ForegroundColor Cyan
Write-Host ""

# Check Java Installation
if (!(Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Host "[-] Java is not installed." -ForegroundColor Red
    Write-Host "    Please download Java 21 or higher from: https://adoptium.net" -ForegroundColor Yellow
    exit 1
}

$oldPreference = $ErrorActionPreference
$ErrorActionPreference = "SilentlyContinue"
$javaVersionStr = & java -version 2>&1 | Out-String
$ErrorActionPreference = $oldPreference

if ($javaVersionStr -match 'version "(\d+)') {
    $javaMajor = [int]$Matches[1]
} else {
    $javaMajor = 0
}

Write-Host "[*] Found Java version: $javaMajor" -ForegroundColor Green

if ($javaMajor -lt 21) {
    Write-Host "[!] Warning: Java 21 or higher is recommended (detected Java $javaMajor)." -ForegroundColor Yellow
    Write-Host "    Burp Suite 2025.x requires Java 21. Older versions (like 2022.x/2023.x) can run on Java 11/17." -ForegroundColor Yellow
    $confirm = Read-Host "    Continue anyway? [y/N]"
    if ($confirm -notmatch '^[Yy]$') {
        exit 1
    }
}

Write-Host "[*] Fetching latest Burp Suite versions..." -ForegroundColor Gray

$versions = @()
try {
    # PortSwigger requires a User-Agent to avoid blocking
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
    $html = $webClient.DownloadString("https://portswigger.net/burp/releases")
    
    # Only match Professional / Community versions (not DAST, CI/CD Driver, etc.)
    $matches = [regex]::matches($html, 'professional-community-(\d{4}(?:-\d+)+)')
    $uniqueVersions = @()
    foreach ($m in $matches) {
        # Convert hyphens to dots: 2026-4-3 -> 2026.4.3
        $vStr = $m.Groups[1].Value -replace '-', '.'
        if ($uniqueVersions -notcontains $vStr) {
            $uniqueVersions += $vStr
        }
    }
    
    # Sort by version (pad missing patch number for comparison)
    $sortedVersions = $uniqueVersions | Sort-Object {
        $parts = $_ -split '\.'
        [int]$parts[0] * 10000 + [int]$parts[1] * 100 + $(if ($parts.Length -ge 3) { [int]$parts[2] } else { 0 })
    } -Descending | Select-Object -First 5
    $versions = @($sortedVersions)
    Write-Host "[+] Fetched $($versions.Count) Professional/Community versions from portswigger.net" -ForegroundColor Green
} catch {
    Write-Host "[!] Could not fetch versions online - using fallback list." -ForegroundColor Yellow
    $versions = @("2026.4.3", "2026.4.2", "2026.4.1", "2026.4", "2026.3.3")
}

Write-Host ""
Write-Host "Available Burp Suite Pro Versions:" -ForegroundColor White
for ($i = 0; $i -lt $versions.Count; $i++) {
    $label = $versions[$i]
    if ($i -eq 0) { $label += "  (latest)" }
    Write-Host "  $($i + 1)) $label" -ForegroundColor White
}
Write-Host "  $($versions.Count + 1)) Custom version (download automatically)" -ForegroundColor White
Write-Host "  $($versions.Count + 2)) Use local JAR file (enter path manually)" -ForegroundColor White
Write-Host ""

$choiceStr = Read-Host "Select option [1-$($versions.Count + 2)]"
$choice = 0
[int]::TryParse($choiceStr, [ref]$choice) | Out-Null

$localJarMode = $false
$version = "Custom"

if ($choice -ge 1 -and $choice -le $versions.Count) {
    $version = $versions[$choice - 1]
} elseif ($choice -eq ($versions.Count + 1)) {
    $version = Read-Host "Enter the version to download (e.g., 2023.12.1)"
} elseif ($choice -eq ($versions.Count + 2)) {
    $localJarMode = $true
    $localJarPath = Read-Host "Enter the full path to your Burp Suite JAR file"
} else {
    Write-Host "[-] Invalid option. Exiting." -ForegroundColor Red
    exit 1
}

if (-not $localJarMode) {
    Write-Host "[+] Selected Burp Suite version: $version" -ForegroundColor Green
}

$jarFile = "Burp_Suite_Pro_$version.jar"

if ($localJarMode) {
    if (Test-Path $localJarPath) {
        Write-Host "[+] Using local JAR file: $localJarPath" -ForegroundColor Green
        Copy-Item -Path $localJarPath -Destination "Burp_Suite_Pro.jar" -Force
    } else {
        Write-Host "[-] File not found: $localJarPath" -ForegroundColor Red
        exit 1
    }
} else {
    $needDownload = $true
    if (Test-Path $jarFile) {
        Write-Host ""
        $fileSize = (Get-Item $jarFile).Length / 1MB
        Write-Host "[*] Found existing JAR: $jarFile ($("{0:N2}" -f $fileSize) MB)" -ForegroundColor Yellow
        $redownload = Read-Host "   Re-download? [y/N]"
        if ($redownload -match '^[Yy]$') {
            $needDownload = $true
        } else {
            $needDownload = $false
            Write-Host "[*] Skipping download - using existing JAR." -ForegroundColor Gray
        }
    }

    if ($needDownload) {
        $link = "https://portswigger.net/burp/releases/startdownload?product=desktop&version=$version&type=Jar"
        Write-Host "[*] Downloading Burp Suite Professional v$version ..." -ForegroundColor White
        
        try {
            # Stream-based download with progress
            Add-Type -AssemblyName System.Net.Http
            $handler = New-Object System.Net.Http.HttpClientHandler
            $handler.AllowAutoRedirect = $true
            $httpClient = New-Object System.Net.Http.HttpClient($handler)
            $httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
            $httpClient.Timeout = [TimeSpan]::FromMinutes(30)

            $response = $httpClient.GetAsync($link, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
            $response.EnsureSuccessStatusCode() | Out-Null

            $totalBytes = $response.Content.Headers.ContentLength
            $stream = $response.Content.ReadAsStreamAsync().Result
            $fullPath = Join-Path (Get-Location) $jarFile
            $fileStream = [System.IO.File]::Create($fullPath)

            $buffer = New-Object byte[] 65536
            $totalRead = 0
            $startTime = Get-Date

            while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                $fileStream.Write($buffer, 0, $bytesRead)
                $totalRead += $bytesRead

                $receivedMB = [math]::Round($totalRead / 1MB, 2)
                $elapsed = ((Get-Date) - $startTime).TotalSeconds
                $speedMB = if ($elapsed -gt 0) { [math]::Round($totalRead / 1MB / $elapsed, 2) } else { 0 }

                if ($null -ne $totalBytes -and $totalBytes -gt 0) {
                    $pct = [math]::Floor($totalRead / $totalBytes * 100)
                    $totalMB = [math]::Round($totalBytes / 1MB, 2)
                    Write-Progress -Activity "Downloading Burp Suite v$version" `
                        -Status ("{0:N2} / {1:N2} MB  ({2:N2} MB/s)" -f $receivedMB, $totalMB, $speedMB) `
                        -PercentComplete $pct
                } else {
                    Write-Progress -Activity "Downloading Burp Suite v$version" `
                        -Status ("{0:N2} MB downloaded  ({1:N2} MB/s)" -f $receivedMB, $speedMB)
                }
            }

            $fileStream.Close()
            $stream.Close()
            $httpClient.Dispose()
            Write-Progress -Activity "Downloading Burp Suite v$version" -Completed

            # Simple check if file is indeed a zip/jar (starts with PK)
            $bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $jarFile))
            if ($bytes.Length -lt 2 -or $bytes[0] -ne 0x50 -or $bytes[1] -ne 0x4B) {
                Write-Host "[-] Download failed - version $version does not exist!" -ForegroundColor Red
                Write-Host "    PortSwigger returned an HTML page or invalid data instead of a JAR." -ForegroundColor Yellow
                Remove-Item -Path $jarFile -ErrorAction SilentlyContinue
                exit 1
            }
            
            $fileSize = (Get-Item $jarFile).Length / 1MB
            Write-Host "[+] Downloaded successfully ($("{0:N2}" -f $fileSize) MB)" -ForegroundColor Green
        } catch {
            Write-Host "[-] Download failed: $_" -ForegroundColor Red
            exit 1
        }
    }
    
    Copy-Item -Path $jarFile -Destination "Burp_Suite_Pro.jar" -Force
}

Start-Sleep -Seconds 1

Write-Host "[*] Starting Keygenerator..." -ForegroundColor Cyan
Start-Process java -ArgumentList "-jar keygen.jar"

Write-Host "[*] Generating Dynamic Silent Runner..." -ForegroundColor Cyan
$workDir = (Get-Location).Path
$javaw = "javaw.exe"

$javaArgs = @(
    '--add-opens=java.desktop/javax.swing=ALL-UNNAMED',
    '--add-opens=java.base/java.lang=ALL-UNNAMED',
    '--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED',
    '--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED',
    '-Dfile.encoding=utf-8',
    "-javaagent:`"loader.jar`"",
    '-noverify',
    "-jar `"Burp_Suite_Pro.jar`""
)
$vbsCmdLine = "`"$javaw`" " + ($javaArgs -join ' ')

$runnerPath = Join-Path $workDir 'burp.vbs'
$runnerContent = @"
Option Explicit
Dim WshShell, fso, baseDir, cmd
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
baseDir = fso.GetParentFolderName(WScript.ScriptFullName)
WshShell.CurrentDirectory = baseDir
cmd = "$($vbsCmdLine.Replace('"', '""'))"
WshShell.Run cmd, 0, False
Set WshShell = Nothing
"@
Set-Content -Path $runnerPath -Value $runnerContent -Encoding ASCII

# Create Desktop Shortcut
Write-Host "[*] Creating Desktop Shortcut..." -ForegroundColor Cyan
$desktop = [Environment]::GetFolderPath("Desktop")
$scPath = Join-Path $desktop "Burp Suite Professional.lnk"
$wShell = New-Object -ComObject WScript.Shell
$shortcut = $wShell.CreateShortcut($scPath)
$shortcut.TargetPath = "$env:WINDIR\System32\WScript.exe"
$shortcut.Arguments = "`"$runnerPath`""
$shortcut.WorkingDirectory = "$workDir"
$icoPath = Join-Path $workDir 'burp.ico'
if (Test-Path $icoPath) { $shortcut.IconLocation = $icoPath } else { $shortcut.IconLocation = "javaw.exe,0" }
$shortcut.Save()

# Try to run it
Start-Process $runnerPath

Write-Host ""
Write-Host "[+] Burp Suite Pro v$version launched successfully!" -ForegroundColor Green
Write-Host "[*] You can use the 'Burp Suite Professional' shortcut on your Desktop." -ForegroundColor White
Write-Host ""
