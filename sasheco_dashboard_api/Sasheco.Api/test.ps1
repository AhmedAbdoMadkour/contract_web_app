$process = Start-Process -FilePath "dotnet" -ArgumentList "run" -WorkingDirectory "d:\programming\projects\sasheco-v1\sasheco_dashboard_api\Sasheco.Api" -PassThru -NoNewWindow
Start-Sleep -Seconds 5
$body = '{"username":"admin","password":"password"}'
$response = Invoke-WebRequest -Uri "http://localhost:5191/api/auth/login" -Method Post -Body $body -ContentType "application/json" -ErrorAction SilentlyContinue
Write-Host "Status: $($response.StatusCode)"
Write-Host "Content: $($response.Content)"
Start-Sleep -Seconds 2
Stop-Process -Id $process.Id -Force
