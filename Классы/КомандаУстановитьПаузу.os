// УстановитьПаузу
&Пластилин
Перем Настройки; // BSLLS:Typo-off

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
	СекундПаузы = Настройки.ПараметрыКоманд.Пауза;
	
	Если ЗначениеЗаполнено(СекундПаузы) Тогда
		
		Миллисекунда = 1000;
		Приостановить(СекундПаузы * Миллисекунда);
	
	КонецЕсли;
		
	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры