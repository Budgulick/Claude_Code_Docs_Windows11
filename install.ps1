#Requires -Version 5.1
<#
.SYNOPSIS
    Claude Code Docs Installer v0.3.3 for Windows
.DESCRIPTION
    Installs/migrates claude-code-docs to %USERPROFILE%\.claude-code-docs
    Provides the /docs command for Claude Code on Windows
.NOTES
    Requires: Git for Windows, PowerShell 5.1+
#>

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Script configuration
$SCRIPT_VERSION = "0.3.3"
$INSTALL_DIR = Join-Path $env:USERPROFILE ".claude-code-docs"
$INSTALL_BRANCH = "main"
$REPO_URL = "https://github.com/ericbuess/claude-code-docs.git"

# Display banner
Write-Host "Claude Code Docs Installer v$SCRIPT_VERSION (Windows)" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Detect Windows version
$osInfo = [System.Environment]::OSVersion
Write-Host "[OK] Detected Windows $($osInfo.Version.Major).$($osInfo.Version.Minor)" -ForegroundColor Green

# Check dependencies
Write-Host "Checking dependencies..."

# Check Git
$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
    Write-Host "[ERROR] git is required but not installed" -ForegroundColor Red
    Write-Host "Please install Git for Windows from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}
Write-Host "  [OK] git found at: $($gitCmd.Source)" -ForegroundColor Green

# Check PowerShell version (already enforced by #Requires, but show info)
Write-Host "  [OK] PowerShell $($PSVersionTable.PSVersion)" -ForegroundColor Green

Write-Host "[OK] All dependencies satisfied" -ForegroundColor Green

#region Functions

