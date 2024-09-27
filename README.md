# Автоматизация обновления конфигурации 1С

- <https://gitlab.ci.vozovoz.ru/admins/sync_repo>

## Clone

- Установить Git - <https://git-scm.com/download/win>
- Склонировать репозиторий с помощью команды `git clone <https://oauth2:Токен@gitlab.ci.vozovoz.ru/admins/sync_repo.git>`, где токен указать из настроек в профиле пользователя.
- Для получения изменений использовать команду `git pull`

## Установка

- Установить OneScript - <https://oscript.io/docs/page/install>, перезагурзиться.
- Запустить ```install.bat``` под полными правами.

## Настройка

- Скопировать файл `autumn-properties_example.yml` и переименовать его в `autumn-properties.yml`.
- В файле `autumn-properties.yml` в секции `Ответсвенный` указать свое имя.

## Настроенные скрипты в папке "bat"

- `update_all.bat` - полное обновление всех тестовых баз из хранилища
- `task_update_all.bat` - выборочное обновление тестовых баз
- `close_config_ИД` - скрипты закрытия конфигуратора под каждую базу
- `update_ИД` - скрипты обновления конфигурации базы данных под каждую базу

## Контроль запуска по расписанию

Будет разрешен запуск только в указанное время.

### Настройки

```yaml
Расписание:
    - ДеньНедели: 7
      Параметры: 
      - ВремяС: 9
      - ВремяПо: 10
```

## Возможные команды

### GUI

- `ЗадатьВопрос` (Параметры: `ТекстВопроса`)
- `ПоказатьПриветствие` (Параметры: `Приветствие`)
- `УстановитьПаузу` (Параметры: `Пауза`)
- `ПоказатьНачало` (Параметры: `Начало`)
- `ПоказатьЗавершение` (Параметры: `Окончание`)

### Конфигуратор

#### Настройки

```yaml
Конфигуратор:
    Логин: "Логин"
    Пароль: "Пароль"
```

#### Команды

- `ОтключитьКонфигураторОтИнформационнойБазы`
- `ВыгрузитьКонфигурациюВФайл`
- `ОбъединитьКонфигурациюСФайлом`
- `ВыполнитьСинтаксическийКонтроль`
- `ВыполнитьРасширенныйСинтаксическийКонтроль`
- `ОбновитьКонфигурациюБазыДанных` (Параметры: `РежимРеструктуризации` - Первый или Второй (по умолчанию "Первый"), `ИмяРасширения` - будет обновляться указанное расширение). При установки переменной окружения `SYNC_REPO_UPDATE_DYNAMIC`, будет попытка обновиться динамически.

### Хранилище

#### Настройки:

```yaml
Хранилище:
    Путь: "Путь"
    Логин: "Логин"
    Пароль: "Пароль"
```

#### Команды

- `ПодключитьсяКХранилищу` (Параметры: `ИмяРасширения` - будет подключаться указанное расширение по параметрам указанным в самом расширении)
- `ПолучитьВерсиюКонфигурацииИзХранилища`
- `ЗагрузитьКонфигурациюИзХранилища` (Параметры: `ИмяРасширения` - если указано, то будет загружать конфигурацию для расширения)
- `ЗахватитьОбъектыВХранилище`
- `ЗахватитьОбъектыВХранилищеПоСпискуИзФайла` - список объектов необходимо указать в файле ```settings/metadata.txt``` или передать в переменную окружения `listMetadataBuild` (если будет передана `*`, то будет выпоплняться команда `ЗахватитьОбъектыВХранилище` на все объекты). Необходимо передавать каждый объект на новой строке, объекты по умолчанию захватываются рекурсивно. Если установить переменную окружения `SYNC_REPO_BUILD_LISTMETADATA_INCLUDECHILDOBJECTS` в истина, то объекты будут захватываться рекурсивно.
- `ОтменитьЗахватОбъектовВХранилище`
- `ПоместитьИзмененияОбъектовВХранилище` (Параметры: `КомментарийПриПомещенииВХранилище`)

### Расширения

#### Настройки:

```yaml
Расширения:
    - Имя: "Имя"
        Хранилище:
        Путь: "Путь"
        Логин: "Логин"
        Пароль: "Пароль"
```

#### Команды

- `ЗагрузитьРасширениеВРежимеПредприятия` (Параметры команды: `ИмяРасширения` (обязательный) - имя файла расширения, `Путь` - путь к файлу расширения, если не указан, то будет осуществляться поиск файла в каталоге `cfe`)

- `ЗагрузитьРасширениеИзФайла` (Устарела) (Параметры команды: `Имя` (обязательный), `ИмяФайла` (обязательный), `ОбновитьКонфигурациюИБ` (по умолчанию `Ложь`))
По умолчнию поиск файлов осуществляться в каталоге `cfe`, но его можно переопределить в настройка `autumn-properties.yml`

```yaml
Общие
    ПутьККаталогуCFe: "\\cfe"
```

### RAS

#### Настройки:

```yaml
 RAS:
    Сервер: "Сервер"
    Порт: "Порт"
```

#### Команды

- `ЗаблокироватьИБ`
- `ОтключитьСеансыИнформационнойБазы` (Параметры: `ПриложенияИсключения` - возможность указать имена приложений, которые не нужно отключать.)
- `ПроверитьБлокировкуИБ`
- `ПроверитьНаличиеАктивныхСеансовИБ`
- `СнятьБлокировкуИБ` (Параметры: `СниматьБлокировкуРегламентныхЗаданий`). При установки переменной окружения `SYNC_REPO_KEEP_LOCK_IB` блокирова ИБ не будет снята.

### Предприятие

- `ЗапуститьВРежимеПредприятия` (Параметры: `КлючиЗапускаПредприятия`, `ОжидатьВыполнения` - при установки false, не будет ожидать завершения)

### SQL

#### Настройки:

```yaml
SQL:
    ТипСУБД: "MSSQLServer"
    Сервер: "Имя сервера"
    ИмяБазы: "Имя базы"
    ИмяПользователя: ""
    Пароль: ""
```

Если, не передан пользователь, то будет выполняться windows аудентификация.
Возможные скрипты нужно добавлять в файл ```src/templates/Классы/СкриптыSQL.os``` отдельной функцией

#### Команды

```yaml
- Команда: ВыполнитьСкриптSQL # Выполняет скрипт SQL с проверкой результата
  Параметры: 
    - Имя: "ЗапуститьЗадание"
    - Параметр1: "Имя"
    - ОжидатьРезультат: 1
 - Команда: ВыполнитьЗапросSQL # Выполняет запрос SQL на выборку с выгрузкой его в таблицу значений
   Параметры: 
    - Имя: "АктивностьЗадания" 
    - Параметр1: "Имя" 
    - ОжидатьКоличествоСтрок: 0
    - Пауза: 3
    - ПовторныхОтправок: 5 
 - Команда: ВыполнитьЗапросSQL # Показывает активные запросы в БД, при ошибки соединения к БД скрипт не останавливается
   Параметры:                  # Должна быть установлена в БД хранимая процедура https://whoisactive.com
    - Имя: "WhoIsActive" 
    - Параметр1: "ИмяБД"
    - ПропускатьПриОшибке: Да
```

### CMD

- `ВыполнитьКомандныйФайл` (Параметры: `СтрокаКоманды`(обязательный) ,`Имя`)

## Переопределение общих параметров команд

В команде можно указать параметры, которые будет приоритетнее общих параметров

```yaml
- Команда: ЗадатьВопрос
  Параметры: 
    - ТекстВопроса: "Вопрос из команды" 
```

## Асинхронное выполнение нескольних команд

Скрипт пойдет далее, после того как будут выполнены все команды.

```yaml
- Группа команд:
    - УстановитьПаузу
    - Команда: ПоказатьНачало
        Параметры: 
            - Начало: "Начало в Асинх"
```

## Паралельное выполнение нескольких команд

В строке запуске передать параметр ```groupCommand``` с именем файла настроек групповых команд.

```bat
@set groupCommand=--GroupCommands \bat\commands\connect_repo.yaml
oscript "sync_repo.os" run %groupCommand%
```

При добавлении группы `Последовательно` - команды в группе будут выполняться последовательно.

Пример файла настроек:

```yaml
Запуск:
    Параметры:
        sync_repo: "oscript sync_repo.os run"
        command: "--Commands \\bat\\commands\\connect_repo.yaml"           
    Команды:
        - "%sync_repo --ИдентификаторБазы PP %command" 
        - "%sync_repo --ИдентификаторБазы QA %command"
        - Последовательно:
            - "%sync_repo --ИдентификаторБазы QP %command" 
            - "%sync_repo --ИдентификаторБазы QV %command" 
```

## Каталоги по умолчания

- cf - Каталог для сохранения/загрузки конфигурации.
- cfe - Каталог для загрузки расширений из файлов.
  