winget install -e --id Google.Chrome;winget install -e --id TeamViewer.TeamViewer;winget install -e --id VideoLAN.VLC;winget install -e --id RARLab.WinRAR
Set-MpPreference -DisableRealtimeMonitoring
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
#install acrobat
Start-Process -FilePath .\Acrobat.exe

#enable realtime monitoring
Set-MpPreference -DisableRealtimeMonitoring $false
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 3
