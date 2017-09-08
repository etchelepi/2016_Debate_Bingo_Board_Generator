@echo off

setlocal ENABLEDELAYEDEXPANSION
set /a total_quotes = 0;
REM This generates the TRUMP tweets
set /a c =-1
for /F "tokens=*" %%A in (resource/trumpisims.txt) do (
set /a c = c + 2
)
set /a trump_total_quotes = !c!/2

REM This generates the HILLARY Tweets
set /a c =0
for /F "tokens=*" %%A in (resource/clintonsays.txt) do (
set /a c = c + 2
)
set /a clinton_total_quotes = !c!/2

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
set /A tot = %total_quotes% - 1
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
call magick montage !lis! -mode Concatenate -tile 5x5  montage_array.jpg
call magick montage  resource\banner.png montage_array.jpg resource\footer.png -mode Concatenate -tile x3  montage_array_Result_%RANDOM%.jpg