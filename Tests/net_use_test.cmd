@ECHO OFF
setlocal enableDelayedExpansion

echo Erstelle Laufwerk

SET protocol=https://
SET subdomain=test-test
SET domain=bitrix24.de
SET "relative_webdav_path=/company/personal/user/1/disk/path/TestFolder"
SET webdav_path=!protocol!!subdomain!.!domain!!relative_webdav_path!
SET username=over9k_not_my_real_mail@web.de
SET password=testPW

SET driveletter=Z
SET driveletter=!driveletter!:

echo Zielpfad: !webdav_path!
echo Ziel-Laufwerksbuchstabe: !driveletter!

REM WebDAV Pfad "mounten"
net use !driveletter! !webdav_path! /persistent:yes /user:!username! !password!

pause

echo Loesche Laufwerk

REM WebDAV Pfad "UN-mounten"
net use !driveletter! /DELETE


pause