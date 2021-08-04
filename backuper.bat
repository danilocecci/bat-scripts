@echo off
@chcp 65001

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

@echo.
@set /p "pasta=Digite o nome da pasta: "
@mkdir "%pasta%"
@echo A pasta %pasta% foi criada com sucesso!
@cd "%pasta%"

@for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do @set NetworkIP=%%a
@echo IP=%NetworkIP% > "ip.txt" && @if "%NetworkIP:~8,1%" EQU "0" (echo GATEWAY=%NetworkIP:~0,9%.1 >> "ip.txt") else (echo GATEWAY=%NetworkIP:~0,11%.1 >> "ip.txt")

@echo "Copiando o Restaurer..."
@cd .. && @Xcopy restaurer.bat "./%pasta%" /I

@cd "%pasta%"

@echo "Iniciando backup..."

@Xcopy "%userprofile%" . /E /I

@echo Processo de restauração concluída com sucesso!

@timeout 5