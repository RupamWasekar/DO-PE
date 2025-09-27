@echo off
setlocal enabledelayedexpansion

REM === Config ===
set TEST_PLAN=%1
set RESULTS_DIR_REPORT=C:\dockerJMeter\results\reports
set RESULTS_DIR_JTL=C:\dockerJMeter\results\jtl
set RESULTS_DIR_LOG=C:\dockerJMeter\results\logs



REM Ensure results directories exist
if not exist "%RESULTS_DIR_JTL%" mkdir "%RESULTS_DIR_JTL%"
if not exist "%RESULTS_DIR_LOG%" mkdir "%RESULTS_DIR_LOG%"
if not exist "%RESULTS_DIR_REPORT%" mkdir "%RESULTS_DIR_REPORT%"


REM Get today’s date (YYYY-MM-DD)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set ldt=%%I
set TODAY=!ldt:~0,4!-!ldt:~4,2!-!ldt:~6,2!

REM Find next available number for JTL file
set i=1
:check_jtl
if exist "%RESULTS_DIR_JTL%\dockerJMeterTest_%TODAY%_!i!.jtl" (
    set /a i+=1
    goto :check_jtl
)

set RESULT_FILE=dockerJMeterTest_%TODAY%_!i!.jtl
set LOG_FILE=dockerJMeterLog_%TODAY%_!i!.log
set REPORT_FOLDER=dockerJMeterReport_%TODAY%_!i!


echo 📊 Saving results to %RESULTS_DIR%\%RESULT_FILE%
echo 📝 Saving JMeter log to %RESULTS_DIR_LOG%\%LOG_FILE%
echo 📂 Generating HTML report in %REPORT_FOLDER%



REM Run JMeter in Docker with correct output file
docker exec -it jmeter jmeter -n -t /tests/%TEST_PLAN% -l /results/jtl/%RESULT_FILE% -j /results/logs/%LOG_FILE%

REM Generate HTML report
docker exec -it jmeter jmeter -g /results/jtl/%RESULT_FILE% -o /results/reports/%REPORT_FOLDER%


echo ✅ Test finished.
echo JTL results: %RESULT_FILE%
echo Logs: %LOG_FILE%
echo HTML report folder: %REPORT_FOLDER%
