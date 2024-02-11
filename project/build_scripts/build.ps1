# Stop the script on error
$ErrorActionPreference = "Stop"
# Show verbose output
$VerbosePreference = "Continue"

Write-Host "Building for $env:BUILD_TARGET"

$env:BUILD_PATH = Join-Path $env:UNITY_DIR "Builds\$env:BUILD_TARGET"
New-Item -ItemType Directory -Force -Path $env:BUILD_PATH

$unityExecutable = if ($env:UNITY_EXECUTABLE) { $env:UNITY_EXECUTABLE } else { "Unity.exe" }

& $unityExecutable `
    -projectPath $env:UNITY_DIR `
    -quit `
    -batchmode `
    -nographics `
    -buildTarget $env:BUILD_TARGET `
    -customBuildTarget $env:BUILD_TARGET `
    -customBuildName $env:BUILD_NAME `
    -customBuildPath $env:BUILD_PATH `
    -executeMethod BuildCommand.PerformBuild `
    -logFile UnityBuild.log

# Loop to wait for build completion
$unityLogPath = Join-Path $env:CI_PROJECT_DIR "UnityBuild.log"
$buildSuccessMessage = "Exiting batchmode successfully now!"
$timeout = 1800  # Set timeout to 30 minutes (1800 seconds)
$startTime = Get-Date

do {
    Start-Sleep -Seconds 30
    $buildSuccess = Get-Content $unityLogPath | Select-String -Pattern $buildSuccessMessage -Quiet

    if ($buildSuccess) {
        Write-Host "Build completed successfully."
        break
    }

    $currentTime = Get-Date
    $elapsed = ($currentTime - $startTime).TotalSeconds
    if ($elapsed -gt $timeout) {
        throw "Build process timed out."
    }
} while ($true)

# Check build result
switch ($UNITY_EXIT_CODE) {
    0 { Write-Host "Run succeeded, no failures occurred" }
    2 { Write-Host "Run succeeded, some tests failed" }
    3 { Write-Host "Run failure (other failure)" }
    default { Write-Host "Unexpected exit code $UNITY_EXIT_CODE" }
}

