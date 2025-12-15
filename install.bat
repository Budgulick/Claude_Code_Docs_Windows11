@echo off
setlocal EnableDelayedExpansion

REM ============================================================================
REM Claude Code Docs Installer for Windows - Batch Wrapper
REM ============================================================================
REM This batch file provides easy installation for Windows users
REM No PowerShell knowledge required - just double-click to install
REM ============================================================================

echo.
echo ============================================================================
echo Claude Code Docs Installer v0.3.3 (Windows)
echo ============================================================================
echo.
echo This will install Claude Code Documentation Mirror to your system.
echo.
echo Installation location: %%USERPROFILE%%\.claude-code-docs
echo Creates command: /docs
echo.

REM Check for PowerShell
where powershell.exe >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] PowerShell not found
    echo.
    echo PowerShell 5.1 or later is required.
    echo It should be included with Windows 10 and later.
    echo.
    echo If you're on an older Windows version, please download PowerShell from:
    echo https://github.com/PowerShell/PowerShell/releases
    echo.
    pause
    exit /b 1
)

REM Check for Git
where git.exe >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Git not found
    echo.
    echo Git for Windows is required for this installation.
    echo.
    echo Please download and install Git for Windows from:
    echo https://git-scm.com/download/win
    echo.
    echo After installing Git, restart this installer.
    echo.
    pause
    exit /b 1
)

echo Prerequisites check: OK
echo   - PowerShell: Found
echo   - Git: Found
echo.
echo Press any key to begin installation...
pause >nul

REM Run PowerShell installer
echo.
echo Running installer...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

REM Check result
if %ERRORLEVEL% equ 0 (
    echo.
    echo ============================================================================
    echo [SUCCESS] Installation complete!
    echo ============================================================================
    echo.
    echo Next steps:
    echo   1. Restart Claude Code to load the new /docs command
    echo   2. Try these commands:
    echo      /docs              - List all documentation topics
    echo      /docs hooks        - Read hooks documentation
    echo      /docs what's new   - See recent changes
    echo.
) else (
    echo.
    echo ============================================================================
    echo [ERROR] Installation failed
    echo ============================================================================
    echo.
    echo Please check the error messages above for details.
    echo.
    echo For help, visit: https://github.com/ericbuess/claude-code-docs/issues
    echo.
)

echo.
echo Press any key to exit...
pause >nul
exit /b %ERRORLEVEL%
