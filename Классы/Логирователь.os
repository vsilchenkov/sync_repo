#Использовать logos
#Использовать "../srс/Модули"

&Пластилин
Перем Настройки;

&Пластилин
Перем Телеграм;

Перем Лог;

Процедура ВЛог(Знач ТекстСообщения, Ошибка = Ложь, ВТелеграм = Ложь, 
						Знач ТекстСообщенияТелеграм = "", Эмодзи = "") Экспорт 
	
	УбратьВИсключенииСтрокуКода(ТекстСообщения);
	ЗаменитьПараметрыВТексте(ТекстСообщения);
	ДополнитьОсновныеПараметрыВТексте(ТекстСообщения);

	Начало = ТекущаяДата();
	ТекстСообщенияПолный = Строка(Формат(Начало, "ДФ=ЧЧ:мм:сс")) + ": " + ТекстСообщения;
	
	Если Ошибка = Истина Тогда
		Лог.Ошибка(ТекстСообщенияПолный);
	Иначе
		Лог.Информация(ТекстСообщенияПолный);
	КонецЕсли;
	
	Если ВТелеграм Тогда
		Если ЗначениеЗаполнено(ТекстСообщенияТелеграм) Тогда
			УбратьВИсключенииСтрокуКода(ТекстСообщенияТелеграм);
			ЗаменитьПараметрыВТексте(ТекстСообщенияТелеграм);
			ДополнитьОсновныеПараметрыВТексте(ТекстСообщенияТелеграм);
		Иначе
			ТекстСообщенияТелеграм = ТекстСообщения;			
		КонецЕсли;
		Телеграм.ВЛог(ТекстСообщенияТелеграм, Ошибка, Эмодзи);			
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиЛогИзФайла(ПутьКФайлу, Выведенные = Неопределено, Позиция = 0) Экспорт
	
	Если Выведенные = Неопределено Тогда
		Выведенные = Новый Массив();	
	КонецЕсли;

	Сообщения = РаботаСФайлами.ПрочитатьФайлВМассивСтрок(ПутьКФайлу, Ложь);

	Для каждого ИсходноеСообщение Из Сообщения Цикл

		Если Выведенные.Найти(ИсходноеСообщение) <> Неопределено Тогда
			Продолжить;	
		КонецЕсли;

		Если СтрНайти(ИсходноеСообщение, "ОШИБКА -") > 0 Тогда
			Статус = СтатусСообщения.Важное;
		Иначе
			Статус = СтатусСообщения.БезСтатуса;
		КонецЕсли;
		
		Если Позиция > 0 Тогда
			ТекстСообщения = "Команда №" + Строка(Позиция) + " " + ИсходноеСообщение;
		Иначе
			ТекстСообщения = ИсходноеСообщение;
		КонецЕсли;
		
		Сообщить(ТекстСообщения, Статус);
		Выведенные.Добавить(ИсходноеСообщение);

	КонецЦикла;

КонецПроцедуры

Процедура ЗаменитьПараметрыВТексте(Текст, Разделитель = "#") Экспорт
	
	Если СтрНайти(Текст, Разделитель) = 0 Тогда
		Возврат;		
	КонецЕсли;

	Для Каждого КлючЗначение Из Настройки.ПараметрыПодключения Цикл
		Ключ = КлючЗначение.Ключ;
		Если СтрНайти(Текст, Ключ) > 0 Тогда
			Текст = ЗаменитьПараметрВТексте(Текст, Ключ, КлючЗначение.Значение);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция ЗаменитьПараметрВТексте(Текст, ИмяПараметра, Знач ЗначениеПараметра, Разделитель = "#") Экспорт
	
	Если ИмяПараметра = "ИмяБазы" Тогда
		ЗначениеПараметра = """" + ЗначениеПараметра + """";		
	КонецЕсли;

	Возврат СтрЗаменить(Текст, Разделитель + ИмяПараметра, ЗначениеПараметра);	

КонецФункции

Процедура ДополнитьОсновныеПараметрыВТексте(Текст) Экспорт
	
	Если Не ТипЗнч(Настройки.ПараметрыПодключения) = Тип("Структура") Тогда
		Возврат;	
	КонецЕсли;

	ПараметрNobase = "#Nobase"; // если установлен в тексте, то имя базы прибавляем

	ИмяБазы = Общий.СвойствоСтруктуры(Настройки.ПараметрыПодключения, "ИмяБазы", "");
	Если ЗначениеЗаполнено(ИмяБазы) И СтрНайти(Текст, ИмяБазы) = 0 Тогда
		Если СтрНайти(Текст, ПараметрNobase) = 0 Тогда
			Текст = Текст + " """ + ИмяБазы + """";
		Иначе
			Текст = СтрЗаменить(Текст, ПараметрNobase, "");	
		КонецЕсли;		
	КонецЕсли;

КонецПроцедуры

Процедура УбратьВИсключенииСтрокуКода(ОписаниеОшибки)
	
	Если СтрНайти(ОписаниеОшибки, "v8runner") = 0 Тогда
		Возврат;	
	КонецЕсли;

	СтрокаГотовая = "";
	Для каждого СтрокаРазделенная Из СтрРазделить(ОписаниеОшибки, "/") Цикл
		Если СтрНайти(СтрокаРазделенная,"v8runner") > 0 Тогда
			Продолжить;	
		КонецЕсли;	
		Если СтрНайти(СтрокаРазделенная, "Ошибка в строке") > 0 Тогда
			Продолжить;	
		КонецЕсли;	
		Если Не ПустаяСтрока(СтрокаГотовая) Тогда
			СтрокаГотовая = СтрокаГотовая + " ";	
		КонецЕсли;
		СтрокаГотовая = СтрокаГотовая + СокрЛП(СтрокаРазделенная);
	КонецЦикла;

	// Удалим последний символ }, т.к. он уже в первой строке удален
	Если Прав(СтрокаГотовая, 1) = "}" Тогда
		СтрокаГотовая = Лев(СтрокаГотовая, СтрДлина(СтрокаГотовая)-1);
	КонецЕсли;

	ОписаниеОшибки = СтрокаГотовая;

КонецПроцедуры

Функция ПутьКФайлуЛога(ИмяКласса, Позиция, УдалитьСуществующий = Ложь) Экспорт
	
	ПутьКФайлу = ОбъединитьПути(ТекущийКаталог(), "var\log\" + ИмяКласса + "_" + Строка(Позиция) + ".log");

	Если УдалитьСуществующий И РаботаСФайлами.ФайлСуществует(ПутьКФайлу) Тогда
		УдалитьФайлы(ПутьКФайлу);
	КонецЕсли;	

	Возврат ПутьКФайлу;

КонецФункции

Функция LOGOS_CONFIG(Позиция = 0, sync_repo_ВФайл = Ложь) Экспорт // BSLLS:LatinAndCyrillicSymbolInWord-off
	
	СтрокаКоманды = "set LOGOS_CONFIG=logger.oscript.lib.stream=INFO, stream;"
					+ "appender.stream=ВыводЛогаВФайл;"
					+ "appender.stream.file=var\log\stream#Позиция.log;"
					+ "logger.oscript.lib.v8runner=INFO, v8runner;"
					+ "appender.v8runner=ВыводЛогаВФайл;"
					+ "appender.v8runner.file=var\log\v8runner#Позиция.log;";

	Если sync_repo_ВФайл Тогда
		СтрокаКоманды = СтрокаКоманды 
						+ "logger.oscript.lib.sync_repo=INFO, sync_repo;"
						+ "appender.sync_repo=ВыводЛогаВФайл;"
						+ "appender.sync_repo.file=var\log\sync_repo#Позиция.log;";
	КонецЕсли;

	Если Позиция = 0 Тогда
		ЗначениеПозиции = "";
	Иначе
		ЗначениеПозиции = "_" + Строка(Позиция);	
	КонецЕсли;

	СтрокаКоманды = ЗаменитьПараметрВТексте(СтрокаКоманды, "Позиция", ЗначениеПозиции);

	Возврат СтрокаКоманды;

КонецФункции

&Желудь
Процедура ПриСозданииОбъекта()
    Лог = Логирование.ПолучитьЛог("oscript.lib.sync_repo");
КонецПроцедуры