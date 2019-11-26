@echo off %DEBUG%

call unix --quiet

sed -f "%TOOLBOXHOME%\Unixhome\bin\ingo\shell-filters\bin\%~n0" %*
