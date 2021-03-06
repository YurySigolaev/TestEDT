#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Исполнитель) Тогда
		МассивПолей.Добавить("Исполнитель");
	КонецЕсли;
	
	ЗаполняемыеПредметы = Предметы.НайтиСтроки(Новый Структура("РольПредмета", Перечисления.РолиПредметов.Заполняемый));
	Для Каждого СтрокаПредмета Из ЗаполняемыеПредметы Цикл
		
		Отбор = Новый Структура("ИмяПредмета, ОбязательноеЗаполнение",СтрокаПредмета.ИмяПредмета, Истина);
		ТочкиЗаполнения = ПредметыЗадач.НайтиСтроки(Отбор);
		
		Для Каждого СтрокаТочки Из ТочкиЗаполнения Цикл
			
			Если СтрокаТочки.ТочкаМаршрута = БизнесПроцессы.Поручение.ТочкиМаршрута.Контролировать
				И Не ЗначениеЗаполнено(Контролер) Тогда
				
				МассивПолей.Добавить("Контролер");
				
			ИначеЕсли СтрокаТочки.ТочкаМаршрута = БизнесПроцессы.Поручение.ТочкиМаршрута.Проверить
				И Не ЗначениеЗаполнено(Проверяющий) Тогда
				
				МассивПолей.Добавить("Проверяющий");
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат МассивПолей;
	
КонецФункции	

//Формирует текстовое представление бизнес-процесса, создаваемого по шаблону
Функция СформироватьСводкуПоШаблону() Экспорт
	
	Результат = ШаблоныБизнесПроцессов.ПолучитьОбщуюЧастьОписанияШаблона(Ссылка);
		
	Если ЗначениеЗаполнено(НаименованиеБизнесПроцесса) Тогда
		Результат = Результат + НСтр("ru = 'Заголовок'") + ": " + НаименованиеБизнесПроцесса + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Описание) Тогда
		Результат = Результат + НСтр("ru = 'Описание'") + ": " + Описание + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Важность) Тогда
		Результат = Результат + НСтр("ru = 'Важность'") + ": " + Строка(Важность) + Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		Результат = Результат + Нстр("ru = 'Исполнитель'") + ": "
			+ Строка(Исполнитель)
			+ Символы.ПС;
	КонецЕсли;
			
	Если ЗначениеЗаполнено(Проверяющий) Тогда
		Результат = Результат + Нстр("ru = 'Проверяющий'") + ": "
			+ Строка(Проверяющий)
			+ Символы.ПС;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контролер) Тогда
		Результат = Результат + Нстр("ru = 'Контролер'") + ": "
			+ Строка(Контролер) + Символы.ПС;
	КонецЕсли;
	
	ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(ЭтотОбъект);
	ДлительностьПроцессаСтрокой = СрокиИсполненияПроцессовКлиентСервер.ПредставлениеДлительности(
		ДлительностьПроцесса.СрокИсполненияПроцессаДни,
		ДлительностьПроцесса.СрокИсполненияПроцессаЧасы,
		ДлительностьПроцесса.СрокИсполненияПроцессаМинуты);
		
	Если ЗначениеЗаполнено(ДлительностьПроцессаСтрокой) Тогда
		Результат = Результат + Нстр("ru = 'Срок'") + ": "
			+ ДлительностьПроцессаСтрокой;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_ПоддержкаМеханизмаОтсутствий

// Получает исполнителей
Функция ПолучитьИсполнителей() Экспорт
	
	МассивИсполнителей = Новый Массив;
	
	Если ЗначениеЗаполнено(Исполнитель) Тогда
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(Исполнитель);
		МассивИсполнителей.Добавить(ДанныеИсполнителя);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контролер) Тогда
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(Контролер);
		МассивИсполнителей.Добавить(ДанныеИсполнителя);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Проверяющий) Тогда
		ДанныеИсполнителя = ОтсутствияКлиентСервер.ПолучитьДанныеИсполнителя(Проверяющий);
		МассивИсполнителей.Добавить(ДанныеИсполнителя);
	КонецЕсли;
	
	Возврат МассивИсполнителей;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		ШаблоныБизнесПроцессов.НачальноеЗаполнениеШаблона(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблоныБизнесПроцессов.ШаблонПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли