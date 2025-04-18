// ОбновитьКонфигурациюБазыДанных
#Использовать "..//../../src/Модули"

&Пластилин
Перем УправлятельКонфигуратора;
&Пластилин
Перем КомандаОтключитьКонфигураторОтИнформационнойБазы;

&Пластилин
Перем Логирователь; // BSLLS:Typo-off

&Пластилин
Перем Настройки; // BSLLS:Typo-off

// Параметры
//	РежимРеструктуризации - Первый или Второй
Функция ВыполнитьКоманду(ПараметрыКоманды,    // BSLLS:MissingReturnedValueDescription-off
								Знач РежимРеструктуризации = Неопределено) Экспорт
	
	Если Не КомандаОтключитьКонфигураторОтИнформационнойБазы.ВыполнитьКоманду() Тогда
		Возврат Ложь;	
	КонецЕсли;

	Параметры = ПараметрыКоманды.Параметры;
	
	Если РежимРеструктуризации = Неопределено Тогда
		РежимРеструктуризации = Параметры.Получить("РежимРеструктуризации");
	КонецЕсли;
		
	ИмяРасширения = Параметры.Получить("ИмяРасширения");
	Если Не ЗначениеЗаполнено(ИмяРасширения) Тогда
		ИмяРасширения = "";	
	КонецЕсли;	

	Конфигуратор = УправлятельКонфигуратора.Получить();

	ДинамическоеОбновление = Настройки.ИспользоватьДинамическоеОбновление;

	Если ЗначениеЗаполнено(ИмяРасширения) Тогда
		ТекстДополнения = ". Расширение - " + ИмяРасширения;
		РежимРеструктуризации = Неопределено;
		ВТелеграм = Ложь;
	Иначе
		
		ТекстДополнения = "";
		ВТелеграм = Истина;

		Если ДинамическоеОбновление Тогда 
			РежимРеструктуризации = Неопределено;
		Иначе
			РежимРеструктуризации = ОпределитьРежимРеструктуризации(РежимРеструктуризации, Конфигуратор);
		КонецЕсли;

	КонецЕсли;
	
	ТекстСообщения = "Начинаю обновление конфигурации базы данных" + ТекстДополнения;
	Если ДинамическоеОбновление Тогда
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "обновление", "динамическое обновление");
	КонецЕсли;
	Если ЗначениеЗаполнено(РежимРеструктуризации) Тогда
		ТекстСообщения = ТекстСообщения + ". Режим реструктуризации: " + РежимРеструктуризации;	
	КонецЕсли;
	Логирователь.ВЛог(ТекстСообщения, , ВТелеграм);

	Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
	ПредупрежденияКакОшибки = Ложь; 
	ДинамическоеОбновление = Настройки.ИспользоватьДинамическоеОбновление;
		
	Если ЗначениеЗаполнено(ИмяРасширения) Тогда
			
		НаСервере = Ложь; // Расширения обновляются только на клиенте
			
		Попытка
			Конфигуратор.ОбновитьКонфигурациюБазыДанных(ПредупрежденияКакОшибки, 
															НаСервере, 
															ДинамическоеОбновление,
															ИмяРасширения);	
		Исключение
			Логирователь.ВЛог(ОписаниеОшибки(), Истина, Истина);
			Возврат Ложь;
		КонецПопытки;

	Иначе

		ЕстьОшибка     = Ложь;
		ОписаниеОшибки = "";

		Попытка
			Конфигуратор.ОбновитьКонфигурациюБазыДанныхНаСервере(ПредупрежденияКакОшибки, 
																	ДинамическоеОбновление,
																	РежимРеструктуризации);	
		Исключение
			ЕстьОшибка = Истина;
			ОписаниеОшибки = ОписаниеОшибки();
			Логирователь.ВЛог(ОписаниеОшибки, Истина, Истина);
		КонецПопытки;

		Если ЕстьОшибка Тогда
			Возврат ОбработчикОшибокОбновления(ОписаниеОшибки, ПараметрыКоманды, ВТелеграм);				
		КонецЕсли;
			
	КонецЕсли;

	Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();

	ВремяОбновления =  Конец - Начало;
	Логирователь.ВЛог("Конфигурация базы данных обновлена" + ТекстДополнения);
	
	Если НЕ ЗначениеЗаполнено(ИмяРасширения) Тогда
		ЗафиксироватьВремяОбновления(ВремяОбновления);
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

Функция ОбработчикОшибокОбновления(ОписаниеОшибки, ПараметрыКоманды, ВТелеграм = Ложь)
	
	Если Не ЕстьЗначениеВСтрокеИзМассиваСтрок(ОписаниеОшибки, ОшибкиОбновления())
			И ЕстьЗначениеВСтрокеИзМассиваСтрок(ОписаниеОшибки, ОшибкиПереходаНаПервыйРежим()) Тогда
	
		Логирователь.ВЛог("Повторное обновление в первом режиме реструктуризации", , ВТелеграм);
		
		РежимРеструктуризации = "Первый";
		Возврат ВыполнитьКоманду(ПараметрыКоманды, РежимРеструктуризации);

	Иначе
		Возврат Ложь; // Фиксируем ошибку
	КонецЕсли;

КонецФункции

Функция ОшибкиОбновления()
	
	мОшибки = Новый Массив();
	мОшибки.Добавить("Записи регистра сведений стали неуникальными");
	Возврат мОшибки;

КонецФункции

Функция ОшибкиПереходаНаПервыйРежим()
	
	мОшибки = Новый Массив();
	мОшибки.Добавить("оптимизированного механизма обновления");
	мОшибки.Добавить("Не определен путь до каталога установки Java");
	Возврат мОшибки;

КонецФункции

Функция ЕстьЗначениеВСтрокеИзМассиваСтрок(ЗначениеСтроки, мСтроки)
	
	Для каждого СтрокаПоика Из мСтроки Цикл
		Если СтрНайти(ЗначениеСтроки, СтрокаПоика) > 0 Тогда
			Возврат Истина;
		КонецЕсли;		
	КонецЦикла;	

	Возврат Ложь;

КонецФункции

Функция ОпределитьРежимРеструктуризации(Режим, Конфигуратор)
	
	Если Режим = "Первый" Тогда
		Возврат Конфигуратор.РежимыРеструктуризации().Первый;	
	ИначеЕсли Режим = "Второй" Тогда
		Возврат Конфигуратор.РежимыРеструктуризации().Второй;			
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

Процедура ЗафиксироватьВремяОбновления(ВремяОбновления)
		
	Миллисекунда  = 1000;
	Минута      = 60;
	ВремяОбновленияБазыВМинутах = ВремяОбновления / Миллисекунда / Минута;
	УправлятельКонфигуратора.ВремяОбновленияБазы_Установить(ВремяОбновленияБазыВМинутах);		

КонецПроцедуры
&Асинх
Функция ВыполнитьКомандуАсинх(ПараметрыКоманды) Экспорт // BSLLS:Typo-off
	
	Возврат РаботаСКомандами.ПереопределитьВыполнитьКомандуАсинх(ПараметрыКоманды, ЭтотОбъект);

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры