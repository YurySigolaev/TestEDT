
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Начальное заполнение справочника.
//
Процедура ЗаполнитьРеквизитыПредопределенныхЭлементов() Экспорт
	
	Права = Новый Структура("Чтение", Истина);
	ЗаполнитьРеквизитыПредопределенногоЭлемента("Чтение", 1, Права);
	
	Права = Новый Структура("Чтение, Изменение, Добавление, Удаление",
		Истина, Истина, Истина, Истина);
	ЗаполнитьРеквизитыПредопределенногоЭлемента("Редактирование", 2, Права);
	
	Права = Новый Структура("Чтение, Изменение, Добавление, Удаление, Регистрация",
		Истина, Истина, Истина, Истина, Истина);
	ЗаполнитьРеквизитыПредопределенногоЭлемента("Регистрация", 3, Права);
	
	Права = Новый Структура("ЧтениеБезОграничения", Истина);
	ЗаполнитьРеквизитыПредопределенногоЭлемента("ЧтениеБезОграничения", 4, Права);

	Права = Новый Структура("ЧтениеБезОграничения, ИзменениеБезОграничения", Истина, Истина);
	ЗаполнитьРеквизитыПредопределенногоЭлемента("РедактированиеБезОграничения", 5, Права);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеквизитыПредопределенногоЭлемента(Имя, Приоритет, Права) Экспорт
	
	УровеньДоступаОбъект = Справочники.УровниДоступа[Имя].ПолучитьОбъект();
	УровеньДоступаОбъект.Приоритет = Приоритет;
	ЗаполнитьЗначенияСвойств(УровеньДоступаОбъект, Права);
	УровеньДоступаОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
