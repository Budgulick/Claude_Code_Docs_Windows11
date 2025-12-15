# Credits and Acknowledgments

## Overview

This repository is a Windows-focused fork of the **claude-code-docs** project, which provides local access to Claude Code documentation through a convenient `/docs` slash command.

The Windows port maintains full feature parity with the original macOS/Linux implementation while adding native Windows support through PowerShell scripts and batch file wrappers.

---

## Original Project

**Project**: claude-code-docs
**Repository**: https://github.com/ericbuess/claude-code-docs
**License**: MIT License

The original project was created to provide:
- Local mirror of Claude Code documentation
- Automatic updates via GitHub Actions
- `/docs` slash command integration with Claude Code
- Cross-platform support (macOS and Linux)

---

## Contributors

### Eric Buess
**GitHub**: https://github.com/ericbuess
**Contribution**: Original creator and maintainer of claude-code-docs

Eric Buess created the foundational implementation including:
- Documentation fetching system (Python script with sitemap discovery)
- GitHub Actions workflow for automatic updates
- macOS/Linux installation scripts (Bash)
- Helper scripts for `/docs` command functionality
- Auto-update hooks integration
- Documentation structure and organization

**Key Files Created**:
- `scripts/fetch_claude_docs.py`
- `install.sh`
- `uninstall.sh`
- `scripts/claude-docs-helper.sh.template`
- `.github/workflows/update-docs.yml`
- Original documentation and README

### Jeremy Schaab
**GitHub**: https://github.com/jeremy-schaab
**Contribution**: Windows port contributions

Jeremy Schaab contributed to the Windows implementation through:
- Initial Windows compatibility work
- PowerShell script development
- Testing and validation on Windows environments
- Feedback and improvements to the Windows port

**Reference**: GitHub Pull Request #27 provided valuable insights for:
- Batch file wrapper patterns
- `-NoProfile` flag usage
- Windows-specific documentation structure
- Comprehensive testing approach

---

## Windows Port Implementation

### Developed Using Claude Code

The Windows port was implemented with the assistance of **Claude Code**, Anthropic's AI-powered coding assistant. This demonstrates Claude Code's capability to:
- Analyze existing codebases
- Translate between scripting languages (Bash to PowerShell)
- Maintain feature parity across platforms
- Generate comprehensive documentation
- Follow best practices for Windows development

### Windows Port Features

The Windows implementation includes:

**PowerShell Scripts**:
- `install.ps1` - Native Windows installer with PowerShell 5.1+ support
- `uninstall.ps1` - Clean uninstallation with settings backup
- `scripts/claude-docs-helper.ps1.template` - Full-featured helper script

**Batch File Wrappers**:
- `install.bat` - Easy double-click installation
- `uninstall.bat` - Easy double-click uninstallation

**Documentation**:
- `README-WINDOWS.md` - Windows-specific quick start guide
- `docs/WINDOWS_INSTALL.md` - Detailed Windows installation and troubleshooting
- `TESTING-CHECKLIST.md` - Comprehensive Windows testing scenarios
- `WINDOWS-PORT-SUMMARY.md` - Technical implementation documentation

**Key Implementation Decisions**:
- Native PowerShell JSON handling (no jq.exe dependency)
- Batch wrappers for optimal Windows user experience
- `-NoProfile` flag to prevent user profile interference
- Full feature parity with Unix implementation
- Git for Windows as the only external prerequisite

---

## Technologies and Tools

### Core Technologies

**Python** (v3.x):
- Documentation fetching and processing
- Sitemap parsing and content validation
- Manifest generation and tracking

**Bash** (macOS/Linux):
- Installation and update scripts
- Helper functionality for `/docs` command
- Git operations and settings management

**PowerShell** (Windows):
- Native Windows script support (5.1+)
- JSON manipulation without external tools
- Git operations and settings management

**Git**:
- Version control
- Documentation synchronization
- Automatic updates via git pull

### External Services

**GitHub Actions**:
- Automated documentation fetching every 3 hours
- Commit generation for documentation changes
- Issue creation on fetch failures

**Anthropic Documentation**:
- Source: https://docs.anthropic.com/en/docs/claude-code/
- Content belongs to Anthropic and is subject to their terms of use

---

## Upstream Relationship

This repository is a **derivative work** based on the original claude-code-docs project. Changes made in this Windows-focused fork include:

### Additions (Windows Port)
- Complete PowerShell implementation
- Batch file wrappers for ease of use
- Windows-specific documentation
- Testing checklist for Windows environments
- Implementation summary and technical documentation

### Retained from Original
- Python documentation fetcher
- GitHub Actions workflows
- macOS/Linux Bash scripts
- Documentation structure and content
- Core functionality and features

### Fork Rationale

This repository was created as a separate fork to:
1. Focus specifically on Windows users and Windows 11 optimization
2. Maintain Windows-specific documentation and examples
3. Provide a clear Windows-centric user experience
4. Allow independent development and testing cycles

**Users seeking the original multi-platform version** should visit:
https://github.com/ericbuess/claude-code-docs

**Users seeking Windows-optimized version** can use this repository:
https://github.com/[your-username]/Claude_Code_Docs_Windows11

---

## Third-Party Dependencies

### Python Packages
- `requests` (2.32.4) - HTTP library for fetching documentation

### System Requirements

**Windows**:
- Windows 10 or later
- PowerShell 5.1+
- Git for Windows

**macOS/Linux**:
- macOS 12+ or modern Linux distribution
- Bash
- Git
- jq (for JSON processing)

All systems require:
- Claude Code installation
- Internet connection for initial setup and updates

---

## Documentation Content

The documentation content mirrored in this repository is sourced from:
**Anthropic's Official Claude Code Documentation**
- URL: https://docs.anthropic.com/en/docs/claude-code/
- Copyright: Anthropic PBC
- Subject to Anthropic's terms of use

This repository provides a **mirroring tool only**. The documentation content itself remains the property of Anthropic.

---

## Claude Code Changelog

The repository also provides access to the official Claude Code changelog:
- Source: https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
- Accessible via `/docs changelog` command
- Updated automatically with documentation sync

---

## License

This project is licensed under the **MIT License**.

See [LICENSE](LICENSE) file for full license text.

The MIT License allows:
- Commercial use
- Modification
- Distribution
- Private use

With conditions requiring:
- License and copyright notice inclusion
- No liability or warranty

---

## Community and Support

### Getting Help

**For Windows-specific issues**:
- Open an issue in this repository
- Consult `README-WINDOWS.md` and `docs/WINDOWS_INSTALL.md`
- Review `TESTING-CHECKLIST.md` for known issues

**For general claude-code-docs issues**:
- Visit the original project: https://github.com/ericbuess/claude-code-docs
- Review the original README and documentation

**For Claude Code issues**:
- Official documentation: https://docs.anthropic.com/en/docs/claude-code/
- Claude Code repository: https://github.com/anthropics/claude-code

### Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using `TESTING-CHECKLIST.md`
5. Submit a pull request

Please ensure:
- Windows compatibility is maintained
- Documentation is updated
- Feature parity with Unix version is preserved (when applicable)

---

## Acknowledgment Statement

This Windows port stands on the shoulders of the excellent work done by Eric Buess and Jeremy Schaab. Their original implementation provided the foundation, architecture, and feature set that made this Windows adaptation possible.

The use of Claude Code in developing this port demonstrates the power of AI-assisted development while highlighting the importance of human creativity, design decisions, and quality assurance.

**Thank you to all contributors, past and present, who make tools like this available to the community.**

---

**Repository**: https://github.com/[your-username]/Claude_Code_Docs_Windows11
**Original Project**: https://github.com/ericbuess/claude-code-docs
**Last Updated**: December 2024