function Find-ExistingInstallations {
    <#
    .SYNOPSIS
        Find existing claude-code-docs installations from config files
    #>
    $paths = @()

    $commandFile = Join-Path $env:USERPROFILE ".claude\commands\docs.md"
    $settingsFile = Join-Path $env:USERPROFILE ".claude\settings.json"

    # Check command file for paths
    if (Test-Path $commandFile) {
        $content = Get-Content $commandFile -ErrorAction SilentlyContinue
        foreach ($line in $content) {
            # v0.1 format: LOCAL DOCS AT: /path/to/claude-code-docs/docs/
            if ($line -match 'LOCAL\s+DOCS\s+AT:\s+([^\s]+)/docs/') {
                $path = $Matches[1]
                $path = $path -replace '^~', $env:USERPROFILE
                $path = [Environment]::ExpandEnvironmentVariables($path)
                if (Test-Path $path) {
                    $paths += $path
                }
            }

            # v0.2+ format: Execute: /path/to/claude-code-docs/helper.sh or .ps1
            if ($line -match 'Execute:.*claude-code-docs') {
                # Extract path from various formats
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
                        if (Test-Path $dirPath -PathType Container) {
                            $paths += $dirPath
                        }
                    }
                }
            }
        }
    }

    # Check settings.json hooks for paths
    if (Test-Path $settingsFile) {
        try {
            $settings = Get-Content $settingsFile -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
            if ($settings.hooks.PreToolUse) {
                foreach ($hook in $settings.hooks.PreToolUse) {
                    $cmd = $hook.hooks[0].command
                    if ($cmd -match 'claude-code-docs') {
                        # Extract path patterns
                        if ($cmd -match '([^\s"]+claude-code-docs[^\s"]*)') {
                            $path = $Matches[1]
                            $path = $path -replace '^~', $env:USERPROFILE
                            $path = $path -replace '%USERPROFILE%', $env:USERPROFILE
                            $path = [Environment]::ExpandEnvironmentVariables($path)

                            # Get directory part
                            if ($path -match '(.+[/\\]claude-code-docs)([/\\].*)?$') {
                                $dirPath = $Matches[1]
                                # Normalize path separators
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

    # Also check current directory if running from an installation
    $manifestPath = Join-Path (Get-Location) "docs\docs_manifest.json"
    if ((Test-Path $manifestPath) -and ((Get-Location).Path -ne $INSTALL_DIR)) {
        $paths += (Get-Location).Path
    }

    # Deduplicate and exclude new location
    $uniquePaths = $paths | Select-Object -Unique | Where-Object {
        $_ -and ($_ -ne $INSTALL_DIR) -and ($_ -ne $INSTALL_DIR.Replace('\', '/'))
    }

    return $uniquePaths
}

function Invoke-MigrateInstallation {
    <#
    .SYNOPSIS
        Migrate from an old installation location
    #>
    param([string]$OldDir)

    Write-Host ""
    Write-Host "[MIGRATE] Found existing installation at: $OldDir" -ForegroundColor Yellow
    Write-Host "          Migrating to: $INSTALL_DIR" -ForegroundColor Yellow
    Write-Host ""

    # Check if old dir has uncommitted changes
    $shouldPreserve = $false
    $gitDir = Join-Path $OldDir ".git"
    if (Test-Path $gitDir) {
        Push-Location $OldDir
        try {
            $status = git status --porcelain 2>$null
            if ($status) {
                $shouldPreserve = $true
                Write-Host "[WARN] Uncommitted changes detected in old installation" -ForegroundColor Yellow
            }
        } finally {
            Pop-Location
        }
    }

    # Fresh install at new location
    Write-Host "Installing fresh at $INSTALL_DIR..."
    git clone -b $INSTALL_BRANCH $REPO_URL $INSTALL_DIR
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to clone repository" -ForegroundColor Red
        exit 1
    }

    # Remove old directory if safe
    if (-not $shouldPreserve) {
        Write-Host "Removing old installation..."
        Remove-Item -Path $OldDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[OK] Old installation removed" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "[INFO] Old installation preserved at: $OldDir" -ForegroundColor Cyan
        Write-Host "       (has uncommitted changes)"
    }

    Write-Host ""
    Write-Host "[OK] Migration complete!" -ForegroundColor Green
}

function Update-SafeGitRepository {
    <#
    .SYNOPSIS
        Safely update git repository with conflict resolution
    #>
    param([string]$RepoDir)

    Push-Location $RepoDir
    try {
        # Get current branch
        $currentBranch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -ne 0 -or -not $currentBranch) {
            $currentBranch = "unknown"
        }

        $targetBranch = $INSTALL_BRANCH

        # Determine message
        if ($currentBranch -ne $targetBranch) {
            Write-Host "  Switching from $currentBranch to $targetBranch branch..."
        } else {
            Write-Host "  Updating $targetBranch branch..."
        }

        # Set git config for pull strategy if not set
        $pullRebase = git config pull.rebase 2>$null
        if ($LASTEXITCODE -ne 0) {
            git config pull.rebase false 2>$null
        }

        Write-Host "Updating to latest version..."

        # Try regular pull first
        git pull --quiet origin $targetBranch 2>$null
        if ($LASTEXITCODE -eq 0) {
            return $true
        }

        # If pull failed, try more aggressive approach
        Write-Host "  Standard update failed, trying harder..."

        # Fetch latest
        git fetch origin $targetBranch 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  [WARN] Could not fetch from GitHub (offline?)" -ForegroundColor Yellow
            return $false
        }

        # Determine if we need user confirmation
        $needsUserConfirmation = $false

        if ($currentBranch -ne $targetBranch) {
            Write-Host "  Branch switch detected, forcing clean state..."
        } else {
            # Check for changes (excluding docs_manifest.json which is expected)
            $statusOutput = git status --porcelain 2>$null

            # Check for conflicts
            $conflicts = $statusOutput | Select-String -Pattern '^(UU|AA|DD)' |
                        Where-Object { $_ -notmatch 'docs_manifest.json' }

            # Check for other changes
            $changes = $statusOutput | Where-Object { $_ -notmatch 'docs_manifest.json' }

            # Check for untracked files
            $untracked = $statusOutput | Select-String -Pattern '^\?\?' |
                        Where-Object { $_ -notmatch '\.(tmp|log|swp)$' }

            if ($conflicts -or $changes -or $untracked) {
                $needsUserConfirmation = $true
                Write-Host ""
                Write-Host "[WARN] WARNING: Local changes detected in your installation:" -ForegroundColor Yellow
                if ($conflicts) {
                    Write-Host "  - Merge conflicts need resolution" -ForegroundColor Yellow
                }
                if ($changes) {
                    Write-Host "  - Modified files (other than docs_manifest.json)" -ForegroundColor Yellow
                }
                if ($untracked) {
                    Write-Host "  - Untracked files" -ForegroundColor Yellow
                }
                Write-Host ""
                Write-Host "The installer will reset to a clean state, discarding these changes."
                Write-Host "Note: Changes to docs_manifest.json are handled automatically."
                Write-Host ""

                $response = Read-Host "Continue and discard local changes? [y/N]"
                if ($response -notmatch '^[Yy]$') {
                    Write-Host "Installation cancelled. Your local changes are preserved."
                    Write-Host "To proceed later, either:"
                    Write-Host "  1. Manually resolve the issues, or"
                    Write-Host "  2. Run the installer again and choose 'y' to discard changes"
                    return $false
                }
                Write-Host "  Proceeding with clean installation..."
            } else {
                # Check for manifest-only changes
                $manifestChanges = $statusOutput | Select-String -Pattern 'docs_manifest.json'
                if ($manifestChanges) {
                    $isConflict = $manifestChanges | Select-String -Pattern '^UU'
                    if ($isConflict) {
                        Write-Host "  Resolving manifest file conflicts automatically..."
                    } else {
                        Write-Host "  Handling manifest file updates automatically..."
                    }
                }
            }
        }

        # Force clean state
        if ($needsUserConfirmation) {
            Write-Host "  Forcing clean update (discarding local changes)..."
        } else {
            Write-Host "  Updating to clean state..."
        }

        # Abort any in-progress merge/rebase
        git merge --abort 2>$null
        git rebase --abort 2>$null

        # Clear any stale index
        git reset 2>$null

        # Force checkout target branch
        git checkout -B $targetBranch "origin/$targetBranch" 2>$null

        # Reset to clean state
        git reset --hard "origin/$targetBranch" 2>$null

        # Clean untracked files
        git clean -fd 2>$null

        Write-Host "  [OK] Updated successfully to clean state" -ForegroundColor Green

        return $true

    } finally {
        Pop-Location
    }
}

function Remove-OldInstallations {
    <#
    .SYNOPSIS
        Clean up old installations
    #>
    param([array]$OldInstallations)

    if (-not $OldInstallations -or $OldInstallations.Count -eq 0) {
        return
    }

    Write-Host ""
    Write-Host "Cleaning up old installations..."
    Write-Host "Found $($OldInstallations.Count) old installation(s) to remove:"

    foreach ($oldDir in $OldInstallations) {
        if (-not $oldDir) { continue }

        Write-Host "  - $oldDir"

        $gitDir = Join-Path $oldDir ".git"
        if (Test-Path $gitDir) {
            Push-Location $oldDir
            try {
                $status = git status --porcelain 2>$null
                if (-not $status) {
                    Pop-Location
                    Remove-Item -Path $oldDir -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "    [OK] Removed (clean)" -ForegroundColor Green
                } else {
                    Write-Host "    [WARN] Preserved (has uncommitted changes)" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "    [WARN] Preserved (error checking status)" -ForegroundColor Yellow
            } finally {
                if ((Get-Location).Path -eq $oldDir) {
                    Pop-Location
                }
            }
        } else {
            Write-Host "    [WARN] Preserved (not a git repo)" -ForegroundColor Yellow
        }
    }
}

function Update-ClaudeSettings {
    <#
    .SYNOPSIS
        Update Claude settings.json with the PreToolUse hook
    #>
    param([string]$HookCommand)

    $settingsPath = Join-Path $env:USERPROFILE ".claude\settings.json"
    $claudeDir = Join-Path $env:USERPROFILE ".claude"

    # Ensure directory exists
    if (-not (Test-Path $claudeDir)) {
        New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    }

    if (Test-Path $settingsPath) {
        Write-Host "  Updating Claude settings..."

        try {
            # Load existing settings
            $settingsContent = Get-Content $settingsPath -Raw -Encoding UTF8
            $settings = $settingsContent | ConvertFrom-Json

            # Ensure hooks structure exists
            if (-not $settings.hooks) {
                $settings | Add-Member -NotePropertyName "hooks" -NotePropertyValue ([PSCustomObject]@{}) -Force
            }
            if (-not $settings.hooks.PreToolUse) {
                $settings.hooks | Add-Member -NotePropertyName "PreToolUse" -NotePropertyValue @() -Force
            }

            # Remove old claude-code-docs hooks
            $filteredHooks = @($settings.hooks.PreToolUse | Where-Object {
                -not ($_.hooks[0].command -match 'claude-code-docs')
            })

            # Add new hook
            $newHook = [PSCustomObject]@{
                matcher = "Read"
                hooks = @(
                    [PSCustomObject]@{
                        type = "command"
                        command = $HookCommand
                    }
                )
            }

            $filteredHooks += $newHook
            $settings.hooks.PreToolUse = $filteredHooks

            # Save settings - CRITICAL: Use Depth 10 to avoid truncation
            $settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding UTF8 -NoNewline

            Write-Host "[OK] Updated Claude settings" -ForegroundColor Green

        } catch {
            Write-Host "[WARN] Failed to parse existing settings, creating new..." -ForegroundColor Yellow
            # Fall through to create new
            Remove-Item $settingsPath -Force -ErrorAction SilentlyContinue
        }
    }

    if (-not (Test-Path $settingsPath)) {
        Write-Host "  Creating Claude settings..."

        $settings = [PSCustomObject]@{
            hooks = [PSCustomObject]@{
                PreToolUse = @(
                    [PSCustomObject]@{
                        matcher = "Read"
                        hooks = @(
                            [PSCustomObject]@{
                                type = "command"
                                command = $HookCommand
                            }
                        )
                    }
                )
            }
        }

        # CRITICAL: Use Depth 10 to avoid truncation
        $settings | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding UTF8 -NoNewline

        Write-Host "[OK] Created Claude settings" -ForegroundColor Green
    }
}

function New-DocsCommand {
    <#
    .SYNOPSIS
        Create the /docs slash command file
    #>
    $commandPath = Join-Path $env:USERPROFILE ".claude\commands\docs.md"
    $commandDir = Split-Path -Parent $commandPath

    # Ensure directory exists
    if (-not (Test-Path $commandDir)) {
        New-Item -ItemType Directory -Path $commandDir -Force | Out-Null
    }

    if (Test-Path $commandPath) {
        Write-Host "  Updating existing command..."
    }

    # Create command file content
    $commandContent = @'
Execute the Claude Code Docs helper script at %USERPROFILE%\.claude-code-docs\claude-docs-helper.ps1

Usage:
- /docs - List all available documentation topics
- /docs <topic> - Read specific documentation with link to official docs
- /docs -t - Check sync status without reading a doc
- /docs -t <topic> - Check freshness then read documentation
- /docs whats new - Show recent documentation changes (or "what's new")

Examples of expected output:

When reading a doc:
COMMUNITY MIRROR: https://github.com/ericbuess/claude-code-docs
OFFICIAL DOCS: https://docs.anthropic.com/en/docs/claude-code

[Doc content here...]

Official page: https://docs.anthropic.com/en/docs/claude-code/hooks

When showing what's new:
Recent documentation updates:

- 5 hours ago:
  https://github.com/ericbuess/claude-code-docs/commit/eacd8e1
  data-usage: https://docs.anthropic.com/en/docs/claude-code/data-usage
     Added: Privacy safeguards
  security: https://docs.anthropic.com/en/docs/claude-code/security
     Data flow and dependencies section moved here

Full changelog: https://github.com/ericbuess/claude-code-docs/commits/main/docs
COMMUNITY MIRROR - NOT AFFILIATED WITH ANTHROPIC

Every request checks for the latest documentation from GitHub (takes ~0.4s).
The helper script handles all functionality including auto-updates.

Execute: powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude-code-docs\claude-docs-helper.ps1" $ARGUMENTS
'@

    $commandContent | Set-Content -Path $commandPath -Encoding UTF8

    Write-Host "[OK] Created /docs command" -ForegroundColor Green
}

#endregion Functions

#region Main Installation Logic

Write-Host ""

# Find old installations first (before any config changes)
Write-Host "Checking for existing installations..."
$existingInstalls = @(Find-ExistingInstallations)

# Store for later cleanup
$script:OLD_INSTALLATIONS = @()
if ($existingInstalls.Count -gt 0) {
    $script:OLD_INSTALLATIONS = $existingInstalls
    Write-Host "Found $($existingInstalls.Count) existing installation(s):"
    foreach ($install in $existingInstalls) {
        Write-Host "  - $install"
    }
    Write-Host ""
}

# Check if already installed at target location
$manifestPath = Join-Path $INSTALL_DIR "docs\docs_manifest.json"
if ((Test-Path $INSTALL_DIR) -and (Test-Path $manifestPath)) {
    Write-Host "[OK] Found installation at $INSTALL_DIR" -ForegroundColor Green
    Write-Host "  Updating to latest version..."

    # Update it safely
    $updateResult = Update-SafeGitRepository -RepoDir $INSTALL_DIR
    if (-not $updateResult) {
        Write-Host "[ERROR] Update failed" -ForegroundColor Red
        exit 1
    }
} else {
    # Need to install at new location
    if ($existingInstalls.Count -gt 0) {
        # Migrate from old location
        Invoke-MigrateInstallation -OldDir $existingInstalls[0]
    } else {
        # Fresh installation
        Write-Host "No existing installation found"
        Write-Host "Installing fresh to $INSTALL_DIR..."

        git clone -b $INSTALL_BRANCH $REPO_URL $INSTALL_DIR
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[ERROR] Failed to clone repository" -ForegroundColor Red
            exit 1
        }
    }
}

# Set up the helper script
Write-Host ""
Write-Host "Setting up Claude Code Docs v$SCRIPT_VERSION..."

# Copy helper script from template
Write-Host "Installing helper script..."
$templatePath = Join-Path $INSTALL_DIR "scripts\claude-docs-helper.ps1.template"
$helperPath = Join-Path $INSTALL_DIR "claude-docs-helper.ps1"

if (Test-Path $templatePath) {
    Copy-Item -Path $templatePath -Destination $helperPath -Force
    Write-Host "[OK] Helper script installed" -ForegroundColor Green
} else {
    Write-Host "  [WARN] Template file missing, attempting recovery..." -ForegroundColor Yellow
    # Try to fetch the template file directly
    $templateUrl = "https://raw.githubusercontent.com/ericbuess/claude-code-docs/$INSTALL_BRANCH/scripts/claude-docs-helper.ps1.template"
    try {
        Invoke-WebRequest -Uri $templateUrl -OutFile $helperPath -UseBasicParsing
        Write-Host "  [OK] Helper script downloaded directly" -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Failed to install helper script" -ForegroundColor Red
        Write-Host "  Please check your installation and try again"
        exit 1
    }
}

# Create /docs command
Write-Host "Setting up /docs command..."
New-DocsCommand

# Set up automatic updates hook
Write-Host "Setting up automatic updates..."
$hookCommand = 'powershell -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude-code-docs\claude-docs-helper.ps1" hook-check'
Update-ClaudeSettings -HookCommand $hookCommand

# Clean up old installations
Remove-OldInstallations -OldInstallations $script:OLD_INSTALLATIONS

# Success message
Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "[OK] Claude Code Docs v$SCRIPT_VERSION installed successfully!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Command: /docs (user)" -ForegroundColor Cyan
Write-Host "Location: $INSTALL_DIR" -ForegroundColor Cyan
Write-Host ""
Write-Host "Usage examples:"
Write-Host "  /docs hooks         # Read hooks documentation"
Write-Host "  /docs -t           # Check when docs were last updated"
Write-Host "  /docs what's new   # See recent documentation changes"
Write-Host ""
Write-Host "Auto-updates: Enabled - syncs automatically when GitHub has newer content" -ForegroundColor Green
Write-Host ""
Write-Host "Available topics:"

# List available topics
$docsDir = Join-Path $INSTALL_DIR "docs"
if (Test-Path $docsDir) {
    $topics = Get-ChildItem -Path $docsDir -Filter "*.md" |
              ForEach-Object { $_.BaseName } |
              Sort-Object

    # Display in columns (approximate)
    $columnWidth = 20
    $columns = 3
    $count = 0
    $line = ""
    foreach ($topic in $topics) {
        $line += $topic.PadRight($columnWidth)
        $count++
        if ($count -ge $columns) {
            Write-Host "  $line"
            $line = ""
            $count = 0
        }
    }
    if ($line) {
        Write-Host "  $line"
    }
}

Write-Host ""
Write-Host "[NOTE] Restart Claude Code for auto-updates to take effect" -ForegroundColor Yellow

#endregion Main Installation Logic
