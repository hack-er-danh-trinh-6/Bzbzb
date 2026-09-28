# Deprecated legacy bootstrap script. Do not run this file.
# It previously embedded an RDP password and attempted to extract website homepages
# as software archives. The supported setup is the manual GitHub Actions workflow:
# .github/workflows/test-compiler.yml
$ErrorActionPreference = 'Stop'
throw 'This legacy script is disabled. Use the manual GitHub Actions workflow and rotate any RDP password previously stored in this file.'
