# format-disk.ps1

# Get the first RAW disk (uninitialized)
$disk = Get-Disk | Where-Object PartitionStyle -Eq 'RAW'
if ($disk) {
    Write-Host "Initializing disk $($disk.Number)..."
    Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru |
        New-Partition -UseMaximumSize -AssignDriveLetter |
        Format-Volume -FileSystem NTFS -Confirm:$false -Force
}

# Assign drive letter F if not already F
$volume = Get-Volume | Where-Object { $_.DriveLetter -ne $null -and $_.FileSystemLabel -ne 'System Reserved' } |
    Sort-Object DriveLetter | Select-Object -First 1

if ($volume.DriveLetter -ne 'F') {
    Write-Host "Assigning drive letter F to volume $($volume.DriveLetter)..."
    Set-Partition -DriveLetter $volume.DriveLetter -NewDriveLetter 'F'
}

# Create required SQL folders
New-Item -Path "F:\data" -ItemType Directory -Force
New-Item -Path "F:\log" -ItemType Directory -Force
New-Item -Path "F:\tempDb" -ItemType Directory -Force

Write-Host "Disk setup completed."
