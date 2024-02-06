# Stop the script on error
$ErrorActionPreference = "Stop"
# Show verbose output
$VerbosePreference = "Continue"

# Create directories if they don't exist
$env:UNITY_CACHE_PATH = "C:\Users\Public\.cache\unity3d"
$env:UNITY_LICENSE_PATH = "C:\Users\Public\.local\share\unity3d\Unity"
New-Item -ItemType Directory -Force -Path $env:UNITY_CACHE_PATH
New-Item -ItemType Directory -Force -Path $env:UNITY_LICENSE_PATH

$unity_license_destination = Join-Path $env:UNITY_LICENSE_PATH "Unity_lic.ulf"
$android_keystore_destination = "keystore.keystore"

# Check if BUILD_TARGET is set. If not, use a default value or handle the error
if ([string]::IsNullOrWhiteSpace($env:BUILD_TARGET)) {
    Write-Error "BUILD_TARGET environment variable is not set."
    exit 1
    # Alternatively, you can set a default value
    # $upper_case_build_target = "DefaultBuildTarget".ToUpper()
}
else {
    $upper_case_build_target = $env:BUILD_TARGET.ToUpper()
}

if ($upper_case_build_target -eq "ANDROID") {
    if (-not [string]::IsNullOrWhiteSpace($env:ANDROID_KEYSTORE_BASE64)) {
        Write-Verbose "Found '$env:ANDROID_KEYSTORE_BASE64', decoding content into ${android_keystore_destination}"
        [System.Convert]::FromBase64String($env:ANDROID_KEYSTORE_BASE64) | Set-Content -Path $android_keystore_destination -Encoding Byte
    }
    else {
        Write-Verbose "'$env:ANDROID_KEYSTORE_BASE64' env var not found, building with Unity's default debug keystore"
    }
}

if (-not [string]::IsNullOrWhiteSpace($env:UNITY_LICENSE)) {
    Write-Verbose "Writing UNITY_LICENSE to license file ${unity_license_destination}"
    $env:UNITY_LICENSE | Set-Content -Path $unity_license_destination
}
else {
    Write-Verbose "UNITY_LICENSE env var not found"
}
