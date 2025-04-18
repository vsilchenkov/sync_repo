// ОтменитьЗахватОбъектовВХранилище
#Использовать "..//../../src/Модули"

&Пластилин
Перем Настройки;

&Пластилин
Перем УправлятельХранилища; // BSLLS:Typo-off
&Пластилин
Перем КомандаОтключитьКонфигураторОтИнформационнойБазы;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
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

	Если ПоФайлу Тогда
		Логирователь.ВЛог("Отменяю объекты в хранилище по файлу " + ИмяФайла);		
	Иначе 
		Логирователь.ВЛог("Отменяю захват объектов в хранилище");
	КонецЕсли;

	ИгнорироватьИзменения = Истина;

	Если ПоФайлу Тогда
		ПутьКФайлуСоСпискомОбъектов = Настройки.ПолныйПутьКФайлуНастроек(ИмяФайла);
	Иначе
		ПутьКФайлуСоСпискомОбъектов = Неопределено;
	КонецЕсли;

	Хранилище = УправлятельХранилища.Получить();
	
	Попытка
		Хранилище.ОтменитьЗахватОбъектовВХранилище(ПутьКФайлуСоСпискомОбъектов,
														ИгнорироватьИзменения);
	Исключение
		Если ПроверкаПодключения Тогда
			ВызватьИсключение ОписаниеОшибки();
		Иначе
			Логирователь.ВЛог(ОписаниеОшибки(), Истина, Истина);
			Возврат Ложь;
		КонецЕсли;		
	КонецПопытки;

	Если ПоФайлу Тогда
		Логирователь.ВЛог("Отмена захвата объектов в хранилище по файлу " + ИмяФайла + " выполнена");				
	Иначе
		Логирователь.ВЛог("Отмена захвата объектов в хранилище выполнена");
	КонецЕсли;

	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры