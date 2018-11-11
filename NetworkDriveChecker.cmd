@ECHO OFF
REM Main purpose: Keep Bitrix24.de Accounts alive: https://www.mydealz.de/deals/100gb-cloud-speicher-dauerhaft-gratis-dsgvo-konform-1232057

:start
title NetworkDriveChecker v.1.0 by over_nine_thousand - MyDealz

REM recommended according to: http://steve-jansen.github.io/guides/windows-batch-scripting/part-2-variables.html
SETLOCAL ENABLEEXTENSIONS
REM Important for function which generates the random filename: https://ss64.com/nt/delayedexpansion.html
SETLOCAL enableDelayedExpansion
SET me=%~n0
SET parent=%~dp0
REM Newline, THX: https://stackoverflow.com/questions/132799/how-can-you-echo-a-newline-in-batch-files
REM (set \NL=^
REM %=Do not remove this line=%
REM )
REM Usage: Newline!\NL!Here

color 0a

REM ----------------------------------------------- Einstellungen START -----------------------------------------------
REM Hier festen Laufwerksbuchstaben setzen falls dieser nicht automatisch gewaehlt werden soll (Beispiel: SET driveletter=A:)
SET driveletter=

REM Name der Testdatei hier festlegen, ansonsten wird ein zufaelliger Name generiert (Beispiel: SET filename=testdatei.txt)
SET filename=

REM Dateinamen saemtlicher vom Script eventuell zu erstellenden Dateien
REM Dateiname des Logs
SET logfile_name=NetworkDriveCheckerLog.txt
REM Dateiname des Logs fuer die Anzahl fehlgeschlagener Ausfuehrungen
SET logfile_failed_times_name=NetworkDriveCheckerLogFailedTimes.txt
REM Dateiname zum Testen des Schreibzugriffs
SET logfile_test_write_access_name=NetworkDriveCheckerTestWriteAccess.txt

REM Falls gewuenscht wird eine Dummy Datei erstellt und geloescht, falls nicht (=false) wird nur das Netzlaufwerk erstellt und wieder geloescht
SET create_and_delete_dummyfile=true
REM Soll beim ersten Start ein 'Willkommen' Text angezeigt werden?
SET display_welcome_message_on_first_start=true
REM Das aktivieren falls man genauere (Fehler-)Ausgaben moechte ausserdem werden die Ausgaben dann nicht nach jedem Account (Durchgang) geloescht
SET enable_debug_mode=false

REM Fehlerdialog wird gezeigt sobald das Script mehr als x-mal fehlschlaegt.
SET /A max_failures_until_error=3
REM Zeige FehlerDialog falls das Script >= max_failures_until_error fehlschlaegt
SET display_error_dialog_on_too_many_failures=true
REM Zeige unter Windows XP keine Fehlermeldung nach dem Start sondern versuche es trotzdem (wird idR nicht funktionieren)
SET force_allow_windows_xp=false

REM Zugangsdaten hier eintragen
SET "domains[0]=test1.bitrix24.de"
SET "domains[1]=test2.bitrix24.de"
SET "domains[2]=test3.bitrix24.de"
SET "domains[3]=test4.bitrix24.de"

SET "usernames[0]=user1"
SET "usernames[1]=user2"
SET "usernames[2]=user3"
SET "usernames[3]=user4"

SET "passwords[0]=password1"
SET "passwords[1]=password2"
SET "passwords[2]=password3"
SET "passwords[3]=password4"
REM ----------------------------------------------- Einstellungen ENDE -----------------------------------------------

REM Check for unsupported OS
REM thx: https://stackoverflow.com/questions/13212033/get-windows-version-in-a-batch-file (although this script does not find my windows 7 correctly but here we only want to identify XP)
ver | find "XP" > nul
if %ERRORLEVEL% == 0 if defined force_allow_windows_xp if "%force_allow_windows_xp%" == "false" (
	goto :error_windows_xp_unsupported
)
if %ERRORLEVEL% == 0 (
	echo Warnung: Windows XP wird nicht unterstuetzt, aber das Script wird es trotzdem versuchen, da 'force_allow_windows_xp' auf true gesetzt wurde ...
)

REM Check for write access and show warning if we do not have write access
type NUL > !logfile_test_write_access_name!
if exist !logfile_test_write_access_name! (
	REM Delete testfile again
	DEL !logfile_test_write_access_name!
) else (
	cls
	color 04
	REM Display message box so that user can see it even when executing this script without visible window.
	msg "%username%" NetworkDriveChecker: Keine Schreibrechte
	echo Fehler: Keine Schreibrechte^! Dieses Script laeuft auch ohne Adminrechte, aber kann dich dann nicht ueber fehlgeschlagene Logins informieren^!^!
	echo Moegliche Fehlerursachen und Loesungen:
	echo 1. Du verwendest das Script per Windows Zeitplaner? Gehe sicher, dass es als Admin gestartet wird falls es sich nicht unterhalb des Benutzerordners befindet ^("C:\Users\DeinBenutzername\bla"^) oder gib in der Aufgabenplanung im Feld "Starten in" einen Pfad unterhalb des Benutzerordners an.
	echo 2. Du hast dieses Script einfach so gestartet? Gehe sicher, dass sich das Script unterhalb des Benutzerordners befindet ^("C:\Users\DeinBenutzername\bla"^) oder starte es als Admin.
	echo 3. Mache nichts - in 60 Sekunden wird die Ausfuehrung automatisch fortgesetzt ...
	echo Warte 60 Sekunden ...
	ping -n 60 localhost >NUL
	REM Without write-access we cannot check for first start so let's always skip the 'welcome screen'
	SET display_welcome_message_on_first_start=false
	cls
	color 0a
)

REM Check for old logfiles or first start
if exist %logfile_name% (
	type %logfile_name%
) else (
	REM First start - display welcome message if wished by user
	if defined display_welcome_message_on_first_start if "%display_welcome_message_on_first_start%" == "true" (
		echo Erster Start: Willkommen %logonserver%\%username% - beim NetworkDriveChecker von over_nine_thousand
		echo In 10 Sekunden geht^'s los
		ping -n 10 localhost >NUL
	)
)

REM Find out how many items are in our array
SET /A numberof_accounts=0
:ArrayItemCountLoop

if defined domains[%numberof_accounts%] if defined usernames[%numberof_accounts%] if defined passwords[%numberof_accounts%] (
	SET /a numberof_accounts+=1
	GOTO :ArrayItemCountLoop
)

:find_free_drive_letter
if not defined driveletter (
	echo Suche freien Laufwerksbuchstaben
	REM Alphabet reverted, da viele User Laufwerksbuchstaben am Anfang des Alphabets bereits verwendet haben
	for %%F in (Z, Y, X, W, V, U, T, S, R, Q, P, O, N, M, L, K, J, I, H, G, F, E, D, C, B, A) do (
		REM Hier nochmal pruefen, ob bereits ein Laufwerksbuchstabe gefunden wurde damit die Schleife zuende laufen kann und wir nicht ueber eine Funktion herrausspringen muessen
		if not defined driveletter (
				if exist %%F: (
						if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Laufwerksbuchstabe %%F ist vergeben
					) else (
						if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Laufwerksbuchstabe %%F ist FREI
						SET driveletter=%%F:
					)
				)
			)
) else (
	if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Verwende voreingestellten Laufwerksbuchstaben %driveletter%
)

REM Zeige Fehlermeldung, falls kein freier Laufwerksbuchstabe gefunden wird was EXTREM unwahrscheinlich ist.
if not defined driveletter goto :error_failed_to_find_free_drive_letter
REM Erzeuge zufaelligen Dateinamen, falls der Benutzer keinen festgelegt hat
REM TODO: Das springt danach in :login und sorgt damit bei Aenderungen oft für Bugs - irgendwie verbessern!
if not defined filename goto :generate_random_filename

:login
if %numberof_accounts% EQU 0 goto :error_account_array_empty

