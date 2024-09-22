Add-Type -AssemblyName System.Drawing

# Input folder paths (Root folder for images and temporary folder for processing)
$rootFolder = "C:\bla\bla\bla"
$tempFolder = "C:\bla\bla"

# Validate input directories
if (-not (Test-Path $rootFolder)) {
    Write-Error "Root folder path does not exist: $rootFolder"
    exit
}
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
            Width = $width
            Height = $height
        }
    } catch {
        Write-Error "Failed to get dimensions for $file`: $_"
        return $null
    }
}

# Process all JPG images in the root folder and its subdirectories
Get-ChildItem -Path $rootFolder -Recurse -Include *.jpg -File | ForEach-Object {
    $file = $_
    $fileFullPath = $file.FullName
    $fileDirectory = $file.DirectoryName

    # Skip files in the "storage" folder
    if ($fileDirectory -like "*storage*") {
        Write-Host "Skipping file in storage folder: $fileFullPath"
        return
    }

    try {
        Write-Host "Processing file: $fileFullPath"

        # Get image dimensions
        $imageDimensions = Get-ImageDimensions -file $fileFullPath
        if (-not $imageDimensions) {
            Write-Error "Skipping $fileFullPath due to error in retrieving image dimensions."
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
        } else {
            Write-Error "Failed to process $fileFullPath"
        }

        Write-Host "_______________________________________________"
    } catch {
        Write-Error "Error processing file $fileFullPath`: $_"
    }
}
