#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак наличия метода ИзменитьРеквизитыНевыполненныхЗадач
//
Функция ЕстьМетодИзменитьРеквизитыНевыполненныхЗадач() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Заполняет бизнес-процесс на основании проектной задачи
//
Процедура ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения) Экспорт 
	
	Проект = ДанныеЗаполнения.Владелец;
	ПроектнаяЗадача = ДанныеЗаполнения;
	НаименованиеПоУмолчанию = МультипредметностьКлиентСервер.ПолучитьНаименованиеСПредметами(
		НСтр("ru = 'Обработка входящего'"), Предметы);
	
	Если Не ЗначениеЗаполнено(Наименование) Или Наименование = НаименованиеПоУмолчанию Тогда
		Наименование = ПроектнаяЗадача.Наименование;
	КонецЕсли;
	
	Если Предметы.Количество() = 0 Тогда 
		Предмет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроектнаяЗадача, "Предмет");
		
		Если Предмет <> Неопределено И Предметы.Найти(Предмет,"Предмет") = Неопределено Тогда
			СтрокаПредметов = Предметы.Добавить();
			СтрокаПредметов.РольПредмета = Перечисления.РолиПредметов.Основной;
			СтрокаПредметов.ИмяПредмета =  МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(
				Предмет, Предметы.ВыгрузитьКолонку("ИмяПредмета"));
			СтрокаПредметов.Предмет = Предмет;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры	

#КонецОбласти

#Область ПрограммныйИнтерфейс_Предметы

// Проверяет права участников процесса на предметы этого процесса.
// Если у участников процесса отсутствуют права на предметы, то выводятся сообщения с привязкой
// к карточке процесса.
//
// Параметры
//  ПроцессОбъект - БизнесПроцессОбъект - процесс.
//  Отказ - Булево - в этот параметр помещается значение Истина, если кто-то из участников не имеет
//                   прав на предметы.
//  ПроверятьПриИзменении - Булево - если указано значение Истина, то проверка выполняется только если
//                          изменены участники или предметы процесса, иначе проверка выполняется всегда.
//
Процедура ПроверитьПраваУчастниковПроцессаНаПредметы(
	ПроцессОбъект, Отказ, ПроверятьПриИзменении) Экспорт
	
	Мультипредметность.ПроверитьПраваУчастниковПроцессаНаПредметы(
		ПроцессОбъект, Отказ, ПроверятьПриИзменении);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//Код процедур и функций
#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	ДатаНачала = '00010101';
	ДатаЗавершения = '00010101';
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт 
	
	Если ЭтоНовый() Тогда 
		Дата = ТекущаяДатаСеанса();
		Если Не ЗначениеЗаполнено(Автор) Тогда
			Автор = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения, Ложь, Истина);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ЗадачаСсылка = ДанныеЗаполнения;
		ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ДанныеЗаполнения.Шаблон, ЭтотОбъект);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Предметы") Тогда
			Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения.Предметы, Ложь, Истина);
			Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			ЗаполнитьПоШаблону(ДанныеЗаполнения.Шаблон);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗадачаИсполнителя") Тогда
			ЗадачаСсылка = ДанныеЗаполнения.ЗадачаИсполнителя;
			ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ПроектнаяЗадача") Тогда
			ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения.ПроектнаяЗадача);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда 
		ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) И Предметы.Количество() > 0 Тогда
		МультипредметностьКлиентСервер.ЗаполнитьНаименованиеПроцесса(ЭтотОбъект, НСтр("ru = 'Обработка входящего'"));
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Мультипредметность.ПроверитьКорректностьТиповОсновныхПредметов(ЭтотОбъект, Отказ);
	
	Если Не ЗначениеЗаполнено(ШаблонРассмотрения) И Не ЗначениеЗаполнено(ШаблонИсполненияОзнакомления) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите шаблон рассмотрения или шаблон исполнения.'"),,,,Отказ);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ШаблонРассмотрения) И Не ЗначениеЗаполнено(ШаблонРассмотрения.Исполнитель) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'В шаблоне рассмотрения не указан исполнитель.'"), ЭтотОбъект, "ШаблонРассмотрения",,Отказ);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ШаблонИсполненияОзнакомления) И ШаблонИсполненияОзнакомления.Исполнители.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'В шаблоне исполнения (ознакомления) не указаны исполнители.'"), ЭтотОбъект, "ШаблонИсполненияОзнакомления",,Отказ);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ШаблонПоручения) И Не ЗначениеЗаполнено(ШаблонПоручения.Исполнитель) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'В шаблоне поручения не указан исполнитель.'"), ЭтотОбъект, "ШаблонПоручения",,Отказ);
	КонецЕсли;
	
	// Проверка прав участников процесса на предметы
	Если Не РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		
		ПроверитьПраваУчастниковПроцессаНаПредметы(ЭтотОбъект, Отказ, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбычнаяЗапись = Истина;
	ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов = Ложь;
	
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		
		ОбычнаяЗапись = Ложь;
		
		ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов = 
			(ДополнительныеСвойства.ВидЗаписи = 
			"ЗаписьСОбновлением_Предметов_ПредметовЗадач_Проекта_ОбщегоСпискаПроцессов_РабочихГруппПредметов_РабочихГруппПроцессов_ДопРеквизитовПоПредметам");
		
		Если Не ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбычнаяЗапись Тогда
		
		ПредыдущаяПометкаУдаления = Ложь;
		Если Не Ссылка.Пустая() Тогда
			ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
		КонецЕсли;
		ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
		
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		КонецЕсли;
		
		Если Не РаботаСБизнесПроцессамиВызовСервера.ПроверитьПередЗаписью(ЭтотОбъект) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбычнаяЗапись Или ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов Тогда
		
		// Обработка рабочей группы	
		РаботаСБизнесПроцессамиВызовСервера.СформироватьРабочуюГруппу(ЭтотОбъект);
		
		// Заполнение табличной части ПредметыЗадач
		Мультипредметность.ЗаполнитьПредметыТочекВложенныхПроцессов(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

// рассмотрение
Процедура НаРассмотрениеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЗначениеЗаполнено(ШаблонРассмотрения);
	
КонецПроцедуры

Процедура РассмотрениеПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	РассмотрениеОбъект = БизнесПроцессы.Рассмотрение.СоздатьБизнесПроцесс();
	
	РассмотрениеОбъект.Дата = ТекущаяДатаСеанса();
	РассмотрениеОбъект.Автор = Автор;
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонРассмотрения, РассмотрениеОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(РассмотрениеОбъект, ЭтотОбъект, Ложь, Истина);
	
	РассмотрениеОбъект.Проект = Проект;
	РассмотрениеОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
	РассмотрениеОбъект.ЗаполнитьПоШаблону(ШаблонРассмотрения);
	РассмотрениеОбъект.Состояние = Состояние;
	
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЭтотОбъект, РассмотрениеОбъект);
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = 
		СрокиИсполненияПроцессов.ДатаОтсчетаДляНовогоДействияСоставногоПроцесса(Ссылка);
	
	СрокиИсполненияПроцессов.РассчитатьСрокиРассмотрения(РассмотрениеОбъект, ПараметрыДляРасчетаСроков);
	
	РассмотрениеСсылка = БизнесПроцессы.Рассмотрение.ПолучитьСсылку();
	РассмотрениеОбъект.УстановитьСсылкуНового(РассмотрениеСсылка);
	
	// Проверка прав участников процесса на предметы
	Если РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		// Проверяем права, если процесс создается/выполняется в рег. задании.
		// В интерактивном режим проверка произойдет в обработчике проверки заполнения подчиненного процесса.
		МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(ЭтотОбъект, Автор);
	КонецЕсли;
	
	Рассмотрение = РассмотрениеСсылка;
	
	РаботаСБизнесПроцессами.ЗаписатьПроцесс(ЭтотОбъект, "ПростаяЗапись");
	
	ФормируемыеБизнесПроцессы.Добавить(РассмотрениеОбъект);
	
КонецПроцедуры

Процедура РассмотрениеПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	МассивПредметов = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(ЭтотОбъект);
	СтрокаПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(МассивПредметов, Истина, Ложь);
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ведущая задача - Рассмотреть %1'",
				ЛокализацияКонфигурации.КодЯзыкаИсполнителяЗадачи(Задача)),
			СтрокаПредметов);
		Задача.Автор = Автор;
		Задача.Проект = Проект;
		Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	КонецЦикла;	
		
КонецПроцедуры

Процедура РассмотреноПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = БизнесПроцессы.Рассмотрение.ПроцессЗавершилсяУдачно(Рассмотрение);
	
КонецПроцедуры

// исполнение
Процедура ИсполнениеОзнакомлениеПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	МассивПредметов = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(ЭтотОбъект);
	СтрокаПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(МассивПредметов, Истина, Ложь);
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Если ТипЗнч(ШаблонИсполненияОзнакомления) = Тип("СправочникСсылка.ШаблоныИсполнения") Тогда  
			Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ведущая задача - Исполнить %1'",
					ЛокализацияКонфигурации.КодЯзыкаИсполнителяЗадачи(Задача)),
				СтрокаПредметов);
		ИначеЕсли ТипЗнч(ШаблонИсполненияОзнакомления) = Тип("СправочникСсылка.ШаблоныОзнакомления") Тогда 
			Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ведущая задача - Ознакомиться %1'",
					ЛокализацияКонфигурации.КодЯзыкаИсполнителяЗадачи(Задача)),
				СтрокаПредметов);
		КонецЕсли;	
		Задача.Автор = Автор;
		Задача.Проект = Проект;
		Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	КонецЦикла;
	
КонецПроцедуры

Процедура ИсполнениеОзнакомлениеПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	Если ЗначениеЗаполнено(ШаблонРассмотрения) Тогда  
		
		Если Рассмотрение.ВариантРассмотрения = Перечисления.ВариантыРассмотрения.НаправитьНаИсполнение Тогда 
			ИсполнениеОзнакомлениеОбъект = БизнесПроцессы.Исполнение.СоздатьБизнесПроцесс();
			
		ИначеЕсли Рассмотрение.ВариантРассмотрения = Перечисления.ВариантыРассмотрения.НаправитьНаОзнакомление Тогда 
			ИсполнениеОзнакомлениеОбъект = БизнесПроцессы.Ознакомление.СоздатьБизнесПроцесс();
			
		ИначеЕсли Рассмотрение.ВариантРассмотрения = Перечисления.ВариантыРассмотрения.ВвестиТекстРезолюции Тогда 
			
			Если Рассмотрение.ВариантОбработкиРезолюции = Перечисления.ВариантыОбработкиРезолюции.НаправитьНаИсполнение Тогда 
				ИсполнениеОзнакомлениеОбъект = БизнесПроцессы.Исполнение.СоздатьБизнесПроцесс();
			ИначеЕсли Рассмотрение.ВариантОбработкиРезолюции = Перечисления.ВариантыОбработкиРезолюции.НаправитьНаОзнакомление Тогда 
				ИсполнениеОзнакомлениеОбъект = БизнесПроцессы.Ознакомление.СоздатьБизнесПроцесс();
			КонецЕсли;
				
		КонецЕсли;
		
		ИсполнениеОзнакомлениеОбъект.Дата = ТекущаяДатаСеанса();
		ИсполнениеОзнакомлениеОбъект.ЗаполнитьПоРассмотрению(Рассмотрение);
		ИсполнениеОзнакомлениеОбъект.Состояние = Состояние;
		РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЭтотОбъект, ИсполнениеОзнакомлениеОбъект);
		
		// Проверка прав участников процесса на предметы
		Если РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
			// Проверяем права, если процесс создается/выполняется в рег. задании.
			// В интерактивном режим проверка произойдет в обработчике проверки заполнения подчиненного процесса.
			МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(ЭтотОбъект, Автор);
		КонецЕсли;
		
		ФормируемыеБизнесПроцессы.Добавить(ИсполнениеОзнакомлениеОбъект);
		
	Иначе	
		
		Если ТипЗнч(ШаблонИсполненияОзнакомления) = Тип("СправочникСсылка.ШаблоныИсполнения") Тогда 
			ИсполнениеОзнакомлениеОбъект = БизнесПроцессы.Исполнение.СоздатьБизнесПроцесс();
			НаименованиеПоУмолчанию = НСтр("ru = 'Исполнить'");
		ИначеЕсли ТипЗнч(ШаблонИсполненияОзнакомления) = Тип("СправочникСсылка.ШаблоныОзнакомления") Тогда 
			ИсполнениеОзнакомлениеОбъект = БизнесПроцессы.Ознакомление.СоздатьБизнесПроцесс();
			НаименованиеПоУмолчанию = НСтр("ru = 'Ознакомиться'");
		КонецЕсли;
		
		ИсполнениеОзнакомлениеОбъект.Дата = ТекущаяДатаСеанса();
		ИсполнениеОзнакомлениеОбъект.Автор = Автор;
		
		Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонИсполненияОзнакомления, ИсполнениеОзнакомлениеОбъект);
		Мультипредметность.ПередатьПредметыПроцессу(ИсполнениеОзнакомлениеОбъект, ЭтотОбъект, Ложь, Истина);
		
		ИсполнениеОзнакомлениеОбъект.Проект = Проект;
		ИсполнениеОзнакомлениеОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
		ИсполнениеОзнакомлениеОбъект.ЗаполнитьПоШаблону(ШаблонИсполненияОзнакомления);
		ИсполнениеОзнакомлениеОбъект.Состояние = Состояние;
		
		ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
		ПараметрыДляРасчетаСроков.ДатаОтсчета = 
			СрокиИсполненияПроцессов.ДатаОтсчетаДляНовогоДействияСоставногоПроцесса(Ссылка);
		
		Если ТипЗнч(ШаблонИсполненияОзнакомления) = Тип("СправочникСсылка.ШаблоныИсполнения") Тогда 
			СрокиИсполненияПроцессов.РассчитатьСрокиПроцессаИсполнения(ИсполнениеОзнакомлениеОбъект, ПараметрыДляРасчетаСроков);
		ИначеЕсли ТипЗнч(ШаблонИсполненияОзнакомления) = Тип("СправочникСсылка.ШаблоныОзнакомления") Тогда 
			СрокиИсполненияПроцессов.РассчитатьСрокиОзнакомления(ИсполнениеОзнакомлениеОбъект, ПараметрыДляРасчетаСроков);
		КонецЕсли;
		
		РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЭтотОбъект, ИсполнениеОзнакомлениеОбъект);
		
		// Проверка прав участников процесса на предметы
		Если РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
			// Проверяем права, если процесс создается/выполняется в рег. задании.
			// В интерактивном режим проверка произойдет в обработчике проверки заполнения подчиненного процесса.
			МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(ЭтотОбъект, Автор);
		КонецЕсли;
		
		ФормируемыеБизнесПроцессы.Добавить(ИсполнениеОзнакомлениеОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

// в дело
Процедура ПоместитьВДелоПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЗначениеЗаполнено(ШаблонПоручения);
	
КонецПроцедуры

Процедура ВДелоПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	ПоручениеОбъект = БизнесПроцессы.Поручение.СоздатьБизнесПроцесс();
	
	ПоручениеОбъект.Дата = ТекущаяДатаСеанса();
	ПоручениеОбъект.Автор = Автор;
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонПоручения, ПоручениеОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(ПоручениеОбъект, ЭтотОбъект, Ложь, Истина);
	
	ПоручениеОбъект.Проект = Проект;
	ПоручениеОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
	ПоручениеОбъект.ЗаполнитьПоШаблону(ШаблонПоручения);
	ПоручениеОбъект.Состояние = Состояние;
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЭтотОбъект, ПоручениеОбъект);
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = 
		СрокиИсполненияПроцессов.ДатаОтсчетаДляНовогоДействияСоставногоПроцесса(Ссылка);
	
	СрокиИсполненияПроцессов.РассчитатьСрокиПоручения(ПоручениеОбъект, ПараметрыДляРасчетаСроков);
	
	// Проверка прав участников процесса на предметы
	Если РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		// Проверяем права, если процесс создается/выполняется в рег. задании.
		// В интерактивном режим проверка произойдет в обработчике проверки заполнения подчиненного процесса.
		МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(ЭтотОбъект, Автор);
	КонецЕсли;
	
	ФормируемыеБизнесПроцессы.Добавить(ПоручениеОбъект);
	
КонецПроцедуры

Процедура ВДелоПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	МассивПредметов = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(ЭтотОбъект);
	СтрокаПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(МассивПредметов, Истина, Ложь);
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ведущая задача - Поместить в дело %1'",
				ЛокализацияКонфигурации.КодЯзыкаИсполнителяЗадачи(Задача)), 
			СтрокаПредметов);
		Задача.Автор = Автор;
		Задача.Проект = Проект;
		Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

Процедура ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка)
	
	РаботаСБизнесПроцессами.ЗаполнитьБизнесПроцессПоЗадаче(ЭтотОбъект, ЗадачаСсылка);
	
КонецПроцедуры

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//
Процедура ЗаполнитьПоШаблону(ШаблонБизнесПроцесса) Экспорт
	
	ШаблоныБизнесПроцессов.ЗаполнитьПоШаблонуСоставногоБизнесПроцесса(ШаблонБизнесПроцесса, ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ШаблонДляОтложенногоСтарта", ШаблонБизнесПроцесса);
	
КонецПроцедуры

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса, предмета и автора.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//  Предмет - предмет бизнес-процесса
//  Автор  - автор
//
Процедура ЗаполнитьПоШаблонуИПредмету(ШаблонБизнесПроцесса, ПредметСобытия, АвторСобытия) Экспорт
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонБизнесПроцесса, ЭтотОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ПредметСобытия, Ложь, Истина);
	ЗаполнитьПоШаблону(ШаблонБизнесПроцесса);
	
	Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ПредметСобытия);
	
	Дата = ТекущаяДатаСеанса();
	Автор = АвторСобытия;
	
КонецПроцедуры	

// Возвращает описание задачи, специфичное для бизнес-процесса
Функция ПолучитьОписаниеУведомленияЗадачи(Задача, КодЯзыкаПолучателя) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы со стартом процесса

Процедура ОтложенныйСтарт() Экспорт
	
	СтартПроцессовСервер.СтартоватьПроцессОтложенно(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОтключитьОтложенныйСтарт() Экспорт
	
	СтартПроцессовСервер.ОтключитьОтложенныйСтарт(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для поддержки комплексных процессов

// Формирует шаблон по процессу
// Параметры:
//	ВладелецШаблона - ссылка на шаблон комплексного процесса или комплексный процесс, который будет владельцем
//		создаваемого шаблона процесса
// Возвращает:
//	Ссылка на созданный шаблон
Функция СоздатьШаблонПоПроцессу(ВладелецШаблона = Неопределено) Экспорт
	
	ШаблонОбъект = Шаблон.ПолучитьОбъект().Скопировать();
	ШаблонОбъект.ВладелецШаблона = ВладелецШаблона;	
	ШаблонОбъект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	ШаблонОбъект.Записать();
	Возврат ШаблонОбъект.Ссылка;
			
КонецФункции

// Дополняет описание процесса общим описанием
Процедура ДополнитьОписание(ОбщееОписание) Экспорт	
КонецПроцедуры

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;
	Возврат МассивПолей;
	
КонецФункции	

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;	
	
	СтартПроцессовСервер.ПроцессПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецЕсли