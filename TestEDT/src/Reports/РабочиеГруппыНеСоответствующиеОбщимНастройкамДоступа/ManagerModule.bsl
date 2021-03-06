#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область НастройкиОтчетаПоУмолчанию

// Выполняет заполнение категорий и разделов в зависимости от варианта отчета.
// Параметры:
// 	КлючВариантаОтчета - строковое название варианта отчета
//	СписокКатегорий - в список добавляются необходимые категории
//	СписокРазделов - в список добавляются необходимые разделы
// 
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
	
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Подсистемы.НастройкаИАдминистрирование));
	
	Если КлючВариантаОтчета = "Основной" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Администрирование);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
