[CmdletBinding()]
param()

$sourceDrive = "J:\"
$destinationRoot = "H:\source\dji_action_5\alpha"

Write-Host "========== DJI Import Started =========="
Write-Host "Checking source drive: $sourceDrive"

if (!(Test-Path $sourceDrive)) {
    Write-Host "Source drive not found. Exiting."
    return
}

$files = Get-ChildItem -Path $sourceDrive -Recurse -Include *.mp4, *.mov -ErrorAction SilentlyContinue

if (!$files) {
    Write-Host "No video files found."
    return
}

Write-Host "Found $($files.Count) video file(s)."

foreach ($file in $files) {

    Write-Verbose "Processing file: $($file.FullName)"

    $dt = $file.CreationTime
    $year  = $dt.ToString("yyyy")
    $month = $dt.ToString("MM")
    $day   = $dt.ToString("dd")

    $targetFolder = Join-Path $destinationRoot "$year\$month\$day"

    if (!(Test-Path $targetFolder)) {
        Write-Verbose "Creating folder: $targetFolder"
        New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
    }

    $destinationPath = Join-Path $targetFolder $file.Name

    Write-Host "Moving: $($file.Name) -> $targetFolder"

    try {
        Move-Item -LiteralPath $file.FullName -Destination $destinationPath -Force
        Write-Verbose "Successfully moved."
    }
    catch {
        Write-Host "ERROR moving file: $($file.Name)"
        Write-Host $_
    }
}

Write-Host "========== DJI Import Finished =========="