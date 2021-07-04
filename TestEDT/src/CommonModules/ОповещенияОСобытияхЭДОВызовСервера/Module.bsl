#Область СлужебныеПроцедурыИФункции

// Метод проверяет наличие в регистре сведений записей о новых ЭД.
//
// Возвращаемое значение:
//  Булево - признак наличия в сервисе новых электронных документов.
//
Функция ЕстьСобытияЭДО() Экспорт
	
	Возврат ОповещенияОСобытияхЭДО.ЕстьСобытияЭДО();
	
КонецФункции

Функция ДоступноОповещениеОСобытияхЭДО() Экспорт
	
	Возврат ОповещенияОСобытияхЭДО.ДоступноОповещениеОСобытияхЭДО();
	
КонецФункции

Процедура ПослеНачалаРаботыСистемы(ДоступноОповещениеОСобытияхЭДО = Неопределено) Экспорт
	
	ДоступноОповещениеОСобытияхЭДО = ОповещенияОСобытияхЭДО.ДоступноОповещениеОСобытияхЭДО();
	Если ИнтеграцияЭДО.ИспользоватьОповещенияОтСервисаЭДО() Тогда
		ОповещенияОСобытияхЭДО.СоздатьСлужебногоПользователяОповещенийЭДО();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти