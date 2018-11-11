# NetworkDriveChecker
Prüft ein- oder mehrere passwortgeschützte Netzlaufwerke
Keep bitrix24.de Accounts alive | bewahrt bitrix24.de Accounts vor Inaktivitätslöschung!

## Was macht das Skript?
Es loggt sich automatisch in Netzlaufwerke ein und löscht diese wieder
Damit kann man diese zum Beispiel vor einer Löschung durch Inaktivität zu bewahren (Beispiel-Anbieter: bitrix24.de) oder einfach nur prüfen.

## Kompatibilität
Das Script sollte auf allen Betriebssystemen nach Windows XP laufen (auf XP nicht, dazu mehr am Ende dieser Readme!)

##  Installation

1. Kopiere alle Dateien dieses Projektes in einen Ordner unterhalb des Benutzerordners zum Beispiel: "C:\Users\DeinBenutzername\Documents\networkDriveChecker"

2. Trage deine (bitrix24.de) Zugangsdaten in das Script (NetworkDriveChecker.cmd) ein:
Ganz oben im Skript unter 'domains', 'usernames' und 'passwords'.
Wichtig: Lösche die Dummy-Einträge falls du z.B. nur einen Account hast (dann die Zeilen SET domains[1]=test2.bitrix24.de usw. löschen.)
Außerdem wichtig: Vermeide Sonderzeichen im Passwort - es gibt nur wenige, die erlaubt sind.

3. Starte die "NetworkDriveChecker.cmd" einmal testweise per Doppelklick.
Solltest du Fehlermeldungen bekommen, schaue weiter unten in dieser Readme.

4. Trage die "NetworkDriveCheckerForWindowsScheduler.vbs" in die Windows Aufgabenplanung ein:

https://praxistipps.chip.de/windows-task-scheduler-aufgaben-in-windows-erstellen_28308

Wichtig ist vor allem, dass das Script entweder als Admin gestartet wird oder das "Ausführen in" Feld korrekt ausgefüllt wird:
![alt text](https://raw.githubusercontent.com/farOverNinethousand/networkDriveChecker/master/Screenshots/2018_11_11_Screenshot_Windows_Aufgabenplanung_Starten_in.png "Windows Aufgabenplanung")

5. Teste das Script innerhalb der Aufgabenplanung, indem du die Aufgabe markierst und rechts auf "Ausführen" klickst.
Funktioniert alles einwandfrei, solltest du während der Ausführung sehen, dass im Explorer Netzlaufwerke erstellt- und wieder gelöscht werden.
Sollte es wiederholt zu Problemen bei der Ausführung kommen, wird eine Fehlermeldung angezeigt (siehe auch Einstellungsmöglichkeiten des Scripts).

## Welche Einstellungsmöglichkeiten habe ich im Script (nur die wichtigen)?

1. Allgemeine Einstellungen
* Immer einen bestimmten Laufwerksbuchstaben erzwingen: SET driveletter=Z:
* Name der Testdatei selbst festlegen: SET filename=testname.txt
* Festlegen, ob nach erfolgreichem Login eine Testdatei erstellt und wieder gelöscht werden soll (zur Erhaltung von Bitrix24 Accounts irrelevant): SET create_and_delete_dummyfile=true|false
* SET display_welcome_message_on_first_start=true|false --> 'Willkommen' Text bei der ersten Ausführung des Scripts zeigen/nicht zeigen

2. Einstellungen zu Logging und Fehlermeldungen
* max_failures_until_error = Max Anzahl fehlgeschlagener Script Ausführungen hintereinander --> Dann FehlerDialog
* SET display_error_dialog_on_too_many_failures=true|false --> Fehlerdialog zeigen oder nicht zeigen (es geht nur um die dialogbox nicht um die Meldungen in der Kommandozeile!)

Beispiel: Du startest dieses Script jede Woche 1x, Fehlerdialoge sind aktiviert (SET display_error_dialog_on_too_many_failures=true) und max_failures_until_error = 3.
Sobald das Script das dritte Mal infolge (= in Woche 3) gestartet wird und es Fehler gibt, wird so ein Dialog angezeigt:
![alt text](https://raw.githubusercontent.com/farOverNinethousand/networkDriveChecker/master/Screenshots/2018_11_06_ErrorDialog.png "Screenshot FehlerDialog")

3. Erweiterte Einstellungen

SET enable_debug_mode=true|false --> Zeigt genauere Ausgaben zu dem was aktuell passiert.
Ist für normale Anwender unnötig, da das zu sehr vielen Ausgaben führt und man dann schnell den Überblick verliert.

## Bei mir werden keine Logdateien erstellt - was kann ich tun?
Je nach dem wo das Script liegt kann es sein, dass Adminrechte zur Ausführung benötigt werden (zum Beispiel direkt auf C:).
Starte das Script als Administrator oder lege as an einen Ort in deinem Benutzerverzeichnis zum Beispiel auf den Desktop oder in den "Dokumente" Ordner (zB "C:\Users\DeinBenutzername\Documents\").

Allgemein braucht dieses Script KEINE Adminrechte um zu funktionieren, aber um Fehlermeldungen zuverlässig anzeigen zu können sollte es in seinem Verzeichnis Schreibrechte haben!

## Ich habe einen Fehler gefunden - wo kann ich diesen melden?
Entweder über GitHub oder über MyDealz: https://www.mydealz.de/profile/over_nine_thousand/overview#activity

## Wie mache ich das unter Linux?
Sorry, dafür gibt es noch keine Lösung (in diesem Repository).

## Der folgende Teil richtet sich ausschließlich an bitrix24.de User:

## Warum wurde dieses Script ursprünglich geschrieben?
Um automatisiert die Accounts des Anbieters bitrix24.de aktiv zu halten und wegen eines Deals auf MyDealz durch den man sich dort 100GB Cloud Speicher permanent holen konnte: https://www.mydealz.de/deals/100gb-cloud-speicher-dauerhaft-gratis-dsgvo-konform-1232057

Bitrix24 löscht Accounts, sofern man sich nicht alle 6 Wochen mindestens einmal einloggt.
Man erhält nach 4 Wochen (hier 33 Tage) die erste Warnung ("Ihr Account wird in 14 Tagen gelöscht") und nach 5 Wochen die zweite und eventuell letzte Warnung ("Ihr Account wird in 7 Tagen gelöscht").

## Wie oft sollte man das Script ausführen, damit Bitrix24 Accounts sicher nicht gelöscht werden?
Jede woche einmal.

## Troubleshooting für Windows XP Benutzer
Windows XP hat leider keine https Unterstützung für WebDAV daher wird man beim Start dieses Scripts idR eine 'Systemfehler 67' oder auch 'Systemfehler 5' Fehlermeldung bekommen.
Abgesehen davon, dass man Windows XP heutzutage sowieso nicht mehr nutzen sollte, kann man folgende Workarounds ZUSAMMEN probieren:

https://support.microsoft.com/de-de/help/841215/error-message-when-you-try-to-connect-to-a-windows-sharepoint-document

und

http://wazem.blogspot.com/2013/05/how-to-map-secure-webdav-share-on.html

Danach im Script folgende Einstellung auf 'true' setzen: force_allow_windows_xp UND in folgender Zeile das 'https://' durch 'http://' ersetzen: https://!domains[%position%]!/company/personal/user/1/disk/path/Offene sichtbare Gruppe/

Die Workarounds führen nicht zwangsläufig zum Erfolg!!