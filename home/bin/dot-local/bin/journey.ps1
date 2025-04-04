function exist_or_open {
    $Document = "E:\doc"
    $d_file = "$Document\notes\2-daily\$(Get-Date -Format 'yyyy\\MM\\yyyy-MM-dd').md"

    if (-not (Test-Path $d_file)) {
        Copy-Item -Path "$Document\notes\template\Journey.md" -Destination $d_file
    }
    Set-Location "$Document\notes"
    nvim $d_file
}
exist_or_open
