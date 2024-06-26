#Использовать autumn
#Использовать decorator

Функция ОбработатьЖелудь(Желудь, ОпределениеЖелудя) Экспорт
	
	Конструктор = ОпределениеЖелудя.Завязь().ДанныеМетода();
	
	Аннотация = РаботаСАннотациями.ПолучитьАннотацию(Конструктор, "Прозвище");
	Если Аннотация = Неопределено Тогда
		Возврат Желудь;
	КонецЕсли;
	
	Прозвище = РаботаСАннотациями.ПолучитьЗначениеПараметраАннотации(Аннотация);
	
	Если Прозвище <> "Команда" Тогда
		Возврат Желудь;
	КонецЕсли;
	
	Метод_Ключ = Метод_Ключ(ОпределениеЖелудя);

	НовыйЖелудь = Новый ПостроительДекоратора(Желудь)
		.Метод(Метод_Ключ)
		.Построить();
		
	Возврат НовыйЖелудь;
	
КонецФункции

Функция Метод_Ключ(ОпределениеЖелудя)
	
	КлючКоманды = СтрЗаменить(ОпределениеЖелудя.Имя(), "Команда", "");
	
	Метод = Новый Метод("Ключ")
		.Публичный()
		.ТелоМетода("Возврат """ + КлючКоманды + """;");

	Возврат Метод;
	
КонецФункции

&Напильник
Процедура ПриСозданииОбъекта()

КонецПроцедуры