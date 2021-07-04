#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей шаблона процесса
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруШаблонаКомплексногоПроцесса() Экспорт
	
	ПараметрыПроцесса = Новый Структура;
	ПараметрыПроцесса.Вставить("Наименование");
	ПараметрыПроцесса.Вставить("Родитель");
	ПараметрыПроцесса.Вставить("Ответственный");
	ПараметрыПроцесса.Вставить("Комментарий");
	ПараметрыПроцесса.Вставить("ДобавлятьНаименованиеПредмета");
	ПараметрыПроцесса.Вставить("НаименованиеБизнесПроцесса");
	ПараметрыПроцесса.Вставить("Описание");
	ПараметрыПроцесса.Вставить("Важность");
	ПараметрыПроцесса.Вставить("Автор");
	ПараметрыПроцесса.Вставить("ШаблонВКомплексномПроцессе");
	ПараметрыПроцесса.Вставить("ВладелецШаблона");
	
	Предметы = Новый ТаблицаЗначений;
	Предметы.Колонки.Добавить("РольПредмета");
	Предметы.Колонки.Добавить("ИмяПредмета");
	Предметы.Колонки.Добавить("ТочкаМаршрута");
	Предметы.Колонки.Добавить("ИмяПредметаОснование");
	Предметы.Колонки.Добавить("ШаблонОснование");
	ПараметрыПроцесса.Вставить("Предметы", Предметы);
	
	РабочаяГруппаШаблона = Новый ТаблицаЗначений;
	РабочаяГруппаШаблона.Колонки.Добавить("Участник");
	ПараметрыПроцесса.Вставить("РабочаяГруппа", РабочаяГруппаШаблона);
	
	НастройкиШаблона = Новый ТаблицаЗначений;
	НастройкиШаблона.Колонки.Добавить("КомуНазначен");
	Если Константы.ИспользоватьУчетПоОрганизациям.Получить() Тогда
		НастройкиШаблона.Колонки.Добавить("Организация");
	КонецЕсли;
	НастройкиШаблона.Колонки.Добавить("Условие");
	НастройкиШаблона.Колонки.Добавить("ЗапрещеноИзменение");
	НастройкиШаблона.Колонки.Добавить("ИнтерактивныйЗапуск");
	НастройкиШаблона.Колонки.Добавить("ВидИнтерактивногоСобытия");
	ПараметрыПроцесса.Вставить("НастройкиШаблона", НастройкиШаблона);
	
	Действия = Новый ТаблицаЗначений;
	Действия.Колонки.Добавить("НомерДействия");
	Действия.Колонки.Добавить("ВидДействия");
	Действия.Колонки.Добавить("СтруктураДействия");
	Действия.Колонки.Добавить("ПорядокВыполнения");
	ПараметрыПроцесса.Вставить("Действия", Действия);
	
	ПорядокВыполненияДействий = Новый ТаблицаЗначений;
	ПорядокВыполненияДействий.Колонки.Добавить("НомерДействия");
	ПорядокВыполненияДействий.Колонки.Добавить("ПослеДействия");
	ПорядокВыполненияДействий.Колонки.Добавить("РезультатПредыдущегоДействия");
	ПорядокВыполненияДействий.Колонки.Добавить("Условие");
	ПорядокВыполненияДействий.Колонки.Добавить("ИмяПредметаУсловия");
	ПараметрыПроцесса.Вставить("ПорядокВыполненияДействий", ПорядокВыполненияДействий);
	
	ПараметрыПроцесса.Вставить("Контролер");
	ПараметрыПроцесса.Вставить("ТрудозатратыПланКонтролера");
	
	ПараметрыПроцесса.Вставить("ВариантМаршрутизации");
	
	Возврат ПараметрыПроцесса;
	
КонецФункции

// Создает шаблон процесса.
//
// Параметры:
//   СтруктураШаблона - Структура - структура полей шаблона комплексного процесса.
//
// Возвращаемый параметр:
//   СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов
//
Функция СоздатьШаблонКомплексногоПроцесса(СтруктураШаблона) Экспорт
	
	НачатьТранзакцию();
	
	НовыйШаблон = СоздатьЭлемент();
	ШаблоныБизнесПроцессов.ЗаполнитьШаблон(НовыйШаблон, СтруктураШаблона);
	
	СсылкаНаНовыйПроцесс = ПолучитьСсылку(Новый УникальныйИдентификатор);
	НовыйШаблон.УстановитьСсылкуНового(СсылкаНаНовыйПроцесс);
	
	ТаблицаДействий = СтруктураШаблона.Действия.Скопировать();
	ТаблицаДействий.Колонки.Добавить("ИдентификаторЭтапа");
	
	// Заполнение табличной части Этапы
	Для Каждого ДействиеШаблона Из ТаблицаДействий Цикл
		
		ВидДействия = ДействиеШаблона.ВидДействия;
		
		СтруктураДействия = ДействиеШаблона.СтруктураДействия;
		СтруктураДействия.ШаблонВКомплексномПроцессе = Истина;
		СтруктураДействия.ВладелецШаблона = СсылкаНаНовыйПроцесс;
		
		СсылкаНаДействие = СоздатьДействие(ВидДействия, СтруктураДействия);
		
		СтрокаЭтап = НовыйШаблон.Этапы.Добавить();
		СтрокаЭтап.ИдентификаторЭтапа = Новый УникальныйИдентификатор();
		СтрокаЭтап.ШаблонБизнесПроцесса = СсылкаНаДействие;
		
		МенеджерШаблона = ОбщегоНазначения.МенеджерОбъектаПоСсылке(СсылкаНаДействие);
		РеквизитыШаблона = МенеджерШаблона.РеквизитыЭтапаДляВычисляемыхПолей(СсылкаНаДействие);
		СтрокаЭтап.ИсполнителиЭтапаСтрокой = МенеджерШаблона.ПолучитьСтроковоеПредставлениеИсполнителей(РеквизитыШаблона);
		
		СтрокаЭтап.ПредшественникиВариантИспользования = ДействиеШаблона.ПорядокВыполнения;
		
		ДействиеШаблона.ИдентификаторЭтапа = СтрокаЭтап.ИдентификаторЭтапа;
		
	КонецЦикла;
	
	// Заполнение табличной части ПредшественникиЭтапов
	Если СтруктураШаблона.ВариантМаршрутизации = 
		Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
		
		ПустойИдентификатор = УникальныйИдентификаторПустой();
		
		ПорядокВыполненияДействий = СтруктураШаблона.ПорядокВыполненияДействий;
		
		Для Каждого ДействиеШаблона ИЗ ПорядокВыполненияДействий Цикл
			
			СтрокаПредшественникиЭтапов = НовыйШаблон.ПредшественникиЭтапов.Добавить();
			СтрокаПредшественникиЭтапов.ИдентификаторПоследователя = 
				ТаблицаДействий.Найти(ДействиеШаблона.НомерДействия, "НомерДействия").ИдентификаторЭтапа;
			
			Если ЗначениеЗаполнено(ДействиеШаблона.ПослеДействия) Тогда
				СтрокаПредшественникиЭтапов.ИдентификаторПредшественника =
					ТаблицаДействий.Найти(ДействиеШаблона.ПослеДействия, "НомерДействия").ИдентификаторЭтапа;
			Иначе
				СтрокаПредшественникиЭтапов.ИдентификаторПредшественника = ПустойИдентификатор;
			КонецЕсли;
			
			СтрокаПредшественникиЭтапов.УсловиеРассмотрения = ДействиеШаблона.РезультатПредыдущегоДействия;
			СтрокаПредшественникиЭтапов.УсловиеПерехода = ДействиеШаблона.Условие;
			
			СтрокаПредшественникиЭтапов.ИмяПредметаУсловия = 
				МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредмета(ДействиеШаблона.ИмяПредметаУсловия);
			
		КонецЦикла;
		
	Иначе
		
		ИД_ПредыдущегоЭтапа = УникальныйИдентификаторПустой();
		
		Для Каждого СтрокаЭтап ИЗ НовыйШаблон.Этапы Цикл
					
			СтрокаПредшественникиЭтапов = НовыйШаблон.ПредшественникиЭтапов.Добавить();
			СтрокаПредшественникиЭтапов.ИдентификаторПоследователя = СтрокаЭтап.ИдентификаторЭтапа;
			СтрокаПредшественникиЭтапов.ИдентификаторПредшественника = ИД_ПредыдущегоЭтапа;
			СтрокаПредшественникиЭтапов.УсловиеРассмотрения = 
				Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения;
			
			ИД_ПредыдущегоЭтапа = СтрокаЭтап.ИдентификаторЭтапа;
		КонецЦикла;
		
	КонецЕсли;
	
	// До заполнение табличной части ПредметыЗадач с учетом добавленных
	// действий
	Если СтруктураШаблона.Предметы.Количество() > 0 Тогда
	
		Для Каждого ШаблонЭтапа ИЗ НовыйШаблон.Этапы Цикл
			
			ИмяПроцесса = Справочники[ШаблонЭтапа.ШаблонБизнесПроцесса.Метаданные().Имя].
				ИмяПроцесса(ШаблонЭтапа.ШаблонБизнесПроцесса);
				
			Если ИмяПроцесса = "КомплексныйПроцесс" Тогда
				ДействияШаблонаЭтапа = Новый Массив;
				ДействияШаблонаЭтапа.Добавить(Неопределено);
			Иначе
				ДействияШаблонаЭтапа = БизнесПроцессы[ИмяПроцесса].ТочкиМаршрута;
			КонецЕсли;
				
			Для Каждого ДействиеШаблонаЭтапа ИЗ ДействияШаблонаЭтапа Цикл
				
				Для Каждого Предмет Из СтруктураШаблона.Предметы Цикл
					СтрокаПредметыЗадач = НовыйШаблон.ПредметыЗадач.Добавить();
					СтрокаПредметыЗадач.ИдентификаторЭтапа = ШаблонЭтапа.ИдентификаторЭтапа;
					СтрокаПредметыЗадач.ШаблонБизнесПроцесса = ШаблонЭтапа.ШаблонБизнесПроцесса;
					СтрокаПредметыЗадач.ТочкаМаршрута = ДействиеШаблонаЭтапа;
					СтрокаПредметыЗадач.ИмяПредмета = МультипредметностьВызовСервера.
						ПолучитьСсылкуНаИмяПредмета(Предмет.ИмяПредмета);
					
					Если Предмет.РольПредмета = ПредопределенноеЗначение("Перечисление.РолиПредметов.Заполняемый") 
						И ДействиеШаблонаЭтапа = Предмет.ТочкаМаршрута Тогда
						СтрокаПредметыЗадач.ОбязательноеЗаполнение = Истина;
					КонецЕсли;
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(НовыйШаблон);
	
	НовыйШаблон.Записать();
	
	// Передача подчиненным действиям.
	
	ШаблоныЭтапов = НовыйШаблон.Этапы.ВыгрузитьКолонку("ШаблонБизнесПроцесса");
	
	Для Каждого Предмет Из НовыйШаблон.Предметы Цикл
		
		СтруктураПредмета = Новый Структура("Предмет, ИмяПредмета, РольПредмета");
		ЗаполнитьЗначенияСвойств(СтруктураПредмета, Предмет);
		
		МультипредметностьВызовСервера.ДобавитьПредметВШаблоныПроцесса(
			НовыйШаблон.Ссылка,
			ШаблоныЭтапов,
			НовыйШаблон.ПредметыЗадач,
			СтруктураПредмета);
		
	КонецЦикла;
	
	// Заполнение настроек шаблонов процессов
	НастройкиШаблона = СтруктураШаблона.НастройкиШаблона.Скопировать();
	НастройкиШаблона.Колонки.Добавить("ШаблонБизнесПроцесса");
	НастройкиШаблона.ЗаполнитьЗначения(НовыйШаблон.Ссылка, "ШаблонБизнесПроцесса");
	
	НаборЗаписей = РегистрыСведений.НастройкаШаблоновБизнесПроцессов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ШаблонБизнесПроцесса.Установить(НовыйШаблон.Ссылка);
	НаборЗаписей.Загрузить(НастройкиШаблона);
	НаборЗаписей.Записать();
	
	ЗафиксироватьТранзакцию();
	
	Возврат НовыйШаблон.Ссылка;
	
