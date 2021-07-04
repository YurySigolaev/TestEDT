&НаКлиенте
Перем МенеджерКриптографии;

&НаКлиенте
Перем СертификатКриптографии;

&НаКлиенте
Перем КонтекстЭДОКлиент;


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнициализироватьДанные(Параметры);
	ИнициализироватьОформлениеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЭтоОбновление ИЛИ ЭтоОтправка Тогда
		ПодключитьОбработчикОжидания("Подключаемый_НачатьПолучениеСертификата", 1, Истина);
	КонецЕсли;
	
	// инициализируем контекст ЭДО
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеСертификатаОчистка(Элемент, СтандартнаяОбработка)
	
	ОчиститьСертификат();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СертификатНачалоВыбора_ПослеВыбораСертификата", 
		ЭтотОбъект);
		
	ДопПараметры = ПараметрыВыбораСертификата();

	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ВыборСертификатовОблачныхИлиЛокальных",
		ДопПараметры,
		ЭтотОбъект,
		,
		,
		,
		ОписаниеОповещения, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЗаявку(Команда)
	
	НоваяЗаявка = КопияЗаявки();
	ПоказатьЗначение(,НоваяЗаявка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояние(Команда)
	
	ПоказатьСтраницуДлительногоДействия();
	ПодключитьОбработчикОжидания("Подключаемый_НачатьПолучениеСертификата", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеНапоминать(Команда)
	БольшеНеНапоминатьНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСертификатаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранныйСертификат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредставлениеСертификатаОткрытие_ПослеПолученияДвДанных", 
		ЭтотОбъект);
	
	КриптографияЭДКОКлиент.ЭкспортироватьСертификатВBase64(ОписаниеОповещения, ВыбранныйСертификат, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСертификатаОткрытие_ПослеПолученияДвДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено 
		И Результат.Выполнено 
		И ВыбранныйСертификат <> Неопределено Тогда
		
		ДвДанные = Base64Значение(Результат.СтрокаBase64);
		
		Адрес = ПоместитьВоВременноеХранилище(ДвДанные, Новый УникальныйИдентификатор);
	
		Сертификат = Новый Структура();
		Сертификат.Вставить("Адрес", Адрес);
		
		КриптографияЭДКОКлиент.ПоказатьСертификат(Сертификат, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявку(Команда)
	
	Если ВыбранныйСертификат = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите сертификат'"),,"ПредставлениеСертификата");
		Возврат;  
	КонецЕсли;
	
	ПоказатьСтраницуДлительногоДействия();
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтправитьЗаявку_ПослеПолученияСвойствСертификата", 
		ЭтотОбъект);
		
	РасчитатьСведенияВыбранногоСертификата(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновитьСтатусЗаявки

&НаКлиенте
Процедура ОбновитьСтатусЗаявки(ВходящийКонтекст)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбновитьСтатусЗаявки_ПроверитьСостояние",
		ЭтотОбъект); 
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	
	ДлительнаяОперация = НачатьОбновлениеСтатусаЗаявки(ВходящийКонтекст);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьОбновлениеСтатусаЗаявки(ВходящийКонтекст)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = Обновление статуса заявки в фоне'");
	ПараметрыВыполнения.ОжидатьЗавершение = Истина;
	
	ВходящийКонтекст.Вставить("Заявка", Заявка);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ЗаявкиНаЛьготныйКредит.ОбновитьСтатусЗаявкиВФоне", 
		ВходящийКонтекст, 
		ПараметрыВыполнения);

КонецФункции

&НаКлиенте
Процедура ОбновитьСтатусЗаявки_ПроверитьСостояние(ДлительнаяОперация, ВходящийКонтекст) Экспорт
	
	Если ДлительнаяОперация <> Неопределено И
		(ДлительнаяОперация.Статус = "Выполнено") Тогда
		
		Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		
		Если Результат.Выполнено Тогда
			
			ОдобреноИлиОтклонено = 
				Результат.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЛьготныхЗаявок.ОдобреноБанком")
				ИЛИ Результат.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЛьготныхЗаявок.ОтклоненоБанком");
			
			Если (ЭтоПредупреждение ИЛИ ЭтоОбновление) И ОдобреноИлиОтклонено Тогда
				Результат.Вставить("ТребуетВнимания", Ложь);
			КонецЕсли;
				
			СохранитьРеквизитыЗаявки(Результат);
			ОповеститьОбИзменении(Заявка);
			
			Если ЭтоОбновление Тогда
				ПоказатьРезультатОбновленияСтатуса();
			ИначеЕсли ЭтоПредупреждение Тогда
				ПоказатьСтраницуРезультатОбновленияОдобреннойЗаявки();
			КонецЕсли;
			
		Иначе
			ПоказатьОшибку(Результат.ОписаниеОшибки, Результат.ОшибкаСервера);
		КонецЕсли;
			
	ИначеЕсли ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Ошибка" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Подробности ошибки смотрите в журнале регистрации'");
		ПоказатьОшибку(ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРеквизитыЗаявки(Результат)
	
	Документы.ЗаявкиНаЛьготныйКредит.СохранитьРеквизитыЗаявки(Заявка, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучитьДанныеДляПодписания

&НаКлиенте
Процедура ПолучитьДанныеДляПодписанияИТокен()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучитьДанныеДляПодписанияИТокен_ПроверитьСостояние",
		ЭтотОбъект); 
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	
	ДлительнаяОперация = НачатьПолучениеДанныхДляПодписанияИТокена();
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьПолучениеДанныхДляПодписанияИТокена()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = Получение данных для подписания'");
	ПараметрыВыполнения.ОжидатьЗавершение = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ЗаявкиНаЛьготныйКредит.ПолучитьДанныеДляПодписанияИТокенВФоне", 
		ВыбранныйСертификат.SubjectKeyId, 
		ПараметрыВыполнения);

КонецФункции

&НаКлиенте
Процедура ПолучитьДанныеДляПодписанияИТокен_ПроверитьСостояние(ДлительнаяОперация, ВходящийКонтекст) Экспорт
	
	Если ДлительнаяОперация <> Неопределено И
		(ДлительнаяОперация.Статус = "Выполнено") Тогда
		
		Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		
		Если Результат.Выполнено Тогда
			ПодписатьДанные(Результат);
		Иначе
			ПоказатьОшибку(Результат.ОписаниеОшибки, Результат.ОшибкаСервера);
		КонецЕсли;

			
	ИначеЕсли ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Ошибка" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Подробности ошибки смотрите в журнале регистрации'");
		ПоказатьОшибку(ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускПолученияДанныхДляПодписанияИТокена()
	
	ПоказатьСтраницуДлительногоДействия();
	
	ПодключитьОбработчикОжидания("Подключаемый_ПолучитьДанныеДляПодписанияИТокен", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолучитьДанныеДляПодписанияИТокен()
	ПолучитьДанныеДляПодписанияИТокен();
КонецПроцедуры

#КонецОбласти

#Область ОтправитьЗаявкуОператору

&НаКлиенте
Процедура ОтправитьЗаявкуОператору(ВходящийКонтекст)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтправитьЗаявкуОператору_ПроверитьСостояние",
		ЭтотОбъект); 
		
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.Интервал = 1;
	
	ДлительнаяОперация = НачатьОтправкуЗаявкиОператору(ВходящийКонтекст);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьОтправкуЗаявкиОператору(ВходящийКонтекст)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = Отправка заявки в фоне'");
	ПараметрыВыполнения.ОжидатьЗавершение = Истина;
	
	ВходящийКонтекст.Вставить("Заявка", Заявка);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"Документы.ЗаявкиНаЛьготныйКредит.ОтправитьЗаявкуОператоруВФоне", 
		ВходящийКонтекст, 
		ПараметрыВыполнения);

КонецФункции

&НаКлиенте
Процедура ОтправитьЗаявкуОператору_ПроверитьСостояние(ДлительнаяОперация, ВходящийКонтекст) Экспорт
	
	Если ДлительнаяОперация <> Неопределено И
		(ДлительнаяОперация.Статус = "Выполнено") Тогда
		
		Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		
		Если Результат.Выполнено Тогда

			ДопПараметры = Новый Структура();
			ДопПараметры.Вставить("ИдентификаторЗаявки", Результат.ИдентификаторЗаявки);
			ДопПараметры.Вставить("ОтпечатокСертификата", ВыбранныйСертификат.Отпечаток);
			ДопПараметры.Вставить("Состояние", ПредопределенноеЗначение("Перечисление.СостоянияЛьготныхЗаявок.ОтправленоВФНС"));
			ДопПараметры.Вставить("Дата", ТекущаяДата());
			
			СохранитьРеквизитыЗаявки(ДопПараметры);
			ОповеститьОбИзменении(Заявка);
		
			ПоказатьСтраницуУспех();
		Иначе
			ПоказатьОшибку(Результат.ОписаниеОшибки, Результат.ОшибкаСервера);
		КонецЕсли;
			
	ИначеЕсли ДлительнаяОперация <> Неопределено
		И ДлительнаяОперация.Статус = "Ошибка" Тогда
		
		ОписаниеОшибки = НСтр("ru = 'Подробности ошибки смотрите в журнале регистрации'");
		ПоказатьОшибку(ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Подписание

&НаСервере
Функция ДвДанныеДляПодписания(ДляПодписанияСтрокой)
	
	ДвДанные = ПолучитьДвоичныеДанныеИзСтроки(ДляПодписанияСтрокой, "UTF-8", Ложь);
	
	Возврат ДвДанные;
		
КонецФункции

&НаКлиенте
Процедура ПодписатьДанные(ДанныеИТокен)
	
	Если ВыбранныйСертификат.ЭтоЭлектроннаяПодписьВМоделиСервиса Тогда
		ПодписатьДанныеВМоделиСервиса(ДанныеИТокен);
	Иначе
		ПодписатьДанныеМетодомПлатформы(ДанныеИТокен);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьДанныеМетодомПлатформы(ДанныеИТокен)
	
	// Нельзя объединять оповещения, так как параметры оповещения различные
	Оповещение = Новый ОписаниеОповещения(
		"ПодписатьДанныеМетодомПлатформы_ПослеПодписания", 
		ЭтотОбъект, 
		ДанныеИТокен,
		"ПодписатьДанныеМетодомПлатформы_ОбработчикОшибкиПодписания",
		ЭтотОбъект);
			
	ДвДанные = ДвДанныеДляПодписания(ДанныеИТокен.ДанныеДляПодписи);
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = Пароль;
	КонецЕсли;
	
	// Методом платформы, так как компонента не подписывает сертификатами сторонних УЦ
	МенеджерКриптографии.НачатьПодписывание(
		Оповещение, 
		ДвДанные, 
		СертификатКриптографии);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПодписатьДанныеМетодомПлатформы_ПослеПодписания(ПодписанноеСообщение, ВходящийКонтекст) Экспорт
	
	Если ПодписанноеСообщение = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'Не удалось сформировать цифровую подпись.'");
		ПоказатьОшибку(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	ПодписанноеСообщениеBase64 = Base64Строка(ПодписанноеСообщение);
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ПодписанноеСообщениеBase64", ПодписанноеСообщениеBase64);
	ДопПараметры.Вставить("ТокенДляИдентификации", ВходящийКонтекст.ТокенДляИдентификации);
	
	ВыполнитьДействиеПослеПодписания(ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеПослеПодписания(ДопПараметры) Экспорт
	
	Если ЭтоОтправка Тогда
		ОтправитьЗаявкуОператору(ДопПараметры);
	ИначеЕсли ЭтоОбновление ИЛИ ЭтоПредупреждение Тогда
		ОбновитьСтатусЗаявки(ДопПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьДанныеМетодомПлатформы_ОбработчикОшибкиПодписания(ИнформацияОбОшибке, СтандартнаяОбработка, ВходящийКонтекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ТекстОшибки = КраткоеПредставлениеОшибки(ОбщегоНазначенияЭДКОКлиентСервер.ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке));
	ПоказатьОшибку(ТекстОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьДанныеВМоделиСервиса(ДанныеИТокен)
	
	// Нельзя объединять оповещения, так как параметры оповещения различные
	Оповещение = Новый ОписаниеОповещения(
		"ПодписатьДанныеВМоделиСервиса_ПослеПодписания", 
		ЭтотОбъект,
		ДанныеИТокен);
		
	ДвДанные = ДвДанныеДляПодписания(ДанныеИТокен.ДанныеДляПодписи);
	
	АдресДанных     = ПоместитьВоВременноеХранилище(ДвДанные, Новый УникальныйИдентификатор);
	АдресРезультата = ПоместитьВоВременноеХранилище(, Новый УникальныйИдентификатор);
	
	КриптографияЭДКОКлиент.ПодписатьPKCS7(Оповещение, ВыбранныйСертификат, АдресДанных, Ложь, АдресРезультата,,, Истина);
		
КонецПроцедуры	
		
&НаКлиенте
Процедура ПодписатьДанныеВМоделиСервиса_ПослеПодписания(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат.Выполнено Тогда
		
		ДвДанныеПодписи = ПолучитьИзВременногоХранилища(Результат.ИмяФайлаПодписи);
		
		ПодписанноеСообщениеBase64 = Base64Строка(ДвДанныеПодписи);
		
		ДопПараметры = Новый Структура();
		ДопПараметры.Вставить("ПодписанноеСообщениеBase64", ПодписанноеСообщениеBase64);
		ДопПараметры.Вставить("ТокенДляИдентификации", ВходящийКонтекст.ТокенДляИдентификации);
	
		ВыполнитьДействиеПослеПодписания(ДопПараметры);
		
	ИначеЕсли Результат.ОписаниеОшибки = НСтр("ru = 'Пользователь отказался от ввода пароля'") Тогда
		
		Закрыть();
		
	Иначе
		ПоказатьОшибку(Результат.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПоискСертификатов

&НаКлиенте
Процедура ОчиститьСертификат()
	
	ВыбранныйСертификат      = Неопределено;
	ПредставлениеСертификата = Неопределено;
	МенеджерКриптографии     = Неопределено;
	СертификатКриптографии   = Неопределено;
	Пароль = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуПоискаСертификата(ДополнительныеПараметры, ТекстОшибки)
	
	ОчиститьСертификат();
	ПоказатьОшибкуПоискаСертификата(ТекстОшибки);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачатьПолучениеСертификата()
	
	ДополнительныеПараметрыМетода = Новый Структура;
	ДополнительныеПараметрыМетода.Вставить("ПредлагатьУстановкуВнешнейКомпоненты", Истина);
	ДополнительныеПараметрыМетода.Вставить("ВыводитьСообщения", Ложь);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучитьСертификатыЗавершение", 
		ЭтотОбъект);
		
	КриптографияЭДКОКлиент.ПолучитьСертификаты(ОписаниеОповещения,,ДополнительныеПараметрыМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСертификатыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Выполнено Тогда
		
		ЗаполнитьСписокВсехСертификатов(Результат.Сертификаты);
		ОставитьТолькоНужныеСертификаты();
		
		Если НужныеСертификаты.Количество() = 0 Тогда
			ПоказатьОшибкуОтсутствияСертификатов();
			Возврат;
		КонецЕсли;
		
		НайтиОдинПодходящийСертификат();
		
		ПоказатьСтраницуВводаПароля();
		
	Иначе
		
		ПоказатьОшибкуПоискаСертификата(Результат.ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НайтиОдинПодходящийСертификат() Экспорт
	
	Отпечаток = ОтпечатокТекущегоСертификата();
	
	НайденныйСертификат = Неопределено;
	Для Каждого ТекущийСертификат Из НужныеСертификаты Цикл
		
		Если Отпечаток = ТекущийСертификат.Отпечаток Тогда
			НайденныйСертификат = ТекущийСертификат;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НайденныйСертификат = Неопределено И НужныеСертификаты.Количество() = 1 Тогда
		НайденныйСертификат = НужныеСертификаты[0];
	КонецЕсли;
	
	Если НайденныйСертификат <> Неопределено Тогда
		ЗаполнитьСведенияВыбранногоСертификата(НайденныйСертификат);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьСертификаты_ПослеЗаполненияСведенийВыбранногоСертификата(Результат, ДополнительныеПараметры) Экспорт
	
	ПоказатьСтраницуВводаПароля();
	
КонецПроцедуры

&НаСервере
Функция ОтпечатокТекущегоСертификата()
	
	Отпечаток = "";
	
	Если ЗначениеЗаполнено(Заявка.ОтпечатокСертификата) Тогда
		Отпечаток = Заявка.ОтпечатокСертификата;
	Иначе
	
		УстановитьПривилегированныйРежим(Истина);
		
		Организация = Заявка.Организация;
		Если Организация.ВидОбменаСКонтролирующимиОрганами = Перечисления.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате
			И ЗначениеЗаполнено(Организация.УчетнаяЗаписьОбмена) Тогда
			
			Отпечаток = Организация.УчетнаяЗаписьОбмена.СертификатРуководителя;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Отпечаток;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВсехСертификатов(СписокСертификаты)
	
	// заполняем полную таблицу сертификатов из хранилища
	Для Каждого ЭлементСертификат Из СписокСертификаты Цикл
		НовСтр = ВсеСертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ЭлементСертификат);
	КонецЦикла;
	
	Для Каждого СтрСертификат Из ВсеСертификаты Цикл
		
		СтрСертификат.Поставщик = ЗначениеПоля(СтрСертификат.Поставщик);
		СтрСертификат.СерийныйНомер = ЗначениеПоля(СтрСертификат.СерийныйНомер);
		СтрСертификат.Владелец = ЗначениеПоля(СтрСертификат.Владелец);
		СтрСертификат.Наименование = ЗначениеПоля(СтрСертификат.Наименование);
		СтрСертификат.Отпечаток = нрег(СтрСертификат.Отпечаток);
		
		ПараметрыВладельца = РазложитьСтрокуВладелец(СтрСертификат.ВладелецСтруктура);
		СтрСертификат.ИмяВладельца = ЗначениеПоля(ПараметрыВладельца.Имя);
		СтрСертификат.Организация = ЗначениеПоля(ПараметрыВладельца.Организация);
		СтрСертификат.Должность = ЗначениеПоля(?(ЗначениеЗаполнено(ПараметрыВладельца.Должность) И ПараметрыВладельца.Должность <> "0", ПараметрыВладельца.Должность, ПараметрыВладельца.Подразделение));
		СтрСертификат.EMail = ЗначениеПоля(ПараметрыВладельца.ЭлектроннаяПочта);
		СтрСертификат.ИНН = ЗначениеПоля(ПараметрыВладельца.ИНН);
		СтрСертификат.СНИЛС = ЗначениеПоля(ПараметрыВладельца.СНИЛС);
		
		ПоставщикСтруктура = СтрСертификат.ПоставщикСтруктура;
		Если ПоставщикСтруктура.Свойство("CN") Тогда
			СтрСертификат.Издатель = ПоставщикСтруктура["CN"];
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОставитьТолькоНужныеСертификаты()
	
	Для Каждого ТекущийСертификат Из ВсеСертификаты Цикл
		
		Просрочен = 
			НачалоДня(ТекДата) < НачалоДня(ТекущийСертификат.ДействителенС)
			ИЛИ НачалоДня(ТекДата) > НачалоДня(ТекущийСертификат.ДействителенПо);
			
		ПроверятьИНН = НЕ ЭтоРежимТестирования;
			
		ИННДругой = 
			(СтрДлина(ИНН) = 10 И ИНН <> Сред(ТекущийСертификат.ИНН,3) // Юр лицо 
			ИЛИ СтрДлина(ИНН) = 12 И ИНН <> ТекущийСертификат.ИНН) // ИП
		    И ПроверятьИНН;
			
		НеТоХранилище = ТекущийСертификат.Хранилище.Хранилище <> "MY";
		
		ПропуститьСертификат = Просрочен ИЛИ ИННДругой ИЛИ НеТоХранилище;
			
		Если ПропуститьСертификат Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйСертификат = НужныеСертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйСертификат, ТекущийСертификат);
		НовыйСертификат.ЭтоЭлектроннаяПодписьВМоделиСервиса = НЕ ТекущийСертификат.Хранилище.ЭтоЛокальноеХранилище;
		
	КонецЦикла;
	
	НужныеСертификаты.Сортировать("ДействителенС, ДействителенПо");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазложитьСтрокуВладелец(Знач ВладелецСтруктура)
	
	СвойстваРезультат = Новый Структура();
	СвойстваРезультат.Вставить("Имя",              "");
	СвойстваРезультат.Вставить("Организация",      "");
	СвойстваРезультат.Вставить("Подразделение",    "");
	СвойстваРезультат.Вставить("ЭлектроннаяПочта", "");
	СвойстваРезультат.Вставить("Должность",        "");
	СвойстваРезультат.Вставить("ИНН",              "");
	СвойстваРезультат.Вставить("СНИЛС",            "");
	
	// ФИО
	Если ВладелецСтруктура.Свойство("SN") И ВладелецСтруктура.Свойство("GN") Тогда
		ФИО = ВладелецСтруктура["SN"] + " " + ВладелецСтруктура["GN"];
	ИначеЕсли ВладелецСтруктура.Свойство("CN") Тогда
		// У ПФРовских сертификатов поля с ФИО не заполнены.
		ФИО = ВладелецСтруктура["CN"];
	Иначе
		ФИО = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Имя", ФИО);

	// Организация
	Если ВладелецСтруктура.Свойство("O") Тогда
		Организация = ВладелецСтруктура["O"];
	Иначе
		Организация = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Организация", Организация);
	
	// Подразделение
	Если ВладелецСтруктура.Свойство("OU") Тогда
		Подразделение = ВладелецСтруктура["OU"];
	Иначе
		Подразделение = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Подразделение", Подразделение);
	
	// ЭлектроннаяПочта
	Если ВладелецСтруктура.Свойство("E") Тогда
		ЭлектроннаяПочта = ВладелецСтруктура["E"];
	Иначе
		ЭлектроннаяПочта = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);	

	// Должность
	Если ВладелецСтруктура.Свойство("T") Тогда
		Должность = ВладелецСтруктура["T"];
	Иначе
		Должность = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("Должность", Должность);
	
	// ИНН
	Если ВладелецСтруктура.Свойство("INN") Тогда
		ИНН = ВладелецСтруктура["INN"];
	Иначе
		ИНН = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("ИНН", ИНН);
	
	// СНИЛС
	Если ВладелецСтруктура.Свойство("SNILS") Тогда
		СНИЛС = ВладелецСтруктура["SNILS"];
	Иначе
		СНИЛС = "";
	КонецЕсли;
	
	СвойстваРезультат.Вставить("СНИЛС", СНИЛС);

	Возврат СвойстваРезультат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПоля(СтрЗначениеПоля)
	
	Возврат ?(НЕ ЗначениеЗаполнено(СтрЗначениеПоля) ИЛИ СокрЛП(СтрЗначениеПоля) = "0", "", СтрЗначениеПоля);
	
КонецФункции

#КонецОбласти

#Область ВыборСертификатовИВыбранныйСертификат

&НаКлиенте
Процедура ОтправитьЗаявку_ПослеПолученияСвойствСертификата(Результат, ВходящийКонтекст) Экспорт
	
	ЗапускПолученияДанныхДляПодписанияИТокена();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСведенияВыбранногоСертификата(Сертификат)
	
	ВыбранныйСертификат = Новый Структура();
	ВыбранныйСертификат.Вставить("Представление",  ДокументооборотСКОКлиентСервер.ПредставлениеСертификата(Сертификат));
	ВыбранныйСертификат.Вставить("Отпечаток",      Сертификат.Отпечаток);
	ВыбранныйСертификат.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", Сертификат.ЭтоЭлектроннаяПодписьВМоделиСервиса);
	// Определим позже
	ВыбранныйСертификат.Вставить("ДвДанные",       Неопределено);
	ВыбранныйСертификат.Вставить("SubjectKeyId",   "");
	// Определим позже. Для подписания методами платформы
	ВыбранныйСертификат.Вставить("СерийныйНомер", 		   Сертификат.СерийныйНомер);
	ВыбранныйСертификат.Вставить("Поставщик",     		   Сертификат.Поставщик);
	
	ПредставлениеСертификата = ВыбранныйСертификат.Представление;
	
	Элементы.Пароль.Видимость = НЕ Сертификат.ЭтоЭлектроннаяПодписьВМоделиСервиса;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьСведенияВыбранногоСертификата(ВыполяемоеОповещение)
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ВыполяемоеОповещение", ВыполяемоеОповещение);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СертификатНачалоВыбора_ПослеПолученияДвДанныхВыбранногоСертификата", 
		ЭтотОбъект, 
		ДопПараметры);
	
	КриптографияЭДКОКлиент.ЭкспортироватьСертификатВBase64(ОписаниеОповещения, ВыбранныйСертификат, Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыВыбораСертификата()
	
	ТаблицаНужныеСертификаты = РеквизитФормыВЗначение("НужныеСертификаты");
	Адрес = ПоместитьВоВременноеХранилище(ТаблицаНужныеСертификаты, Новый УникальныйИдентификатор);
	
	ДопПараметры = Новый Структура();
	Если ВыбранныйСертификат = Неопределено Тогда
		ДопПараметры.Вставить("Отпечаток", "");
	Иначе	
		ДопПараметры.Вставить("Отпечаток", ВыбранныйСертификат.Отпечаток);
	КонецЕсли; 
	
	ДопПараметры.Вставить("ИНН",   ИНН);
	ДопПараметры.Вставить("Адрес", Адрес);

	Возврат ДопПараметры;
		
КонецФункции

&НаКлиенте
Процедура СертификатНачалоВыбора_ПослеВыбораСертификата(
		Результат, 
		ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСведенияВыбранногоСертификата(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора_ПослеПолученияДвДанныхВыбранногоСертификата(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено 
		И Результат.Выполнено 
		И ВыбранныйСертификат <> Неопределено Тогда
		
		ВыбранныйСертификат.ДвДанные = Base64Значение(Результат.СтрокаBase64);
		
		СвойстваСертификата = КриптографияЭДКОСлужебныйВызовСервера.ПолучитьСвойстваСертификата(ВыбранныйСертификат.ДвДанные);
		
		Если СвойстваСертификата.ИдентификаторКлючаСубъекта = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Выбранный сертификат невозможно использовать для авторизации, так как в нем отсутствует поле ""Subject Key Identifier"".'");
			ОбработатьОшибкуПоискаСертификата(ДополнительныеПараметры, ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		ИдентификаторКлючаСубъекта = ПолучитьHexСтрокуИзДвоичныхДанных(СвойстваСертификата.ИдентификаторКлючаСубъекта);
		ВыбранныйСертификат.Вставить("SubjectKeyId", ИдентификаторКлючаСубъекта);
		
	Иначе
		
		ТекстОшибки = НСтр("ru = 'Не удалось получить данные сертификата.'");
		ОбработатьОшибкуПоискаСертификата(ДополнительныеПараметры, ТекстОшибки);
		Возврат;
		
	КонецЕсли;
	
	Если ВыбранныйСертификат.ЭтоЭлектроннаяПодписьВМоделиСервиса Тогда
		
		Если ДополнительныеПараметры.ВыполяемоеОповещение <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполяемоеОповещение);
		КонецЕсли;
		
	Иначе
	
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СертификатНачалоВыбора_ПослеПолученияМенеджераКриптографии", 
			ЭтотОбъект,
			ДополнительныеПараметры);
			
		ВыбранныйСертификат.Вставить("Сертификат", ВыбранныйСертификат.ДвДанные);
		ЛьготныеКредитыКлиент.ПолучитьМенеджерИСертификатКриптографии(ВыбранныйСертификат, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора_ПослеПолученияМенеджераКриптографии(Результат , ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат.Выполнено = Истина И НЕ Результат.МенеджерКриптографии = Неопределено Тогда
		
		МенеджерКриптографии = Результат.МенеджерКриптографии;
		СертификатКриптографии = Результат.СертификатКриптографии;
	
	Иначе
		
		Если Результат.Выполнено = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Вы отказались от установки расширения для работы с криптографией, которое требуется для подписания заявки.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Не удалось установить расширение для работы с криптографией, которое требуется для подписания заявки электронной подписью.'");
		КонецЕсли;
		ОбработатьОшибкуПоискаСертификата(ДополнительныеПараметры, ТекстОшибки);
		Возврат;
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.ВыполяемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ВыполяемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область ИзменениеОформленияФормы

&НаСервере
Процедура ПоказатьСтраницуВводаПароля()
	
	УстановитьЗаголовокПоУмолчанию();
	Элементы.ОтправитьЗаявку.КнопкаПоУмолчанию = Истина;
	
	Если ВыбранныйСертификат = Неопределено Тогда
		ТекущийЭлемент = Элементы.ПредставлениеСертификата;
	Иначе
		ТекущийЭлемент = Элементы.Пароль;
	КонецЕсли;
	
	АктивизироватьСтраницу(Элементы.СертификатИПароль);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуДлительногоДействия()
	
	Заголовок = НСтр("ru = 'Подождите, пожалуйста...'");
	Если ЭтоОтправка Тогда
		Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется отправка заявки...'");
	Иначе
		Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется обновление состояния заявки...'");
	КонецЕсли;
	
	АктивизироватьСтраницу(Элементы.ДлительноеДействие);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибку(ТекстОшибки, ОшибкаСервера = Ложь)
	
	Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.ОшибкаОтправки;
	
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	
	УстановитьЗаголовокПоУмолчанию();
	Элементы.ТекстОшибки.Заголовок = ТекстОшибки;
	
	ТекстСерверНедоступен = Документы.ЗаявкиНаЛьготныйКредит.ТекстСерверНедоступен();
	
	Если ОшибкаСервера ИЛИ ТекстОшибки = ТекстСерверНедоступен Тогда
		Элементы.РекомендацияКОшибке.Заголовок = Документы.ЗаявкиНаЛьготныйКредит.ЧтоДелатьПриНедоступностиСервера();
	Иначе
		Элементы.РекомендацияКОшибке.Заголовок = НСтр("ru = 'Попробуйте устранить проблему и повторите действие.'");
	КонецЕсли;
	
	АктивизироватьСтраницу(Элементы.Результат);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьРезультатОбновленияСтатуса()
	
	Если Заявка.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЛьготныхЗаявок.ОтклоненоБанком") Тогда
		
		ПоказатьСтраницуОтклоненнойЗаявки();
		
	ИначеЕсли Заявка.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЛьготныхЗаявок.ОдобреноБанком") Тогда
		
		ПоказатьСтраницуРезультатОбновленияОдобреннойЗаявки();
		
	ИначеЕсли Заявка.Состояние <> СостояниеЗаявки И 
		Заявка.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОбработаноВФНСПереданоВБанк Тогда
		
		ПоказатьСтраницуПередачиВБанк();
		
	ИначеЕсли Заявка.Состояние = СостояниеЗаявки 
		ИЛИ Заявка.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОтправленоВФНС Тогда
		
		Элементы.ТекстОшибки.Видимость = Ложь;
		Элементы.Отступ.Видимость = Ложь;
		Элементы.РекомендацияКОшибке.Видимость = Ложь;
		
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию  = Истина;
		Заголовок = НСтр("ru = 'Обновление завершено'");
	
		Если Заявка.Состояние = СостояниеЗаявки Тогда
			Элементы.СостояниеТекст.Заголовок = НСтр("ru = 'Состояние заявки не изменилось'");
			Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.ИнформацияПоДлительнойОтправке;
		Иначе
			Элементы.СостояниеТекст.Заголовок = НСтр("ru = 'Состояние заявки изменилось на: '") + Строка(Заявка.Состояние);
			Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.ИнформацияПоДлительнойОтправке;
		КонецЕсли;
		
		АктивизироватьСтраницу(Элементы.Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкуПоискаСертификата(ТекстОшибки)
	
	Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.ОшибкаОтправки;
	
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	
	Заголовок = НСтр("ru = 'Поиск сертификатов'");
	Элементы.ТекстОшибки.Заголовок = ТекстОшибки;
	Элементы.РекомендацияКОшибке.Заголовок = НСтр("ru = 'Убедитесь, что в системе установлен криптопровайдер и есть сертификаты для шифрования'");
	
	АктивизироватьСтраницу(Элементы.Результат);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкуОтсутствияСертификатов()
	
	Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.ОшибкаОтправки;
	
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	
	Заголовок = НСтр("ru = 'Поиск сертификатов'");
	Элементы.ТекстОшибки.Заголовок = НСтр("ru = 'Не найдено ни одного действующего сертификата по ИНН '") + ИНН;
	Элементы.РекомендацияКОшибке.Заголовок = НСтр("ru = 'Попробуйте устранить проблему и повторите действие.'");
	
	АктивизироватьСтраницу(Элементы.Результат);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуУспех()
	
	Элементы.КартинкаСостояние.Картинка = БиблиотекаКартинок.УспешнаяОтправка;
	
	Элементы.ТекстОшибки.Видимость = Ложь;
	Элементы.Отступ.Видимость = Ложь;
	Элементы.РекомендацияКОшибке.Видимость = Ложь;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию  = Истина;
	Элементы.СостояниеТекст.Заголовок = НСтр("ru = 'Заявка на льготный кредит отправлена в ФНС.
                                              |Программа сообщит вам, когда заявка будет обработана.'");
	
	Заголовок = НСтр("ru = 'Успешно!'");
	
	АктивизироватьСтраницу(Элементы.Результат);
	
КонецПроцедуры

&НаСервере
Процедура АктивизироватьСтраницу(ТекущаяСтраница)
	
	ДокументооборотСКОКлиентСервер.АктивизироватьСтраницу(Элементы.Этапы, ТекущаяСтраница);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьОформлениеФормы()
	
	Если ЭтоОтправка Тогда
		ПоказатьСтраницуДлительногоДействия();
	КонецЕсли;
		
	Если ЭтоОбновление ИЛИ ЭтоПредупреждение Тогда
		
		Элементы.ОтправитьЗаявку.Заголовок = НСтр("ru = 'Обновить состояние'");
		
		ПоказатьСтраницуДлительногоДействия();
		
	КонецЕсли;
		
	Если ЭтоПредупреждение И Заявка.ТребуетВнимания Тогда
		
		Если Заявка.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОдобреноБанком Тогда
			ПоказатьСтраницуОдобренойЗаявки();
		ИначеЕсли Заявка.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОтклоненоБанком Тогда
		    ПоказатьСтраницуОтклоненнойЗаявки();
		ИначеЕсли Заявка.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОбработаноВФНСПереданоВБанк Тогда
		    ПоказатьСтраницуПередачиВБанк();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуОтклоненнойЗаявки()
	
	Результат = Новый Структура();
	Результат.Вставить("ТребуетВнимания", Ложь);
	СохранитьРеквизитыЗаявки(Результат);
	
	Подстрока1 = НСтр("ru = 'Ваша '");
	Ссылка = Новый ФорматированнаяСтрока(НСтр("ru = 'заявка'"),,,,ПолучитьНавигационнуюСсылку(Заявка));
	Подстрока2 = НСтр("ru = ' на льготный кредит по организации '") + Строка(Заявка.Организация) + НСтр("ru = ' отклонена.'");;

	Элементы.ТекстПоясненияОтклонения.Заголовок = Новый ФорматированнаяСтрока(
		Подстрока1,
		Ссылка,
		Подстрока2);
		
	Элементы.ЗаявкаОтклоненаОписание.Видимость = ЗначениеЗаполнено(Заявка.ПричинаОтклоненияБанком);
		
	УстановитьЗаголовокПоУмолчанию();
	Элементы.ПричинаОтклоненияБанком.Заголовок = Заявка.ПричинаОтклоненияБанком;
	Элементы.СоздатьЗаявку.КнопкаПоУмолчанию = Истина;
	АктивизироватьСтраницу(Элементы.ЗаявкаОтклонена);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуОдобренойЗаявки()
	
	Подстрока1 = НСтр("ru = 'Ваша '");
	Ссылка = Новый ФорматированнаяСтрока(НСтр("ru = 'заявка'"),,,,ПолучитьНавигационнуюСсылку(Заявка));
	Подстрока2 = НСтр("ru = ' на льготный кредит по организации '") + Строка(Заявка.Организация) + НСтр("ru = ' одобрена.'");;
	Подстрока3 = НСтр("ru = 'Для получения доп. информации об одобренном кредите, обновите состояние по кнопке. '");
	Подстрока4 = НСтр("ru = 'Для авторизации на сервере вам понадобится сертификат электронной подписи.'");

	Элементы.ЗаявкаОдобренаПояснение.Заголовок = Новый ФорматированнаяСтрока(
		Подстрока1,
		Ссылка,
		Подстрока2,
		Символы.ПС,
		Символы.ПС,
		Подстрока3,
		Подстрока4);

	УстановитьЗаголовокПоУмолчанию();
	Элементы.ОбновитьСостояние.КнопкаПоУмолчанию = Истина;
	АктивизироватьСтраницу(Элементы.ЗаявкаОдобрена);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуРезультатОбновленияОдобреннойЗаявки()
	
	ОдобреннаяСумма = Формат(Заявка.ОдобреннаяСуммаКредита, "ЧДЦ=2; ЧРД=.; ЧН=0.00; ЧВН=; ЧГ=3,0");
	
	Подстрока1 = НСтр("ru = 'Вам одобрен кредит на '");
	Подстрока2 = ОдобреннаяСумма + НСтр("ru = ' руб.'"); 
	Подстрока2 = Новый ФорматированнаяСтрока(Подстрока2, Новый Шрифт(,,Истина));
	
	Элементы.СколькоОдобрено.Заголовок = Новый ФорматированнаяСтрока(
		Подстрока1,
		Подстрока2);
		
	Элементы.ЧтоДальше.Заголовок = Документы.ЗаявкиНаЛьготныйКредит.ЧтоДелатьПослеОдобрения(Заявка);

	УстановитьЗаголовокПоУмолчанию();
	Элементы.ФормаЗакрыть1.КнопкаПоУмолчанию = Истина;
	АктивизироватьСтраницу(Элементы.РезультатОбновленияОдобреннойЗаявки);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуПередачиВБанк()
	
	Результат = Новый Структура();
	Результат.Вставить("ТребуетВнимания", Ложь);
	СохранитьРеквизитыЗаявки(Результат);

	Подстрока1 = НСтр("ru = 'Ваша '");
	Ссылка = Новый ФорматированнаяСтрока(НСтр("ru = 'заявка'"), , , , ПолучитьНавигационнуюСсылку(Заявка));
	
	Подстрока2 = НСтр("ru = ' на льготный кредит по организации '") 
		+ Строка(Заявка.Организация) 
		+ НСтр("ru = ' передана в банк '") 
		+ Заявка.НаименованиеБанка + ".";
	
	Подстрока3 = НСтр("ru = 'Для рассмотрения заявки необходимо связаться с банком.'");

	Элементы.ЗаявкаПереданаВБанкПояснение.Заголовок = Новый ФорматированнаяСтрока(
		Подстрока1,
		Ссылка,
		Подстрока2,
		Символы.ПС,
		Символы.ПС,
		Подстрока3);
		
	Документы.ЗаявкиНаЛьготныйКредит.ДобавитьКонтактыБанка(Заявка, Элементы.ЗаявкаПереданаВБанкПояснение.Заголовок);

	УстановитьЗаголовокПоУмолчанию();
	Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	АктивизироватьСтраницу(Элементы.ЗаявкаПереданаВБанк);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Функция КопияЗаявки()
	
	НоваяЗаявка = Заявка.Скопировать();
	НоваяЗаявка.Записать();
	
	Возврат НоваяЗаявка.Ссылка;
	
КонецФункции

&НаСервере
Функция УстановитьЗаголовокПоУмолчанию()

	Если ЭтоОтправка Тогда
		Заголовок = НСтр("ru = 'Отправка заявки'");
	ИначеЕсли ЭтоОбновление Тогда
		Заголовок = НСтр("ru = 'Обновление состояния'");
	ИначеЕсли ЭтоПредупреждение Тогда
		Заголовок = НСтр("ru = 'Заявка на льготный кредит'");
	КонецЕсли;

КонецФункции 

&НаСервере
Процедура ИнициализироватьДанные(Параметры)
	
	Заявка = Параметры.Заявка;
	ИНН    = Параметры.Заявка.ИНН;
	СостояниеЗаявки = Заявка.Состояние;
	
	// См. ЛьготныеКредитыКлиент.ПараметрыОткрытияФормыОтправки()
	ЭтоОбновление     = Параметры.ЭтоОбновление;
	ЭтоОтправка       = Параметры.ЭтоОтправка;
	ЭтоПредупреждение = Параметры.ЭтоПредупреждение;
	
	ТекДата = ТекущаяДатаСеанса();
	
	ЭтоРежимТестирования = ЛьготныеКредиты.ИспользуетсяРежимТестирования();
	
КонецПроцедуры

&НаСервере
Процедура БольшеНеНапоминатьНаСервере()
	
	ИсключаемыеЛьготныеЗаявки = ХранилищеОбщихНастроек.Загрузить("ЛьготныеЗаявки_БольшеНеНапоминать");
	Если ТипЗнч(ИсключаемыеЛьготныеЗаявки) <> Тип("Массив") Тогда
		ИсключаемыеЛьготныеЗаявки = Новый Массив;
	КонецЕсли;
	
	ИсключаемыеЛьготныеЗаявки.Добавить(Заявка);
	
	ХранилищеОбщихНастроек.Сохранить(
		"ЛьготныеЗаявки_БольшеНеНапоминать",
		,
		ИсключаемыеЛьготныеЗаявки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти