# Claude Code Documentation Mirror - Windows Fork

[![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-blue)]()
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)]()
[![Beta](https://img.shields.io/badge/status-early%20beta-orange)](https://github.com/ericbuess/claude-code-docs/issues)
[![License](https://img.shields.io/badge/license-MIT-green)]()

**Windows-focused fork** of the claude-code-docs project, optimized for Windows 10/11 with native PowerShell support.

Local mirror of Claude Code documentation files from https://docs.anthropic.com/en/docs/claude-code/, updated every 3 hours.

> **📢 Fork Notice**: This is a Windows-optimized fork of [ericbuess/claude-code-docs](https://github.com/ericbuess/claude-code-docs). For the original multi-platform version, visit the upstream repository.
>
> **🤖 Windows Port**: Implemented using Claude Code (Anthropic's AI coding assistant), demonstrating AI-assisted cross-platform development.

## ⚠️ Early Beta Notice

**This is an early beta release**. There may be errors or unexpected behavior. If you encounter any issues, please [open an issue](https://github.com/ericbuess/claude-code-docs/issues) - your feedback helps improve the tool!

## 🆕 Version 0.3.3 - Windows Support & Changelog Integration

**New in this version:**
- 🪟 **Full Windows support**: Native PowerShell installer and helper scripts
- 📋 **Claude Code Changelog**: Access the official Claude Code release notes with `/docs changelog`
- 🍎 **Full macOS compatibility**: Fixed shell compatibility issues for Mac users
- 🐧 **Linux support**: Tested on Ubuntu, Debian, and other distributions
- 🔧 **Improved installer**: Better handling of updates and edge cases

To update (macOS/Linux):
```bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.sh | bash
```

To update (Windows PowerShell):
```powershell
iwr -useb https://raw.githubusercontent.com/Budgulick/Claude_Code_Docs_Windows11/main/install.ps1 | iex
```

## Why This Exists

- **Faster access** - Reads from local files instead of fetching from web
- **Automatic updates** - Attempts to stay current with the latest documentation
- **Track changes** - See what changed in docs over time
- **Claude Code changelog** - Quick access to official release notes and version history
- **Better Claude Code integration** - Allows Claude to explore documentation more effectively

## Platform Compatibility

- ✅ **macOS**: Fully supported (tested on macOS 12+)
- ✅ **Linux**: Fully supported (Ubuntu, Debian, Fedora, etc.)
- ✅ **Windows**: Fully supported (Windows 10+, PowerShell 5.1+)

### Prerequisites

#### macOS / Linux
- **git** - For cloning and updating the repository (usually pre-installed)
- **jq** - For JSON processing (pre-installed on macOS; Linux: `apt install jq` or `yum install jq`)
- **curl** - For downloading the installation script (usually pre-installed)
- **Claude Code** - Obviously :)

#### Windows
- **Git for Windows** - Download from https://git-scm.com/download/win
- **PowerShell 5.1+** - Included in Windows 10 and later
- **Claude Code** - Obviously :)

## Installation

### macOS / Linux

Run this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.sh | bash
```

### Windows

**Option 1: Simple Batch File (Recommended)**

Download and double-click `install.bat`:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Budgulick/Claude_Code_Docs_Windows11/main/install.bat" -OutFile install.bat
```
Then double-click `install.bat` to run.

**Option 2: PowerShell One-Liner**

Run this command in PowerShell:
```powershell
iwr -useb https://raw.githubusercontent.com/Budgulick/Claude_Code_Docs_Windows11/main/install.ps1 | iex
```

**Option 3: Download and Run Manually**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Budgulick/Claude_Code_Docs_Windows11/main/install.ps1" -OutFile install.ps1
.\install.ps1
```

### What the installer does

1. Install to `~/.claude-code-docs` (macOS/Linux) or `%USERPROFILE%\.claude-code-docs` (Windows)
2. Create the `/docs` slash command
3. Set up a 'PreToolUse' 'Read' hook for automatic updates

**Note**: The command is `/docs (user)` - it will show in your command list with "(user)" after it to indicate it's a user-created command.

## Usage

The `/docs` command provides instant access to documentation with optional freshness checking.

### Default: Lightning-fast access (no checks)
```bash
/docs hooks        # Instantly read hooks documentation
/docs mcp          # Instantly read MCP documentation
/docs memory       # Instantly read memory documentation
```

You'll see: `📚 Reading from local docs (run /docs -t to check freshness)`

### Check documentation sync status with -t flag
```bash
/docs -t           # Show sync status with GitHub
/docs -t hooks     # Check sync status, then read hooks docs
/docs -t mcp       # Check sync status, then read MCP docs
```

### See what's new
```bash
/docs what's new   # Show recent documentation changes with diffs
```

### Read Claude Code changelog
```bash
/docs changelog    # Read official Claude Code release notes and version history
```

The changelog feature fetches the latest release notes directly from the official Claude Code repository, showing you what's new in each version.

### Uninstall
```bash
/docs uninstall    # Get commnd to remove claude-code-docs completely
```

### Customize command name

If you prefer a different command name (e.g., `/claude-docs` instead of `/docs`), you can easily customize it:

```bash
# Rename the command file
mv ~/.claude/commands/docs.md ~/.claude/commands/claude-docs.md

# Now use /claude-docs instead of /docs
/claude-docs hooks
/claude-docs mcp
```

You can use any name you prefer: `/cdocs`, `/claude-code-docs`, etc. The command file name determines the slash command.

### Creative usage examples
```bash
# Natural language queries work great
/docs what environment variables exist and how do I use them?
/docs explain the differences between hooks and MCP

# Check for recent changes
/docs -t what's new in the latest documentation?
/docs changelog    # Check Claude Code release notes

# Search across all docs
/docs find all mentions of authentication
/docs how do I customize Claude Code's behavior?
```

## How Updates Work

The documentation attempts to stay current:
- GitHub Actions runs periodically to fetch new documentation
- When you use `/docs`, it checks for updates
- Updates are pulled when available
- You may see "🔄 Updating documentation..." when this happens

Note: If automatic updates fail, you can always run the installer again to get the latest version.

## Updating from Previous Versions

Regardless of which version you have installed, simply run the appropriate installer:

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/ericbuess/claude-code-docs/main/install.sh | bash
```

**Windows:**
```powershell
iwr -useb https://raw.githubusercontent.com/Budgulick/Claude_Code_Docs_Windows11/main/install.ps1 | iex
```

The installer will handle migration and updates automatically.

## Troubleshooting

### Command not found
If `/docs` returns "command not found":

**macOS / Linux:**
1. Check if the command file exists: `ls ~/.claude/commands/docs.md`
2. Restart Claude Code to reload commands
3. Re-run the installation script

**Windows:**
1. Check if the command file exists: `Test-Path "$env:USERPROFILE\.claude\commands\docs.md"`
2. Restart Claude Code to reload commands
3. Re-run the installation script

### Documentation not updating
If documentation seems outdated:
1. Run `/docs -t` to check sync status and force an update
2. Manually update:
   - macOS/Linux: `cd ~/.claude-code-docs && git pull`
   - Windows: `cd "$env:USERPROFILE\.claude-code-docs"; git pull`
3. Check if GitHub Actions are running: [View Actions](https://github.com/ericbuess/claude-code-docs/actions)

### Installation errors
- **"git not found"**: Install Git (macOS/Linux: use package manager, Windows: download Git for Windows)
- **"jq not found"** (macOS/Linux only): Install jq (`brew install jq` or `apt install jq`)
- **"Failed to clone repository"**: Check your internet connection
- **"Failed to update settings.json"**: Check file permissions

### Windows-specific issues
- **Execution policy error**: The installer uses `-ExecutionPolicy Bypass` automatically. If issues persist, run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **Git not recognized**: Ensure Git for Windows is installed and added to PATH. Restart PowerShell after installation.

See [WINDOWS_INSTALL.md](docs/WINDOWS_INSTALL.md) for detailed Windows troubleshooting.

## Uninstalling

To completely remove the docs integration:

```bash
/docs uninstall
```

Or run directly:

**macOS / Linux:**
```bash
~/.claude-code-docs/uninstall.sh
```

**Windows:**
```powershell
& "$env:USERPROFILE\.claude-code-docs\uninstall.ps1"
```

See [UNINSTALL.md](UNINSTALL.md) for manual uninstall instructions.

## Security Notes

- The installer modifies `~/.claude/settings.json` to add an auto-update hook
- The hook only runs `git pull` when reading documentation files
- All operations are limited to the documentation directory
- No data is sent externally - everything is local
- **Repository Trust**: The installer clones from GitHub over HTTPS. For additional security, you can:
  - Fork the repository and install from your own fork
  - Clone manually and run the installer from the local directory
  - Review all code before installation

## What's New

### v0.3.3 (Latest)
- Added full Windows support with native PowerShell scripts
- Added Claude Code changelog integration (`/docs changelog`)
- Fixed shell compatibility for macOS users (zsh/bash)
- Improved documentation and error messages
- Added platform compatibility badges

### v0.3.2
- Fixed automatic update functionality  
- Improved handling of local repository changes
- Better error recovery during updates

## Contributing

**Contributions are welcome!** This is a community project and we'd love your help:

- 🐛 **Bug Reports**: Found something not working? [Open an issue](https://github.com/ericbuess/claude-code-docs/issues)
- 💡 **Feature Requests**: Have an idea? [Start a discussion](https://github.com/ericbuess/claude-code-docs/issues)
- 📝 **Documentation**: Help improve docs or add examples

You can also use Claude Code itself to help build features - just fork the repo and let Claude assist you!

## Known Issues

As this is an early beta, you might encounter some issues:
- Auto-updates may occasionally fail on some network configurations
- Some documentation links might not resolve correctly

If you find any issues not listed here, please [report them](https://github.com/ericbuess/claude-code-docs/issues)!

## Credits and Acknowledgments

This repository is a **Windows-focused fork** of the original claude-code-docs project.

### Original Project
- **Created by**: [Eric Buess](https://github.com/ericbuess)
- **Original Repository**: https://github.com/ericbuess/claude-code-docs
- **Contributions by**: [Jeremy Schaab](https://github.com/jeremy-schaab)

### Windows Port
- **Implemented using**: Claude Code (Anthropic's AI coding assistant)
- **Platform Focus**: Windows 10/11 with native PowerShell support
- **Full Feature Parity**: All features from the original macOS/Linux version

The Windows port was developed with assistance from Claude Code, demonstrating the power of AI-assisted development while building on the excellent foundation created by Eric Buess and contributions from Jeremy Schaab.

For detailed credits, see [CREDITS.md](CREDITS.md).

## License

Documentation content belongs to Anthropic.
This mirror tool is licensed under the MIT License - see [LICENSE](LICENSE) file for details.
