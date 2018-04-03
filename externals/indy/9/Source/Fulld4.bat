@echo off

if (%1)==() goto test_command
if (%1)==(start) goto start
goto endok

:test_command
if (%COMSPEC%)==() goto no_command
%COMSPEC% /E:9216 /C %0 start %1 %2 %3
goto endok

:no_command
echo No Command Interpreter found
goto endok

:start
call clean.bat
computil SetupD4
if exist setenv.bat call setenv.bat
if not exist ..\D4\*.* md ..\D4 >nul
if exist ..\D4\*.* call clean.bat ..\D4\

if (%NDD4%)==() goto enderror
if (%NDWINSYS%)==() goto enderror

REM ***************************************************
REM Compile Runtime Package Indy40
REM ***************************************************
REM IdCompressionIntercept.pas has to be compiled separately from Indy40 because of a DCC32 bug.  The bug
REM also appears when doing a full build.
%NDD4%\bin\dcc32.exe IdCompressionIntercept.pas /Oobjs /m /h /w /N..\D4 /LE..\D4 /LN..\D4 -$d-l-n+p+r-s-t-w- %2 %3 %4

%NDD4%\bin\dcc32.exe Indy40.dpk /Oobjs /m /h /w /N..\D4 /LE..\D4 /LN..\D4 -$d-l-n+p+r-s-t-w- %2 %3 %4
if errorlevel 1 goto enderror
copy ..\D4\Indy40.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Design-time Package dclIndy40
REM ***************************************************
%NDD4%\bin\dcc32.exe dclIndy40.dpk /Oobjs /m /h /w /N..\D4 /LE..\D4 /LN..\D4 /L..\D4\Indy40.dcp /U..\D4 -$d-l-n+p+r-s-t-w- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del ..\D4\dclIndy40.dcu >nul
del ..\D4\dclIndy40.dcp >nul
del ..\D4\Indy40.dcu >nul
del ..\D4\Indy40.bpl >nul
del ..\D4\IdAbout.dcu >nul
del ..\D4\IdDsnPropEdBinding.dcu >nul
del ..\D4\IdDsnRegister.dcu >nul
del ..\D4\IdRegister.dcu >nul
goto endok
:enderror
call clean
echo Error!
:endok

