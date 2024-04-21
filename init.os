#Использовать logos

Перем Лог;

Процедура Инициализировать_autumn_properties() // BSLLS:LatinAndCyrillicSymbolInWord-off
	
	ИмяФайла       = "autumn-properties.yml";
	ИмяФайлаШаблон = "autumn-properties_example.yml";

	Лог.Отладка("Инициализация файла настроек" + ИмяФайла);

	ТекущийКаталог = ТекущийКаталог();
	ПутьКФайлу = ОбъединитьПути(ТекущийКаталог, ИмяФайла);

	// BSLLS:CommentedCode-off
	// ФайлПоиска = Новый Файл(ПутьКФайлу); 
	// Если ФайлПоиска.Существует() Тогда
	// 	Лог.Отладка("Файл настроек " + ИмяФайла + " уже существует");
	// 	Возврат;
	// КонецЕсли;

	ПутьКФайлуШаблон = ОбъединитьПути(ТекущийКаталог, ИмяФайлаШаблон);
	КопироватьФайл(ПутьКФайлуШаблон, ПутьКФайлу);
	Лог.Отладка("Файл настроек " + ИмяФайла + " скопирован из " + ИмяФайлаШаблон);

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.sync_repo.init");
Инициализировать_autumn_properties();