SET /A position=0
SET /A user_readable_position=1
SET /A position_of_last_element=%numberof_accounts%-1
SET /A numberof_failed_accounts=0
SET /A numberof_successful_accounts=0

SET failed_accounts=

:AccountLoop

REM Important for the loop to work correctly!
setlocal enableDelayedExpansion
if %position% LSS %numberof_accounts% (
	REM Clear screen after every loop if we're not in debug mode
	if defined enable_debug_mode if "!enable_debug_mode!" == "false" cls
	REM Dateiname ist fuer jeden Durchgang minimal anders
	call echo Pruefe Account: %user_readable_position% of %numberof_accounts% : %%usernames[%position%]%%
	
	REM Use different filename for each run
	SET filename=!position!_!filename!
	if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Erstelle Laufwerk %driveletter%
	net use %driveletter% "https://!domains[%position%]!/company/personal/user/1/disk/path/Offene sichtbare Gruppe/" /persistent:yes /user:!usernames[%position%]! !passwords[%position%]!>nul && (
		REM Login was successful
		REM Increase counter of failed accounts
		SET /a numberof_successful_accounts+=1
	) || (
		REM Login failed - continue to next account
		echo Fehler: !usernames[%position%]!: Zugangsdaten sind eventuell ungueltig
		REM Increase counter of failed accounts
		SET /a numberof_failed_accounts+=1
		REM Collect usernames of failed accounts
		if defined failed_accounts (
			SET failed_accounts=!failed_accounts!^,
		)
		SET failed_accounts=!failed_accounts!!usernames[%position%]!
		
		SET /a position+=1
		SET /a user_readable_position+=1
		GOTO :AccountLoop 
	)
	ping -n 10 localhost >NUL
	REM Datei nur erstellen- und wieder loeschen falls vom Benutzer gewuenscht
	if defined create_and_delete_dummyfile if "%create_and_delete_dummyfile%" == "true" (
		if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Erstelle Datei %filename%
		type NUL > "%driveletter%\%filename%"
		if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Loesche Datei %filename%
		del "%driveletter%\%filename%"
	) else (
		if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Erstelle KEINE Datei
	)
	if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Trenne Laufwerk %driveletter%
	net use %driveletter% /DELETE>nul
	SET /a position+=1
	SET /a user_readable_position+=1
	GOTO :AccountLoop 
)


SET result_text=%numberof_accounts% Accounts geprueft _ Davon erfolgreich: %numberof_successful_accounts% _ Davon fehlgeschlagen: !numberof_failed_accounts!
REM Delete old logfile
if exist %logfile_name% del %logfile_name%
REM Write new logfile
@echo Letzte Ausfuehrung: %date% ^| %result_text% >> %logfile_name%

REM Display results - clear screen if there were no errors
if !numberof_failed_accounts! GEQ 1 (
	REM We have failed accounts --> Show error
	echo %result_text%
	goto :error_login_failures
) else (
	REM Everything went well
)

goto :nice_ending



REM Stolen from: https://superuser.com/questions/349474/how-do-you-make-a-letter-password-generator-in-batch/734014#734014
:generate_random_filename
Set _RNDLength=16
Set _Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
Set _Str=%_Alphanumeric%987654321
:_LenLoop
IF NOT "%_Str:~18%"=="" SET _Str=%_Str:~9%& SET /A _Len+=9& GOTO :_LenLoop
SET _tmp=%_Str:~9,1%
SET /A _Len=_Len+_tmp
Set _count=0
SET filename=
:_loop
Set /a _count+=1
SET _RND=%Random%
Set /A _RND=_RND%%%_Len%
SET filename=!filename!!_Alphanumeric:~%_RND%,1!
If !_count! lss 16 goto _loop
SET filename=%filename%.txt
REM Mache dort weiter wo die Funktion aufgerufen wurde
goto :login


REM Fehlermeldung, die nie erscheinen sollte
:error_failed_to_find_free_drive_letter
cls
color 04
echo Fehler: WTF Kein freier Laufwerksbuchstabe gefunden
goto :bad_ending

REM Benutzer hat vermutlich Syntaxfehler in den Arrays mit den Zugangsdaten
:error_account_array_empty
cls
color 04
echo Fehler: Keine Accounts gefunden^^!
echo Eventuell hast du einen Syntaxfehler verursacht.
echo Gehe sicher dass du deine Zugangsdaten korrekt eintraegst^^!
goto :bad_ending

REM Benutzer hat vermutlich Syntaxfehler in den Arrays mit den Zugangsdaten
:error_login_failures
REM Write usernames of failed accounts in logfile

@echo Fehlgeschlagene Accounts !failed_accounts! >> !logfile_name!
REM ----------- Handling for too many failures START -----------
if exist !logfile_failed_times_name! (
	SET /P failedtimes=<!logfile_failed_times_name!
	REM Delete old logfile as it will get replaced by the new one later
	DEL !logfile_failed_times_name!
) else (
	SET /A failedtimes=0
)
echo failedtimes ist !failedtimes!
SET /A failedtimes+=1
echo failedtimes ist !failedtimes!

SET account_failure_text_1=Es konnten !failedtimes! mal infolge nicht alle Accounts geprueft werden^^!
SET account_failure_text_2=Die Zugangsdaten folgender Accounts sind eventuell ungueltig: !failed_accounts!

REM Display error dialog if the script failed too many times in a row and the user wants to see this error dialog.
if !failedtimes! GEQ !max_failures_until_error! if defined display_error_dialog_on_too_many_failures if "!display_error_dialog_on_too_many_failures!" == "true" (
	msg "%username%" NetworkDriveChecker: !account_failure_text_1! !account_failure_text_2!
)
REM Write new 'number of failures' to log
@echo !failedtimes! >> !logfile_failed_times_name!
REM ----------- Handling for too many failures END -----------

REM Do NOT clear screen so that the user can easily track what went wrong
cls
color 04
echo Fehler: !account_failure_text_1!
echo Fehler: !account_failure_text_2!
echo Hast du vor kurzem dein Passwort geaendert?
REM In Tests funktionierten selbst korrekt 'escapte' Sonderzeichen nicht. Daher sollte man die Verwendung dieser vermeiden.
echo Hast du Sonderzeichen im Passwort?
echo Vermeide Sonderzeichen, vorallem folgende: ^| %% ^^ ^& ^< ^> ^' ^=
echo Getestete und funktionierende Sonderzeichen: *
echo Hast du vor kurzem deine Domain ^^(xyz.bitrix24.de^^) geaendert?
echo Falls Du bitrix24 Accounts verwendest, gehe sicher, dass du dich regelmaessig einloggst, da diese nach 6 Wochen ohne Login geloescht werden^^!
goto :bad_ending

:error_windows_xp_unsupported
cls
color 04
echo Fehler: Windows XP wird nicht unterstuetzt, da es keine https Unterstuetzung fuer WebDAV hat^^!
echo Helfen kann eine Kombination mehrerer Workarounds ^(oder der Umstieg auf ein neueres Microsoft Betriebssystem^):
echo http://wazem.blogspot.com/2013/05/how-to-map-secure-webdav-share-on.html
echo und:
echo https://support.microsoft.com/de-de/help/841215/error-message-when-you-try-to-connect-to-a-windows-sharepoint-document
echo Damit diese Warnung beim naechsten Versuch unter Windows XP nicht angezeigt wird, setze 'force_allow_windows_xp' auf 'true'
goto :bad_ending



:bad_ending
echo Druecke ENTER zum Beenden
pause>nul
exit



:nice_ending
REM Everything went well :)
REM Cleanup: Delete file which contains number of failed times as we only want this to trigger an errormessage if it fails several times in a row
if exist !logfile_failed_times_name! (
	del !logfile_failed_times_name!
)
cls
echo ALLE %numberof_accounts% Account^(s^) wurden erfolgreich geprueft :^)
echo Das Fenster wird in 10 Sekunden geschlossen
ping -n 10 localhost >NUL
exit