// КомандаПоУмолчанию
&Пластилин
Перем Логирователь; // BSLLS:Typo-off

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт
	
	ТекстСообщения = "Неизвестная команда - " + ПараметрыКоманды.Ключ;
	Логирователь.ВЛог(ТекстСообщения, Истина);
	Возврат Истина;

КонецФункции

&Верховный
&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры