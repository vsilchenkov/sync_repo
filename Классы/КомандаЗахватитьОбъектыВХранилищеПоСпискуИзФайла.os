// BSLLS:LatinAndCyrillicSymbolInWord-off
// ЗахватитьОбъектыВХранилище
#Использовать "../srс/Модули"

&Пластилин
Перем КомандаЗахватитьОбъектыВХранилище;

&Пластилин
Перем Настройки;

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off
	
	ПутьКФайлу_meta = Настройки.ПолныйПутьКФайлуНастроек(Настройки.ФайлыНастроек.metadata);
	
	Метаданные = РаботаСФайлами.ПрочитатьФайлВМассивСтрок(ПутьКФайлу_meta);

	ИмяФайлаMetadata_merge = Настройки.ФайлыНастроек.metadata_merge;
	ПутьКФайлу_merge = Настройки.ПолныйПутьКФайлуНастроек(ИмяФайлаMetadata_merge);

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПутьКФайлу_merge);
    
    ЗаписьXML.ЗаписатьНачалоЭлемента("Objects");
    ЗаписьXML.ЗаписатьАтрибут("xmlns",   XMLСтрока("http://v8.1c.ru/8.3/config/objects"));
    ЗаписьXML.ЗаписатьАтрибут("version", XMLСтрока("1.0"));
      	
    Для каждого ПолноеИмя Из Метаданные Цикл

        ЗаписьXML.ЗаписатьНачалоЭлемента("Object");	
        
        ЗаписьXML.ЗаписатьАтрибут("fullName", ПолноеИмя);
        ЗаписьXML.ЗаписатьАтрибут("includeChildObjects", "true");
        
        ЗаписьXML.ЗаписатьКонецЭлемента();

    КонецЦикла;
    
    ЗаписьXML.ЗаписатьКонецЭлемента();  
    ЗаписьXML.Закрыть();

	КомандаЗахватитьОбъектыВХранилище.ВыполнитьКомандуСПараметрами(Истина, ИмяФайлаMetadata_merge); 
    
	Возврат Истина;

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

КонецПроцедуры