
#Область СлужебныеПроцедурыИФункции	

&НаСервере
Процедура ЗаполнитьСписокВидовНО()

	// Заполняем список видов регламентированной отчетности по обнаруженным
	// в информационной базе сохраненным документам РегламентированныйОтчет.

	// Используем механизм запросов.
	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегламентированныйОтчет.КодНалоговогоОргана КАК КодНалоговогоОргана
	|ИЗ
	|	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодНалоговогоОргана";

	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗапроса   = РезультатЗапроса.Выгрузить();
	ТаблицаЗапроса.Свернуть("КодНалоговогоОргана");
	МассивЗначений   = ТаблицаЗапроса.ВыгрузитьКолонку("КодНалоговогоОргана");

	// заполняем список выбора
	Элементы.СписокВидовНО.СписокВыбора.ЗагрузитьЗначения(МассивЗначений);
	
КонецПроцедуры  

&НаСервере
Процедура УстановитьОтборПоВидуОтчета(ВидОтчета)
	
	Перем ОтборИсточникОтчета;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсточникОтчета") Тогда
			ОтборИсточникОтчета = Элемент;
		КонецЕсли;
				
	КонецЦикла;
	
	Если ОтборИсточникОтчета = Неопределено Тогда
		ОтборИсточникОтчета = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборИсточникОтчета.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИсточникОтчета");
	КонецЕсли;
				
	ОтборИсточникОтчета.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборИсточникОтчета.ПравоеЗначение = ВидОтчета.ИсточникОтчета;
		
	Если ПустаяСтрока(ВидОтчета.ИсточникОтчета) Тогда
		ОтборИсточникОтчета.Использование = Ложь;
	Иначе
		ОтборИсточникОтчета.Использование = Истина;
	КонецЕсли;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
	СохранитьНастройки();
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОрганизации()
	
	Перем ОтборОрганизация;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
			ОтборОрганизация = Элемент;
		КонецЕсли;
				
	КонецЦикла;
	
	Если ОтборОрганизация = Неопределено Тогда
		ОтборОрганизация = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборОрганизация.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	КонецЕсли;
				
	ОтборОрганизация.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОрганизация.ПравоеЗначение = Организация;
		
	ОтборОрганизация.Использование = Истина;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
	СохранитьНастройки();
			
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере()
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиФильтров = ХранилищеНастроекДанныхФорм.Загрузить("Документ.РегламентированныйОтчет.Форма.ФормаСписка", "НастройкиФильтров");
	мНазвФормыФильтра = "";

	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	ОсновнаяОрганизация = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	Если НЕ УчетПоВсемОрганизациям Тогда
        		
		Организация = ОсновнаяОрганизация;
		Элементы.Организация.Доступность = Ложь;

	Иначе

		// Если включен учет по всем организациям
		Организация = ?(НастройкиФильтров = Неопределено, ОсновнаяОрганизация, НастройкиФильтров.Организация);

		Если (НастройкиФильтров = Неопределено) И (Организация <> РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа("СправочникСсылка.Организации")) Тогда
					
			РегламентированнаяОтчетность.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));
			СоставФильтраОбособленныеПодразделения();

		КонецЕсли;
        		
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			
		Организация = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
			
	КонецЕсли;

	Если НастройкиФильтров = Неопределено Тогда

		// в случае первого раза, устанавливаем фильтр по датам
		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -1));
		ДатаНачалаПериодаОтчета = НачалоМесяца(ДатаКонцаПериодаОтчета);
		
		ПоказатьПериод();
		ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц;
		УстановитьОтборПоПериоду();
				
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы["ГруппаСтандартныйПериод"];
		
	ИначеЕсли НастройкиФильтров <> Неопределено Тогда

		// *** восстанавливаем ****************
		мНазвФормыФильтра = "";

		ДатаНачалаПериодаОтчета = НастройкиФильтров.ДатаНач;
		ДатаКонцаПериодаОтчета = НастройкиФильтров.ДатаКон;

		ПолеВыбораПериодичность = НастройкиФильтров.Периодичность;

		Если (ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц)
		Или (ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал) Тогда  // ежеквартально

			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтандартныйПериод;
			
			ПоказатьПериод();

		Иначе
			
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПроизвольныйПериод;

		КонецЕсли;
        		
		// Если вызвано из справочника, то фильтр установит та форма которая вызвала
		// в этом случае не восстанавливаем свой фильтр
		// Восстановим его только когда форма списка документов будет открыта напрямую

		Если мРежимРаботы <> "ВызваноИзСправочника" Тогда

			ИсточникОтчетаДляОтбора = НастройкиФильтров.ОтчетнаяФормаЗначение;
			НаименованиеОтчетаДляОтбора = НастройкиФильтров.ОтчетнаяФормаПредставление;
			
			ДанныеОтчета = Новый СписокЗначений;
			ДанныеОтчета.Добавить(ИсточникОтчетаДляОтбора, НаименованиеОтчетаДляОтбора);
			
			РеглОтч = ИсточникОтчетаДляОтбора;
			
			Если ЗначениеЗаполнено(РеглОтч) Тогда
				УстановитьОтборПоВидуОтчета(РеглОтч);
			КонецЕсли;
			
		Иначе

			мНазвФормыФильтра = РеглОтч;

		КонецЕсли;
		
		СписокИФНС = Новый СписокЗначений;
		СписокИФНС.Добавить(?(НастройкиФильтров.Свойство("НалоговыйОрганЗначение"),
			НастройкиФильтров.НалоговыйОрганЗначение, "    "));
		
		Элементы.СписокВидовНО.СписокВыбора.ЗагрузитьЗначения(СписокИФНС.ВыгрузитьЗначения());
		СписокВидовНО = ?(НастройкиФильтров.Свойство("НалоговыйОрганЗначение"),
			НастройкиФильтров.НалоговыйОрганЗначение, "    ");

		Если ЗначениеЗаполнено(СписокВидовНО) Тогда
			УстановитьОтборПоВидуНО();
		КонецЕсли;
		
	КонецЕсли;

	Если мРежимРаботы = Неопределено Тогда
		мРежимРаботы = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		УстановитьОтборПоОрганизации();
	КонецЕсли;
				
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц,   "Ежемесячно");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал, "Ежеквартально");
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить("Произвольный", "Произвольный");
	
	ЗаполнитьСписокВидовНО();
	
	УстановитьОтборПоПериоду();

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	Перем ОтборПериодичность;
	Перем ОтборДатаОкончания;
	Перем ОтборДатаОкончания2;
		
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		          	
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Периодичность") Тогда
			ОтборПериодичность = Элемент;
		ИначеЕсли Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания")
			    И (Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно
				ИЛИ Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно) Тогда
			ОтборДатаОкончания = Элемент;
		ИначеЕсли Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания")
			    И Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
			ОтборДатаОкончания2 = Элемент;	
		КонецЕсли;
				
	КонецЦикла;
	
	Если ОтборПериодичность = Неопределено Тогда
		ОтборПериодичность = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПериодичность.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Периодичность");
	КонецЕсли;
		
	Если ОтборДатаОкончания = Неопределено Тогда
		ОтборДатаОкончания = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборДатаОкончания.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	КонецЕсли;
	
	Если ОтборДатаОкончания2 = Неопределено Тогда
		ОтборДатаОкончания2 = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборДатаОкончания2.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	КонецЕсли;
		
	ОтборПериодичность.Использование = Истина;
	ОтборПериодичность.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		
	ОтборДатаОкончания.Использование = Истина;
	ОтборДатаОкончания.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	    	
	ОтборДатаОкончания2.Использование = Ложь;
	ОтборДатаОкончания2.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			
	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц Тогда
	// При такой установке отбора в журнал попадают отчеты, у которых периодичность - ежемесячно,
	// а дата конца периода составления отчета совпадает с датой конца указанного периода отбора.
		ОтборПериодичность.ПравоеЗначение = Перечисления.Периодичность.Месяц;
		ОтборДатаОкончания.ПравоеЗначение = ДатаКонцаПериодаОтчета;
	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда
		ОтборПериодичность.Использование = Ложь;
		ОтборДатаОкончания.ПравоеЗначение = ДатаКонцаПериодаОтчета;
	Иначе
		ОтборПериодичность.Использование = Ложь;
		
		ОтборДатаОкончания.ПравоеЗначение = ДатаНачалаПериодаОтчета;
		ОтборДатаОкончания.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		
		ОтборДатаОкончания2.ПравоеЗначение = ДатаКонцаПериодаОтчета;
				
		ОтборДатаОкончания.Использование = Истина;
		ОтборДатаОкончания2.Использование = Истина;
	КонецЕсли;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
			
КонецПроцедуры

&НаКлиенте
Процедура ИсточникОтчетаПриИзменении(Элемент)
	
	мНазвФормыФильтра = Элементы.СписокВидовОтчета.ВыделенныйТекст;
	
	УстановитьОтборПоВидуОтчета(РеглОтч);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	НастройкиФильтров = Новый Структура;
	
	НастройкиФильтров.Вставить("ДатаНач", ДатаНачалаПериодаОтчета);
	НастройкиФильтров.Вставить("ДатаКон", ДатаКонцаПериодаОтчета);
	
	НастройкиФильтров.Вставить("Организация", Организация);
	
	Если (мНазвФормыФильтра = Неопределено) Или НЕ ЗначениеЗаполнено(мНазвФормыФильтра)
	   И (Элементы.СписокВидовОтчета.СписокВыбора.Количество() > 0) Тогда
		
		мНазвФормыФильтра = Элементы.СписокВидовОтчета.СписокВыбора[0].Представление;
		
	КонецЕсли;
	
	НастройкиФильтров.Вставить("ОтчетнаяФормаПредставление", мНазвФормыФильтра);
	
	НастройкиФильтров.Вставить("ОтчетнаяФормаЗначение", РеглОтч);
			
	НастройкиФильтров.Вставить("НалоговыйОрганЗначение", ?(СписокВидовНО = Неопределено, "    ", СписокВидовНО));
		
	НастройкиФильтров.Вставить("Периодичность", ПолеВыбораПериодичность);

	ХранилищеНастроекДанныхФорм.Сохранить("Документ.РегламентированныйОтчет.Форма.ФормаСписка", "НастройкиФильтров", НастройкиФильтров);
		
КонецПроцедуры

&НаСервере
Процедура СоставФильтраОбособленныеПодразделения()

	РегламентированнаяОтчетность.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));

КонецПроцедуры

&НаКлиенте
Процедура НастроитьПериод(Команда)
			
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = ДатаНачалаПериодаОтчета;
	Диалог.Период.ДатаОкончания = ДатаКонцаПериодаОтчета;
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьПериодЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПериодЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Период <> Неопределено Тогда
		
		ДатаНачалаПериодаОтчета = Период.ДатаНачала;
		ДатаКонцаПериодаОтчета  = Период.ДатаОкончания;
		
		УстановитьОтборПоПериоду();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналВыгрузки(Команда)
			
	ОткрытьФорму("Документ.ВыгрузкаРегламентированныхОтчетов.Форма.ФормаСписка", , ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(1);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьПериод(Шаг)

	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда  // ежеквартально

		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(ДатаКонцаПериодаОтчета, 3*Шаг)); 
		ДатаНачалаПериодаОтчета = НачалоКвартала(ДатаКонцаПериодаОтчета);

	Иначе
		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(ДатаКонцаПериодаОтчета, Шаг)); 
		ДатаНачалаПериодаОтчета = НачалоМесяца(ДатаКонцаПериодаОтчета);
	КонецЕсли;

	ПоказатьПериод();

	УстановитьОтборПоПериоду();

	СохранитьНастройки();
	
КонецПроцедуры

&НаСервере
Процедура ОперацииПриСменеПериодичности()
		
	Если ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал Тогда  // ежеквартально
		
		ДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		ДатаНачалаПериодаОтчета = НачалоКвартала(ДатаКонцаПериодаОтчета);
				
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы["ГруппаСтандартныйПериод"];

	ИначеЕсли ПолеВыбораПериодичность = Перечисления.Периодичность.Месяц Тогда  // ежеквартально

		ДатаКонцаПериодаОтчета  = КонецМесяца(ДатаКонцаПериодаОтчета);
		ДатаНачалаПериодаОтчета = НачалоМесяца(ДатаКонцаПериодаОтчета);

		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы["ГруппаСтандартныйПериод"];
		
	ИначеЕсли ЗначениеЗаполнено(ПолеВыбораПериодичность) Тогда
			
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы["ГруппаПроизвольныйПериод"];
			
	Иначе
			
		Элементы.ГруппаСтраницы.ТекущаяСтраница.Доступность = Ложь;
			
		Возврат;
		
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница.Доступность = Истина;

	ИзменитьПериод(0);
	ПоказатьПериод();
	
	СохранитьНастройки();

КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораПериодичностьПриИзменении(Элемент)

	ОперацииПриСменеПериодичности();

КонецПроцедуры

&НаСервере
Процедура ПоказатьПериод()

	СтрПериодОтчета = ПредставлениеПериода( НачалоДня(ДатаНачалаПериодаОтчета), КонецДня(ДатаКонцаПериодаОтчета), "ФП = Истина" );

	// Покажем период в диалоге
	Элементы.НадписьПериодСоставленияОтчета.Заголовок = СтрПериодОтчета;

КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаОтчетаПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаКонцаПериодаОтчетаПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоВидуНО()
	
	Перем ОтборКодНалоговогоОргана;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КодНалоговогоОргана") Тогда
			ОтборКодНалоговогоОргана = Элемент;
		КонецЕсли;
				
	КонецЦикла;
	
	Если ОтборКодНалоговогоОргана = Неопределено Тогда
		ОтборКодНалоговогоОргана = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборКодНалоговогоОргана.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КодНалоговогоОргана");
	КонецЕсли;
				
	ОтборКодНалоговогоОргана.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборКодНалоговогоОргана.ПравоеЗначение = СписокВидовНО;
	ОтборКодНалоговогоОргана.Использование = Истина;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВыбораПериодичностьОчистка(Элемент, СтандартнаяОбработка)
	
	ПолеВыбораПериодичностьОчисткаНаСервере();
			
КонецПроцедуры

&НаСервере
Процедура ПолеВыбораПериодичностьОчисткаНаСервере()
	
	Перем ОтборПериодичность;
	Перем ОтборДатаОкончания;
	Перем ОтборДатаОкончания2;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Периодичность") Тогда
			ОтборПериодичность = Элемент;
		ИначеЕсли Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания")
			    И (Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно
				ИЛИ Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно) Тогда
			ОтборДатаОкончания = Элемент;
		ИначеЕсли Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания")
			    И Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
			ОтборДатаОкончания2 = Элемент;	
		КонецЕсли;
				
	КонецЦикла;
	
	Если НЕ ОтборПериодичность = Неопределено Тогда
		ОтборДинамическогоСписка.Элементы.Удалить(ОтборПериодичность);
	КонецЕсли;
	
	Если НЕ ОтборДатаОкончания = Неопределено Тогда
		ОтборДинамическогоСписка.Элементы.Удалить(ОтборДатаОкончания);
	КонецЕсли;
	
	Если НЕ ОтборДатаОкончания2 = Неопределено Тогда
		ОтборДинамическогоСписка.Элементы.Удалить(ОтборДатаОкончания2);
	КонецЕсли;	
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяФормыОбъектаПоУмолчанию(Ссылка)
	
	Возврат Ссылка.Метаданные().ПолноеИмя() + ".ФормаОбъекта";
	
КонецФункции

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если НЕ Копирование Тогда
		
		ДобавлениеОтчетаВЖурналеОтчетов();
		
	Иначе
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
				
		Если ТекущиеДанные <> Неопределено Тогда
			
			Ссылка = ТекущиеДанные.Ссылка;
			ПараметрыФормы = Новый Структура("ЗначениеКопирования", Ссылка); 
			
			Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ЭлектронныеПредставленияРегламентированныхОтчетов") Тогда
				
				ОткрытьФорму("Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов.ФормаОбъекта", ПараметрыФормы);
				
			ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
				
				ОткрытьФорму("Документ.РегламентированныйОтчет.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
				
			Иначе
				
				ИмяФормыОбъекта = ИмяФормыОбъектаПоУмолчанию(Ссылка);
				ОткрытьФорму(ИмяФормыОбъекта, ПараметрыФормы);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеОтчетаВЖурналеОтчетов()
	
	ФормаВыбораОтчета = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ФормаВыбораВидаОтчета", , ЭтаФорма);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеОтчетаВЖурналеОтчетовЗавершение", ЭтотОбъект);
	ФормаВыбораОтчета.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
	ФормаВыбораОтчета.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаВыбораОтчета.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеОтчетаВЖурналеОтчетовЗавершение(ВыбранныйВидОтчета, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбранныйВидОтчета) Тогда
		ОткрытьФормуОтчетаНаКлиенте(ВыбранныйВидОтчета);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчетаНаКлиенте(Отчет)
	
	ОрганизацияОтчета          = Неопределено;
	ДатаНачалаПериодаОтчета    = Неопределено;
	ДатаОкончанияПериодаОтчета = Неопределено;
	ПериодичностьОтчета        = Неопределено;
	
	НаименованиеОтчета = "";
	
	РезультатОткрытияФормыНаСервере = ОткрытьФормуОтчетаНаСервере(Отчет, ОрганизацияОтчета, ДатаНачалаПериодаОтчета, 
																ДатаОкончанияПериодаОтчета, ПериодичностьОтчета, НаименованиеОтчета);
			
	ФормаОткрытаУспешно = Истина;
		
	Если РезультатОткрытияФормыНаСервере = "Недостаточно прав" Тогда

		ПоказатьПредупреждение(,НСтр("ru='Недостаточно прав.'"));
		ФормаОткрытаУспешно = Ложь;
				
	ИначеЕсли РезультатОткрытияФормыНаСервере = "Отчет не найден" Тогда
				
		ПоказатьПредупреждение(,НСтр("ru='Отчет не найден.'"));
		ФормаОткрытаУспешно = Ложь;
				
	ИначеЕсли РезультатОткрытияФормыНаСервере = "Не удалось открыть отчет" Тогда
				
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не удалось открыть отчет.'");
		Сообщение.Сообщить();
		
		ФормаОткрытаУспешно = Ложь;
		
	ИначеЕсли РезультатОткрытияФормыНаСервере = "Открыть внутренний отчет-документ" Тогда
		
		Если Отчет.ИсточникОтчета = "РегламентированныйОтчетРСВ1" Тогда
			
			ИмяФормыОтчета = "Документ." + Отчет.ИсточникОтчета + ".Форма." + РегламентированнаяОтчетностьКлиентСерверПереопределяемый.ИмяОсновнойФормыРСВ1();
						
		Иначе
			
			ИмяФормыОтчета = "Документ." + Отчет.ИсточникОтчета + ".Форма.ОсновнаяФорма";
						
		КонецЕсли;
			
	ИначеЕсли ТипЗнч(РезультатОткрытияФормыНаСервере) = Тип("Структура") Тогда
		
		Если Отчет.ИсточникОтчета = "РегламентированныйОтчетРСВ1" Тогда
			
			ИмяФормыОтчета = "Отчет." + Отчет.ИсточникОтчета + ".Форма." + РегламентированнаяОтчетностьКлиентСерверПереопределяемый.ИмяОсновнойФормыРСВ1();
			
		Иначе
			
			ИмяФормыОтчета = "Отчет." + Отчет.ИсточникОтчета + ".Форма.ОсновнаяФорма";
			
		КонецЕсли;
	КонецЕсли;
	
	Если ФормаОткрытаУспешно Тогда
		
		// Сначала попробуем найти его среди открытых стартовых форм.
		// Необходимо для предотвращения
		// открытия нескольких стартовых форм одного отчета.
		НайденоОкно = Ложь;
		РегламентированнаяОтчетностьКлиент.ВебКлиентНайтиАктивизироватьОкно(ИмяФормыОтчета,ЭтаФорма,НайденоОкно);
		Если НайденоОкно <> Неопределено Тогда
			Если НайденоОкно Тогда
				
				Возврат;
				
			КонецЕсли;
		КонецЕсли;
	
		Если ТипЗнч(РезультатОткрытияФормыНаСервере) = Тип("Структура") Тогда
			
			ОткрытьФорму(ИмяФормыОтчета, РезультатОткрытияФормыНаСервере, ЭтаФорма, ИмяФормыОтчета, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			РезультатОткрытияФормыНаСервере.Удалить("ВнешнийОтчетИспользовать");
			
		Иначе
			
			ОткрытьФорму(ИмяФормыОтчета, , ЭтаФорма, ИмяФормыОтчета, , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОткрытьФормуОтчетаНаСервере(Знач Отчет, ОрганизацияОтчета, ДатаНачалаПериодаОтчета, 
				                    ДатаОкончанияПериодаОтчета, ПериодичностьОтчета, НаименованиеОтчета)
	
	ИсточникОтчета = Отчет.ИсточникОтчета;
	
	НаименованиеИзСправочника = Отчет.Наименование;
	МетаОтчет = Метаданные.Отчеты.Найти(ИсточникОтчета);
	Если МетаОтчет <> Неопределено И МетаОтчет.ОсновнаяФорма <> Неопределено Тогда
		
		НаименованиеОтчета = МетаОтчет.ОсновнаяФорма.Синоним;
		
	Иначе
		
		НаименованиеОтчета = НаименованиеИзСправочника;
		
	КонецЕсли;

	
	ПравоДоступаКОтчету = РегламентированнаяОтчетностьВызовСервера.ПравоДоступаКРегламентированномуОтчету(ИсточникОтчета);
	
	Если ПравоДоступаКОтчету = Ложь Тогда
		Возврат "Недостаточно прав";
	ИначеЕсли ПравоДоступаКОтчету = Неопределено Тогда
		Возврат "Отчет не найден";
	КонецЕсли;
		
	Если Метаданные.Документы.Найти(ИсточникОтчета) <> Неопределено Тогда // это внутренний отчет-документ
		Возврат "Открыть внутренний отчет-документ";
	КонецЕсли;
	
	ТекОтчет = РегламентированнаяОтчетность.РеглОтчеты(ИсточникОтчета);
	Если ТекОтчет = Неопределено Тогда
		Возврат "Не удалось открыть отчет";
	КонецЕсли;
	
	ТекФорма = РегламентированнаяОтчетность.ФормаРеглОтчета(ИсточникОтчета);
	Если ТекФорма = Неопределено Тогда
		Возврат "Не удалось открыть отчет";
	КонецЕсли;
	
	ПараметрыТекФормы = Новый Структура;
	ПараметрыТекФормы.Вставить("Организация");
	ПараметрыТекФормы.Вставить("мДатаНачалаПериодаОтчета");
	ПараметрыТекФормы.Вставить("мДатаКонцаПериодаОтчета");
	ПараметрыТекФормы.Вставить("мПериодичность");
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Попытка
			ПараметрыТекФормы.Организация = Организация;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	ПараметрыТекФормы.Вставить("ИсточникОтчета", ИсточникОтчета);
		
	Возврат ПараметрыТекФормы;
	
КонецФункции

&НаКлиенте
Процедура СписокВидовНООчистка(Элемент, СтандартнаяОбработка)
	
	СписокВидовНООчисткаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СписокВидовНООчисткаНаСервере()
	
	Перем ОтборКодНалоговогоОргана;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КодНалоговогоОргана") Тогда
			ОтборКодНалоговогоОргана = Элемент;
		КонецЕсли;
				
	КонецЦикла;
	
	Если НЕ ОтборКодНалоговогоОргана = Неопределено Тогда
		ОтборДинамическогоСписка.Элементы.Удалить(ОтборКодНалоговогоОргана);
	КонецЕсли;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовНООбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВидовНО = ВыбранноеЗначение;
	
	УстановитьОтборПоВидуНО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	ОрганизацияОчисткаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОчисткаНаСервере()
	
	Перем ОтборОрганизация;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
						
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
			ОтборОрганизация = Элемент;
		КонецЕсли;
				
	КонецЦикла;
	
	Если НЕ ОтборОрганизация = Неопределено Тогда
		ОтборДинамическогоСписка.Элементы.Удалить(ОтборОрганизация);
	КонецЕсли;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
			
	Очистка = Истина;
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ Очистка Тогда
		УстановитьОтборПоОрганизации();
	Иначе
		Очистка = Ложь;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти