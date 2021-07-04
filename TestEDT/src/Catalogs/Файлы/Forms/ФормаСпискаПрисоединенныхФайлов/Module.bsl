&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(,ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	Если ИмяКаталога = Неопределено ИЛИ ПустаяСтрока(ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ВыбраннаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаРедактирования", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(Обработчик, ДанныеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаРедактирования(Результат, ПараметрыВыполнения) Экспорт
	
	РезультатОткрыть = "Открыть";
	РезультатРедактировать = "Редактировать";
	РезультатОткрытьКарточку = "ОткрытьКарточку";
	
	Если Результат = РезультатРедактировать Тогда
		Обработчик = Новый ОписаниеОповещения("СписокВыборПослеРедактированияФайла", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	ИначеЕсли Результат = РезультатОткрытьКарточку Тогда
		ПоказатьЗначение(, ПараметрыВыполнения.ДанныеФайла.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеРедактированияФайла(Результат, ПараметрыВыполнения) Экспорт
	
	ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ФайлОснование = Элементы.Список.ТекущаяСтрока;
	
	Если Не Копирование Тогда
		
		Отказ = Истина;
		Попытка
			ВладелецФайла = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
			Обработчик = Новый ОписаниеОповещения("ОбновитьСписокФайлов", ЭтотОбъект);
			РаботаСФайламиКлиент.ДобавитьФайл(Обработчик, ВладелецФайла.Значение, ЭтотОбъект);
		Исключение
			ПоказатьПредупреждение(, ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
				ИнформацияОбОшибке()));
		КонецПопытки;
		
	Иначе
		
		ВладелецФайла = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла.Значение, ФайлОснование);
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Список.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		
		Если Параметр <> Неопределено Тогда
			
			ВладелецФайлаСписка = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
			
			ВладелецФайла = Неопределено;
			Если Параметр.Свойство("Владелец", ВладелецФайла) Тогда
				Если ВладелецФайла = ВладелецФайлаСписка.Значение Тогда
					Элементы.Список.Обновить();
					
					ФайлСозданный = Неопределено;
					Если Параметр.Свойство("Файл", ФайлСозданный) Тогда
						Элементы.Список.ТекущаяСтрока = ФайлСозданный;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
			УстановитьДоступностьФайловыхКоманд();
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда 
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;	
	
	Если Параметры.Свойство("ВладелецФайла") Тогда 
		Список.Параметры.УстановитьЗначениеПараметра(
			"Владелец", Параметры.ВладелецФайла);
		КонецЕсли;
		
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", Пользователи.ТекущийПользователь());
		
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	Если Не ПоказыватьУдаленныеФайлы Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьУдаленныеФайлы);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;
	
	Элементы.ФормаПоказыватьУдаленныеФайлы.Пометка = ПоказыватьУдаленныеФайлы;
	
	Если Не ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи()
		И Не ЭлектроннаяПодпись.ИспользоватьШифрование() Тогда
		
		Элементы.ПодписанЭП.Видимость = Ложь;
	КонецЕсли;
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.ТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлВыполнить()
	
	Попытка
		ВладелецФайла = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
		Обработчик = Новый ОписаниеОповещения("ОбновитьСписокФайлов", ЭтотОбъект);
		РаботаСФайламиКлиент.ДобавитьФайл(Обработчик, ВладелецФайла.Значение, ЭтотОбъект);
	Исключение
		ПоказатьПредупреждение(,ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
			ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	
	ПараметрыОбновленияФайла = РаботаСФайламиКлиент.ПараметрыОбновленияФайла(Обработчик, 
		СтрокаТаблицы.Ссылка, УникальныйИдентификатор);
	ПараметрыОбновленияФайла.ХранитьВерсии = СтрокаТаблицы.ХранитьВерсии;
	ПараметрыОбновленияФайла.РедактируетТекущийПользователь = СтрокаТаблицы.РедактируетТекущийПользователь;
	ПараметрыОбновленияФайла.Редактирует = СтрокаТаблицы.Редактирует;
	ПараметрыОбновленияФайла.АвторТекущейВерсии = СтрокаТаблицы.Автор;
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	РаботаСФайламиКлиент.ЗанятьСОповещением(Обработчик, Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОсвобожденияФайла = РаботаСФайламиКлиент.ПараметрыОсвобожденияФайла(Обработчик, 
		Элементы.Список.ТекущаяСтрока);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;	
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
	КомандыРаботыСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
		
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	РаботаСФайламиКлиент.РедактироватьСОповещением(Обработчик, Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	
	РаботаСФайламиКлиент.СохранитьИзмененияФайлаСОповещением(
		Обработчик,
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 1 Тогда
		
		СписокФайловДляВыгрузки = Новый СписокЗначений;
		Для Каждого ВыбраннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
			ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);	
			СписокФайловДляВыгрузки.Добавить(ДанныеСтроки.Ссылка);
		КонецЦикла;
		
		Если СписокФайловДляВыгрузки.Количество() > 0 Тогда
			РаботаСФайламиКлиент.СохранитьФайлыКак(СписокФайловДляВыгрузки, УникальныйИдентификатор);
		КонецЕсли;
		
	ИначеЕсли Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
		
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
			Элементы.Список.ТекущаяСтрока,
			Неопределено,
			УникальныйИдентификатор);
		
		КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	ВладелецФайла = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
	ВладелецФайлаСписка = ВладелецФайла.Значение;
	
	Если ВладелецФайлаСписка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			УстановитьДоступностьКоманд(Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
				Элементы.Список.ТекущиеДанные.Редактирует, Элементы.Список.ТекущиеДанные.ПодписанЭП,
				Элементы.Список.ТекущиеДанные.Зашифрован);
					
		КонецЕсли;	
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(РедактируетТекущийПользователь, Редактирует, ПодписанЭП, Зашифрован)
	
	Элементы.ЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	Элементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	
	Элементы.СохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	Элементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	
	Элементы.Освободить.Доступность = Не Редактирует.Пустая();
	Элементы.КонтекстноеМенюСписокОсвободить.Доступность = Не Редактирует.Пустая();
	
	Элементы.Занять.Доступность = Редактирует.Пустая() И НЕ (ПодписанЭП ИЛИ Зашифрован);
	Элементы.КонтекстноеМенюСписокЗанять.Доступность = Редактирует.Пустая() И НЕ (ПодписанЭП ИЛИ Зашифрован);
	
	Элементы.Редактировать.Доступность = НЕ (ПодписанЭП ИЛИ Зашифрован);
	Элементы.КонтекстноеМенюСписокРедактировать.Доступность = НЕ (ПодписанЭП ИЛИ Зашифрован);
	
	Элементы.ФормаПодписать.Доступность = Редактирует.Пустая();
	Элементы.ФормаПодписатьКонтекст.Доступность = Редактирует.Пустая();
	
	Элементы.ФормаСохранитьВместеСЭП.Доступность = ПодписанЭП;
	Элементы.ФормаСохранитьВместеСЭПКонтекст.Доступность = ПодписанЭП;
	
	Элементы.ФормаЗашифровать.Доступность = Редактирует.Пустая() И НЕ Зашифрован;
	Элементы.ФормаЗашифроватьКонтекст.Доступность = Редактирует.Пустая() И НЕ Зашифрован;
	
	Элементы.ФормаРасшифровать.Доступность = Зашифрован;
	Элементы.ФормаРасшифроватьКонтекст.Доступность = Зашифрован;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		УстановитьДоступностьФайловыхКоманд();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортФайлов(Команда)
	
	#Если Не ВебКлиент Тогда
		МассивИменФайлов = ФайловыеФункцииКлиент.ПолучитьСписокИмпортируемыхФайлов();
		
		Если МассивИменФайлов.Количество() > 0 Тогда
			ВладелецФайла = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Владелец"));
			ПараметрыИмпорта = Новый Структура("ПапкаДляДобавления, МассивИменФайлов", ВладелецФайла.Значение, МассивИменФайлов);
			ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаФайлов", ПараметрыИмпорта);
		КонецЕсли;
	#Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'В Веб-клиенте импорт файлов не поддерживается. Используйте команду ""Создать"" в списке файлов.'"));
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	МассивФайлов = Новый Массив;
	Для Каждого ФайлСсылка Из Элементы.Список.ВыделенныеСтроки Цикл
		Если Не ФайловыеКомандыДоступны(ФайлСсылка) Тогда 
			Продолжить;
		КонецЕсли;
		МассивФайлов.Добавить(ФайлСсылка);
	КонецЦикла;
	
	РаботаСФайламиСлужебныйКлиент.ПодписатьФайл(МассивФайлов, УникальныйИдентификатор,
		Новый ОписаниеОповещения("ПодписатьЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭПИзФайла(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.ДобавитьПодписьИзФайла(
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор,
		Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭП(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиСлужебныйКлиент.СохранитьФайлВместеСПодписью(Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Элементы.Список.ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	ПараметрыОбработчика.Вставить("ОбъектСсылка", ОбъектСсылка);
	Обработчик = Новый ОписаниеОповещения("ЗашифроватьПослеШифрованияНаКлиенте", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.Зашифровать(Обработчик, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьПослеШифрованияНаКлиенте(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяРабочегоКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	ЗашифроватьСервер(
		Результат.МассивДанныхДляЗанесенияВБазу,
		Результат.МассивОтпечатков,
		МассивФайловВРабочемКаталогеДляУдаления,
		ИмяРабочегоКаталога,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	РаботаСФайламиКлиент.ИнформироватьОШифровании(
		МассивФайловВРабочемКаталогеДляУдаления,
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаСервере
Процедура ЗашифроватьСервер(МассивДанныхДляЗанесенияВБазу, МассивОтпечатков, 
	МассивФайловВРабочемКаталогеДляУдаления,
	ИмяРабочегоКаталога, ОбъектСсылка, ЕстьЗашифрованныеИлиЗанятыеФайлы)
	
	Зашифровать = Истина;
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
	СсылкаВладелецФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектСсылка, "ВладелецФайла");
	ЕстьЗашифрованныеИлиЗанятыеФайлы = РаботаСФайламиВызовСервера.ЕстьЗашифрованныеИлиЗанятыеФайлы(СсылкаВладелецФайла);

КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Элементы.Список.ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	ПараметрыОбработчика.Вставить("ОбъектСсылка", ОбъектСсылка);
	Обработчик = Новый ОписаниеОповещения("РасшифроватьПослеРасшифровкиНаКлиенте", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиСлужебныйКлиент.Расшифровать(Обработчик, ДанныеФайла.Ссылка, УникальныйИдентификатор, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифроватьПослеРасшифровкиНаКлиенте(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяРабочегоКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	РасшифроватьСервер(
		Результат.МассивДанныхДляЗанесенияВБазу,
		ИмяРабочегоКаталога,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	РаботаСФайламиКлиент.ИнформироватьОРасшифровке(
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаСервере
Процедура РасшифроватьСервер(МассивДанныхДляЗанесенияВБазу, 
	ИмяРабочегоКаталога, ОбъектСсылка, ЕстьЗашифрованныеИлиЗанятыеФайлы)
	
	Зашифровать = Ложь;
	МассивОтпечатков = Новый Массив;
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьУдаленныеФайлы"] <> Неопределено Тогда
		
		Если Не ПоказыватьУдаленныеФайлы Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, "ПометкаУдаления", Ложь,
				ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьУдаленныеФайлы);
		Иначе		
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
		КонецЕсли;	
			
		Элементы.ФормаПоказыватьУдаленныеФайлы.Пометка = ПоказыватьУдаленныеФайлы;	
			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленныеФайлы(Команда)
	
	ПоказыватьУдаленныеФайлы = Не ПоказыватьУдаленныеФайлы;
	
	Если Не ПоказыватьУдаленныеФайлы Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьУдаленныеФайлы);
	Иначе		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;	
		
	Элементы.ФормаПоказыватьУдаленныеФайлы.Пометка = ПоказыватьУдаленныеФайлы;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаОткрытия(Результат, ПараметрыВыполнения) Экспорт
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.КакОткрывать = 1 Тогда
		// Для редактирования.
		Обработчик = Новый ОписаниеОповещения("СписокВыборПослеРедактирования", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор);
		Возврат;
	КонецЕсли;
	
	// Для просмотра.
	РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеРедактирования(Результат, ПараметрыВыполнения) Экспорт
	ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ЗанятьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат.Успех <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ПараметрыВыполнения.ФайлСсылка,
		Истина, // Зашифровать
		Результат.МассивДанныхДляЗанесенияВБазу,
		Неопределено, // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		Результат.МассивОтпечатков);
	
	РаботаСФайламиКлиент.ИнформироватьОШифровании(
		МассивФайловВРабочемКаталогеДляУдаления, 
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ФайлСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура РасшифроватьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат.Успех <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ПараметрыВыполнения.ФайлСсылка,
		Ложь,          // Зашифровать
		Результат.МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		Новый Массив,  // МассивФайловВРабочемКаталогеДляУдаления
		Новый Массив); // МассивОтпечатков
		
	РаботаСФайламиКлиент.ИнформироватьОРасшифровке(
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ФайлСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодписьИзФайлаЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСПодписьюЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактированиеЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

&НаКлиенте
Функция ФайловыеКомандыДоступны(ФайлСсылка = Неопределено)
	// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка.
	
	Если ФайлСсылка = Неопределено Тогда 
		ФайлСсылка = Элементы.Список.ТекущаяСтрока;
	КонецЕсли;
	
	Если ФайлСсылка = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ФайлСсылка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокФайлов(Результат, ПараметрыВыполнения) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
