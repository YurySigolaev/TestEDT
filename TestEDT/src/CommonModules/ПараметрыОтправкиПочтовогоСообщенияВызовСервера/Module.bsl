// Возвращает структуру параметров отправки сообщения
// Результат (Структура)
// - Заголовок (Строка)
// - Тело (Строка)
// - Важность (ВажностьИнтернетПочтовогоСообщения)
// - Кому (Строка)
// - Копия (Строка)
// - СкрытаяКопия (Строка)
// - Файлы (Массив)
// - ИспользоватьЭП (Булево)
// - ОтправлятьЭП (ПеречислениеСсылка.ДействияПриОтправкеПоПочтеЭП)
// - РасширениеДляФайловПодписи (Строка)
// - РасширениеДляЗашифрованныхФайлов (Строка)
// - ПрикладыватьФайлВзаимодействияСЭД (Булево)
// - Документы (Массив)
//   - Элемент (СправочникСсылка.ВнутренниеДокументы, СправочникСсылка.ВходящиеДокументы, СправочникСсылка.ИсходящиеДокументы)
// - Шифровать (Булево)
// - ОтпечаткиСертификатовШифрования (Массив)
//   - Элемент (Строка) Отпечаток сертификата
// - НастройкиПрофилейДляОтправки (Структура)
//   - ВсеПрофили (Массив)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Неопределено, Структура)
//   - ДоступныеПрофили (Массив)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Неопределено, Структура)
//   - ОсновнойПрофиль (Неопределено, Структура)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Структура)
//   - Профиль (Неопределено, Структура)
//     - Элемент (Структура)
//       - Профиль (Строка, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты)
//       - ВидПочтовогоКлиента (ПеречислениеСсылка.ВидыПочтовыхКлиентов)
//       - Использовать (Булево)
//       - Данные (Структура)
//
Функция Создать() Экспорт
	
	Результат = Новый Структура;
	
	ИспользоватьЭП = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи");
	
	РасширениеДляЗашифрованныхФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЭП",
		"РасширениеДляЗашифрованныхФайлов",
		"p7m");
	
	РасширениеДляФайловПодписи = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЭП",
		"РасширениеДляФайловПодписи",
		"p7s");
	
	ОтправлятьПодписиЭППоПочте = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЭП",
		"ОтправлятьПодписиЭППоПочте",
		Перечисления.ДействияПриОтправкеПоПочтеЭП.Спрашивать);
	
	ПрикладыватьФайлВзаимодействияСЭД = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСПочтой",
		"ОтправкаПрикладыватьФайлВзаимодействияСЭД",
		Перечисления.ДаНетСпрашивать.Спрашивать);
	
	ОтправкаПодписьСообщения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РаботаСПочтой",
		"ОтправкаПодписьСообщения",
		"");
	
	НастройкиПрофилейДляОтправки = ЛегкаяПочтаСервер.ПолучитьНастройкиПрофилейДляОтправки();
	
	Результат.Вставить("Тема", "");
	Результат.Вставить("Текст", "");
	Результат.Вставить("Важность", Перечисления.ВажностьПисем.Обычная);
	Результат.Вставить("Кому", "");
	Результат.Вставить("Копия", "");
	Результат.Вставить("СкрытаяКопия", "");
	Результат.Вставить("Вложения", Новый Массив);
	Результат.Вставить("Документы", Новый Массив);
	
	Результат.Вставить("Шифровать", Ложь);
	Результат.Вставить("ОтпечаткиСертификатовШифрования", Новый Массив);
	
	Результат.Вставить("ИспользоватьЭП", ИспользоватьЭП);
	Результат.Вставить("РасширениеДляФайловПодписи", РасширениеДляФайловПодписи);
	Результат.Вставить("РасширениеДляЗашифрованныхФайлов", РасширениеДляЗашифрованныхФайлов);
	Результат.Вставить("ОтправлятьПодписиЭППоПочте", ОтправлятьПодписиЭППоПочте);
	Результат.Вставить("ПрикладыватьФайлВзаимодействияСЭД", ПрикладыватьФайлВзаимодействияСЭД);
	Результат.Вставить("ОтправкаПодписьСообщения", ОтправкаПодписьСообщения);
	
	Результат.Вставить("НастройкиПрофилейДляОтправки", НастройкиПрофилейДляОтправки);
	
	Результат.Вставить("ПарольНеТребуется", Ложь);
	
	Если ЗначениеЗаполнено(НастройкиПрофилейДляОтправки.Профиль) Тогда
		ВидПочтовогоКлиента = НастройкиПрофилейДляОтправки.Профиль.ВидПочтовогоКлиента;
		Если ВидПочтовогоКлиента = ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.ИнтернетПочта") Тогда

			УчетнаяЗапись = НастройкиПрофилейДляОтправки.Профиль.Профиль;
			ИспользоватьOAuth = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "ИспользоватьOAuth");
			Если ИспользоватьOAuth Тогда
				Результат.ПарольНеТребуется = Истина;
			КонецЕсли;	
			
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру почтового сообщения
// Результат (Структура)
// - Тема (Строка)
// - Текст (Строка)
// - Важность (ВажностьИнтернетПочтовогоСообщения)
// - Получатели (Массив)
//   - Элемент (Строка)
// - Копии (Массив)
//   - Элемент (Строка)
// - СлепыеКопии (Массив)
//   - Элемент (Строка)
// - Вложения (Массив)
//   - Элемент (Структура)
//     - Наименование (Строка)
//     - ИмяФайла (Строка)
//     - Адрес (Строка) Адрес во временном хранилище
//     - Зашифрован (Булево)
// 
// Параметры:
// - ПараметрыОтправки (Структура)
//   - Тема (Строка)
//   - Текст (Строка)
//   - Важность (ВажностьИнтернетПочтовогоСообщения)
//   - Кому (Строка)
//   - Копия (Строка)
//   - СкрытаяКопия (Строка)
//   - Вложения (Массив)
//     - Элемент (Структура)
//       - Расположение (Строка) - ("СсылкаНаФайл", "ВременноеХранилище")
//       - Ссылка (СправочникСсылка.Файлы)
//       - Адрес (Строка) - адрес во временном хранилище.
//       - Размер (Число) - размер в байтах.
//       - ИмяФайла (Строка) - представление вложения.
//   - ОтправлятьПодписиЭППоПочте (ПеречислениеСсылка.ДействияПриОтправкеПоПочтеЭП)
//   - РасширениеДляФайловПодписи (Строка)
//   - ПрикладыватьФайлВзаимодействияСЭД (Булево)
//   - Документы (Массив)
//     - Элемент (СправочникСсылка.ВнутренниеДокументы, СправочникСсылка.ВходящиеДокументы, СправочникСсылка.ИсходящиеДокументы)
// - УникальныйИдентификатор (УникальныйИдентификатор)
//
Функция СформироватьСтруктуруПочтовогоСообщения(ПараметрыОтправки, УникальныйИдентификатор) Экспорт
	
	Сообщение = Новый Структура;
	Сообщение.Вставить("Тема", ПараметрыОтправки.Тема);
	Сообщение.Вставить("Текст", ПараметрыОтправки.Текст);
	Сообщение.Вставить("Важность", ПараметрыОтправки.Важность);
	
	Сообщение.Вставить("Получатели", Новый Массив);
	Для каждого Получатель Из РаботаСоСтроками.РазложитьСтрокуПочтовыхАдресов(ПараметрыОтправки.Кому) Цикл
		Сообщение.Получатели.Добавить(
			РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
				Получатель.ОтображаемоеИмя,
				Получатель.Адрес));
	КонецЦикла;
	
	Сообщение.Вставить("Копии", Новый Массив);
	Для каждого Получатель Из РаботаСоСтроками.РазложитьСтрокуПочтовыхАдресов(ПараметрыОтправки.Копия) Цикл
		Сообщение.Копии.Добавить(
			РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
			Получатель.ОтображаемоеИмя,
			Получатель.Адрес));
	КонецЦикла;
	
	Сообщение.Вставить("СлепыеКопии", Новый Массив);
	Для каждого Получатель Из РаботаСоСтроками.РазложитьСтрокуПочтовыхАдресов(ПараметрыОтправки.СкрытаяКопия) Цикл
		Сообщение.СлепыеКопии.Добавить(
			РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
				Получатель.ОтображаемоеИмя,
				Получатель.Адрес));
	КонецЦикла;
	
	Сообщение.Вставить("Вложения", Новый Массив);
	
	Для каждого Вложение Из ПараметрыОтправки.Вложения Цикл
		Если Вложение.Тип = "СсылкаНаФайл" Тогда
			Файл = Вложение.Ссылка;
			Зашифрован = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Файл, "Зашифрован");
			ТекущаяВерсия = Файл.ТекущаяВерсия;
			Наименование = Файл.ПолноеНаименование;
			ИмяФайла = Файл.ПолноеНаименование +
				"." + ТекущаяВерсия.Расширение +
				?(Зашифрован, "." + ПараметрыОтправки.РасширениеДляЗашифрованныхФайлов, "");
			Адрес = РаботаСФайламиВызовСервера.ПолучитьНавигационнуюСсылкуВоВременномХранилище(
				ТекущаяВерсия,
				УникальныйИдентификатор);
			
			ДобавитьВложениеВнутр(Сообщение, Наименование, ИмяФайла, Адрес, Зашифрован);
			
			Если ПараметрыОтправки.ОтправлятьПодписиЭППоПочте = Перечисления.ДействияПриОтправкеПоПочтеЭП.ОтправлятьВсеПодписи Тогда
				Для каждого СтруктураПодписи Из ПолучитьМассивСтруктурЭП(ТекущаяВерсия) Цикл
					Адрес = ПоместитьВоВременноеХранилище(СтруктураПодписи.ДвоичныеДанные, УникальныйИдентификатор);
					ИмяФайла = СтруктураПодписи.Наименование
						+ "."
						+ ПараметрыОтправки.РасширениеДляФайловПодписи;
					ДобавитьВложениеВнутр(Сообщение, СтруктураПодписи.Наименование, ИмяФайла, Адрес, Ложь);
				КонецЦикла;
			КонецЕсли;
			
		ИначеЕсли Вложение.Тип = "ВременноеХранилище" Тогда
			Наименование = Вложение.ИмяФайла;
			ИмяФайла = Вложение.ИмяФайла;
			Адрес = Вложение.Адрес;
			Зашифрован = Ложь;
			ДобавитьВложениеВнутр(Сообщение, Наименование, ИмяФайла, Адрес, Зашифрован);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПараметрыОтправки.ПрикладыватьФайлВзаимодействияСЭД <> Перечисления.ДаНетСпрашивать.Нет Тогда
		Для каждого Документ Из ПараметрыОтправки.Документы Цикл
			Если Не ДелопроизводствоКлиентСервер.ЭтоДокумент(Документ) Тогда 
				Продолжить;
			КонецЕсли;
			
			ИмяВременногоФайла = ВзаимодействиеСЭДСервер.Выгрузить(Документ);
			Файл = Новый Файл(ИмяВременногоФайла);
			Если Файл.Существует() Тогда
				ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
				Наименование = "1C-53898-2010";
				ИмяФайла = "1C-53898-2010.xml";
				Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
				ДобавитьВложениеВнутр(Сообщение, Наименование, ИмяФайла, Адрес, Ложь);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Сообщение;
	
КонецФункции

// Вставляет в массив Сообщение.Вложения структуру "Наименование, ИмяФайла, Адрес, Размер, Зашифрован"
//
// Параметры:
// - Сообщение (Структура)
// - Наименование (Строка)
// - ИмяФайла (Строка)
// - Адрес (Строка) Адрес во временном хранилище
// - Размер (Число)
// - Зашифрован (Булево)
//
Процедура ДобавитьВложениеВнутр(Сообщение, Знач Наименование, Знач ИмяФайла, Адрес, Зашифрован)
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		ВызватьИсключение НСтр("ru = 'Не задано имя файла'")
	КонецЕсли;
	
	ИменаФайлов = Новый Массив;
	Для каждого ВложенияСтрока Из Сообщение.Вложения Цикл
		ИменаФайлов.Добавить(ВложенияСтрока.ИмяФайла);
	КонецЦикла;
	
	ИмяФайлаИнфо = РаботаСоСтроками.РазложитьИмяФайла(ИмяФайла);
	Имя = ИмяФайлаИнфо.Имя;
	Расширение = ИмяФайлаИнфо.Расширение;
	Счетчик = 1;
	Пока ИменаФайлов.Найти(ИмяФайла) <> Неопределено Цикл
		Имя = ИмяФайлаИнфо.Имя + "(" + Формат(Счетчик, "ЧГ=0") + ")";
		Счетчик = Счетчик + 1;
		ИмяФайла = Имя + "." + Расширение;
	КонецЦикла;
	
	Вложение = Новый Структура;
	Вложение.Вставить("Наименование", Наименование);
	Вложение.Вставить("ИмяФайла", ИмяФайла);
	Вложение.Вставить("Адрес", Адрес);
	//Вложение.Вставить("Размер", Размер);
	Вложение.Вставить("Зашифрован", Зашифрован);
	Сообщение.Вложения.Добавить(Вложение);
	
КонецПроцедуры

// Результат (Массив)
// - Элемент (Структура)
//   - Наименование (Строка)
//   - ДвоичныеДанные (ДвоичныеДанные) ЭП
//
Функция ПолучитьМассивСтруктурЭП(ВерсияФайла)
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЭП.КомуВыданСертификат,
		|	ЭП.ДатаПодписи,
		|	ЭП.Комментарий,
		|	ЭП.Подпись,
		|	ЭП.ИмяФайлаПодписи
		|ИЗ
		|	РегистрСведений.ЭлектронныеПодписи КАК ЭП
		|ГДЕ
		|	ЭП.Объект = &ВерсияФайла");
	Запрос.Параметры.Вставить("ВерсияФайла", ВерсияФайла);
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		Подпись = ВыборкаЗапроса.Подпись.Получить();
		КомуВыданСертификат = СтрЗаменить(ВыборкаЗапроса.КомуВыданСертификат,","," ");
		КомуВыданСертификат = СтрЗаменить(КомуВыданСертификат,":"," ");
		КомуВыданСертификат = СтрЗаменить(КомуВыданСертификат,""""," ");
		КомуВыданСертификат = СтрЗаменить(КомуВыданСертификат,"  "," ");
		КомуВыданСертификат = СтрЗаменить(КомуВыданСертификат,"  "," ");
		КомуВыданСертификат = СтрЗаменить(КомуВыданСертификат,"  "," ");
		
		Наименование = ВерсияФайла.Владелец.ПолноеНаименование + " - " + КомуВыданСертификат;
		
		СтруктураПодписи = Новый Структура;
		СтруктураПодписи.Вставить("Наименование", Наименование);
		СтруктураПодписи.Вставить("ДвоичныеДанные", Подпись);
		
		Результат.Добавить(СтруктураПодписи);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
