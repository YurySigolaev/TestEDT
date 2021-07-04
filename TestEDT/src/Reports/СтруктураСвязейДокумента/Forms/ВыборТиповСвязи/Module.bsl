
&НаКлиенте
Процедура ОК(Команда)
	
	ВыбранныеТипыСвязей = Новый СписокЗначений;
	Для Каждого Строка Из ТипыСвязей Цикл
		Если Строка.Пометка Тогда 
			ВыбранныеТипыСвязей.Добавить(Строка.Значение);
		КонецЕсли;
	КонецЦикла;	
	
	Закрыть(ВыбранныеТипыСвязей);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СвязиДокументов.ТипСвязи,
	|	СвязиДокументов.ДатаУстановки
	|ИЗ
	|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
	|ГДЕ
	|	СвязиДокументов.Документ = &Документ";
	Запрос.УстановитьПараметр("Документ", Параметры.Документ);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Свернуть("ТипСвязи");
	
	ВыбранныеТипыСвязей = Параметры.ВыбранныеТипыСвязей;
	Для Каждого Строка Из Результат Цикл 
		Пометка = (ВыбранныеТипыСвязей.НайтиПоЗначению(Строка.ТипСвязи) <> Неопределено);
		ТипыСвязей.Добавить(Строка.ТипСвязи,,Пометка);
	КонецЦикла;
	
КонецПроцедуры
