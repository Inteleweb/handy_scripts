
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

$progressPreference = 'silentlyContinue'

# Define package information
$wingetInstallerUrl = 'https://aka.ms/getwinget'
$vcLibsUrl = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
$uiXamlUrl = 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx'

$wingetInstallerFile = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
$vcLibsFile = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
$uiXamlFile = 'Microsoft.UI.Xaml.2.7.x64.appx'

function IsAppxPackageInstalled($packageName) {
    $package = Get-AppxPackage -Name $packageName -ErrorAction SilentlyContinue
    return $package -ne $null
}

function DownloadAndInstallAppx($url, $file, $packageName) {
    if (-not (IsAppxPackageInstalled $packageName)) {
        Write-Information "$packageName is not installed, downloading and installing..."
        Invoke-WebRequest -Uri $url -OutFile $file -ErrorAction Stop
        Add-AppxPackage -Path $file -ErrorAction Stop
    } else {
        Write-Information "$packageName is already installed."
    }
}

# Ensure cmdlets are available
if (-not (Get-Command 'Add-AppxPackage' -ErrorAction SilentlyContinue)) {
    Write-Error "Add-AppxPackage is not available. Make sure you are running this script as an administrator in a PowerShell session."
    return
}

try {
    # Check and install WinGet if necessary
    if (-not (Get-Command 'winget' -ErrorAction SilentlyContinue)) {
        DownloadAndInstallAppx -url $wingetInstallerUrl -file $wingetInstallerFile -packageName 'WinGet'
    } else {
        Write-Information "WinGet is already installed."
    }

    # Check and install Microsoft.VCLibs if necessary
    DownloadAndInstallAppx -url $vcLibsUrl -file $vcLibsFile -packageName 'Microsoft.VCLibs.140.00.UWPDesktop'

    # Check and install Microsoft.UI.Xaml if necessary
    DownloadAndInstallAppx -url $uiXamlUrl -file $uiXamlFile -packageName 'Microsoft.UI.Xaml.2.x'

} catch {
    Write-Error "An error occurred: $_"
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
