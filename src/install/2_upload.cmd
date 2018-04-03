@echo off
echo.
echo --------------------------------------------
echo Uploading files ...
echo --------------------------------------------
echo.

ftp -n -s:..\..\..\liftoff_deployment\xUploadInput.txt

echo.
echo --------------------------------------------
echo Upload done.
echo --------------------------------------------
echo.
type output\wupdate.ini
echo.

pause
