#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриКопировании(ОбъектКопирования)
	
	РегистрационныйНомер = "";
	ЧисловойНомер 	= 0;
	Бессрочный = Ложь;
	ДатаНачалаДействия = '00010101';
	ДатаОкончанияДействия = '00010101';
	ПорядокПродления = Перечисления.ПорядокПродления.ПустаяСсылка();
	ДатаРегистрации = '00010101';
	ДатаСоздания 	= ТекущаяДатаСеанса();
	Зарегистрировал = Справочники.Пользователи.ПустаяСсылка();
	Подготовил 		= ПользователиКлиентСервер.ТекущийПользователь();
	Создал	 		= Подготовил;
	Подразделение 	= РаботаСПользователями.ПолучитьПодразделение(Подготовил);
	Утвердил		= Справочники.Пользователи.ПустаяСсылка();
	Подписал		= Справочники.Пользователи.ПустаяСсылка();
	УстановилПодпись= Справочники.Пользователи.ПустаяСсылка();
	ДатаПодписания	= '00010101';
	ДатаУстановкиПодписи = '00010101';
	КомментарийПодписи = "";
	РезультатПодписания = Перечисления.РезультатыПодписания.ПустаяСсылка();
	
	КоличествоЭкземпляров = 1;
	КоличествоЛистов 	 = 1;
	КоличествоПриложений = 0;
	ЛистовВПриложениях 	 = 0;
	Дело = Справочники.ДелаХраненияДокументов.ПустаяСсылка();
	
	ПодписанЭП = Ложь;
	НеДействует = Ложь;
	
	Стороны.Очистить();
	Для Каждого СтрокаСтороны Из ОбъектКопирования.Стороны Цикл
		НоваяСторона = Стороны.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСторона, СтрокаСтороны, "Сторона, КонтактноеЛицо, Наименование");
		НоваяСторона.Подписал = "";
	КонецЦикла;
	
	ГрифыУтверждения.Очистить();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт 
	
	Если ЭтоНовый() Тогда 
		
		РегистрационныйНомер = "";
		ЧисловойНомер 	= 0;
		ДатаРегистрации = '00010101';
		ДатаСоздания 	= ТекущаяДатаСеанса();
		Зарегистрировал = Справочники.Пользователи.ПустаяСсылка();
		Подготовил 		= ПользователиКлиентСервер.ТекущийПользователь();
		Создал	 		= Подготовил;
		Подразделение 	= РаботаСПользователями.ПолучитьПодразделение(Подготовил);
		
		КоличествоЭкземпляров = 1;
		КоличествоЛистов 	 = 1;
		КоличествоПриложений = 0;
		ЛистовВПриложениях 	 = 0;
		Дело = Справочники.ДелаХраненияДокументов.ПустаяСсылка();
		СрокИсполнения = '00010101';

		Если Не ЗначениеЗаполнено(ВидДокумента) Тогда 
			ВидДокумента = Делопроизводство.ПолучитьВидДокументаПоУмолчанию(Ссылка);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Организация) Тогда 
			Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
		КонецЕсли;
		
		Если Константы.ИспользоватьГрифыДоступа.Получить() Тогда
			ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
		КонецЕсли;	

		Если ЗначениеЗаполнено(ВидДокумента) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьСуммуВоВнутренних",
			Новый Структура("ВидВнутреннегоДокумента", ВидДокумента)) Тогда
			Валюта = Делопроизводство.ПолучитьВалютуПоУмолчанию();
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(Проект) Тогда
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
		
		ФормаДокумента = Перечисления.ВариантыФормДокументов.Бумажная;
	КонецЕсли;
	
	ОснованиеЗаполнения = ДанныеЗаполнения;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Основание") Тогда
		ОснованиеЗаполнения = ДанныеЗаполнения.Основание;
	КонецЕсли;
	
	// Сначала заполняем данными шаблона - затем документа-основания.
	
	// Создание из шаблона.
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ШаблонДокумента") Тогда
		
		Шаблон = ДанныеЗаполнения.ШаблонДокумента;
		ШаблоныДокументов.ЗаполнитьРеквизитыДокументаПоШаблону(Шаблон, ЭтотОбъект);
		
	КонецЕсли;
	
	// Создание внутренних документов на основании других внутренних документов.
	Если ТипЗнч(ОснованиеЗаполнения) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОснованиеЗаполнения, 
			"Заголовок, НоменклатураДел, Контрагент, КонтактноеЛицо, Папка, Проект, ГрифДоступа, ВопросДеятельности, 
			|Организация, Сумма, Валюта");
		
		ЯвляетсяЗаявкойНаОплату = Ложь;
		Если ЗначениеЗаполнено(ВидДокумента) Тогда
			ЯвляетсяЗаявкойНаОплату = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "ЯвляетсяЗаявкойНаОплату");
		КонецЕсли;
			
		Если Не ЗначениеЗаполнено(Заголовок) Тогда
			Заголовок = РеквизитыОснования.Заголовок;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = РеквизитыОснования.Организация;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ВопросДеятельности) Тогда
			ВопросДеятельности = РеквизитыОснования.ВопросДеятельности;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Папка) Тогда
			Папка = РеквизитыОснования.Папка;
		КонецЕсли;
		
		Если Стороны.Количество() = 0 Тогда 
			Для каждого Строка Из ОснованиеЗаполнения.Стороны Цикл
				НоваяСтрока = Стороны.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, "Сторона, КонтактноеЛицо, Наименование");
			КонецЦикла;
			
		ИначеЕсли Стороны.Количество() = 1 Тогда 
			// Первая строка должна быть "Организацией", если она введена, то копируем только контрагентов
			ВведенаОрганизация = Неопределено;
			Для Каждого Сторона из Стороны Цикл 
				Если ЗначениеЗаполнено(Сторона.Сторона) 
					И ТипЗнч(Сторона.Сторона) = Тип("СправочникСсылка.Организации") Тогда 
					ВведенаОрганизация = Сторона.Сторона;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			ПерваяСтрока = Истина;
			Для Каждого Строка Из ОснованиеЗаполнения.Стороны Цикл
				Если ВведенаОрганизация <> Неопределено И ЗначениеЗаполнено(Строка.Сторона) 
					И ТипЗнч(Строка.Сторона) = Тип("СправочникСсылка.Организации") Тогда 
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = Стороны.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, "Сторона, КонтактноеЛицо, Наименование");
			КонецЦикла;
			
		ИначеЕсли Стороны.Количество() = 2 И ЯвляетсяЗаявкойНаОплату Тогда
			
			// В заявке на оплату всегда есть 2 стороны - плательщик и получатель
			// Плательщик - наша организация, получатель - контрагент из основания
			
			ОрганизацияОснования = Неопределено;
			КонтрагентОснования = Неопределено;
			
			Для Каждого СтрокаСтороныОснования Из ОснованиеЗаполнения.Стороны Цикл
				Если ЗначениеЗаполнено(СтрокаСтороныОснования.Сторона) Тогда
					Если ТипЗнч(СтрокаСтороныОснования.Сторона) = Тип("СправочникСсылка.Организации")
						И Не ЗначениеЗаполнено(ОрганизацияОснования) Тогда
						ОрганизацияОснования = СтрокаСтороныОснования;
					ИначеЕсли Не ЗначениеЗаполнено(КонтрагентОснования) Тогда
						КонтрагентОснования = СтрокаСтороныОснования;
					Иначе
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого Сторона Из Стороны Цикл
				Если Не ЗначениеЗаполнено(Сторона.Сторона) Тогда
					Если Сторона.Наименование = Справочники.НаименованияСторон.Плательщик Тогда
						Если ЗначениеЗаполнено(ОрганизацияОснования) Тогда
							ЗаполнитьЗначенияСвойств(Сторона, ОрганизацияОснования, "Сторона, КонтактноеЛицо");
						Иначе
							Сторона.Сторона = РеквизитыОснования.Организация;
						КонецЕсли;
					ИначеЕсли Сторона.Наименование = Справочники.НаименованияСторон.Получатель Тогда
						Если ЗначениеЗаполнено(КонтрагентОснования) Тогда
							ЗаполнитьЗначенияСвойств(Сторона, КонтрагентОснования, "Сторона, КонтактноеЛицо");
						Иначе
							Сторона.Сторона = РеквизитыОснования.Контрагент;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если Контрагенты.Количество() = 0 Тогда 
			Для каждого Строка Из ОснованиеЗаполнения.Контрагенты Цикл
				НоваяСтрока = Контрагенты.Добавить();
				НоваяСтрока.Контрагент = Строка.Контрагент;
				НоваяСтрока.КонтактноеЛицо = Строка.КонтактноеЛицо;
				НоваяСтрока.ПодписалОтКонтрагента = Строка.ПодписалОтКонтрагента;
			КонецЦикла;
			
			Если Не ЗначениеЗаполнено(Контрагент) Тогда
				Контрагент = РеквизитыОснования.Контрагент;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(КонтактноеЛицо) Тогда
				КонтактноеЛицо = РеквизитыОснования.КонтактноеЛицо;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(НоменклатураДел) Тогда
			НоменклатураДел = РеквизитыОснования.НоменклатураДел;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ГрифДоступа) Тогда
			ГрифДоступа = РеквизитыОснования.ГрифДоступа;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Проект) Тогда
			Проект = РеквизитыОснования.Проект;
		КонецЕсли;
		
		Сумма = РеквизитыОснования.Сумма;
		
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			Валюта = РеквизитыОснования.Валюта;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОснованиеЗаполнения) = Тип("СправочникСсылка.ВходящиеДокументы") 
		Или ТипЗнч(ОснованиеЗаполнения) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОснованиеЗаполнения, 
			"Заголовок, ВопросДеятельности, Организация, Проект");
		
		Если Не ЗначениеЗаполнено(Заголовок) Тогда
			Заголовок = РеквизитыОснования.Заголовок;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = РеквизитыОснования.Организация;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ВопросДеятельности) Тогда
			ВопросДеятельности = РеквизитыОснования.ВопросДеятельности;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Проект) Тогда
			Проект = РеквизитыОснования.Проект;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОснованиеЗаполнения) = Тип("Массив")
		И ОснованиеЗаполнения.Количество() > 0
		И ТипЗнч(ОснованиеЗаполнения[0]) = Тип("СправочникСсылка.Файлы") Тогда
		
		Если ОснованиеЗаполнения.Количество() = 1 И Не ЗначениеЗаполнено(Заголовок) Тогда
			Заголовок = ОснованиеЗаполнения[0].ПолноеНаименование;
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") И Не ЗначениеЗаполнено(Проект) Тогда
			Проекты = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ОснованиеЗаполнения, "Проект");
			Проект = Проекты.Получить(ОснованиеЗаполнения[0]);
			Для Каждого Строка Из Проекты Цикл
				Если Строка.Значение <> Проект Тогда 
					Проект = Неопределено;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;	
		
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ОснованиеЗаполнения) Тогда
		
		ОснованиеЗаполненияОбъект = ОснованиеЗаполнения.ПолучитьОбъект();
		
		Если Не ЗначениеЗаполнено(Содержание) Тогда
			Содержание = ОснованиеЗаполненияОбъект.ПолучитьТекстовоеПредставлениеСодержанияПисьма();
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Заголовок) Тогда
			Заголовок = ОснованиеЗаполненияОбъект.Тема;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Проект) Тогда
			Проект = ОснованиеЗаполненияОбъект.Проект;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОснованиеЗаполнения) = Тип("Структура") Тогда 
		
		ОснованиеЗаполнения.Свойство("Заголовок",Заголовок);
		ОснованиеЗаполнения.Свойство("Содержание",Содержание);
		ОснованиеЗаполнения.Свойство("Комментарий",Комментарий);
		ОснованиеЗаполнения.Свойство("СуммаДокумента",Сумма);
		ОснованиеЗаполнения.Свойство("Папка",Папка);
		ОснованиеЗаполнения.Свойство("Ответственный",Ответственный);
		
		Стороны.Очистить();
		
		ОснованиеСтороны = Неопределено;
		ОснованиеЗаполнения.Свойство("Стороны", ОснованиеСтороны);
		
		Если ЗначениеЗаполнено(ОснованиеСтороны) 
			И ТипЗнч(ОснованиеСтороны) = Тип("ТаблицаЗначений") Тогда
			
				Для каждого Строка Из ОснованиеСтороны Цикл
					НоваяСтрока = Стороны.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
				КонецЦикла;
			
		Иначе
			
			Если ЗначениеЗаполнено(Организация) Тогда
				НоваяСтрока = Стороны.Добавить();
				НоваяСтрока.Сторона = Организация;
			КонецЕсли;
			
			ОснованиеКонтрагент = Неопределено;
			ОснованиеЗаполнения.Свойство("Контрагент", ОснованиеКонтрагент);
			
			ОснованиеКонтактноеЛицо = Неопределено;
			ОснованиеЗаполнения.Свойство("КонтактноеЛицо", ОснованиеКонтактноеЛицо);
			
			ОснованиеПодписалОтКонтрагента = Неопределено; 
			ОснованиеЗаполнения.Свойство("ПодписалОтКонтрагента", ОснованиеПодписалОтКонтрагента);
			
			Если ЗначениеЗаполнено(ОснованиеКонтрагент)
				Или ЗначениеЗаполнено(ОснованиеКонтактноеЛицо)
				Или ЗначениеЗаполнено(ОснованиеПодписалОтКонтрагента) Тогда 
					НоваяСтрока = Стороны.Добавить();
					НоваяСтрока.Сторона = ОснованиеКонтрагент;
					НоваяСтрока.КонтактноеЛицо = ОснованиеКонтактноеЛицо;
					НоваяСтрока.Подписал = ОснованиеПодписалОтКонтрагента;
					
					НоваяСтрока = Контрагенты.Добавить();
					НоваяСтрока.Контрагент = ОснованиеКонтрагент;
					НоваяСтрока.КонтактноеЛицо = ОснованиеКонтактноеЛицо;
					НоваяСтрока.ПодписалОтКонтрагента = ОснованиеПодписалОтКонтрагента;
			КонецЕсли;
			
		КонецЕсли;
		
		СтруктураИменПередаваемыхРеквизитов = ОбменСКонтрагентамиДОСервер.ИменаПередаваемыхРеквизитов();
		
		Для Каждого КлючИмяПередаваемогоРеквизита Из СтруктураИменПередаваемыхРеквизитов Цикл
			ИмяПередаваемогоРеквизита = КлючИмяПередаваемогоРеквизита.Ключ;
			Если ОснованиеЗаполнения.Свойство(ИмяПередаваемогоРеквизита) 
				И ЗначениеЗаполнено(ОснованиеЗаполнения[ИмяПередаваемогоРеквизита]) Тогда
				Если Метаданные.Справочники.ВнутренниеДокументы.Реквизиты.Найти(ИмяПередаваемогоРеквизита) <> Неопределено Тогда
					ЭтотОбъект[ИмяПередаваемогоРеквизита] = ОснованиеЗаполнения[ИмяПередаваемогоРеквизита];
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(РегистрационныйНомер) И ЗначениеЗаполнено(ДатаРегистрации) Тогда 
		Если Не Делопроизводство.РегистрационныйНомерУникален(ЭтотОбъект) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Регистрационный номер не уникален!'"),
				ЭтотОбъект,
				"РегистрационныйНомер",, 
				Отказ);
		КонецЕсли;	
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСуммуВоВнутренних", Новый Структура("ВидВнутреннегоДокумента", ВидДокумента)) Тогда 
		Если ЗначениеЗаполнено(Сумма) Тогда 
			ПроверяемыеРеквизиты.Добавить("Валюта");
		КонецЕсли;	
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоАдресатам", Новый Структура("ВидВнутреннегоДокумента", ВидДокумента)) Тогда 
		ПроверяемыеРеквизиты.Добавить("Адресат");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам")
			И ПолучитьФункциональнуюОпцию("ИспользоватьВидыВнутреннихДокументов")
			И ЗначениеЗаполнено(ВидДокумента)
			И ОбщегоНазначения.СсылкаСуществует(ВидДокумента) Тогда
		НастройкиУчетаПоПроектам = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидДокумента,
			"ОбязательноУказаниеПроекта, КонтролироватьУникальностьДокументаВРамкахПроекта");
		Если НастройкиУчетаПоПроектам.ОбязательноУказаниеПроекта Тогда
			ПроверяемыеРеквизиты.Добавить("Проект");
		КонецЕсли;
		Если НастройкиУчетаПоПроектам.КонтролироватьУникальностьДокументаВРамкахПроекта
				И Не РаботаСПроектами.ДокументУникален(ЭтотОбъект) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Уже есть %1 с проектом %2. Документ данного вида должен быть уникален в рамках проекта'"),
						ВидДокумента,
						Проект),
				ЭтотОбъект,
				"Проект",,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("УчитыватьСрокДействияДокумента", Новый Структура("ВидВнутреннегоДокумента", ВидДокумента)) Тогда 
		
		Если ЗначениеЗаполнено(ДатаРегистрации) Тогда
			ПроверяемыеРеквизиты.Добавить("ДатаНачалаДействия");
			Если Не Бессрочный Тогда 
				ПроверяемыеРеквизиты.Добавить("ДатаОкончанияДействия");
				ПроверяемыеРеквизиты.Добавить("ПорядокПродления");
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) И ДатаНачалаДействия > ДатаОкончанияДействия Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Дата окончания действия меньше, чем дата начала.'"),
				ЭтотОбъект,
				"ДатаОкончанияДействия",, 
				Отказ);
		КонецЕсли;	
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоОрганизациям", Новый Структура("ВидВнутреннегоДокумента", ВидДокумента)) Тогда 
		Делопроизводство.ПроверитьЗаполнениеДела(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Дело) Тогда 
		
		Если (Ссылка.Дело <> Дело Или Ссылка.ВидДокумента <> ВидДокумента)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("ВидыДокументов", ВидДокумента, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы с видом %1.'"),
					Строка(ВидДокумента)),
				,
				"ДелоТекст",, 
				Отказ);
		КонецЕсли;
		
		Если (Ссылка.Дело <> Дело Или Ссылка.Контрагент <> Контрагент)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("Контрагенты", Контрагент, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы по контрагенту %1.'"),
					Строка(Контрагент)),
				,
				"ДелоТекст",, 
				Отказ);
		КонецЕсли;
		
		Если (Ссылка.Дело <> Дело Или Ссылка.ВопросДеятельности <> ВопросДеятельности)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("ВопросыДеятельности", ВопросДеятельности, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы по вопросу деятельности %1.'"),
					Строка(ВопросДеятельности)),
				,
				"ДелоТекст",, 
				Отказ);
		КонецЕсли;
		
	КонецЕсли;	
	
	Делопроизводство.ПроверкаСвязейПриИзмененииВидаДокумента(ЭтотОбъект, Отказ);
	
	Если ВидДокумента.ВестиУчетПоНоменклатуреДел Тогда
		Делопроизводство.ПроверитьСоответствиеНоменклатурыДел(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	//Проверка табличной части Стороны на задвоения
	КоличествоСторон = Стороны.Количество();
	Если КоличествоСторон > 1 Тогда
		Для Инд1 = 0 По КоличествоСторон - 2 Цикл
			Для Инд2 = Инд1 + 1 По КоличествоСторон - 1 Цикл
				Если Стороны[Инд1].Сторона = Стороны[Инд2].Сторона
					И Стороны[Инд1].Подписал = Стороны[Инд2].Подписал Тогда 
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Сторона ""%1"" указана дважды в списке сторон'"),
						Стороны[Инд2].Сторона);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект,
						"Стороны["+ Формат(Инд2, "ЧН=0; ЧГ=0") +"].Сторона",,Отказ);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

	Если ЗначениеЗаполнено(ВидДокумента) Тогда 
		
		РеквизитыВида = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидДокумента,
			"ОбязательноеУказаниеОтветственного, ВестиУчетСторон, ЯвляетсяЗаявкойНаОплату");
			
		Если РеквизитыВида.ОбязательноеУказаниеОтветственного И Не ЗначениеЗаполнено(Ответственный) Тогда
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У документа вида ""%1"" должен быть обязательно указан ответственный.'"),
					Строка(ВидДокумента)),
				ЭтотОбъект,
				"Ответственный",,
				Отказ);
				
		КонецЕсли;
		
		Если РеквизитыВида.ВестиУчетСторон Тогда
			РаботаСПодписямиДокументов.ПроверитьЗаполнениеСторон(ЭтотОбъект, Отказ);
			Индекс = ПроверяемыеРеквизиты.Найти("Контрагенты.Контрагент");
			ПроверяемыеРеквизиты.Удалить(Индекс);
			Если РеквизитыВида.ЯвляетсяЗаявкойНаОплату Тогда
				Индекс = ПроверяемыеРеквизиты.Найти("Стороны.Сторона");
				ПроверяемыеРеквизиты.Удалить(Индекс);
			КонецЕсли;
		КонецЕсли;
		
		Делопроизводство.ПроверитьЗаполнениеРеквизитовХранения(ЭтотОбъект, ПроверяемыеРеквизиты);
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("РаздельныйУчетДокументов") Тогда 
		ПроверяемыеРеквизиты.Добавить("ФормаДокумента");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		ПредыдущиеЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"РегистрационныйНомер, Ответственный, ПодписанЭП, ПометкаУдаления, ПодписанВсеми");
	Иначе
		ПредыдущиеЗначенияРеквизитов = Новый Структура;
		ПредыдущиеЗначенияРеквизитов.Вставить("РегистрационныйНомер", Неопределено);
		ПредыдущиеЗначенияРеквизитов.Вставить("Ответственный", Неопределено);
		ПредыдущиеЗначенияРеквизитов.Вставить("ПодписанЭП", Ложь);
		ПредыдущиеЗначенияРеквизитов.Вставить("ПометкаУдаления", Ложь);
		ПредыдущиеЗначенияРеквизитов.Вставить("ПодписанВсеми", Ложь);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПредыдущийРегистрационныйНомер",
		ПредыдущиеЗначенияРеквизитов.РегистрационныйНомер);
	ДополнительныеСвойства.Вставить("ПредыдущийОтветственный",
		ПредыдущиеЗначенияРеквизитов.Ответственный);
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьПодписанногоОбъекта = Ложь;
	Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
		ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
	КонецЕсли;	
	
	Если Не ПривилегированныйРежим() И ЗаписьПодписанногоОбъекта <> Истина Тогда
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			Если ПодписанЭП И ПредыдущиеЗначенияРеквизитов.ПодписанЭП Тогда
				// Проверяем ключевые поля - изменились ли
				МассивИмен = Справочники.ВнутренниеДокументы.ПолучитьИменаКлючевыхРеквизитов();
				РаботаСЭП.ПроверитьИзмененностьКлючевыхПолей(МассивИмен, ЭтотОбъект, Ссылка);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
	// Заполним Наименование по шаблону
	Если ЗначениеЗаполнено(Шаблон) Тогда 
		УстановитьПривилегированныйРежим(Истина);
		РеквизитыШаблона = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шаблон,
			"ЗаполнениеНаименованияПоШаблону, Заголовок");
		Если РеквизитыШаблона.ЗаполнениеНаименованияПоШаблону Тогда 
			ШаблонЗаголовка = РеквизитыШаблона.Заголовок;
			Заголовок = ШаблоныДокументов.СформироватьНаименованиеПоШаблону(
				ЭтотОбъект, ШаблонЗаголовка);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Наименование = Делопроизводство.НаименованиеДокумента(ЭтотОбъект);
	
	// Пометка на удаление приложенных файлов.
	Если ПометкаУдаления <> ПредыдущиеЗначенияРеквизитов.ПометкаУдаления Тогда 
		
		Если ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("НужноПометитьНаУдалениеБизнесСобытия", Истина);
		КонецЕсли;
		
		Если ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Ссылка).Удаление Тогда 
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У вас нет права ""Пометка на удаление"" документа ""%1"".'"),
				Строка(Ссылка));
		КонецЕсли;	
		
	КонецЕсли;
	
	РеквизитыВида = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидДокумента, 
		"ВестиУчетПоОрганизациям, ВестиУчетСторон, ВариантПодписания");
	
	// Сброс организации при смене вида.
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ВидДокумента) 
		И РеквизитыВида.ВестиУчетПоОрганизациям = Ложь Тогда
		Организация = Неопределено;
	КонецЕсли;
	
	// Работа со сторонами
	Если (ДополнительныеСвойства.Свойство("ВестиУчетСторон") И ДополнительныеСвойства.ВестиУчетСторон)
		Или (ЗначениеЗаполнено(ВидДокумента) 
			И РеквизитыВида.ВестиУчетСторон) Тогда
		РаботаСПодписямиДокументов.ПеренестиКонтрагентовИзСторон(Контрагенты, Стороны);
		РаботаСПодписямиДокументов.ПеренестиОрганизациюИзСторон(Организация, Стороны);
		РаботаСПодписямиДокументов.ПеренестиУтвердилИзСторон(Утвердил, Стороны);
		ПодписанВсеми = РаботаСПодписямиДокументов.ДокументПодписанСторонами(Стороны, РеквизитыВида.ВариантПодписания);
	Иначе
		ПодписанВсеми = Ложь;
	КонецЕсли;
	
	// Если изменился признак "ПодписанВсеми", значит нужно обновить состояние документа.
	Если ПодписанВсеми <> ПредыдущиеЗначенияРеквизитов.ПодписанВсеми Тогда 
		Если ПодписанВсеми Тогда
			ДополнительныеСвойства.Вставить("УстановитьСостояние", Перечисления.СостоянияДокументов.Подписан);
		Иначе 
			ДополнительныеСвойства.Вставить("УстановитьСостояние", Перечисления.СостоянияДокументов.НаПодписании);
		КонецЕсли;
	КонецЕсли;
	
	ПодписанУтвержден = Делопроизводство.СтрокаПодписалУтвердил(ЭтотОбъект);
	Делопроизводство.ЗаписатьДанныеДокумента(Ссылка, "ПодписанУтвержден", ПодписанУтвержден);
	
	Если Контрагенты.Количество() = 0 Тогда
		Контрагент = Неопределено;
		КонтактноеЛицо = Неопределено;
		ПодписалОтКонтрагента = Неопределено;
	Иначе
		Строка = Контрагенты[0];
		Контрагент = Строка.Контрагент;
		КонтактноеЛицо = Строка.КонтактноеЛицо;
		ПодписалОтКонтрагента = Строка.ПодписалОтКонтрагента;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Заполним дату начала дела, если не заполнена
	Если ЗначениеЗаполнено(Дело) И Не ЗначениеЗаполнено(Дело.ДатаНачала) И ЗначениеЗаполнено(ДатаРегистрации) Тогда 
		
		ЗаблокироватьДанныеДляРедактирования(Дело.Ссылка);
		ДелоОбъект = Дело.ПолучитьОбъект();
		ДелоОбъект.ДатаНачала = ДатаРегистрации;
		ДелоОбъект.Записать();	
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоступаКПерсональнымДанным") Тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить(
			"ИзменилсяСписокПерсональныхДанных", ПерсональныеДанные.ИзменилсяСписокПерсональныхДанных(ЭтотОбъект));
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		Если Не Ссылка.Пустая() Тогда 
			СсылкаПроект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Проект");
			ЭтотОбъект.ДополнительныеСвойства.Вставить("ИзменилсяПроект", СсылкаПроект <> Проект);
		КонецЕсли;	
	КонецЕсли;
	
	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.ВнутренниеДокументы.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			СсылкаОбъекта = СсылкаНового;
		КонецЕсли;
	КонецЕсли;
	
	// Определение дескрипторов для проверки прав при записи рабочей группы.
	Если ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		ДокументооборотПраваДоступа.ОпределитьДескрипторыОбъекта(ЭтотОбъект);
	КонецЕсли;
	
	// Подготовка рабочей группы
	РабочаяГруппа = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(СсылкаОбъекта);
	
	// Добавление автоматических участников из самого объекта
	Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(ЭтотОбъект) Тогда
		
		НовыеУчастникиРГ = РаботаСРабочимиГруппами.ПолучитьПустуюТаблицуУчастников();
		ДобавитьУчастниковРабочейГруппыВНабор(НовыеУчастникиРГ);
		РаботаСРабочимиГруппами.ЗаполнитьКолонкуИзменениеПоСтандартнымПравам(СсылкаОбъекта, НовыеУчастникиРГ);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НовыеУчастникиРГ, РабочаяГруппа);
		
	КонецЕсли;
	
	// Добавление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаДобавить") Тогда
		
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаДобавить Цикл
			
			// Добавление участника в итоговую рабочую группу
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = Эл.Участник;
			Строка.Изменение = Эл.Изменение;
			
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Удаление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаУдалить") Тогда
		
		Для Каждого Эл Из ДополнительныеСвойства.РабочаяГруппаУдалить Цикл
			
			// Поиск удаляемого участника в итоговой рабочей группе
			Для Каждого Эл2 Из РабочаяГруппа Цикл
				
				Если Эл2.Участник = Эл.Участник 
					И Эл2.Изменение = Эл.Изменение Тогда
					
					// Удаление участника из итоговой рабочей группы
					РабочаяГруппа.Удалить(Эл2);
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;	
				
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Обработка обязательного заполнения рабочих групп 
	Если РабочаяГруппа.Количество() = 0 Тогда
	
		Если РаботаСРабочимиГруппами.ОбязательноеЗаполнениеРабочихГруппДокументов(ВидДокумента) Тогда
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = ПользователиКлиентСервер.ТекущийПользователь();
			Строка.Изменение = Истина;
		КонецЕсли;
		
	КонецЕсли;		
	
	// Запись итоговой рабочей группы
	Если Не РаботаСРабочимиГруппами.ПерезаписьРабочейГруппыПредметаПроцессаОтключена(ЭтотОбъект) Тогда
		РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(
			СсылкаОбъекта,
			РабочаяГруппа,
			Ложь,	//ОбновитьПраваДоступа
			Пользователи.ТекущийПользователь());
	КонецЕсли;
	
	// Установка необходимости обновления прав доступа
	ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
	Если Сумма > 0 Тогда 
		СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Сумма, Валюта);
	КонецЕсли;
	
	Если СуммаНДС > 0 Тогда 
		СуммаНДСПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаНДС, Валюта);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЧисловойНомер > 0 Тогда
		СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(ЭтотОбъект);
		Нумерация.ОсвободитьНомер(СтруктураПараметров);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента);
		Иначе
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента);
		КонецЕсли;
		
		Делопроизводство.ЗарегистрироватьСобытиеНазначениеОтветственного(
			Ссылка,
			Ответственный,
			ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый,
			?(ДополнительныеСвойства.Свойство("ПредыдущийОтветственный"),
				ДополнительныеСвойства.ПредыдущийОтветственный,
				Неопределено));
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;
	
	// Установим состояние Подписания, если изменился признак "ПодписанВсеми".
	Если ДополнительныеСвойства.Свойство("УстановитьСостояние") Тогда
		Делопроизводство.ЗаписатьСостояниеДокумента(
			Ссылка, 
			ТекущаяДатаСеанса(), 
			ДополнительныеСвойства.УстановитьСостояние, 
			ПользователиКлиентСервер.ТекущийПользователь());
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ЗначениеЗаполнено(РегистрационныйНомер) И РегистрационныйНомер <> ДополнительныеСвойства.ПредыдущийРегистрационныйНомер Тогда
			Если ЗначениеЗаполнено(ДополнительныеСвойства.ПредыдущийРегистрационныйНомер) Тогда
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ПеререгистрацияВнутреннегоДокумента);	
			Иначе	
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.РегистрацияВнутреннегоДокумента);	
			КонецЕсли;			
		КонецЕсли;		
	КонецЕсли;		
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды")
		И ДополнительныеСвойства.Свойство("ЭтоНовый") 
		И ДополнительныеСвойства.ЭтоНовый Тогда
		
		Штрихкод = ШтрихкодированиеСервер.СформироватьШтрихКод();
		ШтрихкодированиеСервер.ПрисвоитьШтрихКод(Ссылка, Штрихкод);
		
	КонецЕсли;
	
	// Заполняем сведения о персональных данных во всех файлах
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоступаКПерсональнымДанным") Тогда
		
		Если Не ОбменДанными.Загрузка 
			И ЭтотОбъект.ДополнительныеСвойства.Свойство("ИзменилсяСписокПерсональныхДанных") 
			И ЭтотОбъект.ДополнительныеСвойства.ИзменилсяСписокПерсональныхДанных Тогда
			
			ПерсональныеДанные.ЗаполнитьПерсональныеДанныеФайлов(Ссылка);
			
		КонецЕсли;	
		
	КонецЕсли;
	
	// Заполнение проекта в файлах
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ИзменилсяПроект") 
		   И ЭтотОбъект.ДополнительныеСвойства.ИзменилсяПроект Тогда
			РаботаСПроектами.ЗаполнитьПроектПодчиненныхФайлов(Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	// обновить связи документа
	СвязиДокументов.ОбновитьСвязиДокумента(Ссылка);
	
КонецПроцедуры

// Изменяет срок действия документа, делает запись в РС ИсторияСроковДействияДокументов
// Параметры:
// - ПараметрыЗаписи (Структура)
//   - Документ
//   - ДатаНачалаДействия
//   - ДатаОкончанияДействия
//   - Бессрочный
//   - ПорядокПродления
//   - ДокументИсточникИзменения
//   - Комментарий
//
Процедура ИзменитьСрокДействия(ПараметрыЗаписи) Экспорт
	
	Если ПараметрыЗаписи.Документ <> ЭтотОбъект.Ссылка Тогда
		ВызватьИсключение НСтр("ru = 'Передан некорректный параметр <Документ>.'");
	КонецЕсли;
	
	ЗаблокироватьДанныеДляРедактирования(ЭтотОбъект.Ссылка);
	
	НачатьТранзакцию();
	Попытка
		СрокДействияПредыдущий = Новый Структура("ДатаНачалаДействия, ДатаОкончанияДействия, Бессрочный, ПорядокПродления");
		ЗаполнитьЗначенияСвойств(СрокДействияПредыдущий, ЭтотОбъект);
		РегистрыСведений.ИсторияСроковДействияДокументов.ДобавитьЗапись(ПараметрыЗаписи);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыЗаписи, "ДатаНачалаДействия, ДатаОкончанияДействия, Бессрочный, ПорядокПродления");
		Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СрокДействияПредыдущий);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		ВызватьИсключение;
	КонецПопытки
	
КонецПроцедуры

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		ИсходныеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"ВидДокумента, Ответственный, Зарегистрировал, Подготовил, Адресат, Создал, Подписал, ГрифыУтверждения, Стороны");
			
		Если ИсходныеРеквизиты.ВидДокумента = ВидДокумента Тогда
			ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты);
		Иначе
			ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		КонецЕсли;
		
	Иначе	
		
		ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты)
	
	// Добавление реквизита Ответственный
	Если ИсходныеРеквизиты.Ответственный <> Ответственный Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);
	КонецЕсли;
	
	// Добавление реквизита Зарегистрировал
	Если ИсходныеРеквизиты.Зарегистрировал <> Зарегистрировал Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);
	КонецЕсли;
	
	// Добавление реквизита Подготовил
	Если ИсходныеРеквизиты.Подготовил <> Подготовил Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил);
	КонецЕсли;
	
	// Добавление реквизита Подписал
	Если ИсходныеРеквизиты.Подписал <> Подписал Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подписал);
	КонецЕсли;
	
	// Добавление реквизита Адресат
	Если ИсходныеРеквизиты.Адресат <> Адресат Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Адресат);
	КонецЕсли;
	
	// Добавление реквизита Создал
	Если ИсходныеРеквизиты.Создал <> Создал Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Создал);
	КонецЕсли;
	
	// Добавление подписантов сторон
	Если ОбщегоНазначенияДокументооборотКлиентСервер.ЕстьОтличияВТаблицах(
			ИсходныеРеквизиты.Стороны.Выгрузить(), Стороны, "Подписал") Тогда
	
		ПодписантыСторон = РаботаСПодписямиДокументов.ПодписантыСторонДокумента(Стороны);
		Для каждого Подписант Из ПодписантыСторон Цикл
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
				ТаблицаНабора, 
				Подписант);
		КонецЦикла;
	КонецЕсли;
	
	// Добавление авторов утверждений
	Если ОбщегоНазначенияДокументооборотКлиентСервер.ЕстьОтличияВТаблицах(
			ИсходныеРеквизиты.ГрифыУтверждения.Выгрузить(), ГрифыУтверждения, "АвторУтверждения") Тогда
			
		АвторыУтверждения = РаботаСГрифамиУтверждений.АвторыУтвержденийДокумента(ГрифыУтверждения);
		Для каждого Автор Из АвторыУтверждения Цикл
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
				ТаблицаНабора, 
				Автор);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подписал);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Адресат);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Создал);
	
	ПодписантыСторон = РаботаСПодписямиДокументов.ПодписантыСторонДокумента(Стороны);
	Для каждого Подписант Из ПодписантыСторон Цикл
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
			ТаблицаНабора, 
			Подписант);
	КонецЦикла;
		
	АвторыУтверждения = РаботаСГрифамиУтверждений.АвторыУтвержденийДокумента(ГрифыУтверждения);
	Для каждого Автор Из АвторыУтверждения Цикл
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
			ТаблицаНабора, 
			Автор);
	КонецЦикла;
	
	Если Ссылка.Пустая() Тогда 
		Возврат;
	КонецЕсли;
	
	// Добавление авторов виз согласования
	АвторыВиз = Справочники.ВизыСогласования.ПолучитьМассивАвторовВизПоДокументу(Ссылка);
	Для каждого Автор Из АвторыВиз Цикл
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
			ТаблицаНабора, 
			Автор);
	КонецЦикла;
	
	// Добавление контролеров
	Контроль.ДобавитьКонтролеровВТаблицу(ТаблицаНабора, Ссылка);
	
КонецПроцедуры

#КонецЕсли