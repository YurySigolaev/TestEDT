
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.Заголовок;
	
	Если ЗначениеЗаполнено(Параметры.ТекстСообщенияHTML) Тогда 
		
		ТекстСообщения.УстановитьHTML(Параметры.ТекстСообщения, Новый Структура);
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.ТекстСообщения) Тогда 
		
		Текст = Параметры.ТекстСообщения;
		Текст = СтрЗаменить(Текст, ">", "");
		Текст = СтрЗаменить(Текст, "<", "");
		
		ТекстСообщения.Добавить(Текст, ТипЭлементаФорматированногоДокумента.Текст);
		
	КонецЕсли;	
	
КонецПроцедуры
