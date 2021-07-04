////////////////////////////////////////////////////////////////////////////////
// Подсистема "ЦентрКонтроляКачества".
//
////////////////////////////////////////////////////////////////////////////////
// @strict-types

#Область ПрограммныйИнтерфейс

// Процедура дополняет список типов инцидентов СписокТипов
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//  СписокТипов	 - Соответствие из КлючИЗначение:
//	 * Ключ - Строка - с именем типа,
//	 * Значение - Структура:
//		** УровеньИнцидента - Строка
//		** Подсистема - Строка
//		** Теги - Строка
//		** ПроцедураПроверки - Строка
// Пример: 
//	Здесь следует определить прикладные типы инцидентов и методы их проверки актуальности. 
//	Подробно см:
// 	Описание = ИнцидентыЦККСервер.СоздатьОписаниеТипаИнцидента("ОстановиласьОчередьОбменаССайтом");
// 	ИнцидентыЦККСервер.СоздатьЗаписьТипа(СписокТипов, Описание);
//
Процедура СписокТиповИнцидентовПереопределяемый(СписокТипов) Экспорт
КонецПроцедуры

// В процедуре можно вызвать все прикладные проверки, связанные с периодическим мониторингом прикладной конфигурации.
// Процедура вызывается с помощью регламентной процедуры МониторингЦКК раз в минуту, если константа АдресЦКК заполнена.
// @skip-warning ПустойМетод - переопределяемый метод.
//
Процедура ВыполнитьЗадачиМониторингаЦКК() Экспорт
КонецПроцедуры

#КонецОбласти

