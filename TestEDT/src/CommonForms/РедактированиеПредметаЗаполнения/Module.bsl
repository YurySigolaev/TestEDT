////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Добавление") И Параметры.Добавление = Истина Тогда
		Заголовок = НСтр("ru='Добавление заполняемого предмета'");
	Иначе
		Заголовок = НСтр("ru='Заполняемый предмет'");
	КонецЕсли;
	
	Параметры.Свойство("РольПредмета",РольПредмета);
	
	Параметры.Свойство("Предмет", Предмет);
	Параметры.Свойство("ИмяПредмета", ИмяПредмета);
	Параметры.Свойство("ИмяПредмета", ИмяПредметаСтрокой);
	Параметры.Свойство("ИмяПредметаОснование",ИмяПредметаОснование);
	Параметры.Свойство("ШаблонОснование",ШаблонОснование);
	Параметры.Свойство("ТочкаМаршрута", ТочкаМаршрута);
	
	Параметры.Свойство("Предмет", ИсходныйПредмет);
	Параметры.Свойство("ИмяПредмета", ИсходноеИмяПредмета);
	Параметры.Свойство("ИмяПредметаОснование",ИсходноеИмяПредметаОснование);
	Параметры.Свойство("ИменаПредметовИсключений",ИменаПредметовИсключений);
	Параметры.Свойство("ШаблонОснование",ИсходныйШаблонОснование);
	Параметры.Свойство("ТочкаМаршрута", ИсходныйТочкаМаршрута);
	
	Параметры.Свойство("СсылкаНаПроцесс",СсылкаНаПроцесс);
	Параметры.Свойство("Шаблон",Шаблон);
	Параметры.Свойство("ШаблонПроцесса",ШаблонПроцесса);
	Параметры.Свойство("ТолькоПросмотр", ТолькоПросмотр);
	Параметры.Свойство("ДействияПроцесса", ДействияПроцессаСписок);
	
	Для Каждого Элемент Из ИменаПредметовИсключений Цикл
		Элемент.Представление = " " + Строка(Элемент.Значение);
	КонецЦикла;
	
	Если Параметры.Свойство("Шаблон") И СсылкаНаПроцесс = Неопределено Тогда
		СсылкаНаПроцесс = МультипредметностьПереопределяемый.ПолучитьСсылкуНаПроцессПоШаблону(Параметры.Шаблон);
	КонецЕсли;
	
	Если Параметры.Свойство("Шаблон") Тогда
		Элементы.ШаблонОснование.Видимость = Истина;
		Элементы.ДекорацияДляШаблона.Видимость = Ложь;
	Иначе
		Элементы.ШаблонОснование.Видимость = Ложь;
		Элементы.ДекорацияДляШаблона.Видимость = Истина;
	КонецЕсли;
	
	Если ДействияПроцессаСписок.Количество() = 0 Тогда
		ДействияПроцессаСписок.ЗагрузитьЗначения(Мультипредметность.ПолучитьДействияПроцесса(СсылкаНаПроцесс));
	КонецЕсли;
	
	Если Не ТолькоПросмотр Тогда
		Для Каждого Действие Из ДействияПроцессаСписок Цикл 
			Элементы.ТочкаМаршрута.СписокВыбора.Добавить(Действие.Значение);
		КонецЦикла;
		Если ТочкаМаршрута = Неопределено И Элементы.ТочкаМаршрута.СписокВыбора.Количество() > 0 Тогда
			ТочкаМаршрута = Элементы.ТочкаМаршрута.СписокВыбора[0].Значение;
		КонецЕсли;
		Для Каждого ПредметОснование Из ИменаПредметовИсключений Цикл
			Элементы.ИмяПредметаОснование.СписокВыбора.Добавить(ПредметОснование.Значение);
		КонецЦикла;
	
		Если ЗначениеЗаполнено(ШаблонПроцесса) Тогда 
			ТипыПредмета = МультипредметностьВызовСервера.ПолучитьОграничениеТиповИмениПредметаШаблона(ШаблонПроцесса, ИмяПредмета);
		КонецЕсли;
		Если ТипыПредмета.Количество() = 0 Тогда
			ТипыПредмета = МультипредметностьВызовСервера.ПолучитьСписокТиповПредметовПроцесса(СсылкаНаПроцесс, РольПредмета);
			ТипыПредмета.Вставить(0, "Неопределено", НСтр("ru='Любой доступный тип'"));
		КонецЕсли;
		
		Для Каждого Элемент Из ТипыПредмета Цикл
			Элементы.ПредметСтрокой.СписокВыбора.Добавить(Элемент.Значение, Элемент.Представление);
		КонецЦикла;
		
		Если Предмет = Неопределено Тогда
			ПредметСтрокой = "Неопределено";
		Иначе
			ПредметСтрокой = Предмет.Метаданные().ПолноеИмя();
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого Строка Из ИменаПредметовИсключений Цикл
		Если Строка.Значение = ИмяПредметаОснование Тогда
			Строка.Пометка = Истина;
		Иначе
			Строка.Пометка = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТолькоПросмотр Тогда
		Отказ = Истина;
		ПоказатьЗначение(, Предмет);
	Иначе
		УстановитьДоступностьИТипШаблонаОснования();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПредметСтрокойПриИзменении(Элемент)
	
	Если ПредметСтрокой = "" Тогда
		ПредметСтрокой = "Неопределено";
	КонецЕсли;
	
	ВыбранноеЗначение = ТипыПредмета.НайтиПоЗначению(ПредметСтрокой);
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		Если Найти(ВыбранноеЗначение.Значение,"Справочник")
			Или Найти(ВыбранноеЗначение.Значение,"Документ") Тогда
			Предмет = ПредопределенноеЗначение(ВыбранноеЗначение.Значение + ".ПустаяСсылка");
		Иначе
			Предмет = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьДоступностьИТипШаблонаОснования();

КонецПроцедуры

&НаКлиенте
Процедура ИмяПредметаСтрокойПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ИмяПредметаСтрокой) Тогда
		ИмяПредмета = МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредмета(ИмяПредметаСтрокой);
	Иначе
		ИмяПредмета = ПредопределенноеЗначение("Справочник.ИменаПредметов.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПредметаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если СтрДлина(Текст) > 1 Тогда
		МультипредметностьВызовСервера.ПолучитьДанныеДляАвтоподбораИмениПредмета(ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Готово(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(ИмяПредмета) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Поле ""Имя предмета"" не заполнено'"),, 
			"ИмяПредметаСтрокой");
		Отказ = Истина;
	КонецЕсли;
	
	Если ИменаПредметовИсключений.НайтиПоЗначению(ИмяПредмета) <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имя предмета ""%1"" уже используется в этом процессе'"),
				Строка(ИмяПредмета)),, 
			"ИмяПредметаСтрокой");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяПредмета <> ИсходноеИмяПредмета 
	 Или Предмет <> ИсходныйПредмет 
	 Или ИмяПредметаОснование <> ИсходноеИмяПредметаОснование 
	 Или ТочкаМаршрута <> ИсходныйТочкаМаршрута 
	 Или ШаблонОснование <> ИсходныйШаблонОснование Тогда 
	 
	 	СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("РольПредмета",РольПредмета);
		СтруктураВозврата.Вставить("ИмяПредмета",ИмяПредмета);
		СтруктураВозврата.Вставить("Предмет",Предмет);
		СтруктураВозврата.Вставить("ТочкаМаршрута", ТочкаМаршрута);
		СтруктураВозврата.Вставить("ИмяПредметаОснование",ИмяПредметаОснование);
		СтруктураВозврата.Вставить("ШаблонОснование", ШаблонОснование);
		
		Если Шаблон = Неопределено Тогда
			Если ЗначениеЗаполнено(ТочкаМаршрута) И Не ЗначениеЗаполнено(Предмет) Тогда
				Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1, %2, заполняется в задаче ""%3""'"),
					Строка(ИмяПредмета), 
					НРег(Элементы.ПредметСтрокой.СписокВыбора.НайтиПоЗначению(ПредметСтрокой).Представление), 
					Строка(ТочкаМаршрута));
			Иначе
				Описание = ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(Предмет, ИмяПредмета);
			КонецЕсли;
			СтруктураВозврата.Вставить("Описание", Описание);
		Иначе
			СтруктураВозврата.Вставить("Описание");
			МультипредметностьКлиентСервер.УстановитьОписаниеСтрокиПредметаШаблона(СтруктураВозврата);
		КонецЕсли;
			
		Закрыть(СтруктураВозврата);
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьДоступностьИТипШаблонаОснования()
	
	Если ТипЗнч(Предмет) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		Если ТипЗнч(ШаблонОснование) <> Тип("СправочникСсылка.ШаблоныВнутреннихДокументов") Тогда
			ШаблонОснование = ПредопределенноеЗначение("Справочник.ШаблоныВнутреннихДокументов.ПустаяСсылка");
		КонецЕсли;
	ИначеЕсли ТипЗнч(Предмет) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		Если ТипЗнч(ШаблонОснование) <> Тип("СправочникСсылка.ШаблоныВходящихДокументов") Тогда
			ШаблонОснование = ПредопределенноеЗначение("Справочник.ШаблоныВходящихДокументов.ПустаяСсылка");
		КонецЕсли;
	ИначеЕсли ТипЗнч(Предмет) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		Если ТипЗнч(ШаблонОснование) <> Тип("СправочникСсылка.ШаблоныИсходящихДокументов") Тогда
			ШаблонОснование = ПредопределенноеЗначение("Справочник.ШаблоныИсходящихДокументов.ПустаяСсылка");
		КонецЕсли;
	ИначеЕсли ТипЗнч(Предмет) = Тип("СправочникСсылка.Файлы") Тогда
		Если ТипЗнч(ШаблонОснование) <> Тип("СправочникСсылка.Файлы") Тогда
			ШаблонОснование = ПредопределенноеЗначение("Справочник.Файлы.ПустаяСсылка");
		КонецЕсли;
	Иначе
		ШаблонОснование = Неопределено;
	КонецЕсли;
	
	Если ШаблонОснование <> Неопределено Тогда
		Элементы.ШаблонОснование.Доступность = Истина;
	Иначе
		Элементы.ШаблонОснование.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипЗнч(ШаблонОснование) = Тип("СправочникСсылка.Файлы") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытияФормы = Новый Структура("ВыборШаблона, ТекущаяСтрока", 
			Истина, ?(ЗначениеЗаполнено(ШаблонОснование), ШаблонОснование, ПредопределенноеЗначение("Справочник.ПапкиФайлов.Шаблоны")));
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ШаблонОснованиеНачалоВыбораПродолжение", 
			ЭтотОбъект);
		ОткрытьФорму(
			"Справочник.Файлы.Форма.ФормаВыбораФайлаВПапках",
			ПараметрыОткрытияФормы,,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ШаблонОснованиеНачалоВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонОснование = Результат;
	
КонецПроцедуры
