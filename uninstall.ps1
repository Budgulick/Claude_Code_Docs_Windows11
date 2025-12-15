#Requires -Version 5.1
<#
.SYNOPSIS
    Claude Code Docs Uninstaller v0.3.3 for Windows
.DESCRIPTION
    Removes claude-code-docs installation including command, hooks, and directory
.NOTES
    Requires: PowerShell 5.1+
#>

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Display banner
Write-Host "Claude Code Documentation Mirror - Uninstaller (Windows)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

#region Functions

function Find-AllInstallations {
    <#
    .SYNOPSIS
        Find all claude-code-docs installations from config files
    #>
    $paths = @()

    $commandFile = Join-Path $env:USERPROFILE ".claude\commands\docs.md"
    $settingsFile = Join-Path $env:USERPROFILE ".claude\settings.json"

    # From command file
    if (Test-Path $commandFile) {
        $content = Get-Content $commandFile -ErrorAction SilentlyContinue
        foreach ($line in $content) {
            if ($line -match 'Execute:.*claude-code-docs') {
                if ($line -match '([^\s"]+claude-code-docs[^\s"]*)') {
                    $path = $Matches[1]
                    $path = $path -replace '^~', $env:USERPROFILE
                    $path = $path -replace '%USERPROFILE%', $env:USERPROFILE
                    $path = [Environment]::ExpandEnvironmentVariables($path)

                    # Get directory part
                    if (Test-Path $path -PathType Container) {
                        $paths += $path
                    } elseif ($path -match '(.+[/\\]claude-code-docs)([/\\].*)?$') {
                        $dirPath = $Matches[1]
                        $dirPath = $dirPath -replace '/', '\'
                        if (Test-Path $dirPath -PathType Container) {
                            $paths += $dirPath
                        }
                    }
                }
            }
        }
    }

    # From hooks in settings.json
    if (Test-Path $settingsFile) {
        try {
            $settings = Get-Content $settingsFile -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
            if ($settings.hooks.PreToolUse) {
                foreach ($hook in $settings.hooks.PreToolUse) {
                    $cmd = $hook.hooks[0].command
                    if ($cmd -match 'claude-code-docs') {
                        if ($cmd -match '([^\s"]+claude-code-docs[^\s"]*)') {
                            $path = $Matches[1]
                            $path = $path -replace '^~', $env:USERPROFILE
                            $path = $path -replace '%USERPROFILE%', $env:USERPROFILE
                            $path = [Environment]::ExpandEnvironmentVariables($path)

                            # Get directory part
                            if ($path -match '(.+[/\\]claude-code-docs)([/\\].*)?$') {
                                $dirPath = $Matches[1]
                                $dirPath = $dirPath -replace '/', '\'
                                if (Test-Path $dirPath -PathType Container) {
                                    $paths += $dirPath
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            # Ignore JSON parse errors
        }
    }

    # Also check default location
    $defaultPath = Join-Path $env:USERPROFILE ".claude-code-docs"
    if (Test-Path $defaultPath -PathType Container) {
        $paths += $defaultPath
    }

    # Deduplicate
    return $paths | Select-Object -Unique
}

function Remove-ClaudeHooks {
    <#
    .SYNOPSIS
        Remove claude-code-docs hooks from settings.json
    #>
    $settingsPath = Join-Path $env:USERPROFILE ".claude\settings.json"

    if (-not (Test-Path $settingsPath)) {
        return
    }

    # Create backup
    $backupPath = "$settingsPath.backup"
    Copy-Item $settingsPath $backupPath -Force

    try {
        $settingsContent = Get-Content $settingsPath -Raw -Encoding UTF8
        $settings = $settingsContent | ConvertFrom-Json

        if ($settings.hooks.PreToolUse) {
            # Filter out claude-code-docs hooks
            $filteredHooks = @($settings.hooks.PreToolUse | Where-Object {
                -not ($_.hooks[0].command -match 'claude-code-docs')
            })

            $settings.hooks.PreToolUse = $filteredHooks

            # Clean up empty structures
            if ($settings.hooks.PreToolUse.Count -eq 0) {
                # Remove PreToolUse property if empty
                $settings.hooks.PSObject.Properties.Remove('PreToolUse')

                # Check if hooks object is now empty
                $remainingProps = $settings.hooks.PSObject.Properties | Where-Object { $_.Name }
                if (-not $remainingProps -or $remainingProps.Count -eq 0) {
                    # Remove entire hooks property
                    $settings.PSObject.Properties.Remove('hooks')
                }
            }

            # Save cleaned settings - CRITICAL: Use Depth 10
            $settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding UTF8 -NoNewline
        }

        Write-Host "[OK] Removed hooks (backup: $backupPath)" -ForegroundColor Green

    } catch {
        Write-Host "[ERROR] Failed to update settings: $_" -ForegroundColor Red
        Write-Host "        Backup preserved at: $backupPath" -ForegroundColor Yellow
    }
}

function Remove-InstallationDirectories {
    <#
    .SYNOPSIS
        Remove installation directories (only if clean git repos)
    #>
    param([array]$Installations)

    if (-not $Installations -or $Installations.Count -eq 0) {
        return
    }

    Write-Host ""

    foreach ($path in $Installations) {
        if (-not (Test-Path $path -PathType Container)) {
            continue
        }

        $gitDir = Join-Path $path ".git"
        if (Test-Path $gitDir) {
            Push-Location $path
            try {
                $status = git status --porcelain 2>$null
                if (-not $status) {
                    Pop-Location
                    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "[OK] Removed $path (clean git repo)" -ForegroundColor Green
                } else {
                    Write-Host "[WARN] Preserved $path (has uncommitted changes)" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "[WARN] Preserved $path (error checking status)" -ForegroundColor Yellow
            } finally {
                if ((Get-Location).Path -eq $path) {
                    Pop-Location
                }
            }
        } else {
            Write-Host "[WARN] Preserved $path (not a git repo)" -ForegroundColor Yellow
        }
    }
}

#endregion Functions

#region Main Uninstall Logic

# Find all installations
$installations = @(Find-AllInstallations)

if ($installations.Count -gt 0) {
    Write-Host "Found installations at:"
    foreach ($path in $installations) {
        Write-Host "  [DIR] $path" -ForegroundColor Cyan
    }
    Write-Host ""
}

# Show what will be removed
Write-Host "This will remove:"
$commandFile = Join-Path $env:USERPROFILE ".claude\commands\docs.md"
$settingsFile = Join-Path $env:USERPROFILE ".claude\settings.json"

Write-Host "  - The /docs command from $commandFile"
Write-Host "  - All claude-code-docs hooks from $settingsFile"
if ($installations.Count -gt 0) {
    Write-Host "  - Installation directories (if safe to remove)"
}
Write-Host ""

# Confirmation prompt
$response = Read-Host "Continue? (y/N)"
if ($response -notmatch '^[Yy]$') {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# Remove command file
if (Test-Path $commandFile) {
    Remove-Item -Path $commandFile -Force -ErrorAction SilentlyContinue
    Write-Host "[OK] Removed /docs command" -ForegroundColor Green
}

# Remove hooks from settings.json
if (Test-Path $settingsFile) {
    Remove-ClaudeHooks
}

# Remove installation directories
Remove-InstallationDirectories -Installations $installations

# Success message
Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "[OK] Uninstall complete!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "To reinstall:"
Write-Host "  iwr -useb https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.ps1 | iex" -ForegroundColor Cyan

#endregion Main Uninstall Logic
