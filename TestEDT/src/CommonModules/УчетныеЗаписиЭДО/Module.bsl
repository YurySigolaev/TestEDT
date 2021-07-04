
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание запроса, в результате которого будут содержаться учетные записи.
// Запрос содержит следующие поля:
//  * ИдентификаторЭДО - Строка - идентификатор учетной записи
//  * НаименованиеУчетнойЗаписи - Строка - наименование учетной записи
//  * НазначениеУчетнойЗаписи - Строка - назначение учетной записи
//  * ПодробноеОписаниеУчетнойЗаписи - Строка - подробное описание учетной записи
//  * Организация - ОпределяемыйТип.Организация
//  * ОператорЭДО - Строка - идентификатор оператора электронного документооборота
//  * СпособОбменаЭД - ПеречислениеСсылка.СпособыОбменаЭД
//  * ПринятыУсловияИспользования - Булево - пользователь принял условия использования сервиса
//                                  электронного документооборота
//  * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//  * ВозможенОбменБезПодписи - Булево
//  * ИмяФайлаСоглашенияНаРоуминг - Строка
//  * ДанныеСоглашенияНаРоуминг - ДвоичныеДанные
//  * ДатаСоглашенияНаРоуминг - Дата
//  * КаталогОбмена - Строка
//  * ПутьFTP - Строка
//  * УчетнаяЗаписьЭлектроннойПочты - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
//  * КодНалоговогоОргана - Строка.
// 
// Параметры:
// 	ИмяВременнойТаблицы - Строка - таблица, в которую будет помещен результат запроса
// 	Отбор - см. НовыйОтборУчетныхЗаписей
// Возвращаемое значение:
// 	см. ОбщегоНазначенияБЭД.НовоеОписаниеЗапроса
Функция ЗапросУчетныхЗаписей(ИмяВременнойТаблицы, Отбор = Неопределено) Экспорт
	
	Если Отбор = Неопределено Тогда
		Отбор = НовыйОтборУчетныхЗаписей();
	КонецЕсли;
	
	ПоляУсловия = Новый Массив;
	Если Отбор.УчетныеЗаписи <> "" Тогда
		ПоляУсловия.Добавить(СтрШаблон("ИдентификаторЭДО В(%1)", Отбор.УчетныеЗаписи));
	КонецЕсли;
	Если Отбор.Организация <> "" Тогда
		ПоляУсловия.Добавить(СтрШаблон("Организация В (%1)", Отбор.Организация));
	КонецЕсли;
	Если Отбор.СпособОбмена <> "" Тогда
		ПоляУсловия.Добавить(СтрШаблон("СпособОбменаЭД В (%1)", Отбор.СпособОбмена));
	КонецЕсли;
	Если Отбор.Оператор <> "" Тогда
		ПоляУсловия.Добавить(СтрШаблон("ОператорЭДО В (%1)", Отбор.Оператор));
	КонецЕсли;
	
	ОписаниеЗапроса = ОбщегоНазначенияБЭД.НовоеОписаниеЗапроса();
	ОписаниеЗапроса.Текст = ШаблонЗапросаУчетныхЗаписей(ИмяВременнойТаблицы,
		"ИдентификаторЭДО, НаименованиеУчетнойЗаписи, НазначениеУчетнойЗаписи, ПодробноеОписаниеУчетнойЗаписи,
		|Организация, ОператорЭДО, СпособОбменаЭД, ПринятыУсловияИспользования,
		|СпособОбменаЭД В (&СпособыПрямогоОбмена) КАК ВозможенОбменБезПодписи,
		|ИмяФайлаСоглашенияНаРоуминг, ДанныеСоглашенияНаРоуминг, ДатаСоглашенияНаРоуминг,
		|КаталогОбмена, ПутьFTP, УчетнаяЗаписьЭлектроннойПочты, КодНалоговогоОргана", ПоляУсловия);
		
	ОписаниеЗапроса.СлужебныеПараметры.Вставить("СпособыПрямогоОбмена", СинхронизацияЭДО.СпособыПрямогоОбмена());
	Возврат ОписаниеЗапроса;
	
КонецФункции

// Возвращает описание запроса, в результате которого будут содержаться сертификаты учетных записей.
// Запрос содержит следующие поля:
//  * ИдентификаторЭДО - Строка - идентификатор учетной записи
//  * Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования.
// 
// Параметры:
// 	ИмяВременнойТаблицы - Строка
// 	Отбор - см. НовыйОтборСертификатовУчетныхЗаписей
// Возвращаемое значение:
// 	См. ОбщегоНазначенияБЭД.НовоеОписаниеЗапроса
Функция ЗапросСертификатовУчетныхЗаписей(ИмяВременнойТаблицы, Отбор = Неопределено) Экспорт
	
	Если Отбор = Неопределено Тогда
		Отбор = НовыйОтборСертификатовУчетныхЗаписей();
	КонецЕсли;
	
	ПоляУсловия = Новый Массив;
	Если ЗначениеЗаполнено(Отбор.УчетныеЗаписи) Тогда
		ПоляУсловия.Добавить(СтрШаблон("СертификатыУчетныхЗаписей.ИдентификаторЭДО В(%1)", Отбор.УчетныеЗаписи));
	КонецЕсли;
	Если Отбор.ТолькоДействительные Тогда
		ПоляУсловия.Добавить("РАЗНОСТЬДАТ(&ТекущаяДата, СертификатыУчетныхЗаписей.ДействителенДо, МИНУТА) > 0");
	КонецЕсли;
	Если ЗначениеЗаполнено(Отбор.Сертификат) Тогда
		ПоляУсловия.Добавить(СтрШаблон("СертификатыУчетныхЗаписей.Сертификат В(%1)", Отбор.Сертификат));
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	СертификатыУчетныхЗаписей.ИдентификаторЭДО КАК ИдентификаторЭДО,
	|	СертификатыУчетныхЗаписей.Сертификат КАК Сертификат
	|ПОМЕСТИТЬ ИмяВременнойТаблицы
	|ИЗ
	|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписей
	|ГДЕ
	|&ПоляУсловия";
	
	ТекстЗапроса = ОбщегоНазначенияБЭД.ТекстЗапросаИзШаблона(ТекстЗапроса, ИмяВременнойТаблицы, "", ПоляУсловия);
	
	ОписаниеЗапроса = ОбщегоНазначенияБЭД.НовоеОписаниеЗапроса();
	ОписаниеЗапроса.Текст = ТекстЗапроса;
	ОписаниеЗапроса.СлужебныеПараметры.Вставить("ТекущаяДата", ТекущаяДатаСеанса());
	
	Возврат ОписаниеЗапроса;
	
КонецФункции

// Возвращает учетные записи с непринятыми условиями использования.
// 
// Параметры:
// 	ИдентификаторыУчетныхЗаписей - Массив из Строка
// Возвращаемое значение:
// 	Массив из Строка - идентификаторы учетных записей
Функция УчетныеЗаписиЭДОБезПринятыхУсловийСервиса(ИдентификаторыУчетныхЗаписей) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|ГДЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО В(&ИдентификаторыОрганизаций)
		|	И НЕ УчетныеЗаписиЭДО.ПринятыУсловияИспользования
		|	И НЕ УчетныеЗаписиЭДО.СпособОбменаЭД В (&СпособОбменаЭД)";
	
	Запрос.УстановитьПараметр("ИдентификаторыОрганизаций", ИдентификаторыУчетныхЗаписей);
	Запрос.УстановитьПараметр("СпособОбменаЭД", СинхронизацияЭДО.СпособыПрямогоОбмена());
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.ИдентификаторЭДО);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает описание запроса, в результате которого будут содержаться настройки учетных записей.
// 
// Параметры:
// 	ИмяВременнойТаблицы - Строка - таблица, в которую будет помещен результат запроса
// 	Отбор - см. НовыйОтборУчетныхЗаписей
// Возвращаемое значение:
// 	см. ОбщегоНазначенияБЭД.НовоеОписаниеЗапроса
Функция ЗапросНастроекУчетныхЗаписей(ИмяВременнойТаблицы, Отбор = Неопределено) Экспорт
	
	Если Отбор = Неопределено Тогда
		Отбор = НовыйОтборУчетныхЗаписей();
	КонецЕсли;
	
	ПоляУсловия = Новый Массив;
	Если Отбор.УчетныеЗаписи <> "" Тогда
		ПоляУсловия.Добавить(СтрШаблон("ИдентификаторЭДО В(&%1)", Отбор.УчетныеЗаписи));
	КонецЕсли;
	Если Отбор.Организация <> "" Тогда
		ПоляУсловия.Добавить(СтрШаблон("Организация = &%1", Отбор.Организация));
	КонецЕсли;
	Если Отбор.СпособОбмена <> "" Тогда
		ПоляУсловия.Добавить(СтрШаблон("СпособОбменаЭД = &%1", Отбор.СпособОбмена));
	КонецЕсли;
	
	ОписаниеЗапроса = ОбщегоНазначенияБЭД.НовоеОписаниеЗапроса();
	ОписаниеЗапроса.Текст = ШаблонЗапросаУчетныхЗаписей(ИмяВременнойТаблицы,
		"ИдентификаторЭДО, Организация, ОператорЭДО, СпособОбменаЭД,
		|КаталогОбмена, ПассивноеСоединениеFTP, ПортFTP, ПутьFTP, УчетнаяЗаписьЭлектроннойПочты", ПоляУсловия);
	
	Возврат ОписаниеЗапроса;
	
КонецФункции

// Возвращает учетные записи без доступных сертификатов.
// 
// Параметры:
// 	ОтпечаткиДоступныхУчетныхЗаписей - Массив из Строка
// Возвращаемое значение:
// 	Массив из Строка - идентификаторы учетных записей
Функция УчетныеЗаписиБезДоступныхСертификатов(ОтпечаткиДоступныхУчетныхЗаписей) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО
	|ИЗ
	|	УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СертификатыУчетныхЗаписей КАК СертификатыУчетныхЗаписей
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ СертификатыКлючейЭлектроннойПодписиИШифрования КАК СертификатыКлючейЭлектроннойПодписиИШифрования
	|			ПО СертификатыУчетныхЗаписей.Сертификат = СертификатыКлючейЭлектроннойПодписиИШифрования.Ссылка
	|		ПО СертификатыУчетныхЗаписей.ИдентификаторЭДО = УчетныеЗаписиЭДО.ИдентификаторЭДО,
	|	Организации КАК Организации
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО
	|ИЗ
	|	УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|		ЛЕВОЕ СОЕДИНЕНИЕ СертификатыУчетныхЗаписей КАК СертификатыУчетныхЗаписей
	|		ПО УчетныеЗаписиЭДО.ИдентификаторЭДО = СертификатыУчетныхЗаписей.ИдентификаторЭДО
	|		ЛЕВОЕ СОЕДИНЕНИЕ НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиПоВидам
	|		ПО УчетныеЗаписиЭДО.ИдентификаторЭДО = НастройкиОтправкиПоВидам.ИдентификаторОтправителя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Организации КАК Организации
	|		ПО УчетныеЗаписиЭДО.Организация = Организации.Ссылка
	|ГДЕ
	|	(НастройкиОтправкиПоВидам.ОбменБезПодписи = ЛОЖЬ
	|			ИЛИ НЕ УчетныеЗаписиЭДО.СпособОбменаЭД В (&СпособыПрямогоОбмена))
	|	И СертификатыУчетныхЗаписей.Сертификат ЕСТЬ NULL";
	
	Отбор = КриптографияБЭД.НовыйОтборНедействующихИлиНедоступныхСертификатов();
	Отбор.ОпечаткиДоступныхСертификатов = "Отпечатки";
	Запросы = Новый Массив;
	Запросы.Добавить(КриптографияБЭД.ЗапросНеДействующихИлиНедоступныхСертификатов(
		"СертификатыКлючейЭлектроннойПодписиИШифрования", Отбор));
	Запросы.Добавить(ИнтеграцияЭДО.ЗапросДоступныхОрганизаций("Организации"));
	ОтборУчетныхЗаписей = НовыйОтборУчетныхЗаписей();
	Запросы.Добавить(ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО", ОтборУчетныхЗаписей));
	Запросы.Добавить(НастройкиЭДО.ЗапросНастроекОтправкиУчетныхЗаписей("НастройкиОтправкиЭлектронныхДокументовПоВидам"));
	Запросы.Добавить(ЗапросСертификатовУчетныхЗаписей("СертификатыУчетныхЗаписей"));
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("СпособыПрямогоОбмена", СинхронизацияЭДО.СпособыПрямогоОбмена());
	ИтоговыйЗапрос.УстановитьПараметр("Отпечатки", ОтпечаткиДоступныхУчетныхЗаписей);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = ИтоговыйЗапрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Выборка = РезультатЗапроса.Выбрать();
	
	УчетныеЗаписи = Новый Массив;
	Пока Выборка.Следующий() Цикл
		УчетныеЗаписи.Добавить(Выборка.ИдентификаторЭДО);
	КонецЦикла;
	
	Возврат УчетныеЗаписи;
	
КонецФункции

// Возвращает структуру для получения запроса учетных записей. См. ЗапросУчетныхЗаписей.
// 
// Возвращаемое значение:
// 	Структура:
// * УчетныеЗаписи - Строка - параметр или выражение для отбора по идентификаторам учетных записей
// * Организация - Строка - параметр или выражение для отбора по организации
// * СпособОбмена - Строка - параметр или выражение для отбора по способу обмена
// * Оператор - Строка - параметр или выражение для отбора по оператору
Функция НовыйОтборУчетныхЗаписей() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("УчетныеЗаписи", "");
	Отбор.Вставить("Организация", "");
	Отбор.Вставить("СпособОбмена", "");
	Отбор.Вставить("Оператор", "");
	
	Возврат Отбор;
	
КонецФункции

// Возвращает структуру для получения запроса сертификатов учетных записей. См. ЗапросСертификатовУчетныхЗаписей.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * УчетныеЗаписи - Строка - параметр или выражение для отбора по идентификаторам учетных записей
// * ТолькоДействительные - Булево - отбирать только действительные сертификаты
// * Сертификат - Строка - параметр или выражение для отбора по сертификатам
Функция НовыйОтборСертификатовУчетныхЗаписей() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("УчетныеЗаписи", "");
	Отбор.Вставить("ТолькоДействительные", Ложь);
	Отбор.Вставить("Сертификат", "");
	
	Возврат Отбор;
	
КонецФункции

// Изменяет свойство учетной записи "Версия конфигурации".
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// 	ВерсияКонфигурации - Строка
Процедура ИзменитьВерсиюКонфигурации(ИдентификаторУчетнойЗаписи, ВерсияКонфигурации) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИдентификаторЭДО = ИдентификаторУчетнойЗаписи;
	МенеджерЗаписи.Прочитать();

	Если МенеджерЗаписи.Выбран() И МенеджерЗаписи.ВерсияКонфигурации <> ВерсияКонфигурации Тогда

		МенеджерЗаписи.ВерсияКонфигурации = ВерсияКонфигурации;
		МенеджерЗаписи.Записать();

	КонецЕсли;
		
КонецПроцедуры

// Возвращает параметры учетной записи для обмена по FTP.
// 
// Параметры:
// 	УчетнаяЗапись - РегистрСведенийЗапись.УчетныеЗаписиЭДО
// Возвращаемое значение:
// 	Структура:
//    * ПутьFTP - Строка
//    * ПортFTP - Число
//    * Идентификатор - Строка
//    * ПассивноеСоединениеFTP - Булево
Функция ПараметрыУчетнойЗаписиДляОбменаПоFTP(УчетнаяЗапись) Экспорт
	
	ДанныеУчетнойЗаписи = Новый Структура;
	ДанныеУчетнойЗаписи.Вставить("ПутьFTP", УчетнаяЗапись.ПутьFTP);
	ДанныеУчетнойЗаписи.Вставить("ПортFTP", УчетнаяЗапись.ПортFTP);
	ДанныеУчетнойЗаписи.Вставить("Идентификатор", УчетнаяЗапись.ИдентификаторЭДО);
	ДанныеУчетнойЗаписи.Вставить("ПассивноеСоединениеFTP", УчетнаяЗапись.ПассивноеСоединениеFTP);
	
	Возврат ДанныеУчетнойЗаписи;
	
КонецФункции

// Возвращает список идентификаторов и их представлений по организации и обособленным подразделениям для сервиса ЭДО.
//
// Параметры:
//   Организация - ОпределяемыйТип.Организация
//
// Возвращаемое значение:
//   СписокЗначений - список идентификаторов организации и их представлений.
//
Функция СписокИдентификаторовУчетныхЗаписейОрганизацииСервисаЭДО(Организация) Экспорт
	
	МассивЗначенийСвойств = ЗначенияСвойствУчетныхЗаписейОрганизацииСервисаЭДО(Организация,
		"ИдентификаторЭДО, НаименованиеУчетнойЗаписи");
	
	СписокИдентификаторов = Новый СписокЗначений;
	Для каждого ЗначенияСвойств Из МассивЗначенийСвойств Цикл
		СписокИдентификаторов.Добавить(ЗначенияСвойств.ИдентификаторЭДО, ЗначенияСвойств.НаименованиеУчетнойЗаписи);
	КонецЦикла; 
	
	Возврат СписокИдентификаторов;
	
КонецФункции

// Сохраняет данные соглашения на роуминг.
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// 	ДанныеСоглашенияНаРоуминг - ДвоичныеДанные
// 	ИмяФайла - Строка
// Возвращаемое значение:
// 	Структура:
// * Статус - Булево - Истина, если сохранение прошло успешно
// * ОписаниеОшибки - Строка
Функция ЗаписатьДанныеСоглашенияНаРоуминг(ИдентификаторУчетнойЗаписи, ДанныеСоглашенияНаРоуминг, ИмяФайла) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", Истина);
	Результат.Вставить("ОписаниеОшибки");
	
	НачатьТранзакцию();
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку(
			"РегистрСведений.УчетныеЗаписиЭДО", Новый Структура("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи));
		
		МенеджерЗаписи = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ИдентификаторЭДО = ИдентификаторУчетнойЗаписи;
		
		МенеджерЗаписи.Прочитать();
		Если Не МенеджерЗаписи.Выбран() Тогда
			Результат.Статус = Ложь;
			Результат.ОписаниеОшибки = НСтр("ru = 'Не найдена учетная запись организации'");
			ЗафиксироватьТранзакцию();
			Возврат Результат;
		КонецЕсли;
		
		МенеджерЗаписи.ИмяФайлаСоглашенияНаРоуминг = ИмяФайла;
		МенеджерЗаписи.ДанныеСоглашенияНаРоуминг = Новый ХранилищеЗначения(
			ДанныеСоглашенияНаРоуминг, Новый СжатиеДанных(9));
		МенеджерЗаписи.ДатаСоглашенияНаРоуминг = ТекущаяУниверсальнаяДата() + СмещениеСтандартногоВремени("GMT+3");
		МенеджерЗаписи.Записать();
		
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Результат.Статус = Ложь;
		Результат.ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Отправка приглашений ЭДО'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Удаляет данные соглашения на роуминг.
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// Возвращаемое значение:
// 	Булево
Функция УдалитьДанныеСоглашенияНаРоуминг(ИдентификаторУчетнойЗаписи) Экспорт
	
	Результат = Истина;
	
	НачатьТранзакцию();
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку(
			"РегистрСведений.УчетныеЗаписиЭДО", Новый Структура("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи));
		
		МенеджерЗаписи = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ИдентификаторЭДО = ИдентификаторУчетнойЗаписи;
		
		МенеджерЗаписи.Прочитать();
		Если Не МенеджерЗаписи.Выбран() Тогда
			Результат = Ложь;
			ЗафиксироватьТранзакцию();
			Возврат Результат;
		КонецЕсли;
		
		МенеджерЗаписи.ИмяФайлаСоглашенияНаРоуминг = "";
		МенеджерЗаписи.ДанныеСоглашенияНаРоуминг   = Новый ХранилищеЗначения(Неопределено);
		МенеджерЗаписи.ДатаСоглашенияНаРоуминг     = '00010101';
		МенеджерЗаписи.Записать();
		
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Результат = Ложь;
		
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Отправка приглашений ЭДО'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			НСтр("ru = 'Не удалось удалить данные соглашения на роуминг для учетной записи организации'"));
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Возвращает электронные адреса для уведомлений о статусе заявке на роуминг.
// 
// Параметры:
// 	Организация - ОпределяемыйТип.Организация
// Возвращаемое значение:
// 	Массив из Строка
Функция ЭлектронныеАдресаДляУведомленияОСтатусеЗаявкиНаРоуминг(Организация) Экспорт
	
	ДанныеУчетныхЗаписей = ЗначенияСвойствУчетныхЗаписейОрганизацииСервисаЭДО(Организация, "ЭлектроннаяПочтаДляУведомлений, EmailОрганизации");
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Организация),
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,,
		ТекущаяДатаСеанса());
	
	МассивEmailОрганизации = Новый Массив;
	МассивЭлектроннаяПочтаДляУведомлений = Новый Массив;
	МассивКонтактнаяИнформация = Новый Массив;
	Для каждого ДанныеУчетнойЗаписи Из ДанныеУчетныхЗаписей Цикл
		Если ЗначениеЗаполнено(ДанныеУчетнойЗаписи.EmailОрганизации)
			И МассивEmailОрганизации.Найти(ДанныеУчетнойЗаписи.EmailОрганизации) = Неопределено Тогда
			МассивEmailОрганизации.Добавить(ДанныеУчетнойЗаписи.EmailОрганизации);
		КонецЕсли;
		Если ЗначениеЗаполнено(ДанныеУчетнойЗаписи.ЭлектроннаяПочтаДляУведомлений)
			И МассивЭлектроннаяПочтаДляУведомлений.Найти(ДанныеУчетнойЗаписи.ЭлектроннаяПочтаДляУведомлений) = Неопределено Тогда
			МассивЭлектроннаяПочтаДляУведомлений.Добавить(ДанныеУчетнойЗаписи.ЭлектроннаяПочтаДляУведомлений);
		КонецЕсли;
	КонецЦикла;
	Для каждого ЭлементКонтактнойИнформации Из КонтактнаяИнформация Цикл
		Если ЗначениеЗаполнено(ЭлементКонтактнойИнформации.Представление)
			И МассивКонтактнаяИнформация.Найти(ЭлементКонтактнойИнформации.Представление) = Неопределено Тогда
			МассивКонтактнаяИнформация.Добавить(ЭлементКонтактнойИнформации.Представление);
		КонецЕсли;
	КонецЦикла; 
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивEmailОрганизации, МассивЭлектроннаяПочтаДляУведомлений, Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивEmailОрганизации, МассивКонтактнаяИнформация, Истина);
	
	Возврат МассивEmailОрганизации;
	
КонецФункции

// Сохраняет Email организации.
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// 	EmailОрганизации - Строка
Процедура ЗаписатьEmailОрганизации(ИдентификаторУчетнойЗаписи, EmailОрганизации) Экспорт
	
	НачатьТранзакцию();
	Попытка
		ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку(
			"РегистрСведений.УчетныеЗаписиЭДО", Новый Структура("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи));
		МенеджерЗаписиУчетнаяЗапись = РегистрыСведений.УчетныеЗаписиЭДО.СоздатьМенеджерЗаписи();
		МенеджерЗаписиУчетнаяЗапись.ИдентификаторЭДО = ИдентификаторУчетнойЗаписи;
		МенеджерЗаписиУчетнаяЗапись.Прочитать();
		МенеджерЗаписиУчетнаяЗапись.EmailОрганизации = EmailОрганизации;
		МенеджерЗаписиУчетнаяЗапись.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИмяСобытия = НСтр("ru = 'Запись email организации учетной записи электронного документооборота'",
			ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

// Возвращает данные учетной записи.
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// Возвращаемое значение:
// 	Структура, Неопределено - данные учетной записи:
//  * НаименованиеУчетнойЗаписи - Строка - наименование учетной записи
//  * ИдентификаторОрганизации - Строка - идентификатор учетной записи
//  * Организация - ОпределяемыйТип.Организация
//  * ОператорЭДО - Строка - идентификатор оператора электронного документооборота
//  * СпособОбменаЭД - ПеречислениеСсылка.СпособыОбменаЭД
Функция ДанныеУчетнойЗаписи(ИдентификаторУчетнойЗаписи) Экспорт 
	
	Данные = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи КАК НаименованиеУчетнойЗаписи,
		|	УчетныеЗаписиЭДО.Организация КАК Организация,
		|	УчетныеЗаписиЭДО.ОператорЭДО КАК ОператорЭДО,
		|	УчетныеЗаписиЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторОрганизации
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|ГДЕ
		|	УчетныеЗаписиЭДО.ИдентификаторЭДО = &ИдентификаторЭДО";
	
	Запрос.УстановитьПараметр("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаРезультат = РезультатЗапроса.Выгрузить();
	
	Если ТаблицаРезультат.Количество() > 0 Тогда
		
		Данные = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРезультат[0]);
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

// Возвращает таблицу учетных записей без сертификатов.
// 
// Возвращаемое значение:
// 	ТаблицаЗначений:
// * ИдентификаторЭДО - Строка
// * СообщениеЭДО - ДокументСсылка.СообщениеЭДО 
Функция НоваяТаблицаУчетныхЗаписейБезСертификатов() Экспорт
	
	УчетныеЗаписиБезСертификатов = Новый ТаблицаЗначений;
	УчетныеЗаписиБезСертификатов.Колонки.Добавить("ИдентификаторЭДО",
		Метаданные.РегистрыСведений.УчетныеЗаписиЭДО.Измерения.ИдентификаторЭДО.Тип);
	УчетныеЗаписиБезСертификатов.Колонки.Добавить("Сообщение", Новый ОписаниеТипов("ДокументСсылка.СообщениеЭДО"));
	
	Возврат УчетныеЗаписиБезСертификатов;
	
КонецФункции

// Возвращает ключ записи регистра сведений УчетныеЗаписиЭДО.
// 
// Параметры:
// 	ИдентификаторУчетнойЗаписи - Строка
// Возвращаемое значение:
// 	РегистрСведенийКлючЗаписи.УчетныеЗаписиЭДО
Функция КлючУчетнойЗаписи(ИдентификаторУчетнойЗаписи) Экспорт
	
	ЗначенияКлюча = Новый Структура("ИдентификаторЭДО", ИдентификаторУчетнойЗаписи);
	Возврат РегистрыСведений.УчетныеЗаписиЭДО.СоздатьКлючЗаписи(ЗначенияКлюча);
	
КонецФункции

// Создает учетную запись для обмена электронными документами.
// 
// Параметры:
// 	ОписаниеУчетнойЗаписи - см. УчетныеЗаписиЭДОКлиентСервер.НовоеОписаниеУчетнойЗаписи
// 	АдресИзменен - Булево
// Возвращаемое значение:
// 	Булево - учетная запись создана
Функция СоздатьУчетнуюЗапись(ОписаниеУчетнойЗаписи, АдресИзменен = Истина) Экспорт
	
	Возврат УчетныеЗаписиЭДОСлужебный.СоздатьУчетнуюЗапись(ОписаниеУчетнойЗаписи, АдресИзменен);

КонецФункции

Процедура ЗаписатьСертификатыУчетнойЗаписи(ИдентификаторУчетнойЗаписи, Знач Сертификаты,
	Замещать = Истина) Экспорт
	
	УчетныеЗаписиЭДОСлужебный.ЗаписатьСертификатыУчетнойЗаписи(ИдентификаторУчетнойЗаписи, Сертификаты, Замещать);
	
КонецПроцедуры

Функция УчетныеЗаписиЭДОДляОбновленияСертификата(Знач Организация, Знач Сертификат, Знач НовыйСертификат) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
	|	УчетныеЗаписиЭДО.Организация КАК Организация,
	|	УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи КАК НаименованиеУчетнойЗаписи,
	|	УчетныеЗаписиЭДО.ВерсияКонфигурации КАК ВерсияКонфигурации,
	|	УчетныеЗаписиЭДО.ОператорЭДО КАК ОператорЭДО,
	|	УчетныеЗаписиЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
	|	УчетныеЗаписиЭДО.ЭлектроннаяПочтаДляУведомлений КАК ЭлектроннаяПочтаДляУведомлений,
	|	УчетныеЗаписиЭДО.ОжидатьИзвещениеОПолучении КАК ОжидатьИзвещениеОПолучении,
	|	УчетныеЗаписиЭДО.УведомлятьОНовыхПриглашениях КАК УведомлятьОНовыхПриглашениях,
	|	УчетныеЗаписиЭДО.УведомлятьОбОтветахНаПриглашения КАК УведомлятьОбОтветахНаПриглашения,
	|	УчетныеЗаписиЭДО.УведомлятьОНовыхДокументах КАК УведомлятьОНовыхДокументах,
	|	УчетныеЗаписиЭДО.УведомлятьОНеОбработанныхДокументах КАК УведомлятьОНеОбработанныхДокументах,
	|	УчетныеЗаписиЭДО.УведомлятьОбОкончанииСрокаДействияСертификата КАК УведомлятьОбОкончанииСрокаДействияСертификата,
	|	УчетныеЗаписиЭДО.КодНалоговогоОргана КАК КодНалоговогоОргана,
	|	УчетныеЗаписиЭДО.АдресОрганизации КАК АдресОрганизации,
	|	УчетныеЗаписиЭДО.НазначениеУчетнойЗаписи КАК НазначениеУчетнойЗаписи,
	|	УчетныеЗаписиЭДО.ПодробноеОписаниеУчетнойЗаписи КАК ПодробноеОписаниеУчетнойЗаписи,
	|	УчетныеЗаписиЭДО.ОбновитьНастройкиУведомлений КАК ОбновитьНастройкиУведомлений,
	|	УчетныеЗаписиЭДО.ПринятыУсловияИспользования КАК ПринятыУсловияИспользования
	|ПОМЕСТИТЬ втУчетныеЗаписиЭДО
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК Сертификаты
	|		ПО УчетныеЗаписиЭДО.ИдентификаторЭДО = Сертификаты.ИдентификаторЭДО
	|			И (Сертификаты.Сертификат = &Сертификат)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыНовый
	|		ПО УчетныеЗаписиЭДО.ИдентификаторЭДО = СертификатыНовый.ИдентификаторЭДО
	|			И (СертификатыНовый.Сертификат = &НовыйСертификат)
	|ГДЕ
	|	СертификатыНовый.Сертификат ЕСТЬ NULL
	|	И УчетныеЗаписиЭДО.Организация = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втУчетныеЗаписиЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
	|	втУчетныеЗаписиЭДО.Организация КАК Организация,
	|	втУчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи КАК НаименованиеУчетнойЗаписи,
	|	втУчетныеЗаписиЭДО.ВерсияКонфигурации КАК ВерсияКонфигурации,
	|	втУчетныеЗаписиЭДО.ОператорЭДО КАК ОператорЭДО,
	|	втУчетныеЗаписиЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
	|	втУчетныеЗаписиЭДО.ЭлектроннаяПочтаДляУведомлений КАК ЭлектроннаяПочтаДляУведомлений,
	|	втУчетныеЗаписиЭДО.ОжидатьИзвещениеОПолучении КАК ОжидатьИзвещениеОПолучении,
	|	втУчетныеЗаписиЭДО.УведомлятьОНовыхПриглашениях КАК УведомлятьОНовыхПриглашениях,
	|	втУчетныеЗаписиЭДО.УведомлятьОбОтветахНаПриглашения КАК УведомлятьОбОтветахНаПриглашения,
	|	втУчетныеЗаписиЭДО.УведомлятьОНовыхДокументах КАК УведомлятьОНовыхДокументах,
	|	втУчетныеЗаписиЭДО.УведомлятьОНеОбработанныхДокументах КАК УведомлятьОНеОбработанныхДокументах,
	|	втУчетныеЗаписиЭДО.УведомлятьОбОкончанииСрокаДействияСертификата КАК УведомлятьОбОкончанииСрокаДействияСертификата,
	|	втУчетныеЗаписиЭДО.КодНалоговогоОргана КАК КодНалоговогоОргана,
	|	втУчетныеЗаписиЭДО.АдресОрганизации КАК АдресОрганизации,
	|	втУчетныеЗаписиЭДО.НазначениеУчетнойЗаписи КАК НазначениеУчетнойЗаписи,
	|	втУчетныеЗаписиЭДО.ПодробноеОписаниеУчетнойЗаписи КАК ПодробноеОписаниеУчетнойЗаписи,
	|	втУчетныеЗаписиЭДО.ОбновитьНастройкиУведомлений КАК ОбновитьНастройкиУведомлений,
	|	втУчетныеЗаписиЭДО.ПринятыУсловияИспользования КАК ПринятыУсловияИспользования
	|ИЗ
	|	втУчетныеЗаписиЭДО КАК втУчетныеЗаписиЭДО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО КАК ИдентификаторЭДО,
	|	СертификатыУчетныхЗаписейЭДО.Сертификат КАК Сертификат
	|ИЗ
	|	РегистрСведений.СертификатыУчетныхЗаписейЭДО КАК СертификатыУчетныхЗаписейЭДО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втУчетныеЗаписиЭДО КАК втУчетныеЗаписиЭДО
	|		ПО СертификатыУчетныхЗаписейЭДО.ИдентификаторЭДО = втУчетныеЗаписиЭДО.ИдентификаторЭДО";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Сертификат", Сертификат);
	Запрос.УстановитьПараметр("НовыйСертификат", НовыйСертификат);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	УчетныеЗаписи = Результаты[1].Выгрузить();
	УчетныеЗаписи.Колонки.Добавить("ВсеСертификаты");
	
	Сертификаты = Результаты[2].Выгрузить();
	Сертификаты.Индексы.Добавить("ИдентификаторЭДО");
	
	Для каждого УчетнаяЗапись Из УчетныеЗаписи Цикл
		
		ОтборПоУчетнойЗаписи = Новый Структура("ИдентификаторЭДО", УчетнаяЗапись.ИдентификаторЭДО);
		НайденныеСтроки = Сертификаты.НайтиСтроки(ОтборПоУчетнойЗаписи);
		
		УчетнаяЗапись.ВсеСертификаты = Новый Массив;
		УчетнаяЗапись.ВсеСертификаты.Добавить(НовыйСертификат);
		Для каждого СтрокаСертификата Из НайденныеСтроки Цикл
			УчетнаяЗапись.ВсеСертификаты.Добавить(СтрокаСертификата.Сертификат);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(УчетныеЗаписи);
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// См. СинхронизацияЭДО.ПриЗаполненииСписковСОграничениемДоступа
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт

	Списки.Вставить(Метаданные.РегистрыСведений.УчетныеЗаписиЭДО, Истина);
	
КонецПроцедуры

// См. СинхронизацияЭДО.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = Описание + "
	|РегистрСведений.УчетныеЗаписиЭДО.Чтение.Организации
	|";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ШаблонЗапросаУчетныхЗаписей(ИмяВременнойТаблицы, ВыбираемыеПоля, ПоляУсловия = "") 
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&ВыбираемыеПоля
	|ПОМЕСТИТЬ ИмяВременнойТаблицы
	|ИЗ
	|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
	|ГДЕ
	|	&ПоляУсловия";
	
	Если ИмяВременнойТаблицы = "" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяВременнойТаблицы", "");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяВременнойТаблицы", ИмяВременнойТаблицы);
	КонецЕсли;
	
	Возврат ОбщегоНазначенияБЭД.ТекстЗапросаИзШаблона(ТекстЗапроса, "УчетныеЗаписиЭДО", ВыбираемыеПоля, ПоляУсловия);
	
КонецФункции

Функция ЗначенияСвойствУчетныхЗаписейОрганизацииСервисаЭДО(Организация, Свойства)
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОрганизацииПоИНН.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТ_Организации
		|ИЗ
		|	ИмяТаблицыОрганизации КАК Организации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИмяТаблицыОрганизации КАК ОрганизацииПоИНН
		|		ПО Организации.ИмяРеквизитаИНН = ОрганизацииПоИНН.ИмяРеквизитаИНН
		|ГДЕ
		|	Организации.Ссылка = &Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Свойства,
		|	УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи КАК Представление
		|ИЗ
		|	РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Организации КАК ВТ_Организации
		|		ПО УчетныеЗаписиЭДО.Организация = ВТ_Организации.Ссылка
		|ГДЕ
		|	УчетныеЗаписиЭДО.СпособОбменаЭД В (&СпособыОбменаЧерезОператора)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Свойства", Свойства);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяТаблицыОрганизации", ОбщегоНазначения.ИмяТаблицыПоСсылке(Организация));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяРеквизитаИНН",
		ИнтеграцияЭДО.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении("ИННОрганизации"));
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СпособыОбменаЧерезОператора", СинхронизацияЭДО.СпособыОбменаЧерезОператора());
	
	МассивЗначенийСвойств = Новый Массив;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗначенияСвойств = Новый Структура(Свойства);
			ЗаполнитьЗначенияСвойств(ЗначенияСвойств, Выборка);
			МассивЗначенийСвойств.Добавить(ЗначенияСвойств);
		КонецЦикла;
	КонецЕсли;
	
	Возврат МассивЗначенийСвойств;
	
КонецФункции

#КонецОбласти