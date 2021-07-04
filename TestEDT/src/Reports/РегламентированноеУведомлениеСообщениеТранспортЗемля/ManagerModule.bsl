#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2020_1";
	Стр.КНД = "1150099";
	Стр.ВерсияФормата = "5.01";
	
	Возврат Результат;
КонецФункции

Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
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
	Стр.ИмяФормы = "Форма2020_1";
	Стр.ОписаниеФормы = "В соответствии с приказом ФНС России от 25.02.2020 № ЕД-7-21/124@";
	Стр.ДатаНачала = '20201001';
	Стр.ДатаКонца = '20991231';
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2020_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2020_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2020_1" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Электронный формат для данной формы не опубликован'"));
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2020_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2020_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2020_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Данные.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
		Данные.Вставить("ПодписантИмя", Объект.ПодписантИмя);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2020_1(СведенияОтправки)
	Префикс = "NO_SOBNALORG";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2020_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	ОТЧ = Новый ОписаниеТипов("Число");
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	Если Не ЗначениеЗаполнено(Титульная.ИНН) 
		Или Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульная.ИНН, Истина, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан ИНН", "Титульная", "ИНН"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КПП) 
		Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Титульная.КПП, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан КПП", "Титульная", "КПП"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "1" Или Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" Тогда 
		Если Не ЗначениеЗаполнено(Данные.ПодписантИмя) Или Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан подписант", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
		КонецЕсли;
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И Не ЗначениеЗаполнено(Титульная.НаимДок) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО)
		Или (Не УведомлениеОСпецрежимахНалогообложения.СтрокаСодержитТолькоЦифры(Титульная.КодНО))
		Или СтрДлина(СокрЛП(Титульная.КодНО)) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан/неправильно указан налоговый орган", "Титульная", "КодНО"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование организации", "Титульная", "НаимОрг"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Титульная.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ)
		И (Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Или Не ЗначениеЗаполнено(Данные.ПодписантИмя))Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указаны фамилия/имя представителя", "Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.СпособИнфРез) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан способ информирования налогоплательщика о результатах рассмотрения настоящего заявления", "Титульная", "СпособИнфРез"));
	КонецЕсли;
	
	СписокКодов = ";01;02;03;04;05;06;07;08;09;10;11;12;13;14;15;16;";
	
	ЕстьЗаполненныеЛисты = Ложь;
	Для Каждого Лист0Итер Из Данные.ДанныеМногостраничныхРазделов.Транспорт Цикл
		Лист0 = Лист0Итер.Значение;
		Страница0Заполнена = УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Лист0);
		ТекЗаполнена = Страница0Заполнена;
		Если Страница0Заполнена Тогда 
			ЕстьЗаполненныеЛисты = Истина;
		КонецЕсли;
		Если Не ТекЗаполнена Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Лист0.ВидТС) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнен вид транспортного средства", "Транспорт", "ВидТС", Лист0.УИД));
		ИначеЕсли 0 = СтрНайти(СписокКодов, ";" + Лист0.ВидТС + ";") Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Неправильно заполнен вид транспортного средства", "Транспорт", "ВидТС", Лист0.УИД));
		КонецЕсли;
		Если Лист0.ВидТС = "16" И Не ЗначениеЗаполнено(Лист0.НаимВидТС) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не заполнено наименование транспортного средства", "Транспорт", "НаимВидТС", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.ДатаРегТС) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указана дата регистрации транспортного средства", "Транспорт", "ДатаРегТС", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.НомДокРегТС) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указана серия и номер документа, подтверждающего регистрацию транспортного средства", "Транспорт", "НомДокРегТС", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.ДатаДокРегТС) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указана дата выдачи документа, подтверждающего регистрацию транспортного средства", "Транспорт", "ДатаДокРегТС", Лист0.УИД));
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Лист0Итер Из Данные.ДанныеМногостраничныхРазделов.Земля Цикл
		Лист0 = Лист0Итер.Значение;
		Страница0Заполнена = УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Лист0);
		ТекЗаполнена = Страница0Заполнена;
		Если Страница0Заполнена Тогда 
			ЕстьЗаполненныеЛисты = Истина;
		КонецЕсли;
		Если Не ТекЗаполнена Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Лист0.НомКадастрЗУ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнен кдастровый номер земельного участка", "Земля", "НомКадастрЗУ", Лист0.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Лист0.ДатаРегПрав) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнена дата регистрации (возникновения) права", "Земля", "ДатаРегПрав", Лист0.УИД));
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьЗаполненныеЛисты Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не заполнены сведения о льготах", "Транспорт", "ВидТС", Данные.ДанныеМногостраничныхРазделов.Транспорт[0].Значение.УИД));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2020_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Ложь);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("КодНО", Данные.ДанныеУведомления.Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Данные.ДанныеУведомления.Титульная.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ТлфПодп", Данные.ДанныеУведомления.Титульная.Тлф);
	ОсновныеСведения.Вставить("ИННТитул", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.Титульная.ИНН);
	ОсновныеСведения.Вставить("НаимДок", Данные.ДанныеУведомления.Титульная.НаимДок);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2020_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2020_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	ДанныеУведомления.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
	ДанныеУведомления.Вставить("ПодписантИмя", Объект.ПодписантИмя);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2020_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""", Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2020_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2020_1");
	ЗаполнитьДанными_Форма2020_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
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

Процедура ДополнитьПараметры_2020(Параметры)
КонецПроцедуры

Процедура ЗаполнитьДанными_Форма2020_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры_2020(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Узел, ПараметрыТекущейСтраницы = Неопределено, УИДРодителя = Неопределено)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если Стр.Тип = "А" Или Стр.Тип = "A" Или Стр.Тип = "П" Тогда
			Если ЗначениеЗаполнено(Стр.Ключ) Тогда
				ЗначениеПоказателя = Неопределено;
				Если ПараметрыТекущейСтраницы <> Неопределено И ПараметрыТекущейСтраницы.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда 
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
				ИначеЕсли ПараметрыТекущейСтраницы = Неопределено 
					И ЗначениеЗаполнено(Стр.Раздел)
					И ПараметрыВыгрузки.ДанныеУведомления.Свойство(Стр.Раздел, ЗначениеПоказателя) Тогда 
					Если ЗначениеПоказателя.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда
						РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда
			Если Стр.Многостраничность = Истина Тогда
				Многостраничность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Раздел, Многостраничность)
					И ТипЗнч(Многостраничность) = Тип("СписокЗначений") Тогда
				
					Для Каждого СтрМнгч Из Многостраничность Цикл 
						Если УИДРодителя = Неопределено Или СтрМнгч.Значение.УИДРодителя = УИДРодителя Тогда 
							НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
							ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, НовУзел, СтрМнгч.Значение, СтрМнгч.Значение.УИД);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			Иначе
				ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Стр, ПараметрыТекущейСтраницы, УИДРодителя)
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП, ВыводитьМакет = Истина, МакетПФ = Неопределено)
	Попытка
		Если МакетПФ = Неопределено Тогда 
			МакетПФ = Отчеты.РегламентированноеУведомлениеСообщениеТранспортЗемля.ПолучитьМакет(ИмяМакета);
		КонецЕсли;
	Исключение
		Возврат;
	КонецПопытки;
	
	НомСтр = НомСтр + 1;
	Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
		ИначеЕсли КЗ.Значение = Неопределено Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ, МакетПФ.Области, "-");
		КонецЕсли;
	КонецЦикла;
	
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
	ЗаполнитьЗначенияСвойств(МакетПФ.Параметры, СтруктураДанныхСтраницы);
	Если ВыводитьМакет Тогда 
		ПечатнаяФорма.Вывести(МакетПФ);
	КонецЕсли;
КонецПроцедуры

Процедура НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПарам, ПечатнаяФорма, НомСтр, ИННКПП)
	МакетыПФ = СтрПарам.МакетыПФ;
	ИмяМакета = СтрПарам.ИмяМакета;
	
	Если Не ЗначениеЗаполнено(МакетыПФ) И Не ЗначениеЗаполнено(ИмяМакета) Тогда 
		Для Каждого СтрПодч Из СтрПарам.Строки Цикл
			НапечататьСтроку(Объект, СтруктураПараметров, Листы, СтрПодч, ПечатнаяФорма, НомСтр, ИННКПП);
		КонецЦикла;
		
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МакетыПФ) Тогда 
		МассивИменМакетов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(МакетыПФ, ";");
	Иначе 
		МассивИменМакетов = Новый Массив;
		МассивИменМакетов.Добавить("ПФ_" + ИмяМакета);
	КонецЕсли;
	
	Если СтруктураПараметров.ДанныеУведомления.Свойство(СтрПарам.ИДНаименования) Тогда 
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл 
			СтруктураДанныхСтраницы = СтруктураПараметров.ДанныеУведомления[СтрПарам.ИДНаименования];
			Если УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(СтруктураДанныхСтраницы) Тогда
				НапечататьСтруктуру(СтруктураДанныхСтраницы, НомСтр, ИмяМакета, ПечатнаяФорма, ИННКПП);
				Если СтрПарам.ИДНаименования = "Титульная" Тогда
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
					ПечатнаяФорма.Области.ЭлАдрес.Текст = СтруктураДанныхСтраницы.ЭлАдрес;
				КонецЕсли;
				УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция СформироватьСписокЛистовФорма2020_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Титульная.ИНН);
	ИННКПП.Вставить("КПП", СтруктураПараметров.ДанныеУведомления.Титульная.КПП);
	
	НомСтр = 0;
	НапечататьСтруктуру(СтруктураПараметров.ДанныеУведомления["Титульная"], НомСтр, "Печать_Форма2020_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	
	НомСтр = 2;
	НапечататьЛистыДоп("Транспорт", 2, НомСтр, Листы, ИННКПП, СтруктураПараметров, Объект);
	НапечататьЛистыДоп("Земля", 6, НомСтр, Листы, ИННКПП, СтруктураПараметров, Объект);
	Возврат Листы;
КонецФункции

Процедура НапечататьЛистыДоп(ИмяМакета, КоличествоСтрок, НомСтр, Листы, ИННКПП, СтруктураПараметров, Объект)
	Попытка
		МакетПФ = Отчеты.РегламентированноеУведомлениеСообщениеТранспортЗемля.ПолучитьМакет("Печать_Форма2020_1_" + ИмяМакета);
		ОТЧ = Новый ОписаниеТипов("Число");
	Исключение
		Возврат;
	КонецПопытки;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтрокаДляПечати = 0;
	Для Каждого Элт0 Из СтруктураПараметров.ДанныеМногостраничныхРазделов[ИмяМакета] Цикл
		Свед0 = Элт0.Значение;
		Если Не УведомлениеОСпецрежимахНалогообложения.СтраницаЗаполнена(Свед0) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаДляПечати = СтрокаДляПечати + 1;
		
		Для Каждого КЗ Из Свед0 Цикл
			Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ + "_" + СтрокаДляПечати, МакетПФ.Области, "-");
			ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ + "_" + СтрокаДляПечати, МакетПФ.Области, "-");
			ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ + "_" + СтрокаДляПечати, МакетПФ.Области);
			ИначеЕсли КЗ.Значение = Неопределено Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ + "_" + СтрокаДляПечати, МакетПФ.Области, "-");
			КонецЕсли;
		КонецЦикла;
		
		Если СтрокаДляПечати = КоличествоСтрок Тогда
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
			ПечатнаяФорма.Вывести(МакетПФ);
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			МакетПФ = Отчеты.РегламентированноеУведомлениеСообщениеТранспортЗемля.ПолучитьМакет("Печать_Форма2020_1_" + ИмяМакета);
			СтрокаДляПечати = 0;
			НомСтр = НомСтр + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаДляПечати <> 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", МакетПФ.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.КПП, "КППШапка", МакетПФ.Области, "-");
		Для Каждого Обл Из МакетПФ.Области Цикл 
			Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
				И Не ЗначениеЗаполнено(Обл.Текст) Тогда 
				
				Обл.Текст = "-";
			КонецЕсли;
		КонецЦикла;
		ПечатнаяФорма.Вывести(МакетПФ);
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
		НомСтр = НомСтр + 1;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
