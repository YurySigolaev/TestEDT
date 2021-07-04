///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует и выводит на экран печатные формы.
// 
// Параметры:
//  ИмяМенеджераПечати - Строка - менеджер печати для печатаемых объектов;
//  ИменаМакетов       - Строка - идентификаторы печатных форм;
//  МассивОбъектов     - Ссылка, Массив - объекты печати;
//  ВладелецФормы      - ФормаКлиентскогоПриложения - форма, из которой выполняется печать;
//  ПараметрыПечати    - Структура - произвольные параметры для передачи в менеджер печати.
//
// Пример:
//   УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатнаяФорма", "СписаниеТоваров", ДокументыНаПечать, ЭтотОбъект);
//
Процедура ВыполнитьКомандуПечати(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ВладелецФормы, ПараметрыПечати = Неопределено) Экспорт
	
	Если НЕ ПроверитьКоличествоПереданныхОбъектов(МассивОбъектов) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати");
	ПараметрыОткрытия.ИмяМенеджераПечати = ИмяМенеджераПечати;
	ПараметрыОткрытия.ИменаМакетов		 = ИменаМакетов;
	ПараметрыОткрытия.ПараметрКоманды	 = МассивОбъектов;
	ПараметрыОткрытия.ПараметрыПечати	 = ПараметрыПечати;
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, ВладелецФормы, Строка(Новый УникальныйИдентификатор));
	
КонецПроцедуры

// Формирует и выводит на принтер печатные формы.
//
// Параметры:
//  ИмяМенеджераПечати - Строка - менеджер печати для печатаемых объектов;
//  ИменаМакетов       - Строка - идентификаторы печатных форм;
//  МассивОбъектов     - Ссылка, Массив - объекты печати;
//  ПараметрыПечати    - Структура - произвольные параметры для передачи в менеджер печати.
//
// Пример:
//   УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер("Обработка.ПечатнаяФорма", "СписаниеТоваров", ДокументыНаПечать);
//
Процедура ВыполнитьКомандуПечатиНаПринтер(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ПараметрыПечати = Неопределено) Экспорт

	// Проверим количество объектов.
	Если НЕ ПроверитьКоличествоПереданныхОбъектов(МассивОбъектов) Тогда
		Возврат;
	КонецЕсли;
	
	// Сформируем табличные документы.
#Если ТолстыйКлиентОбычноеПриложение Тогда
	ПечатныеФормы = УправлениеПечатьюВызовСервера.СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение(
			ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ПараметрыПечати);
	Если НЕ ПечатныеФормы.Отказ Тогда
		ОбъектыПечати = Новый СписокЗначений;
		Для Каждого ОбъектПечати Из ПечатныеФормы.ОбъектыПечати Цикл
			ОбъектыПечати.Добавить(ОбъектПечати.Значение, ОбъектПечати.Ключ);
		КонецЦикла;
		ПечатныеФормы.ОбъектыПечати = ОбъектыПечати;
	КонецЕсли;
#Иначе
	ПечатныеФормы = УправлениеПечатьюВызовСервера.СформироватьПечатныеФормыДляБыстройПечати(
			ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ПараметрыПечати);
#КонецЕсли
	
	Если ПечатныеФормы.Отказ Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Нет прав для вывода печатной формы на принтер, обратитесь к администратору.'"));
		Возврат;
	КонецЕсли;
	
	// Распечатаем
	РаспечататьТабличныеДокументы(ПечатныеФормы.ТабличныеДокументы, ПечатныеФормы.ОбъектыПечати);
	
КонецПроцедуры

