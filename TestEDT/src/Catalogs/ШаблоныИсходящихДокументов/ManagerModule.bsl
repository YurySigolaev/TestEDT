#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Шаблона исходящих документов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруШаблона() Экспорт
	
	ПараметрыШаблона = Новый Структура;
	ПараметрыШаблона.Вставить("Наименование");
	ПараметрыШаблона.Вставить("ВидДокумента");
	ПараметрыШаблона.Вставить("ВопросДеятельности");
	ПараметрыШаблона.Вставить("НоменклатураДел");
	ПараметрыШаблона.Вставить("Автор");
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

// Создает и записывает в БД шаблон исходящих документов
//
// Параметры:
//   СтруктураШаблона - Структура - структура полей шаблона ис документов.
//
Функция СоздатьШаблон(СтруктураШаблона) Экспорт
	
	НовыйШаблон = Справочники.ШаблоныИсходящихДокументов.СоздатьЭлемент();
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
	
	ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ШаблонСсылка, 
		"Заголовок,КомментарийКДокументу,ВидДокумента,ГрифДоступа,ДлительностьИсполнения,Организация,Подразделение");
		
	РабочаяГруппа = "";
	Для Каждого УчастникГруппы Из ШаблонСсылка.РабочаяГруппаДокумента Цикл
		РабочаяГруппа = РабочаяГруппа + Строка(УчастникГруппы.Участник);
		РабочаяГруппа = РабочаяГруппа + ", ";
	КонецЦикла;
	Если ЗначениеЗаполнено(РабочаяГруппа) Тогда
		РабочаяГруппа = Лев(РабочаяГруппа, СтрДлина(РабочаяГруппа) - 2);
		ДанныеДокумента.Вставить("РабочаяГруппа", РабочаяГруппа);
	КонецЕсли;
	
	Получатели = "";
	Для Каждого Получатель Из ШаблонСсылка.Получатели Цикл
		Получатели = Получатели + Получатель.Получатель	+ ", ";
	КонецЦикла;
	Если ЗначениеЗаполнено(Получатели) Тогда
		Получатели = Лев(Получатели, СтрДлина(Получатели) - 2);
		ДанныеДокумента.Вставить("Получатели", Получатели);
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
		|Получатели,
		|Автор";
	
КонецФункции

// Заполняет переданный дескриптор доступа
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
		
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.ВидДокумента;
	ДескрипторДоступа.ВопросДеятельности = ОбъектДоступа.ВопросДеятельности;
	ДескрипторДоступа.ГрифДоступа = ОбъектДоступа.ГрифДоступа;
	ДескрипторДоступа.Организация = ОбъектДоступа.Организация;
	
	// Контрагенты
	ВсеКонтрагенты = ОбъектДоступа.Получатели.Выгрузить().ВыгрузитьКолонку("Получатель");
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

#КонецОбласти

#КонецЕсли