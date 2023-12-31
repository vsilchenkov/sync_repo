// ОбновитьКонфигурациюБазыДанных
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

	Конфигуратор = УправлятельКонфигуратора.Получить();
	
	Логирователь.ВЛог("Начинаю обновление конфигурации базы данных", , Истина);

	Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	Попытка
		ПредупрежденияКакОшибки = Ложь; 
		ДинамическоеОбновление = Ложь;
		Конфигуратор.ОбновитьКонфигурациюБазыДанныхНаСервере(ПредупрежденияКакОшибки, ДинамическоеОбновление);
	Исключение
		Логирователь.ВЛог(ОписаниеОшибки(), Истина, Истина);
		Возврат Ложь;
	КонецПопытки;

	Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();

	ВремяОбновления =  Конец - Начало;
	Логирователь.ВЛог("Конфигурация базы данных обновлена");
	
	Миллисекунда  = 1000;
	Минута      = 60;
	ВремяОбновленияБазыВМинутах = ВремяОбновления / Миллисекунда / Минута;
	УправлятельКонфигуратора.ВремяОбновленияБазы_Установить(ВремяОбновленияБазыВМинутах);

	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры