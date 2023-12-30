# Set strict error handling
$ErrorActionPreference = "Stop"

# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Your download URLs for the script
$DownloadURL = 'https://raw.githubusercontent.com/Inteleweb/handy_scripts/e42efadb4a16ebe6c3e9890bd1c86fb037961b2e/flutter_install/flutter_install.ps1'
$DownloadURL2 = 'https://inteleweb.com/files/flutter_install/flutter_install.ps1'

# Random number for unique file naming
$rand = Get-Random -Maximum 99999999


# Check for admin rights and set the file path accordingly
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\YourScript_$rand.cmd" } else { "$env:TEMP\YourScript_$rand.cmd" }


# Prompt for continuation for debugging before downloading
Read-Host "Press Enter to continue with the download or any other key to exit" -OutVariable continue
if ($continue -ne "") { exit }

# Attempt to download the script from the primary URL, fallback to secondary if needed
try {
    $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
}
catch {
    $response = Invoke-WebRequest -Uri $DownloadURL2 -UseBasicParsing
}

# Prepare and write the script content to the file
$ScriptArgs = "$args "
$prefix = "@REM $rand `r`n"
$content = $prefix + $response.Content
Set-Content -Path $FilePath -Value $content


# Prompt for continuation after download and before execution
Read-Host "Download complete. Press Enter to execute the script or any other key to exit" -OutVariable continue
if ($continue -ne "") { exit }


# Execute the script
Start-Process $FilePath $ScriptArgs -Wait

# Cleanup script files after execution
$FilePaths = @("$env:TEMP\YourScript*.cmd", "$env:SystemRoot\Temp\YourScript*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
