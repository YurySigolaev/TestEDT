#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Ссылка.Пустая() Тогда
		
		ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ТерриторииИПомещения.Ссылка,
				|	ТерриторииИПомещения.ПометкаУдаления
				|ИЗ
				|	Справочник.ТерриторииИПомещения КАК ТерриторииИПомещения
				|ГДЕ
				|	ТерриторииИПомещения.Ссылка В ИЕРАРХИИ(&Ссылка)
				|	И ТерриторииИПомещения.Ссылка <> &Ссылка
				|	И ТерриторииИПомещения.ПометкаУдаления <> &ПометкаУдаления
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ
				|	МестаХраненияДел.Ссылка,
				|	МестаХраненияДел.ПометкаУдаления
				|ИЗ
				|	Справочник.МестаХраненияДел КАК МестаХраненияДел
				|ГДЕ
				|	МестаХраненияДел.ТерриторияПомещение В ИЕРАРХИИ(&Ссылка)
				|	И МестаХраненияДел.ПометкаУдаления <> &ПометкаУдаления";
				
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				Объект = Выборка.Ссылка.ПолучитьОбъект();
				Объект.Заблокировать();
				Объект.УстановитьПометкуУдаления(ПометкаУдаления);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если БрониВводитОтветственный Тогда
		ПроверяемыеРеквизиты.Добавить("Ответственный");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
