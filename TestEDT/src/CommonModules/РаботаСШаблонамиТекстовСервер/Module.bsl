
// Возвращает список значений для выбора шаблона текста
Функция СформироватьДанныеВыбораШаблона(ПараметрыПолученияДанных, ОбластьПрименения) Экспорт 
	
	ПараметрыПолученияДанных.Отбор = Новый Структура;
	ПараметрыПолученияДанных.Отбор.Вставить("ОбластьПрименения", ОбластьПрименения);
	
	// временно. жду ответа от платформы.
	//Данные = Справочники.ШаблоныТекстов.ПолучитьДанныеВыбора(ПараметрыПолученияДанных);
	
	Текст = ПараметрыПолученияДанных.СтрокаПоиска; 
	Данные = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШаблоныТекстов.Ссылка КАК Ссылка,
	|	ШаблоныТекстов.Наименование КАК Наименование,
	|	ШаблоныТекстов.Шаблон КАК Шаблон
	|ИЗ
	|	Справочник.ШаблоныТекстов КАК ШаблоныТекстов
	|ГДЕ
	|	ШаблоныТекстов.Наименование ПОДОБНО &Текст
	|	И ШаблоныТекстов.ПометкаУдаления = ЛОЖЬ
	|	И ШаблоныТекстов.ОбластьПрименения = &ОбластьПрименения";
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("ОбластьПрименения", ОбластьПрименения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОписаниеШаблона = Новый Структура("Ссылка, Шаблон",
			Выборка.Ссылка, Выборка.Шаблон);
		Данные.Добавить(ОписаниеШаблона, Выборка.Наименование);
		
	КонецЦикла;	
	
	Возврат Данные;
	
КонецФункции	
