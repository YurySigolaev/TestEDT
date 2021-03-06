// Возвращает таблицу (поля Папка, Представление) папок для текущего пользователя
Функция ПолучитьПапкиДляТекущегоПользователя() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПапкиПисемЧастоИспользуемые.Папка КАК Папка,
		|	ПРЕДСТАВЛЕНИЕ(ПапкиПисемЧастоИспользуемые.Папка) КАК Представление,
		|	ПапкиПисемЧастоИспользуемые.Порядок КАК Порядок,
		|	ПапкиПисем.ВариантОтображенияКоличестваПисем КАК ВариантОтображенияКоличестваПисем
		|ИЗ
		|	РегистрСведений.ПапкиПисемЧастоИспользуемые КАК ПапкиПисемЧастоИспользуемые
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПапкиПисем КАК ПапкиПисем
		|		ПО ПапкиПисемЧастоИспользуемые.Папка = ПапкиПисем.Ссылка
		|ГДЕ
		|	ПапкиПисемЧастоИспользуемые.Пользователь = &Пользователь
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок");
		
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	ТаблицаПапок = Запрос.Выполнить().Выгрузить();
	Возврат ТаблицаПапок;
	
КонецФункции

// Записывает массив папок для текущего пользователя, затирая предыдущие
Функция ЗаписатьПапкиДляТекущегоПользователя(МассивПапок) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ПапкиПисемЧастоИспользуемые.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(ПользователиКлиентСервер.ТекущийПользователь());
	НаборЗаписей.Записать();
	
	НомерПоПорядку = 0;
	Для Каждого Папка Из МассивПапок Цикл
		
		МенеджерЗаписи = РегистрыСведений.ПапкиПисемЧастоИспользуемые.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Папка = Папка;
		МенеджерЗаписи.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
		МенеджерЗаписи.Порядок = НомерПоПорядку;
		МенеджерЗаписи.Записать();
		
		НомерПоПорядку = НомерПоПорядку + 1;
		
	КонецЦикла;	
	
КонецФункции

