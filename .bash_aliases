alias gits='git status'
if [ ! -z "${WSL_DISTRO_NAME}" ]; then
  alias pbpaste='powershell.exe -NoProfile -NoLogo -NonInteractive -Command "Get-Clipboard"'
fi
