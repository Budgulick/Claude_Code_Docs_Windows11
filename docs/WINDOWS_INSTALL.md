# Windows Installation Guide

This guide covers installing and troubleshooting Claude Code Documentation Mirror on Windows.

## Prerequisites

### 1. Git for Windows

Git for Windows is required for cloning and updating the documentation repository.

**Installation:**
1. Download from https://git-scm.com/download/win
2. Run the installer
3. Use default settings (or customize as needed)
4. Ensure "Git from the command line" option is selected

**Verify installation:**
```powershell
git --version
```

### 2. PowerShell 5.1+

PowerShell 5.1 is included in Windows 10 and later. No additional installation needed.

**Check your version:**
```powershell
$PSVersionTable.PSVersion
```

You should see version 5.1 or higher. PowerShell 7+ also works.

### 3. Claude Code

Obviously, you need Claude Code installed. The `/docs` command integrates with Claude Code.

## Installation

### Quick Install

Run this command in PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/Budgulick/Claude_Code_Docs_Windows11/main/install.ps1 | iex
```

### Alternative: Download and Run

If the quick install doesn't work (corporate firewalls, etc.):

```powershell
# Download the installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Budgulick/Claude_Code_Docs_Windows11/main/install.ps1" -OutFile install.ps1

# Run it
.\install.ps1

# Clean up
Remove-Item install.ps1
```

### What Gets Installed

The installer creates:

1. **Installation directory:** `%USERPROFILE%\.claude-code-docs\`
   - Contains the documentation repository
   - Contains the helper script (`claude-docs-helper.ps1`)

2. **Command file:** `%USERPROFILE%\.claude\commands\docs.md`
   - Defines the `/docs` slash command for Claude Code

3. **Settings hook:** `%USERPROFILE%\.claude\settings.json`
   - Adds a PreToolUse hook for automatic updates

## Usage

After installation, restart Claude Code to load the new command.

### Basic Usage

```
/docs                  # List all available topics
/docs hooks            # Read hooks documentation
/docs mcp              # Read MCP documentation
/docs changelog        # Read Claude Code changelog
```

### Check for Updates

```
/docs -t               # Check sync status with GitHub
/docs -t hooks         # Check status, then read hooks
```

### See What's New

```
/docs what's new       # Show recent documentation changes
```

### Uninstall

```
/docs uninstall        # Show uninstall instructions
```

## Troubleshooting

### "git is not recognized"

**Cause:** Git for Windows is not installed or not in PATH.

**Solution:**
1. Install Git for Windows from https://git-scm.com/download/win
2. During installation, ensure "Git from the command line" is selected
3. Restart PowerShell after installation

### Execution Policy Error

**Cause:** PowerShell's execution policy is blocking scripts.

**Solution 1:** The installer automatically uses `-ExecutionPolicy Bypass`. If this fails:

**Solution 2:** Change execution policy for current user:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Solution 3:** Run installer with explicit bypass:
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

### "/docs command not found"

**Cause:** Claude Code hasn't loaded the new command.

**Solution:**
1. Restart Claude Code
2. Check command file exists:
   ```powershell
   Test-Path "$env:USERPROFILE\.claude\commands\docs.md"
   ```
3. If file doesn't exist, re-run installer

### "Could not sync with GitHub"

**Cause:** Network connectivity issue or firewall blocking GitHub.

**Solution:**
1. Check internet connection
2. Try accessing https://github.com in browser
3. If behind corporate firewall, may need proxy configuration
4. The tool will use cached documentation if sync fails

### Documentation Not Updating

**Cause:** Git pull may be failing silently.

**Solution:**
1. Check sync status: `/docs -t`
2. Manual update:
   ```powershell
   cd "$env:USERPROFILE\.claude-code-docs"
   git pull
   ```
3. Check for local changes blocking pull:
   ```powershell
   cd "$env:USERPROFILE\.claude-code-docs"
   git status
   ```

### Settings.json Corrupted

**Cause:** JSON parsing error, possibly from manual editing.

**Solution:**
1. Backup exists at `%USERPROFILE%\.claude\settings.json.backup`
2. Restore it:
   ```powershell
   Copy-Item "$env:USERPROFILE\.claude\settings.json.backup" "$env:USERPROFILE\.claude\settings.json"
   ```
3. Re-run installer

### Installation Path Issues

**Cause:** Special characters or spaces in Windows username.

**Solution:** The installer uses `$env:USERPROFILE` which handles this automatically. If issues persist:
1. Check path resolves correctly:
   ```powershell
   $env:USERPROFILE
   ```
2. Ensure no permission issues on the path

## Manual Installation

If the automated installer doesn't work, you can install manually:

### 1. Clone Repository

```powershell
git clone https://github.com/ericbuess/claude-code-docs.git "$env:USERPROFILE\.claude-code-docs"
```

### 2. Copy Helper Script

```powershell
Copy-Item "$env:USERPROFILE\.claude-code-docs\scripts\claude-docs-helper.ps1.template" "$env:USERPROFILE\.claude-code-docs\claude-docs-helper.ps1"
```

### 3. Create Command File

Create `%USERPROFILE%\.claude\commands\docs.md` with this content:

```markdown
Execute the Claude Code Docs helper script at %USERPROFILE%\.claude-code-docs\claude-docs-helper.ps1

Usage:
- /docs - List all available documentation topics
- /docs <topic> - Read specific documentation
- /docs -t - Check sync status
- /docs what's new - Show recent changes

Execute: powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\.claude-code-docs\claude-docs-helper.ps1" $ARGUMENTS
```

### 4. Add Hook to Settings (Optional)

Edit `%USERPROFILE%\.claude\settings.json` to add automatic updates. See the installer source for the exact JSON structure.

## Uninstallation

### Automated Uninstall

```powershell
& "$env:USERPROFILE\.claude-code-docs\uninstall.ps1"
```

### Manual Uninstall

1. **Remove command file:**
   ```powershell
   Remove-Item "$env:USERPROFILE\.claude\commands\docs.md"
   ```

2. **Remove installation directory:**
   ```powershell
   Remove-Item -Recurse "$env:USERPROFILE\.claude-code-docs"
   ```

3. **Edit settings.json** to remove the claude-code-docs hook (or restore from backup)

## Differences from macOS/Linux

| Feature | macOS/Linux | Windows |
|---------|-------------|---------|
| Shell | Bash | PowerShell |
| Home directory | `~` | `%USERPROFILE%` |
| JSON processing | jq | PowerShell native |
| Path separator | `/` | `\` |
| File permissions | chmod | N/A |
| Script extension | .sh | .ps1 |

The functionality is identical - only the implementation differs.

## Getting Help

- **GitHub Issues:** https://github.com/ericbuess/claude-code-docs/issues
- **Main README:** [README.md](../README.md)
- **Uninstall Guide:** [UNINSTALL.md](../UNINSTALL.md)
