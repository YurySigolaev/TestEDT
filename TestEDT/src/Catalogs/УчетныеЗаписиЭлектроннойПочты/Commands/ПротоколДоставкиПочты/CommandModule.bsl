
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("УчетнаяЗапись", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.ПротоколДоставкиПочты.ФормаСписка", ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