// Вывести табличные документы на принтер.
//
// Параметры:
//  ТабличныеДокументы           - СписокЗначений - печатные формы.
//  ОбъектыПечати                - СписокЗначений - соответствие объектов именам областей табличного документа.
//  ПечататьКомплектами          - Булево, Неопределено - не используется (вычисляется автоматически).
//  КоличествоКопийКомплектов    - Число - количество экземпляров каждого из комплектов документов.
Процедура РаспечататьТабличныеДокументы(ТабличныеДокументы, ОбъектыПечати, Знач ПечататьКомплектами = Неопределено, 
	Знач КоличествоКопийКомплектов = 1) Экспорт
	
	ПечататьКомплектами = ТабличныеДокументы.Количество() > 1;
	ПакетОтображаемыхДокументов = УправлениеПечатьюВызовСервера.ПакетДокументов(ТабличныеДокументы,
		ОбъектыПечати, ПечататьКомплектами, КоличествоКопийКомплектов);
	ПакетОтображаемыхДокументов.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
	
КонецПроцедуры

// Выполняет интерактивное проведение документов перед печатью.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ОписаниеПроцедурыЗавершения - ОписаниеОповещения - процедура, в которую необходимо передать управление после
//                                                     выполнения.
//                                Параметры вызываемой процедуры:
//                                  СписокДокументов - Массив - проведенные документы;
//                                  ДополнительныеПараметры - значение, которое было указано при создании объекта
//                                                            оповещения.
//  СписокДокументов            - Массив            - ссылки на документы, которые требуется провести.
//  Форма                       - ФормаКлиентскогоПриложения  - форма, из которой было вызвана команда. Параметр
//                                                    требуется, когда процедура
//                                                    вызвана из формы объекта, для того чтобы перечитать форму.
Процедура ПроверитьПроведенностьДокументов(ОписаниеПроцедурыЗавершения, СписокДокументов, Форма = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеПроцедурыЗавершения", ОписаниеПроцедурыЗавершения);
	ДополнительныеПараметры.Вставить("СписокДокументов", СписокДокументов);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	НепроведенныеДокументы = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(СписокДокументов);
	ЕстьНепроведенныеДокументы = НепроведенныеДокументы.Количество() > 0;
	Если ЕстьНепроведенныеДокументы Тогда
		ДополнительныеПараметры.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
		УправлениеПечатьюСлужебныйКлиент.ПроверитьПроведенностьДокументовДиалогПроведения(ДополнительныеПараметры);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеПроцедурыЗавершения, СписокДокументов);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму ПечатьДокументов для коллекции табличных документов.
//
// Параметры:
//  КоллекцияПечатныхФорм - Массив - см. НоваяКоллекцияПечатныхФорм();
//  ОбъектыПечати - СписокЗначений - см. УправлениеПечатьюПереопределяемый.ПриПечати;
//  ДополнительныеПараметры - Структура - дополнительные параметры открытия формы печати. См. ПараметрыПечати().
//                          - ФормаКлиентскогоПриложения - форма, из которой выполняется печать;
//
Процедура ПечатьДокументов(КоллекцияПечатныхФорм, Знач ОбъектыПечати = Неопределено,
	ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыПечати = ПараметрыПечати();
	
	ВладелецФормы = Неопределено;
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыПечати, ДополнительныеПараметры);
		ВладелецФормы = ПараметрыПечати.ВладелецФормы;
		ПараметрыПечати.Удалить("ВладелецФормы");
	ИначеЕсли ТипЗнч(ДополнительныеПараметры) = Тип("ФормаКлиентскогоПриложения") Тогда 
		ВладелецФормы = ДополнительныеПараметры; // Поддержка обратной совместимости с 3.0.2.
	КонецЕсли;
	
	Если ОбъектыПечати = Неопределено Тогда
		ОбъектыПечати = Новый СписокЗначений;
	КонецЕсли;
	
	КлючУникальности = Строка(Новый УникальныйИдентификатор);
	
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати");
	ПараметрыОткрытия.ПараметрКоманды = Новый Массив;
	ПараметрыОткрытия.Вставить("КоллекцияПечатныхФорм", КоллекцияПечатныхФорм);
	ПараметрыОткрытия.Вставить("ОбъектыПечати", ОбъектыПечати);
	ПараметрыОткрытия.Вставить("ПараметрыПечати", ПараметрыПечати);
	
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, ВладелецФормы, КлючУникальности);
	
КонецПроцедуры

// Конструктор параметра ДополнительныеПараметры процедуры ПечатьДокументов.
//
//  Возвращаемое значение:
//   Структура - дополнительные параметры открытия формы печати:
//    * ВладелецФормы - ФормаКлиентскогоПриложения - форма, из которой выполняется печать.
//    * Заголовок     - Строка - Заголовок формы ПечатьДокументов.
//
Функция ПараметрыПечати() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ВладелецФормы");
	Результат.Вставить("ЗаголовокФормы");
	
	Возврат Результат;
	
КонецФункции

// Конструктор параметра КоллекцияПечатныхФорм для процедур и функций этого модуля.
// См. ПечатьДокументов()
// См. ОписаниеПечатнойФормы().
//
// Параметры:
//  Идентификаторы - Строка - идентификаторы печатных форм.
//
// Возвращаемое значение:
//  Массив - коллекция описаний печатных форм. Коллекция предназначена для использования в качестве
//           параметра КоллекцияПечатныхФорм в других процедурах клиентского программного интерфейса подсистемы.
//           Для обращения к элементам коллекции необходимо использовать функцию ОписаниеПечатнойФормы.
//
Функция НоваяКоллекцияПечатныхФорм(Знач Идентификаторы) Экспорт
	
	Если ТипЗнч(Идентификаторы) = Тип("Строка") Тогда
		Идентификаторы = СтрРазделить(Идентификаторы, ",");
	КонецЕсли;
	
	Поля = УправлениеПечатьюКлиентСервер.ИменаПолейКоллекцииПечатныхФорм();
	ДобавленныеПечатныеФормы = Новый Соответствие;
	Результат = Новый Массив;
	
	Для Каждого Идентификатор Из Идентификаторы Цикл
		ПечатнаяФорма = ДобавленныеПечатныеФормы[Идентификатор];
		Если ПечатнаяФорма = Неопределено Тогда
			ПечатнаяФорма = Новый Структура(СтрСоединить(Поля, ","));
			ПечатнаяФорма.ИмяМакета = Идентификатор;
			ПечатнаяФорма.ИмяВРЕГ = ВРег(Идентификатор);
			ПечатнаяФорма.Экземпляров = 1;
			ДобавленныеПечатныеФормы.Вставить(Идентификатор, ПечатнаяФорма);
			Результат.Добавить(ПечатнаяФорма);
		Иначе
			ПечатнаяФорма.Экземпляров = ПечатнаяФорма.Экземпляров + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает описание найденной в коллекции печатной формы.
// Если описание не найдено, возвращает Неопределено.
//
// Параметры:
//  КоллекцияПечатныхФорм - Массив - см. НоваяКоллекцияПечатныхФорм();
//  Идентификатор         - Строка - идентификатор печатной формы.
//
// Возвращаемое значение:
//  Структура - найденное описание печатной формы в коллекции печатных форм:
//   * СинонимМакета - Строка - представление печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатная форма;
//   * Экземпляров - Число - количество копий, которое необходимо вывести на печать;
//   * ПолныйПутьКМакету - Строка - используется для быстрого перехода к редактированию макета печатной формы;
//   * ИмяФайлаПечатнойФормы - Строка - имя файла;
//                           - Соответствие - имена файлов для каждого объекта:
//                              ** Ключ - ЛюбаяСсылка - ссылка на объект печати;
//                              ** Значение - Строка - имя файла;
//   * ОфисныеДокументы - Соответствие - коллекция печатных форм в формате офисных документов:
//                         ** Ключ - Строка - адрес во временном хранилище двоичных данных печатной формы;
//                         ** Значение - Строка - имя файла печатной формы.
//
Функция ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, Идентификатор) Экспорт
	Для Каждого ОписаниеПечатнойФормы Из КоллекцияПечатныхФорм Цикл
		Если ОписаниеПечатнойФормы.ИмяВРЕГ = ВРег(Идентификатор) Тогда
			Возврат ОписаниеПечатнойФормы;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

// Открывает форму выбора режима открытия макетов.
//
Процедура ЗадатьДействиеПриВыбореМакетаПечатнойФормы() Экспорт
	
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.ВыбораРежимаОткрытияМакета");
	
КонецПроцедуры

// Открывает форму с инструкцией как сделать факсимильную подпись и печать.
Процедура ПоказатьИнструкциюПоСозданиюФаксимильнойПодписиИПечати() Экспорт
	
	ВыполнитьКомандуПечати("РегистрСведений.ОбщиеПоставляемыеМакетыПечати", "ИнструкцияПоСозданиюФаксимильнойПодписиИПечати", 
		ПредопределенноеЗначение("Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка"), Неопределено, Новый Структура);
	
КонецПроцедуры

// Предназначена для использования в процедурах модуля УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументов<...>.
// Возвращает коллекцию параметров текущей печатной формы в форме "Печать документов" (ОбщаяФорма.ПечатьДокументов).
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма ПечатьДокументов, переданная в параметре Форма процедуры общего модуля
//                             УправлениеПечатьюКлиентПереопределяемый.
//
// Возвращаемое значение:
//  ДанныеФормыЭлементКоллекции - настройки текущей печатной формы.
//
Функция НастройкаТекущейПечатнойФормы(Форма) Экспорт
	Результат = Форма.Элементы.НастройкиПечатныхФорм.ТекущиеДанные;
	Если Результат = Неопределено И Форма.НастройкиПечатныхФорм.Количество() > 0 Тогда
		Результат = Форма.НастройкиПечатныхФорм[0];
	КонецЕсли;
	Возврат Результат;
КонецФункции

#Область УстаревшиеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с макетами офисных документов.

//	Секция содержит интерфейсные функции (API), используемые при создании
//	печатных форм основанных на офисных документах MS Office (шаблоны MS Word) и Open Office (шаблоны OO Writer).
//
////////////////////////////////////////////////////////////////////////////////
//	Типы используемых данных (определяется конкретными реализациями).
//	СсылкаПечатнаяФорма	- ссылка на печатную форму.
//	СсылкаМакет			- ссылка на макет.
//	Область				- ссылка на область в печатной форме или макете (структура)
//						доопределяется в интерфейсном модуле служебной информацией
//						об области.
//	ОписаниеОбласти			- описание области макета (см. ниже).
//	ДанныеЗаполнения		- либо структура, либо массив структур (для случая
//							списков и таблиц.
////////////////////////////////////////////////////////////////////////////////
//	ОписаниеОбласти - структура, описывающая подготовленные пользователем области макета
//	ключ ИмяОбласти - имя области
//	ключ ТипТипОбласти - 	ВерхнийКолонтитул.
//							НижнийКолонтитул
//							Общая
//							СтрокаТаблицы
//							Список
//

////////////////////////////////////////////////////////////////////////////////
// Функции инициализации и закрытия ссылок.

// Устарела. Следует использовать УправлениеПечатью.ИнициализироватьПечатнуюФорму.
//
// Создает соединение с выходной печатной формой.
// Необходимо вызвать перед любыми действиями над формой.
// Функция не работает в любых других браузерах кроме IE.
// Перед выполнением функции в веб-клиенте необходимо подключить расширение для работы с 1С:Предприятием.
//
// Параметры:
//  ТипДокумента            - Строка - тип печатной формы "DOC" или "ODT";
//  НастройкиСтраницыМакета - Соответствие - параметры из структуры, возвращаемой функцией ИнициализироватьМакет
//                                           (параметр устарел, его следует пропускать и использовать параметр Макет);
//  Макет                   - Структура - результат функции ИнициализироватьМакет.
//
// Возвращаемое значение:
//  Структура - новая печатная форма.
// 
Функция ИнициализироватьПечатнуюФорму(Знач ТипДокумента, Знач НастройкиСтраницыМакета = Неопределено, Макет = Неопределено) Экспорт
	
	Если ВРег(ТипДокумента) = "DOC" Тогда
		Параметр = ?(Макет = Неопределено, НастройкиСтраницыМакета, Макет); // для обратной совместимости
		ПечатнаяФорма = УправлениеПечатьюMSWordКлиент.ИнициализироватьПечатнуюФормуMSWord(Параметр);
		ПечатнаяФорма.Вставить("Тип", "DOC");
		ПечатнаяФорма.Вставить("ПоследняяВыведеннаяОбласть", Неопределено);
		Возврат ПечатнаяФорма;
	ИначеЕсли ВРег(ТипДокумента) = "ODT" Тогда
		ПечатнаяФорма = УправлениеПечатьюOOWriterКлиент.ИнициализироватьПечатнуюФормуOOWriter(Макет);
		ПечатнаяФорма.Вставить("Тип", "ODT");
		ПечатнаяФорма.Вставить("ПоследняяВыведеннаяОбласть", Неопределено);
		Возврат ПечатнаяФорма;
	КонецЕсли;
	
