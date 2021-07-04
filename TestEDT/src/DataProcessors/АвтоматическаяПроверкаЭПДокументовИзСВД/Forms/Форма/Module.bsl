////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьЭП = Константы.ИспользоватьЭлектронныеПодписи.Получить();
	Если Не ИспользоватьЭП Тогда
		Возврат;
	КонецЕсли;
	ВыполнятьПроверкуЭПНаСервере = ЭлектроннаяПодпись.ПроверятьЭлектронныеПодписиНаСервере();
	Если ВыполнятьПроверкуЭПНаСервере Тогда
		Возврат;
	КонецЕсли;
	
	ВключеноИзвлечениеТекста = Ложь;
	
	ИнтервалВремениВыполнения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическаяПроверкаЭПДокументовИзСВД", "ИнтервалВремениВыполнения");
	Если ИнтервалВремениВыполнения = 0 Тогда
		ИнтервалВремениВыполнения = 60;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическаяПроверкаЭПДокументовИзСВД", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	КонецЕсли;	
	
	КоличествоНепроверенныхДокументов = ПолучитьКоличествоНепроверенныхДокументов();
	
	КоличествоДокументовВПорции = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическаяПроверкаЭПДокументовИзСВД", "КоличествоДокументовВПорции");
	Если КоличествоДокументовВПорции = 0 Тогда
		КоличествоДокументовВПорции = 100;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическаяПроверкаЭПДокументовИзСВД", "КоличествоДокументовВПорции",  КоличествоДокументовВПорции);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	Отказ = Истина;
	ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте извлечение текстов не поддерживается.'"));
	Возврат;
#КонецЕсли

	Если Не ИспользоватьЭП Тогда
		
		Отказ = Истина;
		СтрокаСообщения = НСтр("ru = 'Необходимо включить использование ЭП в настройках программы.'");
		ПоказатьПредупреждение(, СтрокаСообщения);
		Возврат;
		
	КонецЕсли;

	Если ВыполнятьПроверкуЭПНаСервере Тогда
		
		Отказ = Истина;
		СтрокаСообщения = НСтр("ru = 'Настроена проверка ЭП на сервере.'");
		ПоказатьПредупреждение(,СтрокаСообщения);
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ИнтервалВремениВыполненияПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"АвтоматическаяПроверкаЭПДокументовИзСВД", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	
	Если ВключеноИзвлечениеТекста Тогда
		ОтключитьОбработчикОжидания("ПроверкаКлиентОбработчик");
		ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
		Если ИнтервалВремениВыполнения > 0 Тогда
			ПодключитьОбработчикОжидания("ПроверкаКлиентОбработчик", ИнтервалВремениВыполнения);
		Иначе
			ПроверкаКлиентОбработчик();
		КонецЕсли;
		ОбновлениеОбратногоОтсчета();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики команд формы
//

////////////////////////////////////////////////////////////////////////////////
// Служебные
//

&НаСервере
Процедура ЗаполнитьСписокЭП(Документ)
	
	РаботаСЭП.ЗаполнитьСписокПодписей(Документ, ТаблицаПодписей, 
		УникальныйИдентификатор, Неопределено);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Проверка ЭП документов из СВД'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,,,
		ТекстСообщения);
	
КонецПроцедуры

// Обновляет обратный отсчет
//
&НаКлиенте
Процедура ОбновлениеОбратногоОтсчета()
	
	Осталось = ПрогнозируемоеВремяНачалаИзвлечения - ТекущаяДата();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'До начала извлечения текстов осталось %1 сек'"), 
							Осталось);
	
	Если Осталось <= 1 Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ИнтервалВремениВыполнения = Элементы.ИнтервалВремениВыполнения.ТекстРедактирования;
	Статус = ТекстСообщения;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаКлиентОбработчик()
	
#Если НЕ ВебКлиент Тогда
	ПроверкаЭПКлиент();
#КонецЕсли	

КонецПроцедуры

#Если НЕ ВебКлиент Тогда
// Извлекает текст из файлов на диске на клиенте
&НаКлиенте
Процедура ПроверкаЭПКлиент(РазмерПорции = Неопределено)
	
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
	
	Состояние(НСтр("ru = 'Начата проверка ЭП'"));
	Документ = Неопределено;
	
	Попытка
		
		РазмерПорцииТекущий = КоличествоДокументовВПорции;
		Если РазмерПорции <> Неопределено Тогда
			РазмерПорцииТекущий = РазмерПорции;
		КонецЕсли;	
		МассивДокументов = ПолучитьНепроверенныеДокументы(РазмерПорцииТекущий);
		
		Если МассивДокументов.Количество() = 0 Тогда
			Состояние(НСтр("ru = 'Нет документов для проверки'"));
			Возврат;
		КонецЕсли;
		
		Для Индекс = 0 По МассивДокументов.Количество() - 1 Цикл
			
			Документ = МассивДокументов[Индекс];
			
			Попытка
				
				ИмяСРасширением = Строка(Документ);
				Прогресс = Индекс * 100 / МассивДокументов.Количество();
				Состояние(НСтр("ru = 'Идет проверка ЭП документа:'"), Прогресс, ИмяСРасширением);
				
				ЗаполнитьСписокЭП(Документ);
				
				ПодписываемыеЭлементы = ТаблицаПодписей.ПолучитьЭлементы();
				Для Каждого ПодписываемыйЭлемент Из ПодписываемыеЭлементы Цикл
					Подписи = ПодписываемыйЭлемент.ПолучитьЭлементы();
					Для Каждого ОднаПодпись Из Подписи Цикл
						Если Не ОднаПодпись.ПодписьВерна Тогда
							РаботаСЭП.УстановитьСтатусПроверки(Документ, ПредопределенноеЗначение("Перечисление.СтатусПроверкиЭП.ПодписьНедействительна"));
							Возврат;
						КонецЕсли;
					КонецЦикла;
				КонецЦикла;
				Если ПодписываемыеЭлементы.Количество() > 0 Тогда
					РаботаСЭП.УстановитьСтатусПроверки(Документ, ПредопределенноеЗначение("Перечисление.СтатусПроверкиЭП.ПодписьДействительна"));
				Иначе
					РаботаСЭП.УстановитьСтатусПроверки(Документ, ПредопределенноеЗначение("Перечисление.СтатусПроверкиЭП.ПодписиНет"));
				КонецЕсли;
				
			Исключение
				
				ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Во время проверки ЭП документа ""%1"" произошла неизвестная ошибка.'",
											ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
										Строка(Документ));
										
				ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
				
				Состояние(ТекстСообщения);
				
				ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
				
			КонецПопытки;
				
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								 НСтр("ru = 'Проверка ЭП документа успешно завершена. Обработано документов: %1'"), 
								 МассивДокументов.Количество());
		Состояние(ТекстСообщения);
		
	Исключение
		
		ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Во время проверки ЭП документа ""%1"" произошла неизвестная ошибка.'",
									ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
								Строка(Документ));
								
		ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
		
		Состояние(ТекстСообщения);
		
		// запись в журнал регистрации
		ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
		
	КонецПопытки;
	
	КоличествоНепроверенныхДокументов = ПолучитьКоличествоНепроверенныхДокументов();
	
КонецПроцедуры
#КонецЕсли

&НаКлиенте
Процедура Старт(Команда)
	
	ВключеноИзвлечениеТекста = Истина; 
	
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата();
	Если ИнтервалВремениВыполнения > 0 Тогда
		ПодключитьОбработчикОжидания("ПроверкаКлиентОбработчик", ИнтервалВремениВыполнения);
	КонецЕсли;
	ПроверкаКлиентОбработчик();
	
	ПодключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета", 1);
	ОбновлениеОбратногоОтсчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Стоп(Команда)
	ВыполнитьСтоп();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСтоп()
	ОтключитьОбработчикОжидания("ПроверкаКлиентОбработчик");
	ОтключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета");
	Статус = "";
	ВключеноИзвлечениеТекста = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВсе(Команда)
	
	#Если НЕ ВебКлиент Тогда
		КоличествоНепроверенныхДокументовДоНачалаОперации = КоличествоНепроверенныхДокументов;
		Статус = "";
		РазмерПорции = 0; // извлечь все
		ПроверкаЭПКлиент(РазмерПорции);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Завершена проверка ЭП документов, поступивших по СВД. Обработано документов: %1.'"),
			КоличествоНепроверенныхДокументовДоНачалаОперации);
		ПоказатьПредупреждение(, ТекстСообщения);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоФайловВПорцииПриИзменении(Элемент)
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"АвтоматическаяПроверкаЭПДокументовИзСВД", "КоличествоДокументовВПорции",  КоличествоДокументовВПорции);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКоличествоНепроверенныхДокументов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(КОЛИЧЕСТВО(ВходящиеДокументы.Ссылка), 0) КАК КоличествоДокументов
		|ИЗ
		|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаЗагруженныхДанных КАК ПроверкаЗагруженныхДанных
		|		ПО ВходящиеДокументы.Ссылка = ПроверкаЗагруженныхДанных.Объект
		|			И (ПроверкаЗагруженныхДанных.Проверен = ЛОЖЬ)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КешИнформацииОбОбъектах КАК КешИнформацииОбОбъектах
		|		ПО ВходящиеДокументы.Ссылка = КешИнформацииОбОбъектах.Объект
		|			И (КешИнформацииОбОбъектах.СтатусЭП = &СтатусЭП)
		|			И (КешИнформацииОбОбъектах.ПолученПоСВД = ИСТИНА)";
		
	Запрос.УстановитьПараметр("СтатусЭП", Перечисления.СтатусПроверкиЭП.ПодписьНеПроверена);	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.КоличествоДокументов;
	
КонецФункции	

&НаСервереБезКонтекста
Функция ПолучитьНепроверенныеДокументы(КоличествоДокументовВПорции)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ {КоличествоДокументовВПорции}
		|	ВходящиеДокументы.Ссылка КАК Ссылка,
		|	ВходящиеДокументы.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ВходящиеДокументы КАК ВходящиеДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаЗагруженныхДанных КАК ПроверкаЗагруженныхДанных
		|		ПО ВходящиеДокументы.Ссылка = ПроверкаЗагруженныхДанных.Объект
		|			И (ПроверкаЗагруженныхДанных.Проверен = ЛОЖЬ)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КешИнформацииОбОбъектах КАК КешИнформацииОбОбъектах
		|		ПО ВходящиеДокументы.Ссылка = КешИнформацииОбОбъектах.Объект
		|			И (КешИнформацииОбОбъектах.СтатусЭП = &СтатусЭП)
		|			И (КешИнформацииОбОбъектах.ПолученПоСВД = ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
		
	Если КоличествоДокументовВПорции <> 0 Тогда			
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{КоличествоДокументовВПорции}", "ПЕРВЫЕ " + Формат(КоличествоДокументовВПорции, "ЧГ=; ЧН="));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{КоличествоДокументовВПорции}", "");
	КонецЕсли;	
		
	Запрос.УстановитьПараметр("СтатусЭП", Перечисления.СтатусПроверкиЭП.ПодписьНеПроверена);	
	МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	Возврат МассивДокументов;
	
КонецФункции	