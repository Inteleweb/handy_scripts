# Set strict error handling
$ErrorActionPreference = "Stop"

# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Your download URLs for the script
$DownloadURL = 'inteleweb.com/files/flutter_get/get.ps1'
$DownloadURL2 = 'YOUR_SECONDARY_DOWNLOAD_URL'

# Random number for unique file naming
$rand = Get-Random -Maximum 99999999

# Check for admin rights and set the file path accordingly
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\YourScript_$rand.cmd" } else { "$env:TEMP\YourScript_$rand.cmd" }

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

# Execute the script
Start-Process $FilePath $ScriptArgs -Wait

# Cleanup script files after execution
$FilePaths = @("$env:TEMP\YourScript*.cmd", "$env:SystemRoot\Temp\YourScript*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
