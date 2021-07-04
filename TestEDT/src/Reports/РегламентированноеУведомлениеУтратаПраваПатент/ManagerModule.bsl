#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "По приказу ФНС от 23.04.2014 N ММВ-7-3/250@";
	Стр.ДатаНачала = '20140101';
	Стр.ДатаКонца = '20190731';
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2019_1";
	Стр.ОписаниеФормы = "По приказу ФНС от 12.07.2019 № ММВ-7-3/352@ (в редакции от 21.08.2020 № ЕД-7-3/597@)";
	Стр.ДатаНачала = '20190801';
	Стр.ДатаКонца = '20991231';
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразуПолучениеПатентаРекомендованнаяФорма_Форма2014_1(Объект);
	ИначеЕсли ИмяФормы = "Форма2019_1" Тогда
		Возврат ПечатьСразуПолучениеПатентаРекомендованнаяФорма_Форма2019_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакетПолучениеПатентаРекомендованнаяФорма_Форма2014_1(Объект);
	ИначеЕсли ИмяФормы = "Форма2019_1" Тогда
		Возврат СформироватьМакетПолучениеПатентаРекомендованнаяФорма_Форма2019_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	ИначеЕсли ИмяФормы = "Форма2019_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2014_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор);
	ИначеЕсли ИмяФормы = "Форма2019_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2019_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция СформироватьМакетПолучениеПатентаРекомендованнаяФорма_Форма2014_1(Объект)
	
	ПечатнаяФорма = Новый ТабличныйДокумент;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2014_1");
	Область1 = МакетУведомления.ПолучитьОбласть("Страница1");
	ПараметрыМакета = Область1.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Строка = СтруктураПараметров.Титульный[0];
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.П_ИНН_1, "ИНН_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.КОД_НО, "КОД_НО_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ФАМИЛИЯ_ИП, "Фамилия_", ПараметрыМакета, 37);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ИМЯ_ИП, "Имя_", ПараметрыМакета, 37);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ОТЧЕСТВО_ИП, "Отчество_", ПараметрыМакета, 37);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 40);
	ВсегоСтраниц = 1 + СтруктураПараметров.Листы3.Количество();
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(ВсегоСтраниц, "НаСтраницах_", ПараметрыМакета, 3, Истина);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Строка.КОЛИЧЕСТВО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3, Истина);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка.ДАТА_ПОДПИСИ, "ДатаПодписи_", ПараметрыМакета);
	ПараметрыМакета.ПризнакПредставителя = Строка.ПРИЗНАК_НП_ПОДВАЛ;
	ПараметрыМакета.КОД_ПРИЧИНЫ = СтруктураПараметров.Титульный[0].КОД_ПРИЧИНЫ;
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка.ДАТА_УТРАТЫ_ПРАВА, "ДатаОбстоятельства_", ПараметрыМакета);
	
	ПечатнаяФорма.Вывести(Область1);
	ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	
	НомерЛиста = 2;
	Для Каждого Строка Из СтруктураПараметров.Листы3 Цикл 
		Область3 = МакетУведомления.ПолучитьОбласть("Страница3_1");
		ПараметрыМакета = Область3.Параметры;
		
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.Титульный[0].П_ИНН_1, "ИНН_", ПараметрыМакета, 12);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Формат(НомерЛиста, "ЧЦ=3; ЧН=; ЧВН="), "Страница_", ПараметрыМакета, 3);
		ПечатнаяФорма.Вывести(Область3);
		
		Для Инд = 1 По 17 Цикл
			Область3 = МакетУведомления.ПолучитьОбласть("Страница3_2_1");
			ПараметрыМакета = Область3.Параметры;
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка["НОМЕР_ПАТЕНТА_"+Инд], "НОМЕР_ПАТЕНТА_", ПараметрыМакета, 13);
			Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка["ДАТА_НАЧАЛА_"+Инд], "ДатаНачалаДействия_", ПараметрыМакета);
			Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка["ДАТА_ОКОНЧАНИЕ_"+Инд], "ДатаОкончанияДействия_", ПараметрыМакета);
			ПечатнаяФорма.Вывести(Область3);
		КонецЦикла;
		
		Область3 = МакетУведомления.ПолучитьОбласть("Страница3_3");
		ПечатнаяФорма.Вывести(Область3);
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
		НомерЛиста = НомерЛиста + 1;
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция СформироватьМакетПолучениеПатентаРекомендованнаяФорма_Форма2019_1(Объект)
	
	ПечатнаяФорма = Новый ТабличныйДокумент;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2019_1");
	Область1 = МакетУведомления.ПолучитьОбласть("Страница1");
	ПараметрыМакета = Область1.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Строка = СтруктураПараметров.Титульный[0];
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.П_ИНН_1, "ИНН_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.КОД_НО, "КОД_НО_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ФАМИЛИЯ_ИП, "Фамилия_", ПараметрыМакета, 35);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ИМЯ_ИП, "Имя_", ПараметрыМакета, 35);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ОТЧЕСТВО_ИП, "Отчество_", ПараметрыМакета, 35);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 40);
	ВсегоСтраниц = 1 + СтруктураПараметров.Листы3.Количество();
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(ВсегоСтраниц, "НаСтраницах_", ПараметрыМакета, 3, Истина);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Строка.КОЛИЧЕСТВО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3, Истина);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка.ДАТА_ПОДПИСИ, "ДатаПодписи_", ПараметрыМакета);
	ПараметрыМакета.ПризнакПредставителя = Строка.ПРИЗНАК_НП_ПОДВАЛ;
	ПараметрыМакета.КОД_ПРИЧИНЫ = СтруктураПараметров.Титульный[0].КОД_ПРИЧИНЫ;
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка.ДАТА_УТРАТЫ_ПРАВА, "ДатаОбстоятельства_", ПараметрыМакета);
	
	ПечатнаяФорма.Вывести(Область1);
	ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	
	НомерЛиста = 2;
	Для Каждого Строка Из СтруктураПараметров.Листы3 Цикл 
		Область3 = МакетУведомления.ПолучитьОбласть("Страница3_1");
		ПараметрыМакета = Область3.Параметры;
		
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.Титульный[0].П_ИНН_1, "ИНН_", ПараметрыМакета, 12);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Формат(НомерЛиста, "ЧЦ=3; ЧН=; ЧВН="), "Страница_", ПараметрыМакета, 3);
		ПечатнаяФорма.Вывести(Область3);
		
		Для Инд = 1 По 17 Цикл
			Область3 = МакетУведомления.ПолучитьОбласть("Страница3_2_1");
			ПараметрыМакета = Область3.Параметры;
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Строка["НОМЕР_ПАТЕНТА_"+Инд], "НОМЕР_ПАТЕНТА_", ПараметрыМакета, 13);
			Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка["ДАТА_НАЧАЛА_"+Инд], "ДатаНачалаДействия_", ПараметрыМакета);
			Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Строка["ДАТА_ОКОНЧАНИЕ_"+Инд], "ДатаОкончанияДействия_", ПараметрыМакета);
			ПараметрыМакета["НОМЕР_СТР"] = Формат(Инд, "ЧЦ=2; ЧВН=");
			ПечатнаяФорма.Вывести(Область3);
		КонецЦикла;
		
		Область3 = МакетУведомления.ПолучитьОбласть("Страница3_3");
		ПечатнаяФорма.Вывести(Область3);
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
		НомерЛиста = НомерЛиста + 1;
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразуПолучениеПатентаРекомендованнаяФорма_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакетПолучениеПатентаРекомендованнаяФорма_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ПечатьСразуПолучениеПатентаРекомендованнаяФорма_Форма2019_1(Объект)
	
	ПечатнаяФорма = СформироватьМакетПолучениеПатентаРекомендованнаяФорма_Форма2019_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "SR_ZUTRPSN";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные.Титульный[0];
	
	Ошибок = 0;
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_УТРАТЫ_ПРАВА) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнена дата утраты права на применение патентной системы", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_ПРИЧИНЫ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен код утраты права на применение патентной системы", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Ошибок > 0 Тогда
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	
	ОсновныеСведения = Новый Структура("ЭтоПБОЮЛ", Истина);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	Данные = Объект.ДанныеУведомления.Получить();
	Титульный = Данные.Титульный[0];
	
	ОсновныеСведения.Вставить("Фамилия", СокрЛП(Титульный.ФАМИЛИЯ_ИП));
	ОсновныеСведения.Вставить("Имя",  СокрЛП(Титульный.ИМЯ_ИП));
	ОсновныеСведения.Вставить("Отчество",  СокрЛП(Титульный.ОТЧЕСТВО_ИП));
	ОсновныеСведения.Вставить("ДатаУтрПСН", Формат(Титульный.ДАТА_УТРАТЫ_ПРАВА, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("КодППункт", Титульный.КОД_ПРИЧИНЫ);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор)
	
	ОсновныеСведения = Новый Структура("ЭтоПБОЮЛ", Истина);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	Данные = Объект.ДанныеУведомления.Получить();
	Титульный = Данные.Титульный[0];
	
	ОсновныеСведения.Вставить("Фамилия", СокрЛП(Титульный.ФАМИЛИЯ_ИП));
	ОсновныеСведения.Вставить("Имя",  СокрЛП(Титульный.ИМЯ_ИП));
	ОсновныеСведения.Вставить("Отчество",  СокрЛП(Титульный.ОТЧЕСТВО_ИП));
	ОсновныеСведения.Вставить("ДатаУтрПСН", Формат(Титульный.ДАТА_УТРАТЫ_ПРАВА, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("КодППункт", Титульный.КОД_ПРИЧИНЫ);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2014_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_ЗУтрПСН = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "ЗУтрПСН");
	СвДействПт = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ЗУтрПСН, "СвДействПт");
	Узел_ДействПт = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(СвДействПт, "ДействПт");
	
	Данные = Объект.ДанныеУведомления.Получить();
	Листы3 = Данные.Листы3;
	Для Каждого Лист3 Из Листы3 Цикл
		Для Инд = 1 По 17 Цикл 
			Патент = СокрЛП(Лист3["НОМЕР_ПАТЕНТА_" + Инд]);
			Если ЗначениеЗаполнено(Патент) Тогда 
				НовыйУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_ДействПт);
				
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел, "НомерПт", Патент);
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел, "ДатаНачПт", Формат(Лист3["ДАТА_НАЧАЛА_" + Инд], "ДФ=dd.MM.yyyy"));
				
				Если ЗначениеЗаполнено(Лист3["ДАТА_ОКОНЧАНИЕ_" + Инд]) Тогда 
					Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел, "ДатаКонПт", Формат(Лист3["ДАТА_ОКОНЧАНИЕ_" + Инд], "ДФ=dd.MM.yyyy"));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	РегламентированнаяОтчетность.УдалитьУзел(Узел_ДействПт);
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульный = Данные.Титульный[0];
	
	Если Не ЗначениеЗаполнено(Титульный.П_ИНН_1) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН на титульном листе", "Титульный", "П_ИНН_1", Титульный.UID));
	ИначеЕсли СтрДлина(СокрЛП(Титульный.П_ИНН_1)) <> 12 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_ИНН_1) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН на титульном листе", "Титульный", "П_ИНН_1", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_ПРИЧИНЫ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код причины утраты права", "Титульный", "КОД_ПРИЧИНЫ", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_УТРАТЫ_ПРАВА) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата утраты права", "Титульный", "ДАТА_УТРАТЫ_ПРАВА", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ФАМИЛИЯ_ИП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана фамилия", "ТитульныйЛист", "ФАМИЛИЯ_ИП", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ИМЯ_ИП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано имя", "ТитульныйЛист", "ИМЯ_ИП", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_НО) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "ТитульныйЛист", "КОД_НО", Титульный.UID));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ЭлектронноеПредставление_Форма2019_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2019_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2019_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2019_1");
	ЗаполнитьДанными_Форма2019_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2019_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_ЗУтрПСН = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "ЗУтрПСН");
	СвДействПт = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ЗУтрПСН, "СвДействПт");
	Узел_ДействПт = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(СвДействПт, "ДействПт");
	
	Данные = Объект.ДанныеУведомления.Получить();
	Листы3 = Данные.Листы3;
	Для Каждого Лист3 Из Листы3 Цикл
		Для Инд = 1 По 17 Цикл 
			Патент = СокрЛП(Лист3["НОМЕР_ПАТЕНТА_" + Инд]);
			Если ЗначениеЗаполнено(Патент) Тогда 
				НовыйУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_ДействПт);
				
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел, "НомерПт", Патент);
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел, "ДатаНачПт", Формат(Лист3["ДАТА_НАЧАЛА_" + Инд], "ДФ=dd.MM.yyyy"));
				
				Если ЗначениеЗаполнено(Лист3["ДАТА_ОКОНЧАНИЕ_" + Инд]) Тогда 
					Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел, "ДатаКонПт", Формат(Лист3["ДАТА_ОКОНЧАНИЕ_" + Инд], "ДФ=dd.MM.yyyy"));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	РегламентированнаяОтчетность.УдалитьУзел(Узел_ДействПт);
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу_Форма2019_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульный = Данные.Титульный[0];
	
	Если Не ЗначениеЗаполнено(Титульный.П_ИНН_1) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН на титульном листе", "Титульный", "П_ИНН_1", Титульный.UID));
	ИначеЕсли СтрДлина(СокрЛП(Титульный.П_ИНН_1)) <> 12 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_ИНН_1) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН на титульном листе", "Титульный", "П_ИНН_1", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_ПРИЧИНЫ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код причины утраты права", "Титульный", "КОД_ПРИЧИНЫ", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_УТРАТЫ_ПРАВА) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата утраты права", "Титульный", "ДАТА_УТРАТЫ_ПРАВА", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ФАМИЛИЯ_ИП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана фамилия", "ТитульныйЛист", "ФАМИЛИЯ_ИП", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.ИМЯ_ИП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано имя", "ТитульныйЛист", "ИМЯ_ИП", Титульный.UID));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_НО) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "ТитульныйЛист", "КОД_НО", Титульный.UID));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

#КонецОбласти
#КонецЕсли