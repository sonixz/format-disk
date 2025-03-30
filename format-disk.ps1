# format-disk.ps1

# Get the first RAW disk (uninitialized)
$disk = Get-Disk | Where-Object PartitionStyle -Eq 'RAW'
if ($disk) {
    Write-Host "Initializing disk $($disk.Number)..."
    $partition = Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru |
        New-Partition -UseMaximumSize -DriveLetter F

    # Format the partition
    Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel "SQLData" -Confirm:$false -Force
}

# Ensure F: exists and create required folders
if (Test-Path "F:\") {
    New-Item -Path "F:\data" -ItemType Directory -Force
    New-Item -Path "F:\log" -ItemType Directory -Force
    New-Item -Path "F:\tempDb" -ItemType Directory -Force
    Write-Host "Disk F: configured with required SQL folders."
} else {
    Write-Host "Drive F: was not created. Check disk initialization."
}


# Create required SQL folders
New-Item -Path "F:\data" -ItemType Directory -Force
New-Item -Path "F:\log" -ItemType Directory -Force
New-Item -Path "F:\tempDb" -ItemType Directory -Force

Write-Host "Disk setup completed."
