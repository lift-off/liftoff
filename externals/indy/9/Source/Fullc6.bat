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
computil SetupC6
if exist setenv.bat call setenv.bat
if not exist ..\C6\*.* md ..\C6 >nul
if exist ..\C6\*.* call clean.bat ..\C6\
if (%NDC6%)==() goto enderror
if (%NDWINSYS%)==() goto enderror

copy *.pas ..\C6
copy *.dpk ..\C6
copy *.obj ..\C6
copy *.inc ..\C6
copy *.res ..\C6
copy *.dcr ..\C6
copy *.rsp ..\C6

if (%NDC6%)==() goto enderror
if (%NDWINSYS%)==() goto enderror

cd ..\C6
REM ***************************************************
REM Compile Runtime Package Indy60
REM ***************************************************
REM IdCompressionIntercept can never be built as part of a package.  It has to be compileed separately
REM due to a DCC32 bug.
%NDC6%\bin\dcc32.exe IdCompressionIntercept.pas /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4

%NDC6%\bin\dcc32.exe Indy60.dpk /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
%NDC6%\bin\dcc32.exe IdDummyUnit.pas /LIndy60.dcp /DBCB /O..\Source\objs /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
del IdDummyUnit.dcu >nul
del IdDummyUnit.hpp >nul
del IdDummyUnit.obj >nul

%NDC6%\bin\dcc32.exe Indy60.dpk /M /DBCB /O..\Source\objs /H /W -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
copy Indy60.bpl %NDWINSYS% >nul
del Indy60.bpl > nul

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating Indy60.LIB file, please wait...
%NDC6%\bin\tlib.exe Indy60.lib /P32 @IndyWin32.rsp >nul
if exist ..\C6\Indy60.bak del ..\C6\Indy60.bak >nul

REM ***************************************************
REM Compile Design-time Package RPDT30
REM ***************************************************
%NDC6%\bin\dcc32.exe dclIndy60.dpk /DBCB /O..\Source\objs /H /W /N..\C6 /LIndy60.dcp -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del dclIndy60.dcu >nul
del dclIndy60.dcp >nul
del Indy60.dcu >nul
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

