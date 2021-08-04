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

@echo Restaurando IP
@echo off & setLocal
for /f "eol=: tokens=2 delims==" %%a in ('find "IP" ip.txt') do (set IP=%%a)
for /f "eol=: tokens=2 delims==" %%a in ('find "GATEWAY" ip.txt') do (set GATEWAY=%%a)

@netsh interface ipv4 set address name="Ethernet" static %IP% 255.255.255.0 %GATEWAY% & @netsh interface ipv4 set dnsservers name="Ethernet" static %GATEWAY% & @netsh interface ipv4 add dnsservers name="Ethernet" 8.8.8.8

@echo Iniciando restauração...
@Xcopy . "%userprofile%" /E /I /y && @echo A restauração foi concluída com sucesso!
@timeout 5

@echo Iniciando processo de instalação de programas essenciais...
@cd.. && @cd INSTALA.ME && call "!ME INSTALA.bat"
@echo Instalações concluídas com sucesso!
@timeout 5