@echo off

if (%1)==() goto test_command
if (%1)==(start) goto start
goto endok

:test_command
if (%COMSPEC%)==() goto no_command
%COMSPEC% /E:9217 /C %0 start %1 %2 %3
goto endok

:no_command
echo No Command Interpreter found
goto endok

:start
call clean.bat
computil SetupD7
if exist setenv.bat call setenv.bat
if not exist ..\D7\*.* md ..\D7 >nul
if exist ..\D7\*.* call clean.bat ..\D7\

if (%NDD7%)==() goto enderror
if (%NDWINSYS%)==() goto enderror

REM ***************************************************
REM Compile Runtime Package Indy70
REM ***************************************************
REM IdCompressionIntercept.pas has to be compiled separately from Indy70 because of a DCC32 bug.  The bug
REM also appears when doing a full build.
%NDD7%\bin\dcc32.exe IdCompressionIntercept.pas /Oobjs /m /h /w /N..\D7 /LE..\D7 /LN..\D7 -$d-l-n+p+r-s-t-w- %2 %3 %4

%NDD7%\bin\dcc32.exe Indy70.dpk /Oobjs /m /h /w /N..\D7 /LE..\D7 /LN..\D7 -$d-l-n+p+r-s-t-w- %2 %3 %4
if errorlevel 1 goto enderror
copy ..\D7\Indy70.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Design-time Package dclIndy70
REM ***************************************************
%NDD7%\bin\dcc32.exe dclIndy70.dpk /Oobjs /m /h /w /N..\D7 /LE..\D7 /LN..\D7 /L..\D7\Indy70.dcp /U..\D7 -$d-l-n+p+r-s-t-w- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del ..\D7\dclIndy70.dcu >nul
del ..\D7\dclIndy70.dcp >nul
del ..\D7\Indy70.dcu >nul
del ..\D7\Indy70.bpl >nul
del ..\D7\IdAbout.dcu >nul
del ..\D7\IdDsnPropEdBinding.dcu >nul
del ..\D7\IdDsnRegister.dcu >nul
del ..\D7\IdRegister.dcu >nul
goto endok
:enderror
call clean
echo Error!
:endok

