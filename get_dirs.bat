echo off
for /d %%a in (*) do dir /ad /on /s /b "%%a" >> get_dirs.txt