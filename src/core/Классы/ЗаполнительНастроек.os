#Использовать configor
#Использовать "..//../../src/Модули"

&Пластилин
Перем Настройки;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

&Пластилин
Перем ФиксаторОшибок;

&Пластилин
Перем Телеграм;

&Пластилин
Перем Завершатель; // BSLLS:Typo-off

// BSLLS:CyclomaticComplexity-off
// BSLLS:CognitiveComplexity-off 

Процедура ЗаполнитьНачальныеНастройки(Опции, Повторно = Ложь) Экспорт  // BSLLS:MissingParameterDescription-off
	
	Если Не ПроверитьОбязательныеОпции(Опции) Тогда
		Возврат;		
	КонецЕсли;

	ПутьКФайлуConfig = Опции.Config;
	
	УказательПлатформы = Опции.Platform;
	УказательПлатформыПоУмолчанию = "Платформа";

	Настройки.ИдентификаторБазы = Опции.ИдентификаторБазы;
	
	ПутьКФайлуCommands = Опции.Commands;
	ПутьКФайлуGroupCommands = Опции.GroupCommands;
	ПозицияВГрупповой = Опции.GroupPosition;

	ИдентификаторКоманд = Опции.ИдентификаторКоманд;
	ИдентификаторГрупповыхКоманд = Опции.ИдентификаторГрупповыхКоманд;
	
	Ответственный = Опции.Ответственный;
	Если ЗначениеЗаполнено(Ответственный) Тогда
		Настройки.Ответственный = Ответственный;
	КонецЕсли;

	Настройки.Фоново = Опции.Фоново = Истина;
	Настройки.ИспользоватьPowerShell = Опции.ИспользоватьPowerShell = Истина;
	Настройки.ИспользоватьДинамическоеОбновление = Опции.ИспользоватьДинамическоеОбновление = Истина;
	Настройки.ОставитьБлокировкуИБ = Опции.ОставитьБлокировкуИБ = Истина;
	
	Настройки.ПаузаПередЗапуском = Опции.ПаузаПередЗапуском;
	Настройки.СписокМетаданных = Опции.СписокМетаданных;
	Настройки.ОбновлятьОбъектыРекурсивно = Опции.ОбновлятьОбъектыРекурсивно = Истина;
	
	РежимDebug = Опции.РежимDebug = Истина;
	Настройки.РежимDebug = РежимDebug;

	Если РежимDebug = Истина Тогда
		ПутьКФайлуConfig = Настройки.Debug_ФайлНастроек;
	КонецЕсли;

	Настройки.ПараметрыDebug    = Новый Структура("КаталогСкрипта", "");
	Настройки.ПозицияВГрупповой = ПозицияВГрупповой;
	ФиксаторОшибок.Инициализировать(ПозицияВГрупповой);
	
	Если НЕ ЗначениеЗаполнено(ПутьКФайлуGroupCommands) Тогда
	
		МенеджерПараметров = РаботаСФайлами.ПрочитатьYAMLФайл(ПутьКФайлуConfig);
		
		ПараметрыОбщие = МенеджерПараметров.Параметр("Общие");
		Настройки.Идентификатор = ПараметрыОбщие.Получить("Идентификатор");

		Настройки.ПараметрыРасписания = МенеджерПараметров.Параметр("Расписание");
		Настройки.ПараметрыКонфигурации = МенеджерПараметров.Параметр("Конфигурация");		
		
		Настройки.ПараметрыПлатформы = МенеджерПараметров.Параметр(УказательПлатформы);	

		Если Настройки.РежимDebug Тогда
			ПереопределитьПараметрыDebug(МенеджерПараметров, ИдентификаторКоманд, ПутьКФайлуCommands, 
											ПутьКФайлуGroupCommands, ИдентификаторГрупповыхКоманд);
		КонецЕсли;
		
		Если Настройки.ПараметрыПлатформы = Неопределено Тогда
			Завершатель.ЗавершитьПоОшибке("Группа команд - " + УказательПлатформы 
											+ " в файле настроек " + ПутьКФайлуConfig + " не найдена");
		КонецЕсли;

		Настройки.ПараметрыБазы = МенеджерПараметров.Параметр(Настройки.ИдентификаторБазы);

		Если НЕ ЗначениеЗаполнено(ИдентификаторКоманд) Тогда
			Если Не ЗначениеЗаполнено(ПутьКФайлуCommands) Тогда
				Логирователь.ВЛог("Не передан параметр ""ИдентификаторКоманд"" - для базы " + Настройки.ИдентификаторБазы, Истина);
				Завершатель.ЗавершитьПоОшибке();	
			Иначе
				// по умолчанию
				ИдентификаторКоманд = "Команды";
			КонецЕсли;		
		КонецЕсли;

		Если Не ЗначениеЗаполнено(ПутьКФайлуCommands) Тогда
			КорневыеПараметрыКоманд = Настройки.ПараметрыБазы;
		Иначе			
			МенеджерПараметров = РаботаСФайлами.ПрочитатьYAMLФайл(ПутьКФайлуCommands);
			КорневыеПараметрыКоманд = МенеджерПараметров.Параметр(Настройки.ИдентификаторБазы);
		КонецЕсли;
		
	Иначе
		Настройки.ПараметрыОбщие = Новый Соответствие();
		Настройки.ПараметрыРасписания = Новый Массив;
		Настройки.ПараметрыПлатформы = Новый Соответствие();
		Настройки.ПараметрыБазы = Новый Соответствие();
	КонецЕсли;

	Если ЗначениеЗаполнено(ПутьКФайлуGroupCommands) Тогда
		Если НЕ ЗначениеЗаполнено(ИдентификаторГрупповыхКоманд) Тогда
			ИдентификаторГрупповыхКоманд = "Запуск"; // по умолчанию	
		КонецЕсли;
		Настройки.ИдентификаторГрупповыхКоманд = ИдентификаторГрупповыхКоманд;
	КонецЕсли;

	Если Не Повторно Тогда
	
		ТекстОписанияНастроек = Символы.ПС;
		ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "-----------------------------");	
		ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Текущий каталог: " + ТекущийКаталог());
		Если ЗначениеЗаполнено(ПутьКФайлуGroupCommands) Тогда	
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Идентификатор групповых команд: " + ИдентификаторГрупповыхКоманд);
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Файл групповых команд: " + ПутьКФайлуGroupCommands);		
		Иначе
	
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Файл настроек: " + ПутьКФайлуConfig);
			Если УказательПлатформы <> УказательПлатформыПоУмолчанию Тогда
				ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Группа настроек платформы: " + УказательПлатформы);					
			КонецЕсли;
			Если ЗначениеЗаполнено(ПутьКФайлуCommands) Тогда
				ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Файл команд: " + ПутьКФайлуCommands);		
			КонецЕсли;
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "ИдентификаторБазы: " + Настройки.ИдентификаторБазы);
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "ИдентификаторКоманд: " + ИдентификаторКоманд);	
			
			НачатьСПозиции = Опции.НачатьСПозиции;
			Если ЗначениеЗаполнено(НачатьСПозиции) И НачатьСПозиции <> 1 Тогда
				ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Запуск команд с позиции: " + Строка(НачатьСПозиции));				
			КонецЕсли;

		КонецЕсли;
		Если Настройки.ПаузаПередЗапуском <> 0 Тогда
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, 
									"Установлена пауза перед запуском: " + Строка(Настройки.ПаузаПередЗапуском));		
		КонецЕсли;
		Если Настройки.ИспользоватьДинамическоеОбновление Тогда
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Обновляемся динамически");		
		КонецЕсли;
		Если Настройки.ОставитьБлокировкуИБ Тогда
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Оставляем блокировку ИБ");		
		КонецЕсли;
		Если Настройки.Фоново Тогда
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Включен фоновый запуск");		
		КонецЕсли;
		Если Настройки.РежимDebug Тогда
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Режим Debug");		
		КонецЕсли;
		Если Настройки.ИспользоватьPowerShell Тогда
			ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "Использую PowerShell");		
		КонецЕсли;
		ДобавитьСтрокуЧерезПС(ТекстОписанияНастроек, "-----------------------------");
		Логирователь.ВЛог(ТекстОписанияНастроек);	

	КонецЕсли;
	
	Настройки.ГрупповыеКоманды = Новый Массив;
	Если ЗначениеЗаполнено(ПутьКФайлуGroupCommands) Тогда
		ЗаполнитьГрупповыеКоманды(ИдентификаторГрупповыхКоманд, ПутьКФайлуGroupCommands);
	Иначе
		ЗаполнитьКоманды(ИдентификаторКоманд, КорневыеПараметрыКоманд);
		ЗаполнитьОбщиеПараметры();
		ЗаполнитьРасписание();
		ЗаполнитьПараметрыПодключения();
		ЗаполнитьДанныеФайловНастроек();
	КонецЕсли;
	
	Настройки.ПараметрыОбщие.Вставить("ПутьКФайлуConfig", ПутьКФайлуConfig); 
	Настройки.ПараметрыОбщие.Вставить("ПутьКФайлуCommands", ПутьКФайлуCommands); 
	Настройки.ПараметрыОбщие.Вставить("ПутьКФайлуGroupCommands", ПутьКФайлуGroupCommands); 
	Настройки.ПараметрыОбщие.Вставить("ИдентификаторКоманд", ИдентификаторКоманд);

	Если ТипЗнч(Настройки.ПараметрыБазы) <> Тип("Соответствие") Тогда
		Логирователь.ВЛог("Нет настроек для базы - " + Настройки.ИдентификаторБазы, Истина);
		Завершатель.ЗавершитьПоОшибке();
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьКоманды(ИдентификаторКоманд, КорневыеПараметры)
	
	ТипСоответствие = Тип("Соответствие");
	Если Не ТипЗнч(КорневыеПараметры) = ТипСоответствие Тогда
		Завершатель.ЗавершитьПоОшибке("Не найдены команды в файле команд");
		Возврат;
	КонецЕсли;

	ДанныеКоманд = КорневыеПараметры.Получить(ИдентификаторКоманд);
	Если ТипЗнч(ДанныеКоманд) <> ТипСоответствие Тогда

		// Проверим якорь
		Якорь = КорневыеПараметры.Получить("<<");
		Если Якорь <> Неопределено Тогда
			ДанныеКоманд = Якорь.Получить(ИдентификаторКоманд);		
		КонецЕсли;

		Если ТипЗнч(ДанныеКоманд) <> ТипСоответствие Тогда
			Логирователь.ВЛог("Не найдены команды - " + ИдентификаторКоманд, Истина);
			Завершатель.ЗавершитьПоОшибке();
		КонецЕсли;

	КонецЕсли;

	Настройки.КомандыВыполнения = ДанныеКоманд.Получить("Команды");
	Если ТипЗнч(Настройки.КомандыВыполнения) <> Тип("Массив") Тогда
		Логирователь.ВЛог("Нет списка команд - " + ИдентификаторКоманд, Истина);
		Завершатель.ЗавершитьПоОшибке();
	КонецЕсли;

	ЗаполнитьПараметрыКоманд(ДанныеКоманд);

КонецПроцедуры

Процедура ЗаполнитьПараметрыКоманд(ДанныеКоманд)
	
	// Параметры команд
	Настройки.ПараметрыКоманд = Новый Структура();	

	ДанныеПараметров = ДанныеКоманд.Получить("Параметры");
	Если ДанныеПараметров <> Неопределено Тогда
		
		Приветствие = ДанныеПараметров.Получить("Приветствие");
		Начало      =  ДанныеПараметров.Получить("Начало");
		Окончание   = ДанныеПараметров.Получить("Окончание");
		
		Пауза                   = ДанныеПараметров.Получить("Пауза");
		КлючиЗапускаПредприятия = ДанныеПараметров.Получить("КлючиЗапускаПредприятия");
		КомментарийПриПомещенииВХранилище = ДанныеПараметров.Получить("КомментарийПриПомещенииВХранилище");
		СниматьБлокировкуРегламентныхЗаданий = ДанныеПараметров.Получить("СниматьБлокировкуРегламентныхЗаданий");
		ОтправлятьСообщенияВТелеграм = ДанныеПараметров.Получить("ОтправлятьСообщенияВТелеграм");
		ТекстВопроса = ДанныеПараметров.Получить("ТекстВопроса");
		
	Иначе
		Приветствие             = "";	
		Начало                  = "";
		Окончание               = "";
		Пауза                   = "0";
		КлючиЗапускаПредприятия = "";
		КомментарийПриПомещенииВХранилище = "";
		СниматьБлокировкуРегламентныхЗаданий = Ложь;
		ОтправлятьСообщенияВТелеграм = Ложь;
		ТекстВопроса = "";
	КонецЕсли;

	Настройки.ПараметрыКоманд.Вставить("Приветствие",             Приветствие);
	Настройки.ПараметрыКоманд.Вставить("Начало",                  Начало);
	Настройки.ПараметрыКоманд.Вставить("Окончание",               Окончание);
	Настройки.ПараметрыКоманд.Вставить("Пауза",                   Пауза);	
	Настройки.ПараметрыКоманд.Вставить("КлючиЗапускаПредприятия", КлючиЗапускаПредприятия);
	Настройки.ПараметрыКоманд.Вставить("КомментарийПриПомещенииВХранилище", КомментарийПриПомещенииВХранилище);	
	Настройки.ПараметрыКоманд.Вставить("СниматьБлокировкуРегламентныхЗаданий", СниматьБлокировкуРегламентныхЗаданий);	
	Настройки.ПараметрыКоманд.Вставить("ОтправлятьСообщенияВТелеграм", ОтправлятьСообщенияВТелеграм);
	Настройки.ПараметрыКоманд.Вставить("ТекстВопроса",            ТекстВопроса);

КонецПроцедуры

Процедура ЗаполнитьГрупповыеКоманды(ИдентификаторГрупповыхКоманд, ПутьКФайлу)
	
	МенеджерПараметров = РаботаСФайлами.ПрочитатьYAMLФайл(ПутьКФайлу);

	ТипСоответствие = Тип("Соответствие");
	КорневыеПараметрыКоманд = МенеджерПараметров.Параметр(ИдентификаторГрупповыхКоманд);
	Если НЕ ТипЗнч(КорневыеПараметрыКоманд) = ТипСоответствие Тогда
		ВызватьИсключение "Не найдены групповые команды - " + ИдентификаторГрупповыхКоманд;
	КонецЕсли;

	ДанныеПараметров = КорневыеПараметрыКоманд.Получить("Параметры");
	ДанныеКоманд = КорневыеПараметрыКоманд.Получить("Команды");

	Если Не ТипЗнч(ДанныеКоманд) = Тип("Массив") Тогда
		ВызватьИсключение "Не найден список команд для - " + ИдентификаторГрупповыхКоманд;
	КонецЕсли;

	Если НЕ ТипЗнч(ДанныеПараметров) = ТипСоответствие Тогда
		ДанныеПараметров = Новый Соответствие;
	КонецЕсли;

	Для каждого ДанныеГрупповой Из ДанныеКоманд Цикл
	
		ТипДанныхГрупповой = ТипЗнч(ДанныеГрупповой);
		Если ТипДанныхГрупповой = Тип("Соответствие") Тогда
			
			ГруппаПоследовательной = Новый Массив;
			КомандыПоследовательные = ДанныеГрупповой.Получить("Последовательно");
			Если ТипЗнч(КомандыПоследовательные) = Тип("Массив") Тогда
				Для каждого ДанныеПоследовательной Из КомандыПоследовательные Цикл
					ДобавитьГрупповуюКоманду(ДанныеПоследовательной, ДанныеПараметров, ГруппаПоследовательной);							
				КонецЦикла;
			КонецЕсли;
			Если ГруппаПоследовательной.Количество() > 0 Тогда
				Настройки.ГрупповыеКоманды.Добавить(ГруппаПоследовательной);				
			КонецЕсли;

		Иначе
			ДобавитьГрупповуюКоманду(ДанныеГрупповой, ДанныеПараметров);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьГрупповуюКоманду(СтрокаКоманды, ДанныеПараметров, Знач ГрупповыеКоманды = Неопределено)
	
	Если ТипЗнч(СтрокаКоманды) <> Тип("Строка") Тогда
		ВызватьИсключение "Не определена групповая команда - " + Строка(СтрокаКоманды);	
	КонецЕсли;

	Если ГрупповыеКоманды = Неопределено Тогда
		ГрупповыеКоманды = Настройки.ГрупповыеКоманды;
	КонецЕсли;

	Разделитель = "%";

	Для каждого КлючЗначение Из ДанныеПараметров Цикл
		ИмяПараметра = КлючЗначение.Ключ;
		ЗначениеПараметра = КлючЗначение.Значение;
		СтрокаКоманды = Логирователь.ЗаменитьПараметрВТексте(СтрокаКоманды, ИмяПараметра, ЗначениеПараметра, Разделитель);
	КонецЦикла;

	СтрокаКоманды = Логирователь.ЗаменитьПараметрВТексте(СтрокаКоманды, "ПС", Символы.ПС, Разделитель);
	ГрупповыеКоманды.Добавить(СтрокаКоманды);