КонецФункции

// Устарела. Следует использовать УправлениеПечатью.ИнициализироватьМакетОфисногоДокумента.
//
// Создает COM-соединение с макетом. В дальнейшем это соединение используется при получении из него областей (тегов и
// таблиц).
// Функция не работает в любых других браузерах кроме IE.
// Перед выполнением функции в веб-клиенте необходимо подключить расширение для работы с 1С:Предприятием.
//
// Параметры:
//  ДвоичныеДанныеМакета - ДвоичныеДанные - двоичные данные макета;
//  ТипМакета            - Строка - тип макета печатной формы "DOC" или "ODT";
//  ИмяМакета            - Строка - имя, которое будет использовано при создании временного файла макета.
//
// Возвращаемое значение:
//  Структура - макет.
//
Функция ИнициализироватьМакетОфисногоДокумента(Знач ДвоичныеДанныеМакета, Знач ТипМакета, Знач ИмяМакета = "") Экспорт
	
	Макет = Неопределено;
	ИмяВременногоФайла = "";
	
	#Если ВебКлиент Тогда
		Если ПустаяСтрока(ИмяМакета) Тогда
			ИмяВременногоФайла = Строка(Новый УникальныйИдентификатор) + "." + НРег(ТипМакета);
		Иначе
			ИмяВременногоФайла = ИмяМакета + "." + НРег(ТипМакета);
		КонецЕсли;
	#КонецЕсли
	
	Если ВРег(ТипМакета) = "DOC" Тогда
		Макет = УправлениеПечатьюMSWordКлиент.ПолучитьМакетMSWord(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Если Макет <> Неопределено Тогда
			Макет.Вставить("Тип", "DOC");
		КонецЕсли;
	ИначеЕсли ВРег(ТипМакета) = "ODT" Тогда
		Макет = УправлениеПечатьюOOWriterКлиент.ПолучитьМакетOOWriter(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Если Макет <> Неопределено Тогда
			Макет.Вставить("Тип", "ODT");
			Макет.Вставить("НастройкиСтраницыМакета", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Макет;
	
КонецФункции

// Устарела. Следует использовать УправлениеПечатью.ОчиститьСсылки.
//
// Освобождает ссылки в созданном интерфейсе связи с офисным приложением.
// Необходимо вызывать каждый раз после завершения формирования макета и выводе печатной формы пользователю.
//
// Параметры:
//  ПечатнаяФорма     - Структура - результат функций ИнициализироватьПечатнуюФорму и ИнициализироватьМакетОфисногоДокумента;
//  ЗакрытьПриложение - Булево    - Истина, если требуется ли закрыть приложение.
//                                  Соединение с макетом требуется закрывать с закрытием приложения.
//                                  ПечатнуюФорму не требуется закрывать.
//
Процедура ОчиститьСсылки(ПечатнаяФорма, Знач ЗакрытьПриложение = Истина) Экспорт
	
	Если ПечатнаяФорма <> Неопределено Тогда
		Если ПечатнаяФорма.Тип = "DOC" Тогда
			УправлениеПечатьюMSWordКлиент.ЗакрытьСоединение(ПечатнаяФорма, ЗакрытьПриложение);
		Иначе
			УправлениеПечатьюOOWriterКлиент.ЗакрытьСоединение(ПечатнаяФорма, ЗакрытьПриложение);
		КонецЕсли;
		ПечатнаяФорма = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функция отображения печатной формы пользователю.

// Устарела. Более не требуется.
//
// Показывает сформированный документ пользователю.
//
// Параметры:
//  ПечатнаяФорма - Структура - результат функции ИнициализироватьПечатнуюФорму.
//
Процедура ПоказатьДокумент(Знач ПечатнаяФорма) Экспорт
	
	Если ПечатнаяФорма.Тип = "DOC" Тогда
		УправлениеПечатьюMSWordКлиент.ПоказатьДокументMSWord(ПечатнаяФорма);
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		УправлениеПечатьюOOWriterКлиент.ПоказатьДокументOOWriter(ПечатнаяФорма);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции получения областей из макета, вывода в печатную форму областей макета
// и заполнение параметров в них.

// Устарела. Следует использовать УправлениеПечатью.ОбластьМакета.
//
// Получает область из макета печатной формы.
//
// Параметры:
//  СсылкаНаМакет   - Структура - макет печатной формы.
//  ОписаниеОбласти - Структура - описание области:
//   * ИмяОбласти - Строка -имя области;
//   * ТипТипОбласти - Строка - тип области: "ВерхнийКолонтитул", "НижнийКолонтитул", "Общая", "СтрокаТаблицы", "Список".
//   
// Возвращаемое значение:
//  Структура - область макета.
//
Функция ОбластьМакета(Знач СсылкаНаМакет, Знач ОписаниеОбласти) Экспорт
	
	Область = Неопределено;
	Если СсылкаНаМакет.Тип = "DOC" Тогда
		
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьВерхнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьНижнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти, 1, 0);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти, 1, 0);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Тип области не указан или указан некорректно: %1.'"), ОписаниеОбласти.ТипОбласти);
		КонецЕсли;
		
		Если Область <> Неопределено Тогда
			Область.Вставить("ОписаниеОбласти", ОписаниеОбласти);
		КонецЕсли;
	ИначеЕсли СсылкаНаМакет.Тип = "ODT" Тогда
		
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьВерхнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьНижнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьМакета(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Тип области не указан или указан некорректно: %1.'"), ОписаниеОбласти.ИмяОбласти);
		КонецЕсли;
		
		Если Область <> Неопределено Тогда
			Область.Вставить("ОписаниеОбласти", ОписаниеОбласти);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Область;
	
КонецФункции

// Устарела. Следует использовать УправлениеПечатью.ПрисоединитьОбласть.
//
// Присоединяет область в печатную форму из макета.
// Применяется при одиночном выводе области.
//
// Параметры:
//  ПечатнаяФорма - Структура - печатная форма, см. ИнициализироватьПечатнуюФорму.
//  ОбластьМакета - см. ОбластьМакета.
//  ПереходНаСледующуюСтроку - Булево - Истина, если требуется вставить разрыв после вывода области.
//
Процедура ПрисоединитьОбласть(Знач ПечатнаяФорма, Знач ОбластьМакета, Знач ПереходНаСледующуюСтроку = Истина) Экспорт
	
	Если ОбластьМакета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ОписаниеОбласти = ОбластьМакета.ОписаниеОбласти;
		
		Если ПечатнаяФорма.Тип = "DOC" Тогда
			
			ВыведеннаяОбласть = Неопределено;
			
			Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
				УправлениеПечатьюMSWordКлиент.ДобавитьВерхнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
				УправлениеПечатьюMSWordКлиент.ДобавитьНижнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая" Тогда
				ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
				ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
				Если ПечатнаяФорма.ПоследняяВыведеннаяОбласть <> Неопределено
				   И ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "СтрокаТаблицы"
				   И НЕ ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ПереходНаСледующуюСтроку Тогда
					ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку, Истина);
				Иначе
					ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
				КонецЕсли;
			Иначе
				ВызватьИсключение ТекстТипОбластиУказанНекорректно();
			КонецЕсли;
			
			ОписаниеОбласти.Вставить("Область", ВыведеннаяОбласть);
			ОписаниеОбласти.Вставить("ПереходНаСледующуюСтроку", ПереходНаСледующуюСтроку);
			
			// Содержит тип области, и границы области (если требуется).
			ПечатнаяФорма.ПоследняяВыведеннаяОбласть = ОписаниеОбласти;
			
		ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
			Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
				УправлениеПечатьюOOWriterКлиент.ДобавитьВерхнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
				УправлениеПечатьюOOWriterКлиент.ДобавитьНижнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
					ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
				УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
				УправлениеПечатьюOOWriterКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
				УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
				УправлениеПечатьюOOWriterКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку, Истина);
			Иначе
				ВызватьИсключение ТекстТипОбластиУказанНекорректно();
			КонецЕсли;
			// Содержит тип области, и границы области (если требуется).
			ПечатнаяФорма.ПоследняяВыведеннаяОбласть = ОписаниеОбласти;
		КонецЕсли;
	Исключение
		СообщениеОбОшибке = СокрЛП(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		СообщениеОбОшибке = ?(Прав(СообщениеОбОшибке, 1) = ".", СообщениеОбОшибке, СообщениеОбОшибке + ".");
		СообщениеОбОшибке = СообщениеОбОшибке + " " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ошибка при попытке вывести область ""%1"" из макета.'"),
			ОбластьМакета.ОписаниеОбласти.ИмяОбласти);
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
КонецПроцедуры

// Устарела. Следует использовать УправлениеПечатью.ЗаполнитьПараметры.
//
// Заполняет параметры области печатной формы.
//
// Параметры:
//  ПечатнаяФорма - Структура - область печатной формы, либо сама печатная форма.
//  Данные - Структура - данные заполнения.
//
Процедура ЗаполнитьПараметры(Знач ПечатнаяФорма, Знач Данные) Экспорт
	
	ОписаниеОбласти = ПечатнаяФорма.ПоследняяВыведеннаяОбласть; // см. ОбластьМакета.ОписаниеОбласти
	
	Если ПечатнаяФорма.Тип = "DOC" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметрыВерхнегоКолонтитула(ПечатнаяФорма, Данные);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметрыНижнегоКолонтитула(ПечатнаяФорма, Данные);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметры(ОписаниеОбласти.Область, Данные);
		Иначе
			ВызватьИсключение ТекстТипОбластиУказанНекорректно();
		КонецЕсли;
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		Если		ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "ВерхнийКолонтитул" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаВерхнийКолонтитул(ПечатнаяФорма);
		ИначеЕсли	ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "НижнийКолонтитул" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаНижнийКолонтитул(ПечатнаяФорма);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
		КонецЕсли;
		УправлениеПечатьюOOWriterКлиент.ЗаполнитьПараметры(ПечатнаяФорма, Данные);
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры.
//
// Добавляет область в печатную форму из макета, при этом заменяя параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры:
//  ПечатнаяФорма - Структура - печатная форма, см. ИнициализироватьПечатнуюФорму.
//  ОбластьМакета - см. ОбластьМакета.
//  Данные - Структура - данные заполнения.
//  ПереходНаСледующуюСтроку - Булево - Истина, если требуется вставить разрыв после вывода области.
//
Процедура ПрисоединитьОбластьИЗаполнитьПараметры(Знач ПечатнаяФорма, Знач ОбластьМакета,
	Знач Данные, Знач ПереходНаСледующуюСтроку = Истина) Экспорт
	
	Если ОбластьМакета <> Неопределено Тогда
		ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
		ЗаполнитьПараметры(ПечатнаяФорма, Данные)
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать УправлениеПечатью.ПрисоединитьИЗаполнитьКоллекцию.
//
// Добавляет область в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры:
//  ПечатнаяФорма - Структура - печатная форма, см. ИнициализироватьПечатнуюФорму.
//  ОбластьМакета - см. ОбластьМакета().
//  Данные - Массив - коллекция элементов типа Структура - данные объекта.
//  ПереходНаСледСтроку - Булево - Истина, если требуется вставить разрыв после вывода области.
//
Процедура ПрисоединитьИЗаполнитьКоллекцию(Знач ПечатнаяФорма,
										Знач ОбластьМакета,
										Знач Данные,
										Знач ПереходНаСледСтроку = Истина) Экспорт
	Если ОбластьМакета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОбласти = ОбластьМакета.ОписаниеОбласти;
	
	Если ПечатнаяФорма.Тип = "DOC" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			УправлениеПечатьюMSWordКлиент.ПрисоединитьИЗаполнитьОбластьТаблицы(ПечатнаяФорма, ОбластьМакета, Данные, ПереходНаСледСтроку);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюMSWordКлиент.ПрисоединитьИЗаполнитьНабор(ПечатнаяФорма, ОбластьМакета, Данные, ПереходНаСледСтроку);
		Иначе
			ВызватьИсключение ТекстТипОбластиУказанНекорректно();
		КонецЕсли;
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			УправлениеПечатьюOOWriterКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, ОбластьМакета, Данные, Истина, ПереходНаСледСтроку);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюOOWriterКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, ОбластьМакета, Данные, Ложь, ПереходНаСледСтроку);
		Иначе
			ВызватьИсключение ТекстТипОбластиУказанНекорректно();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать УправлениеПечатью.ВставитьРазрывНаНовуюСтроку.
