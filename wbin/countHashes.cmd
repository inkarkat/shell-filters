@echo off %DEBUG%

call unix --quiet

sed -f "%~dp0\..\bin\%~n0" %*
