REM ----------------------------------------------- Einstellungen START -----------------------------------------------
REM Hier festen Laufwerksbuchstaben setzen falls dieser nicht automatisch gewaehlt werden soll (Beispiel: SET driveletter=A: - den Doppelpunkt am Ende nicht vergessen!)
SET driveletter=

REM Einstellungen fuer Dateinamen von Logs und temporaeren Dateien
REM Dateiname des Logs
SET logfile_name=NetworkDriveCheckerLog.txt
REM Dateiname des Logs fuer die Anzahl fehlgeschlagener Ausfuehrungen
SET logfile_failed_times_name=NetworkDriveCheckerLogFailedTimes.txt
REM Dateiname zum Testen des Schreibzugriffs
SET logfile_test_write_access_name=NetworkDriveCheckerTestWriteAccess.txt
REM Name der Testdatei hier festlegen, ansonsten wird ein zufaelliger Name generiert (Beispiel: SET filename=testdatei.txt)
SET filename=

REM Falls gewuenscht wird eine Dummy Datei erstellt und geloescht, falls nicht (=false) wird nur das Netzlaufwerk erstellt und wieder geloescht
SET create_and_delete_dummyfile=true
REM Soll beim ersten Start ein 'Willkommen' Text angezeigt werden?
SET display_welcome_message_on_first_start=true
REM Das aktivieren falls man genauere (Fehler-)Ausgaben moechte ausserdem werden die Ausgaben nicht nach jedem Account (Durchgang) geloescht. Diese Einstellung deaktiviert ebenfalls diverse Wartezeiten!
SET enable_debug_mode=false

REM Einstellungen fuer Fehlerdialoge
REM Fehlerdialog wird gezeigt sobald das Script mehr als x-mal fehlschlaegt.
SET /A max_failures_until_error=3
REM Zeige FehlerDialog falls das Script >= max_failures_until_error fehlschlaegt
SET display_error_dialog_on_too_many_failures=true

REM Wartezeiten fuer Einstellungen
REM Wartezeit vor dem Start (nuetzlich bei der Ausfuehrung direkt nach Benutzeranmeldung, da es einige Sekunden dauern kann, bis Netzwerkverbindungen verfuegbar sind)
SET /A waittime_seconds_before_start=8
REM Wartezeit fuer die "Willkommen" Meldung beim ersten Start des Scripts
SET /A waittime_seconds_display_welcome_message=10
REM Wartezeit bei Fehlern nach denen das Script weiter ausgefuehrt wird ("Nicht-fatale-Fehler")
SET /A waittime_seconds_continue_on_non_fatal_error=60
REM Wartezeit nach der das Fenster bei erfolgreicher Ausfuehrung geschlossen wird
SET /A waittime_seconds_on_successful_ending=10
REM Wartezeit nach der das Fenster bei fehlerhafter Ausfuehrung geschlossen wird
SET /A waittime_seconds_on_bad_ending=180
REM Wartezeit nach jeder ERFOLGREICHEN Account-Pruefung (ansonsten geht es sofort mit dem nächsten Account weiter)
SET /A waittime_seconds_between_successful_account_checks=5

REM Einstellungen special
REM Zeige unter Windows XP keine Fehlermeldung nach dem Start sondern versuche es trotzdem (wird idR nicht funktionieren)
SET force_allow_windows_xp=false
REM Mit folgendem String werden Ausgaben manchmal voneinander getrennt
SET separator=-------------------------------------------------------
REM ----------------------------------------------- Einstellungen ENDE -----------------------------------------------