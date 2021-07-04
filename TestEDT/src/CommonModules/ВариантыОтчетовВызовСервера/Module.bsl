///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры:
//  Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка дополнительного отчета.
//  КлючВарианта - Строка - Имя варианта дополнительного отчета.
//
Процедура ПриПодключенииОтчета(ПараметрыОткрытия) Экспорт
	
	ВариантыОтчетов.ПриПодключенииОтчета(ПараметрыОткрытия);
	
КонецПроцедуры

// Получает тип субконто счета по его номеру.
//
// Параметры:
//  Счет - ПланСчетовСсылка - Ссылка счета.
//  НомерСубконто - Число - Номер субконто.
//
// Возвращаемое значение:
//   ОписаниеТипов - Тип субконто.
//   Неопределено - Если не удалось получить тип субконто (нет такого субконто или нет прав).
//
Функция ТипСубконто(Счет, НомерСубконто) Экспорт
	
	Если Счет = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	ОбъектМетаданных = Счет.Метаданные();
	
	Если Не Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПланСчетовВидыСубконто.ВидСубконто.ТипЗначения КАК Тип
	|ИЗ
	|	&ПолноеИмяТаблицы КАК ПланСчетовВидыСубконто
	|ГДЕ
	|	ПланСчетовВидыСубконто.Ссылка = &Ссылка
	|	И ПланСчетовВидыСубконто.НомерСтроки = &НомерСтроки");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолноеИмяТаблицы", ОбъектМетаданных.ПолноеИмя() + ".ВидыСубконто");
	
	Запрос.УстановитьПараметр("Ссылка", Счет);
	Запрос.УстановитьПараметр("НомерСтроки", НомерСубконто);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Выборка.Тип;
	
КонецФункции

Функция СвойстваВариантОтчетаИзФайла(ОписаниеФайла, ВариантОтчетаОснование) Экспорт 
	
	Возврат ВариантыОтчетов.СвойстваВариантОтчетаИзФайла(ОписаниеФайла, ВариантОтчетаОснование);
	
КонецФункции

Процедура ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек) Экспорт 
	
	ВариантыОтчетов.ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек);
	
КонецПроцедуры

Функция ЭтоПредопределенныйВариантОтчета(ВариантОтчета) Экспорт 
	
	Возврат ВариантыОтчетов.ЭтоПредопределенныйВариантОтчета(ВариантОтчета);
	
КонецФункции

#КонецОбласти
