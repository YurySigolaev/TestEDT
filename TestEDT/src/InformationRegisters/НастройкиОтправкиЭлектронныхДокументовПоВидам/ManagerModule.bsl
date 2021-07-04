#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Отправитель)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Отправитель)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель,
	|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель,
	|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор
	|ИЗ
	|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
	|ГДЕ
	|	НастройкиОтправкиЭлектронныхДокументовПоВидам.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовЭДО.ПустаяСсылка)
	|	И
	|		(НастройкиОтправкиЭлектронныхДокументовПоВидам.УдалитьВидДокумента <> ЗНАЧЕНИЕ(Перечисление.ТипыДокументовЭДО.ПустаяСсылка)
	|	ИЛИ НастройкиОтправкиЭлектронныхДокументовПоВидам.УдалитьПрикладнойВидЭД <> &ПустойПрикладнойТипДокумента)";
	
	Запрос.УстановитьПараметр("ПустойПрикладнойТипДокумента",
		Метаданные.ОпределяемыеТипы.ПрикладныеТипыЭлектронныхДокументовЭДО.Тип.ПривестиЗначение());
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь, "Справочник.ВидыДокументовЭДО") Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	ПараметрыОтметкиВыполнения = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	СоответствиеВидовДокументов = ОбменСКонтрагентамиИнтеграция.СоответствиеВидовЭДВидамДокументовЭДО();
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Для Каждого СтрокаДанных Из ВыбранныеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Записать = Ложь;
			
			НаборЗаписей = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Отправитель.Установить(СтрокаДанных.Отправитель);
			НаборЗаписей.Отбор.Получатель.Установить(СтрокаДанных.Получатель);
			НаборЗаписей.Отбор.Договор.Установить(СтрокаДанных.Договор);
			ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировкуПоНаборуЗаписей(НаборЗаписей);
			
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() Тогда

				ОбработатьДанные_ЗаполнитьВидДокумента(НаборЗаписей, СоответствиеВидовДокументов, Записать);
			
			КонецЕсли;

			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей, ПараметрыОтметкиВыполнения);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось обработать настройки отправки электронных документов для: %1 по причине:
				|%2'"), СтрокаДанных.Отправитель, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта, СтрокаДанных.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые настройки отправки электронных документов (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция настроек отправки электронных документов: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов =
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбъектовОбработано;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаЗаписи" Тогда
		Возврат;
	КонецЕсли;
	
	КлючЗаписи = Неопределено;
	Если Не Параметры.Свойство("Ключ", КлючЗаписи)
		ИЛИ КлючЗаписи.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.СпособОбменаЭД КАК СпособОбменаЭД
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель = &Отправитель
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель = &Получатель
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор = &Договор
		|	И НастройкиОтправкиЭлектронныхДокументовПоВидам.ВидДокумента = &ВидДокумента";
	
	Запрос.УстановитьПараметр("Отправитель"    , КлючЗаписи.Отправитель);
	Запрос.УстановитьПараметр("Получатель"     , КлючЗаписи.Получатель);
	Запрос.УстановитьПараметр("Договор"        , КлючЗаписи.Договор);
	Запрос.УстановитьПараметр("ВидДокумента"   , КлючЗаписи.ВидДокумента);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	Если СинхронизацияЭДО.ЭтоИнтеркампани(Выборка.СпособОбменаЭД) Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("Отправитель", КлючЗаписи.Отправитель);
		Параметры.Вставить("Получатель",  КлючЗаписи.Получатель);
		ВыбраннаяФорма = КлючЗаписи.Метаданные().Формы.НастройкиОтправкиДокументовИнтеркампани;
	ИначеЕсли СинхронизацияЭДО.ЭтоПрямойОбмен(Выборка.СпособОбменаЭД) Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("Организация", КлючЗаписи.Отправитель);
		Параметры.Вставить("Контрагент",  КлючЗаписи.Получатель);
		Параметры.Вставить("Договор",     КлючЗаписи.Договор);
		ВыбраннаяФорма = КлючЗаписи.Метаданные().Формы.НастройкиОтправкиДокументовПрямойОбмен;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует таблицу настроек отправки и заполняет ее данными по умолчанию
// 
// Возвращаемое значений:
//  Параметры - ТаблицаЗначений - таблица настроек.
//
Функция СоздатьНастройкиОтправкиДокументов() Экспорт
	
	ИсходящиеДокументы = НастройкиОтправкиЭДОСлужебный.НоваяТаблицаНастроек();
	
	ВидыЭлектронныхДокументов = ЭлектронныеДокументыЭДО.ИспользуемыеВидыДокументовИсходящие();
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВидыЭлектронныхДокументов,
		ЭлектронныеДокументыЭДО.ПрикладныеВидыДокументов());
	
	НастройкиОтправкиЭДОСлужебный.ЗаполнитьНастройкиПоВидамЭлектронныхДокументов(ИсходящиеДокументы, ВидыЭлектронныхДокументов);
	
	УстановитьВариантыЗаполненияПолейПоУмолчанию(ИсходящиеДокументы);
	
	Возврат ИсходящиеДокументы;
	
КонецФункции

// Формирует таблицу настроек отправки и заполняет ее данными по умолчанию
// 
// Возвращаемое значений:
//  Параметры - ТаблицаЗначений - таблица настроек.
//
Функция СоздатьНастройкиОтправкиДокументовИнтеркампани() Экспорт
	
	ИсходящиеДокументы = НастройкиОтправкиЭДОСлужебный.НоваяТаблицаНастроек();
	
	ВидыЭлектронныхДокументов = ЭлектронныеДокументыЭДО.ИспользуемыеВидыДокументовИсходящие();
	
	НастройкиОтправкиЭДОСлужебный.ЗаполнитьНастройкиПоВидамЭлектронныхДокументов(ИсходящиеДокументы, ВидыЭлектронныхДокументов);
	
	УстановитьВариантыЗаполненияПолейПоУмолчанию(ИсходящиеДокументы);
	
	Возврат ИсходящиеДокументы;
	
КонецФункции

// Удаляет настройки отправки ЭДО
// 
//  Параметры - СписокЗначений - параметры учетной записи для удаления
//  АдресРезультата - Строка - путь временного хранилища
//
Процедура УдалитьНастройкиОтправкиЭДО(Параметры, АдресРезультата) Экспорт
	
	Организация        = Неопределено;
	Контрагент         = Неопределено;
	ДоговорКонтрагента = Неопределено;
	Результат          = Истина;
	
	Параметры.Свойство("Организация"       , Организация);
	Параметры.Свойство("Контрагент"        , Контрагент);
	Параметры.Свойство("ДоговорКонтрагента", ДоговорКонтрагента);
	
	Если Не ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ДоговорКонтрагента = Метаданные.ОпределяемыеТипы.ДоговорСКонтрагентомЭДО.Тип.ПривестиЗначение();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Отправитель.Установить(Организация);
	НаборЗаписей.Отбор.Получатель.Установить(Контрагент);
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		НаборЗаписей.Отбор.Договор.Установить(ДоговорКонтрагента);
	КонецЕсли;
	
	НаборЗаписейЗаполнениеДопПолей = РегистрыСведений.НастройкиЗаполненияДополнительныхПолей.СоздатьНаборЗаписей();
	НаборЗаписейЗаполнениеДопПолей.Отбор.Отправитель.Установить(Организация);
	НаборЗаписейЗаполнениеДопПолей.Отбор.Получатель.Установить(Контрагент);
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		НаборЗаписейЗаполнениеДопПолей.Отбор.Договор.Установить(ДоговорКонтрагента);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		// Попытка удаления. Управляемую блокировку устанавливать нет необходимости.
		НаборЗаписей.Записать();
		НаборЗаписейЗаполнениеДопПолей.Записать();
		
		ИмяРеквизитаИННКонтрагента = ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННКонтрагента");
		ИмяРеквизитаКППКонтрагента = ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("КППКонтрагента");
		
		ПараметрыКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент,
			ИмяРеквизитаИННКонтрагента + ", " + ИмяРеквизитаКППКонтрагента);
		
		ПараметрыПроверки = РаботаСАбонентамиЭДО.НовыеПараметрыПроверкиКонтрагента();
		ПараметрыПроверки.Контрагент = Контрагент;
		ПараметрыПроверки.ИНН = ПараметрыКонтрагента[ИмяРеквизитаИННКонтрагента];
		ПараметрыПроверки.КПП = ПараметрыКонтрагента[ИмяРеквизитаКППКонтрагента];
		ПараметрыПроверки.СохранятьРезультатСразуПослеПроверки = Истина;
		ПараметрыПроверки.ПолучатьРезультатПроверкиВебСервисом = Истина;
		
		РаботаСАбонентамиЭДО.ПроверитьКонтрагента(ПараметрыПроверки);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось удалить настройки отправки по:
                                      |Организация: %1,
                                      |Контрагент: %2,
                                      |Договор контрагента: %3.'"), Организация, Контрагент, ДоговорКонтрагента);
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Удаление настроек отправки ЭДО'"), ПодробноеПредставлениеОшибки(Информация), ТекстОшибки);
		Результат = Ложь;
		
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Удаляет настройки отправки интеркампани
// 
//  Параметры - СписокЗначений - параметры учетной записи для удаления
//  АдресРезультата - Строка - путь временного хранилища
//
Процедура УдалитьНастройкиИнтеркампани(Параметры, АдресРезультата) Экспорт
	
	Отправитель        = Неопределено;
	Получатель         = Неопределено;
	Результат          = Истина;
	
	Параметры.Свойство("Отправитель"       , Отправитель);
	Параметры.Свойство("Получатель"        , Получатель);
	
	НаборЗаписей = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Отправитель.Установить(Отправитель);
	НаборЗаписей.Отбор.Получатель.Установить(Получатель);
	
	НачатьТранзакцию();
	Попытка
		// Попытка удаления. Управляемую блокировку устанавливать нет необходимости.
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось удалить настройки интеркампани по:
                                      |Отправитель: %1,
                                      |Получатель: %2.'"), Отправитель, Получатель);
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Удаление настроек интеркампани'"), ПодробноеПредставлениеОшибки(Информация), ТекстОшибки);
		Результат = Ложь;
		
	КонецПопытки;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

// Записывает обновленные настройки отправки в регистр
// 
//  Настройки - Структура - настройки обмена для записи
Процедура ЗаписатьОбновленныеНастройки(Настройки) Экспорт
	
	Менеджер = РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьМенеджерЗаписи();
	Менеджер.Отправитель     = Настройки.Отправитель;
	Менеджер.Получатель      = Настройки.Получатель;
	Менеджер.Договор         = Настройки.Договор;
	Менеджер.ВидДокумента    = Настройки.ВидЭД;
	Менеджер.Прочитать();
	Менеджер.ВерсияФормата                   = Настройки.ВерсияФормата;
	Менеджер.ИдентификаторОтправителя        = Настройки.ИдентификаторОрганизации;
	Менеджер.ИдентификаторПолучателя         = Настройки.ИдентификаторКонтрагента;
	Менеджер.МаршрутПодписания               = Настройки.МаршрутПодписания;
	Менеджер.ТребуетсяОтветнаяПодпись        = Настройки.ТребуетсяПодтверждение;
	Менеджер.ТребуетсяИзвещениеОПолучении    = Настройки.ТребуетсяИзвещение;
	Менеджер.ВыгружатьДополнительныеСведения = Настройки.ВыгружатьДополнительныеСведения;
	Менеджер.ВерсияФорматаУстановленаВручную = Настройки.ВерсияФорматаУстановленаВручную;
	Менеджер.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьВариантыЗаполненияПолейПоУмолчанию(ИсходящиеДокументы)
	
	Для Каждого СтрокаТаблицы Из ИсходящиеДокументы Цикл
		ВариантыЗаполнения = ЭлектронныеДокументыЭДО.ВариантыЗаполненияПолейЭлектронныхДокументов(
			СтрокаТаблицы.ВидДокумента, СтрокаТаблицы.ВерсияФормата);
		
		ЗначениеСвойства = Неопределено;
		Если ВариантыЗаполнения.Свойство("ТоварКод", ЗначениеСвойства) Тогда
			СтрокаТаблицы.ЗаполнениеКодаТовара = ЗначениеСвойства[0].Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДанные_ЗаполнитьВидДокумента(НаборЗаписей, СоответствиеВидовДокументов, Записать)
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Если Не ЗначениеЗаполнено(Запись.ВидДокумента) Тогда
			Если ЗначениеЗаполнено(Запись.УдалитьПрикладнойВидЭД) Тогда
				ТипДокумента = Запись.УдалитьПрикладнойВидЭД;
			ИначеЕсли ЗначениеЗаполнено(Запись.УдалитьВидДокумента) Тогда 
				ТипДокумента = Запись.УдалитьВидДокумента;
			Иначе
				Продолжить;
			КонецЕсли;
			Запись.ВидДокумента = СоответствиеВидовДокументов[ТипДокумента];
			Записать = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаНастроек = НаборЗаписей.Выгрузить();
	НастройкаПроизвольногоВидаДокумента = ТаблицаНастроек.Найти(Перечисления.ТипыДокументовЭДО.УдалитьПроизвольный,
		"УдалитьВидДокумента");
	
	Если НастройкаПроизвольногоВидаДокумента <> Неопределено Тогда
		Для Каждого ВидДокумента Из ЭлектронныеДокументыЭДО.ВидыДокументовДляПроизвольногоФормата() Цикл
			Если ТаблицаНастроек.Найти(ВидДокумента, "ВидДокумента") = Неопределено Тогда
				НоваяСтрока = ТаблицаНастроек.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, НастройкаПроизвольногоВидаДокумента);
				НоваяСтрока.ВидДокумента = ВидДокумента;
			КонецЕсли;
		КонецЦикла;
		ТаблицаНастроек.Удалить(НастройкаПроизвольногоВидаДокумента);
		Записать = Истина;
	КонецЕсли;
	
	ТаблицаНастроек.ЗаполнитьЗначения(Перечисления.ТипыДокументовЭДО.ПустаяСсылка(), "УдалитьВидДокумента");
	ТаблицаНастроек.ЗаполнитьЗначения(Неопределено, "УдалитьПрикладнойВидЭД");
	
	НаборЗаписей.Загрузить(ТаблицаНастроек);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли