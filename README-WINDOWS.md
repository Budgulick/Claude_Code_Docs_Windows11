# Claude Code Documentation Mirror - Windows Installation Guide

Welcome Windows users! This guide will help you install Claude Code Documentation Mirror on Windows 10, 11, or Windows Server.

## Quick Start

### Easiest Method: Batch File

1. Download the installer:
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.bat" -OutFile install.bat
   ```

2. Double-click `install.bat` to run

3. Restart Claude Code

4. Use the `/docs` command!

That's it! The batch file handles everything automatically.

## Prerequisites

Before installing, ensure you have:

### Required
- **Windows 10 or later** (or Windows Server 2016+)
- **PowerShell 5.1+** (included in Windows 10+)
- **Git for Windows** - Download from https://git-scm.com/download/win
- **Claude Code** - The tool this integrates with

### How to Check Your PowerShell Version

Open PowerShell and run:
```powershell
$PSVersionTable.PSVersion
```

You should see version 5.1 or higher.

### Installing Git for Windows

If you don't have Git installed:

1. Download from https://git-scm.com/download/win
2. Run the installer
3. Use default settings (or customize as needed)
4. **Important:** Ensure "Git from the command line" is selected
5. Restart PowerShell after installation

## Installation Methods

### Method 1: Batch File (Recommended for Most Users)

**Best for:** Users who want the simplest installation experience

Download and run:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.bat" -OutFile install.bat
.\install.bat
```

Or just double-click the downloaded `install.bat` file.

**Why this is recommended:**
- No PowerShell execution policy issues
- Clear progress messages
- Automatic prerequisite checking
- Pause at completion so you can read results

### Method 2: PowerShell One-Liner

**Best for:** Advanced users comfortable with PowerShell

```powershell
iwr -useb https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.ps1 | iex
```

### Method 3: Download and Inspect First

**Best for:** Security-conscious users who want to review code first

```powershell
# Download the installer
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.ps1" -OutFile install.ps1

# Review the code (optional but recommended)
notepad install.ps1

# Run it
.\install.ps1
```

## What Gets Installed

The installer creates:

1. **Documentation repository** at `%USERPROFILE%\.claude-code-docs\`
   - Contains all Claude Code documentation
   - Updates automatically via git

2. **Command file** at `%USERPROFILE%\.claude\commands\docs.md`
   - Defines the `/docs` slash command

3. **Settings hook** in `%USERPROFILE%\.claude\settings.json`
   - Enables automatic updates when you read docs

**Total disk space:** Approximately 5-10 MB

## Using the /docs Command

After installation, restart Claude Code and try these commands:

### Basic Usage
```
/docs              # List all available topics
/docs hooks        # Read hooks documentation
/docs mcp          # Read MCP documentation
/docs memory       # Read memory documentation
/docs changelog    # Read Claude Code release notes
```

### Check for Updates
```
/docs -t           # Show sync status with GitHub
/docs -t hooks     # Check status, then read hooks
```

### See What's New
```
/docs what's new   # Show recent documentation changes
```

### Get Help
```
/docs uninstall    # Show uninstall instructions
```

## Troubleshooting

### "PowerShell is not recognized"

This usually means you're using Command Prompt instead of PowerShell.

**Solution:** Open PowerShell specifically:
1. Press `Win + X`
2. Select "Windows PowerShell" or "Terminal"
3. Run the installation command again

### "Execution Policy" Error

**Error message:** "...cannot be loaded because running scripts is disabled..."

**Solution:** The batch file wrapper handles this automatically. If using PowerShell directly:

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

Or change your execution policy (one-time):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "git is not recognized"

**Solution:** Git for Windows is not installed or not in PATH.

1. Install Git for Windows from https://git-scm.com/download/win
2. During installation, ensure "Git from the command line" is selected
3. Restart PowerShell
4. Try the installer again

### "/docs command not found"

**Solution:** Claude Code hasn't loaded the new command yet.

1. Completely exit Claude Code (check system tray)
2. Restart Claude Code
3. Try `/docs` again

If still not working:
```powershell
# Check if command file exists
Test-Path "$env:USERPROFILE\.claude\commands\docs.md"
```

Should return `True`. If `False`, re-run the installer.

### "Could not sync with GitHub"

**Cause:** Network/firewall issue or offline

**Solution:**
- Check internet connection
- If behind corporate firewall, you may need proxy configuration
- The tool will use cached documentation if offline

### Documentation Not Updating

**Check sync status:**
```
/docs -t
```

**Manual update:**
```powershell
cd "$env:USERPROFILE\.claude-code-docs"
git pull
```

### Settings.json Issues

If you see errors about `settings.json`:

**Check the backup:**
```powershell
Test-Path "$env:USERPROFILE\.claude\settings.json.backup"
```

**Restore from backup:**
```powershell
Copy-Item "$env:USERPROFILE\.claude\settings.json.backup" "$env:USERPROFILE\.claude\settings.json"
```

Then re-run the installer.

## Updating

To update to the latest version, just run the installer again:

**Using batch file:**
```powershell
.\install.bat
```

**Using PowerShell:**
```powershell
iwr -useb https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.ps1 | iex
```

The installer will:
- Detect your existing installation
- Update to the latest version
- Preserve your settings

## Uninstalling

### Method 1: Batch File (Easiest)

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/uninstall.bat" -OutFile uninstall.bat
.\uninstall.bat
```

