///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// При закрытии формы необходимо произвести два действия:
//   - если ответ от сервиса не получен, будет создано
//     регламентное задание
//   - при закрытии формы необходимо передать состояние
//     подключения.
&НаКлиенте
Перем ОтказПриЗакрытии Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Идентификатор) Тогда
		ТекстИсключения = НСтр("ru = 'Не заполнен идентификатор сервиса сопровождения.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ОписательСервиса = Справочники.ИдентификаторыСервисовСопровождения.ОписательСервисСопровожденияПоИдентификатору(
		Параметры.Идентификатор);
	
	ДанныеПодключения = Новый Структура;
	ДанныеПодключения.Вставить("ФормаЗаполнена",                Ложь);
	ДанныеПодключения.Вставить("ОписательСервиса",              ОписательСервиса);
	ДанныеПодключения.Вставить("ТестовыеПериоды",               Новый Соответствие);
	ДанныеПодключения.Вставить("ИдентификаторЗапроса",          "");
	ДанныеПодключения.Вставить("КоличествоИтерацийПроверки",    0);
	ДанныеПодключения.Вставить("РежимРегламентногоЗадания",     Ложь);
	ДанныеПодключения.Вставить("НовыеЭлементыФормы",            Новый Массив);
	
	ЗаполнитьДанныеШапкиФормы(ОписательСервиса);
	
	ОтобразитьРезультат = Параметры.ОтобразитьРезультат;
	Если ОтобразитьРезультат Тогда
		ОтобразитьРезультатПодключения(
			Параметры.ПараметрыОтображения);
	Иначе
		ОписательПодключения = Неопределено;
		Параметры.Свойство("ОписательПодключения", ОписательПодключения);
		ЗаполнитьДанныеФормы(ОписательПодключения);
	КонецЕсли;
	
	// На размер формы влияют два параметра:
	//  - Описание сервиса сопровождения;
	//  - Количество доступных тестовых периодов.
	КлючСохраненияПоложенияОкна = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"%1_%2",
		Строка(ДанныеПодключения.ОписательСервиса.СервисСопровождения),
		ДанныеПодключения.ТестовыеПериоды.Количество());
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Если ПоказатьВопросПриЗавершенииРаботыПрограммы() Тогда
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru = 'Подключение тестового периода сервиса не завершено.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не ОтказПриЗакрытии = Ложь Тогда
		СтандартнаяОбработка = Ложь;
		ПодключениеСервисовСопровожденияКлиент.ЗакрытьФормуПодключенияТестовыхПериодов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключить(Команда)
	
	ДанныеПодключения.КоличествоИтерацийПроверки = 0;
	Если СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение") Тогда
		УстановитьВидимостьДоступность(
			ЭтотОбъект,
			СостояниеПодключения,
			Истина);
		ПодключитьТестовыйПериод();
	Иначе
		Если ОтобразитьРезультат Тогда
			ПодключениеСервисовСопровожденияВызовСервера.УдалитьИнформациюОЗапросеНаПодключение(
				ДанныеПодключения.ОписательСервиса.СервисСопровождения,
				ДанныеПодключения.ИдентификаторЗапроса);
		КонецЕсли;
		Если ПодключениеДоступно(СостояниеПодключения) Тогда
			СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.НеПодключен");
			Если Не ДанныеПодключения.ФормаЗаполнена Тогда
				ЗаполнитьДанныеФормы();
			Иначе
				УстановитьВидимостьДоступность(
					ЭтотОбъект,
					СостояниеПодключения,
					Истина);
				ПодключитьТестовыйПериод();
			КонецЕсли;
		Иначе
			ПодключениеСервисовСопровожденияКлиент.ЗакрытьФормуПодключенияТестовыхПериодов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если ОтобразитьРезультат
		И СостояниеПодключения <> ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение") Тогда
		ПодключениеСервисовСопровожденияВызовСервера.УдалитьИнформациюОЗапросеНаПодключение(
			ДанныеПодключения.ОписательСервиса.СервисСопровождения,
			ДанныеПодключения.ИдентификаторЗапроса);
	КонецЕсли;
	
	ПодключениеСервисовСопровожденияКлиент.ЗакрытьФормуПодключенияТестовыхПериодов(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодключениеТестовогоПериода

&НаКлиенте
Процедура ПодключитьТестовыйПериод()
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Если Не ЗначениеЗаполнено(ДанныеПодключения.ИдентификаторЗапроса) Тогда
		
		РезультатВыполнения = ПодключитьТестовыйПериодНаСервере(
			ИдентификаторТестовогоПериода,
			ДанныеПодключения.ОписательСервиса.СервисСопровождения,
			ЭтотОбъект.УникальныйИдентификатор);
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения(
			"ПодключитьТестовыйПериодЗавершение",
			ЭтотОбъект);
		
		Если РезультатВыполнения.Статус = "Выполнено" Тогда
			ПодключитьТестовыйПериодЗавершение(РезультатВыполнения, Неопределено);
			Возврат;
		КонецЕсли;
		
	Иначе
		
		Если ДанныеПодключения.КоличествоИтерацийПроверки >= 3 Тогда
			УстановитьВидимостьДоступность(ЭтотОбъект, СостояниеПодключения);
			Возврат;
		КонецЕсли;
		
		РезультатВыполнения = ПроверитьПодключениеТестовогоПериодаНаСервере(
			ДанныеПодключения.ОписательСервиса.СервисСопровождения,
			ДанныеПодключения.ИдентификаторЗапроса,
			ЭтотОбъект.УникальныйИдентификатор,
			ДанныеПодключения.РежимРегламентногоЗадания,
			ИдентификаторТестовогоПериода,
			ДанныеПодключения.КоличествоИтерацийПроверки);
		
		Если РезультатВыполнения.Статус = "Выполнено" Тогда
			ПроверитьПодключениеТестовогоПериодаЗавершение(РезультатВыполнения, Неопределено);
			Возврат;
		КонецЕсли;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения(
			"ПроверитьПодключениеТестовогоПериодаЗавершение",
			ЭтотОбъект);
		
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьТестовыйПериодЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатОперации.Ошибка Тогда
			ИнформацияОбОшибке   = РезультатОперации.ИнформацияОбОшибке;
			СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
			НастроитьОтображениеФормы(ЭтотОбъект);
		Иначе
			СостояниеПодключения                   = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение");
			ДанныеПодключения.ИдентификаторЗапроса = РезультатОперации.ИдентификаторЗапроса;
			ПодключитьОбработчикОжидания("ПодключитьТестовыйПериод", 10, Истина);
		КонецЕсли;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке   = Результат.КраткоеПредставлениеОшибки;
		СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
		НастроитьОтображениеФормы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодключитьТестовыйПериодНаСервере(
		Знач Идентификатор,
		Знач СервисСопровождения,
		Знач УникальныйИдентификатор)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Идентификатор",       Идентификатор);
	ПараметрыПроцедуры.Вставить("СервисСопровождения", СервисСопровождения);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Подключение тестового периода (activate).'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ПодключениеСервисовСопровождения.ПодключитьТестовыйПериод",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьПодключениеТестовогоПериодаЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатОперации.Ошибка Тогда
			ИнформацияОбОшибке        = РезультатОперации.ИнформацияОбОшибке;
			СостояниеПодключения      = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
			НастроитьОтображениеФормы(ЭтотОбъект);
		Иначе
			РезультатПодключения = РезультатОперации.РезультатПодключения;
			Если РезультатПодключения.Ошибка Тогда
				ИнформацияОбОшибке   = РезультатПодключения.ИнформацияОбОшибке;
				СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
				НастроитьОтображениеФормы(ЭтотОбъект);
				// Необходимо перезаполнение данных формы,
				// т.к. дальнейшая проверка состояние запроса
				// ничего не даст.
				ДанныеПодключения.Вставить("ФормаЗаполнена",   Ложь);
			ИначеЕсли РезультатПодключения.Подключен Тогда
				СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен");
				НастроитьОтображениеФормы(ЭтотОбъект);
			Иначе
				Если ДанныеПодключения.КоличествоИтерацийПроверки >= 3 Тогда
					СостояниеПодключения       = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение");
					НастроитьОтображениеФормы(ЭтотОбъект);
				Иначе
					ПодключитьОбработчикОжидания(
						"ПодключитьТестовыйПериод", 
						(ДанныеПодключения.КоличествоИтерацийПроверки*10),
						Истина);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке   = Результат.КраткоеПредставлениеОшибки;
		СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
		НастроитьОтображениеФормы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьПодключениеТестовогоПериодаНаСервере(
		Знач СервисСопровождения,
		Знач Идентификатор,
		Знач УникальныйИдентификатор,
		Знач РежимРегламентногоЗадания,
		Знач ИдентификаторТестовогоПериода,
		КоличествоИтерацийПроверки)
	
	КоличествоИтерацийПроверки = КоличествоИтерацийПроверки + 1;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("СервисСопровождения",           СервисСопровождения);
	ПараметрыПроцедуры.Вставить("Идентификатор",                 Идентификатор);
	ПараметрыПроцедуры.Вставить("РежимРегламентногоЗадания",     РежимРегламентногоЗадания);
	ПараметрыПроцедуры.Вставить("ИдентификаторТестовогоПериода", ИдентификаторТестовогоПериода);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Проверка состояния подключения тестового периода.'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"ПодключениеСервисовСопровождения.ПроверитьСостояниеЗапросаНаПодключение",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПодключениеДоступно(Знач СостояниеПодключения)
	
	Подключить = (СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.НеПодключен")
		Или СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения"));
	
	Возврат Подключить;
	
КонецФункции

#КонецОбласти

#Область УправлениеФормой

&НаСервере
Процедура ЗаполнитьДанныеФормы(ОписательПодключения = Неопределено)
	
	ОписательСервиса = ДанныеПодключения.ОписательСервиса;
	Если ОписательПодключения = Неопределено Тогда
		ОписательПодключения = ПодключениеСервисовСопровождения.ТестовыеПериодыСервисаСопровождения(
			ОписательСервиса.Идентификатор);
	КонецЕсли;
	
	Если Не ОписательПодключения.Ошибка Тогда
		Если ОписательПодключения.ПодключениеДоступно Тогда
			Элементы.СтраницыПодключения.ТекущаяСтраница = Элементы.ГруппаДоступныеТестовыеПериоды;
			СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.НеПодключен");
			ДобавитьЭлементыТестовыхПериодов(ОписательПодключения, ОписательСервиса);
		Иначе
			СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно");
		КонецЕсли;
	Иначе
		СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
		ИнформацияОбОшибке   = ОписательПодключения.ИнформацияОбОшибке;
		ДанныеПодключения.Вставить("ФормаЗаполнена",   Ложь);
		ДанныеПодключения.Вставить("ТестовыеПериоды", Новый Соответствие);
	КонецЕсли;
	
	НастроитьОтображениеФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПодключения(ПараметрыОтображения)
	
	ДанныеПодключения.ИдентификаторЗапроса = ПараметрыОтображения.ИдентификаторЗапроса;
	ИдентификаторТестовогоПериода          = ПараметрыОтображения.ИдентификаторТестовогоПериода;
	СостояниеПодключения                   = ПараметрыОтображения.СостояниеПодключения;
	
	Если СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения") Тогда
		ИнформацияОбОшибке = ПараметрыОтображения.ИнформацияОбОшибке;
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен") Тогда
		Элементы.ДекорацияНадписьПодключен.Заголовок = НСтр("ru = 'Сервис успешно подключен.'");
		ДанныеПодключения.Вставить("ФормаЗаполнена",  Истина);
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение") Тогда
		// Если истина, после получения подтверждения,
		// будет удалена информация о запросе РС "ИдентификаторыЗапросовНаПодключение"
		// и регламентное задание "ПодключениеТестовыхПериодов".
		ДанныеПодключения.РежимРегламентногоЗадания = ПараметрыОтображения.РежимРегламентногоЗадания;
	КонецЕсли;
	
	НастроитьОтображениеФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОтображениеФормы(Форма)
	
	Элементы             = Форма.Элементы;
	СостояниеПодключения = Форма.СостояниеПодключения;
	
	Если СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения") Тогда
		Элементы.ДекорацияИнформацияОбОшибке.Заголовок = Форма.ИнформацияОбОшибке;
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен") Тогда
		Элементы.ДекорацияНадписьПодключен.Заголовок = НСтр("ru = 'Сервис успешно подключен.'");
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно") Тогда
		Элементы.ДекорацияИнформацияОбОшибке.Заголовок = НСтр("ru = 'Ошибка при получении доступных тестовых периодов:
			|Не обнаружены доступные тестовые периоды.'")
	КонецЕсли;
	
	УстановитьВидимостьДоступность(Форма, СостояниеПодключения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма, Знач СостояниеПодключения, Знач Подключение = Ложь)
	
	Элементы        = Форма.Элементы;
	
	Если Подключение Тогда
		Элементы.СтраницыПодключения.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация;
		Элементы.ФормаПодключить.Видимость           = Ложь;
		Элементы.ФормаОтмена.Видимость               = Ложь;
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения") Тогда
		Элементы.СтраницыПодключения.ТекущаяСтраница = Элементы.ГруппаОшибка;
		Элементы.ФормаПодключить.Видимость           = Истина;
		Элементы.ФормаОтмена.Видимость               = Истина;
		Элементы.ФормаОтмена.Заголовок               = НСтр("ru = 'Закрыть'");
		Элементы.ФормаПодключить.Заголовок           = НСтр("ru = 'Повторить попытку'");
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение") Тогда
		Элементы.СтраницыПодключения.ТекущаяСтраница = Элементы.ГруппаОшибкаТаймаут;
		Элементы.ФормаОтмена.Видимость               = Истина;
		Элементы.ФормаОтмена.Заголовок               = НСтр("ru = 'Закрыть'");
		Элементы.ФормаПодключить.Видимость           = Истина;
		Элементы.ФормаПодключить.Заголовок           = НСтр("ru = 'Проверить подключение'");
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен") Тогда
		Элементы.СтраницыПодключения.ТекущаяСтраница = Элементы.ГруппаПодключенТестовыйПериод;
		Элементы.ФормаПодключить.Видимость           = Истина;
		Элементы.ФормаОтмена.Видимость               = Ложь;
		Элементы.ФормаПодключить.Заголовок           = НСтр("ru = 'OK'");
	ИначеЕсли СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно") Тогда
		Элементы.ФормаПодключить.Видимость           = Ложь;
	ИначеЕсли ПодключениеДоступно(СостояниеПодключения) Тогда
		Элементы.СтраницыПодключения.ТекущаяСтраница = Элементы.ГруппаДоступныеТестовыеПериоды;
		Элементы.ФормаПодключить.Видимость           = Истина;
		Элементы.ФормаОтмена.Видимость               = Истина;
		Элементы.ФормаОтмена.Заголовок               = НСтр("ru = 'Отменить'");
		Элементы.ФормаПодключить.Заголовок           = НСтр("ru = 'Подключить'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоказатьВопросПриЗавершенииРаботыПрограммы()
	
	Возврат (СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение")
		Или Элементы.СтраницыПодключения.ТекущаяСтраница = Элементы.ГруппаДлительнаяОперация);
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеФормы

// Заполняет заголовок формы, описание сервиса и картинку сервиса.
//
// Параметры:
//  ОписательПодключения  - Структура - см. ДоступныеТестовыеПериоды;
//
&НаСервере
Процедура ЗаполнитьДанныеШапкиФормы(ОписательСервиса)
	
	// Оформление шапки.
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Подключение сервиса %1'"),
		ОписательСервиса.Наименование);
	
	Если ОписательСервиса.Картинка <> Неопределено Тогда
		Элементы.КартинкаСервиса.Картинка = ОписательСервиса.Картинка;
	КонецЕсли;
	
	Элементы.ОписаниеСервиса.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '<b>Возможности сервиса:</b>
				|%1 <a href = ""%2"">Подробнее</a>.'"),
			ОписательСервиса.Описание,
			ОписательСервиса.URLОписание));
	
КонецПроцедуры

// Создает поля формы, которые используются для выбора тестового периода, а также
// поля описаний тестовых периодов.
//
// Параметры:
//  ОписательПодключения  - Структура - см. ДоступныеТестовыеПериоды();
//  ОписательСервиса      - Структура - см. ПодключениеСервисовСопровождения.НовыйОписательСервиса();
//
&НаСервере
Процедура ДобавитьЭлементыТестовыхПериодов(ОписательПодключения, ОписательСервиса)
	
	ТестовыеПериоды   = Новый Соответствие;
	
	// Перед добавлением новых элементов формы и реквизитов
	// будут удалены ранее добавленные элементы и реквизиты.
	Для каждого ИмяЭлемента Из ДанныеПодключения.НовыеЭлементыФормы Цикл
		Элементы.Удалить(Элементы[ИмяЭлемента]);
	КонецЦикла;
	
	// Данные будут рассчитаны заново.
	ДанныеПодключения.ИдентификаторЗапроса          = "";
	ДанныеПодключения.КоличествоИтерацийПроверки    = 0;
	ДанныеПодключения.РежимРегламентногоЗадания     = Ложь;
	ДанныеПодключения.НовыеЭлементыФормы            = Новый Массив;
	
	// Создание новых элементов форм.
	ГруппаФормы  = Элементы.ГруппаДоступныеТестовыеПериоды;
	НовыйЭлемент = Элементы.Добавить(НСтр("ru = 'ЗаголовокТестовыеПериоды'"), Тип("ДекорацияФормы"), ГруппаФормы);
	НовыйЭлемент.Вид        = ВидДекорацииФормы.Надпись;
	НовыйЭлемент.Заголовок  = Новый ФорматированнаяСтрока(
		СтроковыеФункции.ФорматированнаяСтрока(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Подключите <a href = ""%1"">бесплатно</a>:'"),
				ОписательСервиса.URLУсловияПолучения)),
		ШрифтыСтиля.ШрифтЗаголовковПодключенияТестовыхПериодов);
	ДанныеПодключения.НовыеЭлементыФормы.Добавить(НовыйЭлемент.Имя);
	
	Если ОписательПодключения.ТестовыеПериоды.Количество() = 1 Тогда
		
		ОписательТестовогоПериода = ОписательПодключения.ТестовыеПериоды[0];
		
		ИмяПоляНаименования      = НСтр("ru = 'ТестовыйПериод1'");
		ИмяГруппыНаименования    = НСтр("ru = 'ГруппаНаименование1'");
		ИмяГруппыОписания        = НСтр("ru = 'ГруппаОписание1'");
		ИмяПоляОписания          = НСтр("ru = 'Описание1'");
		
		ГруппаНаименование = Элементы.Добавить(ИмяГруппыНаименования, Тип("ГруппаФормы"), ГруппаФормы);
		ГруппаНаименование.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаНаименование.Отображение         = ОтображениеОбычнойГруппы.Нет;
		ГруппаНаименование.ОтображатьЗаголовок = Ложь;
		ГруппаНаименование.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ДанныеПодключения.НовыеЭлементыФормы.Добавить(ГруппаНаименование.Имя);
		
		НовыйЭлемент = Элементы.Добавить(ИмяПоляНаименования, Тип("ДекорацияФормы"), ГруппаНаименование);
		НовыйЭлемент.Вид        = ВидДекорацииФормы.Надпись;
		НовыйЭлемент.Заголовок  = ОписательТестовогоПериода.Наименование;
		
		ГруппаОписание = Элементы.Добавить(ИмяГруппыОписания, Тип("ГруппаФормы"), ГруппаФормы);
		ГруппаОписание.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаОписание.Отображение         = ОтображениеОбычнойГруппы.Нет;
		ГруппаОписание.ОтображатьЗаголовок = Ложь;
		ГруппаОписание.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ДанныеПодключения.НовыеЭлементыФормы.Добавить(ГруппаОписание.Имя);
		
		НовыйЭлемент = Элементы.Добавить(ИмяПоляОписания, Тип("ДекорацияФормы"), ГруппаОписание);
		НовыйЭлемент.Вид        = ВидДекорацииФормы.Надпись;
		НовыйЭлемент.Заголовок  = ОписательТестовогоПериода.Описание;
		НовыйЭлемент.Шрифт      = ШрифтыСтиля.МелкийШрифтТекста;
		НовыйЭлемент.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
		
		ТестовыеПериоды.Вставить(
			ОписательТестовогоПериода.Идентификатор,
			ОписательТестовогоПериода.Наименование);
		
	Иначе
		Сч = 1;
		Для Каждого ОписательТестовогоПериода Из ОписательПодключения.ТестовыеПериоды Цикл
			
			ИмяПоляНаименования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'ТестовыйПериод%1'"),
				Сч);
			ИмяГруппыОписания   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'ГруппаОписание%1'"),
				Сч);
			ИмяПоляОписания     = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Описание%1'"),
				Сч);
			
			НовыйЭлемент = Элементы.Добавить(ИмяПоляНаименования, Тип("ПолеФормы"), ГруппаФормы);
			НовыйЭлемент.ПутьКДанным        = "ИдентификаторТестовогоПериода";
			НовыйЭлемент.Вид                = ВидПоляФормы.ПолеПереключателя;
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			ДанныеПодключения.НовыеЭлементыФормы.Добавить(НовыйЭлемент.Имя);
			
			НовыйЭлемент.СписокВыбора.Добавить(
				ОписательТестовогоПериода.Идентификатор,
				ОписательТестовогоПериода.Наименование);
			
			ГруппаОписание = Элементы.Добавить(ИмяГруппыОписания, Тип("ГруппаФормы"), ГруппаФормы);
			ГруппаОписание.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаОписание.Отображение         = ОтображениеОбычнойГруппы.Нет;
			ГруппаОписание.ОтображатьЗаголовок = Ложь;
			ГруппаОписание.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
			ДанныеПодключения.НовыеЭлементыФормы.Добавить(ГруппаОписание.Имя);
			
			НовыйЭлемент = Элементы.Добавить(ИмяПоляОписания, Тип("ДекорацияФормы"), ГруппаОписание);
			НовыйЭлемент.Вид        = ВидДекорацииФормы.Надпись;
			НовыйЭлемент.Заголовок  = ОписательТестовогоПериода.Описание;
			НовыйЭлемент.Шрифт      = ШрифтыСтиля.МелкийШрифтТекста;
			НовыйЭлемент.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
			
			ТестовыеПериоды.Вставить(
				ОписательТестовогоПериода.Идентификатор,
				ОписательТестовогоПериода.Наименование);
			
			Сч = Сч + 1;
		КонецЦикла;
	КонецЕсли;
	
	ДанныеПодключения.НовыеЭлементыФормы  = ОбщегоНазначенияКлиентСервер.СвернутьМассив(
		ДанныеПодключения.НовыеЭлементыФормы);
	
	// Установка значений по умолчанию.
	Если ОписательПодключения.ТестовыеПериоды.Количество() > 0 Тогда
		ОписательТестовогоПериода           = ОписательПодключения.ТестовыеПериоды[0];
		ИдентификаторТестовогоПериода = ОписательТестовогоПериода.Идентификатор;
	КонецЕсли;
	
	ДанныеПодключения.Вставить("ФормаЗаполнена",  Истина);
	ДанныеПодключения.Вставить("ТестовыеПериоды", ТестовыеПериоды);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
