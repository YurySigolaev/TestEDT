
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтКого") И ЗначениеЗаполнено(Параметры.ОтКого) Тогда 
		Объект.ОтКого = Параметры.ОтКого;
	КонецЕсли;
		
	ВариантДелегированияПравВсеПрава = Перечисления.ВариантыДелегированияПрав.ВсеПрава;
	ВариантДелегированияПравВыборочно = Перечисления.ВариантыДелегированияПрав.Выборочно;
	
	Если Объект.Ссылка.Пустая() И Не ЗначениеЗаполнено(Объект.ДатаНачалаДействия) Тогда
		Объект.ДатаНачалаДействия = НачалоМинуты(ТекущаяДата());
	КонецЕсли;
	
	ЗаполнитьОбластиДелегирования();
	ЗаполнитьСписокВыбораКому(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ЗначениеЗаполнено(Объект.ДатаОкончанияДействия) И
		Объект.ДатаОкончанияДействия < Объект.ДатаНачалаДействия Тогда
		
		ТекстОшибки = НСтр("ru = 'Неверно задан период действия.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Объект.ДатаОкончанияДействия)
		И НачалоМинуты(Объект.ДатаОкончанияДействия) - НачалоМинуты(Объект.ДатаНачалаДействия) < 15 * 60 Тогда
		
		ТекстОшибки = НСтр("ru = 'Минимальный срок действия должен быть равен 15 минут.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ОбластиДелегирования.Очистить();	
	
	ТаблицаОбластей = РеквизитФормыВЗначение("ОбластиДелегирования");
	Для Каждого Строка Из ТаблицаОбластей Цикл
		Если Строка.Пометка Тогда 
			НоваяСтрока = ТекущийОбъект.ОбластиДелегирования.Добавить();
			НоваяСтрока.ОбластьДелегирования = Строка.ОбластьДелегирования;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ВариантДелегирования = Перечисления.ВариантыДелегированияПрав.Выборочно Тогда 
		
		ЕстьПометка = Ложь;
		
		ТаблицаОбластей = РеквизитФормыВЗначение("ОбластиДелегирования");
		Для Каждого Строка Из ТаблицаОбластей Цикл
			Если Строка.Пометка Тогда 
				ЕстьПометка = Истина;
			КонецЕсли;	
		КонецЦикла;
		
		Если Не ЕстьПометка Тогда 
			Текст = НСтр("ru = 'Не отмечено ни одной области делегирования'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,, "ОбластиДелегирования",, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДобавленаОбластьДелегирования" Тогда 
		НоваяСтрока = ОбластиДелегирования.Добавить();
		НоваяСтрока.ОбластьДелегирования = Параметр;
		ОбластиДелегирования.Сортировать("ОбластьДелегирования");
	КонецЕсли;	
	
	Если ИмяСобытия = "ИзмененаОбластьДелегирования" Тогда 
		НайденныеСтроки = ОбластиДелегирования.НайтиСтроки(Новый Структура("ОбластьДелегирования", Параметр));
		Если НайденныеСтроки.Количество() > 0 Тогда 
			НайденнаяСтрока = НайденныеСтроки[0];
			НайденнаяСтрока.ОбластьДелегирования = Параметр;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ДелегированиеПрав", Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантДелегированияПриИзменении(Элемент)
	
	Если Объект.ВариантДелегирования = ВариантДелегированияПравВсеПрава Тогда 
		УстановитьПометки(Ложь);
	КонецЕсли;	
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбластиДелегирования

&НаКлиенте
Процедура ОбластиДелегированияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ОбластиДелегирования.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущаяКолонка = Элементы.ОбластиДелегирования.ТекущийЭлемент;
	Если ТекущаяКолонка = Элементы.ОбластиДелегированияПометка Тогда 
		
		ТекущиеДанные.Пометка = Не ТекущиеДанные.Пометка;
		
	Иначе
	
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.ОбластьДелегирования);
	
		ОткрытьФорму("Справочник.ОбластиДелегированияПрав.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьПометки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометки(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОбластиДелегирования()
	
	Запрос = Новый Запрос;
	Запрос.Текст =  
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОбластиДелегированияПрав.Ссылка КАК ОбластьДелегирования,
		|	ВЫБОР
		|		КОГДА ДелегированиеПравОбластиДелегирования.ОбластьДелегирования ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Пометка
		|ИЗ
		|	Справочник.ОбластиДелегированияПрав КАК ОбластиДелегированияПрав
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДелегированиеПрав.ОбластиДелегирования КАК ДелегированиеПравОбластиДелегирования
		|		ПО ДелегированиеПравОбластиДелегирования.ОбластьДелегирования = ОбластиДелегированияПрав.Ссылка
		|		И ДелегированиеПравОбластиДелегирования.Ссылка = &Ссылка
		|ГДЕ
		|	НЕ ОбластиДелегированияПрав.ПометкаУдаления
		|			ИЛИ НЕ ДелегированиеПравОбластиДелегирования.ОбластьДелегирования ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОбластиДелегированияПрав.Наименование";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	ТаблицаОбластей = Запрос.Выполнить().Выгрузить();
	ЗначениеВРеквизитФормы(ТаблицаОбластей, "ОбластиДелегирования");
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьДоступность()
	
	Если Объект.ВариантДелегирования = ВариантДелегированияПравВсеПрава Тогда 
		Элементы.ОбластиДелегирования.ТолькоПросмотр = Истина;
		Элементы.ГруппаКоманднаяПанель.Доступность = Ложь;
	Иначе
		Элементы.ОбластиДелегирования.ТолькоПросмотр = Ложь;
		Элементы.ГруппаКоманднаяПанель.Доступность = Истина;
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьПометки(Пометка)
	
	Для Каждого Строка Из ОбластиДелегирования Цикл
		Строка.Пометка = Пометка;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКому(Параметры)
	
	Элементы.Кому.СписокВыбора.Очистить();
	
	// Если основание не отсутствие то заполнять список выбора не нужно
	Если Не ЗначениеЗаполнено(Параметры.Основание)
		Или ТипЗнч(Параметры.Основание) <> Тип("ДокументСсылка.Отсутствие") Тогда
		Возврат;
	КонецЕсли;
	
	МассивВозможныхЗаместителей = Новый Массив;
	
	// Возможные заместители - по которым еще не создано делегирование
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ОтсутствиеЗаместители.Заместитель
		|ИЗ
		|	Документ.Отсутствие.Заместители КАК ОтсутствиеЗаместители
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДелегированиеПрав КАК ДелегированиеПрав
		|		ПО ОтсутствиеЗаместители.Заместитель = ДелегированиеПрав.Кому
		|ГДЕ
		|	ОтсутствиеЗаместители.Ссылка = &Отсутствие
		|	И (ДелегированиеПрав.Ссылка ЕСТЬ NULL 
		|		ИЛИ ДелегированиеПрав.Ссылка = &ДелегированиеПрав)";
	Запрос.УстановитьПараметр("Отсутствие", Параметры.Основание);
	Запрос.УстановитьПараметр("ДелегированиеПрав", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивВозможныхЗаместителей.Добавить(Выборка.Заместитель);
	КонецЦикла;
	
	// Если по всем заместителям есть делегирование - все заместители возможны
	Если МассивВозможныхЗаместителей.Количество() = 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ОтсутствиеЗаместители.Заместитель
			|ИЗ
			|	Документ.Отсутствие.Заместители КАК ОтсутствиеЗаместители
			|ГДЕ
			|	ОтсутствиеЗаместители.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Параметры.Основание);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			МассивВозможныхЗаместителей.Добавить(Выборка.Заместитель);
		КонецЦикла;
		
	КонецЕсли;
	
	// Если нет возможных заместителей список выбора заполнять не нужно
	Если МассивВозможныхЗаместителей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Кому.КнопкаСоздания = Ложь;
	Элементы.Кому.ИсторияВыбораПриВводе = ИсторияВыбораПриВводе.НеИспользовать;
	
	// Если один возможных заместитель - сразу его выбираем
	Если Объект.Ссылка.Пустая() И Не ЗначениеЗаполнено(Объект.Кому) 
			И МассивВозможныхЗаместителей.Количество() = 1  Тогда
		Объект.Кому = МассивВозможныхЗаместителей[0];
	КонецЕсли;
	
	Для Каждого ВозможныйЗаместитель Из МассивВозможныхЗаместителей Цикл
		Элементы.Кому.СписокВыбора.Добавить(ВозможныйЗаместитель);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
