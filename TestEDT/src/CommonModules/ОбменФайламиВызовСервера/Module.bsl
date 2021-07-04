
// Создать файловый начальный образ на сервере
//
Функция СоздатьФайловыйНачальныйОбразНаСервере(Узел, УникальныйИдентификаторФормы, Язык, ПолноеИмяФайловойБазыWindows, ПолноеИмяФайловойБазыLinux, ПутьКАрхивуСФайламиТомовWindows, ПутьКАрхивуСФайламиТомовLinux) Экспорт
	
	ПутьКАрхивуСФайламиТомов = "";
	ПолноеИмяФайловойБазы = "";
	
	ЕстьФайлыВТомах = Ложь;
	
	Если ФайловыеФункции.ЕстьТомаХраненияФайлов() Тогда
		ЕстьФайлыВТомах = ФайловыеФункции.ПолучитьКоличествоФайловВТомах() > 0;
	КонецЕсли;
	
	ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		
		ПутьКАрхивуСФайламиТомов = ПутьКАрхивуСФайламиТомовWindows;
		ПолноеИмяФайловойБазы = ПолноеИмяФайловойБазыWindows;
		
		Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			Если ЕстьФайлыВТомах Тогда
				Если Не ПустаяСтрока(ПутьКАрхивуСФайламиТомов) И (Лев(ПутьКАрхивуСФайламиТомов, 2) <> "\\" ИЛИ Найти(ПутьКАрхивуСФайламиТомов, ":") <> 0) Тогда
					ТекстОшибки = НСтр("ru = 'Путь к архиву с файлами томов должен быть в формате UNC (\\servername\resource)'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПутьКАрхивуСФайламиТомовWindows");
					Возврат Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			Если Не ПустаяСтрока(ПолноеИмяФайловойБазы) И (Лев(ПолноеИмяФайловойБазы, 2) <> "\\" ИЛИ Найти(ПолноеИмяФайловойБазы, ":") <> 0) Тогда
				ТекстОшибки = НСтр("ru = 'Путь к файловой базе должен быть в формате UNC (\\servername\resource)'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПолноеИмяФайловойБазыWindows");
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ПутьКАрхивуСФайламиТомов = ПутьКАрхивуСФайламиТомовLinux;
		ПолноеИмяФайловойБазы = ПолноеИмяФайловойБазыLinux;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ПолноеИмяФайловойБазы) Тогда
		
		Текст = НСтр("ru = 'Укажите полное имя файловой базы (файл 1cv8.1cd)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ПолноеИмяФайловойБазыWindows");
		
		Возврат Ложь;
		
	КонецЕсли;
	
	ФайлБазы = Новый Файл(ПолноеИмяФайловойБазы);
	
	Если ФайлБазы.Существует() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файл ""%1"" уже существует. Введите другое имя файла.'"), ПолноеИмяФайловойБазы);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ПолноеИмяФайловойБазыWindows");
		Возврат Ложь;
	КонецЕсли;
	
	Если ЕстьФайлыВТомах Тогда
		
		Если ПустаяСтрока(ПутьКАрхивуСФайламиТомов) Тогда
			Текст = НСтр("ru = 'Укажите полное имя архива с файлами томов (файл *.zip)'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ПутьКАрхивуСФайламиТомовWindows");
			Возврат Ложь;
		КонецЕсли;
		
		Файл = Новый Файл(ПутьКАрхивуСФайламиТомов);
		
		Если Файл.Существует() Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файл ""%1"" уже существует. Введите другое имя файла.'"), ПутьКАрхивуСФайламиТомов);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ПутьКАрхивуСФайламиТомовWindows");
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	// создать временный каталог
	ИмяКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяКаталога);
	
	// создать временный каталог для файлов
	ИмяКаталогаФайлов = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяКаталогаФайлов);
	
	ХранилищеОбщихНастроекСохранитьВПривилегированномРежиме("ОбменФайлами", "ВременныйКаталог", ИмяКаталогаФайлов);
	
	ZIP = Неопределено;
	Запись = Неопределено;
	
	Попытка
		
		СтрокаСоединения = "File=""" + ИмяКаталога + """;"
						 + "Locale=""" + Язык + """;";
		ПланыОбмена.СоздатьНачальныйОбраз(Узел, СтрокаСоединения);  // собственно создание начального образа
		
		Если ЕстьФайлыВТомах Тогда
			ZIP = Новый ЗаписьZipФайла;
			ZIP.Открыть(ПутьКАрхивуСФайламиТомов);
			
			ВременныеФайлы = Новый Массив;
			ВременныеФайлы = НайтиФайлы(ИмяКаталогаФайлов, "*.*");
			
			Для Каждого ВременныйФайл Из ВременныеФайлы Цикл
				Если ВременныйФайл.ЭтоФайл() Тогда
					ПутьВременногоФайла = ВременныйФайл.ПолноеИмя;
					ZIP.Добавить(ПутьВременногоФайла);
				КонецЕсли;
			КонецЦикла;
			
			ZIP.Записать();
			
			УдалитьФайлы(ИмяКаталогаФайлов); // удаляем вместе с файлами внутри
		КонецЕсли;
		
	Исключение
		
		УдалитьФайлы(ИмяКаталога);
		УдалитьФайлы(ИмяКаталогаФайлов);
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	ПутьВременногоФайлаБазы = ИмяКаталога + "\1Cv8.1CD";
	ПереместитьФайл(ПутьВременногоФайлаБазы, ПолноеИмяФайловойБазы);
	
	// очистка
	УдалитьФайлы(ИмяКаталога);
	
	Возврат Истина;
	
КонецФункции

// Создать серверный начальный образ на сервере
//
Функция СоздатьСерверныйНачальныйОбразНаСервере(Узел, СтрокаСоединения, ПутьКАрхивуСФайламиТомовWindows, ПутьКАрхивуСФайламиТомовLinux) Экспорт
	
	ПутьКАрхивуСФайламиТомов = "";
	ПолноеИмяФайловойБазы = "";
	
	ЕстьФайлыВТомах = Ложь;
	
	Если ФайловыеФункции.ЕстьТомаХраненияФайлов() Тогда
		ЕстьФайлыВТомах = ФайловыеФункции.ПолучитьКоличествоФайловВТомах() > 0;
	КонецЕсли;
	
	ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		
		ПутьКАрхивуСФайламиТомов = ПутьКАрхивуСФайламиТомовWindows;
		
		Если ЕстьФайлыВТомах Тогда
			Если Не ПустаяСтрока(ПутьКАрхивуСФайламиТомов) И (Лев(ПутьКАрхивуСФайламиТомов, 2) <> "\\" ИЛИ Найти(ПутьКАрхивуСФайламиТомов, ":") <> 0) Тогда
				ТекстОшибки = НСтр("ru = 'Путь к архиву с файлами томов должен быть в формате UNC (\\servername\resource) '");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ПутьКАрхивуСФайламиТомовWindows");
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		ПутьКАрхивуСФайламиТомов = ПутьКАрхивуСФайламиТомовLinux;
	КонецЕсли;
	
	Если ЕстьФайлыВТомах Тогда
		Если ПустаяСтрока(ПутьКАрхивуСФайламиТомов) Тогда
			Текст = НСтр("ru = 'Укажите полное имя архива с файлами томов (файл *.zip)'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "ПутьКАрхивуСФайламиТомовWindows");
			Возврат Ложь;
		КонецЕсли;
		
		ПутьФайла = ПутьКАрхивуСФайламиТомов;
		Файл = Новый Файл(ПутьФайла);
		Если Файл.Существует() Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файл ""%1"" уже существует. Введите другое имя файла.'"), ПутьФайла);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// создать временный каталог
	ИмяКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяКаталога);
	
	// создать временный каталог для файлов
	ИмяКаталогаФайлов = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяКаталогаФайлов);
	
	ХранилищеОбщихНастроекСохранитьВПривилегированномРежиме("ОбменФайлами", "ВременныйКаталог", ИмяКаталогаФайлов);
	
	ZIP = Неопределено;
	Запись = Неопределено;
	
	Попытка
		
		ПланыОбмена.СоздатьНачальныйОбраз(Узел, СтрокаСоединения);
		
		Если ЕстьФайлыВТомах Тогда
			ZIP = Новый ЗаписьZipФайла;
			ПутьZIP = ПутьФайла;
			ZIP.Открыть(ПутьZIP);
			
			ВременныеФайлы = Новый Массив;
			ВременныеФайлы = НайтиФайлы(ИмяКаталогаФайлов, "*.*");
			
			Для Каждого ВременныйФайл Из ВременныеФайлы Цикл
				Если ВременныйФайл.ЭтоФайл() Тогда
					ПутьВременногоФайла = ВременныйФайл.ПолноеИмя;
					ZIP.Добавить(ПутьВременногоФайла);
				КонецЕсли;
			КонецЦикла;
			
			ZIP.Записать();
			УдалитьФайлы(ИмяКаталогаФайлов); // удаляем вместе с файлами внутри
		КонецЕсли;
		
	Исключение
		
		УдалитьФайлы(ИмяКаталога);
		УдалитьФайлы(ИмяКаталогаФайлов);
		ВызватьИсключение;
		
	КонецПопытки;
	
	// очистка
	УдалитьФайлы(ИмяКаталога);
	
	Возврат Истина;
	
КонецФункции

// Размещает файлы в томах, устанавливая ссылки в ВерсииФайла
//
Функция ДобавитьФайлыВТома(ПутьКАрхивуWindows, ПутьКАрхивуLinux) Экспорт
	
	ПолноеИмяФайлаZip = "";
	ТипПлатформыСервера = ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера();
	
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		ПолноеИмяФайлаZip = ПутьКАрхивуWindows;
	Иначе
		ПолноеИмяФайлаZip = ПутьКАрхивуLinux;
	КонецЕсли;
	
	ИмяКаталога = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяКаталога);
	
	ZIP = Новый ЧтениеZipФайла(ПолноеИмяФайлаZip);
	ZIP.ИзвлечьВсе(ИмяКаталога, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	
	СоответствиеПутейФайлов = Новый Соответствие;
	
	Для Каждого ZIPЭлемент Из ZIP.Элементы Цикл
		ПолныйПутьФайла = ИмяКаталога + "\" + ZIPЭлемент.Имя;
		УникальныйИдентификатор = ZIPЭлемент.ИмяБезРасширения;
		
		СоответствиеПутейФайлов.Вставить(УникальныйИдентификатор, ПолныйПутьФайла);
	КонецЦикла;
	
	ТипХраненияФайлов = ФайловыеФункции.ПолучитьТипХраненияФайлов();
	ПрисоединяемыеФайлы = Новый Массив;
	НачатьТранзакцию();
	Попытка
		ФайловыеФункцииПереопределяемый.ДобавитьФайлыВТомаПриРазмещении(СоответствиеПутейФайлов, ТипХраненияФайлов, ПрисоединяемыеФайлы);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
	// очистим регистрацию изменений, которые мы только что сделали
	Для Каждого ПланОбмена из Метаданные.ПланыОбмена Цикл
		ИмяПланаОбмена		= ПланОбмена.Имя;
		МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
		
		ЭтотУзел = МенеджерПланаОбмена.ЭтотУзел();
		Выборка = МенеджерПланаОбмена.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ПланОбменаОбъект = Выборка.ПолучитьОбъект();
			Если ПланОбменаОбъект.Ссылка <> ЭтотУзел Тогда
				
				Попытка
					ФайловыеФункцииПереопределяемый.УдалитьРегистрациюИзменений(ПланОбменаОбъект.Ссылка, ПрисоединяемыеФайлы);
				Исключение
					ЗаписьЖурналаРегистрации("Добавление файлов в тома.УдалитьРегистрациюИзменений", 
						УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
					
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	УдалитьФайлы(ИмяКаталога);
	
КонецФункции

// Передает с клиента на сервер для записи настройку и записывает в привилегированном режиме
Процедура ХранилищеОбщихНастроекСохранитьВПривилегированномРежиме(
	КлючОбъекта, 
	КлючНастроек = Неопределено, 
	Настройки,
	ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено) 
		
	УстановитьПривилегированныйРежим(Истина);
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, ИмяПользователя);
	
КонецПроцедуры
