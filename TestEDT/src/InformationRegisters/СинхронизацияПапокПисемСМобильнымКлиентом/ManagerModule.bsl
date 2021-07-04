#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПапкиДляСинхронизации(Пользователь, СУчетомПапокПоУмолчанию = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборПапки = Регистрысведений.СинхронизацияПапокПисемСМобильнымКлиентом.СоздатьНаборЗаписей();
	НаборПапки.Отбор.Пользователь.Значение = Пользователь;
	НаборПапки.Отбор.Пользователь.Использование = Истина;
	НаборПапки.Прочитать();
	
	Если НаборПапки.Количество() > 0
		ИЛИ НаборПапки.Количество() = 0
		И СУчетомПапокПоУмолчанию = Ложь Тогда
		Возврат НаборПапки.ВыгрузитьКолонку("Папка");
	Иначе
		Возврат ПолучитьПапкиДляСинхронизацииПоУмолчанию(Пользователь);
	КонецЕсли;
		
КонецФункции

Функция ПолучитьПапкиДляСинхронизацииПоУмолчанию(Пользователь)
	
	УстановитьПривилегированныйРежим(Истина);	
	МассивПапок = Новый Массив;
	
	ЗапросУчетныеЗаписи = Новый Запрос;
	ЗапросУчетныеЗаписи.Текст = 
		"ВЫБРАТЬ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
		|ГДЕ
		|	УчетныеЗаписиЭлектроннойПочты.ОтветственныеЗаОбработкуПисем.Пользователь = &Пользователь
		|	И УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = &ПометкаУдаления
		|	И УчетныеЗаписиЭлектроннойПочты.ВариантИспользования = &ВариантИспользования";
	ЗапросУчетныеЗаписи.УстановитьПараметр("Пользователь", Пользователь);
	ЗапросУчетныеЗаписи.УстановитьПараметр("ПометкаУдаления", Ложь);
	ЗапросУчетныеЗаписи.УстановитьПараметр("ВариантИспользования", Перечисления.ВариантыИспользованияПочты.Встроенная);
	МассивУчетныеЗаписи = ЗапросУчетныеЗаписи.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
	Для каждого УчетнаяЗаписьПользователя Из МассивУчетныеЗаписи Цикл
		ЗапросПапкиУчетнойЗаписи = Новый Запрос;
		ЗапросПапкиУчетнойЗаписи.Текст = 
			"ВЫБРАТЬ
			|	ПапкиУчетныхЗаписей.Папка,
			|	ПапкиУчетныхЗаписей.ВидПапки
			|ИЗ
			|	РегистрСведений.ПапкиУчетныхЗаписей КАК ПапкиУчетныхЗаписей
			|ГДЕ
			|	ПапкиУчетныхЗаписей.УчетнаяЗапись = &УчетнаяЗапись";
		ЗапросПапкиУчетнойЗаписи.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗаписьПользователя);
		ПапкиУчетнойЗаписи = ЗапросПапкиУчетнойЗаписи.Выполнить().Выгрузить();
		Для Каждого ПапкаУчетнойЗаписи Из папкиУчетнойЗаписи Цикл
			Если ПапкаУчетнойЗаписи.ВидПапки = Перечисления.ВидыПапокПисем.Корзина Тогда
				Продолжить;
			КонецЕсли;
			
			Если МассивПапок.Найти(ПапкаУчетнойЗаписи.Папка) = Неопределено Тогда
				МассивПапок.Добавить(ПапкаУчетнойЗаписи.Папка);
				РодительПапки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПапкаУчетнойЗаписи.Папка, "Родитель");
				Пока ЗначениеЗаполнено(РодительПапки) Цикл
					Если МассивПапок.Найти(РодительПапки) = Неопределено Тогда
						МассивПапок.Добавить(РодительПапки);
					КонецЕсли;
					РодительПапки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительПапки, "Родитель");
				КонецЦикла;
			КонецЕсли;			
		КонецЦикла;
	КонецЦикла;
		
	Возврат МассивПапок;
	
КонецФункции

Процедура ЗаписатьПапки(МассивПапок, Пользователь = Неопределено) Экспорт

	УстановитьПривилегированныйРежим(Истина);

	Если Пользователь = Неопределено Тогда
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;

	НаборЗаписей = РегистрыСведений.СинхронизацияПапокПисемСМобильнымКлиентом.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Значение = Пользователь;
	НаборЗаписей.Отбор.Пользователь.Использование = Истина;
	НаборЗаписей.Записать();
	
	Для Каждого ПапкаСсылка Из МассивПапок Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Пользователь = Пользователь;
		НоваяЗапись.Папка = папкаСсылка;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецЕсли
