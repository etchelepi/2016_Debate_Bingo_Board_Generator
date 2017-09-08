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

echo "END GENERATE TWEETS"

set /a total_quotes = 0 + %clinton_total_quotes% + %trump_total_quotes

REM echo %trump_total_quotes%
REM echo %clinton_total_quotes%
REM echo %total_quotes%

setlocal enabledelayedexpansion enableextensions
set i=-1
FOR /L %%G IN (1,1,%total_quotes%) DO (

 set /a i=!i!+1
 set suffled_list[!i!]=%%G
)
set lastindex=!i!

REM for /L %%G in (0,1,!lastindex!) do ( 
REM   echo !suffled_list[%%G]!
REM )
echo THIS IS THE DEBUG LOCATION
set /A tot = %total_quotes% - 1
echo the total is %tot%
set lis=


for /L %%i in (0,1,%tot%) do (
   set /A ran=!RANDOM! * %tot% / 32768 + 1
   set /A j=!ran!
   REM SAVE THE ORGINAL VALUE
   set /A TEM= !suffled_list[%%i]!
   REM SAVE THE VALUE AT THE RANDOM LOCATION
   for %%j in (!j!) do set /A TEMJ = !suffled_list[%%j]!
   REM set i to be the J value
   set /A suffled_list[%%i] = !TEMJ!
   REM set j to be the value of i
   for %%j in (!j!) do set suffled_list[%%j]=!TEM!
)
echo PRINT LIST
REM for /L %%G in (0,1,!lastindex!) do ( 
REM   echo !suffled_list[%%G]!
REM )
REM WE GENERATE THE BOARD FROM THE FIRST 24

REM We need to loop through the 25 first elements.
REM For each value returned we check if it's even or odd
REM if even we put the hilary pretext, odd we put the trump
REM we then append the number to the end so we have something like %HIL_or_trump%_tweets\%hilary_or_trump%_tweet_%number%.png
REM then this massive string is put into IMAGE MAGIC. Special case is for element 24 we just use a fixed tweet

for /L %%G in (0,1,24) do ( 
  set /A temp_var=!suffled_list[%%G]! %%2
  set other_var=!suffled_list[%%G]!
  IF  %%G == 12 (
	 set lis= !lis!resource\free.png 
  ) ELSE (
	  IF !temp_var! == 0 (
		  set lis= !lis!clinton_tweets\clinton_tweet_!other_var!.png 
			
		) ELSE (
			set lis= !lis!trump_tweets\trump_tweet_!other_var!.png 
		)
	)
)


echo ONCE
call magick montage !lis! -mode Concatenate -tile 5x5  montage_array.jpg
echo other
call magick montage  resource\banner.png montage_array.jpg resource\footer.png -mode Concatenate -tile x3  montage_array_Result_%RANDOM%.jpg