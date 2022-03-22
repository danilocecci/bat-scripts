::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"

if '%cmdInvoke%'=='1' goto InvokeCmd 

ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO off
@CHCP 65001 >nul

TITLE IP Config

GOTO conexao 

:erroConexao
CLS
ECHO "%conexao%" não é uma opção válida!
ECHO Vamos tentar novamente!
ECHO.

:conexao
ECHO O que deseja configurar?
ECHO [1] IP FIXO
ECHO [2] DHCP
SET /p conexao= Escolha: 
IF %conexao% lss 1 goto erroConexao
IF %conexao% equ 2 goto DHCP
IF %conexao% gtr 2 goto erroConexao

:local
ECHO.
ECHO Qual é o local de acesso?
ECHO [1] INTERNO
ECHO [2] EXTERNO
SET /p local= Escolha: 
IF %local% lss 1 goto local
IF %local% equ 1 set faixa=0& goto ip
IF %local% gtr 2 goto local

:faixa
ECHO.
SET /p faixa= Qual é a faixa de IP? 
SET /p confirmaFaixa= Faixa "%faixa%" está correta? [S/N] 
IF %confirmaFaixa% neq s goto faixa

:ip
ECHO.
SET /p ip= Qual será o IP final desta máquina? 
SET /p cofirmaIp= IP final %ip% está correto? [S/N] 
IF %cofirmaIp% neq s goto ip

:setarIP
NETSH interface ipv4 set address name="Ethernet" static 192.168.%faixa%.%ip% 255.255.255.0 192.168.%faixa%.1 & netsh interface ipv4 set dnsservers name="Ethernet" static 192.168.%faixa%.1 & netsh interface ipv4 add dnsservers name="Ethernet" 8.8.8.8
GOTO thanks

:DHCP
NETSH interface ipv4 set address name="Ethernet" dhcp & netsh interface ipv4 set dnsservers name="Ethernet" dhcp 

:thanks
ECHO Obrigado por utilizar uma ferramenta do Danilo (2021) :D
TIMEOUT /t 3