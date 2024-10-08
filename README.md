# Static-Image-Optimizer

**Static-Image-Optimizer** is a lightweight and efficient PowerShell script designed to optimize JPEG and PNG images by compressing the file and removing the metadata using FFmpeg. By compressing images while preserving their original quality and dimensions, this tool helps you reduce file sizes, improve website performance, and save storage space without compromising on visual fidelity.

## Features
- **Efficient Image Optimization:** Converts JPG, JPEG, and PNG images to WebP format using FFmpeg for improved file size and performance.
- **Original Dimensions Preserved:** Maintains the original image dimensions, ensuring that your images look exactly the same after conversion.
- **Exclusion of Specific Folders:** Skips designated folders (e.g., `storage`) to avoid processing unwanted directories.
- **Detailed Feedback:** Provides clear and informative output throughout the process, including file-by-file statuses and overall results.
- **Error Handling:** Gracefully manages errors and skips problematic files, preventing interruptions during batch processing.

## Prerequisites
To use **Static-Image-Optimizer**, you must have the following installed on your system:

- **FFmpeg:** This script relies on FFmpeg to perform image conversions. Ensure that FFmpeg is installed and added to your system's `PATH`. You can download FFmpeg from the official website: [FFmpeg Download](https://ffmpeg.org/download.html).

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/tauseedzaman/Static-Image-Optimizer.git
   ```

2. **Install FFmpeg:** 
   - **Windows:** Download FFmpeg and ensure it's added to the system's `PATH`.

3. **Run the Script:**
   - **PowerShell (Windows):**
     ```bash
     ./script.ps1
     ```
## Usage

1. Place the script in your project directory or specify the root folder where your images are stored.
   
2. **Default Excluded Folders:**
   The script excludes specific folders like `storage` from optimization to prevent accidental modification of sensitive files. You can customize this exclusion list within the script.

3. **Process Flow:**
   - The script scans all images (`.jpg`, `.jpeg`, `.png`) in the specified directory and its subdirectories.
   - FFmpeg is used to convert each image to the WebP format.
   - After conversion, the original image is replaced by the optimized version.

### Example

- **Running the script with default folder paths**:
    ```bash
    ./script.ps1
    ```

- **Prompt for valid folder path**:
    If the initial root folder is invalid, the script will prompt the user to enter a valid directory.

## Error Handling

- **FFmpeg Not Found:** If FFmpeg is not installed or not found in the system’s `PATH`, the script will halt and provide instructions for installation.
- **Invalid Folder Paths:** If the specified folder path is not valid, the script will prompt the user for a correct directory or terminate if an invalid path is repeatedly entered.
- **File-Specific Errors:** Files that cannot be processed (e.g., due to corrupt image files or permission issues) are skipped, with the errors logged for review.

## Summary Output

After processing, the script provides a detailed summary:
- **Total files processed:**
- **Total files optimized:**
- **Total files skipped:** 

## Contributing

Contributions are welcome! Feel free to fork this repository, make your improvements, and create pull requests. Ensure that your code adheres to the project's coding standards and is thoroughly tested.

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

## Contact

For issues, suggestions, or general inquiries, feel free to open an issue on the repository or contact the author directly.

**Author**: [@tauseedzaman](https://github.com/tauseedzaman)
