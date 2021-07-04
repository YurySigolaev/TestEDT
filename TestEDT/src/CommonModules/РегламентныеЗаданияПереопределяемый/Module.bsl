///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций;
//  - возможность выполнения в различных режимах работы программы;
//  - прочие параметры.
//
// Параметры:
//  Настройки - ТаблицаЗначений - таблица значений с колонками:
//    * РегламентноеЗадание - ОбъектМетаданныхРегламентноеЗадание - регламентное задание.
//    * ФункциональнаяОпция - ОбъектМетаданныхФункциональнаяОпция - функциональная опция,
//        от которой зависит регламентное задание.
//    * ЗависимостьПоИ      - Булево - если регламентное задание зависит более чем
//        от одной функциональной опции и его необходимо включать только тогда,
//        когда все функциональные опции включены, то следует указывать Истина
//        для каждой зависимости.
//        По умолчанию Ложь - если хотя бы одна функциональная опция включена,
//        то регламентное задание тоже включено.
//    * ВключатьПриВключенииФункциональнойОпции - Булево, Неопределено - если Ложь, то при
//        включении функциональной опции регламентное задание не будет включаться. Значение
//        Неопределено соответствует значению Истина.
//        По умолчанию - Неопределено.
//    * ДоступноВПодчиненномУзлеРИБ - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в РИБ.
//        По умолчанию - Неопределено.
//    * ДоступноВАвтономномРабочемМесте - Булево, Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в автономном рабочем месте.
//        По умолчанию - Неопределено.
//    * ДоступноВМоделиСервиса - Булево, Неопределено - Ложь, если необходимо блокировать выполнение регламентного
//        задания (в т.ч. задания очереди) в информационной базе с включенным использованием разделителя.
//        Значение Неопределено трактуется как Истина.
//        По умолчанию - Неопределено.
//    * РаботаетСВнешнимиРесурсами  - Булево - Истина, если регламентное задание модифицирует данные
//        во внешних источниках (получение почты, синхронизация данных и т.п.). Не следует устанавливать
//        значение Истина для регламентных заданий, не модифицирующих данные во внешних источниках.
//        Например, регламентное задание ЗагрузкаКурсовВалют. Регламентные задания, работающие с внешними ресурсами,
//        автоматически отключаются в копии информационной базы. По умолчанию - Ложь.
//    * Параметризуется             - Булево - Истина, если регламентное задание параметризованное.
//        По умолчанию - Ложь.
//
// Пример:
//	Настройка = Настройки.Добавить();
//	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеСтатусовДоставкиSMS;
//	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
//	Настройка.ДоступноВМоделиСервиса = Ложь;
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	Если Настройки.Колонки.Найти("ОчередьЗаданийВМоделиСервиса") = Неопределено Тогда
		Настройки.Колонки.Добавить("ОчередьЗаданийВМоделиСервиса", Новый ОписаниеТипов("Число")); // 0 - выполняется в своем процессе; > 1 - выполняется в процессе общего задания с соответствующим приоритетом; -1 - порядок выполнения определяется своими средствами.  
		Настройки.Колонки.Добавить("ПараллельноеВыполнениеВМоделиСервиса", Новый ОписаниеТипов("Булево")); // Для каждой области запускается свое фоновое задание.
		Настройки.Колонки.Добавить("ФункциональныйРазделительВМоделиСервиса"); // ФО, Константа, Имя функции, определяющая перечень областей, для которых необходим запуск обработчика. Для исключения холостого выполнения. Константа должна входить в ОбластьДанныхВспомогательныеДанные. ФО должна хранится в константе.
		Настройки.Колонки.Добавить("ХранениеПользователяВМоделиСервиса"); // Истина - рег.задание хранит имя пользователя для запуска; Константа - пользователя для запуска необходимо получать из константы.  
	КонецЕсли;
	
	// Права доступа
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ДокументооборотОбновлениеПравДоступаДолгое;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ДокументооборотИспользоватьОграничениеПравДоступа;
	Настройка.ЗависимостьПоИ = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ДокументооборотОбновлениеПравДоступаДолгое;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ДокументооборотИспользоватьОтложенноеОбновлениеПравДоступа;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ДокументооборотОбновлениеПравДоступаОперативное;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ДокументооборотИспользоватьОграничениеПравДоступа;
	Настройка.ЗависимостьПоИ = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ДокументооборотОбновлениеПравДоступаОперативное;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ДокументооборотИспользоватьОтложенноеОбновлениеПравДоступа;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбработкаПравилДелегированияПрав;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ДокументооборотИспользоватьОграничениеПравДоступа;
	
	// Уведомления
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольОкончанияСрокаДействия;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьУведомленияПользователя;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСрокаЗадач;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьУведомленияПользователя;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСрокаЗадач;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьБизнесПроцессыИЗадачи;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСроковЗаявокНаОплату;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВидыВнутреннихДокументов;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольПредоставленияАвансовыхОтчетов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВидыВнутреннихДокументов;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УведомлениеПользователейОСобытиях;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьУведомленияПользователя;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	//  Бизнес события
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбработкаПроизошедшихБизнесСобытий;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьБизнесСобытия;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбработкаДетекторовБизнесСобытий;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьБизнесСобытия;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	// Выполнение задач по почте.
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ВыполнениеЗадачПоПочте;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВыполнениеЗадачПоПочте;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ВыполнениеЗадачПоПочте;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьУведомленияПользователя;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ЗависимостьПоИ = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ВыполнениеЗадачПоПочте;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьБизнесПроцессыИЗадачи;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ЗависимостьПоИ = Истина;
	
	// Контроль срока контрольных точек.
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСрокаКонтрольныхТочек;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьУведомленияПользователя;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСрокаКонтрольныхТочек;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьКонтрольныеТочки;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСрокаКонтроля;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьКонтрольОбъектов;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСрокаКонтроля;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьУведомленияПользователя;
	Настройка.ЗависимостьПоИ = Истина;
	
	// Обмен с мобильным
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбменСМобильнымиРегистрацияИзменений;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьМобильныеКлиенты;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбменСМобильнымиУдалениеСообщенийИнтегрированныхСистем;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьМобильныеКлиенты;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 9;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбменСМобильнымиУдалениеСтарыхЗаписейПротокола;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьМобильныеКлиенты;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 9;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;

	// push-уведомления
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаPushУведомлений;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьPushУведомления;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СозданиеPushУведомленийОНовыхПисьмах;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьPushУведомления;
	Настройка.ЗависимостьПоИ = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	// Встроенная почта
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗаполнениеДанныхДляПоискаПисем;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаПисем;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаПисемПоВнутреннейМаршрутизации;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемПисемПоВнутреннейМаршрутизацииБыстрый;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемПисемПоВнутреннейМаршрутизацииДолгий;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты1;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты2;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты3;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты4;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты5;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты6;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты7;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты8;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты9;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемОтправкаПочты10;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ХранениеПользователяВМоделиСервиса = Метаданные.Константы.ПользовательРегламентногоЗаданияПолучениеИОтправкаПисем;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПроверкаРаботыПриемкиПочты;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьВстроеннуюПочту;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 3;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	// Мониторинг процессов.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.МониторингПроцессов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьМониторингПроцессов;
	Настройка.ДоступноВПодчиненномУзлеРИБ = Ложь;
	Настройка.ОчередьЗаданийВМоделиСервиса = 3;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	// Автокатегоризация.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АвтоматическаяКатегоризацияДанных;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьАвтоматическуюКатегоризациюДанных;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	// Клиент СВД.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаСообщенийПоСВД;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСВД;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемСообщенийПоСВД;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСВД;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	// Сервер СВД.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПересылкаСообщенийСерверомСВД;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ЯвляетсяСерверомСВД;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПриемСообщенийСерверомСВД;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ЯвляетсяСерверомСВД;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	// Эскалация задач
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЭскалацияЗадач;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьЭскалациюЗадач;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	//БЭД
	ЭлектронноеВзаимодействие.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
	//Интеграция ДО с БЭД
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПоддержкаЭДО;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьОбменЭД;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РассылкаУведомленийОПроблемахЭДО;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьОбменЭД;
	Настройка.ОчередьЗаданийВМоделиСервиса = 2;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПометкаНаУдалениеТранспортныхКонтейнеровЭДО;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьОбменЭД;
	Настройка.ОчередьЗаданийВМоделиСервиса = 2;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	// Синхронизация календарей
	СинхронизацияКалендарей.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
	// Распознавание
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.Распознавание;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРаспознавание;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	
	// Файлы
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеРазмеровФайловТомов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ХранитьФайлыВТомахНаДиске;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбработкаОчередиРазмещенияФайловВТомах;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ХранитьФайлыВТомахНаДиске;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаФайлов;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	// Процессы и Задачи
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ВыполнениеЗадач;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Метаданные.Константы.ИспользоватьФоновоеВыполнениеЗадач;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПовторениеБизнесПроцессов;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Метаданные.ФункциональныеОпции.ИспользоватьПовторениеБизнесПроцессов;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СтартОтложенныхПроцессов;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СтартПроцессов;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Метаданные.ФункциональныеОпции.ИспользоватьФоновыйСтартПроцессов;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ФоноваяМаршрутизацияКомплексныхПроцессов;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Метаданные.ФункциональныеОпции.ИспользоватьФоновуюМаршрутизациюКомплексныхПроцессов;
	
	// Обсуждения
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АктуализироватьСоставАвтообсуждений;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ОбсужденияПодключены;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеОбсуждений;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ОбсужденияПодключены;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = -1;
	
	// Администрирование
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АвтоматическоеПродлениеДоговоров;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ИзвлечениеТекста;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ИнтегрированныеСистемыФормированиеСообщений;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ИзмерениеМетрик;
	Настройка.ОчередьЗаданийВМоделиСервиса = 3;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбработкаПротоколаРаботыПользователей;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РасчетПоказателейРаботыПользователей;
	Настройка.ОчередьЗаданийВМоделиСервиса = 3;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УдалениеФайловКУдалению;
	Настройка.ОчередьЗаданийВМоделиСервиса = 9;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УдалениеУстаревшихДанных;
	Настройка.ОчередьЗаданийВМоделиСервиса = 10;
	
	// Контроль самочувствия сотрудников.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольСамочувствияСотрудников;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.УчетСамочувствияСотрудников;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ФункциональныйРазделительВМоделиСервиса = Настройка.ФункциональнаяОпция;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	// Рассылка сводок о рабочем времени.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РассылкаСводокОРабочемВремени;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьЕжедневныеОтчеты;
	Настройка.ЗависимостьПоИ = Ложь;
	Настройка.ОчередьЗаданийВМоделиСервиса = 3;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РассылкаСводокОРабочемВремени;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьЕженедельныеОтчеты;
	Настройка.ЗависимостьПоИ = Ложь;
	
	// Контроль наличия оригиналов.
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КонтрольНаличияОригиналов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.РаздельныйУчетДокументов;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	Настройка.ОчередьЗаданийВМоделиСервиса = 1;
	
	//Регламентированная отчетность
	ОбщегоНазначенияБРО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаОтчетности;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПолучениеРезультатовОтправкиОтчетности;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеИнформацииОНаправленияхСдачиОтчетности;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеСостоянияЗаявокНаЛьготныйКредит;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПереносСообщений1СОтчетностиВПрисоединенныеФайлы;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	//Конец Регламентированная отчетность
	
	
	
КонецПроцедуры

// Позволяет переопределить настройки подсистемы, заданные по умолчанию.
//
// Параметры:
//  Настройки - Структура - структура с ключами:
//    * РасположениеКомандыСнятияБлокировки - Строка - определяет расположение команды снятия
//                                                     блокировки работы с внешними ресурсами
//                                                     при перемещении информационной базы.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти