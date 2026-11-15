param(
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$remoteUrl = "https://github.com/sxqzkf/codex-news.git"

if (-not $Message) {
    $Message = "同步软件更新 " + (Get-Date -Format "yyyy-MM-dd HH:mm")
}

function Invoke-Git {
    param([string[]]$Arguments)

    & git -C $repoRoot @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw ("git " + ($Arguments -join " ") + " failed with exit code " + $LASTEXITCODE)
    }
}

$pending = & git -C $repoRoot status --porcelain
if ($LASTEXITCODE -ne 0) {
    throw "Unable to read repository status with exit code $LASTEXITCODE"
}

if ($pending) {
    Invoke-Git @("add", "-A")
    Invoke-Git @(
        "-c", "user.name=sxqzkf",
        "-c", "user.email=3677756881@qq.com",
        "commit", "-m", $Message
    )
}

Invoke-Git @("-c", "http.sslBackend=openssl", "push", $remoteUrl, "main:main")
