// ЗахватитьОбъектыВХранилище
#Использовать "..//../../srс/Модули"

&Пластилин
Перем Настройки;

&Пластилин
Перем УправлятельХранилища; // BSLLS:Typo-off
&Пластилин
Перем КомандаОтключитьКонфигураторОтИнформационнойБазы;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

&Пластилин
Перем НаборЭмодзи;

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт
	
	Возврат ВыполнитьКомандуСПараметрами(, , , ПараметрыКоманды);

КонецФункции

&Асинх
Функция ВыполнитьКомандуАсинх(ПараметрыКоманды) Экспорт // BSLLS:Typo-off
	
	Возврат РаботаСКомандами.ПереопределитьВыполнитьКомандуАсинх(ПараметрыКоманды, ЭтотОбъект);

КонецФункции

Функция ВыполнитьКомандуСПараметрами(ПоФайлу = Ложь, ИмяФайла = "", 
										ПроверкаПодключения = Ложь, ПараметрыКоманды = Неопределено) Экспорт // BSLLS:UnusedParameters-off
	
	Если Не КомандаОтключитьКонфигураторОтИнформационнойБазы.ВыполнитьКоманду() Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	Если НЕ ПоФайлу Тогда			
		Логирователь.ВЛог("Захватываю объекты в хранилище");
	Иначе 
		СписокМетаданных = Настройки.СписокМетаданных;
		Если ЗначениеЗаполнено(СписокМетаданных) Тогда
			Логирователь.ВЛог("Захватываю объекты по списку метаданных: " + Символы.ПС + СписокМетаданных, 
								,
								Истина, 
								,
								НаборЭмодзи.Звезда());			
		Иначе
			Логирователь.ВЛог("Захватываю объекты в хранилище по файлу " + ИмяФайла);
		КонецЕсли;		
	КонецЕсли;
	
	Хранилище = УправлятельХранилища.Получить();
	
	ПолучатьЗахваченныеОбъекты  = Истина;

	Если ПоФайлу Тогда
		ПутьКФайлуСоСпискомОбъектов = Настройки.ПолныйПутьКФайлуНастроек(ИмяФайла);
	Иначе
		ПутьКФайлуСоСпискомОбъектов = "";
	КонецЕсли;

	Попытка
		Хранилище.ЗахватитьОбъектыВХранилище(ПутьКФайлуСоСпискомОбъектов,
												ПолучатьЗахваченныеОбъекты);
	Исключение
		Если ПроверкаПодключения Тогда
			ВызватьИсключение ОписаниеОшибки();
		Иначе
			Логирователь.ВЛог(ОписаниеОшибки(), Истина, Истина);
			Возврат Ложь;
		КонецЕсли;		
	КонецПопытки;

	Если НЕ ПоФайлу Тогда
		Логирователь.ВЛог("Захват объектов в хранилище выполнен");
	Иначе
		Логирователь.ВЛог("Захват объектов в хранилище по файлу " + ИмяФайла + " выполнен");		
	КонецЕсли;

	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры