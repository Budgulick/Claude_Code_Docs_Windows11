# GitHub Repository Setup Guide

This guide will walk you through uploading the Claude Code Docs Windows11 fork to GitHub.

---

## Repository Information

**Repository Name**: `Claude_Code_Docs_Windows11`
**Description**: Windows-optimized fork of claude-code-docs with native PowerShell support
**Repository Type**: Public
**License**: MIT

---

## Prerequisites

Before starting, ensure you have:

1. **Git installed** on your Windows machine
   - Download from: https://git-scm.com/download/win
   - Verify: `git --version`

2. **GitHub account** created
   - Sign up at: https://github.com/join

3. **Git configured** with your identity
   ```powershell
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

---

## Step 1: Create GitHub Repository

### Option A: Via GitHub Website (Recommended)

1. Go to https://github.com/new
2. Fill in the repository details:
   - **Repository name**: `Claude_Code_Docs_Windows11`
   - **Description**: `Windows-optimized fork of claude-code-docs - Local mirror of Claude Code documentation with native PowerShell support for Windows 10/11`
   - **Visibility**: Public ✅
   - **Initialize repository**:
     - ❌ Do NOT add README
     - ❌ Do NOT add .gitignore
     - ❌ Do NOT add license
     (We already have these files)
3. Click "Create repository"

### Option B: Via GitHub CLI

If you have GitHub CLI installed:
```powershell
gh repo create Claude_Code_Docs_Windows11 --public --description "Windows-optimized fork of claude-code-docs - Local mirror of Claude Code documentation with native PowerShell support for Windows 10/11"
```

---

## Step 2: Initialize Local Git Repository

Open PowerShell and navigate to the project directory:

```powershell
cd "C:\Users\Bud\Downloads\claude-code-docs-main"
```

### Initialize Git (if not already initialized)

Check if Git is already initialized:
```powershell
git status
```

If you see "fatal: not a git repository", initialize it:
```powershell
git init
```

If Git is already initialized, you may want to start fresh:
```powershell
# Remove existing Git history (CAREFUL!)
Remove-Item -Recurse -Force .git

# Reinitialize
git init
```

---

## Step 3: Configure Git Remote

Add your GitHub repository as the remote origin:

```powershell
# Replace YOUR_USERNAME with your actual GitHub username
git remote add origin https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11.git

# Verify remote was added
git remote -v
```

You should see:
```
origin  https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11.git (fetch)
origin  https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11.git (push)
```

---

## Step 4: Prepare Files for Commit

### Review what will be committed

```powershell
# See which files will be tracked
git status

# See which files are ignored
git status --ignored
```

### Check for sensitive information

**IMPORTANT**: Before committing, verify there are no:
- API keys or credentials
- Personal information
- Large binary files
- Local configuration files

The `.gitignore` file should already exclude sensitive files like:
- `.claude/` directory
- `*.log` files
- Test files

### Stage all files

```powershell
git add .
```

### Verify staged files

```powershell
git status
```

You should see files like:
- `install.ps1`
- `install.bat`
- `README.md`
- `README-WINDOWS.md`
- `LICENSE`
- `CREDITS.md`
- etc.

---

## Step 5: Create Initial Commit

Create your first commit with a descriptive message:

```powershell
git commit -m "Initial commit: Windows fork of claude-code-docs

- Native PowerShell implementation (install.ps1, uninstall.ps1)
- Batch file wrappers for easy installation (install.bat, uninstall.bat)
- Windows-specific documentation (README-WINDOWS.md, WINDOWS_INSTALL.md)
- Full feature parity with macOS/Linux version
- Comprehensive testing checklist
- Credits to original authors (Eric Buess, Jeremy Schaab)
- Windows port implemented using Claude Code

Based on: https://github.com/ericbuess/claude-code-docs"
```

---

## Step 6: Set Default Branch

GitHub's default branch is typically `main`:

```powershell
# Rename master to main (if necessary)
git branch -M main
```

---

## Step 7: Push to GitHub

### First-time push

```powershell
git push -u origin main
```

You may be prompted for authentication:

**Option A: Personal Access Token (Recommended)**
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` scope
3. Use token as password when prompted

**Option B: GitHub CLI**
```powershell
gh auth login
```

**Option C: Git Credential Manager**
- Windows will prompt for GitHub credentials
- Sign in via browser

### Verify upload

After pushing, you should see:
```
Enumerating objects: X, done.
Counting objects: 100% (X/X), done.
...
To https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

Visit your repository: `https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11`

---

## Step 8: Configure Repository Settings

### Add Repository Topics

On your GitHub repository page:
1. Click the gear icon ⚙️ next to "About"
2. Add topics:
   - `claude-code`
   - `documentation`
   - `windows`
   - `powershell`
   - `windows10`
   - `windows11`
   - `ai-assisted`
   - `anthropic`
   - `claude`
3. Click "Save changes"

### Update Repository Description

Ensure the description is set:
```
Windows-optimized fork of claude-code-docs - Local mirror of Claude Code documentation with native PowerShell support for Windows 10/11
```

### Add Website URL (Optional)

If you have documentation hosted elsewhere:
- Add the URL in repository settings

### Enable GitHub Actions (if using)

The repository includes `.github/workflows/` files:
1. Go to "Actions" tab
2. Enable GitHub Actions if prompted
3. Review and enable workflows

**Note**: The `update-docs.yml` workflow fetches documentation every 3 hours. You may want to review and adjust the schedule.

---

## Step 9: Create GitHub Release (Optional)

Create a release to mark version 0.3.3:

### Via GitHub Website

1. Go to your repository
2. Click "Releases" on the right sidebar
3. Click "Create a new release"
4. Fill in:
   - **Tag**: `v0.3.3`
   - **Release title**: `v0.3.3 - Windows Fork Initial Release`
   - **Description**:
     ```markdown
     ## Windows Fork - Initial Release

     This is the initial release of the Windows-optimized fork of claude-code-docs.

     ### Features
     - ✅ Native PowerShell implementation
     - ✅ Batch file wrappers for easy installation
     - ✅ Full feature parity with macOS/Linux version
     - ✅ Windows-specific documentation
     - ✅ Comprehensive testing checklist

     ### Installation

     Download `install.bat` and double-click, or run:
     ```powershell
     iwr -useb https://raw.githubusercontent.com/YOUR_USERNAME/Claude_Code_Docs_Windows11/main/install.ps1 | iex
     ```

     ### Credits
     - Original project by [Eric Buess](https://github.com/ericbuess)
     - Windows contributions by [Jeremy Schaab](https://github.com/jeremy-schaab)
     - Windows port implemented using Claude Code

     For full credits, see [CREDITS.md](CREDITS.md)
     ```
5. Click "Publish release"

### Via GitHub CLI

```powershell
gh release create v0.3.3 --title "v0.3.3 - Windows Fork Initial Release" --notes "Initial release of Windows-optimized fork"
```

---

## Step 10: Update URLs in Documentation

After creating the repository, update placeholder URLs:

### Files to update:

1. **README.md** - Update badge URLs and links
2. **CREDITS.md** - Update repository URL at bottom
3. **GITHUB_SETUP.md** (this file) - Replace `YOUR_USERNAME` with actual username

### Find and replace

```powershell
# Use your favorite editor or:
# Replace YOUR_USERNAME with your actual GitHub username
# Replace [your-username] with your actual GitHub username
```

### Commit and push changes

```powershell
git add .
git commit -m "docs: Update repository URLs with actual GitHub username"
git push
```

---

## Step 11: Add Fork Relationship (Optional)

To formally link this as a fork of the original repository:

1. Go to your repository on GitHub
2. Click "Settings"
3. Scroll to "Danger Zone"
4. Look for "Template repository" or fork settings

**Note**: Since this was created independently (not via GitHub's fork button), it won't show as a fork automatically. You can:
- Add a link in the README (already done)
- Reference the original in repository description
- Star the original repository

---

## Step 12: Set Up Branch Protection (Optional)

Protect the main branch from accidental force pushes:

1. Go to Settings → Branches
2. Add rule for `main`
3. Configure:
   - ☑️ Require pull request reviews before merging (if collaborating)
   - ☑️ Require status checks to pass before merging
   - ☑️ Include administrators (optional)

---

## Maintenance: Future Updates

### Making changes

```powershell
# Make your changes to files
# ...

# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: Add new feature XYZ"

# Push to GitHub
git push
```

### Commit message conventions

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks
- `test:` - Test updates
- `refactor:` - Code refactoring

### Syncing with upstream (original repository)

To pull updates from the original claude-code-docs repository:

```powershell
# Add upstream remote (one-time)
git remote add upstream https://github.com/ericbuess/claude-code-docs.git

# Fetch upstream changes
git fetch upstream

# Merge upstream changes (be careful of conflicts)
git merge upstream/main

# Resolve any conflicts manually
# Then push
git push
```

---

## Troubleshooting

### "fatal: remote origin already exists"

```powershell
# Remove existing remote
git remote remove origin

# Add correct remote
git remote add origin https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11.git
```

### Authentication failed

**Solution**: Use Personal Access Token instead of password:
1. Generate token at: https://github.com/settings/tokens
2. Use token as password when prompted

Or use GitHub CLI:
```powershell
gh auth login
```

### "refusing to merge unrelated histories"

If you initialized the repo on GitHub with README/license:
```powershell
git pull origin main --allow-unrelated-histories
# Resolve conflicts
git push
```

### Large files or slow push

Check for large files:
```powershell
# Find large files
git ls-files | ForEach-Object { New-Object PSObject -Property @{
    File = $_
    Size = (Get-Item $_).Length / 1MB
}} | Where-Object {$_.Size -gt 1} | Sort-Object Size -Descending
```

Add large files to `.gitignore` if unnecessary.

---

## GitHub Actions Workflow

The repository includes GitHub Actions workflows:

### update-docs.yml

**Purpose**: Fetches latest documentation every 3 hours

**Schedule**: `0 */3 * * *` (every 3 hours)

**Considerations**:
- Uses GitHub Actions minutes (free tier: 2000 minutes/month)
- Automatically commits documentation updates
- May need to configure GitHub token permissions

**To modify schedule**:
Edit `.github/workflows/update-docs.yml`:
```yaml
schedule:
  - cron: '0 */6 * * *'  # Change to every 6 hours
```

### Secrets needed

If workflows require authentication:
1. Go to Settings → Secrets and variables → Actions
2. Add repository secrets as needed

---

## Post-Upload Checklist

After uploading to GitHub:

- [ ] Repository is public and accessible
- [ ] README.md displays correctly on repository homepage
- [ ] LICENSE file is recognized by GitHub
- [ ] All badges in README.md are working
- [ ] Documentation files are readable and formatted correctly
- [ ] .gitignore is preventing sensitive files from being committed
- [ ] Repository topics are added for discoverability
- [ ] Repository description is set
- [ ] Release v0.3.3 is created (optional)
- [ ] URLs in documentation point to correct repository
- [ ] GitHub Actions workflows are enabled (if using)
- [ ] Repository credited original authors properly

---

## Sharing Your Repository

After setup, share your repository:

**GitHub URL**: `https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11`

**Installation command for users**:
```powershell
# Batch file method (easiest)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/Claude_Code_Docs_Windows11/main/install.bat" -OutFile install.bat

# PowerShell one-liner
iwr -useb https://raw.githubusercontent.com/YOUR_USERNAME/Claude_Code_Docs_Windows11/main/install.ps1 | iex
```

**Update README.md** with your actual GitHub username to provide correct installation commands.

---

## Support and Community

### Getting help

- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Enable GitHub Discussions for community questions
- **Pull Requests**: Welcome contributions from the community

### Enable Discussions (Optional)

1. Go to Settings → Features
2. Enable "Discussions"
3. Set up discussion categories

---

## Congratulations! 🎉

Your repository is now live on GitHub!

**Next steps**:
1. ⭐ Star the original repository: https://github.com/ericbuess/claude-code-docs
2. 📢 Share your Windows fork with the community
3. 📝 Keep documentation updated
4. 🐛 Monitor issues and respond to users
5. 🔄 Periodically sync with upstream for updates

**Repository URL**: https://github.com/YOUR_USERNAME/Claude_Code_Docs_Windows11

---

**Last Updated**: December 2024
**Version**: 1.0
