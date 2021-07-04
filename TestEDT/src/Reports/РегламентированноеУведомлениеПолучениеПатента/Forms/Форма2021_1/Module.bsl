
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
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	РазделительНомераСтроки = "___";
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2021_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда 
			Отказ = Истина; Возврат;
		КонецЕсли;
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	
	Заголовок = Заголовок + " (" + Объект.Организация + ")";
	
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(ИдДляСвор);
	РучнойВвод = Ложь;
	
	Для Каждого Элт Из ДанныеМногостраничныхРазделов.Форма2021_1_ЛистА Цикл 
		ЛистА = Элт.Значение;
		Если ТипЗнч(ЛистА) <> Тип("Структура") Или ЛистА.Свойство("АдресXML") Тогда 
			Прервать;
		КонецЕсли;
		
		ЛистА.Вставить("АдресXML", "");
		ЛистА.Вставить("Адрес9зпт", "");
	КонецЦикла;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов.Форма2021_1_ЛистВ Цикл 
		ЛистВ = Элт.Значение;
		Если ТипЗнч(ЛистВ) <> Тип("Структура") Или ЛистВ.Свойство("АдресXML") Тогда 
			Прервать;
		КонецЕсли;
		
		ЛистВ.Вставить("АдресXML", "");
		ЛистВ.Вставить("Адрес9зпт", "");
	КонецЦикла;
	
	Если Не ДанныеУведомления.Форма2021_1_Титульная.Свойство("АдресXML") Тогда 
		ДанныеУведомления.Форма2021_1_Титульная.Вставить("АдресXML", "");
		ДанныеУведомления.Форма2021_1_Титульная.Вставить("Адрес9зпт", "");
	КонецЕсли;
	
	Если Не ДанныеУведомления.Форма2021_1_Лист2.Свойство("ВыводитьНольНаПечать") Тогда 
		ДанныеУведомления.Форма2021_1_Лист2.Вставить("ВыводитьНольНаПечать", Ложь);
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
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
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	УведомлениеОСпецрежимахНалогообложения.ОчисткаОтчетаДействия(Новый Структура("Форма", ЭтотОбъект));
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2021_1_Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДатаДок", Объект.ДатаПодписи);
	
	СтрокаСведений = "ИННФЛ,ФИО,ТелДом,ФамилияИП,ИмяИП,ОтчествоИП,ОГРН";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	ДанныеУведомленияТитульный.Вставить("ИННШапка", СведенияОбОрганизации.ИННФЛ);
	ДанныеУведомленияТитульный.Вставить("Фамилия", СведенияОбОрганизации.ФамилияИП);
	ДанныеУведомленияТитульный.Вставить("Имя", СведенияОбОрганизации.ИмяИП);
	ДанныеУведомленияТитульный.Вставить("Отчество", СведенияОбОрганизации.ОтчествоИП);
	ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
	ДанныеУведомленияТитульный.Вставить("ОГРНИП", СведенияОбОрганизации.ОГРН);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,ДокументПредставителя");
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПрПодп", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	Иначе
		УстановитьПредставителяПоОрганизации();
		ДанныеУведомленияТитульный.Вставить("ПрПодп", "1");
		ДанныеУведомленияТитульный.Вставить("НаимДок", "");
	КонецЕсли;
	
	Для Каждого Элт Из ДанныеМногостраничныхРазделов.Форма2021_1_ЛистА Цикл 
		ЛистА = Элт.Значение;
		Если ТипЗнч(ЛистА) <> Тип("Структура") Или ЛистА.Свойство("АдресXML") Тогда 
			Прервать;
		КонецЕсли;
		
		ЛистА.Вставить("АдресXML", "");
		ЛистА.Вставить("Адрес9зпт", "");
	КонецЦикла;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов.Форма2021_1_ЛистВ Цикл 
		ЛистВ = Элт.Значение;
		Если ТипЗнч(ЛистВ) <> Тип("Структура") Или ЛистВ.Свойство("АдресXML") Тогда 
			Прервать;
		КонецЕсли;
		
		ЛистВ.Вставить("АдресXML", "");
		ЛистВ.Вставить("Адрес9зпт", "");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2021_1_Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Форма2021_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Лист 2";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2021_1_Лист2";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Форма2021_1_Лист2";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Листы А";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "Форма2021_1_ЛистА";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "Форма2021_1_ЛистА";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Листы Б";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "Форма2021_1_ЛистБ";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "Форма2021_1_ЛистБ";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Листы В";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "Форма2021_1_ЛистВ";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "Форма2021_1_ЛистВ";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УИДТекущаяСтраница <> Элемент.ТекущиеДанные.УИД Тогда 
		ПредУИД = УИДТекущаяСтраница;
		
		УИДТекущаяСтраница = Элемент.ТекущиеДанные.УИД;
		ТекущееИДНаименования = Элемент.ТекущиеДанные.ИДНаименования;
		Если Не ЗначениеЗаполнено(ТекущееИДНаименования) Тогда 
			ТекущееИДНаименования = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].ИДНаименования;
			УИДТекущаяСтраница = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].УИД;
		КонецЕсли;
		
		Если Элемент.ТекущиеДанные.Многостраничность Тогда 
			ИмяМакета = ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
			ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПолучитьМногострочныеЧасти(Элемент.ТекущиеДанные), ПредУИД);
		Иначе 
			ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, Элемент.ТекущиеДанные.МногострочныеЧасти, ПредУИД);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьМногострочныеЧасти(Макет, МногострочныеЧасти)
	Если ТипЗнч(МногострочныеЧасти) = Тип("СписокЗначений") 
		И МногострочныеЧасти.Количество() > 0 Тогда 
		
		Для Каждого МнгСтр Из МногострочныеЧасти Цикл 
			ТЗ = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[МнгСтр.Значение]);
			ИсхСтр = ОбщегоНазначения.СкопироватьРекурсивно(ДанныеДопСтрокСтраницы[МнгСтр.Значение][0].Значение);
			Для Каждого КЗ Из ИсхСтр Цикл 
				ИсхСтр[Кз.Ключ] = Неопределено;
			КонецЦикла;
			
			Строки = ТЗ.НайтиСтроки(Новый Структура("УИД", УИДТекущаяСтраница));
			ДанныеДопСтрокСтраницы[МнгСтр.Значение].Очистить();
			Инд = 0;
			Пока ДанныеДопСтрокСтраницы[МнгСтр.Значение].Количество() < Строки.Количество() Цикл 
				ТекСтр = ОбщегоНазначения.СкопироватьРекурсивно(ИсхСтр);
				ЗаполнитьЗначенияСвойств(ТекСтр, Строки[Инд]);
				ДанныеДопСтрокСтраницы[МнгСтр.Значение].Добавить(ТекСтр);
				Инд = Инд + 1;
			КонецЦикла;
			
			Если ДанныеДопСтрокСтраницы[МнгСтр.Значение].Количество() = 0 Тогда 
				ДанныеДопСтрокСтраницы[МнгСтр.Значение].Добавить(ИсхСтр);
			КонецЕсли;
			
			ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("Header_" + МнгСтр.Значение));
			Инд = 0;
			ВыводитьЗначокУдаления = ДанныеДопСтрокСтраницы[МнгСтр.Значение].Количество() > 1;
			Для Каждого Стр Из ДанныеДопСтрокСтраницы[МнгСтр.Значение] Цикл
				Инд = Инд + 1;
				ИндСтр = РазделительНомераСтроки + Формат(Инд, "ЧГ=");
				Обл = Макет.ПолучитьОбласть("Str_" + МнгСтр.Значение);
				Для Каждого ОблПодч Из Обл.Области Цикл 
					Если ОблПодч.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
						Если ОблПодч.СодержитЗначение Тогда 
							Стр.Значение.Свойство(ОблПодч.Имя, ОблПодч.Значение);
						КонецЕсли;
						ОблПодч.Имя = ОблПодч.Имя + ИндСтр;
					КонецЕсли;
					
					Если ВыводитьЗначокУдаления И ОблПодч.Имя = "Del_" + МнгСтр.Значение + ИндСтр Тогда 
						ОблПодч.Текст = "х";
						ОблПодч.Гиперссылка = Истина;
					КонецЕсли;
				КонецЦикла;
				ПредставлениеУведомления.Вывести(Обл);
			КонецЦикла;
			ПредставлениеУведомления.Области["Str_" + МнгСтр.Значение].Имя = "";
			
			ОблДобавленияСтроки = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("ОбщиеЭлементы").ПолучитьОбласть("AddStrArea");
			ОблДобавленияСтроки.Области["AddStrLabel"].Имя = "AddStrLabel_" + МнгСтр.Значение;
			ОблДобавленияСтроки.Области["AddStr"].Имя = "AddStr_" + МнгСтр.Значение;
			ПредставлениеУведомления.Вывести(ОблДобавленияСтроки);
			ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("Footer_" + МнгСтр.Значение));
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуВДеревоПоУИД(Дерево, UID)
	Для Каждого Элемент Из Дерево Цикл 
		Если Элемент.УИД = UID И Не ПустаяСтрока(Элемент.ИДНаименования) Тогда
			Возврат Элемент;
		КонецЕсли;
	
		НайденныйИД = НайтиСтрокуВДеревоПоУИД(Элемент.ПолучитьЭлементы(), UID);
		Если НайденныйИД <> Неопределено Тогда
			Возврат НайденныйИД;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Функция ПолучитьИмяВыводимогоМакета(ТекущиеДанные)
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяМакета) Тогда 
		Возврат ТекущиеДанные.ИмяМакета;
	Иначе
		Возврат ТекущиеДанные.ПолучитьЭлементы()[0].ИмяМакета;
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ПолучитьМногострочныеЧасти(ТекущиеДанные)
	Если ТекущиеДанные.МногострочныеЧасти.Количество() > 0 Тогда 
		Возврат ТекущиеДанные.МногострочныеЧасти;
	ИначеЕсли ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 Тогда 
		Возврат ТекущиеДанные.ПолучитьЭлементы()[0].МногострочныеЧасти;
	Иначе
		Возврат ТекущиеДанные.МногострочныеЧасти;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура СобратьДанныеМногострочныхЧастейТекущейСтраницы(МногострочныеЧасти, ПредУИД)
	Для Каждого МнгЧ Из ТекущиеМногострочныеЧасти Цикл 
		СЗ = ДанныеДопСтрокСтраницы[МнгЧ.Значение];
		Для Инд = 1 По СЗ.Количество() Цикл 
			ИндСтр = РазделительНомераСтроки + Формат(Инд, "ЧГ=0");
			ДанныеСтроки = СЗ[Инд-1].Значение;
			Для Каждого КЗ Из ДанныеСтроки Цикл 
				ДанныеСтроки[КЗ.Ключ] = ПредставлениеУведомления.Области[КЗ.Ключ + ИндСтр].Значение;
			КонецЦикла;
		КонецЦикла;
		
		ВсеДопСтроки = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[МнгЧ.Значение]);
		СтрокиТекущейСтраницы = ВсеДопСтроки.НайтиСтроки(Новый Структура("УИД", ПредУИД));
		Для Инд = 0 По СтрокиТекущейСтраницы.Количество() - СЗ.Количество() - 1 Цикл 
			ВсеДопСтроки.Удалить(СтрокиТекущейСтраницы[Инд]);
		КонецЦикла;
		
		Для Инд = СтрокиТекущейСтраницы.Количество() + 1 По СЗ.Количество() Цикл 
			НовСтр = ВсеДопСтроки.Добавить();
			НовСтр.УИД = ПредУИД;
		КонецЦикла;
		
		СтрокиТекущейСтраницы = ВсеДопСтроки.НайтиСтроки(Новый Структура("УИД", ПредУИД));
		Для Инд = 0 По СтрокиТекущейСтраницы.ВГраница() Цикл 
			ЗаполнитьЗначенияСвойств(СтрокиТекущейСтраницы[Инд], СЗ[Инд].Значение);
		КонецЦикла;
		
		ДанныеДопСтрок[МнгЧ.Значение] = ПоместитьВоВременноеХранилище(ВсеДопСтроки, ДанныеДопСтрок[МнгЧ.Значение]);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не УдалениеСтраницы И ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		СобратьДанныеМногострочныхЧастейТекущейСтраницы(МногострочныеЧасти, ПредУИД);
	КонецЕсли;
	
	ТекущиеМногострочныеЧасти = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("УправлениеСтраницами"));
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	СтрДанных = Неопределено;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
		Если Элт.Значение.УИД = УИДТекущаяСтраница Тогда 
			СтрДанных = Элт.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	НайденнаяСтрока = НайтиСтрокуВДеревоПоУИД(ДеревоСтраниц.ПолучитьЭлементы(), УИДТекущаяСтраница);
	Если НайденнаяСтрока <> Неопределено
		И НайденнаяСтрока.ПолучитьРодителя().ПолучитьЭлементы().Количество() = 1 Тогда 
		
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницу.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Гиперссылка = Ложь;
		ПредставлениеУведомления.Области.УдалитьСтраницу.Гиперссылка = Ложь;
	КонецЕсли;
	
	ПоказатьМногострочныеЧасти(Макет, МногострочныеЧасти);
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не УдалениеСтраницы И ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		СобратьДанныеМногострочныхЧастейТекущейСтраницы(МногострочныеЧасти, ПредУИД);
	КонецЕсли;
	
	ТекущиеМногострочныеЧасти = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	УведомлениеОСпецрежимахНалогообложения.УстановитьФорматыВПолях(ЭтотОбъект);
	СтрДанных = ДанныеУведомления[ТекущееИДНаименования];
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ПоказатьМногострочныеЧасти(Макет, МногострочныеЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДатаДок" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	Если (Область.Имя = "КодРегион"
		Или Область.Имя = "КодНОУчет")
		И ДанныеМногостраничныхРазделов.Свойство(ТекущееИДНаименования)
		И (Не РучнойВвод) Тогда
		
		О1 = ПредставлениеУведомления.Области["КодРегион"];
		О2 = ПредставлениеУведомления.Области["КодНОУчет"];
		
		ТекстСообщения = "";
		Для Каждого Стр Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
			Если Стр.Значение.УИД <> УИДТекущаяСтраница
				И (Стр.Значение[О1.Имя] <> О1.Значение Или Стр.Значение[О2.Имя] <> О2.Значение) Тогда 
				
				ТекстСообщения = НСтр("ru='Код региона и код налогового органа изменены на всех экземплярах страниц'");
			КонецЕсли;
			Стр.Значение[О1.Имя] = О1.Значение;
			Стр.Значение[О2.Имя] = О2.Значение;
		КонецЦикла;
		Если ЗначениеЗаполнено(ТекстСообщения) Тогда 
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	ИначеЕсли СтрНачинаетсяС(Область.Имя, "Аддр_") Тогда
		ОблАдресJSON = ПредставлениеУведомления.Области.Найти("АдресJSON");
		ОблАдресJSON.Значение = "";
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ОблАдресJSON, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,ДокументПредставителя");
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПрПодп"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПрПодп"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2021_1_Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПрПодп", ПредставлениеУведомления.Области["ПрПодп"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДатаДок", ПредставлениеУведомления.Области["ДатаДок"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2021_1_Титульная"];
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
	КонецЕсли;
	
	УстановитьПодписанта();
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	УстановитьПодписанта();
КонецПроцедуры

&НаСервере
Процедура УстановитьПодписанта()
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2021_1_Титульная"];
	ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ);
	Если ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ") <> Неопределено Тогда
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	Если ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		СобратьДанныеМногострочныхЧастейТекущейСтраницы(ТекущиеМногострочныеЧасти, УИДТекущаяСтраница);
	КонецЕсли;
	
	ДанныеДопСтрокБД = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрок Цикл 
		ДанныеДопСтрокБД.Вставить(КЗ.Ключ, ПолучитьИзВременногоХранилища(КЗ.Значение));
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура;
			
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДанныеДопСтрокБД", ДанныеДопСтрокБД);
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ДанныеМногостраничныхРазделов = СтруктураПараметров.ДанныеМногостраничныхРазделов;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	ДанныеДопСтрокБД = СтруктураПараметров.ДанныеДопСтрокБД;
	ДанныеДопСтрок = Новый Структура;
	ДанныеДопСтрокСтраницы = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрокБД Цикл 
		ДанныеДопСтрок.Вставить(КЗ.Ключ, ПоместитьВоВременноеХранилище(КЗ.Значение, Новый УникальныйИдентификатор));
		Стр = Новый Структура;
		Для Каждого Кол Из КЗ.Значение.Колонки Цикл 
			Если Кол.Имя <> "УИД" Тогда 
				Стр.Вставить(Кол.Имя);
			КонецЕсли;
		КонецЦикла;
		СЗ = Новый СписокЗначений;
		СЗ.Добавить(Стр);
		ДанныеДопСтрокСтраницы.Вставить(КЗ.Ключ, СЗ);
	КонецЦикла;
	
	УведомлениеЗаполненоВПомощнике = СтруктураПараметров.Свойство("ДанныеПомощникаЗаполнения");
	
	Если УведомлениеЗаполненоВПомощнике
		И ТипЗнч(СтруктураПараметров.ДанныеПомощникаЗаполнения) = Тип("Структура") Тогда
		СтруктураПараметров.ДанныеПомощникаЗаполнения.Свойство("ИмяПомощника", ИмяПомощника);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли Область.Имя = "ПодобратьИзКлассификатора" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", "Ввод адреса");
		ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресОрганизации"));
		ПараметрыФормы.Вставить("КонтактнаяИнформация", ПредставлениеУведомления.Области.АдресJSON.Значение);
		ПараметрыФормы.Вставить("ЗначенияПолей", ПредставлениеУведомления.Области.АдресJSON.Значение);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТекущееИДНаименования", ТекущееИДНаименования);
		ДополнительныеПараметры.Вставить("УИДТекущаяСтраница", УИДТекущаяСтраница);
		
		ТипЗначения = Тип("ОписаниеОповещения");
		ПараметрыКонструктора = Новый Массив(3);
		ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
		ПараметрыКонструктора[1] = ЭтотОбъект;
		ПараметрыКонструктора[2] = ДополнительныеПараметры;
		
		Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ТекущийМакет = "Форма2021_1_Титульная" Тогда 
		Если Область.Имя = "КодНО" Тогда 
			СтандартнаяОбработка = Ложь;
			ОбработкаКодаНО(Область.Имя);
		ИначеЕсли Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
			ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораПодписантаЗавершение", ЭтотОбъект, Неопределено);
			УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления",
																		"ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ОписаниеОповещения);
			Возврат;
		КонецЕсли;
	ИначеЕсли  ТекущийМакет = "Форма2021_1_Лист2" И Область.Имя = "ВыводитьНольНаПечать" Тогда 
		Область.Значение = Не Область.Значение;
		СтандартнаяОбработка = Ложь;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина, Истина);
	КонецЕсли;
	
	Если Область.Имя = "КодРегион" И (ТекущееИДНаименования <> "Форма2021_1_Титульная") Тогда 
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	ОбновитьАдресВТабличномДокументе(Результат, Параметры.ТекущееИДНаименования, Параметры.УИДТекущаяСтраница);
КонецПроцедуры

&НаСервере
Процедура ОбновитьАдресВТабличномДокументе(Результат, ТекущееИДНаименования, УИДТекущаяСтраница)
	УведомлениеОСпецрежимахНалогообложения.ОбновитьАдресВМногостраничнойСтранице(Результат, ЭтотОбъект, ТекущееИДНаименования, УИДТекущаяСтраница)
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Результат.Свойство("Фамилия", Объект.ПодписантФамилия);
		Результат.Свойство("Имя", Объект.ПодписантИмя);
		Результат.Свойство("Отчество", Объект.ПодписантОтчество);
		Представление = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		Область = ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ");
		Область.Значение = Представление;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	ТЗМнг = ДанныеМногостраничныхРазделов[ТекущееИДНаименования];
	ПерваяСтраница = ТЗМнг[0].Значение;
	НоваяСтраница = ТЗМнг[ТЗМнг.Количество() - 1].Значение;
	НоваяСтраница.КодРегион = ПерваяСтраница.КодРегион;
	НоваяСтраница.КодНОУчет = ПерваяСтраница.КодНОУчет;
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	УдалениеСтраницы = Истина;
	УдалитьСтраницуНаСервере();
	УдалениеСтраницы = Ложь;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	Для Каждого Стр Из ТекущиеМногострочныеЧасти Цикл 
		ТЗ = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[Стр.Значение]);
		Строки = ТЗ.НайтиСтроки(Новый Структура("УИД", УИДТекущаяСтраница));
		Для Каждого СтрМнг Из Строки Цикл 
			ТЗ.Удалить(СтрМнг);
		КонецЦикла;
		ДанныеДопСтрок[Стр.Значение] = ПоместитьВоВременноеХранилище(ТЗ, ДанныеДопСтрок[Стр.Значение]);
	КонецЦикла;
	
	НовИд = УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
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

&НаКлиенте
Процедура ЗакрытьУведомлениеЗаполненоВПомощникеНажатие(Элемент)
	
	УведомлениеЗаполненоВПомощнике = Ложь;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеЗаполненоВПомощникеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПомощникЗаполнения" И Не ПустаяСтрока(ИмяПомощника) Тогда
		ОткрытьФорму(СтрШаблон("Обработка.%1.Форма", ИмяПомощника),
			Новый Структура("Ключ", Объект.Ссылка), ВладелецФормы);
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
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
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, , Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
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
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2021_1"),
			"1150010_5.09000_10.tif");
		КонецФункции

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ГруппаУведомлениеИзПомощника.Видимость = Форма.УведомлениеЗаполненоВПомощнике;
	
КонецПроцедуры
