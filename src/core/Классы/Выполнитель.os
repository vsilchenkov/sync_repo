#Использовать "..//../../src/Модули"

Перем Поделка;

&Пластилин
Перем Настройки; // BSLLS:Typo-off

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

&Пластилин
Перем Завершатель; // BSLLS:Typo-off

Функция ВыполнитьКомандныйФайл(СтрокаКоманды, Позиция = 1, Фоново = Истина, Знач Имя = "") Экспорт
		
	Если Не ЗначениеЗаполнено(Имя) Тогда
		Имя = СтрокаКоманды;	
	КонецЕсли;

	ТекстСообщения = "Выполняю команду";
	Если Позиция > 0 И Фоново Тогда	
		стрПозиция = Строка(Позиция);
		ТекстСообщения = ТекстСообщения + " №" + стрПозиция;
	КонецЕсли;

	Логирователь.ВЛог(ТекстСообщения + ": " + Имя);
	
	ИспользоватьPowerShell = Настройки.ИспользоватьPowerShell;

	КомандныйФайл = Поделка.НайтиЖелудь("КомандныйФайлSR");
	
	Если ИспользоватьPowerShell Тогда
		КомандныйФайл.УстановитьПриложениеPowerShell();
		КомандныйФайл.СоздатьPowerShell();
		КомандныйФайл.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
	Иначе
		КомандныйФайл.ДобавитьКоманду("@echo off");		
	КонецЕсли;
			
	Попытка
		
		КомандныйФайл.ДобавитьКоманду(Логирователь.LOGOS_CONFIG(Позиция, Истина, ИспользоватьPowerShell));	
		КомандныйФайл.ДобавитьКоманду(СтрокаКоманды);	

		КодВозврата = КомандныйФайл.Исполнить();
		СтрокаВывода = КомандныйФайл.ПолучитьВывод();
		
	Исключение
		КодВозврата = 1;
		СтрокаВывода = ОписаниеОшибки();
	КонецПопытки;

	СтруктураВозврата = Новый Структура("КодВозврата, Вывод, Позиция", 
											КодВозврата,
											СтрокаВывода,
											Позиция);

	
	ТекстРезультата = "Результат команды №" + стрПозиция + ": Код возврата " + КодВозврата;
	ТекстВывода = "Вывод команды №" + стрПозиция + Символы.ПС + СтрокаВывода;
	
	Если КодВозврата <> 0 Тогда
		Логирователь.ВЛог(ТекстРезультата, Истина);
		Логирователь.ВЛог(ТекстВывода, Истина);	
	Иначе
		
		Логирователь.Отладка(ТекстРезультата);
		Логирователь.Отладка(ТекстВывода);

		Если НЕ Фоново Тогда
			Логирователь.ВЛог("Команда: " + Имя + " - выполнена");	
		КонецЕсли;

	КонецЕсли;

	Возврат СтруктураВозврата;

КонецФункции

Процедура СледитьЗаЛогомЗадания(Задание, ПутьКФайлу, Позиция) Экспорт
	
	Выведенные = Новый Массив();

	ПоследняяПопытка = Ложь;

	Пока Истина Цикл
		
		Если Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
			
			Если ПоследняяПопытка Тогда
				Прервать;	
			КонецЕсли;
			
			ПоследняяПопытка = Истина;

		КонецЕсли;

		Логирователь.ВывестиЛогИзФайла(ПутьКФайлу, Выведенные, Позиция);
		
		Если Не ПоследняяПопытка Тогда
			Приостановить(1000);	
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Процедура ВыполнитьКомандыМногопоточно(Команды) Экспорт // BSLLS:Typo-off
	
	Задания = Новый Массив();

	Позиция = 0;
	Для каждого ДанныеКоманды Из Команды Цикл
		
		ТипДанныхКоманды = ТипЗнч(ДанныеКоманды);
		Если ТипДанныхКоманды = Тип("Строка") Тогда
			Позиция = Позиция + 1;
			ЗапуститьФоновуюКоманду(Задания, ДанныеКоманды, Позиция);			
		ИначеЕсли ТипДанныхКоманды = Тип("Массив") Тогда
			
			// Последовательное выполнение		
			ИДБлокирующегоЗадания = Неопределено;
			Для каждого ДанныеВложенной Из ДанныеКоманды Цикл
				Позиция = Позиция + 1;
				ЗапуститьФоновуюКоманду(Задания, ДанныеВложенной, Позиция, ИДБлокирующегоЗадания);
				ИДБлокирующегоЗадания = Позиция; // передаем в следующее задание
			КонецЦикла;

		Иначе
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	ОжидатьФоновыеКоманды(Задания);

	ПроверитьРезультатВыполнения(Задания);

КонецПроцедуры

Процедура ЗапуститьФоновуюКоманду(Задания, СтрокаКоманды, Позиция, 
									ИДБлокирующегоЗадания = Неопределено, ПаузаПередСледующим = 5000)
	
	Если ТипЗнч(СтрокаКоманды) <> Тип("Строка") Тогда
		ВызватьИсключение "Не верно переданы параметры групповой команды - " + Строка(СтрокаКоманды);
	КонецЕсли;

	Если Позиция > 1 Тогда
		Приостановить(ПаузаПередСледующим);	// 5 секунд ожидаем пока запустится предудущее
	КонецЕсли;

	ИмяКласса = "sync_repo"; 
	Если СтрНайти(СтрокаКоманды, ИмяКласса) > 0 Тогда		
		ПутьКФайлуЛога = Логирователь.ПутьКФайлуЛога(ИмяКласса, Позиция, Истина);
		СтрокаКоманды = СтрокаКоманды + " --GroupPosition " + Строка(Позиция);
		Если ЗначениеЗаполнено(ИДБлокирующегоЗадания) Тогда
			СтрокаКоманды = СтрокаКоманды + " --Lock " + Формат(ИДБлокирующегоЗадания, "ЧН=; ЧГ=");
		КонецЕсли;
	Иначе
		ПутьКФайлуЛога = Неопределено;	
	КонецЕсли;

	// Основное задание
	Параметры = Новый Массив(2);
	Параметры[0] = СтрокаКоманды;
	Параметры[1] = Позиция;

	ОсновноеЗадание = ФоновыеЗадания.Выполнить(ЭтотОбъект, "ВыполнитьКомандныйФайл", Параметры);
	Задания.Добавить(ОсновноеЗадание);

	// Следитель
	Если ПутьКФайлуЛога <> Неопределено Тогда

		Параметры = Новый Массив(3);
		Параметры[0] = ОсновноеЗадание;
		Параметры[1] = ПутьКФайлуЛога;
		Параметры[2] = Позиция;

		Следитель = ФоновыеЗадания.Выполнить(ЭтотОбъект, "СледитьЗаЛогомЗадания", Параметры); // BSLLS:Typo-off
		Задания.Добавить(Следитель);
	
	КонецЕсли;

КонецПроцедуры

Процедура ОжидатьФоновыеКоманды(Задания)

	Попытка
		ФоновыеЗадания.ОжидатьВсе(Задания);
	Исключение
		
		МассивЗаданий = ИнформацияОбОшибке().Параметры;

		Если МассивЗаданий <> Неопределено Тогда

			ШаблонТекстаОшибки = 
				"Ошибки при выполнении команд:
				|%1";

			Для Каждого Задание Из МассивЗаданий Цикл
				
				МассивОшибок = Новый Массив();
				МассивОшибок.Добавить(Задание.ИнформацияОбОшибке.ПодробноеОписаниеОшибки());

			КонецЦикла;

			ВызватьИсключение СтрШаблон(
				ШаблонТекстаОшибки,
				СтрСоединить(МассивОшибок, Символы.ПС));

		КонецЕсли;

	КонецПопытки;

КонецПроцедуры

Процедура ПроверитьРезультатВыполнения(Задания) // BSLLS:CognitiveComplexity-off
	
	БылиОшибки = Ложь;

	Для каждого Задание Из Задания Цикл
		
		Состояние = Задание.Состояние;
		Если Состояние = СостояниеФоновогоЗадания.Завершено Тогда
			
			Результат = Задание.Результат;	

			Если ТипЗнч(Результат) = Тип("Структура") Тогда
				
				ТекстСообщения = "";
				
				КодВозврата = Результат.КодВозврата;
				Если КодВозврата <> 0 Тогда
					БылиОшибки = Истина;
					ТекстСообщения = "
								|Код возврата команды №" + Результат.Позиция + ": " + Строка(КодВозврата);	
				КонецЕсли;
				
				СтрокаВывода = Результат.Вывод;	
				Если ЗначениеЗаполнено(СтрокаВывода) Тогда
					БылиОшибки = Истина;
					ТекстСообщения = ТекстСообщения + "
										|Вывод команды №" + Результат.Позиция + ": " + Строка(СтрокаВывода);
				КонецЕсли;

				Если ЗначениеЗаполнено(ТекстСообщения) Тогда
					Логирователь.ВЛог(ТекстСообщения);						
				КонецЕсли;
				
			КонецЕсли;
		
		ИначеЕсли Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			БылиОшибки = Истина;
			Завершатель.ЗавершитьПоОшибке(Задание.ИнформацияОбОшибке.Описание);
		Иначе
			Продолжить;
		КонецЕсли;
				
	КонецЦикла;

	Если БылиОшибки Тогда
		Завершатель.ЗавершитьПоОшибке();
	КонецЕсли;
	
КонецПроцедуры

&Желудь
Процедура ПриСозданииОбъекта(&Пластилин("Поделка") _Поделка)
    Поделка = _Поделка;
КонецПроцедуры