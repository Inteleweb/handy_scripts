
# 1. Checking system specifications
$cpuCores = (Get-WmiObject -Class Win32_Processor).NumberOfLogicalProcessors
$memoryGB = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$diskSpaceGB = [math]::Round((Get-PSDrive -Name "C").Free / 1GB)

# 2. Defining minimum requirements for Flutter
$minCpuCores = 4
$minMemoryGB = 8
$minDiskSpaceGB = 2.5

# 3. Comparing system specs with minimum requirements
if ($cpuCores -ge $minCpuCores -and $memoryGB -ge $minMemoryGB -and $diskSpaceGB -ge $minDiskSpaceGB) {
    Write-Output "System meets the minimum requirements for Flutter."
} else {
    Write-Output "System does not meet the minimum requirements for Flutter."
}

# Software checks and installation
$windowsVersion = [Environment]::OSVersion.Version
$gitVersion = git --version
$chromeInstalled = Test-Path "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$vsCodeInstalled = Test-Path "C:\Users\$Env:UserName\AppData\Local\Programs\Microsoft VS Code\Code.exe"

# Install missing software using winget
if (!$gitVersion) { winget install -e --id Git.Git }
if (!$chromeInstalled) { winget install -e --id Google.Chrome }
if (!$vsCodeInstalled) { winget install -e --id Microsoft.VisualStudioCode }
if ($windowsVersion.Major -lt 10 -or $windowsVersion.Build -lt 14393) { winget install -e --id Microsoft.PowerShell.Preview }

# Final check and prompting user using TUI
if ($cpuCores -ge $minCpuCores -and $memoryGB -ge $minMemoryGB -and $diskSpaceGB -ge $minDiskSpaceGB -and $windowsVersion.Major -ge 10 -and $gitVersion -and $chromeInstalled -and $vsCodeInstalled) {
    $userChoice = Read-Host "All requirements met! Do you want to open Visual Studio Code? [Y/N]"
    if ($userChoice -eq 'Y') {
        Start-Process "code"
    }
}
