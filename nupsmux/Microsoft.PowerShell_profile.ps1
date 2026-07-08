function wtd { wt -d . }


# touch
function touch ($command) {
    New-Item -Path $command -ItemType File | out-null && Write-Host Created $command
}

function rm ($command) {
    Remove-Item $command -Recurse -Force && Write-Host Removed $command
}

## $Env:PATH management
Function Add-DirectoryToPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("FullName")]
        [string] $path,
        [string] $variable = "PATH",

        [switch] $clear,
        [switch] $force,
        [switch] $prepend,
        [switch] $whatIf
    )

    BEGIN {

        ## normalize paths

        $count = 0
        $paths = @()

        if (-not $clear.IsPresent) {

            $environ = Invoke-Expression "`$Env:$variable"
            $environ.Split(";") | ForEach-Object {
                if ($_.Length -gt 0) {
                    $count = $count + 1
                    $paths += $_.ToLowerInvariant()
                }
            }

            Write-Verbose "Currently $($count) entries in `$env:$variable"
        }

        Function Array-Contains {
            param(
                [string[]] $array,
                [string] $item
            )

            $any = $array | Where-Object -FilterScript {
                $_ -eq $item
            }

            Write-Output ($null -ne $any)
        }
    }

    PROCESS {

        if ([IO.Directory]::Exists($path) -or $force.IsPresent) {

            $path = $path.Trim()

            $newPath = $path.ToLowerInvariant()
            if (-not (Array-Contains -Array $paths -Item $newPath)) {
                if ($whatIf.IsPresent) {
                    Write-Host $path
                }

                if ($prepend.IsPresent) { $paths = , $path + $paths }
                else { $paths += $path }

                Write-Verbose "Adding $($path) to `$env:$variable"
            }
        }
        else {

            Write-Host "Invalid entry in `$Env:$($variable): ``$path``" -ForegroundColor Yellow

        }
    }

    END {

        ## re-create PATH environment variable

        $separator = [IO.Path]::PathSeparator
        $joinedPaths = [string]::Join($separator, $paths)

        if ($whatIf.IsPresent) {
            Write-Output $joinedPaths
        }
        else {
            Invoke-Expression " `$env:$variable = `"$joinedPaths`" "
        }
    }

}

# . oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\kali.omp.json" | Invoke-Expression
# . oh-my-posh init pwsh --config "~/kali.omp.json" | Invoke-Expression

if (Get-Module -ListAvailable Terminal-Icons) {
  Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}


Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

function ll {
    Get-ChildItem $Args[0] |
        Format-Table Mode, @{N='Owner';E={(Get-Acl $_.FullName).Owner}}, Length, LastWriteTime, @{N='Name';E={if($_.Target) {$_.Name+' -> '+$_.Target} else {$_.Name}}}
}

function whereis ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function reloadprofile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }
}

function cas {
  # Clear Alternate Screen
  # https://github.com/microsoft/terminal/issues/17739
  [System.Console]::Write("`e[?1049l")
  Clear-Host  # Clears the console
}

function ias {
  # Entering Alternate Screen
  # https://github.com/microsoft/terminal/issues/17739
  [System.Console]::Write("`e[?1049h")
  Clear-Host  # Clears the console
}

function conda_active {
    & 'C:\ProgramData\miniconda3\shell\condabin\conda-hook.ps1'
    conda activate 'C:\ProgramData\miniconda3'
}

$global:originalPrompt = $function:prompt

function DeactivateVenvPrompt {
    $function:prompt = $global:originalPrompt
}
$env:CONDA_CHANGEPS1 = "false"

# function fzf-psmux-project {
#   $fdArgs = @(
#     ".",
#     "$HOME\IdeaProjects", "$HOME\goproject", "$HOME\Dev\Work", "$HOME\Dev\Personal",
#     "--type", "d",
#     "--max-depth", "1",
#     "--exclude", ".git",
#     "--exclude", "node_modules"
#   )

#   $fdOutput = & fd @fdArgs 2>$null
#   if (-not $fdOutput) {
#     Write-Host "No directories found." -ForegroundColor Yellow
#     return
#   }

#   $target = $fdOutput | fzf `
#     --preview "dir `"{}`"" `
#     --bind "ctrl-space:toggle-preview" `
#     --exit-0

#   if (-not $target) { return }

#   $target = (Resolve-Path -LiteralPath $target).Path

#   # Create unique session name from full path, not only folder name
#   # Example: C:\Users\akura\Dev\Personal\golangtailwinds -> Dev_Personal_golangtailwinds
#   $session = $target `
#     -replace '^[A-Za-z]:\\Users\\[^\\]+\\', '' `
#     -replace '^[A-Za-z]:\\', '' `
#     -replace '[\\/:.\s]+', '_' `
#     -replace '[^a-zA-Z0-9_-]', '_'

#   $session = $session.Trim("_")

#   psmux has-session -t $session *> $null
#   $exists = $LASTEXITCODE -eq 0

#   if (-not $exists) {
#     psmux new-session -d -s $session -c $target
#   }

#   # Try switch-client first (works only when we already have an attached client,
#   # i.e. we're inside psmux). If it fails, we're outside, so attach.
#   psmux switch-client -t $session 2>$null
#   if ($LASTEXITCODE -ne 0) {
#     psmux attach -t $session
#   }
# }
# Set-PSReadLineKeyHandler -Chord Ctrl+f -ScriptBlock {
#   [Microsoft.PowerShell.PSConsoleReadLine]::Insert("fzf-psmux-project")
#   [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }


Set-FzfHistoryKeybind -Chord Ctrl+r


# function fzf-psmux {
#   $sessions = & psmux list-sessions -F "#{session_name}" 2>$null
#
#   if (-not $sessions) {
#     Write-Host "No psmux sessions found." -ForegroundColor Yellow
#     return
#   }
#
#   $target = $sessions | fzf `
#     --prompt "psmux session> " `
#     --preview "psmux list-windows -t {}" `
#     --bind "ctrl-space:toggle-preview" `
#     --exit-0 `
#     --exact
#
#   if (-not $target) { return }
#
#   $target = $target.Trim()
#
#   if ($env:TMUX) {
#     # INSIDE psmux
#     psmux switch-client -t $target
#   } else {
#     # OUTSIDE psmux
#     psmux attach -t $target
#   }
# }
#
#
# Set-PSReadLineKeyHandler -Chord Ctrl+l -ScriptBlock {
#   [Microsoft.PowerShell.PSConsoleReadLine]::Insert("fzf-psmux")
#   [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }


#region psmux integration (migrated from Nushell config.nu)

$env:EDITOR = "nvim"

# Generate short session name: first 2 chars for all but last 3 dirs, alphanumeric
function psmux-session-name {
    param([string]$dir)
    $parts = $dir -split '\\'
    $len = $parts.Count
    $n = if ($len -gt 3) { 3 } else { $len }
    $head = @()
    if ($len -gt $n) {
        $head = $parts[0..($len - $n - 1)] | ForEach-Object {
            $p = $_ -replace ':', ''
            if ($p.Length -ge 2) { $p.Substring(0, 2) } else { $p }
        }
    }
    $tail = $parts[($len - $n)..($len - 1)]
    $joined = (@($head) + @($tail)) -join '_'
    ($joined.ToLower() -replace '[^a-z0-9]+', '_').Trim('_')
}

# Ensure psmux server is running (called before any psmux command)
function psmux-ensure-server {
    psmux server-info *> $null
    if ($LASTEXITCODE -ne 0) {
        psmux new-session -ds default
    }
}

# psmux: create/attach session for current directory
function psmux-here {
    psmux-ensure-server
    $session = psmux-session-name $PWD.Path
    $wasInside = $env:PSMUX_SESSION
    if ($wasInside) { Remove-Item Env:\PSMUX_SESSION -ErrorAction SilentlyContinue }

    $create = psmux new-session -ds $session -c $PWD.Path 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host ("psmux: " + (($create -join ' ').Trim())) -ForegroundColor Yellow
    }

    if ($wasInside) {
        $env:PSMUX_SESSION = $wasInside
        psmux switch-client -t $session
    } elseif ($env:TMUX) {
        psmux switch-client -t $session
    } else {
        psmux attach -t $session
    }
}

# psmux project picker: choose folder from ~/Dev/, create (or attach if exists)
function psmux-project {
    psmux-ensure-server
    $roots = @(
        (Join-Path $env:USERPROFILE 'Dev\Work')
        (Join-Path $env:USERPROFILE 'Dev\Personal')
    )

    $dirs = foreach ($r in $roots) {
        if (Test-Path $r) {
            Get-ChildItem -Path $r -Directory | Select-Object -ExpandProperty FullName
        }
    }

    if (-not $dirs) {
        Write-Host "No project directories found."
        return
    }

    $pick = ($dirs | Split-Path -Leaf | fzf --prompt="project> " --height=40%)
    if (-not $pick) { return }
    $pick = $pick.Trim()

    $parent = $roots | Where-Object { (Join-Path $_ $pick) -in $dirs } | Select-Object -First 1
    $dir = Join-Path $parent $pick
    $session = psmux-session-name $dir

    $wasInside = $env:PSMUX_SESSION
    if ($wasInside) { Remove-Item Env:\PSMUX_SESSION -ErrorAction SilentlyContinue }

    $create = psmux new-session -ds $session -c $dir 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host ("psmux: " + (($create -join ' ').Trim())) -ForegroundColor Yellow
    }

    if ($wasInside) {
        $env:PSMUX_SESSION = $wasInside
        psmux switch-client -t $session
    } elseif ($env:TMUX) {
        psmux switch-client -t $session
    } else {
        psmux attach -t $session
    }
}

# Ctrl+F -> psmux project picker
Set-PSReadLineKeyHandler -Chord Ctrl+f -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("psmux-project")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# Auto-start psmux server on startup
psmux server-info *> $null
if ($LASTEXITCODE -ne 0) {
    psmux new-session -ds default
}

#endregion psmux integration
