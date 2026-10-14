@echo off
if exist LastModifyList.txt (del LastModifyList.txt)
python csv2lua_dev.py vn
python csv2py.py vn
pause