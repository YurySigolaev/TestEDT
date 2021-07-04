#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура-обработчик события ПриКомпоновкеРезультата. Устанавливает цвета диаграмм.
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрСчитатьДниОтсутствия = Настройки.ПараметрыДанных.Элементы.Найти("СчитатьДниОтсутствия");
	ПараметрПериод = Настройки.ПараметрыДанных.Элементы.Найти("Период");
	ПараметрПодразделениеДней = Настройки.ПараметрыДанных.Элементы.Найти("ПодразделениеДней");
	
	// Макет компоновки.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	// Внешние наборы данных.
	ТаблицаДниОтсутствия = Новый ТаблицаЗначений;
	ТаблицаДниОтсутствия.Колонки.Добавить("ПодразделениеДней");
	ТаблицаДниОтсутствия.Колонки.Добавить("СотрудникДней");
	ТаблицаДниОтсутствия.Колонки.Добавить("РабочихДней");
	ТаблицаДниОтсутствия.Колонки.Добавить("РаботалВОбычномРежиме");
	ТаблицаДниОтсутствия.Колонки.Добавить("РаботалУдаленно");
	ТаблицаДниОтсутствия.Колонки.Добавить("Отсутсвовал");
	Если ПараметрСчитатьДниОтсутствия.Значение Тогда
		
		ПользователиОтбора = ?(ПараметрПодразделениеДней.Использование,
			РаботаСПользователями.ПолучитьПользователейПодразделения(ПараметрПодразделениеДней.Значение, Истина, Истина),
			РаботаСПользователями.ПолучитьВсехПользователей());
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	СведенияОПользователяхДокументооборот.Пользователь КАК Пользователь,
			|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение
			|ИЗ
			|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
			|ГДЕ
			|	СведенияОПользователяхДокументооборот.Пользователь В(&ПользователиОтбора)");
		
		Запрос.УстановитьПараметр("ПользователиОтбора", ПользователиОтбора);
		
		НастройкиПроверкиОтсутствий = ОтсутствияКлиентСервер.НастройкиПроверкиОтсутствий();
		НастройкиПроверкиОтсутствий.УчитыватьФлагБудуРазбиратьЗадачи = Ложь;
		
		РабочиеДниПоГрафикам = Новый Соответствие;
		ПризнакиЭтоУдаленнаяРабота = Новый Соответствие;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(Выборка.Подразделение) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрокаДниОтсутствия = ТаблицаДниОтсутствия.Добавить();
			СтрокаДниОтсутствия.СотрудникДней = Выборка.Пользователь;
			СтрокаДниОтсутствия.ПодразделениеДней = Выборка.Подразделение;
			
			ГрафикРаботыСотрудника = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Выборка.Пользователь);
			Если ЗначениеЗаполнено(ГрафикРаботыСотрудника) Тогда
				Если РабочиеДниПоГрафикам[ГрафикРаботыСотрудника] = Неопределено Тогда
					РабочиеДниПоГрафикам[ГрафикРаботыСотрудника] = Новый Соответствие;
				КонецЕсли;
				РабочиеДниГрафика = РабочиеДниПоГрафикам[ГрафикРаботыСотрудника];
			Иначе
				РабочиеДниГрафика = Новый Соответствие;
			КонецЕсли;
			
			СекундВДне = 86400;
			СтрокаДниОтсутствия.РабочихДней = 0;
			СтрокаДниОтсутствия.РаботалВОбычномРежиме = 0;
			СтрокаДниОтсутствия.РаботалУдаленно = 0;
			СтрокаДниОтсутствия.Отсутсвовал = 0;
			ПроверяемаяДата = ПараметрПериод.Значение.ДатаНачала;
			Пока ПроверяемаяДата < ПараметрПериод.Значение.ДатаОкончания Цикл
				
				Если ЗначениеЗаполнено(ГрафикРаботыСотрудника) Тогда
					
					Если РабочиеДниГрафика[ПроверяемаяДата] = Неопределено Тогда
						РабочиеДниГрафика[ПроверяемаяДата] = ГрафикиРаботы.ЭтоРабочийДень(ПроверяемаяДата, ГрафикРаботыСотрудника);
					КонецЕсли;
					ЭтоРабочийДень = РабочиеДниГрафика[ПроверяемаяДата];
					
					Если Не ЭтоРабочийДень Тогда
						ПроверяемаяДата = ПроверяемаяДата + СекундВДне;
						Продолжить;
					КонецЕсли;
					
				КонецЕсли;
				
				ЕстьУдаленнаяРабота = Ложь;
				ЕстьОтсутствие = Ложь;
				ТаблицаОтсутствий = Отсутствия.ПолучитьТаблицуОтсутствий(
					НачалоДня(ПроверяемаяДата),
					КонецДня(ПроверяемаяДата),
					Выборка.Пользователь,
					НастройкиПроверкиОтсутствий);
				Для Каждого ДанныеОтсутствия Из ТаблицаОтсутствий Цикл
					
					Если Не ЗначениеЗаполнено(ДанныеОтсутствия.ВидОтсутствия) Тогда
						ЕстьОтсутствие = Истина;
						Продолжить;
					КонецЕсли;
					
					Если ПризнакиЭтоУдаленнаяРабота[ДанныеОтсутствия.ВидОтсутствия] = Неопределено Тогда
						ПризнакиЭтоУдаленнаяРабота[ДанныеОтсутствия.ВидОтсутствия] =
							ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
								ДанныеОтсутствия.ВидОтсутствия,
								"ЭтоУдаленнаяРабота");
						Если ПризнакиЭтоУдаленнаяРабота[ДанныеОтсутствия.ВидОтсутствия] = Неопределено Тогда
							ПризнакиЭтоУдаленнаяРабота[ДанныеОтсутствия.ВидОтсутствия] = Ложь;
						КонецЕсли;
					КонецЕсли;
					ЭтоУдаленнаяРабота = ПризнакиЭтоУдаленнаяРабота[ДанныеОтсутствия.ВидОтсутствия];
					
					Если ЭтоУдаленнаяРабота Тогда
						ЕстьУдаленнаяРабота = Истина;
					Иначе
						ЕстьОтсутствие = Истина;
					КонецЕсли;
					
				КонецЦикла;
				
				СтрокаДниОтсутствия.РабочихДней = СтрокаДниОтсутствия.РабочихДней + 1;
				Если ЕстьОтсутствие Тогда
					СтрокаДниОтсутствия.Отсутсвовал = СтрокаДниОтсутствия.Отсутсвовал + 1;
				ИначеЕсли ЕстьУдаленнаяРабота Тогда
					СтрокаДниОтсутствия.РаботалУдаленно = СтрокаДниОтсутствия.РаботалУдаленно + 1;
				Иначе
					СтрокаДниОтсутствия.РаботалВОбычномРежиме = СтрокаДниОтсутствия.РаботалВОбычномРежиме + 1;
				КонецЕсли;
				
				ПроверяемаяДата = ПроверяемаяДата + СекундВДне;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	ВнешниеНаборыДанных = Новый Структура("ДниОтсутствия", ТаблицаДниОтсутствия);
	
	// Процессор компоновки.
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	// Вывод результата.
	ДокументРезультат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ОбщегоНазначенияДокументооборот.УстановитьЦветаДиаграмм(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли