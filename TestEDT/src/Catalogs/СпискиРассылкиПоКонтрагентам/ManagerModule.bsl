#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ссылка,
		|ГруппаДоступа,
		|Получатели";
	
КонецФункции

// Заполняет переданный дескриптор доступа
// 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	Если ЗначениеЗаполнено(ОбъектДоступа.ГруппаДоступа) Тогда
		Строка = ДескрипторДоступа.Контрагенты.Добавить();
		Строка.ГруппаДоступа = ОбъектДоступа.ГруппаДоступа;
	КонецЕсли;
	
	// Контрагенты
	ВсеКонтрагенты = ОбъектДоступа.Получатели.Выгрузить().ВыгрузитьКолонку("Получатель");
	ЗначенияГруппыДоступа = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ВсеКонтрагенты, "ГруппаДоступа");
	
	ДобавленныеГруппы = Новый Соответствие;
	Для Каждого КлючИЗначение Из ЗначенияГруппыДоступа Цикл
		ГруппаДоступа = КлючИЗначение.Значение;
		Если ЗначениеЗаполнено(ГруппаДоступа) И ДобавленныеГруппы.Получить(ГруппаДоступа) = Неопределено Тогда
			Строка = ДескрипторДоступа.Контрагенты.Добавить();
			Строка.ГруппаДоступа = ГруппаДоступа;
			ДобавленныеГруппы.Вставить(ГруппаДоступа, Истина);
		КонецЕсли;
	КонецЦикла;
	
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
	
	// Расчет по аналогии с разрезом доступа.
	// Если каждая из групп доступа контрагентов доступна на чтение в любом разрешении политик доступа,
	// элемент будет доступен на чтение.
	// Права на изменение определяются правами на чтение и ролями.
	
	Запрос = Справочники.ДескрипторыДоступаОбъектов.ЗапросДляСтандартногоРасчетаПрав(
		Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа, Ложь, Истина);
	Запрос.Текст = ДокументооборотПраваДоступаПовтИсп.ТекстЗапросаДляРасчетаПравРазрезаДоступа();
	
	Возврат Запрос;
	
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
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПротоколРасчетаПравСтандартно(
		ПротоколРасчетаПрав, ЗапросПоПравам);
	
КонецПроцедуры

#КонецЕсли
