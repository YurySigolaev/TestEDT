#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.СовместнаяРабота));
	
	Если КлючВариантаОтчета = "ТекущееСостояние" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроектыСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоПроектам);
					
	ИначеЕсли КлючВариантаОтчета = "ДолжныНачаться" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроектыСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоПроектам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		
	ИначеЕсли КлючВариантаОтчета = "ДолжныЗакончиться" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроектыСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоПроектам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.КонтрольныеОтчеты);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Просроченное);
		
	ИначеЕсли КлючВариантаОтчета = "ПланФактПоСрокам" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроектыСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоПроектам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПланФакт);
	
	ИначеЕсли КлючВариантаОтчета = "ПланФактПоТрудозатратам" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ПроектыСписок);

		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоПроектам);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПланФакт);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
