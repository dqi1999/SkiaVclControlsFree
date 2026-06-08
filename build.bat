@echo off
setlocal
set BDS=D:\Delphi 13.1
set BDSBIN=%BDS%\bin
set PATH=%BDSBIN%;C:\Windows\Microsoft.NET\Framework\v4.0.30319;%PATH%

echo Compiling SkiaVclControls package...
MSBuild SkiaVclControls.dproj /t:Build /p:Config=Debug /p:Platform=Win32
if errorlevel 1 (
    echo Failed to compile SkiaVclControls package.
    exit /b 1
)

echo Compilation successful.
endlocal
