REM -------------- Zugangsdaten hier eintragen --------------
REM Fuer jeden Account muessen eine subdomain, ein username(E-Mail oder Telefonnummer) und Passwort eingetragen werden.
REM Es sind VIER Beispiel-Eintraege vorhanden.
REM Traegt man z.B. nur einen Account ein, muessen jeweils die anderen (DREI) Beispiel-Eintraege bei 'subdomains', 'usernames' und 'passwords' geloescht werden.
REM Hier NUR die Subdomain eintragen, NICHT "meine-subdomain.bitrix24.de" sondern NUR "meine-subdomain" OHNE "bitrix24.de" .
SET "subdomains[0]=test1-bla"
SET "subdomains[1]=test2-bla"
SET "subdomains[2]=test3-bla"
SET "subdomains[3]=test4-bla"

SET "usernames[0]=user1"
SET "usernames[1]=user2"
SET "usernames[2]=user3"
SET "usernames[3]=user4"

SET "passwords[0]=password1"
SET "passwords[1]=password2"
SET "passwords[2]=password3"
SET "passwords[3]=password4"

REM Einstellungen basics - diese muessen trotzdem meist nicht angepasst werden!!
REM 'protocol' und 'domain' nur aendern, falls Accounts einer komplett anderen Webseite geprueft werden sollen!
SET "protocol=https://"
SET "domain=bitrix24.de"
REM Das ist der Standard-Pfad, den alle neuen bitrix24 Accounts haben. Sofern man die Standard-Ordner loescht, muss man diesen Wert hier anpassen! Achtung! Dieser Pfad muss unter allen eingetragenen Accounts existieren!
SET "relative_webdav_path=/company/personal/user/1/disk/path/Offene sichtbare Gruppe/"