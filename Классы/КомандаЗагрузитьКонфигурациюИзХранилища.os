// ЗагрузитьКонфигурациюИзХранилища
&Пластилин
Перем УправлятельКонфигуратора;
&Пластилин
Перем КомандаОтключитьКонфигураторОтИнформационнойБазы;

&Пластилин
Перем Настройки;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
	Если Не КомандаОтключитьКонфигураторОтИнформационнойБазы.ВыполнитьКоманду() Тогда
		Возврат Ложь;	
	КонецЕсли;

	Логирователь.ВЛог("Загрузка конфигурации из хранилища");

	Конфигуратор = УправлятельКонфигуратора.Получить();
	ПараметрыПодключения = Настройки.ПараметрыПодключения;

	Попытка
		НомерВерсии = 0;
		Конфигуратор.ЗагрузитьКонфигурациюИзХранилища(ПараметрыПодключения.ПутьКХранилищу, 
												ПараметрыПодключения.ЛогинКХранилищу, 
												ПараметрыПодключения.ПарольКХранилищу, 
												НомерВерсии);
	Исключение
		Логирователь.ВЛог(ОписаниеОшибки(), Истина, Истина);
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры