#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Схема = Отчеты.ПланФактныйАнализСогласования.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	СписокВыбора = Элементы.ПредставлениеВарианта.СписокВыбора;
	Для каждого Вариант из Схема.ВариантыНастроек Цикл
		СписокВыбора.Добавить(Вариант.Имя, Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеНастроек_ПланФактныйАнализСогласования" Тогда
		Элементы.ГруппаПользовательскиеНастройки.Видимость = Параметр;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Свойство("ПоказыватьБыстрыеНастройки", ПоказыватьБыстрыеНастройки);
	Элементы.ГруппаПользовательскиеНастройки.Видимость = ПоказыватьБыстрыеНастройки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеВариантаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбранныйЭлементСписка = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение);
	ПредставлениеВарианта = ВыбранныйЭлементСписка.Представление;
	УстановитьТекущийВариант(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти