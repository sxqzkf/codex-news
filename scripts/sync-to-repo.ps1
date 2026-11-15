param(
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$remoteUrl = "https://github.com/sxqzkf/codex-news.git"

if (-not $Message) {
    $Message = "同步软件更新 " + (Get-Date -Format "yyyy-MM-dd HH:mm")
}

git -C $repoRoot add -A
$pending = git -C $repoRoot status --porcelain

if ($pending) {
    git -C $repoRoot `
        -c user.name="sxqzkf" `
        -c user.email="3677756881@qq.com" `
        commit -m $Message
}

git -C $repoRoot -c http.sslBackend=openssl push $remoteUrl main:main
