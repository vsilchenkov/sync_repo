@echo Off

CHCP 65001
set /p var=Запустить полное обновление?[Y/N]: 
if %var%== Y goto start
if not %var%== Y exit

:start

cd ..


CHCP 65001
echo Обновление
@set command_update=--Commands \bat\commands\update_all.yaml
oscript "sync_repo.os" --ИдентификаторБазы "REPO" %command_update% --ИдентификаторКоманд "Уведомление"
if ERRORLEVEL = 1 goto error
oscript "sync_repo.os" --ИдентификаторБазы "REPO" %command_update%
if ERRORLEVEL = 1 goto error
oscript "sync_repo.os" --ИдентификаторБазы "BASE1" %command_update%
if ERRORLEVEL = 1 goto error

CHCP 866
@set groupCommand=--GroupCommands \bat\commands\update_all.yaml
oscript "sync_repo.os" %groupCommand%

CHCP 65001
goto end

:error
CHCP 65001
echo ОШИБКА - Получен ненулевой код возврата %ERRORLEVEL%. Выполнение скрипта остановлено!

:end
PAUSE