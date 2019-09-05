
# NetworkDriveChecker
Prüft ein- oder mehrere passwortgeschützte Netzlaufwerke |  bewahrt bitrix24.de Accounts vor Inaktivitätslöschung!

## Was macht das Script?
Es loggt sich automatisch in Netzlaufwerke ein und löscht diese wieder.
Damit kann man z.B. Accounts vor einer Löschung durch Inaktivität zu bewahren (Beispiel-Anbieter: bitrix24.de) oder einfach nur Zugänge prüfen.

## Kompatibilität
Das Script sollte auf allen Betriebssystemen nach Windows XP laufen (auf XP nicht, dazu mehr am Ende dieser Readme!)
Infos zu einer möglichen Linux Version finden sich weiter unten in diesem Dokument.

##  Installation

1. Kopiere alle Dateien dieses Projektes in einen Ordner unterhalb des Benutzerordners zum Beispiel: "C:\Users\DeinBenutzername\Documents\networkDriveChecker"

2. Trage deine (bitrix24.de) Zugangsdaten in das Script (NetworkDriveChecker.cmd) ein:
Ganz oben im Script unter 'subdomains', 'usernames' und 'passwords'.
Wichtig: Lösche die restlichen Dummy-Einträge falls du z.B. nur einen Account hast (in dem Fall die Zeilen 'SET subdomains[1]=test2-bla' usw. löschen.)
Außerdem wichtig: Vermeide Sonderzeichen im Passwort - es gibt nur wenige, die erlaubt sind.

3. Starte die "NetworkDriveChecker.cmd" einmal testweise per Doppelklick.
Solltest du Fehlermeldungen bekommen, schaue weiter unten in dieser Readme.

4. Sobald das Script ohne Fehlermeldungen läuft kannst du es per  "NetworkDriveCheckerForWindowsScheduler.vbs" in die Windows Aufgabenplanung eintragen.

https://praxistipps.chip.de/windows-task-scheduler-aufgaben-in-windows-erstellen_28308

Wichtig ist vor allem, dass das Script entweder als Admin gestartet wird oder das "Ausführen in" Feld korrekt ausgefüllt wird:
![alt text](https://raw.githubusercontent.com/farOverNinethousand/networkDriveChecker/master/Screenshots/2018_11_11_Screenshot_Windows_Aufgabenplanung_Starten_in.png "Windows Aufgabenplanung")

5. Teste das Script innerhalb der Aufgabenplanung, indem du die Aufgabe markierst und rechts auf "Ausführen" klickst.
Funktioniert alles einwandfrei, solltest du während der Ausführung sehen, dass im Explorer Netzlaufwerke erstellt- und wieder gelöscht werden.
Sollte es wiederholt zu Problemen bei der Ausführung kommen, wird neben dem roten Text auch eine Fehlermeldung als Dialog angezeigt (siehe auch Einstellungsmöglichkeiten des Scripts).

## Welche Einstellungsmöglichkeiten habe ich im Script (nur die wichtigen)?

1. Allgemeine Einstellungen
* Immer einen bestimmten Laufwerksbuchstaben erzwingen: SET driveletter=Z: (hier den Doppelpunkt nicht vergessen!)
* WebDAV Pfad anpassen (nötig wenn man z.B. die Standardordner von bitrix24 geloescht hat): relative_webdav_path
* Name der Testdatei selbst festlegen: SET filename=testname.txt
* Festlegen, ob nach erfolgreichem Login eine Testdatei erstellt und wieder gelöscht werden soll: SET create_and_delete_dummyfile=true|false
* SET display_welcome_message_on_first_start=true|false --> 'Willkommen' Text bei der ersten Ausführung des Scripts zeigen/nicht zeigen

2. Einstellungen zu Logging und Fehlermeldungen
* max_failures_until_error = Max Anzahl fehlgeschlagener Script Ausführungen hintereinander --> Dann Fehlerdialog
* SET display_error_dialog_on_too_many_failures=true|false --> Fehlerdialog zeigen oder nicht zeigen (es geht nur um die Dialogbox nicht um die Meldungen in der Kommandozeile!)

Beispiel: Du startest dieses Script jede Woche 1x, Fehlerdialoge sind aktiviert ('SET display_error_dialog_on_too_many_failures=true') und 'max_failures_until_error=3'.
Sobald das Script das dritte Mal infolge gestartet wird und es jedes Mal Fehler gab, wird so ein Dialog angezeigt:
![alt text](https://raw.githubusercontent.com/farOverNinethousand/networkDriveChecker/master/Screenshots/2018_11_06_ErrorDialog.png "Screenshot FehlerDialog")

3. Einstellungen zu Wartezeiten

Siehe Abschnitt "REM Wartezeiten" (zu finden per Textsuche) im Script - dort sind Erklärungen zu jeder der Einstellungsmöglichkeiten vorhanden.
Diese Werte sollten nur verstellt werden wenn man weiß, was man tut.

4. Erweiterte Einstellungen

SET enable_debug_mode=true|false --> Zeigt genauere Ausgaben zu dem was aktuell passiert.
Ist für normale Anwender unnötig, da das zu sehr vielen Ausgaben führt und man schnell den Überblick verliert.

## Bei mir werden keine Logdateien erstellt - was kann ich tun?
Je nach dem wo das Script liegt kann es sein, dass Adminrechte zur Ausführung benötigt werden (zum Beispiel direkt auf C:).
Starte das Script als Administrator oder lege es an einen Ort unterhalb deines Benutzerverzeichnis zum Beispiel auf den Desktop oder in den "Dokumente" Ordner (zB "C:\Users\DeinBenutzername\Documents\").

Allgemein braucht dieses Script KEINE Adminrechte um zu funktionieren, aber um Fehlermeldungen zuverlässig anzeigen zu können sollte es in seinem Verzeichnis Schreibrechte haben!
Läuft alles reibungslos, sollte nach jeder Ausführung die Datei "NetworkDriveCheckerLog.txt" 'neben' dem Script erstellt/aktualisiert werden.
## Beim Starten mit Windows bekomme ich immer die kommandozeile angezeigt, wie kann ich das unterdrücken?
Du hast vermutlich die "NetworkDriveChecker.cmd" in den Aufgabenplaner/Autostart gelegt und nicht die "NetworkDriveCheckerForWindowsScheduler.vbs" ;)

## Ich habe einen Fehler gefunden oder möchte ein neues Feature - wie kann ich dich kontaktieren?
Entweder über GitHub oder über MyDealz: https://www.mydealz.de/profile/over_nine_thousand/overview#activity

## Wie mache ich das unter Linux?
Sorry, dafür gibt es noch keine Lösung in diesem Repository.
Eine Mögliche Lösung könnte wie folgt aussehen:
https://www.mydealz.de/deals/100-gb-cloud-speicher-dauerhaft-gratis-dsgvo-konform-kostenlos-199-1429208?page=4#comment-22802200

## Der folgende Teil richtet sich ausschließlich an bitrix24.de User:

## Warum wurde dieses Script ursprünglich geschrieben?
Um automatisiert die Accounts des Anbieters bitrix24.de aktiv zu halten und wegen eines Deals auf MyDealz durch den man sich dort 100GB Cloud Speicher permanent holen konnte: https://www.mydealz.de/deals/100gb-cloud-speicher-dauerhaft-gratis-dsgvo-konform-1232057

Update 05.09.2019 es gibt den Deal wieder und daher auch ein Update: https://www.mydealz.de/deals/100-gb-cloud-speicher-dauerhaft-gratis-dsgvo-konform-kostenlos-199-1429208

Bitrix24 löscht Accounts, sofern man sich nicht alle 6 Wochen mindestens einmal einloggt (man muss dafür keine Datei(en) hochladen).
Man erhält nach 4 Wochen (hier 33 Tage) die erste Warnung ("Ihr Account wird in 14 Tagen gelöscht") und nach 5 Wochen die zweite und eventuell letzte Warnung ("Ihr Account wird in 7 Tagen gelöscht").

## Wie oft sollte man das Script ausführen, damit Bitrix24 Accounts sicher nicht gelöscht werden?
Mindestens einmal pro Woche.

## Troubleshooting für Windows XP Benutzer
Windows XP hat leider keine https Unterstützung für WebDAV daher wird man beim Start dieses Scripts idR eine 'Systemfehler 67' oder auch 'Systemfehler 5' Fehlermeldung bekommen.
Abgesehen davon, dass man Windows XP heutzutage sowieso nicht mehr nutzen sollte, kann man folgende Workarounds ZUSAMMEN probieren:

https://support.microsoft.com/de-de/help/841215/error-message-when-you-try-to-connect-to-a-windows-sharepoint-document

und

http://wazem.blogspot.com/2013/05/how-to-map-secure-webdav-share-on.html

Danach im Script folgende Einstellung auf 'true' setzen: force_allow_windows_xp UND die Zeile 'SET protocol=https://' durch 'SET protocol=http://' ersetzen!

Die Workarounds führen nicht zwangsläufig zum Erfolg!!