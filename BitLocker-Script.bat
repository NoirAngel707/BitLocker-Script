@echo off

:start

echo list disk>tmp
diskpart /s tmp
del tmp
echo.
set /p Disk=Por favor, selecione o numero do disco a ser formatado:

echo Select disk %Disk% > diskpart.txt 
echo CLEAN >> diskpart.txt
echo CREATE PARTITION PRIMARY SIZE=150 >> diskpart.txt
echo SELECT PARTITION 1 >> diskpart.txt
echo ACTIVE >> diskpart.txt
echo FORMAT fs=ntfs quick >> diskpart.txt

echo Letras indisponiveis:
wmic logicaldisk get name

echo.
set /p LETTER1= Por favor, selecione a letra desejada para a primeira particao:
echo ASSIGN LETTER=%LETTER1% >> diskpart.txt

echo CREATE PARTITION PRIMARY >> diskpart.txt
echo SELECT PARTITION 2 >> diskpart.txt
echo ACTIVE >> diskpart.txt
echo FORMAT fs=ntfs quick >> diskpart.txt

echo.
set /p LETTER2= Por favor, selecione a letra desejada para a segunda particao:
echo ASSIGN LETTER=%LETTER2% >> diskpart.txt

echo.
DISKPART /s diskpart.txt
del diskpart.txt

echo.
manage-bde -on %LETTER1%: -RecoveryPassword
manage-bde -on %LETTER2%: -RecoveryPassword

echo.
manage-bde -protectors -add %LETTER1%: -pw
manage-bde -protectors -add %LETTER2%: -pw 

echo.
set /p Disk_name=Por favor, digite o nome do disco:
LABEL %LETTER1%:%Disk_name%

robocopy "%~dp0\FTK Portable" "%LETTER1%:\FTK Portable" /E /TEE /V /TS /NP /COPY:DAT /DCOPY:DAT
robocopy "%~dp0\VeraCrypt Portable" "%LETTER1%:\VeraCrypt Portable" /E /TEE /V /TS /NP /COPY:DAT /DCOPY:DAT
robocopy "%~dp0\ROBOCOPY" "%LETTER1%:\ROBOCOPY.bat" /E /TEE /V /TS /NP /COPY:DAT /DCOPY:DAT

echo.
manage-bde -lock %LETTER1%:
manage-bde -lock %LETTER2%:

echo Deseja formatar outro disco?
SET /P var=y or n:
IF /I "%var%"=="y" GOTO :start
IF /I NOT "%var%"=="y" GOTO :eof

echo.
echo Formatacao concluida!
pause