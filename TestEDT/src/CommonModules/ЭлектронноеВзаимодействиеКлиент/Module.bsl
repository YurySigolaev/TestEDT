////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиент: общий механизм обмена электронными документами.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Подключаемый обработчик "Подключаемый_ВыполнитьКомандуЭДО", вызов которого размещается в формах объектов учета.
//
// Параметры:
//  Команда - КомандаФормы - вызывающая команда.
//  Форма - ФормаКлиентскогоПриложения - вызывающая форма.
//  Источник - РеквизитФормы -реквизит формы.
//
Процедура ВыполнитьПодключаемуюКомандуЭДО(Знач Команда, Знач Форма, Знач Источник) Экспорт
	ПодключаемыеКомандыЭДОКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, Форма, Источник);
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// См. ЭлектроннаяПодписьКлиентПереопределяемый.ПриДополнительнойПроверкеСертификата
//
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками") Тогда
		МодульОбменаСБанками = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСБанкамиКлиент");
		МодульОбменаСБанками.ПриДополнительнойПроверкеСертификата(Параметры);
	КонецЕсли;

КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентами = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентами.ПослеНачалаРаботыСистемы(); 
	КонецЕсли;
	
КонецПроцедуры

// Обработка нажатия на рекламную ссылку на форме печати БСП.
//
// Параметры:
//  НавигационнаяСсылка - Строка - текст навигационной ссылки;
//  Параметры - Произвольный - значение, которое будет передано процедуру обработки.
//
Процедура ОбработкаНавигационнойСсылкиВФормеПечатиБСП(НавигационнаяСсылка, Параметры = Неопределено) Экспорт
	
	Если НавигационнаяСсылка = "Реклама1СДиректБанк" Тогда
		
		МодульОбменСБанкамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСБанкамиКлиент");
		МодульОбменСБанкамиКлиент.ОбработкаНавигационнойСсылкиВФормеПечатиБСП(НавигационнаяСсылка, Параметры);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиКлиент.ОбработкаНавигационнойСсылкиВФормеПечатиБСП(НавигационнаяСсылка, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// См. УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовОбработкаНавигационнойСсылки
Процедура ПечатьДокументовОбработкаНавигационнойСсылки(Форма, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиКлиент.ПечатьДокументовОбработкаНавигационнойСсылки(Форма, Элемент, 
			НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// См. УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду
Процедура ПечатьДокументовВыполнитьКоманду(Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиКлиент.ПечатьДокументовВыполнитьКоманду(Форма, Команда, ПродолжитьВыполнениеНаСервере, 
			ДополнительныеПараметры);
	КонецЕсли;
		
КонецПроцедуры

// См. УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовОбработкаОповещения
Процедура ПечатьДокументовОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиИнтеграцияКлиентСобытия");
		МодульОбменСКонтрагентамиКлиент.ПечатьДокументовОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

