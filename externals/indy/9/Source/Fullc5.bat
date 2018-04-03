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
computil SetupC5
if exist setenv.bat call setenv.bat
if not exist ..\C5\*.* md ..\C5 >nul
if exist ..\C5\*.* call clean.bat ..\C5\

if (%NDC5%)==() goto enderror
if (%NDWINSYS%)==() goto enderror
copy *.pas ..\C5
copy *.dpk ..\C5
copy *.obj ..\C5
copy *.inc ..\C5
copy *.res ..\C5
copy *.dcr ..\C5
copy *.rsp ..\C5

if (%NDC5%)==() goto enderror
if (%NDWINSYS%)==() goto enderror

cd ..\C5
REM ***************************************************
REM Compile Runtime Package Indy50
REM ***************************************************
REM IdCompressionIntercept can never be built as part of a package.  It has to be compileed separately
REM due to a DCC32 bug.
%NDC5%\bin\dcc32.exe IdCompressionIntercept.pas /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4

%NDC5%\bin\dcc32.exe Indy50.dpk /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
%NDC5%\bin\dcc32.exe IdDummyUnit.pas /LIndy50.dcp /DBCB /O..\Source\objs /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
del IdDummyUnit.dcu >nul
del IdDummyUnit.hpp >nul
del IdDummyUnit.obj >nul

%NDC5%\bin\dcc32.exe Indy50.dpk /M /DBCB /O..\Source\objs /H /W -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
copy Indy50.bpl %NDWINSYS% >nul
del Indy50.bpl > nul

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating Indy50.LIB file, please wait...
%NDC5%\bin\tlib.exe Indy50.lib /P32 @IndyWin32.rsp >nul
if exist ..\C5\Indy50.bak del ..\C5\Indy50.bak >nul

REM ***************************************************
REM Compile Design-time Package RPDT30
REM ***************************************************
%NDC5%\bin\dcc32.exe dclIndy50.dpk /DBCB /O..\Source\objs /H /W /N..\C5 /LIndy50.dcp -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del dclIndy50.dcu >nul
del dclIndy50.dcp >nul
del Indy50.dcu >nul
del *.pas > nul
del *.dpk > nul
del *.inc > nul
del *.dcr > nul
del *.rsp > nul
REM ***************************************************
REM Design-time only unit .DCU's are not needed.
REM ***************************************************
if exist IdAbout.dcu del IdAbout.dcu >nul
if exist IdDsnBaseCmpEdt.dcu del IdDsnBaseCmpEdt.dcu >nul
if exist IdDsnPropEdBinding.dcu del IdDsnPropEdBinding.dcu >nul
if exist IdDsnRegister.dcu del IdDsnRegister.dcu >nul
if exist IdRegister.dcu del IdRegister.dcu >nul

goto endok
:enderror
call clean
echo Error!
:endok
cd ..\Source

