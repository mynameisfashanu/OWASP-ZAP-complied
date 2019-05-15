param(
    [string]$report
)

$ErrorMessage = "ZAP Runner Failed"
try {
    Write-Output "Starting OWASP ZAP report reader"

    Write-Output "Finding OWASP ZAP report"
    
    if(!(Test-Path $report))
    {
        Throw "The file, $report, does not exist."
    }
    
    Write-Output "Reading OWASP ZAP report"
    [xml]$XmlDocument = Get-Content $report
    
    $AlertCount = $XmlDocument.OWASPZAPReport.site.alerts.alertitem | Measure-Object
    Write-Output "Found $($AlertCount.Count) alerts in ZAP report"

    if($AlertCount.Count -eq 0)
    {
        Write-Output "No alerts found"
        exit(0)
    }

    Write-Output "Analysing alerts"

    foreach($alert in $XmlDocument.OWASPZAPReport.site.alerts.alertitem)
    {
        Write-Output "`r`n*************************************ALERT*************************************`r`n"
        Write-Output "NAME: $($alert.name)"
        Write-Output "RISK: $($alert.riskdesc)"
        Write-Output "DESCRIPTION: $($alert.desc)"
    }

    Write-Output "`r`n All alerts reported. No high risk vulnerabilities found"
    Write-Output "`r`n Analysis complete"

    exit(0)
} Catch {
  Write-Output $ErrorMessage
  exit(1)
}

