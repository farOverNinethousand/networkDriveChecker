@ECHO OFF
REM Main purpose: Keep Bitrix24.de Accounts alive: https://www.mydealz.de/deals/100gb-cloud-speicher-dauerhaft-gratis-dsgvo-konform-1232057

:start
title NetworkDriveChecker v.1.39 by over_nine_thousand

REM Load account settings (Mainly Logindata)
call AccountSettings.cmd
REM Load all other settings
call Settings.cmd

REM recommended according to: http://steve-jansen.github.io/guides/windows-batch-scripting/part-2-variables.html
SETLOCAL ENABLEEXTENSIONS
REM Important for function which generates the random filename and our 'Array': https://ss64.com/nt/delayedexpansion.html
SETLOCAL enableDelayedExpansion
SET me=%~n0
SET parent=%~dp0

color 0a

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
	REM Only wait here if the user wants this
	if defined waittime_seconds_continue_on_non_fatal_error if !waittime_seconds_continue_on_non_fatal_error! GTR 0 (
		echo 3. Mache nichts - in !waittime_seconds_continue_on_non_fatal_error! Sekunden wird die Ausfuehrung automatisch fortgesetzt ...
		echo Warte !waittime_seconds_continue_on_non_fatal_error! Sekunden ...
		ping -n !waittime_seconds_continue_on_non_fatal_error! localhost >NUL
	)
	REM Without write-access we cannot check for first start so let's always skip the 'welcome screen'
	SET display_welcome_message_on_first_start=false
	cls
	color 0a
)

REM Check for old logfiles or first start
if exist !logfile_name! (
	echo !separator!
	echo Inhalt des letzten Logs:
	echo !separator!
	type !logfile_name!
) else (
	REM First start - display welcome message if wished by user
	if defined display_welcome_message_on_first_start if "%display_welcome_message_on_first_start%" == "true" (
		echo Erster Start: Willkommen %logonserver%\%username% - beim NetworkDriveChecker von over_nine_thousand
		if defined waittime_seconds_display_welcome_message if !waittime_seconds_display_welcome_message! GTR 0 (
			if defined enable_debug_mode if "!enable_debug_mode!" == "true" (
				echo Ueberspringe 'waittime_seconds_display_welcome_message', da der Debug-Modus aktiv ist
			) else (
				echo In !waittime_seconds_display_welcome_message! Sekunden geht^'s weiter
				ping -n !waittime_seconds_display_welcome_message! localhost >NUL
			)
			REM Skip start waittime if we're already waiting here
			if defined waittime_seconds_before_start if !waittime_seconds_before_start! GTR 0 (
				echo Ueberspringe !waittime_seconds_before_start! Sekunden 'waittime_seconds_before_start' Start-Wartezeit, da dies der erste Start ist und es fuer diesen bereits eine extra-Wartezeit gibt
				if defined enable_debug_mode if "!enable_debug_mode!" == "true" (
					echo !separator!
					echo Ueberspringe !waittime_seconds_before_start! Sekunden 'waittime_seconds_before_start' Start-Wartezeit, da der Debug-Modus aktiv ist
				)
				SET /A waittime_seconds_before_start=0
			)
		)
	)
)

if defined waittime_seconds_before_start if !waittime_seconds_before_start! GTR 0 (
	echo !separator!
	if defined enable_debug_mode if "!enable_debug_mode!" == "true" (
		echo Ueberspringe 'waittime_seconds_before_start', weil der Debug-Modus aktiv ist
	) else (
		echo Warte !waittime_seconds_before_start! Sekunden vor dem Start um sicherzugehen, dass eine Internetverbindung besteht ^(Beispiel: Erste Anmeldung eines Benutzers nach dem Systemstart^) ...
		ping -n !waittime_seconds_before_start! localhost >NUL
	)
)

REM Find out how many items are in our array
SET /A numberof_accounts=0
:ArrayItemCountLoop

if defined subdomains[%numberof_accounts%] if defined usernames[%numberof_accounts%] if defined passwords[%numberof_accounts%] (
	SET /a numberof_accounts+=1
	GOTO :ArrayItemCountLoop
)
if %numberof_accounts% EQU 0 goto :error_account_array_empty

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
	call echo Pruefe Account: !user_readable_position! von !numberof_accounts! : !usernames[%position%]!
	
	REM Use different filename for each run
	SET filename=!position!_!filename!
	SET full_webdav_path=!protocol!!subdomains[%position%]!.!domain!!relative_webdav_path!
	if defined enable_debug_mode if "!enable_debug_mode!" == "true" echo Erstelle Laufwerk !driveletter! zu Pfad: !full_webdav_path!
	net use !driveletter! "!full_webdav_path!" /persistent:yes /user:!usernames[%position%]! !passwords[%position%]!>nul && (
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
			SET "failed_accounts=!failed_accounts!^, "
		)
		SET failed_accounts=!failed_accounts!!usernames[%position%]!
		
		SET /a position+=1
		SET /a user_readable_position+=1
		GOTO :AccountLoop 
	)
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
	net use !driveletter! /DELETE>nul
	SET /a position+=1
	SET /a user_readable_position+=1
	REM Only wait if user wants it and do not wait if we're processing the last object
	if defined waittime_seconds_between_successful_account_checks if !waittime_seconds_between_successful_account_checks! GTR 0 if !position! LEQ !position_of_last_element! (
		if defined enable_debug_mode if "!enable_debug_mode!" == "true" (
			echo Ueberspringe Wartezeit zwischen AccountPruefungen, da der Debug-Modus aktiv ist
		) else (
			echo ERFOLGREICH ^| Warte !waittime_seconds_between_successful_account_checks! Sekunden bis zur Pruefung des naechsten Accounts ...
			ping -n !waittime_seconds_between_successful_account_checks! localhost >NUL
		)
	)
	GOTO :AccountLoop 
)


REM Delete old logfile
if exist !logfile_name! del !logfile_name!
REM Write new logfile
@echo Letzte Ausfuehrung: %date% ^| %numberof_accounts% Accounts geprueft ^| Davon erfolgreich: %numberof_successful_accounts% ^| Davon fehlgeschlagen: !numberof_failed_accounts! >> %logfile_name%

REM Display results - clear screen if there were no errors
if !numberof_failed_accounts! GEQ 1 (
	REM We have failed accounts --> Show error
	goto :error_login_failures
) else (
	REM Everything went well --> goto nice_ending
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
	REM No logfile with recent value for 'failedtimes' ? Initialize variable only
	SET /A failedtimes=0
)
SET /A failedtimes+=1

SET "account_failure_text_1=Es konnten !failedtimes! Mal infolge nicht alle Accounts geprueft werden."
SET "account_failure_text_2=Problematische Accounts: !failed_accounts!"

REM Display error dialog if the script failed too many times in a row and the user wants to see this error dialog.
if !failedtimes! GEQ !max_failures_until_error! if defined display_error_dialog_on_too_many_failures if "!display_error_dialog_on_too_many_failures!" == "true" (
	msg !username! NetworkDriveChecker: !account_failure_text_1! !account_failure_text_2!
)
REM Write new 'number of failures' to log
@echo !failedtimes! >> !logfile_failed_times_name!
REM ----------- Handling for too many failures END -----------

if defined enable_debug_mode if "!enable_debug_mode!" == "false" cls
color 04
REM Show complete result
echo %numberof_accounts% Accounts geprueft ^| Davon erfolgreich: %numberof_successful_accounts% ^| Davon fehlgeschlagen: !numberof_failed_accounts!
echo Fehler: !account_failure_text_1!
echo !account_failure_text_2!
echo Tipps zur Fehlerbehebung:
echo Hast du gerade keine Internetverbindung?
echo In ^'subdomains^' sollte NICHT die Hauptdomain stehen ^(aktuelle Hauptdomain ^= ^'!domain!^'^) - folgender Host ergibt sich z.B. aus Domain + Subdomain deines ersten Accounts und muss existieren: !subdomains[0]!.!domain! 
echo Blockiert deine Firewall den Zugriff zu !subdomains[0]!.!domain! oder einer der anderen ^(Sub-^)Domains deiner Accounts sofern du mehrere eingetragen hast?
echo Hast du vor kuerzlich eine deiner Domains ^(z.B. !subdomains[0]!^) geaendert und vergessen, diese im Script anzupassen?
echo Hast du vor kurzem dein Passwort ueber die !domain! Webseite geaendert und vergessen, es in diesem Script anzupassen?
echo Hast du Sonderzeichen im Passwort?
REM 2019-09-11: In meinen Tests funktionierten selbst korrekt maskierte Sonderzeichen nicht. Daher sollte man die Verwendung dieser vermeiden.
echo Vermeide Sonderzeichen im Passwort - insbesondere folgende: Leerzeichen und folgende Zeichen: ^| %% ^^ ^& ^< ^> ^' ^=
echo Falls du dennoch Sonderzeichen verwenden moechtest, musst du diese ggf. im Script ^'maskieren^' - hier eine Tabelle dazu: https://www.robvanderwoude.com/escapechars.php
echo In meinen Tests konnte ich trotz Maskierung nur wenige Sonderzeichen verwenden - Tipps dazu gerne per Github Issue oder PN an mich schicken ;^)
echo Getestete und funktionierende Sonderzeichen^(keine Maskierung notwendig^): *
echo Hast du die Standard-Ordnerstruktur von bitrix24 geloescht? Dann musst du auch ^'relative_webdav_path^' im Script anpassen^^!^^!
echo Hast du dieses Script direkt nach dem Start deines Betriebssystems ^(automatisiert?^) gestartet? Dann muss es vor der Ausfuehrung vielleicht laenger warten bis die Netzwerkverbindungen hergestellt sind - erhoehe den folgenden Wert im Script: waittime_seconds_before_start
echo Pruefe, ob du das Netzlaufwerk manuell hinzufuegen kannst - klappt das nicht ist klar, dass auch das Script nicht funktionieren kann: https://helpdesk.bitrix24.de/open/8546673/
echo Um genauere Fehlerausgaben zu erhalten, aendere die Zeile ^'enable_debug_mode=false^' zu ^'enable_debug_mode=true^' und lasse dieses Script erneut laufen.
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
REM One or more errors occured
if defined waittime_seconds_on_bad_ending if !waittime_seconds_on_bad_ending! GTR 0 (
	echo Dieses Fenster wird in !waittime_seconds_on_bad_ending! Sekunden geschlossen
	ping -n !waittime_seconds_on_bad_ending! localhost >NUL
) else (
	echo Druecke ENTER zum Beenden
	pause>nul
)
exit



:nice_ending
REM Everything went well :)
REM Cleanup: Delete file which contains number of failed times as we only want this to trigger an errormessage if this script ends with errors several times in a row
if exist !logfile_failed_times_name! (
	if defined enable_debug_mode if "!enable_debug_mode!" == "true" (
		echo Im letzten Durchgang passierten Fehler, aber in diesem nicht - loesche Fehler-Zaehler-Datei !logfile_failed_times_name!
	)
	del !logfile_failed_times_name!
)
if defined enable_debug_mode if "!enable_debug_mode!" == "true" (
	REM Kein cls ausfuehren, da wir im debug-Modus sind
	echo Ueberspringe clearscreen, da der Debug-Modus aktiv ist
) else (
	cls
)
echo ERFOLG ^| ALLE !numberof_accounts! Account^(s^) wurden erfolgreich geprueft :^)
if defined waittime_seconds_on_successful_ending if !waittime_seconds_on_successful_ending! GTR 0 (
	echo Dieses Fenster wird in !waittime_seconds_on_successful_ending! Sekunden geschlossen
	ping -n !waittime_seconds_on_successful_ending! localhost >NUL
)
exit