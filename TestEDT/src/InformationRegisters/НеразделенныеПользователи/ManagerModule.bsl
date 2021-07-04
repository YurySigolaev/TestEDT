///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает максимальный порядковый номер неразделенного пользователя в информационной базе.
//
// Возвращаемое значение:
//  Число
Функция МаксимальныйПорядковыйНомер() Экспорт
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ЕСТЬNULL(МАКСИМУМ(НеразделенныеПользователи.ПорядковыйНомер), 0) КАК ПорядковыйНомер
	               |ИЗ
	               |	РегистрСведений.НеразделенныеПользователи КАК НеразделенныеПользователи";
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПорядковыйНомер;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

// Возвращает порядковый номер неразделенного пользователя информационной базы
//
// Параметры:
//  Идентификатор - уникальный идентификатор пользователя информационной базы.
//
// Возвращаемое значение:
//  Число
Функция ПорядковыйНомерПользователяИБ(Идентификатор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПользователяИБ", Идентификатор);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НеразделенныеПользователи.ПорядковыйНомер КАК ПорядковыйНомер
	|ИЗ
	|	РегистрСведений.НеразделенныеПользователи КАК НеразделенныеПользователи
	|ГДЕ
	|	НеразделенныеПользователи.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПорядковыйНомер;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Возвращает список неразделенных администраторов
//
// Возвращаемое значение:
//   СписокЗначений   – список уникальных идентификаторов с представлениями (имена пользователей)
//
Функция СписокАдминистраторов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НеразделенныеПользователи.ИдентификаторПользователяИБ
		|ИЗ
		|	РегистрСведений.НеразделенныеПользователи КАК НеразделенныеПользователи";
	Выборка = Запрос.Выполнить().Выбрать();
	СписокАдминистраторов = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
			Выборка.ИдентификаторПользователяИБ);
		Если ПользовательИБ = Неопределено Тогда
			Продолжить;
		КонецЕсли;		
		ЕстьРоли = Ложь;
		Для Каждого РольПользователя Из ПользовательИБ.Роли Цикл
			ЕстьРоли = Истина;
			Прервать;
		КонецЦикла;
		Если Не ЕстьРоли Тогда
			Продолжить;
		КонецЕсли;
		Если Не Пользователи.ЭтоПолноправныйПользователь(ПользовательИБ, Истина) Тогда
			Продолжить;
		КонецЕсли;
		СписокАдминистраторов.Добавить(Выборка.ИдентификаторПользователяИБ, ПользовательИБ.Имя);
	КонецЦикла;
	СписокАдминистраторов.СортироватьПоПредставлению();
	Возврат СписокАдминистраторов;
	
КонецФункции

#КонецЕсли