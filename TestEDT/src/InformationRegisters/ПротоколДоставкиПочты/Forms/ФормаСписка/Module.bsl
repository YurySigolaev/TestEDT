
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("УчетнаяЗапись") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор,
			"УчетнаяЗапись",
			Параметры.УчетнаяЗапись);
			
		Элементы.УчетнаяЗапись.Видимость = Ложь;	
			
	КонецЕсли;	
		
КонецПроцедуры
