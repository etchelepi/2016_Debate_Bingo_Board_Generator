@echo off


setlocal ENABLEDELAYEDEXPANSION
set /a total_quotes = 0;

REM This generates the TRUMP tweets
set /a c =-1
for /F "tokens=*" %%A in (resource/trumpisims.txt) do (
set /a c = c + 2
copy /Y resource\trump.svg resource\temp.svg
CALL BatchSubsitute.bat REPLACE "%%A" resource\temp.svg
inkscape --export-png=trump_tweets/trump_tweet_!c!.png resource/temp.svg
)
set /a trump_total_quotes = !c!/2

REM This generates the HILLARY Tweets
set /a c =0
for /F "tokens=*" %%A in (resource/clintonsays.txt) do (
set /a c = c + 2
copy /Y resource\clinton.svg resource\temp.svg
CALL BatchSubsitute.bat REPLACE "%%A" resource\temp.svg
inkscape --export-png=clinton_tweets/clinton_tweet_!c!.png resource/temp.svg
)
set /a clinton_total_quotes = !c!/2

set /a total_quotes = 0 + %clinton_total_quotes% + %trump_total_quotes

echo "END GENERATE TWEETS"


for /L %%i in (0,1,%total_quotes%) do (
	CALL makeboard.bat
)
