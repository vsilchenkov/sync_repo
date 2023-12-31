// ПоместитьИзмененияОбъектовВХранилище
&Пластилин
Перем Настройки;

&Пластилин
Перем УправлятельКонфигуратора;
&Пластилин
Перем КомандаОтключитьКонфигураторОтИнформационнойБазы;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
	Если Не КомандаОтключитьКонфигураторОтИнформационнойБазы.ВыполнитьКоманду() Тогда
		Возврат Ложь;	
	КонецЕсли;

	Логирователь.ВЛог("Помещаю изменения объектов в хранилище");

	Конфигуратор = УправлятельКонфигуратора.Получить();
	ПараметрыКоманд = Настройки.ПараметрыКоманд;

	Комментарий = ПараметрыКоманд.КомментарийПриПомещенииВХранилище;
	Логирователь.ЗаменитьПараметрыВТексте(Комментарий);

	ПараметрыПодключения = Настройки.ПараметрыПодключения;

	ОставитьОбъектыЗахваченными = Ложь;
	ИгнорироватьУдаленные = Истина;

	Попытка
		Конфигуратор.ПоместитьИзмененияОбъектовВХранилище(ПараметрыПодключения.ПутьКХранилищу, 
												ПараметрыПодключения.ЛогинКХранилищу, 
												ПараметрыПодключения.ПарольКХранилищу, 
												,
												Комментарий,
												ОставитьОбъектыЗахваченными,
												ИгнорироватьУдаленные);
	Исключение
		Логирователь.ВЛог(ОписаниеОшибки(), Истина, Истина);
		Возврат Ложь;
	КонецПопытки;

	Логирователь.ВЛог("Изменения объектов помещены в хранилище");

	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры