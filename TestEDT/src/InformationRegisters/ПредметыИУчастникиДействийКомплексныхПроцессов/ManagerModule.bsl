#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет записи по действия в регистре.
// Существующие записи замещаются.
//
// Параметры:
//  Действие - СправочникОбъект<ИмяШаблонаПроцесса>
//             СправочникСсылка<ИмяШаблонаПроцесса> - служебный шаблон комплексного процесса.
//
Процедура ДобавитьЗаписиПоДействию(Действие) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Действие)) Тогда
		РеквизитыДействия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Действие, "Ссылка, КомплексныйПроцесс, Предметы");
		РеквизитыДействия.Предметы = РеквизитыДействия.Предметы.Выгрузить();
	Иначе
		РеквизитыДействия = Действие;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РеквизитыДействия.Ссылка)
		Или Не ЗначениеЗаполнено(РеквизитыДействия.КомплексныйПроцесс) Тогда
		
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ШаблонДействия.Установить(РеквизитыДействия.Ссылка);
	
	ТаблицаЗаписей = НаборЗаписей.ВыгрузитьКолонки();
	
	МенеджерДействия = ОбщегоНазначения.МенеджерОбъектаПоСсылке(РеквизитыДействия.Ссылка);
	УчастникиДействия = МенеджерДействия.УчастникиДляПроверкиПрав(Действие);
	
	Для Каждого СтрУчастник Из УчастникиДействия Цикл
		Для Каждого СтрПредмет Из РеквизитыДействия.Предметы Цикл
			Запись = ТаблицаЗаписей.Добавить();
			Запись.ИмяПредмета = СтрПредмет.ИмяПредмета;
			Запись.Участник = СтрУчастник.Участник;
			Запись.ШаблонДействия = РеквизитыДействия.Ссылка;
			Запись.Изменение = СтрУчастник.Изменение;
			Запись.КомплексныйПроцесс = РеквизитыДействия.КомплексныйПроцесс;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаЗаписей.Свернуть("ИмяПредмета, Участник, ШаблонДействия, КомплексныйПроцесс", "Изменение");
	
	НаборЗаписей.Загрузить(ТаблицаЗаписей);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Удаляет записи действия в регистре.
//
// Параметры:
//  Действие  - СправочникСсылка<ИмяШаблонаПроцесса> - служебный шаблон комплексного процесса.
//
Процедура УдалитьЗаписиДействия(Действие) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЗначениеЗаполнено(Действие) Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ШаблонДействия.Установить(Действие.Ссылка);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
