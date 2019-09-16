@ECHO OFF
setlocal enableDelayedExpansion
color 0a

REM ----------------------------------------------- Einstellungen START -----------------------------------------------
REM Dateiname zum Testen des Schreibzugriffs
SET logfile_test_write_access_name=NetworkDriveCheckerTestWriteAccess.txt
REM ----------------------------------------------- Einstellungen ENDE -----------------------------------------------

echo Erstelle Testdatei !logfile_test_write_access_name!

type NUL > !logfile_test_write_access_name!
if exist !logfile_test_write_access_name! (
	echo Schreibrechte verfuegbar - loesche Testdatei !logfile_test_write_access_name!
	DEL !logfile_test_write_access_name!
) else (
	color 04
	echo Keine Schreibrechte verfuegbar^^!^^!
)

pause