
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура") И Параметры.Отбор.Свойство("ВидДокумента") И ЗначениеЗаполнено(Параметры.Отбор.ВидДокумента) Тогда 
		Элементы.ВидДокумента.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Настройки доступности по состоянию'");
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура") И Параметры.Отбор.Свойство("НастройкаДоступностиПоСостоянию") И ЗначениеЗаполнено(Параметры.Отбор.НастройкаДоступностиПоСостоянию) Тогда 
		Элементы.НастройкаДоступностиПоСостоянию.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Назначен видам документов'");
	КонецЕсли;
	
КонецПроцедуры
