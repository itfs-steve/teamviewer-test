$teamviewerServers = @(
    "GB-LON-ANX-R001.router.teamviewer.com",
    "GB-LON-ANX-R002.router.teamviewer.com"
)

$teamviewerServerPorts = @(
    5938,
    443,
    80
)

$teamviewerSites = @(
    "www.teamviewer.com"
)

$globalServers = @(
    "8.8.8.8",
    "1.1.1.1",
    "google.com"
)

$errorcount = 0;
$currentDateTime = Get-Date -Format "yyyy-MM-dd HH-mm-ss"

Start-Transcript -Path "C:\temp\teamviewertest $currentDateTime.txt" -Append

Write-Host "[INFO] Testing Global Servers..." -ForegroundColor Cyan
foreach ($server in $globalServers) {
    $test = Test-Connection -ComputerName "$server" -Count 1
    if ($test.Status -eq "Success") {
        Write-Host "[SUCCESS] Connection to $server was successful." -ForegroundColor Green
    } else {
        Write-Error "[ERROR] Connection to server $server failed."
        $errorcount++
    }
}


Write-Host "[INFO] Testing Teamviewer Sites..." -ForegroundColor Cyan
foreach ($server in $teamviewerSites) {
    $test = Test-Connection -ComputerName "$server" -Count 1
    if ($test.Status -eq "Success") {
        Write-Host "[SUCCESS] Connection to $server was successful." -ForegroundColor Green
    } else {
        Write-Error "[ERROR] Connection to site $server failed."
        $errorcount++
    }
}


Write-Host "[INFO] Testing Teamviewer Servers..." -ForegroundColor Cyan
foreach ($server in $teamviewerServers) {
    foreach ($port in $teamviewerServerPorts) {
        $test = Test-NetConnection -ComputerName "$server" -Port $port
        if ($test.TcpTestSucceeded -eq $true) {
            Write-Host "[SUCCESS] Connection to $server using port $port was successful." -ForegroundColor Green
        } else {
            Write-Error "[ERROR] Connection to $server using port $port failed."
            $errorcount++
        }
    }
}


if ($errorcount -ne 0) {
    Write-Error "[CRITICAL] $errorcount errors detected"
    Stop-Transcript
    exit 1
} else {
    Write-Host "[SUCCESS] No errors found!" -ForegroundColor Green
    Stop-Transcript
    exit 0
}

