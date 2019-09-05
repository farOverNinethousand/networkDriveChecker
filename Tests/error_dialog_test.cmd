@ECHO OFF
setlocal enableDelayedExpansion

echo Zeige Fehlerdialog

SET "account_failure_text_1=Es konnten !failedtimes! Mal infolge nicht alle Accounts geprueft werden^^!"
SET "account_failure_text_2=Folgende Accounts konnten nicht geprueft werden: !failed_accounts!"
SET "account_failure_text_3=Finde die Ursache des Problems ansonsten könnten deine Accounts in naher Zukunft wegen Inaktivität geloescht werden^^!^^!"

msg "%username%" NetworkDriveChecker: %account_failure_text_1% %account_failure_text_2% %account_failure_text_3%

pause