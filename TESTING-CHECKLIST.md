# Windows Testing Checklist for claude-code-docs

This checklist ensures the Windows implementation works correctly across different environments and scenarios.

## Test Environment Matrix

### Operating Systems
- [ ] Windows 10 Home (21H2 or later)
- [ ] Windows 10 Pro (21H2 or later)
- [ ] Windows 11 Home
- [ ] Windows 11 Pro
- [ ] Windows Server 2019
- [ ] Windows Server 2022

### PowerShell Versions
- [ ] PowerShell 5.1 (Windows default)
- [ ] PowerShell 7.0+
- [ ] PowerShell 7.4+ (latest)

### Git Installations
- [ ] Git for Windows (standard installation)
- [ ] Git for Windows (custom path)
- [ ] Git for Windows (portable)
- [ ] GitHub Desktop (includes Git)

## Installation Testing

### Fresh Installation
- [ ] Run `install.bat` on clean system
- [ ] Run `install.ps1` directly on clean system
- [ ] Run PowerShell one-liner on clean system
- [ ] Verify installation at `%USERPROFILE%\.claude-code-docs`
- [ ] Verify command file created at `%USERPROFILE%\.claude\commands\docs.md`
- [ ] Verify settings.json hook added
- [ ] Verify helper script exists and is executable

### Update Existing Installation
- [ ] Run installer on existing v0.3.2 installation
- [ ] Run installer on existing v0.3.3 installation
- [ ] Verify git repository updated to latest
- [ ] Verify settings preserved
- [ ] Verify no duplicate hooks created

### Migration from Old Location
- [ ] Install at custom location first
- [ ] Run installer to trigger migration
- [ ] Verify migration to `%USERPROFILE%\.claude-code-docs`
- [ ] Verify old location removed (if clean)
- [ ] Verify old location preserved (if has uncommitted changes)

### Edge Cases
- [ ] Username with spaces (e.g., "John Doe")
- [ ] Username with special characters (e.g., "user@domain")
- [ ] Non-English Windows installation
- [ ] User profile on different drive (e.g., D:\Users\)
- [ ] Limited user account (non-admin)
- [ ] Domain-joined machine
- [ ] Installation while offline (should fail gracefully)

## Prerequisite Validation

### Missing Prerequisites
- [ ] Test with Git not installed (should show clear error)
- [ ] Test with Git not in PATH (should show clear error)
- [ ] Test with PowerShell 4.0 or older (should fail with version check)

### Execution Policy
- [ ] Test with policy = Restricted
- [ ] Test with policy = AllSigned
- [ ] Test with policy = RemoteSigned
- [ ] Test with policy = Unrestricted
- [ ] Test with policy = Bypass

### Network Conditions
- [ ] Installation with good internet connection
- [ ] Installation with slow internet connection
- [ ] Installation with proxy server
- [ ] Installation with corporate firewall
- [ ] Installation completely offline (should fail with helpful message)

## Functionality Testing

### /docs Command - Basic
- [ ] `/docs` - List all topics
- [ ] `/docs hooks` - Read specific topic
- [ ] `/docs mcp` - Read another topic
- [ ] `/docs memory` - Read another topic
- [ ] `/docs changelog` - Read Claude Code changelog
- [ ] `/docs nonexistent` - Handle missing topic gracefully

### /docs Command - Freshness Check
- [ ] `/docs -t` - Check sync status only
- [ ] `/docs -t hooks` - Check status then read
- [ ] `/docs --check` - Alternative flag
- [ ] Verify auto-update runs when behind
- [ ] Verify no update when up-to-date
- [ ] Verify offline handling graceful

### /docs Command - What's New
- [ ] `/docs what's new` - Show recent changes
- [ ] `/docs whats new` - Alternative format
- [ ] Verify git log parsing works
- [ ] Verify commit links display correctly
- [ ] Verify handling when no recent changes

### Auto-Update Hook
- [ ] Hook triggers when reading documentation
- [ ] Hook checks for updates
- [ ] Hook pulls updates when behind
- [ ] Hook completes quickly (non-blocking)
- [ ] Hook doesn't interfere with document reading

### Search and Discovery
- [ ] Search for keyword: `/docs "authentication"`
- [ ] Natural language: `/docs how do I use hooks`
- [ ] Partial match works
- [ ] Case-insensitive search
- [ ] Stop words filtered correctly

## Uninstallation Testing

### Clean Uninstall
- [ ] Run `uninstall.bat`
- [ ] Run `uninstall.ps1` directly
- [ ] Verify command file removed
- [ ] Verify hooks removed from settings.json
- [ ] Verify installation directory removed
- [ ] Verify settings.json backup created
- [ ] Verify settings.json remains valid JSON

### Uninstall with Uncommitted Changes
- [ ] Make local changes to repository
- [ ] Run uninstaller
- [ ] Verify repository preserved with warning
- [ ] Verify command file and hooks still removed

### Uninstall with Corrupted Settings
- [ ] Corrupt settings.json
- [ ] Run uninstaller
- [ ] Verify graceful error handling
- [ ] Verify backup created

## Error Handling

### Installation Errors
- [ ] Git clone fails (network issue)
- [ ] Template file missing
- [ ] No write permission to %USERPROFILE%
- [ ] Disk full
- [ ] Settings.json parse error

### Runtime Errors
- [ ] Helper script missing
- [ ] Documentation directory deleted
- [ ] Git repository corrupted
- [ ] Network offline when checking updates
- [ ] settings.json locked by another process

## Integration Testing

### Claude Code Integration
- [ ] Command appears in Claude Code command list
- [ ] Command executes from Claude Code
- [ ] Output displays correctly in Claude Code
- [ ] Long documents display completely
- [ ] Unicode/emoji characters display correctly
- [ ] Links are clickable (if supported)

### Git Integration
- [ ] Git pull works correctly
- [ ] Git fetch works correctly
- [ ] Branch switching handled
- [ ] Merge conflicts handled
- [ ] Detached HEAD handled
- [ ] Clean state forced when needed

### PowerShell Integration
- [ ] JSON parsing works correctly
- [ ] JSON writing preserves structure
- [ ] JSON depth handling correct (no truncation)
- [ ] UTF-8 encoding preserved
- [ ] No BOM added to files
- [ ] Exit codes handled correctly

## Performance Testing

### Speed Tests
- [ ] Fresh installation completes in < 2 minutes
- [ ] Update installation completes in < 30 seconds
- [ ] `/docs` lists topics in < 1 second
- [ ] `/docs topic` reads doc in < 2 seconds
- [ ] `/docs -t` checks status in < 5 seconds
- [ ] Auto-update check completes in < 2 seconds

### Resource Usage
- [ ] Installation uses < 50 MB disk space
- [ ] PowerShell process doesn't leak memory
- [ ] No zombie processes left behind
- [ ] No excessive file handles
- [ ] Git operations don't lock files

## Security Testing

### Script Security
- [ ] Scripts don't contain hardcoded credentials
- [ ] Scripts validate all user input
- [ ] Scripts sanitize paths properly
- [ ] Scripts prevent command injection
- [ ] Scripts use secure git clone (HTTPS)

### Execution Policy Compliance
- [ ] Scripts work with Bypass policy
- [ ] Scripts work with RemoteSigned policy
- [ ] Scripts signed if required (not currently)
- [ ] Batch wrappers use `-ExecutionPolicy Bypass` correctly

### Permissions
- [ ] No elevation required
- [ ] No modifications outside user profile
- [ ] No system file modifications
- [ ] No registry modifications
- [ ] Settings.json backup before modification

## Documentation Testing

### README-WINDOWS.md
- [ ] All instructions accurate
- [ ] All links work
- [ ] All commands tested
- [ ] Prerequisites listed correctly
- [ ] Troubleshooting steps effective

### docs/WINDOWS_INSTALL.md
- [ ] Installation steps work
- [ ] Troubleshooting covers common issues
- [ ] Manual installation instructions work
- [ ] Uninstallation instructions work

### In-Code Help
- [ ] `/docs uninstall` shows correct instructions
- [ ] Error messages helpful and actionable
- [ ] Version numbers correct
- [ ] Links to documentation correct

## Regression Testing

After any code changes, verify:
- [ ] Fresh installation still works
- [ ] Update installation still works
- [ ] All /docs commands still work
- [ ] Uninstallation still works
- [ ] No new errors introduced

## Platform-Specific Tests

### Windows-Specific Features
- [ ] Batch files work correctly
- [ ] PowerShell cmdlets work
- [ ] Windows paths handled correctly
- [ ] %USERPROFILE% expansion works
- [ ] Backslashes in paths work
- [ ] Forward slashes in paths work (Git)

### Cross-Platform Parity
- [ ] Same features as macOS/Linux version
- [ ] Same documentation quality
- [ ] Same error handling quality
- [ ] Same performance characteristics
- [ ] Same security posture

## Sign-Off

Test Run Information:
- **Date:** _______________
- **Tester:** _______________
- **Windows Version:** _______________
- **PowerShell Version:** _______________
- **Git Version:** _______________

Results:
- **Total Tests:** _____
- **Passed:** _____
- **Failed:** _____
- **Skipped:** _____

Critical Issues Found:
- [ ] None
- [ ] List below:

---

### Notes

Use this space for additional observations, edge cases discovered, or recommendations:

---

### Approval

- [ ] All critical tests passed
- [ ] No blocking issues found
- [ ] Ready for release

**Approved by:** _______________
**Date:** _______________
