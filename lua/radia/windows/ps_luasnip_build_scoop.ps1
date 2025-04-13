# Variables
$find = '$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@'
$replace = '$(CC) $^ $(LDLIBS) -o $@ $(LDFLAGS)'
$scoopRoot = Split-Path -Path (Split-Path -Path (Get-Command scoop).Source -Parent) -Parent

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
$luaInc = "$scoopRoot\apps\luajit\current\include"
$luaLib = "$scoopRoot\apps\luajit\current\lib"

# Set env vars for build
$env:CC = "gcc"
$env:CFLAGS = "-I$luaInc -O2 -Wall -fPIC"
$env:LDFLAGS = "-shared -L$luaLib -lluajit-5.1"

# Build DLL using native make
Push-Location '.\deps\jsregexp'
make CC=$env:CC CFLAGS="$env:CFLAGS" LDFLAGS="$env:LDFLAGS" install_jsregexp
Pop-Location



# $scoopRoot = Split-Path -Path (Split-Path -Path (Get-Command scoop).Source -Parent) -Parent
# cd .\deps\jsregexp
#
# gcc -I"$scoopRoot\apps\luajit\current\include\luajit-2.1" -O2 -Wall -Wno-maybe-uninitialized -fPIC -c jsregexp.c -o jsregexp.o
# gcc -shared jsregexp.o -o jsregexp.dll -L"$scoopRoot\apps\luajit\current\lib" -lluajit-5.1
#
# Write-Host "Built jsregexp.dll ✅"
