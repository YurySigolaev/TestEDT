#Область СлужебныеПроцедурыИФункции

// Возвращает помещенную в строку операцию ЭДО.
//
// Параметры:
//  ОперацияЭДО - см. СинхронизацияЭДОКлиентСервер.НоваяОперацияПодключенияЭДО.
//  			- см. СинхронизацияЭДОКлиентСервер.НоваяОперацияОбновленияСертификата.
//
// Возвращаемое значение:
//  Строка - помещенная в строку операция ЭДО.
//
Функция ОперацияЭДОВСтроку(Знач ОперацияЭДО) Экспорт
	
	СтрокаОперацииЭДО = ОбъектВАрхив(ОперацияЭДО);
	
	Возврат СтрокаОперацииЭДО;
	
КонецФункции

// Возвращает извлеченную из строки операцию ЭДО.
//
// Параметры:
//  СтрокаОперацииЭДО - Строка - строка операции ЭДО. См. ОперацияЭДОВСтроку.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - извлеченная из строки операция ЭДО. См. ОбменСКонтрагентами.НоваяОперацияЭДО.
//
Функция ОперацияЭДОИзСтроки(Знач СтрокаОперацииЭДО) Экспорт
	
	ИзвлеченнаяОперацияЭДО = ОбъектИзАрхива(СтрокаОперацииЭДО);
	
	ОперацияПодключенияЭДО = СинхронизацияЭДОКлиентСервер.НоваяОперацияПодключенияЭДО();
	ОперацияОбновленияСертификата = СинхронизацияЭДОКлиентСервер.НоваяОперацияОбновленияСертификата();
	
	// Актуализируем состав параметров операции.
	Если ИзвлеченнаяОперацияЭДО.Действие = ОперацияПодключенияЭДО.Действие Тогда
		
		ОперацияЭДО = ОперацияПодключенияЭДО;
		
	ИначеЕсли ИзвлеченнаяОперацияЭДО.Действие = ОперацияОбновленияСертификата.Действие Тогда
		
		ОперацияЭДО = ОперацияОбновленияСертификата;
		
	Иначе
		
		ОперацияЭДО = ИзвлеченнаяОперацияЭДО;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ОперацияЭДО.Параметры, ИзвлеченнаяОперацияЭДО.Параметры);
	ЗаполнитьЗначенияСвойств(ОперацияЭДО.Результат, ИзвлеченнаяОперацияЭДО.Результат);
	
	Возврат ОперацияЭДО;
	
КонецФункции

// Возвращает признак корректности (заполненности) параметров операции ЭДО.
//
// Параметры:
//  ОперацияЭДО - см. СинхронизацияЭДОКлиентСервер.НоваяОперацияПодключенияЭДО.
//  			- см. СинхронизацияЭДОКлиентСервер.НоваяОперацияОбновленияСертификата.
//
// Возвращаемое значение:
//  Булево - параметры операции корректны (заполнены).
//
Функция ОперацияЭДОКорректна(Знач ОперацияЭДО) Экспорт
	
	Результат = Ложь;
	
	ОперацияПодключенияЭДО = СинхронизацияЭДОКлиентСервер.НоваяОперацияПодключенияЭДО();
	ОперацияОбновленияСертификата = СинхронизацияЭДОКлиентСервер.НоваяОперацияОбновленияСертификата();
	
	Если ОперацияЭДО.Действие = ОперацияПодключенияЭДО.Действие Тогда
		
		Результат = СинхронизацияЭДОКлиентСервер.ОперацияПодключенияЭДОКорректна(ОперацияЭДО);
		
	ИначеЕсли ОперацияЭДО.Действие = ОперацияОбновленияСертификата.Действие Тогда
		
		Результат = СинхронизацияЭДОКлиентСервер.ОперацияОбновленияСертификатаКорректна(ОперацияЭДО);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает архив с помещенным в него объектом.
//
// Параметры:
//  Объект - Произвольный - объект для помещения в архив.
//
// Возвращаемое значение:
//  Строка - архив с помещенным в него объектом.
//
Функция ОбъектВАрхив(Знач Объект)
	
	Архив = Неопределено;
	
	Хранилище = Новый ХранилищеЗначения(Объект);
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ЗаписатьXML(Запись, Хранилище);
	
	Архив = Запись.Закрыть();
	
	Возврат Архив;
	
КонецФункции

// Возвращает объект извлеченный из архива.
//
// Параметры:
//  Архив - Строка - архив с помещенным в него объектом. См. ОбъектВАрхив.
//
// Возвращаемое значение:
//  Произвольный - объект извлеченный из архива.
//
Функция ОбъектИзАрхива(Знач Архив)
	
	Объект = Неопределено;
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Архив);
	Хранилище = ПрочитатьXML(Чтение);
	
	Объект = Хранилище.Получить();
	
	Возврат Объект;
	
КонецФункции

#КонецОбласти