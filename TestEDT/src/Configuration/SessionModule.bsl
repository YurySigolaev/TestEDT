///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
	
	// ТехнологияСервиса
	ТехнологияСервиса.ВыполнитьДействияПриУстановкеПараметровСеанса(ИменаПараметровСеанса);
	// Конец ТехнологияСервиса
	
	Если ИменаПараметровСеанса = Неопределено
		Или ИменаПараметровСеанса.Найти("ДокументооборотИспользоватьОграниченияПравДоступа") <> Неопределено Тогда
		
		Если ОбщегоНазначения.РазделениеВыключено() Тогда
			ПараметрыСеанса.ДокументооборотИспользоватьОграниченияПравДоступа = Ложь;
		Иначе
			ПараметрыСеанса.ДокументооборотИспользоватьОграниченияПравДоступа = 
				Константы.ДокументооборотИспользоватьОграничениеПравДоступа.Получить()
				Или Константы.ДокументооборотВключитьПраваДоступа.Получить();
		КонецЕсли;
			
	КонецЕсли;
	
	Если ИменаПараметровСеанса = Неопределено
		Или ИменаПараметровСеанса.Найти("ПриоритетОчередиОбновленияПрав") <> Неопределено Тогда
		
		ПараметрыСеанса.ПриоритетОчередиОбновленияПрав = 1;
		
	КонецЕсли;
	
	// Проверка разрешения доступа через веб-сервер
	// Если доступ через веб-серверы никак не ограничивается, то
	// проверка не выполняется
	Если Не ОбщегоНазначения.РазделениеВыключено()
		И Константы.ОграничиватьДоступЧерезВебСерверы.Получить() И ИменаПараметровСеанса = Неопределено Тогда
	
		ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь(); 
		
		// Нахождение текущего соединения
		НомерСоединения = НомерСоединенияИнформационнойБазы();
		ТекущееСоединение = Неопределено;
		СоединенияИнформационнойБазы = ПолучитьСоединенияИнформационнойБазы();
		Для Каждого СоединениеИБ Из СоединенияИнформационнойБазы Цикл
			Если СоединениеИБ.НомерСоединения = НомерСоединения Тогда
				ТекущееСоединение = СоединениеИБ;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		// Если текущее соединение выполнено через веб-сервер, то выполняется 
		// проверка разрешения
		Если ТекущееСоединение.ИмяПриложения = "WebServerExtension" Тогда
			
			// Поиск сведений о разрешении подключения через веб-сервер
			ИмяВебСервера = ТекущееСоединение.ИмяКомпьютера;
			
			// Проверка списка разрешенных веб-серверов
			ТекущийПользователь = Пользователи.ТекущийПользователь();
			Если Найти(НРег(ТекущийПользователь.РазрешенныеВебСерверы), НРег(ИмяВебСервера)) = 0 Тогда
				
				// Отказ в доступе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	 				НСтр("ru = 'Вам не разрешен доступ к программе через веб-сервер %1. 
					|Обратитесь к администратору.'"),
					ИмяВебСервера);
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Подключение через веб-сервер'"), УровеньЖурналаРегистрации.Ошибка,
					, , ТекстСообщения);

				ВызватьИсключение ТекстСообщения;
				
			КонецЕсли;	
			
			// Проверка на пустой пароль
			Если Не ТекущийПользовательИБ.ПарольУстановлен Тогда
				
				// Отказ в доступе
				ТекстСообщения = НСтр("ru = 'Доступ к программе через веб-сервер не разрешен для пользователей без пароля. 
					|Обратитесь к администратору.'");
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Подключение через веб-сервер'"), УровеньЖурналаРегистрации.Ошибка,
					, , ТекстСообщения);
				ВызватьИсключение ТекстСообщения;	
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; // Проверка разрешения доступа через веб-сервер
	
	// Интеграция
	ОбработкаЗапросовXDTO.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец Интеграция
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли