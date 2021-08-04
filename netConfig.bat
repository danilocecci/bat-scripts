@echo off
title NETCONFIG
CHCP 1252 >NUL

:-------------------------------------
REM  --> Verificando permissões de administrador
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> Se não tiver previlégios de Administrador ele cria um script pra ter acesso a administrador e depois deleta.
if '%errorlevel%' NEQ '0' (
    echo Requisitando previlegios de administrador...
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
goto conexao 

:erroConexao
cls
echo "%conexao%" não é uma opção válida!
echo Vamos tentar novamente!
echo.

:conexao
echo O que deseja configurar?
echo [1] IP FIXO
echo [2] DHCP
set /p conexao= Escolha: 
if %conexao% lss 1 goto erroConexao
if %conexao% equ 2 goto DHCP
if %conexao% gtr 2 goto erroConexao

:local
echo.
echo Qual é o local de acesso?
echo [1] INTERNO
echo [2] EXTERNO
set /p local= Escolha: 
if %local% lss 1 goto local
if %local% equ 1 set faixa=0& goto ip
if %local% gtr 2 goto local

:faixa
echo.
set /p faixa= Qual é a faixa de IP? 
set /p confirmaFaixa= Faixa "%faixa%" está correta? [S/N] 
if %confirmaFaixa% neq s goto faixa

:ip
echo.
set /p ip= Qual será o IP final desta máquina? 
set /p cofirmaIp= IP final %ip% está correto? [S/N] 
if %cofirmaIp% neq s goto ip

:setarIP
netsh interface ipv4 set address name="Ethernet" static 192.168.%faixa%.%ip% 255.255.255.0 192.168.%faixa%.1 & netsh interface ipv4 set dnsservers name="Ethernet" static 192.168.%faixa%.1 & netsh interface ipv4 add dnsservers name="Ethernet" 8.8.8.8
goto thanks

:DHCP
netsh interface ipv4 set address name="Ethernet" dhcp & netsh interface ipv4 set dnsservers name="Ethernet" dhcp 

:thanks
echo Obrigado! Se o aumento não vier agora, vem mes que vem... (2021) :D
timeout /t 3