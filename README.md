# Static-Image-Optimizer
# Static-Image-Optimizer

Static-Image-Optimizer is a PowerShell/Bash script designed to optimize JPEG/PNG images by converting them to the WebP format using FFmpeg. The script processes all images in a given directory, skipping certain folders like "storage", and replaces the original files with the optimized versions.

## Features
- Converts images to WebP format using FFmpeg.
- Preserves the original image dimensions.
- Skips files in the "storage" directory.
- Handles errors gracefully and provides detailed feedback.

## Prerequisites
- **FFmpeg:** The script relies on FFmpeg for image conversion. Make sure FFmpeg is installed and added to your system's PATH. You can download FFmpeg from [here](https://ffmpeg.org/download.html).   