@echo off

echo Change Version No
notepad wupdate.ini

echo.
echo --------------------------------------------
echo Compiling setup scripts ...
echo --------------------------------------------
echo.

InnoSetup\ISCC.exe "StepFourAirfoils.iss"
if not errorlevel 0 goto error

InnoSetup\ISCC.exe "liftoff.iss"
if not errorlevel 0 goto error

copy history.htm output
copy wupdate.ini output

pause

goto ende

:error
echo --------------------------------------------
echo !!!!!!   ERROR DURING BUILD PACKAGE  !!!!!!!
echo   Please check the package build process!
echo --------------------------------------------

pause

:ende

