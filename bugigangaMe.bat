@echo off
@chcp 65001
@CLS
@cd /d %~dp0
@Title Bem vindo ao bugigangaMe!
@echo ====================================================================
@echo Esse programa é responsável por pegar as informações do computador
@echo e salvá-las em uma pasta criada na raiz deste dispositivo removível!
@echo ====================================================================
@echo.

:id
@set /p id="ID MACHINE: "
@if not exist "Machines" mkdir Machines
@cd Machines
@if exist %id%.txt (cls && @echo ID %id% EM USO! && cd.. && @echo. && goto id)
@if %id% equ " " (cls && @echo ID EM BRANCO NÃO É PERMITIDO! && cd..  && @echo. && goto id)

@cls && echo ID MACHINE: %id%

@for /f "tokens=*" %%f in ('wmic os get Caption /value ^| find "="') do set "%%f"
@for /f "tokens=*" %%f in ('wmic os get OSArchitecture /value ^| find "="') do set "%%f"
@for /f "tokens=*" %%f in ('wmic baseboard get Manufacturer /value ^| find "="') do set "%%f"
@for /f "tokens=*" %%f in ('wmic baseboard get Product /value ^| find "="') do set "%%f"
@for /f "tokens=*" %%f in ('wmic cpu get Name /value ^| find "="') do set "%%f"
@for /f "tokens=*" %%f in ('wmic computersystem get TotalPhysicalMemory /value ^| find "="') do set "%%f"

@echo Placa Mãe = %Manufacturer% - %Product% >> "%id%.txt"
@echo CPU = %Name% >> "%id%.txt"
@set mem=%TotalPhysicalMemory:~0,1%.%TotalPhysicalMemory:~1,1%GB
@echo Memória = %mem% >> "%id%.txt"
@systeminfo | findstr /C:"original" >> "%id%.txt"
@echo S.O. = %Caption% - %OSArchitecture% >> "%id%.txt"
@echo Infos coletadas com sucesso! BOMDIAMichaelCPDFalando2021
timeout 3
