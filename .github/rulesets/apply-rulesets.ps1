# apply-rulesets.ps1

$REPO = "UltrangLabs/Tracknner"
$API_VERSION = "2022-11-28"

Write-Host "Inyectando ruleset para ramas Core (Production y Develop)..." -ForegroundColor Cyan
gh api `
  --method POST `
  -H "Accept: application/vnd.github+json" `
  -H "X-GitHub-Api-Version: $API_VERSION" `
  /repos/$REPO/rulesets `
  --input ruleset-core.json

Write-Host "Inyectando ruleset para ramas de Fase..." -ForegroundColor Cyan
gh api `
  --method POST `
  -H "Accept: application/vnd.github+json" `
  -H "X-GitHub-Api-Version: $API_VERSION" `
  /repos/$REPO/rulesets `
  --input ruleset-phase.json

Write-Host "¡Rulesets aplicados con éxito!" -ForegroundColor Green