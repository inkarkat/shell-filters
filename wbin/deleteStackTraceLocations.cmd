@echo off %DEBUG%

call unix --quiet

sed -f "%~dpn0.sed" %*
