///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ПараметрыОбработкиПользователяИБ; // Параметры, заполняемые при обработке пользователя ИБ.
                                        // Используются в обработчике события ПриЗаписи.

Перем ЭтоНовый; // Показывает, что был записан новый объект.
                // Используются в обработчике события ПриЗаписи.

// Обновление адресной книги
Перем ОбновитьДанныеОтображенияПользователяВАдреснойКниге;
Перем ОбновитьГруппуВсеПользователиВАдреснойКниге;
Перем ОбновитьСловаПоискаПоПользователюВАдреснойКниге;
Перем ОбновитьДоступностьВПоискеПоПользователю;

Перем ОбновитьПользователяСВ;

#КонецОбласти

// *Область ПрограммныйИнтерфейс
//
// Программный интерфейс объекта реализован через ДополнительныеСвойства:
//
// ОписаниеПользователяИБ - Структура со свойствами:
//   Действие - Строка - "Записать" или "Удалить".
//      1. Если Действие = "Удалить" другие свойства не требуются. Удаление
//      будет считаться успешным и в том случае, когда пользовательИБ
//      не найден по значению реквизита ИдентификаторПользователяИБ.
//      2. Если Действие = "Записать", тогда будет создан или обновлен
//      пользователь ИБ по указанным свойствам.
//
//   ВходВПрограммуРазрешен - Неопределено - вычислить автоматически:
//                            если вход в программу запрещен, тогда остается запрещен,
//                            иначе остается разрешен, кроме случая, когда
//                            все виды аутентификации установлены в Ложь.
//                          - Булево - если Истина, тогда установить аутентификацию, как
//                            указана или сохранена в значениях одноименных реквизитов;
//                            если Ложь, тогда снять все виды аутентификации у пользователя ИБ.
//                            Если свойство не указано - прямая установка сохраняемых и
//                            действующих видов аутентификации (для поддержки обратной совместимости).
//
//   ПотребоватьСменуПароляПриВходе - Булево - изменяет одноименный флажок карточки пользователя.
//                                  - Неопределено - флажок не изменяется (аналогично,
//                                        если свойство не указано).
//
//   АутентификацияСтандартная, АутентификацияОС, АутентификацияOpenID - установить
//      сохраняемые значения видов аутентификации и, в зависимости от использования свойства.
//      ВходВПрограммуРазрешен, установить действующие значения видов аутентификации.
// 
//   Остальные свойства.
//      Состав остальных свойств указывается аналогично составу свойств параметра.
//      ОбновляемыеСвойства для процедуры Пользователи.УстановитьСвойстваПользователяИБ(),
//      кроме свойства ПолноеИмя - устанавливается по Наименованию.
//
//      Для сопоставления существующего свободного пользователя ИБ с пользователем в справочнике,
//      с которым не сопоставлен другой существующий пользователь ИБ, нужно вставить свойство.
//      УникальныйИдентификатор. Если указать идентификатор пользователя ИБ, который
//      сопоставлен с текущим пользователем, ничего не изменится.
//
//   При выполнении действий "Записать" и "Удалить" реквизит объекта.
//   ИдентификаторПользователяИБ обновляется автоматически, его не следует изменять.
//
//   После выполнения действия в структуру вставляются (обновляются) следующие свойства:
//   - РезультатДействия - Строка, содержащая одно из значений:
//       "ДобавленПользовательИБ", "ИзмененПользовательИБ", "УдаленПользовательИБ",
//       "ОчищеноСопоставлениеСНесуществующимПользователемИБ", "НеТребуетсяУдалениеПользовательИБ".
//   - УникальныйИдентификатор - УникальныйИдентификатор пользователя ИБ.
//
// *КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	
	ПользователиСлужебный.НачатьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
	// Обновление адресной книги
	ОбновитьДанныеОтображенияПользователяВАдреснойКниге = Ложь;
	ОбновитьГруппуВсеПользователиВАдреснойКниге = Ложь;
	ОбновитьСловаПоискаПоПользователюВАдреснойКниге = Ложь;
	ОбновитьДоступностьВПоискеПоПользователю = Ложь;
	
	ОбновитьПользователяСВ = Ложь;
	
	Если ЭтоНовый Тогда
		
		ОбновитьГруппуВсеПользователиВАдреснойКниге = Истина;
		ОбновитьСловаПоискаПоПользователюВАдреснойКниге = Истина;
		
	Иначе
		
		РеквизитыПользователяПоСсылке = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Ссылка,
			"Наименование, ПредставлениеВДокументах, ПредставлениеВПереписке, ПредставлениеВПерепискеСРангом, ПометкаУдаления, Недействителен, КонтактнаяИнформация");
			
		Если РеквизитыПользователяПоСсылке.ПометкаУдаления <> ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("ИзмененаПометкаУдаления", Истина);
		КонецЕсли;
		
		Если РеквизитыПользователяПоСсылке.ПометкаУдаления <> ПометкаУдаления
			Или РеквизитыПользователяПоСсылке.Недействителен <> Недействителен Тогда
			ОбновитьДанныеОтображенияПользователяВАдреснойКниге = Истина;
			ОбновитьДоступностьВПоискеПоПользователю = Истина;
			ОбновитьПользователяСВ = Истина;
		КонецЕсли;
		
		Если РеквизитыПользователяПоСсылке.Наименование <> Наименование
			Или РеквизитыПользователяПоСсылке.ПредставлениеВДокументах <> ПредставлениеВДокументах
			Или РеквизитыПользователяПоСсылке.ПредставлениеВПереписке <> ПредставлениеВПереписке
			Или РеквизитыПользователяПоСсылке.ПредставлениеВПерепискеСРангом <> ПредставлениеВПерепискеСРангом Тогда
			
			ОбновитьСловаПоискаПоПользователюВАдреснойКниге = Истина;
		КонецЕсли;
		
		Если РеквизитыПользователяПоСсылке.Наименование <> Наименование
			Или РеквизитыПользователяПоСсылке.ПредставлениеВПерепискеСРангом <> ПредставлениеВПерепискеСРангом Тогда
			ОбновитьДанныеОтображенияПользователяВАдреснойКниге = Истина;
		КонецЕсли;
		
		Если НЕ ОбновитьСловаПоискаПоПользователюВАдреснойКниге Тогда
			СтараяКонтактнаяИнформация = РеквизитыПользователяПоСсылке.
				КонтактнаяИнформация.Выгрузить().ВыгрузитьКолонку("Представление");
			НоваяКонтактнаяИнформация = КонтактнаяИнформация.Выгрузить().ВыгрузитьКолонку("Представление");
			Для Каждого СтрИнфо ИЗ НоваяКонтактнаяИнформация Цикл
				Если СтараяКонтактнаяИнформация.Найти(СтрИнфо) = Неопределено Тогда
					ОбновитьСловаПоискаПоПользователюВАдреснойКниге = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ОбновитьСловаПоискаПоПользователюВАдреснойКниге Тогда
				Для Каждого СтрИнфо ИЗ СтараяКонтактнаяИнформация Цикл
					Если НоваяКонтактнаяИнформация.Найти(СтрИнфо) = Неопределено Тогда
						ОбновитьСловаПоискаПоПользователюВАдреснойКниге = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ГруппаНовогоПользователя")
		И ЗначениеЗаполнено(ДополнительныеСвойства.ГруппаНовогоПользователя) Тогда
		
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("Справочник.РабочиеГруппы");
		Блокировка.Заблокировать();
		
		ОбъектГруппы = ДополнительныеСвойства.ГруппаНовогоПользователя.ПолучитьОбъект();
		ОбъектГруппы.Состав.Добавить().Пользователь = Ссылка;
		ОбъектГруппы.Записать();
		
	КонецЕсли;
	
	// Обновление состава автоматической группы "Все пользователи".
	УчастникиИзменений = Новый Соответствие;
	ИзмененныеГруппы   = Новый Соответствие;
	
	ПользователиСлужебный.ОбновитьСоставыГруппПользователей(
		Справочники.РабочиеГруппы.ВсеПользователи, Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	
	ПользователиСлужебный.ОбновитьИспользуемостьСоставовГруппПользователей(
		Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	
	КонтейнерыПользователя = Новый Массив;
	Если ЭтоНовый Тогда
		// При создании администратора нужно дать ему полномочия Администратор,
		// т.к. при записи контейнеров роли будут переназначены в соответствии с полномочиями.
		Если ДополнительныеСвойства.Свойство("СозданиеАдминистратора")
			И ЗначениеЗаполнено(ДополнительныеСвойства.СозданиеАдминистратора) Тогда
			РегистрыСведений.ПолномочияПользователей.ДобавитьПолномочия(
				Ссылка, Справочники.ПрофилиГруппДоступа.Администратор);
		КонецЕсли;
		// Запись "Пользователь - Пользователь" нужна в ССПД и при отключенных правах тоже.
		РегистрыСведений.СоставСубъектовПравДоступа.ДобавлениеПользователя(Ссылка);
		КонтейнерыПользователя.Добавить(Ссылка);
		КонтейнерыПользователя.Добавить(Справочники.РабочиеГруппы.ВсеПользователи);
		Если ДополнительныеСвойства.Свойство("ГруппаНовогоПользователя")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ГруппаНовогоПользователя) Тогда
			КонтейнерыПользователя.Добавить(ДополнительныеСвойства.ГруппаНовогоПользователя);
		КонецЕсли;
		РегистрыСведений.ПользователиВКонтейнерах.ЗаписатьКонтейнерыПользователя(Ссылка, КонтейнерыПользователя);
	ИначеЕсли ДополнительныеСвойства.Свойство("ИзмененаПометкаУдаления") Тогда
		
		Если Не ПометкаУдаления Тогда
			КонтейнерыПользователя.Добавить(Ссылка);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				КонтейнерыПользователя, 
				Справочники.ПолныеРоли.КонтейнерыПользователя(Ссылка));
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				КонтейнерыПользователя, 
				Справочники.СтруктураПредприятия.КонтейнерыПользователя(Ссылка));
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
				КонтейнерыПользователя, 
				Справочники.РабочиеГруппы.КонтейнерыПользователя(Ссылка));
		КонецЕсли;
		РегистрыСведений.ПользователиВКонтейнерах.ЗаписатьКонтейнерыПользователя(Ссылка, КонтейнерыПользователя);
	КонецЕсли;
	
	// Блокировка пользователя системы взаимодейтвия.
	Если ЗначениеЗаполнено(ИдентификаторПользователяИБ) Тогда
		ОбсужденияДокументооборот.ОбновитьПользователя(Ссылка);
	КонецЕсли;
	
	ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(
		ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
	ПользователиСлужебный.ПослеОбновленияСоставовГруппПользователей(
		УчастникиИзменений, ИзмененныеГруппы);
	
	ПользователиСлужебный.ВключитьЗаданиеКонтрольАктивностиПользователейПриНеобходимости(Ссылка);
	
	ИнтеграцияПодсистемБСП.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Обновление записей в регистре ИсполнителиРолейИДелегаты
	РегистрыСведений.ИсполнителиРолейИДелегаты.ОбновитьЗаписиПоПользователю(Ссылка);
	
	// Обновление адресной книги
	Если ОбновитьДанныеОтображенияПользователяВАдреснойКниге Тогда
		Справочники.АдреснаяКнига.ОбновитьДанныеОтображенияПодчиненногоОбъекта(Ссылка);
	КонецЕсли;
	Если ОбновитьГруппуВсеПользователиВАдреснойКниге Тогда
		СоставГруппыВсеПользователи = РаботаСПользователями.ПолучитьВсехПользователей();
		Справочники.АдреснаяКнига.РасширитьСписокПользователейРолями(
			СоставГруппыВсеПользователи, Ложь);
		Справочники.АдреснаяКнига.ОбновитьСписокПодчиненныхОбъектов(
			Справочники.РабочиеГруппы.ВсеПользователи,
			Неопределено,
			СоставГруппыВсеПользователи,
			Справочники.АдреснаяКнига.ПоРабочимГруппам);
	КонецЕсли;
	Если ОбновитьСловаПоискаПоПользователюВАдреснойКниге Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьСловаПоискаПоПользователю(ЭтотОбъект);
	КонецЕсли;
	Если ОбновитьДоступностьВПоискеПоПользователю Тогда
		РегистрыСведений.ПоискВАдреснойКниге.ОбновитьДоступностьВПоиске(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщиеДействияПередУдалениемВОбычномРежимеИПриОбменеДанными();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДополнительныеСвойства.Вставить("ЗначениеКопирования", ОбъектКопирования.Ссылка);
	
	ИдентификаторПользователяИБ = Неопределено;
	ИдентификаторПользователяСервиса = Неопределено;
	Подготовлен = Ложь;
	
	КонтактнаяИнформация.Очистить();
	Комментарий = "";
	
	ФизЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	ПредставлениеВДокументах = Неопределено;
	ПредставлениеВПереписке = Неопределено;
	ПредставлениеВПерепискеСРангом = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Процедура ОбщиеДействияПередУдалениемВОбычномРежимеИПриОбменеДанными() Экспорт
	
	// Требуется удалить пользователя ИБ, иначе он попадет в список ошибок в форме ПользователиИБ,
	// кроме того, вход под этим пользователем ИБ приведет к ошибке.
	
	ОписаниеПользователяИБ = Новый Структура;
	ОписаниеПользователяИБ.Вставить("Действие", "Удалить");
	ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	
	ПользователиСлужебный.НачатьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ, Истина);
	ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