КонецФункции

Функция ИмяПроцесса(ШаблонСсылка) Экспорт
	
	Возврат "КомплексныйПроцесс";
	
КонецФункции

Функция СинонимПроцесса(ИмяПроцесса, РеквизитыШаблона) Экспорт
	
	Возврат Метаданные.БизнесПроцессы[ИмяПроцесса].Синоним;
	
КонецФункции

// Заполняет html обзор данными шаблона процесса.
//
// Параметры:
//   HTMLТекст - Строка
//   Шаблон - СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов - ссылка на шаблон
//
Процедура ЗаполнитьОбзорШаблона(HTMLТекст, Шаблон) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РеквизитыШаблона = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шаблон,
		"Схема,
		|Контролер,
		|ВариантМаршрутизации,
		|Этапы");
	
	Схема = РеквизитыШаблона.Схема;
	Контролер = РеквизитыШаблона.Контролер;
	ВариантМаршрутизации = РеквизитыШаблона.ВариантМаршрутизации;
	
	ИспользуетсяСхема = ЗначениеЗаполнено(Схема);
	
	Если ИспользуетсяСхема Тогда
		
		РеквизитыСхемы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Схема, "ПараметрыДействий, ЭлементыСхемы, ПредшественникиЭлементовСхемы");
		
		Действия = РеквизитыСхемы.ПараметрыДействий.Выгрузить();
		ЭлементыСхемы = РеквизитыСхемы.ЭлементыСхемы.Выгрузить();
		ПредшественникиЭлементовСхемы = РеквизитыСхемы.ПредшественникиЭлементовСхемы.Выгрузить();
		
		КэшДанныхДействий = РаботаСКомплекснымиБизнесПроцессамиСервер.КэшДанныхДействий(Действия);
		
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("Число"));
		ОписаниеТипаЧисло = Новый ОписаниеТипов(МассивТипов);
		
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("Дата"));
		ОписаниеТипаДата = Новый ОписаниеТипов(МассивТипов);
		
		Действия.Колонки.Добавить("СрокИсполненияПроцесса", ОписаниеТипаДата);
		Действия.Колонки.Добавить("СрокИсполненияПроцессаДни", ОписаниеТипаЧисло);
		Действия.Колонки.Добавить("СрокИсполненияПроцессаЧасы", ОписаниеТипаЧисло);
		Действия.Колонки.Добавить("СрокИсполненияПроцессаМинуты", ОписаниеТипаЧисло);
		Действия.Колонки.Добавить("СостояниеПроцесса");
		
		СрокиИсполненияПроцессовКлиентСерверКОРП.
			ЗаполнитьСрокиВПараметрахДействийСхемыКомплексногоПроцесса(
				Действия, ЭлементыСхемы, КэшДанныхДействий);
		
	Иначе
		Действия = РеквизитыШаблона.Этапы.Выгрузить();
		Действия.Колонки.Добавить("СрокИсполненияПроцессаДни");
		Действия.Колонки.Добавить("СрокИсполненияПроцессаЧасы");
		Действия.Колонки.Добавить("СрокИсполненияПроцессаМинуты");
		СрокиИсполненияПроцессовКОРП.ЗаполнитьСрокиИсполненияЭтаповКомплексногоПроцесса(Действия);
		
		РеквизитШаблон = "ШаблонБизнесПроцесса";
	КонецЕсли;
	
	// Формирование строк таблицы
	Если Действия.Количество() > 0 Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		HTMLТекст = HTMLТекст + "<table class=""frame"">";
		
		//Формирование заголовка таблицы
		HTMLТекст = HTMLТекст + "<tr>";
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = '№'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Действие'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"" width=""100"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Срок'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		
		НомерШага = 0;
		
		//Заполнение таблицы действиями
		Для Каждого СтрокаТаблицы Из Действия Цикл
			
			НомерШага = НомерШага + 1;
			
			Если ИспользуетсяСхема Тогда
				Действие = СтрокаТаблицы.ШаблонПроцесса;
			Иначе
				Действие = СтрокаТаблицы.ШаблонБизнесПроцесса;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Действие) Тогда
				Продолжить;
			КонецЕсли;
			
			HTMLТекст = HTMLТекст + "<tr>";
			
			HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, НомерШага, "");
			HTMLТекст = HTMLТекст + "</td>";
			
			HTMLТекст = HTMLТекст + "<td class=""frame"">";
			ЦветТекста = "";
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Действие, ЦветТекста);
			HTMLТекст = HTMLТекст + "</td>";
			
			// Срок исполнения действия
			HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"" width=""100"">";
			ПредставлениеСрока = ОбзорПроцессовВызовСервера.ПредставлениеСрокаИсполнения(
				Дата(1,1,1), СтрокаТаблицы.СрокИсполненияПроцессаДни,
				СтрокаТаблицы.СрокИсполненияПроцессаЧасы, СтрокаТаблицы.СрокИсполненияПроцессаМинуты,
				ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач"),
				Перечисления.ВариантыУстановкиСрокаИсполнения.ОтносительныйСрок);
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеСрока, "");
			HTMLТекст = HTMLТекст + "</td>";
			
			HTMLТекст = HTMLТекст + "</tr>";
			
		КонецЦикла;
		
		HTMLТекст = HTMLТекст + "</table>";
		
		// Формирование подписей под таблицей
		HTMLТекст = HTMLТекст + "<table cellpadding=""0"">";
		HTMLТекст = HTMLТекст + "<tr>";
		
		HTMLТекст = HTMLТекст + "<td>";
		Если ЗначениеЗаполнено(Схема) Тогда
			HTMLТекст = HTMLТекст + СтрШаблон(
				"<A href=v8doc:%1>%2</A>",
				ПолучитьНавигационнуюСсылку(Схема),
				НСтр("ru = 'Схема'"));
		ИначеЕсли ЗначениеЗаполнено(ВариантМаршрутизации) Тогда
			ПредставлениеРеквизитаНаправлять = НСтр("ru = 'Порядок: %1'");
			ПредставлениеРеквизитаНаправлять = СтрШаблон(
				ПредставлениеРеквизитаНаправлять,
				Строка(ВариантМаршрутизации));
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеРеквизитаНаправлять, "");
		КонецЕсли;
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "<td align=""right"">";
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		HTMLТекст = HTMLТекст + "</table>";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контролер) Тогда
		HTMLТекст = HTMLТекст + "<p>";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Контролер: '"));
		ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Контролер, "");
	КонецЕсли;
	
	// Общий срок процесса
	Если ИспользуетсяСхема Тогда
		Смещение = СрокиИсполненияПроцессовКОРП.СмещенияДатыОтсчета(Шаблон);
		ДлительностьПроцесса = СрокиИсполненияПроцессовКОРП.
			ДлительностьИсполненияКомплексногоПроцессаПоДаннымСхемы(
				ЭлементыСхемы, Действия, ПредшественникиЭлементовСхемы, Смещение);
	Иначе
		ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(Шаблон);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДлительностьПроцесса.СрокИсполненияПроцессаДни)
		Или ЗначениеЗаполнено(ДлительностьПроцесса.СрокИсполненияПроцессаЧасы)
		Или ЗначениеЗаполнено(ДлительностьПроцесса.СрокИсполненияПроцессаМинуты) Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		ПредставлениеДлительности = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
			ДлительностьПроцесса.СрокИсполненияПроцессаДни,
			ДлительностьПроцесса.СрокИсполненияПроцессаЧасы,
			ДлительностьПроцесса.СрокИсполненияПроцессаМинуты);
		
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Срок процесса:'"));
		ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеДлительности, "");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_УправлениеДоступом

// Список реквизитов, которые используются для расчета прав доступа.
// 
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ответственный,
		|Ссылка,
		|ЭтоГруппа,
		|ШаблонВКомплексномПроцессе,
		|ВладелецШаблона,
		|КомплексныйПроцесс";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ШаблоныБизнесПроцессов.ЗаполнитьДескрипторыОбъекта(
		ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_Предметы

// Возвращает участников шаблона для проверки прав на предметы.
//
// Параметры:
//  Шаблон - СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов, СправочникОбъект.ШаблоныКомплексныхБизнесПроцессов - шаблон
//  ИмяПредмета - СправочникСсылка.ИменаПредметов - имя предмета.
//
// Возвращаемое значение:
//  ТаблицаЗначений
//   * Участник
//   * Изменение
//
Функция УчастникиДляПроверкиПрав(Шаблон) Экспорт
	
	ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьПустуюТаблицуУчастников();
	
	РаботаСБизнесПроцессами.ДобавитьУчастниковКомплексногоПроцессаВТаблицу(ТаблицаУчастников, Шаблон);
	
	Возврат ТаблицаУчастников;

КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаКомплексныхПроцессов

// Показывает, может ли процесс по данному шаблону использоваться в качестве части комплексного процесса
Функция МожетИспользоватьсяВКомплексномПроцессе() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает реквизиты, которые используются для определения значений
// вычисляемых полей комплексного процесса.
//
// Параметры:
//  Процесс - СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов - ссылка на шаблон
//
// Возвращаемое значение:
//  Структура
//
Функция РеквизитыЭтапаДляВычисляемыхПолей(Процесс) Экспорт
	
	РеквизитыСтрокой = 
		"НаименованиеБизнесПроцесса,
		|ИсходныйШаблон,
		|Описание,
		|Важность,
		|СрокОтложенногоСтарта,
		|Ссылка";
	
	РеквизитыПроцесса = ОбщегоНазначенияДокументооборот.
		ЗначенияРеквизитовОбъектаВПривилегированномРежиме(Процесс, РеквизитыСтрокой);
	
	Возврат РеквизитыПроцесса;
	
КонецФункции

// Получает строковое представление исполнителей шаблона процесса
//
// Параметры:
//  РеквизитыПроцесса - Струкута - см. РеквизитыЭтапаДляВычисляемыхПолей
//
// Возаращаемое значение:
//  Строка
//
Функция ПолучитьСтроковоеПредставлениеИсполнителей(РеквизитыПроцесса) Экспорт
	
	Возврат НСтр("ru = 'Определяются настройкой действия'");
	
КонецФункции

#Область КэшДанныхДействий

// Возвращает выбору данных действий.
//
// Параметры:
//  ПараметрыДействий - ТаблицаЗначений - параметры действий, соответствует табличной части
//                                        ПараметрыДействий схемы процесса.
//
// Возвращаемое значение:
//  ВыборкаДанных
//
Функция ВыборкаДанныхДействий(ПараметрыДействий) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПараметрыДействий.ШаблонПроцесса
		|ПОМЕСТИТЬ ПараметрыДействий
		|ИЗ
		|	&ПараметрыДействий КАК ПараметрыДействий
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ШаблоныКомплексныхБизнесПроцессов.Ссылка,
		|	ШаблоныКомплексныхБизнесПроцессов.Наименование,
		|	ШаблоныКомплексныхБизнесПроцессов.Схема,
		|	ШаблоныКомплексныхБизнесПроцессов.Этапы,
		|	ШаблоныКомплексныхБизнесПроцессов.ПредшественникиЭтапов,
		|	ШаблоныКомплексныхБизнесПроцессов.СрокИсполненияПроцесса
		|ИЗ
		|	ПараметрыДействий КАК ПараметрыДействий
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШаблоныКомплексныхБизнесПроцессов КАК ШаблоныКомплексныхБизнесПроцессов
		|		ПО ПараметрыДействий.ШаблонПроцесса = ШаблоныКомплексныхБизнесПроцессов.Ссылка";
		
	Запрос.УстановитьПараметр("ПараметрыДействий", ПараметрыДействий);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

// Возвращает данные процесса, являющегося действием комплексного процесса.
//
// Параметры:
//  Объект - СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов, ВыборкаДанных
//
// Возвращаемое значение:
//  Структура - см. функцию РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.СтруктураДанныхДействия
//
Функция ДанныеДействия(Объект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеПроцесса = РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.СтруктураДанныхДействия();
	
	ТипОбъект = ТипЗнч(Объект);
	
	РеквизитыОбъектаСтрокой = 
		"Ссылка, Наименование, Схема, Этапы, ПредшественникиЭтапов, СрокИсполненияПроцесса";
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипОбъект) Тогда
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект, РеквизитыОбъектаСтрокой);
		РеквизитыОбъекта.Этапы = РеквизитыОбъекта.Этапы.Выгрузить();
		РеквизитыОбъекта.ПредшественникиЭтапов = РеквизитыОбъекта.ПредшественникиЭтапов.Выгрузить();
	ИначеЕсли ТипОбъект = Тип("ВыборкаИзРезультатаЗапроса") Тогда
		РеквизитыОбъекта = Новый Структура(РеквизитыОбъектаСтрокой);
		ЗаполнитьЗначенияСвойств(РеквизитыОбъекта, Объект,, "Этапы, ПредшественникиЭтапов");
		РеквизитыОбъекта.Этапы = Объект.Этапы.Выгрузить();
		РеквизитыОбъекта.ПредшественникиЭтапов = Объект.ПредшественникиЭтапов.Выгрузить();
	Иначе
		РеквизитыОбъекта = Объект;
	КонецЕсли;
	
	ДанныеПроцесса.Описание = НСтр("ru = 'Комплексный процесс: '") + РеквизитыОбъекта.Наименование;
	
	ДанныеПроцесса.СрокИсполненияПроцесса = РеквизитыОбъекта.СрокИсполненияПроцесса;
	
	ДлительностьИсполнения = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(РеквизитыОбъекта);
	ЗаполнитьЗначенияСвойств(ДанныеПроцесса, ДлительностьИсполнения);
	
	Возврат ДанныеПроцесса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ПрограммныйИнтерфейс_Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Печать карточки шаблона комплексного процесса.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Карточка", "Карточка комплексного процесса", 
			РаботаСКомплекснымиБизнесПроцессамиСервер.ПечатьКарточки(
				МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВыбраннаяФорма = "Справочник.ШаблоныКомплексныхБизнесПроцессов.Форма.ФормаЭлемента";
		
		Если Не Параметры.Свойство("ВладелецШаблона") И Параметры.Свойство("Ключ") Тогда
			ВладелецШаблона = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
				Параметры.Ключ, "ВладелецШаблона");
				
			Если (ТипЗнч(ВладелецШаблона) = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов")
					Или ТипЗнч(ВладелецШаблона) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс")) Тогда
				
				Параметры.Вставить("ВладелецШаблона", ВладелецШаблона);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ОбщаяФорма.ВыборШаблонаБизнесПроцесса";
		Параметры.Вставить("ТипШаблона", "Комплексный");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьДействие(ВидДействия, СтруктураДействия)
	
	СсылкаНаДействие = Неопределено;
	
	Если ВидДействия = "Исполнение" Тогда
		СсылкаНаДействие = Справочники.ШаблоныИсполнения.
			СоздатьШаблонИсполнения(СтруктураДействия);
	ИначеЕсли ВидДействия = "КомплексныйПроцесс" Тогда
		СсылкаНаДействие = Справочники.ШаблоныКомплексныхБизнесПроцессов.
			СоздатьШаблонКомплексногоПроцесса(СтруктураДействия);
	ИначеЕсли ВидДействия = "Ознакомление" Тогда
		СсылкаНаДействие = Справочники.ШаблоныОзнакомления.
			СоздатьШаблонОзнакомления(СтруктураДействия);
	ИначеЕсли ВидДействия = "Поручение" Тогда
		СсылкаНаДействие = Справочники.ШаблоныПоручения.
			СоздатьШаблонПоручения(СтруктураДействия);
	ИначеЕсли ВидДействия = "Приглашение" Тогда
		
	ИначеЕсли ВидДействия = "Рассмотрение" Тогда
		СсылкаНаДействие = Справочники.ШаблоныРассмотрения.
			СоздатьШаблонРассмотрения(СтруктураДействия);
	ИначеЕсли ВидДействия = "Регистрация" Тогда
		СсылкаНаДействие = Справочники.ШаблоныРегистрации.
			СоздатьШаблонРегистрации(СтруктураДействия);
	ИначеЕсли ВидДействия = "Согласование" Тогда
		СсылкаНаДействие = Справочники.ШаблоныСогласования.
			СоздатьШаблонСогласования(СтруктураДействия);
	ИначеЕсли ВидДействия = "Утверждение" Тогда
		СсылкаНаДействие = Справочники.ШаблоныУтверждения.
			СоздатьШаблонУтверждения(СтруктураДействия);
	КонецЕсли;
	
	Возврат СсылкаНаДействие;
	
КонецФункции

#КонецОбласти

#КонецЕсли
