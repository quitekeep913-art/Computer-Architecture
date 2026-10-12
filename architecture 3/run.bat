@echo off
REM Usage:  run.bat lab05_alu_addition     (build and run ONE program, no .asm)
REM         run.bat all                      (build and run all 15, in order)
REM In PowerShell write:  .\run.bat lab05_alu_addition

if "%1"=="" (
    echo Usage: run.bat lab01_immediate_load   or   run.bat all
    exit /b 1
)

if /I "%1"=="all" goto all

:one
echo ===== %1 =====
nasm -f win32 %1.asm -o %1.obj || exit /b 1
gcc -m32 %1.obj -o %1.exe || exit /b 1
%1.exe
echo.
exit /b 0

:all
for %%f in (lab*.asm) do call :one %%~nf
exit /b 0
