# Variables
$find = '$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@'
$replace = '$(CC) $^ $(LDLIBS) -o $@ $(LDFLAGS)'

# Function to modify Makefile
function Modify-Makefile {
    param (
        [string]$file
    )
    if (!(Test-Path $file)) {
        throw "$file not found"
    }

    $content = Get-Content $file
    if ($content -notmatch [regex]::Escape($replace)) {
        $content -replace [regex]::Escape($find), $replace | Set-Content $file
        Write-Host "Modified $file"
    } else {
        Write-Host "$file is already modified."
    }
}

# Modify the Makefiles
Modify-Makefile '.\deps\jsregexp\Makefile'
Modify-Makefile '.\deps\jsregexp005\Makefile'

# Install required packages using Scoop
$packages = @('git', 'gcc', 'make', 'luajit')

foreach ($pkg in $packages) {
    if (-not (scoop list | Select-String $pkg)) {
        Write-Host "Installing $pkg..."
        scoop install $pkg
    } else {
        Write-Host "$pkg is already installed."
    }
}

# Paths for LuaJIT headers and libs
$luaInc = "$env:SCOOP\apps\luajit\current\include"
$luaLib = "$env:SCOOP\apps\luajit\current\lib"

# Set env vars for build
$env:CC = "gcc"
$env:CFLAGS = "-I$luaInc -O2 -Wall -fPIC"
$env:LDFLAGS = "-shared -L$luaLib -lluajit-5.1"

# Build DLL using native make
Push-Location '.\deps\jsregexp'
make CC=$env:CC CFLAGS="$env:CFLAGS" LDFLAGS="$env:LDFLAGS" install_jsregexp
Pop-Location
