// ВыполнитьЗапросSQL
#Использовать "..//../../srс/Модули"

&Пластилин
Перем УправлятельSQL; // BSLLS:Typo-off

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

&Пластилин
Перем СкриптыSQL;

&Пластилин(Значение = "ОбработчикРезультатаSQL", Тип = "Массив")
Перем ОбработчикиРезультата;

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
	ПараметрыСкрипта = ПараметрыКоманды.Параметры;
	
	ПовторноеВыполнение = ЗначениеЗаполнено(ПараметрыСкрипта.Получить("ПовторнаяОтправка"));
	
	ПропускатьПриОшибке = ПараметрыСкрипта.Получить("ПропускатьПриОшибке");
	Если ПропускатьПриОшибке <> Неопределено Тогда
		ПропускатьПриОшибке = Булево(ПропускатьПриОшибке);		
	Иначе
		ПропускатьПриОшибке = Ложь;		
	КонецЕсли;
	
	Имя = ПараметрыСкрипта.Получить("Имя");

	ТекстСообщения = "Выполняю запрос SQL: " + Имя;
	Если ПовторноеВыполнение Тогда
		Логирователь.Отладка(ТекстСообщения);
	Иначе
		Логирователь.ВЛог(ТекстСообщения);
	КонецЕсли;
		
	Параметр1 = ПараметрыСкрипта.Получить("Параметр1");
	
	ТекстЗапроса = СкриптыSQL.Получить(Имя, Параметр1);
	Если ТекстЗапроса = Неопределено Тогда
		ТекстОшибки = "Не определен текст запроса - " + Имя;
		Логирователь.ВЛог(ТекстОшибки, Истина);
		Возврат Ложь;	
	КонецЕсли;
	
	Попытка
		Результат = УправлятельSQL.ВыполнитьЗапрос(ТекстЗапроса);	
	Исключение
		Логирователь.ВЛог("Запрос SQL не выполнен - " + Имя + "." + ОписаниеОшибки(), Истина);
		Возврат ПропускатьПриОшибке;
	КонецПопытки;
	
	Для каждого ОбработчикРезультата Из ОбработчикиРезультата Цикл		
		РезультатОбработки = ОбработчикРезультата.Обработать(Результат, ЭтотОбъект, "Запрос", ПараметрыКоманды);
		Если РезультатОбработки = Ложь Тогда
			Возврат ПропускатьПриОшибке;	
		КонецЕсли;
	КонецЦикла;

	Возврат Истина;

КонецФункции

&Асинх
Функция ВыполнитьКомандуАсинх(ПараметрыКоманды) Экспорт // BSLLS:Typo-off
	
	Возврат РаботаСКомандами.ПереопределитьВыполнитьКомандуАсинх(ПараметрыКоманды, ЭтотОбъект);

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры