
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ПараметрыЗаполнения = Неопределено;
	Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
	Параметры.Свойство("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Организация = Объект.Организация;
		РегистрацияВИФНС = Объект.РегистрацияВИФНС;
	Иначе
		Организация = Параметры.Организация;
		Объект.Организация = Параметры.Организация;
		Если Параметры.Свойство("НалоговыйОрган") И ЗначениеЗаполнено(Параметры.НалоговыйОрган) Тогда 
			РегистрацияВИФНС = Параметры.НалоговыйОрган;
		Иначе
			РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
		ОбщегоНазначения.СообщитьПользователю("Сообщение по форме 26.5-1 можно создавать только для индивидуальных предпринимателей");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	ЗагрузитьДанные();
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМакетыУведомления(ЭтотОбъект, Объект.ИмяОтчета, "ПараметрыФорма2014_1");
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	СформироватьДерево();
	
	СтруктураРеквизитов = РегламентированнаяОтчетность.СформироватьСтруктуруОбязательныхРеквизитовУведомления();
	мСтруктураВариантыЗаполнения = Новый Структура;
	РегламентированнаяОтчетность.СформироватьСоставПоказателей(ЭтаФорма, "СоставПоказателей2014_1");
	РегламентированнаяОтчетность.ПолучитьСведенияОПоказателяхУведомления(ЭтаФорма);
	Элементы.ФормаЗаполнить.Видимость = СтруктураРеквизитов.ОтображатьКнопкуЗаполнить;
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	Если Параметры.Свойство("СформироватьФормуОтчетаАвтоматически") Тогда 
		ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	КонецЕсли;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.РазделыЗаявления.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗагрузитьДанные()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СсылкаНаДанные = Объект.Ссылка;
	ИначеЕсли ЗначениеЗаполнено(ЗначениеКопирования) Тогда 
		СсылкаНаДанные = ЗначениеКопирования;
	Иначе 
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	Если Не СтруктураПараметров.Свойство("Титульный") Тогда 
		Возврат;
	КонецЕсли;
	Титульный = СтруктураПараметров.Титульный;
	НоваяСтрока = ТитульнаяСтраница.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Титульный[0]);
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Листы3 = СтруктураПараметров.Листы3;
	Для Каждого Строка Из Листы3 Цикл
		НоваяСтрока = СтраницыЛиста3.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент;
		Объект.Организация = Организация;
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	Объект.РегистрацияВИФНС = РегистрацияВИФНС;
	Объект.ПодписантТелефон = ТитульнаяСтраница[0].ТЕЛЕФОН;
	Объект.ПодписантДокумент = ТитульнаяСтраница[0].ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ;
	Объект.ПодписантПризнак = ТитульнаяСтраница[0].ПРИЗНАК_НП_ПОДВАЛ;
	Если ЗначениеЗаполнено(ТитульнаяСтраница[0].ДАТА_ПОДПИСИ) Тогда
		Объект.ДатаПодписи = ТитульнаяСтраница[0].ДАТА_ПОДПИСИ;
	Иначе
		Объект.ДатаПодписи = Неопределено;
	КонецЕсли;
	СтруктураПараметров = Новый Структура("Титульный, Листы3",
			ТитульнаяСтраница.Выгрузить(),
			СтраницыЛиста3.Выгрузить());
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТитульный(НовыйЛист)
	НовыйЛист.UID = Новый УникальныйИдентификатор;
	
	СтрокаСведений = "ИННФЛ,ФИО,ТелДом,ФамилияИП,ИмяИП,ОтчествоИП";
	ДП = ?(ЗначениеЗаполнено(Объект.ДатаПодписи), Объект.ДатаПодписи, ТекущаяДатаСеанса());
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДП, СтрокаСведений);
	НовыйЛист.ФАМИЛИЯ_ИП = СведенияОбОрганизации.ФамилияИП;
	НовыйЛист.ИМЯ_ИП = СведенияОбОрганизации.ИмяИП;
	НовыйЛист.ОТЧЕСТВО_ИП = СведенияОбОрганизации.ОтчествоИП;
	НовыйЛист.П_ИНН_1 = СведенияОбОрганизации.ИННФЛ;
	НовыйЛист.ТЕЛЕФОН = СведенияОбОрганизации.ТелДом;
	НовыйЛист.КОД_НО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "Код");
	
	Попытка
		ИндивидуальныйПредприниматель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ИндивидуальныйПредприниматель");
	Исключение
		УстановитьДанныеПоРегистрацииВИФНС();
		Возврат;
	КонецПопытки;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтактнаяИнформация.ЗначенияПолей
		|ИЗ
		|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Ссылка = &Ссылка
		|	И КонтактнаяИнформация.Вид = &Вид";
	Запрос.УстановитьПараметр("Ссылка", ИндивидуальныйПредприниматель);
	Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		АдресСтруктурой = РаботаСАдресами.СведенияОбАдресе(Выборка.ЗначенияПолей);
		ЗаполнитьЗначенияСвойств(НовыйЛист, АдресСтруктурой);
		
	КонецЕсли;
	
	УстановитьДанныеПоРегистрацииВИФНС();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЛист3(НовыйЛист)
	НовыйЛист.UID = Новый УникальныйИдентификатор;
	НовыйЛист.П_ИНН_3 = ТитульнаяСтраница[0].П_ИНН_1;
КонецПроцедуры

&НаСервере
Процедура СформироватьДерево()
	РазделыЗаявления.ПолучитьЭлементы().Очистить();
	КорневойУровень = РазделыЗаявления.ПолучитьЭлементы();
	Если ТитульнаяСтраница.Количество() = 0 Тогда
		НовыйЛист = ТитульнаяСтраница.Добавить();
		ЗаполнитьТитульный(НовыйЛист);
	КонецЕсли;
	Титульный = КорневойУровень.Добавить();
	Титульный.Наименование = "Титульный лист";
	Титульный.ИндексКартинки = 1;
	Титульный.ТипСтраницы = 1;
	Титульный.UID = ТитульнаяСтраница[0].UID;
	
	Листы3 = КорневойУровень.Добавить();
	Листы3.Наименование = "Доп. листы";
	СписокЛистов3 = Листы3.ПолучитьЭлементы();
	
	Если СтраницыЛиста3.Количество() = 0 Тогда
		НовыйЛист = СтраницыЛиста3.Добавить();
		ЗаполнитьЛист3(НовыйЛист);
	КонецЕсли;
	
	Номер = 1;
	Для Каждого Страница3 Из СтраницыЛиста3 Цикл 
		Лист3 = СписокЛистов3.Добавить();
		Лист3.ИндексКартинки = 1;
		Лист3.ТипСтраницы = 3;
		Лист3.Наименование = "Стр. " + Номер;
		Лист3.UID = Страница3.UID;
		Номер = Номер + 1;
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяОбласти(ТекущийТипСтраницы)
	Если ТекущийТипСтраницы = 1 Тогда
		Возврат "ТитульныйЛист";
	ИначеЕсли ТекущийТипСтраницы = 3 Тогда
		Возврат "СтраницаСведения_1";
	КонецЕсли;
	
	Возврат "";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяТаблицы(ТекущийТипСтраницы)
	Если ТекущийТипСтраницы = 1 Тогда
		Возврат "ТитульнаяСтраница";
	ИначеЕсли ТекущийТипСтраницы = 3 Тогда
		Возврат "СтраницыЛиста3";
	КонецЕсли;
	
	Возврат "";
КонецФункции

&НаСервере
Процедура СформироватьМакетНаСервере()
	Документы.УведомлениеОСпецрежимахНалогообложения.СформироватьМакетОтчетаНаСервере(ЭтотОбъект, Объект.ИмяОтчета, "Форма2014_1", ПолучитьИмяОбласти(ТекущийТипСтраницы), ПолучитьИмяТаблицы(ТекущийТипСтраницы));
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка(Инфо)
	Если Инфо.Обработчик = "ОбработкаСписка" Тогда
		ОбработкаСписка(Инфо);
	ИначеЕсли Инфо.Обработчик = "ОбработкаКодаНО" Тогда
		ОбработкаКодаНО(Инфо);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСписка(Инфо)
	
	ИмяНестандартнойОбласти = Инфо.Имя;
	НазваниеСписка = Инфо.ИмяФормы;
	
	СтруктураОтбора = Новый Структура("ИмяСписка", Инфо.ИмяСписка);
	Строки = ТаблицаЗначенийПредопределенныхРеквизитов.НайтиСтроки(СтруктураОтбора);
	ЗагружаемыеКоды.Очистить();
	Для Каждого Строка Из Строки Цикл 
		НоваяСтрока = ЗагружаемыеКоды.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НазваниеСписка);
	ПараметрыФормы.Вставить("ТаблицаЗначений",    ЗагружаемыеКоды);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение));
	
	ДополнительныеПараметры = Новый Структура("ИмяНестандартнойОбласти", ИмяНестандартнойОбласти);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаСпискаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаСпискаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ИмяНестандартнойОбласти = ДополнительныеПараметры.ИмяНестандартнойОбласти;
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение = РезультатВыбора.Код;
	Модифицированность = Истина;
	
	ИмяОбластиДоп = "";
	РезультатВыбораКод = СокрЛП(РезультатВыбора.Код);
	
	ПредставлениеУведомления.Области[ИмяНестандартнойОбласти].Значение = РезультатВыбораКод;
	ИмяОбласти = ПолучитьИмяОбласти(ТекущийТипСтраницы);
	ИмяТаблицы = ПолучитьИмяТаблицы(ТекущийТипСтраницы);
	ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
	Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
	СтруктураЗаписи = Новый Структура(ИмяНестандартнойОбласти, РезультатВыбораКод);
	Если Данные.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяОбластиДоп) Тогда 
		СтруктураЗаписи = Новый Структура(ИмяОбластиДоп, "");
		Если Данные.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
		КонецЕсли;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
		Если ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ") <> Неопределено Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		КонецЕсли;
		ТитульнаяСтраница[0].ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
		Если ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ") <> Неопределено Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
		КонецЕсли;
		ТитульнаяСтраница[0].ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
	Если ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ") <> Неопределено Тогда 
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	КонецЕсли;
	ТитульнаяСтраница[0].ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Представитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "Представитель");
	Если ЗначениеЗаполнено(Представитель) Тогда
		ПризнакПодписанта = "2";
		УстановитьПредставителяПоФизЛицу(Представитель);
		Если ПредставлениеУведомления.Области.Найти("ПРИЗНАК_НП_ПОДВАЛ") <> Неопределено Тогда 
			ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
			ПредставлениеУведомления.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "ДокументПредставителя");
		КонецЕсли;
		ТитульнаяСтраница[0].ПРИЗНАК_НП_ПОДВАЛ = "2";
		ТитульнаяСтраница[0].ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "ДокументПредставителя");
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПризнакПодписанта = "1";
		Если ПредставлениеУведомления.Области.Найти("ПРИЗНАК_НП_ПОДВАЛ") <> Неопределено Тогда 
			ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
			ПредставлениеУведомления.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
		КонецЕсли;
		ТитульнаяСтраница[0].ПРИЗНАК_НП_ПОДВАЛ = "1";
		ТитульнаяСтраница[0].ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КодНалоговогоОргана()
	УстановитьДанныеПоРегистрацииВИФНС();
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВИФНС, "Код");
КонецФункции

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		РегистрацияВИФНС = Результат;
		ПредставлениеУведомления.Области[Инфо.Имя].Значение = КодНалоговогоОргана();
		ТитульнаяСтраница[0][Инфо.Имя] = КодНалоговогоОргана();
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	ТитульнаяСтраница.Очистить();
	СтраницыЛиста3.Очистить();
	СформироватьДерево();
	ТекущийИдентификаторСтраницы = РазделыЗаявления.ПолучитьЭлементы()[0].UID;
	ТекущийТипСтраницы = РазделыЗаявления.ПолучитьЭлементы()[0].ТипСтраницы;
	СформироватьМакетНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	ИмяОбласти = ПолучитьИмяОбласти(ТекущийТипСтраницы);
	Если Не ЗначениеЗаполнено(ИмяОбласти) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "П_ИНН_1" Тогда
		НовИнн = Область.Значение;
		Для Каждого Стр Из СтраницыЛиста3 Цикл 
			Стр.П_ИНН_3 = НовИнн;
		КонецЦикла;
	ИначеЕсли Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	ИмяТаблицы = ПолучитьИмяТаблицы(ТекущийТипСтраницы);
	ПараметрыОтбора = Новый Структура("UID", ТекущийИдентификаторСтраницы);
	Данные = ЭтотОбъект[ИмяТаблицы].НайтиСтроки(ПараметрыОтбора);
	СтруктураЗаписи = Новый Структура(Область.Имя, Область.Значение);
	Если Данные.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Данные[0], СтруктураЗаписи);
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
	КонецЕсли;
	
	ОтборПоИмениОбласти = Новый Структура("Имя", Область.Имя);
	Поля = ПоляСОсобымПорядкомЗаполнения.НайтиСтроки(ОтборПоИмениОбласти);
	Если Поля.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка(Поля[0]);
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления", "ТитульнаяСтраница");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопок()
	
	ТипСтраницы = Элементы.РазделыЗаявления.ТекущиеДанные.ТипСтраницы;
	
	КМенюРО = Элементы.РазделыЗаявления.КонтекстноеМеню;
	Если ТипСтраницы = 3 Тогда
		КМенюРО.Видимость = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюДобавитьСтраницу.Доступность = Истина;
		КМенюРО.ПодчиненныеЭлементы.РазделыЗаявленияКонтекстноеМенюУдалитьСтраницу.Доступность = (СтраницыЛиста3.Количество() > 1);
	Иначе
		КМенюРО.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыЗаявленияПриАктивизацииСтроки(Элемент)
	
	Если ТекущийИдентификаторСтраницы = Элемент.ТекущиеДанные.UID И
		ТекущийТипСтраницы = Элемент.ТекущиеДанные.ТипСтраницы Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.ТипСтраницы = 0 Тогда
		ПодчиненныеЭлементыДерева = Элемент.ТекущиеДанные.ПолучитьЭлементы();
		ТекущийИдентификаторСтраницы = ПодчиненныеЭлементыДерева[0].UID;
		ТекущийТипСтраницы = ПодчиненныеЭлементыДерева[0].ТипСтраницы;
		СформироватьМакетНаСервере();
		УстановитьДоступностьКнопок();
		Возврат;
	КонецЕсли;
	
	ТекущийИдентификаторСтраницы = Элемент.ТекущиеДанные.UID;
	ТекущийТипСтраницы = Элемент.ТекущиеДанные.ТипСтраницы;
	СформироватьМакетНаСервере();
	УстановитьДоступностьКнопок();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	
	Если ТекущийТипСтраницы = 3 Тогда
		ДобавитьСтраницуНаСервере();
		ПеренумероватьСтраницы();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	Если ТекущийТипСтраницы = 3 Тогда
		КорневойУровень = РазделыЗаявления.ПолучитьЭлементы();
		СписокЛистов3 = КорневойУровень[1].ПолучитьЭлементы();
		НовыйЛист = СтраницыЛиста3.Добавить();
		ЗаполнитьЛист3(НовыйЛист);
		Лист3 = СписокЛистов3.Добавить();
		Лист3.ИндексКартинки = 1;
		Лист3.ТипСтраницы = 3;
		Лист3.Наименование = "Стр. 3";
		Лист3.UID = НовыйЛист.UID;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере(UID, ТипСтраницы)
	ОтборСтрок = Новый Структура("UID", UID);
	Таблица = ЭтотОбъект[ПолучитьИмяТаблицы(ТипСтраницы)];
	Строки = Таблица.НайтиСтроки(ОтборСтрок);
	Таблица.Удалить(Строки[0]);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт

	ТекущиеДанные = Элементы.РазделыЗаявления.ТекущиеДанные;
	КопияТекущиеДанные = ТекущиеДанные;
	ТекущиеДанные = ТекущиеДанные.ПолучитьРодителя();
	
	Если ТекущиеДанные = Неопределено Или ТекущиеДанные.ПолучитьЭлементы().Количество() = 1 Тогда
		Возврат;
	КонецЕсли;
	УдалитьСтраницуНаСервере(КопияТекущиеДанные.UID, КопияТекущиеДанные.ТипСтраницы);
	ТекущиеДанные.ПолучитьЭлементы().Удалить(ТекущиеДанные.ПолучитьЭлементы().Индекс(КопияТекущиеДанные));
	ПеренумероватьСтраницы();
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПеренумероватьСтраницы()
	Листы = РазделыЗаявления.ПолучитьЭлементы()[1].ПолучитьЭлементы();
	Номер = 1;
	Для Каждого Лист Из Листы Цикл 
		Лист.Наименование = "Стр. "+Номер;
		Номер = Номер + 1;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

&НаКлиенте
Процедура ПечатьУведомления(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьУведомленияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	Иначе
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредварительныйПросмотрЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2014_1"),
			"1150025_5.02000_02.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

#Область Автозаполнение

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаполнениемОтчетаЗавершение", ЭтотОбъект);
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", Объект.Организация);
	ПараметрыОтчета.Вставить("КодНалоговогоОргана", Объект.РегистрацияВИФНС);
	
	ЭтаФормаИмя = ИДОтчета(ЭтаФорма.ИмяФормы);
	
	СтандартнаяОбработка = Истина;
	
	РегламентированнаяОтчетностьКлиентПереопределяемый.ПередЗаполнениемОтчета(
		ЭтаФормаИмя, ПараметрыОтчета, ЭтотОбъект, ОписаниеОповещения, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		ЗаполнитьАвтоНаСервере();
		Элементы.РазделыЗаявления.Развернуть(РазделыЗаявления.ПолучитьЭлементы()[1].ПолучитьИдентификатор(), Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаполнениемОтчетаЗавершение(ПараметрыЗаполнения, ДополнительныеПараметры) Экспорт
	ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	Элементы.РазделыЗаявления.Развернуть(РазделыЗаявления.ПолучитьЭлементы()[1].ПолучитьИдентификатор(), Истина);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения = Неопределено)
	
	Если ПараметрыЗаполнения <> Неопределено Тогда
		Если ПараметрыЗаполнения.Свойство("НалоговыйОрган") И Объект.РегистрацияВИФНС <> ПараметрыЗаполнения.НалоговыйОрган Тогда
			Объект.РегистрацияВИФНС =  ПараметрыЗаполнения.НалоговыйОрган;
			ТитульнаяСтраница[0].КОД_НО = КодНалоговогоОргана();
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", 			     Объект.Организация);
	ПараметрыОтчета.Вставить("КодНалоговогоОргана",          Объект.РегистрацияВИФНС);
	ПараметрыОтчета.Вставить("ДатаПодписи",                  Объект.ДатаПодписи);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", ЭтаФорма.УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения",          ПараметрыЗаполнения);
	
	ЭтаФормаИмя = ИДОтчета(ЭтаФорма.ИмяФормы);
	
	Контейнер = СформироватьКонтейнерДляАвтозаполнения();
	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ЭтаФормаИмя, Сред(ЭтаФорма.ИмяФормы, СтрНайти(ЭтаФорма.ИмяФормы, ".Форма.") + 7), ПараметрыОтчета, Контейнер);
	ЗагрузитьПодготовленныеДанные(Контейнер);
	КорневойУровень = РазделыЗаявления.ПолучитьЭлементы();
	КорневойУровень.Очистить();
	СформироватьДерево();
	СформироватьМакетНаСервере();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИДОтчета(Знач ЭтаФормаИмя)
	
	Если СтрЧислоВхождений(ЭтаФормаИмя, "ВнешнийОтчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "ВнешнийОтчет.", "");
	ИначеЕсли СтрЧислоВхождений(ЭтаФормаИмя, "Отчет.") > 0 Тогда
		ЭтаФормаИмя = СтрЗаменить(ЭтаФормаИмя, "Отчет.", "");
	КонецЕсли;
	ЭтаФормаИмя = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	
	Возврат ЭтаФормаИмя;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(Контейнер)
	Контейнер.ДопСтроки.Колонки.Добавить("UID");
	Контейнер.ДопСтроки.Колонки.Добавить("П_ИНН_3");
	
	ЗначениеВДанныеФормы(Контейнер.ДопСтроки, СтраницыЛиста3);
	
	Для Каждого Стр Из СтраницыЛиста3 Цикл 
		Стр.UID = Новый УникальныйИдентификатор;
		Стр.П_ИНН_3 = ТитульнаяСтраница[0].П_ИНН_1;
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ТитульнаяСтраница[0], Контейнер.Титульный);
	
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Функция СформироватьКонтейнерДляАвтозаполнения()
	Контейнер = Новый Структура();
	
	Таб = ДанныеФормыВЗначение(СтраницыЛиста3, Тип("ТаблицаЗначений"));
	Таб.Колонки.Удалить("UID");
	Таб.Колонки.Удалить("П_ИНН_3");
	Контейнер.Вставить("ДопСтроки", Таб);
	
	Таб = ДанныеФормыВЗначение(ТитульнаяСтраница, Тип("ТаблицаЗначений"));
	Таб.Колонки.Удалить("UID");
	Таб.Колонки.Удалить("П_ИНН_1");
	Контейнер.Вставить("Титульный", ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Таб[0]));
	
	Возврат Контейнер;
КонецФункции

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		Если Параметр.ИмяСтраницы = "ТитульныйЛист" Тогда 
			ТекущийТипСтраницы = 1;
		ИначеЕсли Параметр.ИмяСтраницы = "ДопЛист" Тогда 
			ТекущийТипСтраницы = 2;
		КонецЕсли;
		
		ТекущийИдентификаторСтраницы = Параметр.УИДСтраницы;
		СформироватьМакетНаСервере();
		Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Области.Найти(Параметр.ИмяОбласти);
		УстановитьДоступностьКнопок();
		Активизировать();
		Если ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения") И Источник.Открыта() Тогда 
			Источник.Закрыть( );
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
