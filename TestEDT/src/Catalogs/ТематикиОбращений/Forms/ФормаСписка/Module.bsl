
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);	
	
КонецПроцедуры

#КонецОбласти
