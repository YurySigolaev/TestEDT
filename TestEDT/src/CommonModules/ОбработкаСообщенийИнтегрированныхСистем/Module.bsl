#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОбработатьСообщениеИнтегрированныхСистем(СообщениеСсылка) Экспорт
	
	Попытка
		
		СтрокаXML = СообщениеСсылка.ДанныеСообщения.Получить();
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(СтрокаXML);
		
		СообщениеXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		
		ОтветноеСообщение = ОбработкаЗапросовXDTO.ОбработатьУниверсальноеСообщение(СообщениеXDTO);
		ОтветноеСообщение.initialMessageID = СообщениеXDTO.messageID;
		ОтветноеСообщение.messageID = Строка(Новый УникальныйИдентификатор);
		
		УстановитьПривилегированныйРежим(Истина);
		НачатьТранзакцию();
		СообщениеОбъект = СообщениеСсылка.ПолучитьОбъект();
		СообщениеОбъект.Заблокировать();
		СообщениеОбъект.Записать();
		СообщениеОбъект.УстановитьПометкуУдаления(Истина);
		
		СтрокаXML = "";
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку();
		ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОтветноеСообщение, , , , НазначениеТипаXML.Явное);
		СтрокаXML = ЗаписьXML.Закрыть();
		
		СообщениеОбъект = Справочники.СообщенияИнтегрированныхСистем.СоздатьЭлемент();
		СообщениеОбъект.ДанныеСообщения = Новый ХранилищеЗначения(СтрокаXML);
		СообщениеОбъект.Входящее = Ложь;
		СообщениеОбъект.ДатаСоздания = ТекущаяДата();
		СообщениеОбъект.Очередь = СообщениеСсылка.Очередь;
		СообщениеОбъект.Код = Строка(ОтветноеСообщение.Тип());
		СообщениеОбъект.ИдентификаторСообщения = ОтветноеСообщение.messageID;
		СообщениеОбъект.ВОтветНа = СообщениеСсылка;
		СообщениеОбъект.Записать();
		ЗафиксироватьТранзакцию();

	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обработка сообщения интегрированных систем'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли