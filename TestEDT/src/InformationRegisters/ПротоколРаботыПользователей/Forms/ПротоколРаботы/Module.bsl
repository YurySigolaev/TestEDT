
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбъектДанных") Тогда
		
		ОбъектДанных = Параметры.ОбъектДанных;
		
		Элемент = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Элемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбъектДанных");
		Элемент.ПравоеЗначение = ОбъектДанных;
		
		Элементы.ГруппаБыстрыеОтборы.Видимость = Ложь;
		Элементы.ОбъектДанных.Видимость = Ложь;
		
	КонецЕсли;	
	
	Для Каждого ТипСобытия Из Перечисления.ТипыСобытийПротоколаРаботыПользователей Цикл
		ТипыСобытий.Добавить(ТипСобытия);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВыборкиПриИзменении(Элемент)
	
	УстановитьПараметрыИОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыСобытийПриИзменении(Элемент)
	
	УстановитьПараметрыИОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПриИзменении(Элемент)
	
	УстановитьПараметрыИОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектДляОтбораПриИзменении(Элемент)
	
	УстановитьПараметрыИОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	
	УстановитьПараметрыИОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеСведенияПолеПриИзменении(Элемент)
	
	УстановитьПараметрыИОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыИОтборСписка()
	
	ПараметрыОтбора = Новый Соответствие();
	
	ТипыСобытийМассив = Новый Массив;
	Для Каждого ТипСобытий Из ТипыСобытий Цикл
		Если ТипСобытий.Пометка Тогда
			ТипыСобытийМассив.Добавить(ТипСобытий.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ТипыСобытийМассив.Количество() <> 0 Тогда
		ПараметрыОтбора.Вставить("ТипыСобытий", ТипыСобытийМассив);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПериодВыборки.ДатаНачала) ИЛИ ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда
		ПараметрыОтбора.Вставить("ПериодВыборки", ПериодВыборки);
	КонецЕсли;	
	
	ПользователиМассив = Новый Массив;
	Для Каждого Пользователь Из Пользователи Цикл
		ПользователиМассив.Добавить(Пользователь.Значение);
	КонецЦикла;
	Если ПользователиМассив.Количество() <> 0 Тогда
		ПараметрыОтбора.Вставить("Пользователи", ПользователиМассив);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ОбъектДляОтбора) Тогда
		ПараметрыОтбора.Вставить("ОбъектДанных", ОбъектДляОтбора);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Описание) Тогда
		ПараметрыОтбора.Вставить("Описание", Описание);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ДополнительныеСведения) Тогда
		ПараметрыОтбора.Вставить("ДополнительныеСведения", ДополнительныеСведения);
	КонецЕсли;	
	
	УстановитьОтборСписка(ПараметрыОтбора);
	
КонецПроцедуры


&НаСервере
Процедура УстановитьОтборСписка(ПараметрыОтбора)
	
	// Описание 
	ОписаниеПараметр = ПараметрыОтбора.Получить("Описание");
	Если ОписаниеПараметр <> Неопределено И ЗначениеЗаполнено(ОписаниеПараметр) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ОписаниеСобытия",
			ОписаниеПараметр,
			ВидСравненияКомпоновкиДанных.Содержит);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"ОписаниеСобытия");
	КонецЕсли;
	
	// ДополнительныеСведения 
	ДополнительныеСведенияПараметр = ПараметрыОтбора.Получить("ДополнительныеСведения");
	Если ДополнительныеСведенияПараметр <> Неопределено И ЗначениеЗаполнено(ДополнительныеСведенияПараметр) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ДополнительныеСведения",
			ДополнительныеСведенияПараметр,
			ВидСравненияКомпоновкиДанных.Содержит);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"ДополнительныеСведения");
	КонецЕсли;
	
	// ОбъектДанных 
	ОбъектДанных = ПараметрыОтбора.Получить("ОбъектДанных");
	Если ОбъектДанных <> Неопределено И ЗначениеЗаполнено(ОбъектДанных) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
			"ОбъектДанных",
			ОбъектДанных);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"ОбъектДанных");
	КонецЕсли;
	
	// пользователи 
	ПользователиМассив = ПараметрыОтбора.Получить("Пользователи");
	Если ПользователиМассив <> Неопределено И ПользователиМассив.Количество() > 0 Тогда 
		
		СписокПользователей = Новый СписокЗначений;
		Для Каждого Пользователь Из ПользователиМассив Цикл
			Если ЗначениеЗаполнено(Пользователь) Тогда
				СписокПользователей.Добавить(Пользователь);
			КонецЕсли;	
		КонецЦикла;
		
		Если СписокПользователей.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Пользователь",
				СписокПользователей,
				ВидСравненияКомпоновкиДанных.ВСписке);
		Иначе	
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Пользователь");
		КонецЕсли;		
			
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"Пользователь");
	КонецЕсли;
	
	// Типы событий 
	ТипыСобытийМассив = ПараметрыОтбора.Получить("ТипыСобытий");
	Если ТипыСобытийМассив <> Неопределено И ТипыСобытийМассив.Количество() > 0 Тогда 
		
		СписокТипов = Новый СписокЗначений;
		Для Каждого ТипСобытий Из ТипыСобытийМассив Цикл
			Если ЗначениеЗаполнено(ТипСобытий) Тогда
				СписокТипов.Добавить(ТипСобытий);
			КонецЕсли;	
		КонецЦикла;
		
		Если СписокТипов.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"ТипСобытия",
				СписокТипов,
				ВидСравненияКомпоновкиДанных.ВСписке);
		Иначе	
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"ТипСобытия");
		КонецЕсли;		
			
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
			"ТипСобытия");
	КонецЕсли;
	
	// период 
	ПериодВыборки = ПараметрыОтбора.Получить("ПериодВыборки");
	Если ПериодВыборки <> Неопределено Тогда 
		
		ЭлементыОтбора = Список.Отбор.Элементы;
		
		ЭлементОтбораДанных = Неопределено;
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			Если ЭлементОтбора.Представление = "ОтборПериод" Тогда
				ЭлементОтбораДанных = ЭлементОтбора;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЭлементОтбораДанных = Неопределено Тогда
			ГруппаОтборПериод = ЭлементыОтбора.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ГруппаОтборПериод.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли; 
			ГруппаОтборПериод.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный; 
			ГруппаОтборПериод.Использование = Истина;
			ГруппаОтборПериод.Представление = "ОтборПериод";
		Иначе
			ГруппаОтборПериод = ЭлементОтбораДанных;
			ГруппаОтборПериод.Элементы.Очистить();
			ГруппаОтборПериод.Использование = Истина;
		КонецЕсли;	
		
		
		ГруппаДатаЗаписи = ГруппаОтборПериод.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаДатаЗаписи.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ; 
		ГруппаДатаЗаписи.Использование = Истина;
			
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаНачала) Тогда 
			ЭлементОтбораДанных = ГруппаДатаЗаписи.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаНачала;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда 
			ЭлементОтбораДанных = ГруппаДатаЗаписи.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаОкончания;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;
		
		Если ГруппаДатаЗаписи.Элементы.Количество() = 0 Тогда 
			ГруппаОтборПериод.Элементы.Удалить(ГруппаДатаЗаписи);
		КонецЕсли;	
		
		
		ГруппаДатаСоздания = ГруппаОтборПериод.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаДатаСоздания.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ; 
		ГруппаДатаСоздания.Использование = Истина;
			
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаНачала) Тогда 
			ЭлементОтбораДанных = ГруппаДатаСоздания.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаНачала;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда 
			ЭлементОтбораДанных = ГруппаДатаСоздания.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
			ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ЭлементОтбораДанных.ПравоеЗначение = ПериодВыборки.ДатаОкончания;
			ЭлементОтбораДанных.Использование = Истина;
		КонецЕсли;
		
		Если ГруппаДатаСоздания.Элементы.Количество() = 0 Тогда 
			ГруппаОтборПериод.Элементы.Удалить(ГруппаДатаСоздания);
		КонецЕсли;	
		
		
		Если ГруппаОтборПериод.Элементы.Количество() = 0 Тогда 
			ЭлементыОтбора.Удалить(ГруппаОтборПериод);
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыСобытийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент = Элементы.ОбъектДанных Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элемент.ТекущиеДанные.ОбъектДанных);
		
	КонецЕсли;	
	
КонецПроцедуры
