///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	Настройки.Алгоритмы.НастроитьИнтерактивнуюВыгрузку = Истина;
	Настройки.Алгоритмы.ПредставлениеОтбораИнтерактивнойВыгрузки = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "УправлениеПроизводственнымПредприятием";
	Синоним = НСтр("ru = '1С:Управление производственным предприятием, ред. 1.3'");
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = "Настройки обмена ДО-УПП";
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = 
		НСтр("ru = 'Позволяет синхронизировать данные между конфигурациями ""1С:Управление производственным предприятием"" и ""1С:Документооборот"".
		|Синхронизация данных выполняется в двустороннем режиме на уровне справочной информации.'");
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "";
	Иначе
		ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.ОбменУправлениеПроизводственнымПредприятиемДокументооборот20.Форма.ПодробнаяИнформация";
	КонецЕсли;
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = Синоним;
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = Синоним;
	ОписаниеВарианта.ЗаголовокУзлаПланаОбмена = Синоним;
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = Синоним;
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена =
		СтрШаблон(НСтр("ru = 'Синхронизация данных с конфигурацией %1 (настройка)'"), Синоним);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая настройка дополнения выгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Используется для контроля режимов работы помощника интерактивного обмена данными.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Cтрока            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Cтрока            - Заголовок для отрисовки на форме команды открытия формы настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно  использовать специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки, предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле "Ссылка.Организация"
//
//
//     Если для всех вариантов флаги разрешения использования установлены в Ложь, то страница дополнения выгрузки в помощнике
//     интерактивного обмена данными будет пропущена и дополнительная регистрация объектов производится не будет. Например, инициализация вида:
//
//          Параметры.ВариантВсеДокументы.Использование      = Ложь;
//          Параметры.ВариантБезДополнения.Использование     = Ложь;
//          Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
//          Параметры.ВариантДополнительно.Использование     = Ложь;
//
//     Приведет к тому, что шаг дополнения выгрузки будет полностью пропущен.
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	Параметры.ВариантВсеДокументы.Использование      = Ложь;
	Параметры.ВариантБезДополнения.Использование     = Ложь;
	Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
	Параметры.ВариантДополнительно.Использование     = Ложь;
	
КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку"
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Могут быть использованы специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", будет использовано поле "Ссылка.Организация"
//
// Возвращаемое значение: 
//     Строка - описание отбора
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	Возврат "";
	
КонецФункции

// Конец СтандартныеПодсистемы.ОбменДанными

#КонецОбласти

#КонецОбласти

#КонецЕсли