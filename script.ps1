Add-Type -AssemblyName System.Drawing

# Initial input folder paths (Root folder for images and temporary folder for processing)
$rootFolder = "C:\path\to\folder"


# List of excluded folders
$excludedFolders = @("storage", "anotherFolder", "excludeThisToo")

$tempFolder = $rootFolder
# Counters for processed, optimized, and skipped files
$processedCount = 0
$optimizedCount = 0
$skippedCount = 0

# Function to check if FFmpeg is installed
try {
    & ffmpeg -version > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "FFmpeg is not installed or not found in the system's PATH. Please install FFmpeg and ensure it's in the PATH."
        exit
    }
}
catch {
    Write-Error "FFmpeg is not installed or not found in the system's PATH. Please install FFmpeg and ensure it's in the PATH."
    exit
}


# Function to prompt user for a valid folder path
function Get-ValidFolderPath {
    param (
        [string]$initialFolder
    )

    while (-not (Test-Path $initialFolder)) {
        Write-Host "The folder path '$initialFolder' does not exist."
        $initialFolder = Read-Host "Please enter a valid root folder path"
    }

    return $initialFolder
}

# Validate or prompt for root folder path
$rootFolder = Get-ValidFolderPath -initialFolder $rootFolder

# Validate temporary folder
if (-not (Test-Path $tempFolder)) {
    Write-Error "Temporary folder path does not exist: $tempFolder"
    exit
}

# Function to get image dimensions
function Get-ImageDimensions {
    param ($file)
    try {
        $image = New-Object System.Drawing.Bitmap($file)
        $width = $image.Width
        $height = $image.Height
        $image.Dispose()

        return [PSCustomObject]@{
            Width  = $width
            Height = $height
        }
    }
    catch {
        Write-Error "Failed to get dimensions for $file`: $_"
        return $null
    }
}

# Check if the file is in an excluded folder
function IsInExcludedFolder {
    param ($fileDirectory)
    foreach ($excludedFolder in $excludedFolders) {
        if ($fileDirectory -like "*$excludedFolder*") {
            return $true
        }
    }
    return $false
}

# Process all JPG, JPEG, PNG images in the root folder and its subdirectories
Get-ChildItem -Path $rootFolder -Recurse -Include *.jpg, *.jpeg, *.png -File | ForEach-Object {
    $file = $_
    $fileFullPath = $file.FullName
    $fileDirectory = $file.DirectoryName

    $processedCount++

    # Skip files in excluded folders
    if (IsInExcludedFolder -fileDirectory $fileDirectory) {
        Write-Host "Skipping file in excluded folder: $fileFullPath"
        $skippedCount++
        return
    }

    try {
        Write-Host "Processing file: $fileFullPath"

        # Get image dimensions
        $imageDimensions = Get-ImageDimensions -file $fileFullPath
        if (-not $imageDimensions) {
            Write-Error "Skipping $fileFullPath due to error in retrieving image dimensions."
            $skippedCount++
            return
        }

        # Prepare temp file path and execute FFmpeg command
        $tempFileFullPath = Join-Path -Path $tempFolder -ChildPath $file.Name
        $ffmpegCommand = "ffmpeg -loglevel error -y -i `"$fileFullPath`" -vf scale=$($imageDimensions.Width):$($imageDimensions.Height) -c:v libwebp -q:v 2 -map_metadata -1 `"$tempFileFullPath`""
        Invoke-Expression $ffmpegCommand

        if ($?) {
            # Remove the original file and move optimized image back to the original location
            Remove-Item -Path $fileFullPath -Force
            Move-Item -Path $tempFileFullPath -Destination $fileFullPath -Force
            Write-Host "Processed and replaced: $fileFullPath"
            $optimizedCount++
        }
        else {
            Write-Error "Failed to process $fileFullPath"
            $skippedCount++
        }

        Write-Host "_______________________________________________"
    }
    catch {
        Write-Error "Error processing file $fileFullPath`: $_"
        $skippedCount++
    }
}

Write-Host "Summary of Processing:"
Write-Host "Total files processed: $processedCount"
Write-Host "Total files optimized: $optimizedCount"
Write-Host "Total files skipped: $skippedCount"
