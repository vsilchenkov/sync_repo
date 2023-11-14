CHCP 65001
@echo Off

cd ..

echo Работа с конфигуратором
@set command=--Commands \bat\commands\close_config.yaml
oscript "sync_repo.os" --ИдентификаторБазы "BASE1" %command%

PAUSE