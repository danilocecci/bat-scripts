@echo off
@echo Iniciando processo de limpeza do sistema!
@echo.
@echo Limpando temp do usu�rio...
@rd %temp% /s /q
@mkdir %temp%
@echo Limpando temp geral...
@rd %windir%\temp /s /q
@mkdir %windir%\temp
@echo Limpando o Prefetch...
@rd /s /q %windir%\Prefetch
@mkdir %windir%\Prefetch
@echo.

@echo Iniciando processo de desativa��o de servi�os do Windows!
@echo.
@Echo Parando o Servi�o Windows Update...
@net stop wuauserv
@echo.
@echo Desabilitando o Servi�o Windows Update ...
@sc config "wuauserv" start= disabled
@echo.

@sc query SysMain > NUL
@if ERRORLEVEL 1060 goto superfetch
@echo Parando o Servi�o SysMain...
@net stop SysMain
@echo Desabilitando o Servi�o SysMain ...
@sc config "Sysmain" start= disabled
@goto fim

:superfetch
@echo Parando o Servi�o Superfetch...
@net stop Superfetch
@echo Desabilitando o Servi�o SysMain ...
@sc config "Sysmain" start= disabled


:fim
@echo Chorrindo!
@timeout 04