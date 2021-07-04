
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Шаблона внутренних документов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруШаблона() Экспорт
	
	ПараметрыШаблона = Новый Структура;
	ПараметрыШаблона.Вставить("Наименование");
	ПараметрыШаблона.Вставить("ВидДокумента");
	ПараметрыШаблона.Вставить("Папка");
	ПараметрыШаблона.Вставить("ВопросДеятельности");
	ПараметрыШаблона.Вставить("НоменклатураДел");
	ПараметрыШаблона.Вставить("Автор");
	ПараметрыШаблона.Вставить("Родитель");
	ПараметрыШаблона.Вставить("Организация");
	ПараметрыШаблона.Вставить("Проект");
	
	ПрикрепленныеФайлы = Новый ТаблицаЗначений;
	ПрикрепленныеФайлы.Колонки.Добавить("ФайлСсылка");
	ПараметрыШаблона.Вставить("ПрикрепленныеФайлы", ПрикрепленныеФайлы);
	
	РабочаяГруппаДокумента = Новый ТаблицаЗначений;
	РабочаяГруппаДокумента.Колонки.Добавить("Участник");
	ПараметрыШаблона.Вставить("РабочаяГруппаДокумента", РабочаяГруппаДокумента);
	
	Возврат ПараметрыШаблона;
	
КонецФункции

// Создает и записывает в БД шаблон внутренних документов
//
// Параметры:
//   СтруктураШаблона - Структура - структура полей шаблона вн документов.
//
Функция СоздатьШаблон(СтруктураШаблона) Экспорт
	
	НовыйШаблон = Справочники.ШаблоныВнутреннихДокументов.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйШаблон, СтруктураШаблона);
	Для Каждого Строка Из СтруктураШаблона.ПрикрепленныеФайлы Цикл
		НоваяСтрока = НовыйШаблон.ПрикрепленныеФайлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	Для Каждого Строка Из СтруктураШаблона.РабочаяГруппаДокумента Цикл
		НоваяСтрока = НовыйШаблон.РабочаяГруппаДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	НовыйШаблон.Записать();
	
	Возврат НовыйШаблон.Ссылка;
	
КонецФункции

Функция ПодготовитьСводкуПоШаблону(ШаблонСсылка) Экспорт
	
	ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ШаблонСсылка,
		"Заголовок,
		|КомментарийКДокументу,
		|ВидДокумента,
		|ГрифДоступа,
		|ДлительностьИсполнения,
		|Организация,
		|Подразделение");
	
	РабочаяГруппаСтр = "";
	Для Каждого УчастникГруппы Из ШаблонСсылка.РабочаяГруппаДокумента Цикл
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			РабочаяГруппаСтр,
			", ",
			УчастникГруппы.Участник);
	КонецЦикла;
	Если ЗначениеЗаполнено(РабочаяГруппаСтр) Тогда
		ДанныеДокумента.Вставить("РабочаяГруппа", РабочаяГруппаСтр);
	КонецЕсли;
	
	КонтрагентыСтр = "";
	Для Каждого СтрокаКонтрагент Из ШаблонСсылка.Контрагенты Цикл
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
			КонтрагентыСтр,
			", ",
			СтрокаКонтрагент.Контрагент);
	КонецЦикла;
	Если ШаблонСсылка.Контрагенты.Количество() > 1 Тогда
		ДанныеДокумента.Вставить("Контрагенты", КонтрагентыСтр);
	ИначеЕсли ШаблонСсылка.Контрагенты.Количество() = 1 Тогда
		ДанныеДокумента.Вставить("Контрагент", КонтрагентыСтр);
	КонецЕсли;
	
	ДанныеДокумента.Вставить("Метаданные", ШаблонСсылка.Метаданные());
	
	Возврат ДанныеДокумента;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ссылка,
		|ЭтоГруппа,
		|ВидДокумента,
		|ВопросДеятельности,
		|ГрифДоступа,
		|Организация,
		|Папка,
		|Контрагент,
		|Автор,
		|Контрагенты";
	
КонецФункции

// Заполняет переданный дескриптор доступа
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	// Заполнение дескриптора для элемента справочника
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.ВидДокумента;
	ДескрипторДоступа.ВопросДеятельности = ОбъектДоступа.ВопросДеятельности;
	ДескрипторДоступа.ГрифДоступа = ОбъектДоступа.ГрифДоступа;
	ДескрипторДоступа.Организация = ОбъектДоступа.Организация;
	
	// Папка
	Если ЗначениеЗаполнено(ОбъектДоступа.Папка) Тогда
		ДокументооборотПраваДоступа.ЗаполнитьПапкуДескриптораОбъекта(ОбъектДоступа, ДескрипторДоступа);
	КонецЕсли;
	
	// Контрагенты
	ВсеКонтрагенты = ОбъектДоступа.Контрагенты.Выгрузить().ВыгрузитьКолонку("Контрагент");
	ЗначенияГруппыДоступа = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ВсеКонтрагенты, "ГруппаДоступа");
	
	ДобавленныеГруппы = Новый Соответствие;
	Для Каждого КлючИЗначение Из ЗначенияГруппыДоступа Цикл
		ГруппаДоступа = КлючИЗначение.Значение;
		Если ЗначениеЗаполнено(ГруппаДоступа) И ДобавленныеГруппы.Получить(ГруппаДоступа) = Неопределено Тогда
			Строка = ДескрипторДоступа.Контрагенты.Добавить();
			Строка.ГруппаДоступа = ГруппаДоступа;
			ДобавленныеГруппы.Вставить(ГруппаДоступа, Истина);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ЕстьМетодПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает таблицу значений с правилами обработки настроек прав папки,
// которые следует применять для расчета прав объекта
// 
Функция ПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	Возврат Справочники.ВнутренниеДокументы.ПолучитьПравилаОбработкиНастроекПравПапки();
	
КонецФункции

#КонецОбласти

#КонецЕсли
