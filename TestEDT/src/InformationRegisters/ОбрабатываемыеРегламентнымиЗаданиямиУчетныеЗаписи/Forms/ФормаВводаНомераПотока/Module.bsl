
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НомерПотока = 1;
	
	МассивУчетныхЗаписей = Параметры.МассивУчетныхЗаписей;
	Количество = МассивУчетныхЗаписей.Количество();
	Количество_ЕдиницаИзмеренеия = 
		ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
			Количество,
			НСтр("ru = '-й учетной записи'") + "," + НСтр("ru = '-х учетных записей'") + "," + НСтр("ru = '-и учетных записей'"));
			
	ЭтаФорма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Изменение потока %1%2'"), Количество, Количество_ЕдиницаИзмеренеия);
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ОповеститьОВыборе(НомерПотока);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры
