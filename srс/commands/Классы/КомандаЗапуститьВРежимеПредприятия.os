// ЗапуститьВРежимеПредприятия
#Использовать "..//../../srс/Модули"

&Пластилин
Перем Настройки;

&Пластилин
Перем УправлятельКонфигуратора;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
	Конфигуратор = УправлятельКонфигуратора.Получить();
	
	Логирователь.ВЛог("Запускаю в режиме предприятия");

	ПараметрыКоманд = Настройки.ПараметрыКоманд;
	ДополнительныеКлючи = ПараметрыКоманд.КлючиЗапускаПредприятия;

	Параметры = ПараметрыКоманды.Параметры;
	ОжидатьВыполнения = Параметры.Получить("ОжидатьВыполнения");
	Если ЗначениеЗаполнено(ОжидатьВыполнения) Тогда
		ОжидатьВыполнения = Булево(ОжидатьВыполнения);
	Иначе
		ОжидатьВыполнения = Истина;			
	КонецЕсли;

	УправлятельКонфигуратора.УстановитьПутьКТонкомуКлиенту();

	ОтключенПризнакОжидания = Ложь;

	Если ОжидатьВыполнения = Ложь Тогда
		Конфигуратор.УстановитьПризнакОжиданияВыполненияПрограммы(Ложь);
		ОтключенПризнакОжидания = Истина;
	КонецЕсли;
	
	ЕстьОшибка = Ложь;
	УправляемыйРежим = Истина;
	Попытка		
		Конфигуратор.ЗапуститьВРежимеПредприятия(, УправляемыйРежим, ДополнительныеКлючи);	
	Исключение
		Логирователь.ВЛог(ОписаниеОшибки(), Истина, Истина);
		ЕстьОшибка = Истина;
	КонецПопытки;
	
	УправлятельКонфигуратора.УстановитьПутьКПлатформе();

	Если ОтключенПризнакОжидания Тогда	
		Конфигуратор.УстановитьПризнакОжиданияВыполненияПрограммы(Истина);
	КонецЕсли;

	Возврат НЕ ЕстьОшибка;

КонецФункции

&Асинх
Функция ВыполнитьКомандуАсинх(ПараметрыКоманды) Экспорт // BSLLS:Typo-off
	
	Возврат РаботаСКомандами.ПереопределитьВыполнитьКомандуАсинх(ПараметрыКоманды, ЭтотОбъект);

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры