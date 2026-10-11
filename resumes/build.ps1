[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$resumeDirectory = $PSScriptRoot
$resumeSources = @(
    'resume_johnson.tex',
    'resume_johnson_dubai.tex'
)

if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
    throw 'latexmk was not found. Install MiKTeX or add latexmk to PATH.'
}

Push-Location -LiteralPath $resumeDirectory
try {
    foreach ($source in $resumeSources) {
        & latexmk -pdf -interaction=nonstopmode -halt-on-error $source
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to compile $source. Supporting files were kept for troubleshooting."
        }
    }

    foreach ($source in $resumeSources) {
        & latexmk -c $source
        if ($LASTEXITCODE -ne 0) {
            throw "Compiled successfully, but cleanup failed for $source."
        }
    }

    $supportPatterns = @(
        '*.aux',
        '*.fdb_latexmk',
        '*.fls',
        '*.log',
        '*.out',
        '*.synctex.gz',
        '*.toc'
    )

    foreach ($pattern in $supportPatterns) {
        Get-ChildItem -LiteralPath $resumeDirectory -Filter $pattern -File |
            Remove-Item -Force
    }

    $templatePdf = Join-Path $resumeDirectory 'resume_common.pdf'
    if (Test-Path -LiteralPath $templatePdf) {
        Remove-Item -LiteralPath $templatePdf -Force
    }

    Write-Output 'Built both resumes and removed LaTeX supporting files.'
}
finally {
    Pop-Location
}
