@echo off %DEBUG%

call unix --quiet

sed -f "%TOOLBOXHOME%\Unixhome\bin\ingo\shell-filters\wbin\%~n0.sed" %*
