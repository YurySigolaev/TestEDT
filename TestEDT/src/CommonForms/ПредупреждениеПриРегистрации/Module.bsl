
&НаКлиенте
Процедура Зарегистрировать(Команда)
	
	Если БольшеНеСпрашивать Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("НастройкиРаботыСДокументами",
			"ПоказыватьПредупреждениеПриРегистрации", Ложь);
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	Закрыть(КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Нет);
	
КонецПроцедуры
