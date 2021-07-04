
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

#Если НЕ ВебКлиент Тогда
	ДанныеОШтрихкоде = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(ПараметрКоманды, Ложь);
	Если НЕ ДанныеОШтрихкоде.Свойство("СообщениеОбОшибке") Тогда
		ШтрихкодированиеКлиент.СохранитьИзображениеШК(ДанныеОШтрихкоде.ДвоичныеДанныеИзображения);	
	Иначе
		ТекстСообщения = ДанныеОШтрихкоде.СообщениеОбОшибке;
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
#Иначе
	ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте выполнение данной операции невозможно.'"));
#КонецЕсли

КонецПроцедуры
