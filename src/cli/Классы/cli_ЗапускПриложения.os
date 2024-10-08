&Опция(Имя = "ИдентификаторБазы", Описание = "Идентификатор базы")
&ВОкружении("SYNC_REPO_ID_BASE")
Перем ИдентификаторБазы;

&Опция(Имя = "ID", Описание = "Идентификатор базы (англ)")
Перем ID;

&Опция(Имя = "ИдентификаторКоманд", Описание = "Идентификатор на список команд, которые следует запускать")
&ВОкружении("SYNC_REPO_ID_COMMAND")
&ПоУмолчанию("Команды")
Перем ИдентификаторКоманд;

&Опция(Имя = "IDCommand", Описание = "Идентификатор на список команд, которые следует запускать (англ)")
Перем IDCommand;

&Опция(Имя = "ИдентификаторГрупповыхКоманд", Описание = "Идентификатор на список команд в групповом файле команд")
&ВОкружении("SYNC_REPO_ID_GROUP_COMMAND")
Перем ИдентификаторГрупповыхКоманд;

&Опция(Имя = "IDCommandGroup", Описание = "Идентификатор на список команд в групповом файле команд (англ)")
Перем IDCommandGroup;

&Опция(Имя = "Config", Описание = "Имя или путь к файлу настроек, по умолчанию onfig.yaml")
&ВОкружении("SYNC_REPO_CONFIG")
&ПоУмолчанию("config.yaml")
Перем Config;

&Опция(Имя = "Platform", Описание = "Группа команд на указание платформы")
&ВОкружении("SYNC_REPO_V8VERSION")
&ПоУмолчанию("Платформа")
Перем Platform;

&Опция(Имя = "Commands", Описание = "Имя или путь к файлу с командами, если файл не передан, то команды будут искаться в файле config") // BSLLS:LineLength-off
&ВОкружении("SYNC_REPO_COMMANDS")
Перем Commands;

&Опция(Имя = "GroupCommands", Описание = "Имя файла с групповыми командами, если файл передан, то будут запускаться групповые команды") // BSLLS:LineLength-off
&ВОкружении("SYNC_REPO_GROUPCOMMANDS")
Перем GroupCommands;

&Опция(Имя = "BuildUser", Описание = "Ответственный, переопределение ответственного в настройках") 
&ВОкружении("SYNC_REPO_BUILD_USER")
Перем BuildUser;

&Опция(Имя = "PausePredBuild", Описание = "Переопределение параметра Пауза в настройках по умолчанию, имеет приоритет перед настройками") // BSLLS:LineLength-off 
&ВОкружении("SYNC_REPO_PAUSE_PRED_BUILD")
Перем PausePredBuild;

&Опция(Имя = "ListMetadata", Описание = "Список метаданных, которые требуется обновить, переопределение файла metadata.txt") // BSLLS:LineLength-off 
&ВОкружении("SYNC_REPO_BUILD_LISTMETADATA")
Перем ListMetadata;

&Опция(Имя = "IncludeChildObjects", Описание = "Обновлять объекты из списка метаданных рекурсивно") // BSLLS:LineLength-off 
&ВОкружении("SYNC_REPO_BUILD_LISTMETADATA_INCLUDECHILDOBJECTS")
&ТБулево
&ПоУмолчанию(Истина)
Перем IncludeChildObjects;

&Опция(Имя = "StartFromPosition", Описание = "Начать с указанной позиции") // BSLLS:LineLength-off 
&ВОкружении("SYNC_REPO_BUILD_STARTFROMPOSITION")
Перем StartFromPosition;

&Опция(Имя = "DynamicUpdate", Описание = "Использовать динамическое обновление")
&ВОкружении("SYNC_REPO_UPDATE_DYNAMIC")
&ТБулево
&ПоУмолчанию(Ложь)
Перем DynamicUpdate;

&Опция(Имя = "KeepLockIB", Описание = "Оставить блокировку ИБ")
&ВОкружении("SYNC_REPO_KEEP_LOCK_IB")
&ТБулево
&ПоУмолчанию(Ложь)
Перем KeepLockIB;

&Опция(Имя = "Background", Описание = "Фоновый запуск, отключает все диалоги, при ошибки сразу завершается") // BSLLS:LineLength-off
&ВОкружении("SYNC_REPO_BACKGROUND")
&ТБулево
&ПоУмолчанию(Ложь)
Перем Background;

&Опция(Имя = "UsePowerShell", Описание = "Использовать PowerShell для запуска параллельных команд, вместо cmd") // BSLLS:LineLength-off
&ВОкружении("SYNC_REPO_USEPOWERSHELL")
&ТБулево
&ПоУмолчанию(Ложь)
Перем UsePowerShell;

&Опция(Имя = "GroupPosition", Описание = "Служебный параметр для передачи порядка вызова групповых команд")
&ТЧисло
&ПоУмолчанию(0)
Перем GroupPosition;

&Опция(Имя = "Lock", Описание = "Служебный параметр для ожидания выполнения предыдущего задания")
Перем Lock;

&Опция(Имя = "Debug", Описание = "Включить режим debug (1)")
&ВОкружении("SYNC_REPO_DEBUG")
&ТЧисло
&ПоУмолчанию(0)
Перем РежимDebug;

Перем Запускатель;
Перем Лог;

&КомандаПриложения(Имя = "run r", Описание = "Выполнение команд")
Процедура ПриСозданииОбъекта(&Пластилин("Запускатель") _Запускатель,
								&Лог("oscript.lib.sync_repo_start") _Лог)

	Запускатель = _Запускатель;
	Лог         = _Лог;

КонецПроцедуры

&ВыполнениеКоманды
Процедура Запустить() Экспорт
	
	Если ЗначениеЗаполнено(ID) Тогда
		ИдентификаторБазы = ID;	
	КонецЕсли;

	Если ЗначениеЗаполнено(IDCommand) Тогда
		ИдентификаторКоманд = IDCommand;	
	КонецЕсли;

	Если ЗначениеЗаполнено(IDCommandGroup) Тогда
		ИдентификаторГрупповыхКоманд = IDCommandGroup;	
	КонецЕсли;
	
	ПаузаПередЗапуском = ПривестиЗначениеВЧисло("PausePredBuild", PausePredBuild, 0);
	НачатьСПозиции = ПривестиЗначениеВЧисло("StartFromPosition", StartFromPosition, 1, 0);
	
	ОбновлятьОбъектыРекурсивно = ПривестиЗначениеВБулево("IncludeChildObjects", IncludeChildObjects, 1);

	Опции = Новый Структура();
	Опции.Вставить("ИдентификаторБазы",   ИдентификаторБазы);
	Опции.Вставить("ИдентификаторКоманд", ИдентификаторКоманд);
	Опции.Вставить("Config",              Config);
	Опции.Вставить("Commands",            Commands);
	Опции.Вставить("Platform",            Platform);	
	Опции.Вставить("ИдентификаторГрупповыхКоманд", ИдентификаторГрупповыхКоманд);
	Опции.Вставить("СписокМетаданных",    ListMetadata);
	Опции.Вставить("ОбновлятьОбъектыРекурсивно", ОбновлятьОбъектыРекурсивно);
	Опции.Вставить("НачатьСПозиции",      НачатьСПозиции);	
	Опции.Вставить("GroupCommands",       GroupCommands);
	Опции.Вставить("Ответственный",       BuildUser);
	Опции.Вставить("ПаузаПередЗапуском",  ПаузаПередЗапуском);
	Опции.Вставить("Фоново",              Background);
	Опции.Вставить("ИспользоватьДинамическоеОбновление", DynamicUpdate);
	Опции.Вставить("ОставитьБлокировкуИБ",   KeepLockIB);
	Опции.Вставить("ИспользоватьPowerShell", UsePowerShell);
	Опции.Вставить("GroupPosition",       GroupPosition);
	Опции.Вставить("Lock",       		  Lock);	
	Опции.Вставить("РежимDebug",          РежимDebug);
	
	Запускатель.Запустить(Опции);

КонецПроцедуры

Функция ПривестиЗначениеВЧисло(Имя, Значение, ЗначениеПоУмолчанию = 0, ЗначениеИсключаемое = Неопределено)
	
	Лог.Отладка("Параметр: %1, Значение: %2", Имя, Значение);
	Лог.Отладка("Параметр: %1, Тип значения: %2", Имя, ТипЗнч(Значение));
	
	ТипЗначения = ТипЗнч(Значение);

	Если ТипЗначения = Тип("Число") Тогда
		Возврат Значение;
	КонецЕсли;

	Если ЗначениеЗаполнено(Значение) И ТипЗнч(Значение) = Тип("Строка") Тогда		
		
		ОписаниеТипа = Новый ОписаниеТипов("Число");
		ЗначениеПриведенное = ОписаниеТипа.ПривестиЗначение(Значение);		

		Если ЗначениеИсключаемое <> Неопределено И ЗначениеПриведенное = ЗначениеИсключаемое Тогда
			ЗначениеПриведенное = ЗначениеПоУмолчанию;
		КонецЕсли;

	Иначе
		ЗначениеПриведенное = ЗначениеПоУмолчанию;			
	КонецЕсли;

	Лог.Отладка("Параметр: %1, Приведенное значение: %2", Имя, ЗначениеПриведенное);	
	
	Возврат ЗначениеПриведенное;

КонецФункции

Функция ПривестиЗначениеВБулево(Имя, Значение, ЗначениеПоУмолчанию)
	
	Лог.Отладка("Параметр: %1, Значение: %2", Имя, Значение);
	Лог.Отладка("Параметр: %1, Тип значения: %2", Имя, ТипЗнч(Значение));

	ТипЗначения = ТипЗнч(Значение);
	Если ТипЗначения = Тип("Булево") Тогда
		Возврат Значение;		
	КонецЕсли;

	Если ТипЗначения = Тип("Число") Тогда
		ЗначениеПриведенное = Значение = Истина;
		Лог.Отладка("Параметр: %1, Приведенное значение: %2", Имя, ЗначениеПриведенное);	
		Возврат ЗначениеПриведенное;
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;

КонецФункции