// BSLLS:ExportVariables-off

// Массивы данных
Перем КомандыВыполнения Экспорт; // порядок выполнения команд
Перем ГрупповыеКоманды Экспорт;

// Соответствия параметров из конфига
&Деталька("Общие")
Перем ПараметрыОбщие Экспорт;
Перем ПараметрыРасписания Экспорт;
Перем ПараметрыПлатформы Экспорт;
Перем ПараметрыБазы Экспорт;
Перем ПараметрыКонфигурации Экспорт;

// Структуры собранных параметров
Перем ПараметрыПодключения Экспорт; 
Перем ПараметрыКоманд Экспорт; 
Перем ПараметрыТелеграм Экспорт; 
Перем ПараметрыDebug Экспорт; 
Перем ФайлыНастроек Экспорт; 

Перем Идентификатор Экспорт;
Перем ИмяКонфигурации Экспорт;

// Контроль расписания
Перем Расписание Экспорт;

// Платформа
Перем ПутьКПлатформе Экспорт;
Перем ВерсияПлатформы Экспорт;

// База
Перем ИмяБазы Экспорт;
Перем СерверБазы Экспорт;
Перем ПортБазы Экспорт;

// RAS
Перем СерверRAS Экспорт;
Перем ПортRAS Экспорт;

// Конфигуратор
Перем ЛогинККонфигуратору Экспорт;
Перем ПарольККонфигуратору Экспорт;

// Хранилище
Перем ПутьКХранилищу Экспорт;
Перем ЛогинКХранилищу Экспорт;
Перем ПарольКХранилищу Экспорт;

// SQL
Перем ТипСУБД Экспорт;
Перем СерверSQL Экспорт;
Перем ИмяБазыSQL Экспорт;
Перем ИмяПользователяSQL Экспорт;
Перем ПарольSQL Экспорт;

// Блокировка
Перем СообщениеПриБлокировкиИБ Экспорт;
Перем КодДоступаПриБлокировкиИБ Экспорт;

// Соответствие расширений конфигурации со структурой настроек
// Имя
// ПутьКХранилищу
// ЛогинКХранилищу
// ПарольКХранилищу
Перем РасширенияКонфигурации Экспорт;

// Каталоги
Перем ПутьККаталогуCF Экспорт;
Перем ПутьККаталогуCFe Экспорт;

// Доп. параметры
Перем ИдентификаторБазы Экспорт;
Перем ИдентификаторГрупповыхКоманд Экспорт;
Перем РежимDebug Экспорт;
Перем ПозицияВГрупповой Экспорт;
Перем ПутьКФайлуБлокировкиЗапуска Экспорт;
Перем Фоново Экспорт;
Перем ИспользоватьPowerShell Экспорт;
Перем ПаузаПередЗапуском Экспорт;
Перем СписокМетаданных Экспорт;
Перем ОбновлятьОбъектыРекурсивно Экспорт;
Перем ИспользоватьДинамическоеОбновление Экспорт;
Перем ОставитьБлокировкуИБ Экспорт;

// autumn-properties.yml;
&Деталька("Общие.Ответственный")
Перем Ответственный Экспорт;
&Деталька("Общие.Debug.ФайлНастроек")
Перем Debug_ФайлНастроек Экспорт;

// Личные
&Деталька("Личные.Конфигуратор.Логин")
Перем ЛичныеЛогинККонфигуратору Экспорт;
&Деталька("Личные.Конфигуратор.Пароль")
Перем ЛичныеПарольККонфигуратору Экспорт;

Функция ПолныйПутьКФайлуНастроек(ИмяФайла, КаталогНастроек = Неопределено) Экспорт
	
	Если КаталогНастроек = Неопределено Тогда
		КаталогНастроек = ФайлыНастроек.Каталог;		
	КонецЕсли;

	Возврат ТекущийКаталог() 
				+ "\" 
				+ КаталогНастроек 
				+ "\" 
				+ ИмяФайла;

КонецФункции

Функция СформироватьПутьКФайлуБлокировкиЗапуска(Позиция) Экспорт
	
	стрПозиция = Формат(Позиция, "ЧН=; ЧГ=");
	ИмяФайла = "synclock_" + стрПозиция;
	ПутьКФайлу = ОбъединитьПути(ТекущийКаталог(), ИмяФайла);
	ПутьКФайлу = ПутьКФайлу + ".txt";		
	
	Возврат ПутьКФайлу;

КонецФункции

&Желудь
Процедура ПриСозданииОбъекта()

	КомандыВыполнения = Новый Массив; 
	ГрупповыеКоманды = Новый Массив;

	ПараметрыПодключения = Новый Структура; 
	ПараметрыКоманд = Новый Структура; 
	ПараметрыТелеграм = Новый Структура; 
	ПараметрыDebug = Новый Структура; 
	ФайлыНастроек = Новый Структура; 

	ИдентификаторБазы = "";
	ИдентификаторГрупповыхКоманд = "";

	Расписание = Новый Массив;

	Фоново = Ложь;
	ИспользоватьPowerShell = Ложь;
	
	РежимDebug = Истина;
	ПозицияВГрупповой = 0;

	Идентификатор = "";
	СписокМетаданных = "";

	РасширенияКонфигурации = Новый Соответствие;
	ПаузаПередЗапуском = 0;
	
КонецПроцедуры