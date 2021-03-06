///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список объектов конфигурации, в модулях менеджеров которых предусмотрена процедура 
// ДобавитьКомандыЗаполнения, формирующая команды заполнения объектов.
// Синтаксис процедуры ДобавитьКомандыЗаполнения см. в документации.
//
// Параметры:
//   Объекты - Массив - объекты метаданных (тип ОбъектМетаданных) с командами заполнения.
//
// Пример:
//  Объекты.Добавить(Метаданные.Справочники.Организации);
//
Процедура ПриОпределенииОбъектовСКомандамиЗаполнения(Объекты) Экспорт
	
	Объекты.Добавить(Метаданные.Справочники.ВнутренниеДокументы);
	Объекты.Добавить(Метаданные.Справочники.ВходящиеДокументы);
	Объекты.Добавить(Метаданные.Справочники.ДелаХраненияДокументов);
	Объекты.Добавить(Метаданные.Справочники.Должности);
	Объекты.Добавить(Метаданные.Справочники.ИсходящиеДокументы);
	Объекты.Добавить(Метаданные.Справочники.КонтактныеЛица);
	Объекты.Добавить(Метаданные.Справочники.Контрагенты);
	Объекты.Добавить(Метаданные.Справочники.НоменклатураДел);
	Объекты.Добавить(Метаданные.Справочники.Организации);
	Объекты.Добавить(Метаданные.Справочники.Пользователи);
	Объекты.Добавить(Метаданные.Справочники.СтруктураПредприятия);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныВнутреннихДокументов);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныВходящихДокументов);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныИсполнения);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныИсходящихДокументов);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныОзнакомления);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныПоручения);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныРассмотрения);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныРегистрации);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныСогласования);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныСоставныхБизнесПроцессов);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныУтверждения);
	Объекты.Добавить(Метаданные.Документы.ЕжедневныйОтчет);
	Объекты.Добавить(Метаданные.Документы.ПередачаДелВАрхив);
	Объекты.Добавить(Метаданные.Документы.УничтожениеДел);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Исполнение);
	Объекты.Добавить(Метаданные.БизнесПроцессы.ОбработкаВнутреннегоДокумента);
	Объекты.Добавить(Метаданные.БизнесПроцессы.ОбработкаВходящегоДокумента);
	Объекты.Добавить(Метаданные.БизнесПроцессы.ОбработкаИсходящегоДокумента);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Ознакомление);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Поручение);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Рассмотрение);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Регистрация);
	Объекты.Добавить(Метаданные.БизнесПроцессы.РешениеВопросовВыполненияЗадач);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Согласование);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Утверждение);
	
	Объекты.Добавить(Метаданные.Справочники.Контроль);
	Объекты.Добавить(Метаданные.Справочники.Мероприятия);
	Объекты.Добавить(Метаданные.Справочники.Проекты);
	Объекты.Добавить(Метаданные.Справочники.ПроектныеЗадачи);
	Объекты.Добавить(Метаданные.Справочники.ФизическиеЛица);
	Объекты.Добавить(Метаданные.Справочники.ШаблоныПриглашения);
	Объекты.Добавить(Метаданные.БизнесПроцессы.КомплексныйПроцесс);
	Объекты.Добавить(Метаданные.БизнесПроцессы.Приглашение);
	Объекты.Добавить(Метаданные.Документы.Отсутствие);
	
КонецПроцедуры

// Определяет общие команды заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - сформированные команды для вывода в подменю.
//     
//     Общие настройки:
//       * Идентификатор - Строка - идентификатор команды.
//     
//     Настройки внешнего вида:
//       * Представление - Строка   - представление команды в форме.
//       * Важность      - Строка   - группа в подменю, в которой следует вывести эту команду.
//                                    Допустимо использовать: "Важное", "Обычное" и "СмТакже".
//       * Порядок       - Число    - порядок размещения команды в подменю. Используется для настройки под конкретное
//                                    рабочее место.
//       * Картинка      - Картинка - картинка команды.
//     
//     Настройки видимости и доступности:
//       * ТипПараметра - ОписаниеТипов - типы объектов, для которых предназначена эта команда.
//       * ВидимостьВФормах    - Строка - имена форм через запятую, в которых должна отображаться команда.
//                                        Используется, когда состав команд отличается для различных форм.
//       * ФункциональныеОпции - Строка - имена функциональных опций через запятую, определяющих видимость команды.
//       * УсловияВидимости    - Массив - определяет видимость команды в зависимости от контекста.
//                                        Для регистрации условий следует использовать процедуру
//                                        ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды().
//                                        Условия объединяются по "И".
//       * ИзменяетВыбранныеОбъекты - Булево - определяет доступность команды, когда у пользователя нет прав на изменение объекта.
//                                        Если Истина, то в описанной выше ситуации кнопка будет недоступна.
//                                        Необязательный. Значение по умолчанию - Истина.
//     
//     Настройки процесса выполнения:
//       * МножественныйВыбор - Булево, Неопределено - если Истина, то команда поддерживает множественный выбор.
//             В этом случае в параметре выполнения будет передан список ссылок.
//             Необязательный. Значение по умолчанию - Истина.
//       * РежимЗаписи - Строка - действия, связанные с записью объекта, которые выполняются перед обработчиком команды.
//             ** "НеЗаписывать"          - объект не записывается, а в параметрах обработчика вместо ссылок передается
//                                       вся форма. В этом режиме рекомендуется работать напрямую с формой,
//                                       которая передается в структуре 2-го параметра обработчика команды.
//             ** "ЗаписыватьТолькоНовые" - записывать новые объекты.
//             ** "Записывать"            - записывать новые и модифицированные объекты.
//             ** "Проводить"             - проводить документы.
//             Перед записью и проведением у пользователя запрашивается подтверждение.
//             Необязательный. Значение по умолчанию - "Записывать".
//       * ТребуетсяРаботаСФайлами - Булево - если Истина, то в веб-клиенте предлагается
//             установить расширение работы с файлами.
//             Необязательный. Значение по умолчанию - Ложь.
//     
//     Настройки обработчика:
//       * Менеджер - Строка - объект, отвечающий за выполнение команды.
//       * ИмяФормы - Строка - имя формы, которую требуется получить для выполнения команды.
//             Если Обработчик не указан, то у формы вызывается метод "Открыть".
//       * ПараметрыФормы - Неопределено, ФиксированнаяСтруктура - необязательный. Параметры формы, указанной в ИмяФормы.
//       * Обработчик - Строка - описание процедуры, обрабатывающей основное действие команды.
//             Формат "<ИмяОбщегоМодуля>.<ИмяПроцедуры>" используется, когда процедура размещена в общем модуле.
//             Формат "<ИмяПроцедуры>" используется в следующих случаях:
//               - если ИмяФормы заполнено, то в модуле указанной формы ожидается клиентская процедура;
//               - если ИмяФормы не заполнено, то в модуле менеджера этого объекта ожидается серверная процедура.
//       * ДополнительныеПараметры - ФиксированнаяСтруктура - необязательный. Параметры обработчика, указанного в Обработчик.
//   
//   Параметры - Структура - сведения о контексте исполнения.
//       * ИмяФормы - Строка - полное имя формы.
//   
//   СтандартнаяОбработка - Булево - если установить в Ложь, то событие "ДобавитьКомандыЗаполнения" менеджера объекта не
//                                   будет вызвано.
//
Процедура ПередДобавлениемКомандЗаполнения(КомандыЗаполнения, Параметры, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти
