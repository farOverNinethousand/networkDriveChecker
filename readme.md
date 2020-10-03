
# NetworkDriveChecker
Prüft ein- oder mehrere passwortgeschützte Netzlaufwerke |  bewahrt bitrix24.de Accounts vor Inaktivitätslöschung!

## Was macht das Script?
Es loggt sich automatisch in Netzlaufwerke ein und löscht diese wieder.
Damit kann man z.B. Accounts vor einer Löschung durch Inaktivität zu bewahren (Beispiel-Anbieter: bitrix24.de) oder einfach nur Zugänge prüfen.

## Kompatibilität
Das Script läuft auf allen Windows Betriebssystemen nach Windows XP.

## Gibt es eine Version für Linux?
Nicht von genau diesem Script, aber folgende Optionen gibt es:
* Option 1: [bitrix24-account-avoid-inactivity-deletion.sh](https://github.com/mesche/common-scripts/blob/main/bitrix24-account-avoid-inactivity-deletion.sh) von MyDealz User [esche](https://www.mydealz.de/profile/esche)
* Option 2: [webdavTester](https://github.com/ka223/webdavTester)

##  Installation

1\. Kopiere alle Dateien dieses Projektes in einen Ordner **unterhalb** des Benutzerordners zum Beispiel: `C:\Users\DeinBenutzername\Documents\networkDriveChecker`  
2\. Trage deine (bitrix24.de) Zugangsdaten in der Datei AccountSettings.cmd ein.
Jeder Account hat quasi drei Zugangsdaten. E-Mail (oder Telefonnummer) und Passwort solltest du kennen - die dazugehörige Domain siehst du in der Adresszeile deines Browsers, wenn du dich über diesen einloggst und im Menü Links auf "Bitrix24.drive" klickst:  
`https://HIER_STEHT_DEINE_SUB_DOMAIN.bitrix24.de/company/personal/user/1/disk/path/`

Beispiel:  
Benutzername/Mail: test@gmail.com  
Passwort: test123  
Subdomain: b24-xxxyyy  
Im Script würde das dann so aussehen:  
```
SET "subdomains[0]=b24-xxxyyy"
SET "usernames[0]=test@gmail.com"
SET "passwords[0]=test123"
```

Wichtig: Lösche die restlichen Dummy-Einträge falls du wie im Beispiel nur einen Account hast (in dem Fall die Zeilen 'SET subdomains[1]=test2-bla' usw. löschen.)
Außerdem wichtig:  Vermeide Sonderzeichen im Passwort - es gibt nur wenige, die erlaubt sind.
Mehr Infos zur Verwendung von Sonderzeichen siehe weiter unten.

Veranschaulichung:
![alt text](https://raw.githubusercontent.com/farOverNinethousand/networkDriveChecker/master/Screenshots/2019_09_06_Beispiel_Accounts_eintragen.png "Veranschaulichung Zugangsdaten in Script eintragen")

3\. Starte die "NetworkDriveChecker.cmd" einmal testweise per Doppelklick und gehe sicher, dass es ohne Fehler durchläuft.
Siehe auch "Woran erkenne ich, dass das Script funktioniert" weiter unten.

4\. Sobald das Script ohne Fehlermeldungen läuft kannst du es per  "NetworkDriveCheckerForWindowsScheduler.vbs" in die Windows Aufgabenplanung eintragen.

https://praxistipps.chip.de/windows-task-scheduler-aufgaben-in-windows-erstellen_28308

Wichtig ist vor allem, dass das Script entweder als Admin gestartet wird oder das "Ausführen in" Feld korrekt ausgefüllt wird!
Beispiel:

Das Haupt-Script befindet sich hier: 
`C:\Users\deinWinBenutzername\Documents\00_WindowsSchedulerScripte\bitrix24_Private_TEST\NetworkDriveChecker.cmd`

Dann sollte das Start-Script (das du im 'Programm/Skript' Feld angibst) hier liegen:
`C:\Users\deinWinBenutzername\Documents\00_WindowsSchedulerScripte\bitrix24_Private_TEST\NetworkDriveCheckerForWindowsScheduler.vbs`

Unter 'Starten in' gibst du dann folgendes an:
`C:\Users\deinWinBenutzername\Documents\00_WindowsSchedulerScripte\bitrix24_Private_TEST`

![alt text](https://raw.githubusercontent.com/farOverNinethousand/networkDriveChecker/master/Screenshots/2018_11_11_Screenshot_Windows_Aufgabenplanung_Starten_in.png "Windows Aufgabenplanung")

5\. Teste das Script nochmals innerhalb der Aufgabenplanung, indem du die Aufgabe markierst und rechts auf "Ausführen" klickst.
Siehe auch "Woran erkenne ich, dass das Script funktioniert".

## Woran erkenne ich, dass das Script funktioniert?

1. Während der Ausführung ist im Explorer erkennbar, wie Netzlaufwerke erscheinen und verschwinden.
2. Nach der Ausführung erscheint keine Fehlermeldung und im Ordner in dem das Script gestartet wurde liegt eine Datei namens "NetworkDriveCheckerLog.txt".
Wenn es keine Fehler gab sollte der Inhalt dieser Datei in etwa so aussehen (Beispiel mit vier Accounts):
```
Letzte Ausfuehrung: 08.09.2019 | 4 Accounts geprueft | Davon erfolgreich: 4 | Davon fehlgeschlagen: 0
```

## Welche Account-Einstellungsmöglichkeiten habe ich (AccountSettings.cmd)?
* WebDAV Pfad anpassen (nötig wenn man z.B. die Standardordner von bitrix24 geloescht hat): relative_webdav_path
* Protokoll einstellen (standard = HTTPS): protocol
* Domain einstellen (standard = bitrix24.de): domain

## Welche Script-Einstellungsmöglichkeiten habe ich (Settings.cmd)?

1\. Allgemeine Einstellungen
* Immer einen bestimmten Laufwerksbuchstaben erzwingen: SET driveletter=Z: (hier den Doppelpunkt nicht vergessen!)
* Name der Testdatei selbst festlegen: SET filename=testname.txt
* Festlegen, ob nach erfolgreichem Login eine Testdatei erstellt und wieder gelöscht werden soll: SET create_and_delete_dummyfile=true|false
* SET display_welcome_message_on_first_start=true|false --> 'Willkommen' Text bei der ersten Ausführung des Scripts zeigen/nicht zeigen

2\. Einstellungen zu Logging und Fehlermeldungen
* max_failures_until_error = Max Anzahl fehlgeschlagener Script Ausführungen hintereinander --> Dann Fehlerdialog
* SET display_error_dialog_on_too_many_failures=true|false --> Fehlerdialog zeigen oder nicht zeigen (es geht nur um die Dialogbox nicht um die Meldungen in der Kommandozeile!)

Beispiel: Du startest dieses Script jede Woche 1x, Fehlerdialoge sind aktiviert ('SET display_error_dialog_on_too_many_failures=true') und 'max_failures_until_error=3'.
Sobald das Script das dritte Mal infolge gestartet wird und es jedes Mal Fehler gab, wird so ein Dialog angezeigt:
![alt text](https://raw.githubusercontent.com/farOverNinethousand/networkDriveChecker/master/Screenshots/2018_11_06_ErrorDialog.png "Screenshot FehlerDialog")

3\. Einstellungen zu Wartezeiten

Siehe Abschnitt "REM Wartezeiten" (zu finden per Textsuche) im Script - dort sind Erklärungen zu jeder der Einstellungsmöglichkeiten vorhanden.
Diese Werte sollten nur verstellt werden wenn man weiß, was man tut.

4\. Erweiterte Einstellungen

SET enable_debug_mode=true|false --> Zeigt genauere Ausgaben zu dem was aktuell passiert.
Ist für normale Anwender unnötig, da das zu sehr vielen Ausgaben führt und man schnell den Überblick verliert.

## Ich will trotzdem Sonderzeichen im Passwort verwenden, wie geht das?
Einige Zeichen müssen "maskiert" werden, da das Script sonst nicht mehr funktionieren würde.
Eine Liste dazu findet sich z.B. hier: https://www.robvanderwoude.com/escapechars.php

Stand 11.09.2019: Ich selbst habe auch mit Maskierung nur wenige Sonderzeichen verwenden können. Falls sich jemand besser damit auskennt, kontaktiert mich gerne per GitHub Issue ;)

## Bei mir werden keine Logdateien erstellt - was kann ich tun?
Je nach dem wo das Script liegt kann es sein, dass Adminrechte zur Ausführung benötigt werden (zum Beispiel direkt auf C:).
Starte das Script als Administrator oder lege es an einen Ort unterhalb deines Benutzerverzeichnis zum Beispiel auf den Desktop oder in den "Dokumente" Ordner (zB "C:\Users\DeinBenutzername\Documents\").

Allgemein braucht dieses Script KEINE Adminrechte um zu funktionieren, aber um Fehlermeldungen zuverlässig anzeigen zu können sollte es in seinem Verzeichnis Schreibrechte haben!
Läuft alles reibungslos, sollte nach jeder Ausführung die Datei "NetworkDriveCheckerLog.txt" 'neben' dem Script erstellt/aktualisiert werden.
## Beim Starten mit Windows bekomme ich immer die kommandozeile angezeigt, wie kann ich das unterdrücken?
Du hast vermutlich die "NetworkDriveChecker.cmd" in den Aufgabenplaner/Autostart gelegt und nicht die "NetworkDriveCheckerForWindowsScheduler.vbs" ;)

## Ich habe einen Fehler gefunden oder möchte ein neues Feature - wie kann ich dich kontaktieren?
Entweder über GitHub oder über MyDealz: https://www.mydealz.de/profile/over_nine_thousand/overview#activity

## Extra bitrix24.de FAQ:

## Warum wurde dieses Script ursprünglich geschrieben?
Um automatisiert die Accounts des Anbieters bitrix24.de aktiv zu halten und wegen eines [Deals auf dem Schnäppchenportal MyDealz](https://www.mydealz.de/deals/100gb-cloud-speicher-dauerhaft-gratis-dsgvo-konform-1232057) durch den man sich dort 100GB Cloud Speicher permanent holen konnte.  
Bitrix24 löscht Accounts, sofern man sich nicht alle 6 Wochen mindestens einmal einloggt (man muss dafür keine Datei(en) hochladen).
Man erhält nach 4 Wochen (hier 33 Tage) die erste Warnung ("Ihr Account wird in 14 Tagen gelöscht") und nach 5 Wochen die zweite und eventuell letzte Warnung ("Ihr Account wird in 7 Tagen gelöscht").

## Ich habe mich bei bitrix24 registriert und vergessen, den Gutschein direkt einzugeben - wie trage ich diesen nachträglich ein?
Links bei der Leiste wo oben "Activity Stream" steht auf "Abonnement" klicken.
Falls das nicht direkt sichtbar ist, erst unten auf "Mehr" klicken.  
Dann auf "Gutschein aktivieren" klicken.


## Wie oft sollte man das Script ausführen, damit Bitrix24 Accounts sicher nicht gelöscht werden?
Mindestens einmal pro Woche.

## Zählt ein Login per Bitrix24 App auch als Login?
Ja, aber wenn du dieses Script verwendest brauchst du die App nicht ;)

## Wo kann ich sehen, wie viel Speicher ich insgesamt habe?
Links bei der Leiste wo oben "Activity Stream" steht auf "Abonnement" klicken.
Falls das nicht direkt sichtbar ist, erst unten auf "Mehr" klicken.  
Falls der Deal "100 GB gratis" war, solltest du dort "105 GB" stehen haben.

## Wo finde ich meine Web-DAV Zugangsdaten, wenn ich mich mit dem Social Login (Facebook/Google) registriert habe?
E-Mail: Mein Profil -> E-Mail  
Passwort: Mein Profil -> Passwörter -> Passwörter der Anwendungen -> Dokumente -> Sonstiges -> Passwort anfordern  