#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет html обзор данными процесса.
//
// Параметры:
//   HTMLТекст - Строка
//   Шаблон - БизнесПроцессСсылка.ОбработкаВходящегоДокумента - ссылка на процесс
//
Процедура ЗаполнитьОбзорПроцесса(HTMLТекст, Процесс) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	РеквизитыПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Процесс,
		"СрокИсполненияПроцесса, ДатаЗавершения");
		
	СрокИсполненияПроцесса = РеквизитыПроцесса.СрокИсполненияПроцесса;
	ДатаЗавершения = РеквизитыПроцесса.ДатаЗавершения;
	
	ЦветЗакрытыеНеактуальныеЗаписи = ОбзорПроцессовВызовСервера.ЦветЗакрытыеНеактуальныеЗаписи();
	
	ЦветПросроченныеДанные = ОбзорПроцессовВызовСервера.ЦветПросроченныеДанные();
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		ФорматСрока = "ДФ='dd.MM.yyyy HH:mm'";
	Иначе
		ФорматСрока = "ДФ='dd.MM.yyyy'";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбработкаВходящегоДокумента.ШаблонРассмотрения КАК ШаблонДействия,
		|	ОбработкаВходящегоДокумента.Ссылка КАК РодительскийПроцесс,
		|	1 КАК Порядок
		|ПОМЕСТИТЬ ШаблоныПроцессы
		|ИЗ
		|	БизнесПроцесс.ОбработкаВходящегоДокумента КАК ОбработкаВходящегоДокумента
		|ГДЕ
		|	ОбработкаВходящегоДокумента.Ссылка = &РодительскийПроцесс
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОбработкаВходящегоДокумента.ШаблонИсполненияОзнакомления,
		|	ОбработкаВходящегоДокумента.Ссылка,
		|	2
		|ИЗ
		|	БизнесПроцесс.ОбработкаВходящегоДокумента КАК ОбработкаВходящегоДокумента
		|ГДЕ
		|	ОбработкаВходящегоДокумента.Ссылка = &РодительскийПроцесс
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОбработкаВходящегоДокумента.ШаблонПоручения,
		|	ОбработкаВходящегоДокумента.Ссылка,
		|	3
		|ИЗ
		|	БизнесПроцесс.ОбработкаВходящегоДокумента КАК ОбработкаВходящегоДокумента
		|ГДЕ
		|	ОбработкаВходящегоДокумента.Ссылка = &РодительскийПроцесс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ШаблоныПроцессы.ШаблонДействия,
		|	ДочерниеБизнесПроцессы.ДочернийПроцесс КАК Действие,
		|	ДочерниеБизнесПроцессы.ДочернийПроцесс.Завершен КАК Завершено,
		|	ШаблоныПроцессы.Порядок КАК Порядок
		|ИЗ
		|	ШаблоныПроцессы КАК ШаблоныПроцессы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДочерниеБизнесПроцессы КАК ДочерниеБизнесПроцессы
		|		ПО ШаблоныПроцессы.ШаблонДействия = ДочерниеБизнесПроцессы.ДочернийПроцесс.Шаблон
		|			И ШаблоныПроцессы.РодительскийПроцесс = ДочерниеБизнесПроцессы.РодительскийПроцесс
		|ГДЕ
		|	НЕ ШаблоныПроцессы.ШаблонДействия ЕСТЬ NULL 
		|	И ШаблоныПроцессы.ШаблонДействия <> НЕОПРЕДЕЛЕНО
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
	
	Запрос.УстановитьПараметр("РодительскийПроцесс", Процесс);
	
	УстановитьПривилегированныйРежим(Истина);
	ДействияПроцесса = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроцессыМассив = ДействияПроцесса.ВыгрузитьКолонку("Действие");
	
	ОбратныйИндекс = ДействияПроцесса.Количество() - 1;
	Пока ОбратныйИндекс >= 0 Цикл
		Если ДействияПроцесса[ОбратныйИндекс].ШаблонДействия.Пустая() Тогда
			ДействияПроцесса.Удалить(ДействияПроцесса[ОбратныйИндекс]);
		КонецЕсли;
		ОбратныйИндекс = ОбратныйИндекс - 1;
	КонецЦикла;
	
	Если ДействияПроцесса.Количество() > 0 Тогда
		
		РезультатСоответствие 
			= ОбзорПроцессовВызовСервера.РезультатыВыполненияПоОбъектам(ПроцессыМассив, "Процесс");
		
		HTMLТекст = HTMLТекст + "<p>";
		
		HTMLТекст = HTMLТекст + "<table class=""frame"">";
		
		//Формирование заголовка таблицы
		HTMLТекст = HTMLТекст + "<tr>";
		
		Если РезультатСоответствие.Количество() <> 0 Тогда
			// статус исполнения - в шапке пусто
			HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, "", "");
			HTMLТекст = HTMLТекст + "</td>";
		КонецЕсли;
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Действие'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"" width=""100"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Срок'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		
		Для Каждого СтрДействие Из ДействияПроцесса Цикл
			
			Если ЗначениеЗаполнено(СтрДействие.Действие) Тогда
				
				Действие = СтрДействие.Действие;
				
				РеквизитыДействия = 
					ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Действие, "СрокИсполненияПроцесса, ДатаЗавершения");
				СрокИсполненияДействия = РеквизитыДействия.СрокИсполненияПроцесса;
				ДатаЗавершенияДействия = РеквизитыДействия.ДатаЗавершения;
				
				ПредставлениеСрока = Формат(СрокИсполненияДействия, ФорматСрока);
				
				Если Не ЗначениеЗаполнено(ДатаЗавершенияДействия) Тогда
					ДатаЗавершенияДействия = ТекущаяДатаСеанса;
				КонецЕсли;
				
				ДатаЗавершенияДействия = ДатаЗавершенияДействия - Секунда(ДатаЗавершенияДействия);
				
				ЦветПредставленияСрока = "";
				Если СрокИсполненияДействия < ДатаЗавершенияДействия Тогда
					ЦветПредставленияСрока = ЦветПросроченныеДанные;
				КонецЕсли;
				
			Иначе
				
				Действие = СтрДействие.ШаблонДействия;
				
				ДлительностьИсполненияДействия = 
					СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(Действие);
					
				Дни = ДлительностьИсполненияДействия.СрокИсполненияПроцессаДни;
				Часы = 0;
				Минуты = 0;
				
				Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
					Часы = ДлительностьИсполненияДействия.СрокИсполненияПроцессаЧасы;
					Минуты = ДлительностьИсполненияДействия.СрокИсполненияПроцессаМинуты;
				КонецЕсли;
				
				ПредставлениеСрока = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
					Дни, Часы, Минуты);
					
				ЦветПредставленияСрока = "";
					
			КонецЕсли;
			
			ЦветТекста = "";
			Если СтрДействие.Завершено = Истина
				Или Не ЗначениеЗаполнено(СтрДействие.Действие) Тогда
				
				HTMLТекст = HTMLТекст + "<FONT color=""" + ЦветЗакрытыеНеактуальныеЗаписи + """>";
				ЦветТекста = ЦветЗакрытыеНеактуальныеЗаписи;
			КонецЕсли;
			
			HTMLТекст = HTMLТекст + "<tr>";
			
			// статус исполнения
			Если РезультатСоответствие.Количество() <> 0 Тогда
				
				HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
				РезультатВыполненияЗадачи = РезультатСоответствие.Получить(СтрДействие.Действие);
				Если РезультатВыполненияЗадачи <> Неопределено Тогда
					
					Картинка = ОбзорПроцессовВызовСервера.ПолучитьКартинкуПоСтатусуВыполнения(
						РезультатВыполненияЗадачи);
					
					ОбзорОбъектовКлиентСервер.ДобавитьКартинку(HTMLТекст, Картинка);
					
				Иначе
					ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, "", "");
				КонецЕсли;	
				HTMLТекст = HTMLТекст + "</td>";
				
			КонецЕсли;	
			
			HTMLТекст = HTMLТекст + "<td class=""frame"">";
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Действие, ЦветТекста);
			HTMLТекст = HTMLТекст + "</td>";
			
			// Срок исполнения действия
			HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"" width=""100"">";
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, ПредставлениеСрока, ЦветПредставленияСрока);
			HTMLТекст = HTMLТекст + "</td>";
			
			HTMLТекст = HTMLТекст + "</tr>";
			
			Если СтрДействие.Завершено = Истина
				Или Не ЗначениеЗаполнено(СтрДействие.Действие) Тогда
				
				HTMLТекст = HTMLТекст + "</FONT>";
			КонецЕсли;
			
		КонецЦикла;
		
		HTMLТекст = HTMLТекст + "</table>";
		
		// Формирование подписей под таблицей
		HTMLТекст = HTMLТекст + "<table cellpadding=""0"">";
		HTMLТекст = HTMLТекст + "<tr>";
		
		HTMLТекст = HTMLТекст + "<td align=""right"">";
		HTMLТекст = HTMLТекст + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<A href=v8doc:%1>%2</A>",
			"Подзадачи_" + Процесс.УникальныйИдентификатор() + "_ОбработкаВходящегоДокумента",
			НСтр("ru = 'Все задачи'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		HTMLТекст = HTMLТекст + "</table>";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СрокИсполненияПроцесса) Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		Если Не ЗначениеЗаполнено(ДатаЗавершения) Тогда
			ДатаЗавершения = ТекущаяДатаСеанса;
		КонецЕсли;
		
		ДатаЗавершения = ДатаЗавершения - Секунда(ДатаЗавершения);
		
		ЦветПредставленияСрока = "";
		Если СрокИсполненияПроцесса < ДатаЗавершения Тогда
			ЦветПредставленияСрока = ЦветПросроченныеДанные;
		КонецЕсли;
		
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Срок процесса:'"));
		ОбзорОбъектовКлиентСервер.ДобавитьЗначение(
			HTMLТекст, Формат(СрокИсполненияПроцесса, ФорматСрока), ЦветПредставленияСрока);
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

// Возвращает признак того что процесс использует условия выполнения задач.
//
// Параметры:
//  ТочкаМаршрута - ТочкаМаршрутаСсылка - Точка маршрута.
//  Параметры - Структура - Параметры.
// 
// Возвращаемое значение:
//  Булево - Использует условия выполнения задач.
//
Функция ИспользуетУсловияЗапретаВыполненияЗадач(ТочкаМаршрута = Неопределено, Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Параметры = Новый Структура;
	КонецЕсли;
	
	ИспользуетУсловияЗапретаВыполненияЗадач = Ложь;
	
	Возврат ИспользуетУсловияЗапретаВыполненияЗадач;
	
КонецФункции

// Формирует комментарий автоматического выполнения задачи.
//
// Параметры:
//  ТочкаМаршрута - ТочкаМаршрута - Точка маршрута.
//  ВариантВыполнения - Булево - Вариант выполнения.
//
// Возвращаемое значение:
//  Строка - Комментарий автоматического выполнения задачи.
//
Функция КомментарийВыполненаАвтоматически(ТочкаМаршрута, ВариантВыполнения) Экспорт
	
	Комментарий = "";
	
	Возврат Комментарий;
	
КонецФункции

// Возвращает для таблицы подзадач - задачи (в том числе и еще не стартованные) процесса в виде массива структур
//
// Параметры:
//   Процесс
//      БизнесПроцессСсылка
//
// Возвращаемое значение:
//   Массив структура(Задача, Процесс, Наименование, Участник, СрокИсполнения, ДатаСоздания, Выполнена)
//
Функция ПодзадачиПроцесса(Процесс) Экспорт
	
	МассивЗадач = Новый Массив;
	Возврат МассивЗадач;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_РабочиеГруппы

// Возвращает признак наличия метода ДобавитьУчастниковВТаблицу у менеджера объекта
//
Функция ЕстьМетодДобавитьУчастниковВТаблицу() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_Предметы

// Возвращает участников для проверки прав на предметы.
//
// Параметры:
//  Процесс - БизнесПроцессОбъект, БизнесПроцессСсылка - процесс
//
// Возвращаемое значение:
//  ТаблицаЗначений
//   * Участник
//   * Изменение
//
Функция УчастникиДляПроверкиПрав(Процесс) Экспорт
	
	УчастникиДляПроверкиПрав = РаботаСРабочимиГруппами.ПолучитьПустуюТаблицуУчастников();
	
	ТипПроцесса = ТипЗнч(Процесс);
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипПроцесса) Тогда
		ЭтоСсылка = Истина;
		ПроцессСсылка = Процесс;
	Иначе
		ЭтоСсылка = Ложь;
		ПроцессСсылка = Процесс.Ссылка;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТИПЗНАЧЕНИЯ(ДочерниеБизнесПроцессы.ДочернийПроцесс) КАК Тип
		|ИЗ
		|	РегистрСведений.ДочерниеБизнесПроцессы КАК ДочерниеБизнесПроцессы
		|ГДЕ
		|	ДочерниеБизнесПроцессы.РодительскийПроцесс = &РодительскийПроцесс";
		
	Запрос.УстановитьПараметр("РодительскийПроцесс", ПроцессСсылка);
	
	ТипыСтартованныхДействий = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Тип");;
	
	РеквизитыПроцесса = 
		"ШаблонИсполненияОзнакомления,
		|ШаблонПоручения,
		|ШаблонРассмотрения";
	
	Если ЭтоСсылка Тогда
		РеквизитыПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПроцессСсылка, РеквизитыПроцесса);
	Иначе
		РеквизитыПроцесса = Новый Структура(РеквизитыПроцесса);
		ЗаполнитьЗначенияСвойств(РеквизитыПроцесса, Процесс);
	КонецЕсли;
	
	Для Каждого Реквизит Из РеквизитыПроцесса Цикл
		
		Если Не ЗначениеЗаполнено(Реквизит.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		МенеджерШаблона = 
			ОбщегоНазначения.МенеджерОбъектаПоСсылке(Реквизит.Значение);
		
		ИмяПроцесса = МенеджерШаблона.ИмяПроцесса(Реквизит.Значение);
		
		ТипПроцесса = Тип("БизнесПроцессСсылка." + ИмяПроцесса);
		
		Если ТипыСтартованныхДействий.Найти(ТипПроцесса) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		УчастникиШаблона = 
			МенеджерШаблона.УчастникиДляПроверкиПрав(Реквизит.Значение);
		
		Для Каждого УчастникШаблона Из УчастникиШаблона Цикл
			Если ТипЗнч(УчастникШаблона) = Тип("Строка")
				Или УчастникиДляПроверкиПрав.Найти(УчастникШаблона) <> Неопределено Тогда
				
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(УчастникиДляПроверкиПрав.Добавить(), УчастникШаблона);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат УчастникиДляПроверкиПрав;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаКомплексныхПроцессов

// Показывает, может ли процесс использоваться в качестве части комплексного процесса
Функция МожетИспользоватьсяВКомплексномПроцессе() Экспорт
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_РИБ

Процедура ОбработатьПолучениеПроцессаИзУзлаРИБ(Узел, ЭлементДанных) Экспорт
	
	ЭтотУзел = РаботаСБизнесПроцессами.ЭтотУзелОбменаДляОбработкиПроцессов();
	
	Если ЭтотУзел = ЭлементДанных.УзелОбмена Тогда // Получение процесса в мастер-узле.
		
		ЗаписатьПроцесс = Ложь;
		
		ПроцессПоСсылке = ЭлементДанных.Ссылка.ПолучитьОбъект();
		
		// Добавляем новые предметы в текущий процесс
		КоличествоПредметовДоДобавления = ПроцессПоСсылке.Предметы.Количество();
		
		РаботаСБизнесПроцессами.ДобавитьНовыеПредметыВПроцесс(
			ПроцессПоСсылке, ЭлементДанных.Предметы, ЭлементДанных.ПредметыЗадач);
		
		КоличествоПредметовПослеДобавления = ПроцессПоСсылке.Предметы.Количество();
		
		Если КоличествоПредметовДоДобавления <> КоличествоПредметовПослеДобавления Тогда
			ЗаписатьПроцесс = Истина;
		КонецЕсли;
		
		Если ЗаписатьПроцесс Тогда
			ПроцессПоСсылке.ОбменДанными.Загрузка = Истина;
			ПроцессПоСсылке.ДополнительныеСвойства.Вставить("УзелОтправитель", Узел);
			ПроцессПоСсылке.Записать();
		Иначе
			
			ОтправкаНазад = Ложь;
			
			// Сравниваем полученный процесс с процессом в мастер узле.
			// В случае отличий отправляем процесс обратно.
			МетаданныеЗадачи = ЭлементДанных.Ссылка.Метаданные();
			ИменаПолейДляСравнения = "";
			Разделитель = "";
			Для Каждого РеквизитЗадачи Из МетаданныеЗадачи.Реквизиты Цикл
				ИменаПолейДляСравнения = ИменаПолейДляСравнения
					+ Разделитель
					+ РеквизитЗадачи.Имя;
				Разделитель = ",";
			КонецЦикла;
			Для Каждого РеквизитЗадачи Из МетаданныеЗадачи.СтандартныеРеквизиты Цикл
				ИменаПолейДляСравнения = ИменаПолейДляСравнения
					+ Разделитель
					+ РеквизитЗадачи.Имя;
				Разделитель = ",";
			КонецЦикла;
			
			СтруктураПроцессаПоСсылке = Новый Структура(ИменаПолейДляСравнения);
			ЗаполнитьЗначенияСвойств(СтруктураПроцессаПоСсылке, ПроцессПоСсылке);
			
			СтруктураПроцесса = Новый Структура(ИменаПолейДляСравнения);
			ЗаполнитьЗначенияСвойств(СтруктураПроцесса, ЭлементДанных);
			
			Если Не ОбщегоНазначения.ДанныеСовпадают(СтруктураПроцессаПоСсылке, СтруктураПроцесса) Тогда
				ОтправкаНазад = Истина;
			КонецЕсли;
			
			Если Не ОбщегоНазначения.ДанныеСовпадают(
					ПроцессПоСсылке.ДополнительныеРеквизиты.Выгрузить(),
					ЭлементДанных.ДополнительныеРеквизиты.Выгрузить()) Тогда
					
				ОтправкаНазад = Истина;
			КонецЕсли;
			
			Если ОтправкаНазад Тогда
				РаботаСБизнесПроцессами.ЗарегистрироватьИзмененияПроцессаЗадачи(ПроцессПоСсылке);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ЭлементДанных.Завершен Тогда // получение выполненного процесса в обычном узле
		ЭлементДанных.ОбменДанными.Загрузка = Истина;
		ЭлементДанных.ДополнительныеСвойства.Вставить("УзелОтправитель", Узел);
		ЭлементДанных.Записать();
	Иначе
	
		// Принимает все пришедшие изменения.
		ПоляДляПолучения = Новый Массив;
		ПоляДляПолучения.Добавить("Предметы");
		ПоляДляПолучения.Добавить("ПредметыЗадач");
		
		ПоляПроцесса = СтрСоединить(ПоляДляПолучения, ",");
			
		РеквизитыПроцесса = ОбщегоНазначенияДокументооборот.ЗначенияРеквизитовОбъектаВПривилегированномРежиме(
			ЭлементДанных.Ссылка, ПоляПроцесса);
			
		Предметы = РеквизитыПроцесса.Предметы.Выгрузить();
		
		ПредметыЗадач = РеквизитыПроцесса.ПредметыЗадач.Выгрузить();
		
		// Дополняем переданные предметы, которые были ранее.
		РаботаСБизнесПроцессами.ДобавитьНовыеПредметыВПроцесс(ЭлементДанных, Предметы, ПредметыЗадач);
		
		ЭлементДанных.ОбменДанными.Загрузка = Истина;
		ЭлементДанных.ДополнительныеСвойства.Вставить("УзелОтправитель", Узел);
		ЭлементДанных.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_СрокиИсполненияПроцессов

// Возвращает даты исполнения участников процесса.
//
// Параметры:
//  Процесс - БизнесПроцессСсылка.ОбработкаВходящегоДокумента - ссылка на процесс
//
// Возвращаемое значение:
//  Соотвествие
//   * Ключ - Строка, ЗадачаСсылка.ЗадачаИсполнителя - имя реквизита с участником процесса или ссылка на его задачу.
//
Функция ДатыИсполненияУчастников(Процесс) Экспорт
	
	// Функция не предусмотрена для данного вида процессов.
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("ТипПроцесса", "ОбработкаВходящегоДокумента");
		ВыбраннаяФорма = Метаданные.ОбщиеФормы.СписокПроцессов;
		
	ИначеЕсли ВидФормы = "ФормаВыбора" Тогда
		
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("Заголовок", НСтр("ru = 'Обработка входящего документа'"));
		Параметры.Вставить("ТипПроцесса", Тип("БизнесПроцессСсылка.ОбработкаВходящегоДокумента"));
		ВыбраннаяФорма = Метаданные.ОбщиеФормы.ВыборБизнесПроцесса;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ОбъектДоступа = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	// Только основной дескриптор, без рабочей группы.
	ДокументооборотПраваДоступа.ЗаполнитьДескрипторОбъектаОсновной(ОбъектДоступа, ТаблицаДескрипторов);
	
КонецПроцедуры

// Возвращает признак того, что менеджер содержит метод ЗапросДляРасчетаПрав()
// 
Функция ЕстьМетодЗапросДляРасчетаПрав() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает запрос для расчета прав доступа по дескрипторам объекта
// 
// Параметры:
//  
//  Дескрипторы - Массив - массив дескрипторов, чьи права нужно рассчитать
//  ИдОбъекта - Ссылка - идентификатор объекта метаданных, назначенный переданным дескрипторам
//  МенеджерОбъектаДоступа - СправочникМенеджер, ДокументМенеджер - менеджер объекта доступа
// 
// Возвращаемое значение - Запрос - запрос, который выберет права доступа для переданного массива дескрипторов
// 
Функция ЗапросДляРасчетаПрав(Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа) Экспорт
	
	Возврат БизнесПроцессыИЗадачиСервер.ЗапросДляРасчетаПрав(Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа);
	
КонецФункции

// Заполняет протокол расчета прав дескрипторов
// 
// Параметры:
//  
//  ПротоколРасчетаПрав - Массив - протокол для заполнения
//  ЗапросПоПравам - Запрос - запрос, который использовался для расчета прав дескрипторов
//  Дескрипторы - Массив - массив дескрипторов, чьи права были рассчитаны
//  
Процедура ЗаполнитьПротоколРасчетаПрав(ПротоколРасчетаПрав, ЗапросПоПравам) Экспорт
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьПротоколРасчетаПрав(ПротоколРасчетаПрав, ЗапросПоПравам);
	
КонецПроцедуры

// Проверяет наличие метода.
// 
Функция ЕстьМетодПолучитьПраваПоФайлам() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает права доступа пользователей к переданным файлам.
// 
Функция ПолучитьПраваПоФайлам(Файлы, Пользователи = Неопределено) Экспорт
	
	Возврат БизнесПроцессыИЗадачиСервер.ПолучитьПраваПоФайлам(Файлы, Пользователи);
	
КонецФункции

// Конец УправлениеДоступом

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача 
//   ТочкаМаршрутаСсылка – точка маршрута 
//
// Возвращаемое значение:
//   Структура   – структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаСсылка) Экспорт
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Неправильный тип параметра ЗадачаСсылка (передан: %1)'"),
		ТипЗнч(ЗадачаСсылка));
	
	ВызватьИсключение ТекстСообщения;
	
КонецФункции

Функция ПроверитьШаблон(СтруктураРеквизитов) Экспорт
	
	Ошибки = Новый СписокЗначений;
	
	Если ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонРассмотрения"])
	   И ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонИсполненияОзнакомления"]) Тогда 
		Ошибки.Добавить("ШаблонИсполненияОзнакомления", НСтр("ru = 'Не требуется указывать шаблон исполнения (ознакомления), так как заполнен шаблон рассмотрения'"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонРассмотрения"])
	   И Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонИсполненияОзнакомления"]) Тогда 
		Ошибки.Добавить("", НСтр("ru = 'Укажите шаблон рассмотрения или шаблон исполнения (ознакомления)'"));
	КонецЕсли;	
	
	Возврат Ошибки;
	
КонецФункции	

// Возвращает массив пользователей переданного бизнес-процесса,
// которые должны иметь иметь права на другие бизнес-процессы, 
// для которых данный бизнес-процесс является ведущим
Функция ПользователиВедущегоБизнесПроцесса(ВедущийБизнесПроцесс) Экспорт
	
	МассивПользователей = Новый Массив;
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВедущийБизнесПроцесс, "Автор");
	Если ЗначениеЗаполнено(Реквизиты.Автор) Тогда
		МассивПользователей.Добавить(Реквизиты.Автор);
	КонецЕсли;
	
	Возврат МассивПользователей;
	
КонецФункции

// Возвращает тип шаблона бизнес-процесса, соответствующего данному процессу
Функция ТипШаблона() Экспорт
	
	Возврат "Справочник.ШаблоныСоставныхБизнесПроцессов";
	
КонецФункции

// Показывает, может ли процесс запускаться через привычные интерфейсы
Функция МожетЗапускатьсяИнтерактивно() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает текстовое описание назначения процесса
Функция ПолучитьОписаниеПроцесса() Экспорт
	
	Возврат НСтр("ru = 'Описывает процедуру обработки входящего документа по заранее определенным правилам.'");
	
КонецФункции

// Проверяет, что процесс завершился удачно
Функция ПроцессЗавершилсяУдачно(Ссылка) Экспорт
	
	Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Завершен");
	Если Результат Тогда
		ЗадачиПроцесса = РаботаСБизнесПроцессами.ПолучитьМассивЗадачПоБизнесПроцессу(Ссылка, Истина);
		Для Каждого Задача Из ЗадачиПроцесса Цикл
			ПроцессыПоЗадаче = РаботаСБизнесПроцессами.ПолучитьПодчиненныеЗадачеБизнесПроцессы(Задача.Ссылка, "ВедущаяЗадача", Истина);
			Для Каждого Процесс Из ПроцессыПоЗадаче Цикл
				МенеджерПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Процесс);
				Результат = Результат И МенеджерПроцесса.ПроцессЗавершилсяУдачно(Процесс);
				Если НЕ Результат Тогда
					Возврат Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак наличия метода РезультатВыполненияПроцесса
Функция ЕстьМетодРезультатВыполненияПроцесса() Экспорт
	Возврат Истина;
КонецФункции

// Возвращает результат выполнения - значение перечисления ВариантыВыполненияПроцессовИЗадач
Функция РезультатВыполненияПроцесса(Ссылка) Экспорт
	
	ЗавершилсяУдачно = ПроцессЗавершилсяУдачно(Ссылка);
	
	Если ЗавершилсяУдачно Тогда
		Возврат Перечисления.ВариантыВыполненияПроцессовИЗадач.Положительно;
	Иначе
		Возврат Перечисления.ВариантыВыполненияПроцессовИЗадач.Отрицательно;
	КонецЕсли;
	
КонецФункции

// Возвращает массив пользователей переданного бизнес-процесса,
// которые должны иметь иметь права на другие бизнес-процессы, 
// для которых данный бизнес-процесс является ведущим
Функция УчастникиПроцессаВлияющиеНаДоступКПодчиненнымОбъектам(Процесс) Экспорт
	
	МассивПользователей = Новый Массив;
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Процесс, "Автор, Проект");
	Если ЗначениеЗаполнено(Реквизиты.Автор) Тогда
		ДанныеУчастника = Новый Структура(
			"Участник");
		ДанныеУчастника.Участник = Реквизиты.Автор;
		МассивПользователей.Добавить(ДанныеУчастника);
	КонецЕсли;
	
	// Добавление руководителя проекта
	Если ЗначениеЗаполнено(Реквизиты.Проект) Тогда
		
		РуководительПроекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Проект, "Руководитель");
		Если ЗначениеЗаполнено(РуководительПроекта) Тогда
			
			ДанныеУчастника = Новый Структура(
				"Участник");
			ДанныеУчастника.Участник = РуководительПроекта;
			
			МассивПользователей.Добавить(ДанныеУчастника);
			
		КонецЕсли;	
			
	КонецЕсли;	
	
	Возврат МассивПользователей;
	
КонецФункции

// Возвращает массив всех участников процесса 
Функция ВсеУчастникиПроцесса(ПроцессСсылка) Экспорт
	
	ВсеУчастники = Новый Массив;
	
	// Автор
	Автор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроцессСсылка, "Автор");
	ДанныеУчастника = Новый Структура;
	ДанныеУчастника.Вставить("Участник", Автор);
	ВсеУчастники.Добавить(ДанныеУчастника);

	Возврат ВсеУчастники;
	
КонецФункции

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает массив структур, содержащих описания участников.
// Состав структуры:
//   ТабличнаяЧасть - имя ТЧ, в которой хранятся данные участников. Если данные хранятся в шапке, этот ключ отсутствует.
//   ИмяУчастника - имя реквизита шапки или ТЧ, в котором хранится ссылка на участника.
//   ВлияетНаДоступКПодчиненнымОбъектам - признак, указывающий на необходимость пересчета прав 
//   задач и дочерних процессов при изменении данного участника.
//
Функция ЗаполнитьОписанияУчастников() Экспорт
	
	МассивОписанийУчастников = Новый Массив;
	
	// Автор
	МассивОписанийУчастников.Добавить(Новый Структура(
		"ИмяУчастника,
		|ВлияетНаДоступКПодчиненнымОбъектам", 
		"Автор",
		Истина));
		
	// Проект
	МассивОписанийУчастников.Добавить(Новый Структура(
		"ИмяУчастника,
		|ВлияетНаДоступКПодчиненнымОбъектам",
		"Проект",
		Ложь));
		
	Возврат МассивОписанийУчастников;
		
КонецФункции

// Возвращает текст компенсации предмета, показываемый пользователю при прерывании
// бизнес-процесса.
//
Функция ТекстКомпенсацииПредмета(ПроцессСсылка) Экспорт
	
	Возврат "";

КонецФункции

// Возвращает доступные для процесса роли предметов
Функция ПолучитьДоступныеРолиПредметов() Экспорт
	
	РолиПредметов = Новый Массив;
	
	РолиПредметов.Добавить(Перечисления.РолиПредметов.Основной);
	РолиПредметов.Добавить(Перечисления.РолиПредметов.Вспомогательный);
	
	Возврат РолиПредметов;
	
КонецФункции

// Возвращает массив доступных типов основных предметов
Функция ПолучитьТипыОсновныхПредметов() Экспорт
	
	ТипыПредметов = Новый Массив;
	
	ТипыПредметов.Добавить(Тип("СправочникСсылка.ВходящиеДокументы"));
	
	Возврат ТипыПредметов;
	
КонецФункции

#КонецЕсли
