#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипыДокументов.Добавить(Перечисления.ТипыОбъектов.ВходящиеДокументы, НСтр("ru = 'Входящие документы'"));
	ТипыДокументов.Добавить(Перечисления.ТипыОбъектов.ИсходящиеДокументы, НСтр("ru = 'Исходящие документы'"));
	ТипыДокументов.Добавить(Перечисления.ТипыОбъектов.ВнутренниеДокументы, НСтр("ru = 'Внутренние документы'"));
	
	ТекущийТипДокумента = ТипыДокументов[0].Значение;
	Элементы.ТипыДокументов.ТекущаяСтрока = ТипыДокументов[0].ПолучитьИдентификатор();
	УстановитьОтборСписка(Список, ТекущийТипДокумента);
	
	ПоказыватьУдаленные = Ложь;
	ПоказатьУдаленные();
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ТекущийТипДокумента = Настройки["ТекущийТипДокумента"];
	Если Не ЗначениеЗаполнено(ТекущийТипДокумента) Тогда 
		Возврат;
	КонецЕсли;	
	
	НайденноеЗначение = ТипыДокументов.НайтиПоЗначению(ТекущийТипДокумента);
	Если НайденноеЗначение = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
		
	Элементы.ТипыДокументов.ТекущаяСтрока = НайденноеЗначение.ПолучитьИдентификатор();
	
	УстановитьОтборСписка(Список, ТекущийТипДокумента);
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ТипыДокументовПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ТипыДокументов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Значение = ТекущийТипДокумента Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущийТипДокумента = ТекущиеДанные.Значение;
	
	УстановитьОтборСписка(Список, ТекущийТипДокумента);
	
КонецПроцедуры


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь);
	КонецЕсли;
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ТекущийТипДокумента)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
		"ТипДокумента",
		ТекущийТипДокумента);
	
КонецПроцедуры	

#КонецОбласти
