# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a community-maintained mirror of Claude Code documentation from https://docs.anthropic.com. It provides:
- Local copies of official Claude Code docs updated every 3 hours via GitHub Actions
- A `/docs` slash command for instant local access to documentation
- Automatic syncing with the official documentation via git hooks

**Target platforms**: macOS, Linux, and Windows

## Key Components

### Documentation Fetching
- **`scripts/fetch_claude_docs.py`**: Python 3 script (v3.0) that:
  - Dynamically discovers documentation pages from official sitemaps
  - Handles both old (`/en/docs/claude-code/`) and new (`/docs/en/`) URL structures
  - Performs robust fetching with retries, rate-limit handling, and content validation
  - Maintains a manifest (`docs/docs_manifest.json`) tracking file hashes and metadata
  - Fetches Claude Code's official changelog from `https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md`
  - **Dependencies**: requests (2.32.4)

### Installation & Updates (macOS/Linux)
- **`install.sh`** (v0.3.3): Smart Bash installer that:
  - Detects existing installations and migrates them to `~/.claude-code-docs`
  - Creates the `/docs` slash command file at `~/.claude/commands/docs.md`
  - Sets up a PreToolUse Read hook in `~/.claude/settings.json` for auto-updates
  - Installs/updates the helper script from template
  - Validates and handles conflicts in local repositories
- **`uninstall.sh`**: Companion script to safely remove all integrations

### Installation & Updates (Windows)
- **`install.ps1`** (v0.3.3): Smart PowerShell installer that:
  - Mirrors all functionality of install.sh for Windows
  - Uses PowerShell native JSON handling (no jq dependency)
  - Installs to `%USERPROFILE%\.claude-code-docs`
  - Creates `/docs` command and settings hook
- **`uninstall.ps1`**: Companion script for Windows uninstallation

### Documentation Helper (macOS/Linux)
- **`scripts/claude-docs-helper.sh.template`** (v0.3.3): Bash script deployed to `~/.claude-code-docs/claude-docs-helper.sh`
  - Handles all `/docs` command functionality
  - Implements auto-update via `git pull` (only when behind remote)
  - Provides fresh/stale checking with `-t` flag
  - Displays changelog and "what's new" functionality
  - Includes input sanitization to prevent command injection

### Documentation Helper (Windows)
- **`scripts/claude-docs-helper.ps1.template`** (v0.3.3): PowerShell script deployed to `%USERPROFILE%\.claude-code-docs\claude-docs-helper.ps1`
  - Full feature parity with Bash version
  - Uses PowerShell native cmdlets (no external dependencies beyond Git)

### Automation
- **`.github/workflows/update-docs.yml`**: GitHub Actions workflow:
  - Runs every 3 hours to fetch latest documentation
  - Uses Python script to discover and fetch pages
  - Generates descriptive commit messages for changed files
  - Creates GitHub issues if fetch fails
  - Only commits when changes detected

### Documentation Manifest
- **`docs/docs_manifest.json`**: Tracks metadata for all fetched files:
  - File hashes (SHA256) for change detection
  - Timestamps for tracking when each file was updated
  - Original source URLs and paths
  - Fetch metadata and statistics
  - GitHub repository/branch configuration

## Development Tasks

### Running Documentation Update Locally
```bash
python scripts/fetch_claude_docs.py
```
This performs a full fetch cycle, discovering pages from Anthropic's sitemap and saving them to the `docs/` directory.

### Testing the /docs Command
After installing:
```bash
/docs hooks          # Read specific documentation
/docs -t            # Check sync status
/docs what's new    # See recent changes
/docs changelog     # View Claude Code changelog
```

### Testing Installation (macOS/Linux)
```bash
bash install.sh     # Full install test
```

### Testing Installation (Windows)
```powershell
.\install.ps1       # Full install test
```

### Testing Uninstallation (macOS/Linux)
```bash
bash uninstall.sh   # Test removal of all components
```

### Testing Uninstallation (Windows)
```powershell
.\uninstall.ps1     # Test removal of all components
```

### Manual Git Repository Operations
When working with the repository:
- The manifest file (`docs/docs_manifest.json`) is git-tracked and will have merge conflicts during automation runs—this is expected
- Preserve git history by avoiding force-pushes to main
- The helper script uses `git pull` with fallback for branch detection

## Architecture Decisions

1. **URL Structure Flexibility**: The fetcher handles both Anthropic's old (`/en/docs/claude-code/`) and new (`/docs/en/`) URL schemes to gracefully handle migrations

2. **Content Validation**: The fetch script validates downloaded content is markdown (checks for minimum size, markdown indicators, and doc patterns) to catch HTML responses or corrupted fetches early

3. **Change Tracking**: Uses SHA256 hashes to avoid unnecessary rewrites; timestamps only update when content actually changes, preserving meaningful "last updated" values

4. **Safe Git Operations**: The helper script:
   - Checks if behind remote before pulling (prevents losing work)
   - Handles detached HEAD and branch switching gracefully
   - Validates branch existence before comparison

5. **Input Sanitization**: The helper script removes shell metacharacters from user input to prevent command injection

## Common Issues & Solutions

**Documentation not updating**: Run `/docs -t` to force a check. The auto-update runs `git pull` if behind remote.

**Installation location migration**: v0.3.x moved the install location to `~/.claude-code-docs` (macOS/Linux) or `%USERPROFILE%\.claude-code-docs` (Windows). The installer automatically finds and migrates older installations.

**Windows execution policy**: The installer uses `-ExecutionPolicy Bypass` automatically. See `docs/WINDOWS_INSTALL.md` for troubleshooting.
