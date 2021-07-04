
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ПустаяСсылкаПользователя = Справочники.Пользователи.ПустаяСсылка();
	
	Если Параметры.Свойство("ЭтоГруппаКонтактов") И Параметры.ЭтоГруппаКонтактов Тогда
		
		ЭтоГруппаКонтактов = Параметры.ЭтоГруппаКонтактов;
		Если Параметры.Свойство("Родитель")
			И ЗначениеЗаполнено(Параметры.Родитель)
			И ТипЗнч(Параметры.Родитель) = Тип("СправочникСсылка.ГруппыКонтактовПользователей") Тогда
			
			Объект.Родитель = Параметры.Родитель;
		Иначе
			Объект.Родитель = Справочники.ГруппыКонтактовПользователей.ПолучитьКорневуюГруппу();
		КонецЕсли;
		
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Автор = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;	
	
	Элементы.ГруппаДоступ.Доступность = Объект.ОбщийСписокРассылки;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не Объект.ОбщийСписокРассылки Тогда
		Объект.Пользователи.Очистить();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщийСписокРассылкиПриИзменении(Элемент)
	
	Элементы.ГруппаДоступ.Доступность = Объект.ОбщийСписокРассылки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ГруппыКонтактовПользователей_Запись");
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ВыбранныеАдресаты = Новый Массив;
	Для каждого ТаблицаСтрока Из Объект.Пользователи Цикл
		Участник = РаботаСАдреснойКнигойКлиент.СтруктураВыбранногоАдресата();
		Участник.Контакт = ТаблицаСтрока.ПользовательИлиГруппа;
		ВыбранныеАдресаты.Добавить(Участник);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Подбор пользователей общей группы контактов'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаВыбранных", НСтр("ru = 'Выбранные пользователи/группы:'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи/группы:'"));
	ПараметрыФормы.Вставить("РежимРаботыФормы", 2);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыФормы.Вставить("ВыбранныеАдресаты", ВыбранныеАдресаты);
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ПодобратьПользователей_Продолжение", ЭтаФорма);
		
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПользователей_Продолжение(ВыбранныеПользователиГруппы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеПользователиГруппы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Пользователи.Очистить();
	
	Для Каждого ПользовательГруппа Из ВыбранныеПользователиГруппы Цикл
		НоваяСтрПользователь = Объект.Пользователи.Добавить();
		НоваяСтрПользователь.ПользовательИлиГруппа = ПользовательГруппа.Контакт;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка= Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("УпрощенныйИнтерфейс", Истина);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	
	Если ЗначениеЗаполнено(Элементы.Пользователи.ТекущиеДанные) Тогда
		ПараметрыФормы.Вставить("ВыбранныеАдресаты", Элементы.Пользователи.ТекущиеДанные.ПользовательИлиГруппа);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор пользователя общей группы контактов'"));
	ПараметрыФормы.Вставить("ЗаголовокСпискаАдреснойКниги", НСтр("ru = 'Все пользователи'"));
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, Элементы.ПользователиПользователь, Неопределено);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ОбщийСписокРассылки Тогда
		
		Для Каждого Строка Из Объект.Контакты Цикл
			Если ТипЗнч(Строка.Контакт) = Тип("СправочникСсылка.ЛичныеАдресаты") Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСТр("ru='Запрещено использовать личных адресатов(""%1"") в общих группах контактов.'"), Строка.Контакт);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Контакты", , Отказ);
			КонецЕсли;	
		КонецЦикла;			
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗначениеТипаПользователя()
	
	Если Элементы.Пользователи.ТекущиеДанные <> Неопределено Тогда
		
		Если Элементы.Пользователи.ТекущиеДанные.ПользовательИлиГруппа = Неопределено Тогда 
			Элементы.Пользователи.ТекущиеДанные.ПользовательИлиГруппа
				= ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		КонецЕсли;
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПередНачаломИзменения(Элемент, Отказ)
	
	ЗаполнитьЗначениеТипаПользователя();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПриАктивизацииСтроки(Элемент)
	
	ЗаполнитьЗначениеТипаПользователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСРабочимиГруппамиКлиент.ДокументРабочаяГруппаУчастникАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Контакты.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.Контакт) Тогда
			
			Контакт = ТекущиеДанные.Контакт;
			ТекущиеДанные.КонтактнаяИнформация = ПолучитьОсновнойАдрес(Контакт);			
			ТекущиеДанные.Недействителен = НедействительностьПользователя(Контакт);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОсновнойАдрес(Контакт) 
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Пользователи")
		Или ТипЗнч(Контакт) = Тип("СправочникСсылка.РолиИсполнителей") 
		Или ТипЗнч(Контакт) = Тип("СправочникСсылка.ФизическиеЛица") 
		Или ТипЗнч(Контакт) = Тип("СправочникСсылка.Контрагенты") 
		Или ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛица") 
		Или ТипЗнч(Контакт) = Тип("СправочникСсылка.ЛичныеАдресаты") Тогда
	
		ТаблицаКонтактовEmail = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Контакт), 
			Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,,
			ТекущаяДатаСеанса());
			
		Если ТаблицаКонтактовEmail.Количество() <> 0 Тогда
			Возврат ТаблицаКонтактовEmail[0].Представление;
		КонецЕсли;	
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции	

&НаКлиенте
Процедура КонтактыКонтактАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если СтрДлина(Текст) < 2 Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоВебКлиент = Ложь;
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#КонецЕсли
	
	ДанныеВыбора = ВстроеннаяПочтаСервер.ПолучитьДанныеВыбораДляЭлектронногоПисьма(
		Текст, 
		ТекущийПользователь, 
		ЭтоВебКлиент);
		
	ВстроеннаяПочтаКлиент.ЗаполнитьКартинкиВСпискеВыбора(ДанныеВыбора);		
	
	Если ДанныеВыбора.Количество() <> 0 Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыКонтактОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Контакты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ТекущиеДанные.Контакт = ВыбранноеЗначение.Контакт;
		ТекущиеДанные.КонтактнаяИнформация = ВыбранноеЗначение.Адрес;
		ТекущиеДанные.Представление = ВыбранноеЗначение.Представление;
		ТекущиеДанные.Тип 
			= ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
			
		ТекущиеДанные.Недействителен = НедействительностьПользователя(ТекущиеДанные.Контакт);			
	Иначе
		Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда			
			ТекущиеДанные.Контакт = ВыбранноеЗначение;
			ТекущиеДанные.КонтактнаяИнформация = ПолучитьОсновнойАдрес(ВыбранноеЗначение);
			ТекущиеДанные.Представление = Строка(ВыбранноеЗначение);
			ТекущиеДанные.Тип 
				= ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
			ТекущиеДанные.Недействителен = НедействительностьПользователя(ТекущиеДанные.Контакт);				
		КонецЕсли;	
	КонецЕсли;	
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Контакт) Тогда
		Элемент.ТекущиеДанные.Контакт = ПустаяСсылкаПользователя;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКонтакт(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимРаботыФормы", 2);
	ПараметрыОткрытия.Вставить("ОтображатьКонтрагентов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьЛичныхАдресатов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьРоли", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьЭлектронныеАдреса", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьПодразделения", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДобавитьКонтактПродолжение",
		ЭтотОбъект);
		
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(
		ПараметрыОткрытия, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКонтактПродолжение(Результат, Параметры) Экспорт
	
	Если (ТипЗнч(Результат) <> Тип("Массив")) И (ТипЗнч(Результат) <> Тип("Соответствие")) Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() > 0 Тогда
		
		Для каждого Строка Из Результат Цикл
			
			НоваяСтрока = Объект.Контакты.Добавить();
			
			НоваяСтрока.Контакт = Строка.Контакт;
			НоваяСтрока.КонтактнаяИнформация = Строка.Адрес;
			НоваяСтрока.Представление = Строка.Представление;
			НоваяСтрока.Тип 
				= ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
			
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	ПоказыватьНедействительныхПользователей = Не ПоказыватьНедействительныхПользователей;
	
	Элементы.ФормаПоказыватьНедействительныхПользователей.Пометка 
		= ПоказыватьНедействительныхПользователей;
		
	УстановитьОтбор();	
КонецПроцедуры 

&НаКлиенте
Процедура КонтактыКонтактНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимРаботыФормы", 1);
	ПараметрыОткрытия.Вставить("ОтображатьКонтрагентов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьЛичныхАдресатов", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыОткрытия.Вставить("ОтображатьРоли", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьЭлектронныеАдреса", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьПодразделения", Истина);
	ПараметрыОткрытия.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
	
	// Открытие формы для редактирования списка адресатов
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КонтактыКонтактНачалоВыбораПродолжение",
		ЭтотОбъект);
		
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(
		ПараметрыОткрытия, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыКонтактНачалоВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если (ТипЗнч(Результат) <> Тип("Массив")) И (ТипЗнч(Результат) <> Тип("Соответствие")) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Контакты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если Результат.Количество() = 1 Тогда
		
		Строка = Результат[0];
		
		ТекущиеДанные.Контакт = Строка.Контакт;
		ТекущиеДанные.КонтактнаяИнформация = Строка.Адрес;
		ТекущиеДанные.Представление = Строка.Представление;
		ТекущиеДанные.Тип 
			= ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
		ТекущиеДанные.Недействителен = НедействительностьПользователя(ТекущиеДанные.Контакт);	
		
		Модифицированность = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтбор()
	Если ПоказыватьНедействительныхПользователей Тогда
		Элементы.Контакты.ОтборСтрок = Неопределено;
		Элементы.Пользователи.ОтборСтрок = Неопределено;
	Иначе
		Отбор = Новый Структура;
		Отбор.Вставить("Недействителен", Ложь);
		Элементы.Контакты.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
		Элементы.Пользователи.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	КонецЕсли;                          
	
	ОбновитьКоличествоПользователей();	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКоличествоПользователей()
	Если ПоказыватьНедействительныхПользователей Тогда
		КоличествоПользователей = Объект.Пользователи.Количество();
	Иначе
		КоличествоПользователей = 0;
		Для каждого Строка Из Объект.Пользователи Цикл		
			Если Не ПоказыватьНедействительныхПользователей И Строка.Недействителен Тогда
				Продолжить;                                       			
			КонецЕсли; 
			КоличествоПользователей = КоличествоПользователей + 1;			
		КонецЦикла;  				
	КонецЕсли; 	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Функция НедействительностьПользователя(ПользовательСсылка)
	Результат = Ложь;
	
	Если ЗначениеЗаполнено(ПользовательСсылка) Тогда
		Если ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.Пользователи") Тогда
			Если ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(ПользовательСсылка,
				"Недействителен") Тогда
				Результат = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции	

&НаКлиенте
Процедура ПользователиПриИзменении(Элемент)
	ОбновитьКоличествоПользователей();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если ОтменаРедактирования Тогда
		ОбновитьКоличествоПользователей();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Для каждого СтрокаТЧ Из Объект.Контакты Цикл		
		СтрокаТЧ.Недействителен = НедействительностьПользователя(СтрокаТЧ.Контакт);
	КонецЦикла;
	
	Для каждого СтрокаТЧ Из Объект.Пользователи Цикл		
		СтрокаТЧ.Недействителен = НедействительностьПользователя(СтрокаТЧ.ПользовательИлиГруппа);		
	КонецЦикла;      		
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПользовательПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Пользователи.ТекущиеДанные;
	ТекущиеДанные.Недействителен = НедействительностьПользователя(
		ТекущиеДанные.ПользовательИлиГруппа);
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

