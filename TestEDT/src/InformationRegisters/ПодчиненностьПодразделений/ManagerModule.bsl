#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обновляет данные о подчиненных для указанного вышестоящего подразделения.
//
// Параметры:
//   Вышестоящее - СправочникСсылка.Подразделения - вышестоящее подразделение.
//
Процедура ОбновитьДанныеВышестоящегоПодразделения(Знач Вышестоящее) Экспорт
	
	Если Не ЗначениеЗаполнено(Вышестоящее) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	Ссылка В ИЕРАРХИИ(&Подразделение)
		|");
		
	Пока ЗначениеЗаполнено(Вышестоящее) Цикл
		
		НаборЗаписей = РегистрыСведений.ПодчиненностьПодразделений.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Вышестоящее.Установить(Вышестоящее);
		
		Запрос.УстановитьПараметр("Подразделение", Вышестоящее);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Вышестоящее = Вышестоящее;
			НоваяЗапись.Подчиненное = Выборка.Ссылка;
			
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
		Вышестоящее = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Вышестоящее, "Родитель");
		
	КонецЦикла;
	
КонецПроцедуры

// Обновляет все данные регистра.
//
Процедура ОбновитьДанныеПолностью() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ИТОГИ ПО
		|	Ссылка ИЕРАРХИЯ
		|");
		
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Подчиненное");
	Таблица.Колонки.Добавить("Вышестоящее");
	
	Вышестоящие = Новый Массив;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "Ссылка");
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Вышестоящее = Выборка.Ссылка;
		НоваяСтрока.Подчиненное = Выборка.Ссылка;
		
		ОбработатьВложеннуюВыборку(Выборка, Таблица, Вышестоящие);
		
	КонецЦикла;
	
	Таблица.Свернуть("Подчиненное, Вышестоящее");
	
	НаборЗаписей = РегистрыСведений.ПодчиненностьПодразделений.СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(Таблица);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Создает запись для самого подразделения (Вышестоящее = Подчиненное).
//
Процедура СоздатьТривиальнуюЗапись(Подразделение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.ПодчиненностьПодразделений.СоздатьМенеджерЗаписи();
	Запись.Вышестоящее = Подразделение;
	Запись.Подчиненное = Подразделение;
	Запись.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьВложеннуюВыборку(Выборка, Таблица, Вышестоящие, Знач ОграничениеРекурсии = 20)
	
	Если ОграничениеРекурсии = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Зацикливание при обновлении сведений о подчиненности подразделений.
			|Возможно, нарушена структура справочника ""Структура предприятия"".'");
	КонецЕсли;
	
	Вышестоящие.Добавить(Выборка.Ссылка);
		
	ВложеннаяВыборка = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "Ссылка");
	Пока ВложеннаяВыборка.Следующий() Цикл
		
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Вышестоящее = ВложеннаяВыборка.Ссылка;
		НоваяСтрока.Подчиненное = ВложеннаяВыборка.Ссылка;
		
		Для Каждого Вышестоящее Из Вышестоящие Цикл
			НоваяСтрока = Таблица.Добавить();
			НоваяСтрока.Подчиненное = ВложеннаяВыборка.Ссылка;
			НоваяСтрока.Вышестоящее = Вышестоящее;
		КонецЦикла;
		
		ОбработатьВложеннуюВыборку(ВложеннаяВыборка, Таблица, Вышестоящие, ОграничениеРекурсии - 1);
		
	КонецЦикла;
	
	Вышестоящие.Удалить(Вышестоящие.Количество() - 1);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли