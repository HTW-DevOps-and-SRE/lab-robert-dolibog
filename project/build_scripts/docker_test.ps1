$ErrorActionPreference = "Stop"

docker run `
  -e "UNITY_LICENSE=$env:UNITY_LICENSE" `
  -e "TEST_PLATFORM=$env:TEST_PLATFORM" `
  -e "UNITY_USERNAME=$env:UNITY_USERNAME" `
  -e "UNITY_PASSWORD=$env:UNITY_PASSWORD" `
  -w "/project/" `
  -v "${env:UNITY_DIR}:/project/" `
  $env:IMAGE_NAME `
  pwsh -c "/project/ci/before_script.ps1; /project/ci/test.ps1"
