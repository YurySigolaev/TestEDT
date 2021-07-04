
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ТекущаяПапка") Тогда
		Элементы.Список.ТекущаяСтрока = Параметры.ТекущаяПапка;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		Элементы.Список.Развернуть(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры
