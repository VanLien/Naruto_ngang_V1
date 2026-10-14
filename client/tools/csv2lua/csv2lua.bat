@echo off
cd /d "%~dp0"

if exist LastModifyList.txt del LastModifyList.txt

"C:\Python27\python.exe" csv2lua.py cn

pause