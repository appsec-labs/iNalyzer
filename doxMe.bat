@echo off

REM Change to the directory where the script lives (when invoked with
REM "Run As Administrator"
cd %~dp0

REM Check to see if graphviz.exe and dot.exe are in the PATH
doxygen >NUL 2>NUL
IF %ERRORLEVEL% NEQ 1 GOTO NODOXYGEN
dot -h >NUL 2>NUL
IF %ERRORLEVEL% NEQ 1 GOTO NOGRAPHVIZ

GOTO RUN

:NODOXYGEN
echo.
echo I can't find an installed copy of Doxygen executables in your PATH.
GOTO INSTALLERROR

:NOGRAPHVIZ
echo.
echo I can't find an installed copy of Graphviz executables in your PATH.

:INSTALLERROR
echo.
echo Please be sure to install Doxygen and GraphViz, adding their "bin"
echo directories to your PATH before running this script.
echo.
pause
exit

:RUN
doxygen.exe dox.template
start html/index.html
pause
exit
