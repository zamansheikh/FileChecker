# FileChecker.ps1

**Developer:** Zaman Sheikh

## Description

FileChecker.ps1 is a PowerShell script designed to generate and match checksums for files within a specified directory. It provides a convenient way to verify file integrity and detect any changes or discrepancies in the files.

The script offers two main functionalities:

1. **Generate Checksums:** This option generates checksums (using SHA256 algorithm) for all files within a specified directory and saves them to a file named `checksums.txt`. This allows users to establish a baseline for file integrity.

2. **Match Checksums:** This option compares the current checksums of files within the directory with the previously generated checksums. It identifies any missing files, newly added files, or files with changed contents and logs them in a file named `mismatch_log.txt`.

## Usage

1. **Generate Checksums:**
   - Select option 1 from the menu.
   - The script will generate checksums for all files in the current directory and its subdirectories.
   - Checksums will be saved to `checksums.txt` in the same directory.

2. **Match Checksums:**
   - Select option 2 from the menu.
   - The script will compare the current checksums of files with the checksums saved in `checksums.txt`.
   - Any discrepancies will be logged in `mismatch_log.txt`.

3. **Exit:**
   - Select option 3 to exit the script.

## Requirements

- PowerShell 5.1 or higher.

## How to Run

1. Download the `FileChecker.ps1` script.
2. Open PowerShell.
3. Navigate to the directory containing the script.
4. Run the script by entering `.\FileChecker.ps1`.
5. Follow the on-screen prompts to generate or match checksums.

## Notes

- Ensure that the script is run with appropriate permissions to access the specified directory and create files.
