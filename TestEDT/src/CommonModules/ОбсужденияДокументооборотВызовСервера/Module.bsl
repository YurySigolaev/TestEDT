////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с обсуждениями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает ключ обсуждения.
//
// Параметры:
//  ИдентификаторОбсуждения - ИдентификаторОбсужденияСистемыВзаимодействия.
//
// Возвращаемое значение:
//  Строка - ключ обсуждения.
//
Функция КлючОбсуждения(Знач ИдентификаторОбсуждения) Экспорт
	
	Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(ИдентификаторОбсуждения);
	
	Возврат Обсуждение.Ключ;
	
КонецФункции

// Проверяет запрет изменения состава участников обсуждения.
// 
// Параметры:
//  ИмяПараметра - Список типов - Текстовое описание параметра функции.
//
// Возвращаемое значение:
//  Булево - Истина, если текущему пользователю запрещено менять состав обсуждения с переданным ключом..
//
Функция РедактированиеУчастниковОбсужденияРазрешено(Знач КлючОбсуждения) Экспорт
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	Если ПользователиСерверПовтИсп.ЭтоПолноправныйПользовательИБ(ТекущийПользователь) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтрНайти(КлючОбсуждения, "Auto") = 0
		Или СтрНайти(КлючОбсуждения, Метаданные.Справочники.Мероприятия.ПолноеИмя()) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если СтрНайти(КлючОбсуждения, Метаданные.Справочники.РабочиеГруппы.ПолноеИмя()) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Разрешено = Ложь;
	Контейнер = ОбсужденияДокументооборот.КонтейнерПоКлючуОбсуждения(КлючОбсуждения);
	ТипКонтейнера = ТипЗнч(Контейнер);
	Если ТипКонтейнера = Тип("СправочникСсылка.СтруктураПредприятия") 
			Или ТипКонтейнера = Тип("СправочникСсылка.Проекты") Тогда
		Руководитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контейнер, "Руководитель");
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ИСТИНА КАК ЕстьЗаписи
			|ИЗ
			|	РегистрСведений.СоставСубъектовПравДоступа КАК СоставСубъектовПравДоступа
			|ГДЕ
			|	СоставСубъектовПравДоступа.Субъект = &Руководитель
			|	И СоставСубъектовПравДоступа.Пользователь = &ТекущийПользователь
			|	И СоставСубъектовПравДоступа.ИмяОбластиДелегирования = """"");
		Запрос.УстановитьПараметр("Руководитель", Руководитель);
		Запрос.УстановитьПараметр("ТекущийПользователь", ТекущийПользователь);
		РезультатЗапроса = Запрос.Выполнить();
		Разрешено = Не РезультатЗапроса.Пустой();
	КонецЕсли;
	
	Возврат Разрешено;
	
КонецФункции

// Выполняет необходимые действия при подключении/отключении обсуждений.
//
// Параметры:
//  ОбсужденияПодключены - Булево - актуальное состояние подключения.
//
Процедура ПриИзмененииСостоянияПодключения(ОбсужденияПодключены) Экспорт
	
	ОбсужденияДокументооборот.ПриИзмененииСостоянияПодключения();
	
КонецПроцедуры

// Возвращает соответствие идентфикаторов СВ и ИБ.
// 
// Параметры:
//  ИдентификаторыПользователейСВ - Массив - идентификаторы СВ.
//
Функция ИдПользователейИБПоИдПользователейСВ(ИдентификаторыПользователейСВ) Экспорт
	
	Результат = Новый Соответствие;
	
	Для Каждого ИдентификаторСВ Из ИдентификаторыПользователейСВ Цикл
		Попытка
			ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторСВ);
			Результат[ИдентификаторСВ] = ПользовательСВ.ИдентификаторПользователяИнформационнойБазы;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные, необходимые для автоподбора пользователей СВ.
//
// Параметры:
//  ИдентификаторОбсуждения - ИдентификаторОбсужденияСистемыВзаимодействия, Неопределено.
//  КонтекстСсылка - Ссылка, Неопределено - контекст обсуждения.
//
// Возвращаемое значение:
//  Структура.
//
Функция ДанныеОбсужденияДляАвтоподбора(ИдентификаторОбсуждения, КонтекстСсылка) Экспорт
	
	ДанныеОбсуждения = Новый Структура;
	ДанныеОбсуждения.Вставить("Ключ", "");
	ДанныеОбсуждения.Вставить("ПользователиИБСПравамиНаКонтекст", Неопределено);
	
	Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(ИдентификаторОбсуждения);
	Если Обсуждение <> Неопределено Тогда
		ДанныеОбсуждения.Ключ = Обсуждение.Ключ;
	КонецЕсли;
	
	Если КонтекстСсылка <> Неопределено
		И ОбщегоНазначения.ЭтоСсылка(ТипЗнч(КонтекстСсылка)) Тогда
		
		ПользователиИБСПравами = Новый Соответствие;
		ТаблицаПрав = ДокументооборотПраваДоступа.ПолучитьПраваПользователейПоОбъекту(КонтекстСсылка, Истина);
		ПользователиСПравами = ТаблицаПрав.ВыгрузитьКолонку("Пользователь");
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Пользователи.Наименование,
			|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
			|ИЗ
			|	Справочник.Пользователи КАК Пользователи
			|ГДЕ
			|	Пользователи.Ссылка В(&ПользователиСПравами)");
		Запрос.УстановитьПараметр("ПользователиСПравами", ПользователиСПравами);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ПользователиИБСПравами[Выборка.ИдентификаторПользователяИБ] = Выборка.Наименование;
		КонецЦикла;
		ДанныеОбсуждения.ПользователиИБСПравамиНаКонтекст = ПользователиИБСПравами;
	КонецЕсли;
	
	Возврат ДанныеОбсуждения;
	
КонецФункции

#КонецОбласти
