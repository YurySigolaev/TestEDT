///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Варианты") Или ТипЗнч(Параметры.Варианты) <> Тип("Массив") Тогда
		ТекстОшибки = НСтр("ru = 'Не указаны варианты отчетов.'");
		Возврат;
	КонецЕсли;
	
	Если Не ЕстьПользовательскиеНастройки(Параметры.Варианты) Тогда
		ТекстОшибки = НСтр("ru = 'Пользовательские настройки выбранных вариантов отчетов (%1 шт) не заданы или уже сброшены.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Формат(Параметры.Варианты.Количество(), "ЧН=0; ЧГ=0"));
		Возврат;
	КонецЕсли;
	
	ОпределитьПоведениеВМобильномКлиенте();
	ИзменяемыеВарианты.ЗагрузитьЗначения(Параметры.Варианты);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСбросить(Команда)
	КоличествоВариантов = ИзменяемыеВарианты.Количество();
	Если КоличествоВариантов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не указаны варианты отчетов.'"));
		Возврат;
	КонецЕсли;
	
	СброситьНастройкиПользователейСервер(ИзменяемыеВарианты);
	Если КоличествоВариантов = 1 Тогда
		СсылкаВарианта = ИзменяемыеВарианты[0].Значение;
		ОповещениеЗаголовок = НСтр("ru = 'Сброшены пользовательские настройки варианта отчета'");
		ОповещениеСсылка    = ПолучитьНавигационнуюСсылку(СсылкаВарианта);
		ОповещениеТекст     = Строка(СсылкаВарианта);
		ПоказатьОповещениеПользователя(ОповещениеЗаголовок, ОповещениеСсылка, ОповещениеТекст);
	Иначе
		ОповещениеТекст = НСтр("ru = 'Сброшены пользовательские настройки
		|вариантов отчетов (%1 шт.).'");
		ОповещениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ОповещениеТекст, Формат(КоличествоВариантов, "ЧН=0; ЧГ=0"));
		ПоказатьОповещениеПользователя(, , ОповещениеТекст);
	КонецЕсли;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервереБезКонтекста
Процедура СброситьНастройкиПользователейСервер(Знач ИзменяемыеВарианты)
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСписка.Значение);
		КонецЦикла;
		Блокировка.Заблокировать();
		
		РегистрыСведений.НастройкиВариантовОтчетов.СброситьНастройки(ИзменяемыеВарианты.ВыгрузитьЗначения());
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	Если Не ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда 
		Возврат;
	КонецЕсли;
	
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
КонецПроцедуры

&НаСервере
Функция ЕстьПользовательскиеНастройки(МассивВариантов)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВариантов", МассивВариантов);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьПользовательскиеНастройки
	|ИЗ
	|	РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	|ГДЕ
	|	Настройки.Вариант В(&МассивВариантов)";
	
	ЕстьПользовательскиеНастройки = НЕ Запрос.Выполнить().Пустой();
	Возврат ЕстьПользовательскиеНастройки;
КонецФункции

#КонецОбласти
