@echo off
@echo Iniciando processo de limpeza do sistema!
@echo.
@echo Limpando temp do usuário...
@rd %temp% /s /q
@mkdir %temp%
@echo Limpando temp geral...
@rd %windir%\temp /s /q
@mkdir %windir%\temp
@echo Limpando o Prefetch...
@rd /s /q %windir%\Prefetch
@mkdir %windir%\Prefetch
@echo.

@echo Iniciando processo de desativação de serviços do Windows!
@echo.
@Echo Parando o Serviço Windows Update...
@net stop wuauserv
@echo.
@echo Desabilitando o Serviço Windows Update ...
@sc config "wuauserv" start= disabled
@echo.

@sc query SysMain > NUL
@if ERRORLEVEL 1060 goto superfetch
@echo Parando o Serviço SysMain...
@net stop SysMain
@echo Desabilitando o Serviço SysMain ...
@sc config "Sysmain" start= disabled
@goto fim

:superfetch
@echo Parando o Serviço Superfetch...
@net stop Superfetch
@echo Desabilitando o Serviço SysMain ...
@sc config "Sysmain" start= disabled


:fim
@echo Chorrindo!
@timeout 04