### Method 2: PowerShell

```powershell
& "$env:USERPROFILE\.claude-code-docs\uninstall.ps1"
```

### Method 3: Manual Removal

1. Delete the command file:
   ```powershell
   Remove-Item "$env:USERPROFILE\.claude\commands\docs.md"
   ```

2. Delete the installation directory:
   ```powershell
   Remove-Item -Recurse "$env:USERPROFILE\.claude-code-docs"
   ```

3. Edit `%USERPROFILE%\.claude\settings.json` to remove claude-code-docs hooks

## Security Notes

### What the Installer Does

The installer:
- Clones a public repository from GitHub
- Creates files only in your user profile directory
- Modifies only `~/.claude/settings.json` (with backup)
- Does **not** require administrator privileges
- Does **not** modify system files
- Does **not** send data anywhere

### Reviewing the Code

You can review all code before installing:

- Installer: https://github.com/ericbuess/claude-code-docs/blob/main/install.ps1
- Uninstaller: https://github.com/ericbuess/claude-code-docs/blob/main/uninstall.ps1
- Helper: https://github.com/ericbuess/claude-code-docs/blob/main/scripts/claude-docs-helper.ps1.template

### Execution Policy

The batch file uses `-ExecutionPolicy Bypass` only for the installer script. This does **not** change your system's execution policy permanently.

## Advanced Topics

### Custom Installation Location

The installer uses `%USERPROFILE%\.claude-code-docs` by default. To use a different location, edit the `$INSTALL_DIR` variable in `install.ps1` before running.

### Proxy Configuration

If behind a corporate proxy:

```powershell
# Set proxy for git
git config --global http.proxy http://proxyserver:port
git config --global https.proxy https://proxyserver:port
```

### Using PowerShell 7+

The installer requires PowerShell 5.1+ but also works with PowerShell 7+. To use PowerShell 7:

```powershell
pwsh -File install.ps1
```

## Getting Help

- **GitHub Issues:** https://github.com/ericbuess/claude-code-docs/issues
- **Detailed Troubleshooting:** See `docs/WINDOWS_INSTALL.md`
- **Main README:** [README.md](README.md)

## Differences from macOS/Linux

| Feature | macOS/Linux | Windows |
|---------|-------------|---------|
| Shell | Bash | PowerShell |
| Home directory | `~` or `$HOME` | `%USERPROFILE%` |
| JSON processing | jq (external tool) | PowerShell native |
| Script extension | `.sh` | `.ps1` |
| Installation | `install.sh` | `install.ps1` or `install.bat` |
| Path separator | `/` | `\` |

**Functionality is identical** - only the implementation differs!

## What's Next?

After installation:

1. ✅ Restart Claude Code
2. ✅ Try `/docs hooks` to read documentation
3. ✅ Use `/docs -t` to check sync status
4. ✅ Explore with `/docs what's new`
5. ✅ Join the community: https://github.com/ericbuess/claude-code-docs

---

## Credits

This Windows port is based on the excellent work by:
- **[Eric Buess](https://github.com/ericbuess)** - Original claude-code-docs creator
- **[Jeremy Schaab](https://github.com/jeremy-schaab)** - Windows port contributions

**Windows Implementation**: Developed using Claude Code (Anthropic's AI coding assistant)

For detailed credits and acknowledgments, see [CREDITS.md](CREDITS.md).

**Original Project**: https://github.com/ericbuess/claude-code-docs

---

Enjoy faster access to Claude Code documentation! 🚀
