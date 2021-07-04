&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеПолученияКонтекстаЭДО", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия = "Завершение отправки" ИЛИ ИмяСобытия = "Успешная отправка заявления на переход")
		И ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("Организация")
		И ТипЗнч(Параметр.Организация) = Тип("СправочникСсылка.Организации") Тогда
		
		ОбновитьНастройкиОбменаОрганизаций(Параметр.Организация);
		
	ИначеЕсли ИмяСобытия = "Завершение отправки заявления"
		И ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи")
		ИЛИ ИмяСобытия = "Запись_Организации" И ТипЗнч(Источник) = Тип("СправочникСсылка.Организации") Тогда
		
		ОбновитьНастройкиОбменаОрганизаций(Источник);
		
	ИначеЕсли ИмяСобытия = "ИзмененаРегистрацияВНалоговомОргане" И ТипЗнч(Параметр) = Тип("Структура")
		И Параметр.Свойство("Владелец") И ТипЗнч(Параметр.Владелец) = Тип("СправочникСсылка.Организации") Тогда
		
		ОбновитьНастройкиОбменаОрганизаций(Параметр.Владелец);
		
	ИначеЕсли ИмяСобытия = "ИзменениеНастроекЭДООрганизации" И ТипЗнч(Параметр) = Тип("СправочникСсылка.Организации")
		ИЛИ ИмяСобытия = "ЗаполнитьСводнуюИнформациюПоЗаявлениюАбонентаСпецоператораСвязи"
		И ТипЗнч(Параметр) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи")
		ИЛИ (ИмяСобытия = "ОбновитьУчетнуюЗапись" ИЛИ ИмяСобытия = "Изменены пользователи учетной записи")
		И ТипЗнч(Параметр) = Тип("СправочникСсылка.УчетныеЗаписиДокументооборота") Тогда
		
		ОбновитьНастройкиОбменаОрганизаций(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиОбмена

&НаКлиенте
Процедура НастройкиОбменаПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
		Возврат;
	КонецЕсли;
	
	ВыбраннаяСтрока = Элемент.ВыделенныеСтроки[0];
	ОрганизацияСсылка = НастройкиОбмена[ВыбраннаяСтрока].ЭлементНастроекОбмена.Организация;
	КонтекстЭДОКлиент.ОткрытьФормуНастроекОбмена(ОрганизацияСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
		Возврат;
	КонецЕсли;
	
	ЭлементНастроекОбмена = НастройкиОбмена[ВыбраннаяСтрока].ЭлементНастроекОбмена;
	ДополнительныеПараметрыПослеОбновления = Неопределено;
	
	Если Поле.Имя = "НастройкиОбменаЗаявление" Тогда
		ДействияДляЭлемента = ДействияДляЭлементаНастроекОбмена(ЭлементНастроекОбмена);
		Если ДействияДляЭлемента.ПоказыватьЗаявление Тогда
			КонтекстЭДОКлиент.ПоказатьФормуСтатусовОтправкиИлиОбновитьЗаявление(
				ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Ссылка,
				ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус,
				ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_НастройкаЗавершена,
				ЭлементНастроекОбмена.Организация);
			
		ИначеЕсли ДействияДляЭлемента.ПредлагатьПодключиться Тогда
			ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(
				ЭлементНастроекОбмена.Организация,
				ЭтотОбъект,,
				ПредопределенноеЗначение("Перечисление.ТипыЗаявленияАбонентаСпецоператораСвязи.Первичное"));
			
		ИначеЕсли НЕ ЭлементНастроекОбмена.ПравоЧтенияУчетнойЗаписиОбмена Тогда
			КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФНСиПФРиРосстатом(ЭлементНастроекОбмена.Организация, ЭтотОбъект);
			
		ИначеЕсли НЕ ДействияДляЭлемента.Действительны
			И (НЕ ДействияДляЭлемента.ПоказыватьСертификат ИЛИ ЭлементНастроекОбмена.СвойстваСертификатаРуководителя <> Неопределено)
			И ЗначениеЗаполнено(ЭлементНастроекОбмена.СпецоператорСвязи)
			И ЭлементНастроекОбмена.СпецоператорСвязи <> ПредопределенноеЗначение("Перечисление.СпецоператорыСвязи.Такском")
			И ЭлементНастроекОбмена.СпецоператорСвязи <> ПредопределенноеЗначение("Перечисление.СпецоператорыСвязи.Прочие") Тогда
			
			Если ДействияДляЭлемента.ПоказыватьСертификат Тогда
				ПараметрыОткрытияМастера = Новый Структура("ПриОткрытииЗапрошеноПродлениеСертификата, ПриОткрытииЗапрошеноПродлениеЛицензии",
					Истина, НЕ ДействияДляЭлемента.ЛицензияДействительна);
			Иначе
				ПараметрыОткрытияМастера = Новый Структура("ПриОткрытииЗапрошеноПродлениеСертификата, ПриОткрытииЗапрошеноПродлениеЛицензии",
					НЕ ДействияДляЭлемента.СертификатДействителен, Истина);
			КонецЕсли;
			ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(
				ЭлементНастроекОбмена.Организация,
				ЭтотОбъект,,,
				ПараметрыОткрытияМастера);
			
		Иначе
			КонтекстЭДОКлиент.ОткрытьФормуНастроекОбмена(ЭлементНастроекОбмена.Организация);
		КонецЕсли;
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаФНССтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаПФРСтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПФР"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаРосстатСтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСГС"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаФСССтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаФСРАРСтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаРПНСтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаФТССтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаБанкРоссииСтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.БанкРоссии"));
			
	ИначеЕсли Поле.Имя = "НастройкиОбменаМинобороныСтрокой" Тогда
		ДополнительныеПараметрыПослеОбновления = Новый Структура("Организация, ТипКонтролирующегоОргана",
			ЭлементНастроекОбмена.Организация, ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.Минобороны"));
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаСостояниеПоследнегоЗаявления" Тогда
		КонтекстЭДОКлиент.ПоказатьФормуСтатусовОтправкиИлиОбновитьЗаявление(
			ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Ссылка,
			ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус,
			ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_НастройкаЗавершена,
			ЭлементНастроекОбмена.Организация);
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаСрокДействияСертификата" Тогда
		ПараметрыОткрытияМастера = Новый Структура("ПриОткрытииЗапрошеноПродлениеСертификата", Истина);
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(
			ЭлементНастроекОбмена.Организация,
			ЭтотОбъект,,,
			ПараметрыОткрытияМастера);
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаСрокДействияЛицензии" Тогда
		ПараметрыОткрытияМастера = Новый Структура("ПриОткрытииЗапрошеноПродлениеЛицензии", Истина);
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(
			ЭлементНастроекОбмена.Организация,
			ЭтотОбъект,,,
			ПараметрыОткрытияМастера);
		
	ИначеЕсли Поле.Имя = "НастройкиОбменаПометкаУдаленияСтрокой" Тогда
		ИзменитьПометкуУдаленияОрганизацииНаСервере(ЭлементНастроекОбмена.Организация);
		ОбновитьНастройкиОбменаОрганизаций(ЭлементНастроекОбмена.Организация);
		
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуНастроекОбмена(ЭлементНастроекОбмена.Организация);
	КонецЕсли;
	
	Если ДополнительныеПараметрыПослеОбновления <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НастройкиОбменаВыборПослеОбновленияНастроек",
			ЭтотОбъект, ДополнительныеПараметрыПослеОбновления);
		ОбновитьНастройкиОбменаОрганизаций(ЭлементНастроекОбмена.Организация, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаУдаление(Команда)
	
	ТекущиеДанные = Элементы.НастройкиОбмена.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИзменитьПометкуУдаленияОрганизацииНаСервере(ТекущиеДанные.ЭлементНастроекОбмена.Организация);
		Если Элементы.НастройкиОбменаОтображатьУдаленные.Пометка Тогда
			ОбновитьНастройкиОбменаОрганизаций(ТекущиеДанные.ЭлементНастроекОбмена.Организация);
		Иначе
			ОбновитьНастройкиОбменаОрганизаций();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиОбменаОткрыть(Команда)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтрокиНастроекОбмена = Элементы.НастройкиОбмена.ВыделенныеСтроки;
	
	Если ВыделенныеСтрокиНастроекОбмена.Количество() > 0 Тогда
		ВыбраннаяСтрока = ВыделенныеСтрокиНастроекОбмена[0];
		ОрганизацияСсылка = НастройкиОбмена[ВыбраннаяСтрока].ЭлементНастроекОбмена.Организация;
		КонтекстЭДОКлиент.ОткрытьФормуНастроекОбмена(ОрганизацияСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаОбновить(Команда)
	
	ОбновитьНастройкиОбменаОрганизаций();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаОтображатьУдаленные(Команда)
	
	Элементы.НастройкиОбменаОтображатьУдаленные.Пометка = НЕ Элементы.НастройкиОбменаОтображатьУдаленные.Пометка;
	ОбновитьНастройкиОбменаОрганизаций();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииПослеПолученияКонтекстаЭДО(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент 						= Результат.КонтекстЭДО;
	ТекстОшибкиИнициализацииКонтекстаЭДО 	= Результат.ТекстОшибки;
	ОбновитьНастройкиОбменаОрганизаций();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНастройкиОбменаОрганизаций(Ссылки = Неопределено, ОповещениеОЗавершении = Неопределено) Экспорт
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("Ссылки, ОповещениеОЗавершении", Ссылки, ОповещениеОЗавершении);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьНастройкиОбменаОрганизацийПослеПолученияНастроекОбмена",
		ЭтотОбъект, ДополнительныеПараметры);
	НастройкиВызова = Новый Структура("ПолучатьДляУдаленныхОрганизаций", Элементы.НастройкиОбменаОтображатьУдаленные.Пометка);
	КонтекстЭДОКлиент.НастройкиОбменаОрганизаций(ОписаниеОповещения, Ссылки, НастройкиВызова);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНастройкиОбменаОрганизацийПослеПолученияНастроекОбмена(Результат, ДополнительныеПараметры) Экспорт
	
	Ссылки 					= ДополнительныеПараметры.Ссылки;
	ОповещениеОЗавершении 	= ДополнительныеПараметры.ОповещениеОЗавершении;
	
	ЭтоОбновлениеВсегоСписка = (Ссылки = Неопределено);
	
	Если ЭтоОбновлениеВсегоСписка Тогда
		ПозицияВТаблице = КонтекстЭДОКлиент.СохранитьПозициюВТаблице(
			Элементы.НастройкиОбмена,
			НастройкиОбмена,
			"ЭлементНастроекОбмена",
			"Организация");
		
		ИндексНастроекОбмена = 0;
	КонецЕсли;
	
	СрокиПредупреждений = КонтекстЭДОКлиент.СрокиПредупрежденийНастроекОбменов(Результат.ТекущаяДатаНаСервере);
	ТекущаяДатаОкончанияПоказаЗаявления = СрокиПредупреждений.ТекущаяДатаОкончанияПоказаЗаявления;
	ТекущаяДатаИстечения 				= СрокиПредупреждений.ТекущаяДатаИстечения;
	
	Элементы.НастройкиОбменаПользователи.Видимость 		= (Результат.СписокПользователейБазы.Количество() > 0);
	Элементы.НастройкиОбменаБанкРоссииСтрокой.Видимость = Результат.ПоддерживаетсяСдачаОтчетностиВБанкРоссии;
	Элементы.НастройкиОбменаМинобороныСтрокой.Видимость = Результат.ПоддерживаетсяСдачаОтчетностиВМинобороныРоссии;
	
	Для каждого ЭлементНастроекОбмена Из Результат.НастройкиОбмена Цикл
		ДействияДляЭлемента = ДействияДляЭлементаНастроекОбмена(ЭлементНастроекОбмена);
		
		НаименованиеОрганизации = ?(ЗначениеЗаполнено(ЭлементНастроекОбмена.НаименованиеСокращенное),
			ЭлементНастроекОбмена.НаименованиеСокращенное, ЭлементНастроекОбмена.НаименованиеОрганизации);
		
		СостояниеПоследнегоЗаявления = КонтекстЭДОКлиент.СтатусЗаявленияСтрокой(
			ЭлементНастроекОбмена,
			,
			,
			,
			Ложь,
			Истина).СтатусСтрокой;
			
		СостояниеПоследнегоЗаявленияВРег = СостояниеПоследнегоЗаявления;
		Если ЗначениеЗаполнено(СостояниеПоследнегоЗаявленияВРег) Тогда
			ПерваяБукваСостояния = Лев(СостояниеПоследнегоЗаявленияВРег, 1);
			СостояниеПоследнегоЗаявленияВРег = ВРег(ПерваяБукваСостояния) + Сред(СостояниеПоследнегоЗаявленияВРег, 2)
				+ ?((ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено")
				ИЛИ ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено"))
				И НЕ ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_НастройкаЗавершена,
				", " + НСтр("ru = 'настройка не завершена'"), "");
		КонецЕсли;
		СрокДействияСертификата = ?(ЭлементНастроекОбмена.СвойстваСертификатаРуководителя <> Неопределено,
			ЭлементНастроекОбмена.СвойстваСертификатаРуководителя.ДействителенПо, Неопределено);
		СрокДействияЛицензии = ЭлементНастроекОбмена.ЛицензияДатаОкончания;
		
		Если ДействияДляЭлемента.ПоказыватьЗаявление Тогда
			ЗаявлениеТекст = СтрШаблон(
				НСтр("ru = 'Заявление %1'"),
				СостояниеПоследнегоЗаявления);
			
			Если (ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено")
				ИЛИ ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус =
				ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено"))
				И НЕ ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_НастройкаЗавершена Тогда
				
				ПерваяБукваТекста = Лев(ЗаявлениеТекст, 1);
				ЗаявлениеТекст = нрег(ПерваяБукваТекста) + Сред(ЗаявлениеТекст, 2);
				ЗаявлениеТекст = СтрШаблон(
					НСтр("ru = 'Настроить 1С-Отчетность (%1)'"),
					ЗаявлениеТекст);
			КонецЕсли;
			
		ИначеЕсли ДействияДляЭлемента.ПредлагатьПодключиться Тогда
			ЗаявлениеТекст = НСтр("ru = 'Подключиться к 1С-Отчетности'");
			
		ИначеЕсли НЕ ЭлементНастроекОбмена.ПравоЧтенияУчетнойЗаписиОбмена Тогда
			ЗаявлениеТекст = НСтр("ru = 'Недостаточно прав'");
			
		Иначе
			ИнформацияОСтатусе = Неопределено;
			Если ДействияДляЭлемента.ПоказыватьСертификат И ЭлементНастроекОбмена.СвойстваСертификатаРуководителя = Неопределено Тогда
				СтатусДействительности = НСтр("ru = 'недоступен'");
				
			ИначеЕсли ДействияДляЭлемента.Действительны Тогда
				СтатусДействительности = "";
				
			Иначе
				ИнформацияОСтатусе = КонтекстЭДОКлиент.СтатусДействительностиСтрокой(
					?(ДействияДляЭлемента.ПоказыватьСертификат, СрокДействияСертификата, СрокДействияЛицензии),
					Результат.ТекущаяДатаНаСервере,
					ТекущаяДатаИстечения,
					ДействияДляЭлемента.ПоказыватьСертификат);
				СтатусДействительности = ИнформацияОСтатусе.СтатусСтрокой;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтатусДействительности) Тогда
				Если ИнформацияОСтатусе <> Неопределено И ИнформацияОСтатусе.ТребуетПродления
					И ЗначениеЗаполнено(ЭлементНастроекОбмена.СпецоператорСвязи)
					И ЭлементНастроекОбмена.СпецоператорСвязи <> ПредопределенноеЗначение("Перечисление.СпецоператорыСвязи.Такском")
					И ЭлементНастроекОбмена.СпецоператорСвязи <> ПредопределенноеЗначение("Перечисление.СпецоператорыСвязи.Прочие") Тогда
					ЗаявлениеТекст = СтрШаблон(
						?(ДействияДляЭлемента.ПоказыватьСертификат, НСтр("ru = 'Продлить сертификат (%1)'"), НСтр("ru = 'Продлить лицензию (%1)'")),
						СтатусДействительности);
				Иначе
					ЗаявлениеТекст = СтрШаблон(
						?(ДействияДляЭлемента.ПоказыватьСертификат, НСтр("ru = 'Сертификат %1'"), НСтр("ru = 'Лицензия %1'")),
						СтатусДействительности);
				КонецЕсли;
				
			Иначе
				ЗаявлениеТекст = НСтр("ru = 'Готов к использованию'");
			КонецЕсли;
		КонецЕсли;
		
		УчетнаяЗаписьДоступна = (ЭлементНастроекОбмена.ВидОбменаСКонтролирующимиОрганами =
			ПредопределенноеЗначение("Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате")
			И ЗначениеЗаполнено(ЭлементНастроекОбмена.УчетнаяЗаписьОбмена)
			И ЭлементНастроекОбмена.ПравоЧтенияУчетнойЗаписиОбмена);
		
		КоличествоФНС 	= ЭлементНастроекОбмена.КодыФНС.Количество();
		КоличествоФСГС 	= ЭлементНастроекОбмена.КодыФСГС.Количество();
		
		СписокПользователейСтрокой = КонтекстЭДОКлиент.СписокПользователейСтрокой(
			ЭлементНастроекОбмена.СписокПользователей,
			УчетнаяЗаписьДоступна);
		
		Если ЭлементНастроекОбмена.ПредназначенаДляДокументооборотаСФНС И КоличествоФНС > 1 Тогда
			ФНССтрокой = СтрШаблон(
				НСтр("ru = 'Да (%1)'"),
				Строка(КоличествоФНС));
		Иначе
			ФНССтрокой = ?(ЭлементНастроекОбмена.ПредназначенаДляДокументооборотаСФНС, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		КонецЕсли;
		ПФРСтрокой = ?(ЭлементНастроекОбмена.ПредназначенаДляДокументооборотаСПФР, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		Если ЭлементНастроекОбмена.ПредназначенаДляДокументооборотаСФСГС И КоличествоФСГС > 1 Тогда
			РосстатСтрокой = СтрШаблон(
				НСтр("ru = 'Да (%1)'"),
				Строка(КоличествоФСГС));
		Иначе
			РосстатСтрокой = ?(ЭлементНастроекОбмена.ПредназначенаДляДокументооборотаСФСГС, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		КонецЕсли;
		ФСССтрокой = ?(ЭлементНастроекОбмена.НастройкиОбменаФСС_ИспользоватьОбмен, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		ФСРАРСтрокой = ?(ЭлементНастроекОбмена.НастройкиОбменаФСРАР_ИспользоватьОбмен,
			НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		РПНСтрокой = ?(ЭлементНастроекОбмена.НастройкиОбменаРПН_ИспользоватьОбмен,
			НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		ФТССтрокой = ?(ЭлементНастроекОбмена.НастройкиОбменаФТС_ИспользоватьОбмен,
			НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		БанкРоссииСтрокой = ?(ЭлементНастроекОбмена.НастройкиОбменаБанкРоссии_ИспользоватьОбмен,
				НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		МинобороныСтрокой = ?(ЭлементНастроекОбмена.НастройкиОбменаМинобороны_ИспользоватьОбмен,
				НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		
		Если ЭтоОбновлениеВсегоСписка Тогда
			Если ИндексНастроекОбмена < НастройкиОбмена.Количество() Тогда
				СтрокаНастроекОбмена = НастройкиОбмена[ИндексНастроекОбмена];
			Иначе
				СтрокаНастроекОбмена = НастройкиОбмена.Добавить();
			КонецЕсли;
			ИндексНастроекОбмена = ИндексНастроекОбмена + 1;
			
		Иначе
			СтрокаНастроекОбмена = Неопределено;
			Для ИндексНастроекОбмена = 0 По НастройкиОбмена.Количество() - 1 Цикл
				ТекущаяСтрокаНастроекОбмена = НастройкиОбмена[ИндексНастроекОбмена];
				Если ТекущаяСтрокаНастроекОбмена.ЭлементНастроекОбмена.Организация = ЭлементНастроекОбмена.Организация Тогда
					СтрокаНастроекОбмена = ТекущаяСтрокаНастроекОбмена;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если СтрокаНастроекОбмена <> Неопределено Тогда
			СтрокаНастроекОбмена.Организация 					= НаименованиеОрганизации;
			СтрокаНастроекОбмена.Заявление 						= ЗаявлениеТекст;
			СтрокаНастроекОбмена.ДатаПодключения 				= ЭлементНастроекОбмена.ДатаПодключения;
			СтрокаНастроекОбмена.Направления 					= КонтекстЭДОКлиент.НаправленияСтрокой(
				ЭлементНастроекОбмена,
				Результат.ПоддерживаетсяСдачаОтчетностиВБанкРоссии,
				Результат.ПоддерживаетсяСдачаОтчетностиВМинобороныРоссии);
			СтрокаНастроекОбмена.Пользователи 					= СписокПользователейСтрокой;
			СтрокаНастроекОбмена.ЭлементНастроекОбмена 			= ЭлементНастроекОбмена;
			СтрокаНастроекОбмена.ПометкаУдаления 				= ЭлементНастроекОбмена.ПометкаУдаления;
			СтрокаНастроекОбмена.ФНССтрокой 					= ФНССтрокой;
			СтрокаНастроекОбмена.ПФРСтрокой 					= ПФРСтрокой;
			СтрокаНастроекОбмена.РосстатСтрокой 				= РосстатСтрокой;
			СтрокаНастроекОбмена.ФСССтрокой 					= ФСССтрокой;
			СтрокаНастроекОбмена.ФСРАРСтрокой 					= ФСРАРСтрокой;
			СтрокаНастроекОбмена.РПНСтрокой 					= РПНСтрокой;
			СтрокаНастроекОбмена.ФТССтрокой 					= ФТССтрокой;
			СтрокаНастроекОбмена.БанкРоссииСтрокой 				= БанкРоссииСтрокой;
			СтрокаНастроекОбмена.МинобороныСтрокой 				= МинобороныСтрокой;
			СтрокаНастроекОбмена.ПометкаУдаленияСтрокой 		= ?(ЭлементНастроекОбмена.ПометкаУдаления, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
			СтрокаНастроекОбмена.СостояниеПоследнегоЗаявления 	= СостояниеПоследнегоЗаявленияВРег;
			СтрокаНастроекОбмена.СрокДействияСертификата 		= СрокДействияСертификата;
			СтрокаНастроекОбмена.СрокДействияЛицензии 			= СрокДействияЛицензии;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭтоОбновлениеВсегоСписка Тогда
		// обход проблемы платформы неверного текущего элемента при обновлении таблицы очисткой:
		// таблица обновляется поэлементно, после этого удаление лишних элементов, если есть
		КоличествоНастроекОбмена = ИндексНастроекОбмена;
		Пока Истина Цикл
			КоличествоСтрокНастроекОбмена = НастройкиОбмена.Количество();
			Если КоличествоСтрокНастроекОбмена > КоличествоНастроекОбмена Тогда
				НастройкиОбмена.Удалить(КоличествоСтрокНастроекОбмена - 1);
			Иначе
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Элементы.НастройкиОбмена.Обновить();
		
		КонтекстЭДОКлиент.ВосстановитьПозициюВТаблице(
			ПозицияВТаблице,
			Элементы.НастройкиОбмена,
			НастройкиОбмена,
			"ЭлементНастроекОбмена",
			"Организация");
	КонецЕсли;
	
	Если ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Результат.ТекущаяДатаНаСервере);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДействияДляЭлементаНастроекОбмена(ЭлементНастроекОбмена)
	
	ПоказыватьЗаявление = (ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус =
		ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отправлено")
		ИЛИ ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус =
		ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено")
		И НЕ ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_НастройкаЗавершена
		ИЛИ ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Статус =
		ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено"))
		И ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Дата <> Неопределено
		И ЭлементНастроекОбмена.ЗаявлениеАбонентаСпецоператораСвязи_Дата >= ТекущаяДатаОкончанияПоказаЗаявления;
	
	ПредлагатьПодключиться = (ЭлементНастроекОбмена.ВидОбменаСКонтролирующимиОрганами <>
		ПредопределенноеЗначение("Перечисление.ВидыОбменаСКонтролирующимиОрганами.ОбменВУниверсальномФормате")
		ИЛИ НЕ ЗначениеЗаполнено(ЭлементНастроекОбмена.УчетнаяЗаписьОбмена));
	
	ПоказыватьСертификат = ЭлементНастроекОбмена.СвойстваСертификатаРуководителя = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(ЭлементНастроекОбмена.ЛицензияДатаОкончания)
		ИЛИ ЗначениеЗаполнено(ЭлементНастроекОбмена.СвойстваСертификатаРуководителя.ДействителенПо)
		И ЭлементНастроекОбмена.СвойстваСертификатаРуководителя.ДействителенПо < ЭлементНастроекОбмена.ЛицензияДатаОкончания;
	
	ДействительныПо = ?(ПоказыватьСертификат,
		?(ЭлементНастроекОбмена.СвойстваСертификатаРуководителя <> Неопределено,
		ЭлементНастроекОбмена.СвойстваСертификатаРуководителя.ДействителенПо, Неопределено),
		ЭлементНастроекОбмена.ЛицензияДатаОкончания);
	Действительны = ЗначениеЗаполнено(ДействительныПо) И ДействительныПо > ТекущаяДатаИстечения;
	СертификатДействителен = ЭлементНастроекОбмена.СвойстваСертификатаРуководителя <> Неопределено
		И ЗначениеЗаполнено(ЭлементНастроекОбмена.СвойстваСертификатаРуководителя.ДействителенПо)
		И ЭлементНастроекОбмена.СвойстваСертификатаРуководителя.ДействителенПо > ТекущаяДатаИстечения;
	ЛицензияДействительна = ЗначениеЗаполнено(ЭлементНастроекОбмена.ЛицензияДатаОкончания)
		И ЭлементНастроекОбмена.ЛицензияДатаОкончания > ТекущаяДатаИстечения;
	
	Результат = Новый Структура;
	Результат.Вставить("ПоказыватьЗаявление", 		ПоказыватьЗаявление);
	Результат.Вставить("ПредлагатьПодключиться", 	ПредлагатьПодключиться);
	Результат.Вставить("ПоказыватьСертификат", 		ПоказыватьСертификат);
	Результат.Вставить("Действительны", 			Действительны);
	Результат.Вставить("СертификатДействителен", 	СертификатДействителен);
	Результат.Вставить("ЛицензияДействительна", 	ЛицензияДействительна);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ИзменитьПометкуУдаленияОрганизацииНаСервере(Организация)
	
	ОбъектОрганизация = Организация.ПолучитьОбъект();
	ОбъектОрганизация.Прочитать();
	ОбъектОрганизация.ПометкаУдаления = НЕ ОбъектОрганизация.ПометкаУдаления;
	ОбъектОрганизация.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаВыборПослеОбновленияНастроек(Результат, ДополнительныеПараметры) Экспорт
	
	Организация 				= ДополнительныеПараметры.Организация;
	ТипКонтролирующегоОргана 	= ДополнительныеПараметры.ТипКонтролирующегоОргана;
	
	ТекущаяДатаНаСервере = Результат;
	
	ЭлементНастроекОбмена = Неопределено;
	Для каждого СтрокаНастроекОбмена Из НастройкиОбмена Цикл
		Если СтрокаНастроекОбмена.ЭлементНастроекОбмена.Организация = Организация Тогда
			ЭлементНастроекОбмена = СтрокаНастроекОбмена.ЭлементНастроекОбмена;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ЭлементНастроекОбмена = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОКлиент.ОткрытьФормуПодключенияИлиНастройкиНаправленияСдачиОтчетности(
		ЭлементНастроекОбмена,
		ТипКонтролирующегоОргана,
		ТекущаяДатаНаСервере);
	
КонецПроцедуры

#КонецОбласти
