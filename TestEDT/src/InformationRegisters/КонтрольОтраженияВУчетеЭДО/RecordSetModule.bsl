////////////////////////////////////////////////////////////////////////////////
// Модуль набора записей регистра сведений КонтрольОтраженияВУчетеЭДО
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НаУдаление = Новый Массив;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Не (Запись.СоздатьУчетныйДокумент ИЛИ Запись.ПровестиУчетныйДокумент) Тогда
			Запись.СопоставитьНоменклатуру = Ложь;
		КонецЕсли;
		
		Если Не (Запись.СопоставитьНоменклатуру
			ИЛИ Запись.СоздатьУчетныйДокумент
			ИЛИ Запись.ПровестиУчетныйДокумент) Тогда
				
			НаУдаление.Добавить(Запись);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Запись Из НаУдаление Цикл
		
		Удалить(Запись);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли