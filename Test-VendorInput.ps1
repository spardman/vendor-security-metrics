# Metric #2: Systemic Security Gaps Audit Tool
param (
    [string]$ManifestPath = "vendor-manifest.json"
)

if (-not (Test-Path $ManifestPath)) {
    $mockPayload = @{
        vendorName = "UntrustedVendor_Corp"
        apiVersion = "1.0.4"
        tlsRequirement = "TLS1.1" 
        requestAdminPrivileges = $true 
        digitalSignature = "" 
    } | ConvertTo-Json
    Out-File -FilePath $ManifestPath -InputObject $mockPayload -Encoding utf8
    Write-Host "[+] Created a fresh mock vendor payload for testing." -ForegroundColor Cyan
}

Write-Host "`n=== Auditing Automated Vendor Input against Metric #2 ===" -ForegroundColor Yellow
$manifest = Get-Content $ManifestPath | ConvertFrom-Json

$gapsDetected = 0

if ([string]::IsNullOrEmpty($manifest.digitalSignature)) {
    Write-Host "[CRITICAL] Security Gap Detected: Vendor input lacks a valid digital signature!" -ForegroundColor Red
    $gapsDetected++
}

if ($manifest.tlsRequirement -eq "TLS1.0" -or $manifest.tlsRequirement -eq "TLS1.1") {
    Write-Host "[WARN] Security Gap Detected: Vendor uses deprecated protocol ($($manifest.tlsRequirement)). Minimum allowed is TLS1.2." -ForegroundColor DarkYellow
    $gapsDetected++
}

if ($manifest.requestAdminPrivileges -eq $true) {
    Write-Host "[CRITICAL] Security Gap Detected: Vendor input automatically requests local administrator access." -ForegroundColor Red
    $gapsDetected++
}

Write-Host "`n=== Audit Summary ===" -ForegroundColor Yellow
if ($gapsDetected -gt 0) {
    Write-Host "Total Systemic Security Gaps Tracked: $gapsDetected" -ForegroundColor Red
    Write-Host "[STATUS] Action Blocked. Vendor input rejected by Sandbox Safeguards." -ForegroundColor Red
    Exit 1
} else {
    Write-Host "Total Systemic Security Gaps Tracked: $gapsDetected" -ForegroundColor Green
    Write-Host "[STATUS] Action Approved. Payload safe to process." -ForegroundColor Green
    Exit 0
}
