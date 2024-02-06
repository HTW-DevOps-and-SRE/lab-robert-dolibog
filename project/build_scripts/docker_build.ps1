$ErrorActionPreference = "Stop"

# Ensure the Docker image is capable of running PowerShell scripts.
# The command assumes that PowerShell is installed in the Docker image.
docker run `
  -e "BUILD_NAME=$env:BUILD_NAME" `
  -e "UNITY_LICENSE=$env:UNITY_LICENSE" `
  -e "BUILD_TARGET=$env:BUILD_TARGET" `
  -e "UNITY_USERNAME=$env:UNITY_USERNAME" `
  -e "UNITY_PASSWORD=$env:UNITY_PASSWORD" `
  -w "/project/" `
  -v "${env:UNITY_DIR}:/project/" `
  $env:IMAGE_NAME `
  pwsh -c "/project/ci/before_script.ps1; /project/ci/build.ps1"
