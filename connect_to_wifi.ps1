# Set the Wi-Fi SSID (network name) and password
$wifiSSID = "MY_SSID"
$wifiPassword = "MY_PSWD"

# Connect to the Wi-Fi network
netsh wlan connect ssid="$wifiSSID" name="$wifiSSID" key="$wifiPassword"

# Check if the connection was successful
if ($?) {
    Write-Host "Connected to Wi-Fi network: $wifiSSID"
} else {
    Write-Host "Failed to connect to Wi-Fi network: $wifiSSID"
}
