# 简单的PowerShell HTTP服务器
$port = 8080
$root = "."
$url = "http://localhost:$port/"

Write-Host "启动茶旅2026页面服务器..." -ForegroundColor Green
Write-Host "访问地址: $url" -ForegroundColor Yellow
Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Gray

# 创建简单的HTTP监听器
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $filePath = Join-Path $root ($request.Url.LocalPath.TrimStart('/'))
        if ($filePath -eq $root) {
            $filePath = Join-Path $root "index.html"
        }
        
        if (Test-Path $filePath -PathType Leaf) {
            $content = Get-Content $filePath -Raw
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            Write-Host "请求: $($request.Url.LocalPath) -> 200 OK" -ForegroundColor Green
        } else {
            $notFound = "<h1>404 - 页面未找到</h1><p>茶旅页面正在准备中...</p>"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($notFound)
            $response.StatusCode = 404
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            Write-Host "请求: $($request.Url.LocalPath) -> 404 Not Found" -ForegroundColor Red
        }
        
        $response.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "服务器已停止" -ForegroundColor Gray
}