$ErrorActionPreference = "Stop"

$activation_file = if ($null -ne $UNITY_ACTIVATION_FILE) { $UNITY_ACTIVATION_FILE } else { ".\unity3d.alf" }

if ([string]::IsNullOrWhiteSpace($UNITY_USERNAME) -or [string]::IsNullOrWhiteSpace($UNITY_PASSWORD)) {
    Write-Host "UNITY_USERNAME or UNITY_PASSWORD environment variables are not set, please refer to instructions in the readme and add these to your secret environment variables."
    exit 1
}

# Assuming UNITY_EDITOR points to the Unity Editor executable path
& $UNITY_EDITOR `
    -logFile UnityLog.log `
    -batchmode `
    -nographics `
    -username $UNITY_USERNAME `
    -password $UNITY_PASSWORD

# Assuming the log will contain the necessary licensing information
# This part may need to be adjusted depending on Unity's output
$licenseContent = Get-Content UnityLog.log | Select-String 'LICENSE SYSTEM .* Posting *' | ForEach-Object { $_ -replace '.*Posting *', '' }

if ($licenseContent) {
    $licenseContent | Out-File -FilePath $activation_file -Encoding Default
    Write-Host "### Congratulations! ###"
    Write-Host "$activation_file was generated successfully!"
    # ... Additional instructions ...
} else {
    Write-Host "License file could not be found at $activation_file"
    exit 1
}

# Display the content for verification
Get-Content -Path $activation_file