//
// Вставляет разрыв между строками в виде символа перевода строки.
//
// Параметры:
//  ПечатнаяФорма - Структура - печатная форма, см. ИнициализироватьПечатнуюФорму.
//
Процедура ВставитьРазрывНаНовуюСтроку(Знач ПечатнаяФорма) Экспорт
	
	Если	  ПечатнаяФорма.Тип = "DOC" Тогда
		УправлениеПечатьюMSWordКлиент.ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		УправлениеПечатьюOOWriterКлиент.ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму диалога загрузки файла макета для редактирования во внешней программе.
Процедура РедактироватьМакетВоВнешнейПрограмме(ОписаниеОповещения, ПараметрыМакета, Форма) Экспорт
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.РедактированиеМакета", ПараметрыМакета, Форма, , , , ОписаниеОповещения);
КонецПроцедуры

// Конструктор параметра НастройкиСохранения функции УправлениеПечатью.НапечататьВФайл.
// Определяет формат и другие настройки записи табличного документа в файл.
// 
// Возвращаемое значение:
//  Структура - настройки записи табличного документа в файл:
//   * ФорматыСохранения - Массив - коллекция значений типа ТипФайлаТабличногоДокумента, преобразованных в строку;
//   * УпаковатьВАрхив   - Булево - если установить значение Истина, будет создан один файл архива с файлами указанных форматов;
//   * ПереводитьИменаФайловВТранслит - Булево - если установить Истина, то имена полученных файлов будут на латинице.
//   * ПодписьИПечать    - Булево - если установить Истина и сохраняемый табличный документ поддерживает размещение
//                                  подписей и печатей, то в записанных файлах будут размещены подписи и печати.
//
Функция НастройкиСохранения() Экспорт
	
	Возврат УправлениеПечатьюКлиентСервер.НастройкиСохранения();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Перед выполнением команды печати проверить, был ли передан хотя бы один объект, так как
// для команд с множественным режимом использования может быть передан пустой массив.
Функция ПроверитьКоличествоПереданныхОбъектов(ПараметрКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ТекстТипОбластиУказанНекорректно()
	Возврат НСтр("ru = 'Тип области не указан или указан некорректно.'");
КонецФункции

#КонецОбласти
