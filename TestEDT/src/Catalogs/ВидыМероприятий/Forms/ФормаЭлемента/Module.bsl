#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Куратор.Доступность = Объект.ВедетКуратор;
	
	// Видимость команды "Политики доступа".
	Если Элементы.Найти("ФормаПолитикиДоступа") <> Неопределено Тогда
		ОтключенныеРазрезы = ДокументооборотПраваДоступаПовтИсп.ОтключенныеРазрезыДоступа(Ложь);
		Если ОтключенныеРазрезы.Найти(ПланыВидовХарактеристик.ВидыДоступа.ВидыМероприятий) <> Неопределено Тогда
			Элементы.ФормаПолитикиДоступа.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВедетКураторПриИзменении(Элемент)
	
	Элементы.Куратор.Доступность = Объект.ВедетКуратор;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтаФорма,
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаборСвойств(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьНаборСвойствПродолжение",
		ЭтотОбъект);

	Если Объект.Ссылка.Пустая() Тогда
		ТекстВопроса = НСтр("ru = 'Для перехода к набору свойств элемент необходимо записать.'")
			+ Символы.ПС + НСтр("ru = 'Записать?'");
		ОбщегоНазначенияДокументооборотКлиент.ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаборСвойствПродолжение(Результат, Параметры) Экспорт 

	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "НаборыДополнительныхРеквизитов");
	
	ОткрытьФорму("Справочник.НаборыДополнительныхРеквизитовИСведений.ФормаСписка", ПараметрыФормы);
	
	ПараметрыПерехода = Новый Структура;
	ПараметрыПерехода.Вставить("Набор", Объект.НаборСвойств);
	ПараметрыПерехода.Вставить("Свойство", Неопределено);
	ПараметрыПерехода.Вставить("ЭтоДополнительноеСведение", Ложь);
	
	Оповестить("Переход_НаборыДополнительныхРеквизитовИСведений", ПараметрыПерехода);
	
КонецПроцедуры

#КонецОбласти