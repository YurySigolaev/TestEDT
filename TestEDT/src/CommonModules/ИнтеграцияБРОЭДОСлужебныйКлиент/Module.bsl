#Область СлужебныеПроцедурыИФункции

Процедура ЗакрытиеФормыНастроекРегистрацииЭДО(Знач ОперацияЭДО, Знач ОбработкаПродолжения) Экспорт
	
	Настройки = Неопределено;
	Если ОперацияЭДО <> Неопределено Тогда
		Настройки = ИнтеграцияБРОЭДОСлужебныйВызовСервера.ОперацияЭДОВСтроку(ОперацияЭДО);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОбработкаПродолжения, Настройки);
	
КонецПроцедуры


#Область ОткрытьФормуОтправкиДанныхОператоруЭДО

Процедура ОткрытьФормуОтправкиДанныхОператоруЭДО_ПослеПоискаСертификата(СсылкаНаСертификат, Контекст) Экспорт
	
	Если Не ЗначениеЗаполнено(СсылкаНаСертификат) Тогда
		Результат = Новый Структура("Выполнено, Настройки", Ложь, Контекст.Настройки);
		ВыполнитьОбработкуОповещения(Контекст.ВыполняемоеОповещение, Результат);
		Возврат;
	КонецЕсли;
	
	Операция = Контекст.Операция;
	
	ОперацияПодключенияЭДО = СинхронизацияЭДОКлиентСервер.НоваяОперацияПодключенияЭДО();
	ОперацияОбновленияСертификата = СинхронизацияЭДОКлиентСервер.НоваяОперацияОбновленияСертификата();
	
	Если Операция.Действие = ОперацияПодключенияЭДО.Действие Тогда
		Операция.Параметры.Сертификат = СсылкаНаСертификат;
	ИначеЕсли Операция.Действие = ОперацияОбновленияСертификата.Действие Тогда
		Операция.Параметры.НовыйСертификат = СсылкаНаСертификат;
	КонецЕсли;
	
	ОбработкаЗакрытия = Новый ОписаниеОповещения("ОткрытьФормуОтправкиДанныхОператоруЭДО_ПослеВыполненияОперации",
		ЭтотОбъект, Контекст.ВыполняемоеОповещение);
	
	СинхронизацияЭДОКлиент.НачатьВыполнениеОперацииЭДО(Операция, ОбработкаЗакрытия);
	
КонецПроцедуры

Процедура ОткрытьФормуОтправкиДанныхОператоруЭДО_ПослеВыполненияОперации(Знач РезультатОперации, Знач ОбработкаПродолжения) Экспорт
	
	Результат = Новый Структура("Выполнено, Настройки", Истина, Неопределено);
	
	Если Не РезультатОперации.Выполнено Тогда
		Результат.Выполнено = Ложь;
		Результат.Настройки = ИнтеграцияБРОЭДОСлужебныйВызовСервера.ОперацияЭДОВСтроку(РезультатОперации.ОперацияЭДО);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОбработкаПродолжения, Результат);
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти