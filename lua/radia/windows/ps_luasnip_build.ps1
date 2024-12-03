$find = '$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@'
$replace = '$(CC) $^ $(LDLIBS) -o $@ $(LDFLAGS)'

# Function to modify Makefile
function Modify-Makefile {
    param (
        [string]$file
    )
    If (!(Test-Path $file)) {
        throw "$file not found"
    }

    $content = Get-Content $file
    if ($content -notmatch [regex]::Escape($replace)) {
        $content.replace($find, $replace) | Set-Content $file
        Write-Host "Modified $file"
    } else {
        Write-Host "$file is already modified."
    }
}

# Modify Makefiles
Modify-Makefile '.\deps\jsregexp\Makefile'
Modify-Makefile '.\deps\jsregexp005\Makefile'

$env:CHERE_INVOKING = 'yes' # Keep current Directory
$env:MSYSTEM = 'UCRT64' # https://www.msys2.org/docs/environments/

# Function to check if a package is installed
function Is-PackageInstalled {
    param (
        [string]$packageName
    )
    $installedPackages = & C:\msys64\usr\bin\bash -lc 'pacman -Q'
    return $installedPackages -match $packageName
}

# Check and install/update packages only if they're not installed
$packages = @(
    'git',
    'mingw-w64-ucrt-x86_64-luajit',
    'mingw-w64-ucrt-x86_64-make',
    'mingw-w64-ucrt-x86_64-gcc'
)

# Update the package database
& C:\msys64\usr\bin\bash -lc 'pacman --noconfirm -Syu'

foreach ($package in $packages) {
    if (-not (Is-PackageInstalled $package)) {
        Write-Host "Installing $package..."
        & C:\msys64\usr\bin\bash -lc "pacman --noconfirm -S $package"
    } else {
        Write-Host "$package is already installed."
    }
}

# Build and install the jsregexp
& C:\msys64\usr\bin\bash -lc 'mingw32-make CC=gcc CFLAGS="-I/ucrt64/include/luajit-2.1 -O2 -Wall -fPIC" LDFLAGS="-shared -lluajit-5.1" install_jsregexp'
