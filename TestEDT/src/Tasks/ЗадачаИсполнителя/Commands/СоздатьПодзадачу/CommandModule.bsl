
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	
	ПомощникОтправитьКлиент.ОтправитьПодзадачу(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