КонецПроцедуры

Процедура ЗаполнитьОбщиеПараметры()

	Настройки.ПараметрыТелеграм = Новый Структура();

	ЗаполнитьПараметрыТелеграм();
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыТелеграм()
	
	// Телеграм
	ДанныеПараметров = Настройки.ПараметрыОбщие.Получить("Телеграм");
	Если ТипЗнч(ДанныеПараметров) <> Тип("Соответствие") Тогда
		ДанныеПараметров = Новый Соответствие();
	КонецЕсли;
	
	ОтправлятьСообщения = Общий.ПризнакВключенияПараметра("ОтправлятьСообщенияВТелеграм", Настройки.ПараметрыКоманд);	
	Настройки.ПараметрыТелеграм.Вставить("ОтправлятьСообщения", ОтправлятьСообщения);	
	Настройки.ПараметрыТелеграм.Вставить("BotID", Строка(ДанныеПараметров.Получить("BotID")));
	Настройки.ПараметрыТелеграм.Вставить("Токен", Строка(ДанныеПараметров.Получить("Токен")));

	Если Настройки.РежимDebug = Истина Тогда
		
		Настройки.ПараметрыТелеграм.ОтправлятьСообщения = Ложь;		
	
	Иначе

		Телеграм.УстановитьТокен(Настройки.ПараметрыТелеграм.Токен);

	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРасписание()
	
	// Конфигурация
	ПараметрыРасписания = Настройки.ПараметрыРасписания;
	ПривестиМассивПараметр(ПараметрыРасписания);

	Для каждого Элемент Из ПараметрыРасписания Цикл
		
		ДеньНедели = Элемент.Получить("ДеньНедели");
		ПривестиЧисловойПараметр(ДеньНедели);

		ПараметрыВремени = Элемент.Получить("Параметры");
		ПривестиМассивПараметр(ПараметрыВремени);

		ВремяКэш = Новый Соответствие();
		ВремяКэш.Вставить("ВремяС", 0);
		ВремяКэш.Вставить("ВремяПо", 0);

		Для каждого ЭлементВремени Из ПараметрыВремени Цикл
			
			Для каждого ЭлементПараметра Из Общий.СкопироватьСоответствие(ВремяКэш) Цикл
				Ключ = ЭлементПараметра.Ключ;
				Значение = ЭлементВремени.Получить(ЭлементПараметра.Ключ);
				Если Значение <> Неопределено Тогда
					ПривестиЧисловойПараметр(Значение);
					ВремяКэш.Вставить(Ключ, Значение);
				КонецЕсли;
			КонецЦикла;
						
		КонецЦикла;

		ЭлементРасписания = Новый Структура("ДеньНедели", ДеньНедели);
		Время = Новый Массив;
		СтруктураВремени = Новый Структура("С, По", 
							ВремяКэш.Получить("ВремяС"), 
							ВремяКэш.Получить("ВремяПо"));
		Время.Добавить(СтруктураВремени);
		ЭлементРасписания.Вставить("Время", Время);

		Настройки.Расписание.Добавить(ЭлементРасписания);

	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыПодключения()

	Настройки.ПараметрыПодключения = Новый Структура();

	// BSLLS:DuplicateStringLiteral-off

	// Общие
	Настройки.ПараметрыПодключения.Вставить("Идентификатор", Строка(Настройки.Идентификатор));
	
	// Конфигурация
	ПараметрыКонфигурации = Настройки.ПараметрыКонфигурации;
	ПривестиПустыеПараметры(ПараметрыКонфигурации);
	Настройки.ПараметрыПодключения.Вставить("ИмяКонфигурации", ПараметрыКонфигурации.Получить("Имя")); 
	
	Ответственный = Настройки.Ответственный;
	Если НЕ ЗначениеЗаполнено(Ответственный) Или Ответственный = "Фамилия Имя" Тогда
		Завершатель.ЗавершитьПоОшибке("Заполни ответственного в файле autumn-properties.yml");
		Возврат;		
	КонецЕсли;

	Настройки.ПараметрыПодключения.Вставить("Ответственный", Ответственный);	
	
	// Платформа
	Настройки.ПараметрыПодключения.Вставить("ПутьКПлатформе",  Настройки.ПараметрыПлатформы.Получить("1cv8"));
	Настройки.ПараметрыПодключения.Вставить("ВерсияПлатформы", Настройки.ПараметрыПлатформы.Получить("Версия"));

	// RAS
	ПараметрыRAS = Настройки.ПараметрыПлатформы.Получить("RAS");
	ПривестиПустыеПараметры(ПараметрыRAS);
	Настройки.ПараметрыПодключения.Вставить("СерверRAS", ПараметрыRAS.Получить("Сервер")); 
	Настройки.ПараметрыПодключения.Вставить("ПортRAS",   ПараметрыRAS.Получить("Порт"));

	// Обновление
	ПараметрыОбновления = Настройки.ПараметрыПлатформы.Получить("Обновление");
	ПривестиПустыеПараметры(ПараметрыОбновления);
	Настройки.ПараметрыПодключения.Вставить("СообщениеПриБлокировкиИБ",   ПараметрыОбновления.Получить("Сообщение"));
	Настройки.ПараметрыПодключения.Вставить("КодДоступаПриБлокировкиИБ",  ПараметрыОбновления.Получить("КодДоступа"));
	
	// База
	ПараметрыБазы = Настройки.ПараметрыБазы;
	ПривестиПустыеПараметры(ПараметрыБазы);
	Настройки.ПараметрыПодключения.Вставить("ИмяБазы",    ПараметрыБазы.Получить("ИмяБазы")); 
	Настройки.ПараметрыПодключения.Вставить("СерверБазы", ПараметрыБазы.Получить("Сервер"));
	Настройки.ПараметрыПодключения.Вставить("ПортБазы",   ПараметрыБазы.Получить("Порт"));

	// Конфигуратор
	ПараметрыКонфигуратора = ПараметрыБазы.Получить("Конфигуратор");
	ПривестиПустыеПараметры(ПараметрыКонфигуратора);
	
	Если Настройки.ЛичныеЛогинККонфигуратору <> Неопределено Тогда
		ЛогинККонфигуратору = Строка(Настройки.ЛичныеЛогинККонфигуратору);
		ПарольККонфигуратору = Строка(Настройки.ЛичныеПарольККонфигуратору);
	Иначе
		ЛогинККонфигуратору = ПараметрыКонфигуратора.Получить("Логин");
		ПарольККонфигуратору = ПараметрыКонфигуратора.Получить("Пароль");
	КонецЕсли;
	
	Настройки.ПараметрыПодключения.Вставить("ЛогинККонфигуратору",  ЛогинККонфигуратору);
	Настройки.ПараметрыПодключения.Вставить("ПарольККонфигуратору", ПарольККонфигуратору);

	// Хранилище
	ПараметрыХранилища = ПараметрыБазы.Получить("Хранилище");
	ПривестиПустыеПараметры(ПараметрыХранилища);
	Настройки.ПараметрыПодключения.Вставить("ПутьКХранилищу",   ПараметрыХранилища.Получить("Путь"));
	Настройки.ПараметрыПодключения.Вставить("ЛогинКХранилищу",  ПараметрыХранилища.Получить("Логин"));
	Настройки.ПараметрыПодключения.Вставить("ПарольКХранилищу", ПараметрыХранилища.Получить("Пароль"));

	// SQL Хранилище
	ПараметрыSQL = ПараметрыБазы.Получить("SQL");
	ПривестиПустыеПараметры(ПараметрыSQL);
	Настройки.ПараметрыПодключения.Вставить("ТипСУБД",            ПараметрыSQL.Получить("ТипСУБД"));
	Настройки.ПараметрыПодключения.Вставить("СерверSQL",          ПараметрыSQL.Получить("Сервер"));
	Настройки.ПараметрыПодключения.Вставить("ИмяБазыSQL",         ПараметрыSQL.Получить("ИмяБазы"));
	Настройки.ПараметрыПодключения.Вставить("ИмяПользователяSQL", ПараметрыSQL.Получить("ИмяПользователя"));
	Настройки.ПараметрыПодключения.Вставить("ПарольSQL",          ПараметрыSQL.Получить("Пароль"));

	ЗаполнитьЗначенияСвойств(Настройки, Настройки.ПараметрыПодключения);
	
	ЗаполнитьПараметрыРасширенийКонфигурации(ПараметрыБазы);
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасширенийКонфигурации(ПараметрыБазы)
	
	Расширения = ПараметрыБазы.Получить("Расширения");
	Если Не ТипЗнч(Расширения) = Тип("Массив") Тогда
		Возврат;		
	КонецЕсли;

	Для каждого НастройкиРасширения Из Расширения Цикл
		
		Имя = НастройкиРасширения.Получить("Имя");
		
		ДанныеРасширения = Новый Структура;				
		ДанныеРасширения.Вставить("Имя", Имя);

		ПараметрыХранилища = НастройкиРасширения.Получить("Хранилище"); 
		ПривестиПустыеПараметры(ПараметрыХранилища);
		ДанныеРасширения.Вставить("ПутьКХранилищу",   ПараметрыХранилища.Получить("Путь"));
		ДанныеРасширения.Вставить("ЛогинКХранилищу",  ПараметрыХранилища.Получить("Логин"));
		ДанныеРасширения.Вставить("ПарольКХранилищу", ПараметрыХранилища.Получить("Пароль"));

		Настройки.РасширенияКонфигурации.Вставить(Имя, ДанныеРасширения);
		
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьДанныеФайловНастроек()
	
	Настройки.ФайлыНастроек = Новый Структура();
	Настройки.ФайлыНастроек.Вставить("Каталог", Настройки.ПараметрыОбщие.Получить("КаталогНастроек"));

	ИменаФайлов = Настройки.ПараметрыОбщие.Получить("Файлы");
	Если ТипЗнч(ИменаФайлов) <> Тип("Соответствие") Тогда
		ВызватьИсключение "Не найдена секция ""Файлы"" в группе ""Общие"" в файле настроек";
	КонецЕсли;
		
	Настройки.ФайлыНастроек.Вставить("repo_test", ИменаФайлов.Получить("repo_test"));
	Настройки.ФайлыНастроек.Вставить("merge", ИменаФайлов.Получить("merge"));

	metadata_name = ИменаФайлов.Получить("metadata");
	Если Не ЗначениеЗаполнено(metadata_name) Тогда
		metadata_name = "metadata.txt";	
	КонецЕсли;
	Настройки.ФайлыНастроек.Вставить("metadata", metadata_name);

	metadata_merge = ИменаФайлов.Получить("metadata_merge");
	Если Не ЗначениеЗаполнено(metadata_merge) Тогда
		metadata_merge = "metadata_merge.xml";	
	КонецЕсли;
	Настройки.ФайлыНастроек.Вставить("metadata_merge", metadata_merge);

	ИмяКаталогаПоУмолчанию = "cf";
	ПутьВНастройках = "ПутьККаталогуCF";
	УстановитьКаталогФайловНастроек(ИмяКаталогаПоУмолчанию, ПутьВНастройках);

	ИмяКаталогаПоУмолчанию = "cfe";
	ПутьВНастройках = "ПутьККаталогуCFe";
	УстановитьКаталогФайловНастроек(ИмяКаталогаПоУмолчанию, ПутьВНастройках);

	ЗаполнитьЗначенияСвойств(Настройки, Настройки.ФайлыНастроек);

КонецПроцедуры

Процедура ПереопределитьПараметрыDebug(МенеджерПараметров, ИдентификаторКоманд, ПутьКФайлуCommands, 
										ПутьКФайлуGroupCommands, ИдентификаторГрупповыхКоманд)

	ДанныеПараметров = Настройки.ПараметрыОбщие.Получить("Debug");
	Настройки.ИдентификаторБазы = ДанныеПараметров.Получить("ИдентификаторБазы");
	ИдентификаторКоманд = ДанныеПараметров.Получить("ИдентификаторКоманд");
	ПутьКФайлуCommands = ДанныеПараметров.Получить("ФайлКоманд");	
	ПутьКФайлуGroupCommands = ДанныеПараметров.Получить("ФайлГрупповыхКоманд");
	ИдентификаторГрупповыхКоманд = ДанныеПараметров.Получить("ИдентификаторГрупповыхКоманд");	
	
	УказательПлатформы = ДанныеПараметров.Получить("УказательГруппыПлатформы");
	Если ЗначениеЗаполнено(УказательПлатформы) Тогда
		Настройки.ПараметрыПлатформы = МенеджерПараметров.Параметр(УказательПлатформы);	
	КонецЕсли;
	
	Настройки.ПараметрыDebug.Вставить("КаталогСкрипта", ДанныеПараметров.Получить("КаталогСкрипта"));	
	
КонецПроцедуры

Процедура УстановитьКаталогФайловНастроек(ИмяКаталога, ПутьВНастройках, ПоУмолчанию = Ложь)
	
	Если ПоУмолчанию Тогда
		ПутьККаталогу = "\" + ИмяКаталога;		
	Иначе
		ПутьККаталогу = Настройки.ПараметрыОбщие.Получить(ПутьВНастройках);
		Если Не ЗначениеЗаполнено(ПутьККаталогу) Тогда
			УстановитьКаталогФайловНастроек(ИмяКаталога, ПутьВНастройках, Истина);
			Возврат;				
		КонецЕсли;
	КонецЕсли;

	Если СтрНайти(ПутьККаталогу, ":\") = 0 Тогда
		// Относительный путь
		ПутьККаталогу = ТекущийКаталог() + ПутьККаталогу; 					
	КонецЕсли;

	Если Не РаботаСФайлами.ФайлСуществует(ПутьККаталогу) Тогда
		
		Попытка
			СоздатьКаталог(ПутьККаталогу);	
		Исключение
			ТекстСообщения = "Не удаётся создать каталог " 
								+ ИмяКаталога + " по пути в настройках" + Символы.ПС + ОписаниеОшибки();
			Логирователь.ВЛог(ТекстСообщения, Истина);
			Если Не ПоУмолчанию Тогда
				УстановитьКаталогФайловНастроек(ИмяКаталога, ПутьВНастройках, Истина);
			Иначе
				ВызватьИсключение;	
			КонецЕсли;

		КонецПопытки;

	КонецЕсли;
	Настройки.ФайлыНастроек.Вставить(ПутьВНастройках, ПутьККаталогу);

КонецПроцедуры

Процедура ДобавитьСтрокуЧерезПС(СтрокаИсходная, Текст)
	
	Если Не ПустаяСтрока(СтрокаИсходная) Тогда
		СтрокаИсходная = СтрокаИсходная + Символы.ПС;
	КонецЕсли;

	СтрокаИсходная = СтрокаИсходная + Текст;

КонецПроцедуры

Функция ПроверитьОбязательныеОпции(Опции)
	
	ИдентификаторБазы = Опции.ИдентификаторБазы;
	GroupCommands = Опции.GroupCommands;

	Если Не ЗначениеЗаполнено(ИдентификаторБазы) И Не ЗначениеЗаполнено(GroupCommands) Тогда
		
		ТекстСообщения = "Необходимо передать один из обязательных параметров:
							|--ИдентификаторБазы
							|--GroupCommands";

		Завершатель.ЗавершитьПоОшибке(ТекстСообщения);

		Возврат Ложь;

	КонецЕсли;
	
	Возврат Истина;

КонецФункции

#Область Приведение_типов

Процедура ПривестиПустыеПараметры(ПолученныеПараметры)
	Если ТипЗнч(ПолученныеПараметры) <> Тип("Соответствие") Тогда
		ПолученныеПараметры = Новый Соответствие;	
	КонецЕсли;	
КонецПроцедуры

Процедура ПривестиЧисловойПараметр(Значение)
	Если ТипЗнч(Значение) <> Тип("Число") Тогда
		ОписаниеТипа = Новый ОписаниеТипов("Число");
		Значение = ОписаниеТипа.ПривестиЗначение(Значение);		
	КонецЕсли;	
КонецПроцедуры

Процедура ПривестиМассивПараметр(Значение)
	Если ТипЗнч(Значение) <> Тип("Массив") Тогда
		Значение = Новый Массив;		
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

&Желудь
Процедура ПриСозданииОбъекта(&Пластилин ПервыйЗапуск)
	ПервыйЗапуск.Инициализация();
КонецПроцедуры