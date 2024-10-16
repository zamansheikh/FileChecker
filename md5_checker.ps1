# Define checks directory path
$checksDir = "checks"

# Function to generate MD5 hashes for each file and save them in the checks/ directory
function Generate-MD5Hashes {
  # Create checks directory if it doesn't exist
  if (-not (Test-Path -Path $checksDir -PathType Directory)) {
    New-Item -ItemType Directory -Path $checksDir
  }

  Write-Host "Generating MD5 checksums for all files in the current directory and its subdirectories (excluding checks/ folder and md5_checker.ps1)..."

  # Find all files, excluding the md5_checker.ps1 itself and anything in the checks folder
  Get-ChildItem -Path . -Recurse -File | Where-Object { $_.FullName -notlike "$checksDir\*"} | Where-Object { $_.Name -ne "md5_checker.ps1" } | ForEach-Object {
    # Calculate checksum
    $checksum = Get-FileHash -Path $_.FullName -Algorithm MD5 | Select-Object -ExpandProperty Hash
    $filename = $_.BaseName

    # Store checksum in a .checks file inside the checks/ directory
    Out-File -FilePath "$checksDir\$filename.checks" -InputObject $checksum -Append -Encoding ASCII
  }

  Write-Host "MD5 checksums saved in $checksDir"
}

# Function to check MD5 hashes against stored .checks files
function Check-MD5Hashes {
  # Check if checks directory exists
  if (-not (Test-Path -Path $checksDir -PathType Directory)) {
    Write-Warning "The directory $checksDir does not exist. Please generate checksums first."
    return
  }

  Write-Host "Checking file integrity by comparing checksums in $checksDir..."

  # Initialize counters
  $totalFiles = 0
  $matchedFiles = 0
  $unmatchedFiles = 0
  $unmatchedList = @()

  # Find all files, excluding the md5_checker.ps1 and anything in the checks folder
  Get-ChildItem -Path . -Recurse -File | Where-Object { $_.FullName -notlike "$checksDir\*"} | Where-Object { $_.Name -ne "md5_checker.ps1" } | ForEach-Object {
    $totalFiles++
    $filename = $_.BaseName
    $checksFile = Join-Path $checksDir -ChildPath "$filename.checks"

    # Check if .checks file exists
    if (Test-Path -Path $checksFile) {
      # Read the stored checksum (removing any extra spaces or newlines)
      $storedChecksum = Get-Content $checksFile | ConvertFrom-StringData -Encoding ASCII | Trim

      # Calculate the current checksum
      $currentChecksum = Get-FileHash -Path $_.FullName -Algorithm MD5 | Select-Object -ExpandProperty Hash

      # Compare the checksums
      if ($storedChecksum -eq $currentChecksum) {
        Write-Host "$filename: OK"
        $matchedFiles++
      } else {
        Write-Warning "$filename: FAILED"
        $unmatchedFiles++
        $unmatchedList += $_.FullName
      }
    } else {
      Write-Warning "Warning: Checksum file for $filename not found in $checksDir."
      $unmatchedFiles++
      $unmatchedList += $_.FullName
    }
  }

  # Print result summary
  if ($unmatchedFiles -eq 0) {
    Write-Host "All files match."
  } else {
    Write-Host "Match: $matchedFiles out of $totalFiles files, $unmatchedFiles not matched."
    Write-Host "Files that didn't match or had no checksum file:"
    $unmatchedList | ForEach-Object { Write-Host $_ }
  }
}

# Function to display menu
function Display-Menu {
  Write-Host "--------------------------------"
  Write-Host "     MD5 Hash Checker           "
  Write-Host "--------------------------------"
  Write-Host "1. Start MD5 Check (Generate .checks files)"
  Write-Host "2. Match MD5 Hashes (Check against .checks files)"
  Write-Host "3. Exit"
  Write-Host "--------------------------------"
  Write-Host -NoNewline "Choose an option: "
}

# Main loop
while ($true) {
  Display-Menu
  $choice = Read-Host
