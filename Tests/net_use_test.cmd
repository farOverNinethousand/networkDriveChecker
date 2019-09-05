@ECHO OFF
setlocal enableDelayedExpansion
color 0a

REM ----------------------------------------------- Einstellungen START -----------------------------------------------
REM Logindaten START
SET subdomain=test-test
SET "username=over9k_not_my_real_mail@web.de"
SET "password=testPW"
REM Logindaten ENDE

SET protocol=https://
SET domain=bitrix24.de
SET "relative_webdav_path=/company/personal/user/1/disk/path/Offene sichtbare Gruppe/"
REM ----------------------------------------------- Einstellungen ENDE -----------------------------------------------

SET full_webdav_path=!protocol!!subdomain!.!domain!!relative_webdav_path!
SET driveletter=Z
SET driveletter=!driveletter!:

echo Zielpfad: !full_webdav_path!
echo Ziel-Laufwerksbuchstabe: !driveletter!

echo Erstelle Laufwerk

REM WebDAV Pfad "mounten"
net use !driveletter! "!full_webdav_path!" /persistent:yes /user:!username! !password!

pause

echo Loesche Laufwerk

REM WebDAV Pfad "UN-mounten"
net use !driveletter! /DELETE

echo Test Ende

pause