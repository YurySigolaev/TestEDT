
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриоритетОчереди = 2;
	ПриоритетОчередиСтрокой = "Долгая";
	КоличествоЭлементовКаждогоТипа = 10;
	КоличествоТиповДляАнализа = 1000;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПрогнозВремениОбработкиОчереди(Команда)
	
	ТекстСостояния = НСтр("ru = 'Выполняется анализ скорости расчета очереди'");
	Состояние(ТекстСостояния);
	
	СформироватьПрогнозВремениОбработкиОчередиНаСервере();
	
	ТекстСостояния = НСтр("ru = 'Анализ завершен'");
	Состояние(ТекстСостояния);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПрогнозВремениОбработкиОчередиНаСервере()
	
	СтарыйПриоритетОчередиОбновленияПрав = ПараметрыСеанса.ПриоритетОчередиОбновленияПрав;
	ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = ПриоритетОчереди;
	
	Попытка
		
		ТабРезультата = РеквизитФормыВЗначение("ТаблицаРезультата", Тип("ТаблицаЗначений"));
		ТабРезультата.Очистить();
		
		ЗапросПоТипам = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ %КоличествоЗаписей
		|	КОЛИЧЕСТВО(ОчередьОбновленияПравДоступа.Объект) КАК КолЗаписей,
		|	ТИПЗНАЧЕНИЯ(ОчередьОбновленияПравДоступа.Объект) КАК Тип,
		|	ОчередьОбновленияПравДоступа.ОбновлениеЗависимыхПрав,
		|	ЕСТЬNULL(ДескрипторыДоступаОбъектов.ИдентификаторОбъектаМетаданных, НЕОПРЕДЕЛЕНО) КАК ИдентификаторОбъектаМетаданных
		|ИЗ
		|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДескрипторыДоступаОбъектов КАК ДескрипторыДоступаОбъектов
		|		ПО ОчередьОбновленияПравДоступа.Объект = ДескрипторыДоступаОбъектов.Ссылка
		|ГДЕ
		|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет
		|
		|СГРУППИРОВАТЬ ПО
		|	ОчередьОбновленияПравДоступа.ОбновлениеЗависимыхПрав,
		|	ТИПЗНАЧЕНИЯ(ОчередьОбновленияПравДоступа.Объект),
		|	ДескрипторыДоступаОбъектов.ИдентификаторОбъектаМетаданных
		|
		|УПОРЯДОЧИТЬ ПО
		|	КолЗаписей УБЫВ");
		
		ЗапросПоТипам.Текст = СтрЗаменить(ЗапросПоТипам.Текст, "%КоличествоЗаписей", 
		Формат(КоличествоТиповДляАнализа, "ЧГ="));
		
		ЗапросПоТипам.УстановитьПараметр("Приоритет", ПриоритетОчереди);
		
		ТекстЗапросаПоЭлементам =
		"ВЫБРАТЬ ПЕРВЫЕ %КоличествоЗаписей
		|	ОчередьОбновленияПравДоступа.Объект,
		|	ОчередьОбновленияПравДоступа.ОбновлениеЗависимыхПрав,
		|	ОчередьОбновленияПравДоступа.ДопСведения
		|ИЗ
		|	РегистрСведений.ОчередьОбновленияПравДоступа КАК ОчередьОбновленияПравДоступа
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДескрипторыДоступаОбъектов КАК ДескрипторыДоступаОбъектов
		|		ПО ОчередьОбновленияПравДоступа.Объект = ДескрипторыДоступаОбъектов.Ссылка
		|ГДЕ
		|	ОчередьОбновленияПравДоступа.Приоритет = &Приоритет
		|	И ТИПЗНАЧЕНИЯ(ОчередьОбновленияПравДоступа.Объект) = &Тип
		|	И ОчередьОбновленияПравДоступа.ОбновлениеЗависимыхПрав = &ОбновлениеЗависимыхПрав
		|	И ЕСТЬNULL(ДескрипторыДоступаОбъектов.ИдентификаторОбъектаМетаданных, &ИОМ) = &ИОМ";
		
		РезультатЗапроса = ЗапросПоТипам.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Сообщить(НСтр("ru = 'Очередь не содержит элементов'"));
		КонецЕсли;
		
		ВыборкаПоТипам = РезультатЗапроса.Выбрать();
		Пока ВыборкаПоТипам.Следующий() Цикл
			
			ЗапросПоЭлементам = Новый Запрос(СтрЗаменить(
				ТекстЗапросаПоЭлементам, "%КоличествоЗаписей", 
				Мин(ВыборкаПоТипам.КолЗаписей, КоличествоЭлементовКаждогоТипа)));
			
			ЗапросПоЭлементам.УстановитьПараметр("Приоритет", ПриоритетОчереди);
			ЗапросПоЭлементам.УстановитьПараметр("Тип", ВыборкаПоТипам.Тип);
			ЗапросПоЭлементам.УстановитьПараметр("ИОМ", ВыборкаПоТипам.ИдентификаторОбъектаМетаданных);
			ЗапросПоЭлементам.УстановитьПараметр("ОбновлениеЗависимыхПрав", ВыборкаПоТипам.ОбновлениеЗависимыхПрав);
			
			Выборка = ЗапросПоЭлементам.Выполнить().Выбрать();
			ПродолжительностьРасчета = 0;
			Пока Выборка.Следующий() Цикл
				
				НачатьТранзакцию();
				Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
				
				ОбработанныеВТекущейИтерации = Новый Соответствие;
				РегистрыСведений.ОчередьОбновленияПравДоступа.ОбработатьЭлементОчереди(Выборка.Объект,
					Выборка.ОбновлениеЗависимыхПрав, Выборка.ДопСведения, ОбработанныеВТекущейИтерации);
				
				Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
				ОтменитьТранзакцию();
				
				ОбработаноЭлементов = ОбработанныеВТекущейИтерации.Количество();
				Если ОбработаноЭлементов = 0 Тогда
					ОбработаноЭлементов = 1;
				КонецЕсли;
				
				ПродолжительностьРасчета = ПродолжительностьРасчета + (Конец - Начало) / ОбработаноЭлементов;
				
			КонецЦикла;
			
			КоличествоРасчитанныхЭлементов = Выборка.Количество();
			Если КоличествоРасчитанныхЭлементов = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаРезультата = ТабРезультата.Добавить();
			
			Если ВыборкаПоТипам.Тип = Тип("СправочникСсылка.ДескрипторыДоступаОбъектов") Тогда
				СтрокаРезультата.ТипЭлемента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Дескриптор объекта (%1)'"),
				ВыборкаПоТипам.ИдентификаторОбъектаМетаданных.Имя);
			Иначе
				СтрокаРезультата.ТипЭлемента = ВыборкаПоТипам.Тип;
			КонецЕсли;
			
			СтрокаРезультата.ОбновлениеЗависимых = ВыборкаПоТипам.ОбновлениеЗависимыхПрав;
			СтрокаРезультата.КоличествоВОчереди = ВыборкаПоТипам.КолЗаписей;
			СтрокаРезультата.СреднееВремяРасчета = ПродолжительностьРасчета / КоличествоРасчитанныхЭлементов;
			СтрокаРезультата.Прогноз = ПродолжительностьРасчета * ВыборкаПоТипам.КолЗаписей / КоличествоРасчитанныхЭлементов;
			
		КонецЦикла;
		
		ТабРезультата.Сортировать("Прогноз Убыв");
		ЗначениеВРеквизитФормы(ТабРезультата, "ТаблицаРезультата");
		
		Элементы.ТаблицаРезультатаПрогноз.ТекстПодвала = "" + Окр(ТабРезультата.Итог("Прогноз") / 1000 / 60, 2) + " мин.";
		Элементы.ТаблицаРезультатаКоличествоВОчереди.ТекстПодвала = ТабРезультата.Итог("КоличествоВОчереди");
		
	Исключение
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = СтарыйПриоритетОчередиОбновленияПрав;
		ВызватьИсключение;
		
	КонецПопытки;
	
	ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = СтарыйПриоритетОчередиОбновленияПрав;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриоритетОчередиСтрокойПриИзменении(Элемент)
	
	ПриоритетОчереди = ?(ПриоритетОчередиСтрокой = "Оперативная", 1, 2);
	
КонецПроцедуры
