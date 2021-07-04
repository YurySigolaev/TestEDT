#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПриСозданииНаСервереРедакцииКонфигурации();	
	
	ЧислоДокументов = Параметры.ЧислоДокументовБезОрганизации;
	Если ЧислоДокументов % 10 = 1
		И ЧислоДокументов <> 11 Тогда
		ЧислоДокументовСтрокой = СтрШаблон(НСтр("ru = '%1 документа'"), ЧислоДокументов);
	Иначе
		ЧислоДокументовСтрокой = СтрШаблон(НСтр("ru = '%1 документов'"), ЧислоДокументов);
	КонецЕсли;
	
	Элементы.ДекорацияВопрос.Заголовок = СтрШаблон(
		Элементы.ДекорацияВопрос.Заголовок,
		ЧислоДокументов);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назначить(Команда)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Закрыть(Организация);
	Иначе
		Элементы.Организация.ОтметкаНезаполненного = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите организацию.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеНазначать(Команда)
	
	Закрыть(КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()	
	
	Элементы.Организация.ПодсказкаВвода = РедакцииКонфигурацииКлиентСервер.Организация();
	Элементы.ДекорацияВопрос.Заголовок = РедакцииКонфигурацииКлиентСервер.НазначениеОрганизацииПодсказкаВвода();
		
КонецПроцедуры

#КонецОбласти