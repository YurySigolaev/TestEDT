
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДанныеЗаявки(Знач ДополнительныеПараметры, ДанныеЗаявки) Экспорт
	
	СертификатКриптографии   = ДополнительныеПараметры.Сертификат;
	АдресОрганизацииЗначение = ДополнительныеПараметры.АдресОрганизацииЗначение;
		
	ПараметрыСертификата = КриптографияБЭД.СвойстваСертификатов(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СертификатКриптографии))[СертификатКриптографии];
	Ответ = ИнтеграцияБСПБЭД.СведенияОбАдресеПоЗначению(АдресОрганизацииЗначение);
	
	Если НЕ ЗначениеЗаполнено(Ответ.Город) Тогда
		Ответ.Город = Ответ.Регион;
	КонецЕсли;
	
	ДанныеЗаявки.КодНалоговогоОргана = ДополнительныеПараметры.КодНалоговогоОргана;
	
	ЗаполнитьЗначенияСвойств(ДанныеЗаявки, Ответ);
	ЗаполнитьЗначенияСвойств(ДанныеЗаявки, ПараметрыСертификата, "Фамилия, Имя, Отчество");
	
КонецПроцедуры

Функция НачатьУдалениеУчетнойЗаписи(ИдентификаторУчетнойЗаписи, ИдентификаторФормы) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Удаление учетной записи электронного документооборота'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "УчетныеЗаписиЭДОСлужебный.УдалитьУчетнуюЗапись",
		ИдентификаторУчетнойЗаписи);
	
КонецФункции

#КонецОбласти