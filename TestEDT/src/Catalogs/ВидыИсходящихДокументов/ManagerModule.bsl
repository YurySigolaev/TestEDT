#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей ВидаИсходящихДокументов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруВидаИсходящихДокументов() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Наименование");
	Параметры.Вставить("Нумератор");
	Параметры.Вставить("СпособНумерации");
	Параметры.Вставить("АвтоматическиВестиСоставУчастниковРабочейГруппы");
	Параметры.Вставить("ВестиУчетПоНоменклатуреДел");
	Параметры.Вставить("ИспользоватьСрокИсполнения");
	Параметры.Вставить("ОбязателенФайлОригинала");
	Параметры.Вставить("ОбязательноеЗаполнениеРабочихГруппДокументов");
	Параметры.Вставить("УчитыватьВходящийНомерИДатуПолучателя");
	Параметры.Вставить("УчитыватьСуммуДокумента");
	
	Возврат Параметры;
	
КонецФункции

// Создает и записывает в БД вид исходящего документа
//
// Параметры:
//   ПараметрыВидаИсходящегоДокумента - Структура - структура полей видов исходящих документов.
//
Функция СоздатьВидИсходящегоДокумента(СтруктураВидаИсходящегоДокумента) Экспорт
	
	НовыйВидИсходящегоДокумента = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйВидИсходящегоДокумента, СтруктураВидаИсходящегоДокумента);
	НовыйВидИсходящегоДокумента.Записать();
	
	Возврат НовыйВидИсходящегоДокумента.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка, ЭтоГруппа";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

// Возвращает признак того, что менеджер содержит метод ЗапросДляРасчетаПрав()
// 
Функция ЕстьМетодЗапросДляРасчетаПрав() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает запрос для расчета прав доступа по дескрипторам объекта
// 
// Параметры:
//  
//  Дескрипторы - Массив - массив дескрипторов, чьи права нужно рассчитать
//  ИдОбъекта - Ссылка - идентификатор объекта метаданных, назначенный переданным дескрипторам
//  МенеджерОбъектаДоступа - СправочникМенеджер, ДокументМенеджер - менеджер объекта доступа
// 
// Возвращаемое значение - Запрос - запрос, который выберет права доступа для переданного массива дескрипторов
// 
Функция ЗапросДляРасчетаПрав(Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа) Экспорт
	
	Запрос = Справочники.ДескрипторыДоступаОбъектов.ЗапросДляСтандартногоРасчетаПрав(
		Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа, Ложь, Истина);
	Запрос.Текст = ДокументооборотПраваДоступаПовтИсп.ТекстЗапросаДляРасчетаПравРазрезаДоступа();
	
	Возврат Запрос;
	
КонецФункции

// Заполняет протокол расчета прав дескрипторов
// 
// Параметры:
//  
//  ПротоколРасчетаПрав - Массив - протокол для заполнения
//  ЗапросПоПравам - Запрос - запрос, который использовался для расчета прав дескрипторов
//  Дескрипторы - Массив - массив дескрипторов, чьи права были рассчитаны
//  
Процедура ЗаполнитьПротоколРасчетаПрав(ПротоколРасчетаПрав, ЗапросПоПравам) Экспорт
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПротоколРасчетаПравСтандартно(
		ПротоколРасчетаПрав, ЗапросПоПравам);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли