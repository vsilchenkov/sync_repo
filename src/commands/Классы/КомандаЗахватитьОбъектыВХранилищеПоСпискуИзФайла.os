// BSLLS:LatinAndCyrillicSymbolInWord-off
// ЗахватитьОбъектыВХранилищеПоСпискуИзФайла
#Использовать "..//../../src/Модули"

&Пластилин
Перем КомандаЗахватитьОбъектыВХранилище;

&Пластилин
Перем Настройки;

Перем ТаблицаМетаданных;

Функция ВыполнитьКоманду(ПараметрыКоманды) Экспорт // BSLLS:UnusedParameters-off

    СписокМетаданных = СокрЛП(Настройки.СписокМетаданных);
    Если ЗначениеЗаполнено(СписокМетаданных) Тогда
        ПреобразоватьДанныеИзСпискаВТаблицуМетаданных(СписокМетаданных);
    Иначе
        ПутьКФайлу_meta = Настройки.ПолныйПутьКФайлуНастроек(Настройки.ФайлыНастроек.metadata);
        ПреобразоватьДанныеИзФайлаВТаблицуМетаданных(ПутьКФайлу_meta);
    КонецЕсли;
  
    ИмяФайлаMetadata_merge = Настройки.ФайлыНастроек.metadata_merge;
    ОбработатьТаблицуМетаданныхВXML(ИмяФайлаMetadata_merge);

	Возврат КомандаЗахватитьОбъектыВХранилище.ВыполнитьКомандуСПараметрами(Истина, ИмяФайлаMetadata_merge); 

КонецФункции

Процедура ПреобразоватьДанныеИзФайлаВТаблицуМетаданных(ПутьКФайлу_meta)
    
	Метаданные = РаботаСФайлами.ПрочитатьФайлВМассивСтрок(ПутьКФайлу_meta);
    ПреобразоватьДанныеИзМассиваВТаблицуМетаданных(Метаданные);

КонецПроцедуры

Процедура ПреобразоватьДанныеИзСпискаВТаблицуМетаданных(СписокМетаданных)
    
	Метаданные = СтрРазделить(СписокМетаданных, Символы.ПС);
    ПреобразоватьДанныеИзМассиваВТаблицуМетаданных(Метаданные);

КонецПроцедуры

Процедура ПреобразоватьДанныеИзМассиваВТаблицуМетаданных(Метаданные)
    	
    ИмяКонфигурации = Настройки.ИмяКонфигурации;

    Рекурсивно = Настройки.ОбновлятьОбъектыРекурсивно;
    
    ТаблицаМетаданных.Очистить();
    Для каждого ПолноеИмя Из Метаданные Цикл

        Если НЕ ЗначениеЗаполнено(ПолноеИмя) Тогда
            Продолжить;            
        КонецЕсли;

        НоваяСтрока = ТаблицаМетаданных.Добавить();
        НоваяСтрока.ПолноеИмя  = СокрЛП(ПолноеИмя);
        
        Если ПолноеИмя = ИмяКонфигурации Тогда
            НоваяСтрока.Рекурсивно = Ложь;
        Иначе
            НоваяСтрока.Рекурсивно = Рекурсивно;
        КонецЕсли;     

    КонецЦикла;

КонецПроцедуры

Процедура ОбработатьТаблицуМетаданныхВXML(ИмяФайлаMetadata_merge)
    
    ПутьКФайлу_merge = Настройки.ПолныйПутьКФайлуНастроек(ИмяФайлаMetadata_merge);

	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПутьКФайлу_merge);
    
    ЗаписьXML.ЗаписатьНачалоЭлемента("Objects");
    ЗаписьXML.ЗаписатьАтрибут("xmlns",   XMLСтрока("http://v8.1c.ru/8.3/config/objects"));
    ЗаписьXML.ЗаписатьАтрибут("version", XMLСтрока("1.0"));
      	
    Для каждого СтрокаТаблицы Из ТаблицаМетаданных Цикл

        ЗаписьXML.ЗаписатьНачалоЭлемента("Object");	
        
        ЗаписьXML.ЗаписатьАтрибут("fullName",            СтрокаТаблицы.ПолноеИмя);
        
        Если СтрокаТаблицы.Рекурсивно = Истина Тогда
            includeChildObjects = "true";   
        Иначе
            includeChildObjects = "false"; 
        КонецЕсли;
        ЗаписьXML.ЗаписатьАтрибут("includeChildObjects", includeChildObjects);
        
        ЗаписьXML.ЗаписатьКонецЭлемента();

    КонецЦикла;
    
    ЗаписьXML.ЗаписатьКонецЭлемента();  
    ЗаписьXML.Закрыть();

КонецПроцедуры

&Асинх
Функция ВыполнитьКомандуАсинх(ПараметрыКоманды) Экспорт // BSLLS:Typo-off
	
	Возврат РаботаСКомандами.ПереопределитьВыполнитьКомандуАсинх(ПараметрыКоманды, ЭтотОбъект);

КонецФункции

&Желудь
&Прозвище("Команда")
Процедура ПриСозданииОбъекта()

    ТаблицаМетаданных = Новый ТаблицаЗначений();
    ТаблицаМетаданных.Колонки.Добавить("ПолноеИмя");
	ТаблицаМетаданных.Колонки.Добавить("Рекурсивно", Новый ОписаниеТипов("Булево"));

КонецПроцедуры