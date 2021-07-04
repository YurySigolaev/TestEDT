
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Параметры.Свойство("ТекущийПользователь", ТекущийПользователь);

	Если Не ЗначениеЗаполнено(ТекущийПользователь) Тогда
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;

	ЗагрузитьНастройки();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Заголовок = СтрШаблон("%1: %2", Заголовок, ТекущийПользователь);
	
	ОбработатьОткрытиеДляНастроекСинхронизацииПочты();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПапокПисем

&НаКлиенте
Процедура ДеревоПапокПисемПередРазворачиванием(Элемент, Строка, Отказ)
	
	ИзмененоСостояниеДереваПапокПисем = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПисемПередСворачиванием(Элемент, Строка, Отказ)
	
	ИзмененоСостояниеДереваПапокПисем = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПисемВыбранаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПапокПисем.ТекущиеДанные;
	
	Если ТекущиеДанные.Выбрана Тогда
		ТекущаяСтрока = Элементы.ДеревоПапокПисем.ТекущаяСтрока;
		ЭлементДерева = ДеревоПапокПисем.НайтиПоИдентификатору(ТекущаяСтрока);
		ПометитьРодительскиеПапкиПисем(ЭлементДерева);
		Если НЕ ЭтоСтандартнаяпапкаУчетнойЗаписи(ЭлементДерева.ВидПапки) Тогда
			ПометитьДочерниеПапкиПисем(ЭлементДерева);
		КонецЕсли;
	Иначе
		ТекущаяСтрока = Элементы.ДеревоПапокПисем.ТекущаяСтрока;
		ЭлементДерева = ДеревоПапокПисем.НайтиПоИдентификатору(ТекущаяСтрока);
		ПараметрыОбработчикаОповещения = Новый Структура;
		ПараметрыОбработчикаОповещения.Вставить("ЭлементДерева", ЭлементДерева);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда
			ОбработчикОповещения = Новый ОписаниеОповещения(
				"ДеревоПапокПисемВыбранаПриИзмененииПродолжение",
				ЭтотОбъект,
				ПараметрыОбработчикаОповещения);
			ТекстВопроса = НСтр("ru = 'Будет выключена синхронизация всех папок в этой папке. Выключить?'");
				
			Режим = Новый СписокЗначений;
			Режим.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Выключить'"));
			Режим.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не выключать'"));
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, Режим, , КодВозвратаДиалога.Нет);
		КонецЕсли;
		Если ЭтоСтандартнаяпапкаУчетнойЗаписи(ЭлементДерева.ВидПапки) Тогда	
			ПараметрыОбработчикаОповещения.Вставить("СнятьОтметкуСРодительскихПапок", Истина);
			ОбработчикОповещения = Новый ОписаниеОповещения(
				"ДеревоПапокПисемВыбранаПриИзмененииПродолжение",
				ЭтотОбъект,
				ПараметрыОбработчикаОповещения);
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Будет выключена синхронизация всех папок в папке ""%1"". Выключить?'"),
				ЭлементДерева.ПолучитьРодителя().Наименование);
				
			Режим = Новый СписокЗначений;
			Режим.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Выключить'"));
			Режим.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не выключать'"));
			ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, Режим, , КодВозвратаДиалога.Нет);
		КонецЕсли;
		СнятьОтметкуСДочернихПапокПисем(ЭлементДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПисемВыбранаПриИзмененииПродолжение(Ответ, Параметры) Экспорт
	
	ТекущиеДанные = Элементы.ДеревоПапокПисем.ТекущиеДанные;
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		ТекущиеДанные.Выбрана = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СнятьОтметкуСРодительскихПапок") Тогда
		СнятьОтметкуСРодительскихПапокПисем(Параметры.ЭлементДерева);	
	КонецЕсли;
	СнятьОтметкуСДочернихПапокПисем(Параметры.ЭлементДерева);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)

	Если Не ЗначениеЗаполнено(ТекущийПользователь) Тогда

		Сообщение = Новый СообщениеПользователю();
		Сообщение.Поле  = "ТекущийПользователь";
		Сообщение.Текст = "Не выбран пользователь";
		Сообщение.Сообщить();

		Возврат;

	КонецЕсли;

	ЗаписатьНастройкиПочтыКлиент();
	ЗаписатьНастройкиИПроверитьИзменениеНастроекСинхронизацииСервер();
	
	Закрыть(СоставПапокИзменился);

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеПапкиПисем(Команда)
	
	ОтображатьУдаленныеПапкиПисем = Не ОтображатьУдаленныеПапкиПисем;
	Элементы.ДеревоПапокПисемКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленныеПапкиПисем;
	ЗаполнитьДеревоПапокПисем();
	
	ВосстановитьСостояниеДереваПапокПисем(СостояниеДереваПапокПисем);
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоМоиПапкиПисем(Команда)
	
	ОтображатьТолькоМоиПапкиПисем = Не ОтображатьТолькоМоиПапкиПисем;
	Элементы.ДеревоПапокПисемКонтекстноеМенюТолькоМоиПапки.Пометка = ОтображатьТолькоМоиПапкиПисем;
	ЗаполнитьДеревоПапокПисем();
	
	ВосстановитьСостояниеДереваПапокПисем(СостояниеДереваПапокПисем);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьНастройкиИПроверитьИзменениеНастроекСинхронизацииСервер()

	ПараметрыСинхронизации = ОбменСМобильнымиСервер.ПолучитьПараметрыСинхронизации(ТекущийПользователь);
	
	ЗаписатьИПроверитьНастройкиПочтыСервер(ПараметрыСинхронизации);
	
КонецПроцедуры

#Область ОбщиеНастройкиСинхронизации

&НаСервере
Процедура ЗагрузитьНастройки()

	ЗагрузитьНастройкиСинхронизацииПочты();
	
КонецПроцедуры 

#КонецОбласти


#Область НастройкиСинхронизацииПочты

&НаСервере
Процедура ЗагрузитьНастройкиСинхронизацииПочты()
	
	// Загрузка настроек для отображения дерева папок
	Если Параметры.Свойство("ОтображатьУдаленныеПапкиПисем") Тогда
		ОтображатьУдаленныеПапкиПисем = Параметры.ОтображатьУдаленныеПапкиПисем;
	Иначе
		ОтображатьУдаленныеПапкиПисем =
			ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("ОтображатьУдаленныеПисьмаИПапки");
	КонецЕсли;

	Если Параметры.Свойство("ОтображатьТолькоМоиПапкиПисем") Тогда
		ОтображатьТолькоМоиПапкиПисем = Параметры.ОтображатьТолькоМоиПапкиПисем;
	Иначе
		ОтображатьТолькоМоиПапкиПисем = ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("РежимМоиПапки");
	КонецЕсли;
	
	СостояниеДереваПапокПисем = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ЭтаФорма.ИмяФормы, 
		"СостояниеДереваПапокПисем", 
		Неопределено);
		
	Если СостояниеДереваПапокПисем = Неопределено И Параметры.Свойство("СостояниеДереваПапокПисем") Тогда
		СостояниеДереваПапокПисем = Параметры.СостояниеДереваПапокПисем;
	КонецЕсли;
	
	Элементы.ДеревоПапокПисемКонтекстноеМенюТолькоМоиПапки.Пометка = ОтображатьТолькоМоиПапкиПисем;
	
	Элементы.ДеревоПапокПисемКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленныеПапкиПисем;
	
	МассивПапокДляСинхронизации = 	
		РегистрыСведений.СинхронизацияПапокПисемСМобильнымКлиентом.ПолучитьПапкиДляСинхронизации(
			ТекущийПользователь, Истина);
				
	ПапкиПисемДляСинхронизацииПриОткрытии.ЗагрузитьЗначения(МассивПапокДляСинхронизации);
	ПапкиПисемДляСинхронизации.ЗагрузитьЗначения(МассивПапокДляСинхронизации);
	
	ЗаполнитьДеревоПапокПисем();
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОткрытиеДляНастроекСинхронизацииПочты()
	
	Если СостояниеДереваПапокПисем <> Неопределено Тогда
		ВосстановитьСостояниеДереваПапокПисем(СостояниеДереваПапокПисем);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИПроверитьНастройкиПочтыСервер(ПараметрыСинхронизации)

	УстановитьПривилегированныйРежим(Истина);
	
	СоставПапокИзменился = Ложь;
	
	Если ПапкиПисемДляСинхронизации.Количество() = 0 Тогда
		
		РегистрыСведений.ОбменСМобильнымиНастройкиПользователей.ЗаписатьНастройку(
			ТекущийПользователь,
			Перечисления.ОбменСМобильнымиТипыНастроекПользователей.СинхронизацияПочты,
			Ложь);
			
			СоставПапокИзменился = Истина;
			
		Возврат;
		
	КонецЕсли;
	
	// Проверим изменился ли состав папок 
	
	ИзмененныеПапки = Новый Массив();
	
	// Если Включили флаг синхронизации почты то в измененные должны попасть все папки
	ИзмененныеПапки = ПапкиПисемДляСинхронизации.ВыгрузитьЗначения();

	// Определяем что добавили
	Для каждого Элемент Из ПапкиПисемДляСинхронизации Цикл
		
		// Если проверяемой папки нет в списке который был при открытии - значит нужно выполнить
		// регистрацию писем на клиент.
		Если ПапкиПисемДляСинхронизацииПриОткрытии.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
			СоставПапокИзменился = Истина;
			ИзмененныеПапки.Добавить(Элемент.Значение);
		КонецЕсли;
		
	КонецЦикла;

	// Определяем что удалили
	Для каждого Элемент Из ПапкиПисемДляСинхронизацииПриОткрытии Цикл
		
		// Если проверяемой папки нет в списке который был при открытии - значит нужно выполнить
		// регистрацию писем на клиент.
		Если ПапкиПисемДляСинхронизации.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
			СоставПапокИзменился = Истина;
			ИзмененныеПапки.Добавить(Элемент.Значение);
		КонецЕсли;
		
	КонецЦикла;

	Если Не СоставПапокИзменился Тогда
		Возврат;
	КонецЕсли;

	// Сохранение настроек синхронизации почты
	РегистрыСведений.СинхронизацияПапокПисемСМобильнымКлиентом.ЗаписатьПапки(
		ПапкиПисемДляСинхронизации.ВыгрузитьЗначения(), ТекущийПользователь);

	РегистрыСведений.ИзмененныеНастройкиСинхронизацииСМобильнымКлиентом.ДобавитьЗапись(
		ТекущийПользователь,
		Перечисления.ВидыНастроекОбменаСМобильнымКлиентом.СинхронизацияПапокПисем);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкиПочтыКлиент()
	
	ПапкиПисемДляСинхронизации.Очистить();
	ЭлементыДерева = ДеревоПапокПисем.ПолучитьЭлементы();
	ЗаполнитьСписокВыбранныхПапок(ЭлементыДерева, ПапкиПисемДляСинхронизации);
	Если ИзмененоСостояниеДереваПапокПисем Тогда
		СостояниеДереваПапокПисем = ЗапомнитьСостояниеДереваПапокПисем();
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(ЭтаФорма.ИмяФормы,
			"СостояниеДереваПапокПисем", СостояниеДереваПапокПисем);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбранныхПапок(ЭлементыДерева, СписокПапок)
	
	Для Каждого Элемент Из ЭлементыДерева Цикл
		Если Элемент.Выбрана Тогда
			СписокПапок.Добавить(Элемент.Ссылка);
		КонецЕсли;
		ЗаполнитьСписокВыбранныхПапок(Элемент.ПолучитьЭлементы(), СписокПапок)
	КонецЦикла;
	
Конецпроцедуры

&НаКлиенте
Процедура ОбойтиДерево(ДеревоЭлементы, Контекст, ИмяПроцедуры)
	
	Для каждого Элемент Из ДеревоЭлементы Цикл
		ОбойтиДерево(Элемент.ПолучитьЭлементы(), Контекст, ИмяПроцедуры);
		Результат = Вычислить(ИмяПроцедуры + "(Элемент, Контекст)");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ЗапомнитьСостояниеДереваПапокПисем()
	
	Состояние = Новый Структура;
	Состояние.Вставить("ТекСсылка", Неопределено);
	Если Элементы.ДеревоПапокПисем.ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.ДеревоПапокПисем.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Состояние.ТекСсылка = ТекущиеДанные.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоПапокПисем);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоПапокПисем);
	Контекст.Вставить("Состояние", Новый Соответствие);
	ОбойтиДерево(ДеревоПапокПисем.ПолучитьЭлементы(), Контекст, "ЗапомнитьСостояниеРазвернут");
	Состояние.Вставить("Развернут", Контекст.Состояние);
	
	Возврат Состояние;
	
КонецФункции

&НаКлиенте
Функция ЗапомнитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Контекст.Состояние.Вставить(ТекДанные.Ссылка, Контекст.ФормаДерево.Развернут(ИдентификаторСтроки));
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСостояниеДереваПапокПисем(Состояние)
	
	Если Состояние = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоПапокПисем);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоПапокПисем);
	Контекст.Вставить("Состояние", Состояние.Развернут);
	Контекст.Вставить("ТекСсылка", Состояние.ТекСсылка);
	ОбойтиДерево(ДеревоПапокПисем.ПолучитьЭлементы(), Контекст, "УстановитьСостояниеРазвернут");
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Контекст.Состояние.Получить(ТекДанные.Ссылка) = Истина Тогда
		Контекст.ФормаДерево.Развернуть(ИдентификаторСтроки);
	Иначе
		Контекст.ФормаДерево.Свернуть(ИдентификаторСтроки);
	КонецЕсли;
	Если ТекДанные.Ссылка = Контекст.ТекСсылка Тогда
		Контекст.ФормаДерево.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоПапокПисем()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПапкиУчетныхЗаписей.ВидПапки,
		|	ПапкиУчетныхЗаписей.Папка КАК Папка
		|ПОМЕСТИТЬ ВидыПапок
		|ИЗ
		|	РегистрСведений.ПапкиУчетныхЗаписей КАК ПапкиУчетныхЗаписей
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Папка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПапкиПисем.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.Ссылка В (&СписокВыбранныхПапок)
		|			ТОГДА Истина
		|		ИНАЧЕ Ложь
		|	КОНЕЦ КАК Выбрана,
		|	ПапкиПисем.ПометкаУдаления КАК ПометкаУдаления,
		|	ПапкиПисем.Представление КАК Представление,
		|	ПапкиПисем.ВидПапки КАК ВидПапки,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ПометкаУдаления
		|			ТОГДА 1
		|		КОГДА ВидыПапок.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 2
		|		КОГДА ВидыПапок.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 4
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НомерКартинки,
		|	ВЫБОР
		|		КОГДА ВидыПапок.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Входящие)
		|			ТОГДА 1
		|		КОГДА ВидыПапок.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Исходящие)
		|			ТОГДА 2
		|		КОГДА ВидыПапок.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Отправленные)
		|			ТОГДА 3
		|		КОГДА ВидыПапок.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 5
		|		КОГДА ВидыПапок.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 6
		|		ИНАЧЕ 7
		|	КОНЕЦ КАК Порядок,
		|	ПапкиПисем.ВариантОтображенияКоличестваПисем,");
		
	Если ОтображатьТолькоМоиПапкиПисем Тогда
		Запрос.Текст = Запрос.Текст +
			"
			|	ЛОЖЬ КАК ПапкаБыстрогоДоступа";
	Иначе
		Запрос.Текст = Запрос.Текст +
			"
			|ВЫБОР
			|	КОГДА ПапкиПисемБыстрогоДоступа.Папка ЕСТЬ NULL 
			|		ТОГДА ЛОЖЬ
			|	ИНАЧЕ ИСТИНА
			|КОНЕЦ КАК ПапкаБыстрогоДоступа"
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст +
		"
		|ИЗ
		|	Справочник.ПапкиПисем КАК ПапкиПисем
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
		|	ПО (ПапкиПисемБыстрогоДоступа.Папка = ПапкиПисем.Ссылка И ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)
		|	ЛЕВОЕ СОЕДИНЕНИЕ ВидыПапок КАК ВидыПапок
		|	ПО ПапкиПисем.Ссылка = ВидыПапок.Папка
		|ГДЕ
		|	((НЕ ПапкиПисем.ПометкаУдаления)
		|			ИЛИ &ОтображатьУдаленныеПапкиПисем)";
		
	Если ОтображатьТолькоМоиПапкиПисем Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПапкиПисемБыстрогоДоступа.Папка КАК Папка
			|	Поместить ПапкиПисемБыстрогоДоступаПользователя 
			|ИЗ
			|	РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
			|ГДЕ
			|	ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь		
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|" + Запрос.Текст +
			"
			|	И ПапкиПисем.Ссылка В ИЕРАРХИИ
			|		(ВЫБРАТЬ
			|			ПапкиПисемБыстрогоДоступа.Папка
			|		ИЗ
			|			ПапкиПисемБыстрогоДоступаПользователя КАК ПапкиПисемБыстрогоДоступа)";
	КонецЕсли;
		
	Запрос.Текст = Запрос.Текст +
		"
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ";
		
	Запрос.УстановитьПараметр("ОтображатьУдаленныеПапкиПисем", ОтображатьУдаленныеПапкиПисем);
	Запрос.УстановитьПараметр("ТекущийПользователь", ТекущийПользователь);
		
	Запрос.УстановитьПараметр("СписокВыбранныхПапок", ПапкиПисемДляСинхронизацииПриОткрытии.ВыгрузитьЗначения());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);

	// Администратору как правило доступны все папки, однако если мы смотрим настройки почты для 
	// другого пользователя,то оставим только те папки, которые доступны ему по правам.
	Если Не ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь() Тогда

		МассивПапкоВерхнегоУровня = Новый Массив();

		// обходим папки верхнего уровня
		Для каждого СтрокаПапки Из Дерево.Строки Цикл
			МассивПапкоВерхнегоУровня.Добавить(СтрокаПапки.Ссылка);
		КонецЦикла;

		ПроверяемыеПользователи = Новый Массив();
		ПроверяемыеПользователи.Добавить(ТекущийПользователь);

		ПраваНаОбъекты = 
			ДокументооборотПраваДоступа.ПолучитьПраваПользователейПоОбъектам(
				МассивПапкоВерхнегоУровня, Ложь, ПроверяемыеПользователи);

		Для каждого СтрокаПапки Из Дерево.Строки Цикл

			СтрокаПрав = ПраваНаОбъекты.Найти(СтрокаПапки.Ссылка, "ОбъектДоступа");

			УдалитьСтрокуСписка = Ложь;
			Если СтрокаПрав = Неопределено Тогда
				УдалитьСтрокуСписка = Истина;
			ИначеЕсли Не СтрокаПрав.Чтение Тогда
				УдалитьСтрокуСписка = Истина;
			КонецЕсли;
			
			Если УдалитьСтрокуСписка Тогда
				Дерево.Строки.Удалить(СтрокаПапки);
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	ТекУчетнаяЗапись = Неопределено;
	СтрокаУчетнаяЗапись = Неопределено;
	
	ДеревоПапокПисемОбъект = РеквизитФормыВЗначение("ДеревоПапокПисем");
	ДеревоПапокПисемОбъект.Строки.Очистить();
	ДобавитьПапкиВДерево(ДеревоПапокПисемОбъект.Строки, Дерево.Строки);
	СортироватьИерархически(ДеревоПапокПисемОбъект.Строки, "Порядок, Наименование");
		
	ЗначениеВДанныеФормы(ДеревоПапокПисемОбъект, ДеревоПапокПисем);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПапкиВДерево(ДеревоСтроки, ИсточникСтроки)

	МенеджерПапокПисем = Справочники.ПапкиПисем;

	Для каждого ПапкаИнфо Из ИсточникСтроки Цикл

		СтрокаПапка = ДеревоСтроки.Добавить();

		СтрокаПапка.Ссылка = ПапкаИнфо.Ссылка;
		СтрокаПапка.Выбрана = ПапкаИнфо.Выбрана;
		СтрокаПапка.Наименование = ПапкаИнфо.Представление;
		СтрокаПапка.ПолныйПуть = МенеджерПапокПисем.ПолучитьПолныйПутьПапки(ПапкаИнфо.Ссылка);
		СтрокаПапка.ВидПапки = ПапкаИнфо.ВидПапки;
		СтрокаПапка.Порядок = ПапкаИнфо.Порядок;
		СтрокаПапка.НомерКартинки = ПапкаИнфо.НомерКартинки;
		СтрокаПапка.ВариантОтображенияКоличестваПисем = ПапкаИнфо.ВариантОтображенияКоличестваПисем;
		СтрокаПапка.ПапкаБыстрогоДоступа = ПапкаИнфо.ПапкаБыстрогоДоступа;
		СтрокаПапка.ПометкаУдаления = ПапкаИнфо.ПометкаУдаления;

		ДобавитьПапкиВДерево(СтрокаПапка.Строки, ПапкаИнфо.Строки);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СортироватьИерархически(СтрокиДерева, Знач Колонки)
	
	СтрокиДерева.Сортировать(Колонки);
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			СортироватьИерархически(СтрокаДерева.Строки, Колонки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьРодительскиеПапкиПисем(ЭлементДерева)
	
	Родитель = ЭлементДерева.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		Родитель.Выбрана = Истина;
		ПометитьРодительскиеПапкиПисем(Родитель);
	Иначе
		ПометитьДочерниеПапкиПисем(ЭлементДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьДочерниеПапкиПисем(ЭлементДерева)
	
	ПодчиненныеЭлементыДерева = ЭлементДерева.ПолучитьЭлементы();
	Если ЭлементДерева.ПолучитьРодителя() <> Неопределено Тогда
		Для Каждого ПодчиненныйЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
			ПодчиненныйЭлементДерева.Выбрана = Истина;
			ПометитьДочерниеПапкиПисем(ПодчиненныйЭлементДерева);
		КонецЦикла;
	Иначе
		Для Каждого ПодчиненныйЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
			Если ЭтоСтандартнаяпапкаУчетнойЗаписи(ПодчиненныйЭлементДерева.ВидПапки) Тогда
				ПодчиненныйЭлементДерева.Выбрана = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСДочернихПапокПисем(ЭлементДерева)
	
	ПодчиненныеЭлементыДерева = ЭлементДерева.ПолучитьЭлементы();
	Для Каждого ПодчиненныйЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
		ПодчиненныйЭлементДерева.Выбрана = Ложь;
		СнятьОтметкуСДочернихПапокПисем(ПодчиненныйЭлементДерева);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСРодительскихПапокПисем(ЭлементДерева)
	
	Родитель = ЭлементДерева.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		Родитель.Выбрана = Ложь;
		Если Родитель.ПолучитьРодителя() = Неопределено Тогда
			СнятьОтметкуСДочернихПапокПисем(Родитель);
		Иначе
			СнятьОтметкуСРодительскихПапокПисем(Родитель)
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоСтандартнаяПапкаУчетнойЗаписи(ВидПапки)

	Возврат ЗначениеЗаполнено(ВидПапки)
		И (ВидПапки = ПредопределенноеЗначение("Перечисление.ВидыПапокПисем.Входящие")
		Или ВидПапки = ПредопределенноеЗначение("Перечисление.ВидыПапокПисем.Исходящие")
		Или ВидПапки = ПредопределенноеЗначение("Перечисление.ВидыПапокПисем.Отправленные")
		Или ВидПапки = ПредопределенноеЗначение("Перечисление.ВидыПапокПисем.Черновики"));

КонецФункции

#КонецОбласти

#КонецОбласти

