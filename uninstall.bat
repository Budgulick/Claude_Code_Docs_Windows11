@echo off
setlocal EnableDelayedExpansion

REM ============================================================================
REM Claude Code Docs Uninstaller for Windows - Batch Wrapper
REM ============================================================================
REM This batch file provides easy uninstallation for Windows users
REM No PowerShell knowledge required - just double-click to uninstall
REM ============================================================================

echo.
echo ============================================================================
echo Claude Code Docs Uninstaller v0.3.3 (Windows)
echo ============================================================================
echo.
echo This will remove Claude Code Documentation Mirror from your system.
echo.
echo What will be removed:
echo   - The /docs command from %%USERPROFILE%%\.claude\commands\docs.md
echo   - Auto-update hooks from %%USERPROFILE%%\.claude\settings.json
echo   - Installation directory %%USERPROFILE%%\.claude-code-docs
echo.
echo Note: Directories with uncommitted changes will be preserved.
echo.

REM Check for PowerShell
where powershell.exe >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] PowerShell not found
    echo.
    echo PowerShell is required to run the uninstaller.
    echo.
    pause
    exit /b 1
)

echo Press any key to begin uninstallation...
pause >nul

REM Run PowerShell uninstaller
echo.
echo Running uninstaller...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1"

REM Check result
if %ERRORLEVEL% equ 0 (
    echo.
    echo ============================================================================
    echo [SUCCESS] Uninstallation complete!
    echo ============================================================================
    echo.
    echo Claude Code Docs has been removed from your system.
    echo.
    echo To reinstall later, visit:
    echo https://github.com/ericbuess/claude-code-docs
    echo.
) else (
    echo.
    echo ============================================================================
    echo [ERROR] Uninstallation failed
    echo ============================================================================
    echo.
    echo Please check the error messages above for details.
    echo.
    echo You can also manually remove:
    echo   - %%USERPROFILE%%\.claude\commands\docs.md
    echo   - %%USERPROFILE%%\.claude-code-docs
    echo   - Hooks from %%USERPROFILE%%\.claude\settings.json
    echo.
)

echo.
echo Press any key to exit...
pause >nul
exit /b %ERRORLEVEL%
