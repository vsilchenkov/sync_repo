// ПоказатьНачало
&Пластилин
Перем Настройки;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

&Пластилин
Перем НаборЭмодзи;

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
	Начало = Настройки.ПараметрыКоманд.Начало;
	Если Не ЗначениеЗаполнено(Начало) Тогда
		Логирователь.ВЛог("Не заполнен текст начала");
		Возврат Ложь; 		
	КонецЕсли;

	Логирователь.ВЛог(Начало, , Истина, , НаборЭмодзи.Начало()); 
	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры