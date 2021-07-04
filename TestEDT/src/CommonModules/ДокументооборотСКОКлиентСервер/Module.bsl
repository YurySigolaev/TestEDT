
#Область ПрограммныйИнтерфейс

Функция ПоддерживаетсяФормированиеПакетаДляВнесенияИзмененийВЕГРЮЛ() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	ПоддерживаетсяНачинаяС = ВерсияДляФормированиеПакетаЕГРЮЛ();

	Результат = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПлатформы, ПоддерживаетсяНачинаяС);
	Возврат Результат >= 0;
	
КонецФункции

Функция ВерсияДляФормированиеПакетаЕГРЮЛ() Экспорт
	
	Возврат "8.3.16.1791";
	
КонецФункции

Процедура ПриИнициализацииФормыРегламентированногоОтчета(Форма, КонтролирующийОрган = "ФНС", ПараметрыПрорисовкиПанели = Неопределено) Экспорт
	
	// если кнопка отправки отсутствует, то не будем регулировать
	КнопкаОтправитьВКонтролирующийОрган = Форма.Элементы.Найти("ОтправитьВКонтролирующийОрган");
	Если КнопкаОтправитьВКонтролирующийОрган = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// вызываем серверный обработчик
	Отчет = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.СсылкаНаОтчетПоФорме(Форма);
	ОрганизацияОтчета = ПолучитьОрганизациюПоФорме(Форма);
	ПараметрыПрорисовкиКнопокОтправки = Неопределено;
	
	ДокументооборотСКОВызовСервера.ПриИнициализацииФормыРегламентированногоОтчета(Отчет, ОрганизацияОтчета, КонтролирующийОрган, ПараметрыПрорисовкиКнопокОтправки, ПараметрыПрорисовкиПанели);
	
	// регулируем видимость кнопки в зависимости от результата
	УстановитьВидимостьГруппыКнопокОтправки(Форма, ПараметрыПрорисовкиКнопокОтправки);
	
КонецПроцедуры

Функция ПолучитьОрганизациюПоФорме(Форма) Экспорт
	
	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "СтруктураРеквизитовФормы")
	И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.СтруктураРеквизитовФормы, "Организация") Тогда
		Возврат Форма.СтруктураРеквизитовФормы.Организация;
	ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "Объект")
	И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.Объект, "Организация") Тогда
		Возврат Форма.Объект.Организация;
	ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "ОтправкаОбъект")
	И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.ОтправкаОбъект, "Организация") Тогда
		Возврат Форма.ОтправкаОбъект.Организация;
	Иначе
		Возврат ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСерверПереопределяемый.ПолучитьСсылкуНаОрганизациюОтправляемогоДокументаПоФорме(Форма);
	КонецЕсли;
	
КонецФункции

Процедура УстановитьВидимостьГруппыКнопокОтправки(Форма, ПараметрыПрорисовкиКнопокОтправки) Экспорт
	
	Для Каждого Эл Из ПараметрыПрорисовкиКнопокОтправки Цикл
		ЭУ = Форма.Элементы.Найти(Эл.Ключ);
		Если ЭУ <> Неопределено Тогда
			ЭУ.Видимость = Эл.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма, КонтролирующийОрган) Экспорт
	
	ОтчетСсылка 		= ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.СсылкаНаОтчетПоФорме(Форма);
	ОрганизацияОтчета 	= ПолучитьОрганизациюПоФорме(Форма);
	Возврат ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(ОтчетСсылка, ОрганизацияОтчета, КонтролирующийОрган);
	
КонецФункции

Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач ИдентификаторНазначения  = "") Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Если ЗначениеЗаполнено(ИдентификаторНазначения) Тогда
		Сообщение.ИдентификаторНазначения  = ИдентификаторНазначения;
	КонецЕсли;	
	Сообщение.Сообщить();

КонецПроцедуры

Функция ЭтоВидОтправляемогоДокументаРеестраНДС(ВидОтчета) Экспорт
	
	ВидыРеестровНДС = ВидыОтправляемыхДокументовРеестровНДС();
	Возврат ВидыРеестровНДС.Найти(ВидОтчета) <> Неопределено;
	
КонецФункции

Функция ВидыОтправляемыхДокументовРеестровНДС() Экспорт
	
	Виды = Новый Массив;
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСДекларацииИТаможенныеДекларации23"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСДекларацииНаЭкспрессГрузы"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение1"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение2"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение3"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение4"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение5"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение6"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение7"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение8"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение9"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение10"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение11"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение12"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение13"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрНДСПриложение14"));
	
	Возврат Виды;

КонецФункции

Функция ЭтоВидОтправляемогоДокументаРеестраАкцизов(ВидОтчета) Экспорт
	
	ВидыРеестровАкцизов = ВидыОтправляемыхДокументовРеестровАкцизов();
	Возврат ВидыРеестровАкцизов.Найти(ВидОтчета) <> Неопределено;
	
КонецФункции

Функция ВидыОтправляемыхДокументовРеестровАкцизов() Экспорт
	
	Виды = Новый Массив;
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрАкцизыПриложение1"));
	Виды.Добавить(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеестрАкцизыПриложение2"));
	
	Возврат Виды;
	
КонецФункции

Функция УдалитьРазделители(Знач АнализируемаяСтрока) Экспорт
	
	Разделители = " ""%&'()+,-./:;@_«№»";
	НоваяСтрока = "";
	
	Для Инд = 1 По СтрДлина(АнализируемаяСтрока) Цикл
		
		СимволАнализируемойСтроки = Сред(АнализируемаяСтрока, Инд, 1);
		
		ЭтоРазделитель = СтрНайти(Разделители, СимволАнализируемойСтроки) <> 0;
		Если НЕ ЭтоРазделитель Тогда
			НоваяСтрока = НоваяСтрока + СимволАнализируемойСтроки;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НоваяСтрока;
	
КонецФункции

Функция ПроверитьЦифровойКодЗаданнойДлины(Параметр, Длина, ПропускатьПустой = Ложь) Экспорт
	
	Параметр = СокрЛП(Параметр);
	
	Если ПустаяСтрока(Параметр) И ПропускатьПустой Тогда
		
	ИначеЕсли СтрДлина(Параметр) = Длина Тогда
		
		Для Счетчик = 1 по Длина Цикл
			
			КодСимвола = КодСимвола(Сред(Параметр, Счетчик, 1));
			
			Если НЕ (КодСимвола >= 48 И КодСимвола <= 57) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПроверитьКПП(КПП) Экспорт
	
	Параметр = СокрЛП(КПП);
	
	Если СтрДлина(Параметр) = 9 Тогда
		
		Для Счетчик = 1 по 9 Цикл
			
			КодСимвола = КодСимвола(Сред(Параметр, Счетчик, 1));
			
			Если НЕ (КодСимвола >= 48 И КодСимвола <= 57) Тогда
				
				Если Счетчик = 5 ИЛИ Счетчик = 6 Тогда
					
					Если НЕ (КодСимвола >= 65 И КодСимвола <= 90) Тогда
						
						Возврат Ложь;
						
					КонецЕсли;
					
				Иначе
					
					Возврат Ложь;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПроверитьРегистрационныйНомерПФР(Параметр, ПропускатьПустой = Ложь) Экспорт
	
	Возврат (ПустаяСтрока(Параметр) И ПропускатьПустой)
	ИЛИ (Сред(Параметр,4,1) = "-" 
	И Сред(Параметр,8,1) = "-" 
	И СтрДлина(Параметр) = 14 
	И ПроверитьЦифровойКодЗаданнойДлины(СтрЗаменить(Параметр,"-",""),12));
	
КонецФункции

Функция ЭтоФНС(КонтролирующийОрган) Экспорт
	
	Возврат КонтролирующийОрган = ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС")
		ИЛИ КонтролирующийОрган = "ФНС";
		
КонецФункции

Функция НайденыЗапрещенныеСимволы(АнализируемаяСтрока, НаименованиеРеквизита, Поле, ТихийРежим = Ложь, ТекстОшибки = "") Экспорт
	
	ЗапрещенныеСимволы = ЗапрещенныеСимволыВСтроке(АнализируемаяСтрока);
	Если СтрДлина(ЗапрещенныеСимволы) = 0 Тогда
		
		Возврат Ложь;
		
	Иначе
		
		ЗапрещенныеСимволыПрописью 		= НаименованиеРеквизита + НСтр("ru = ' содержит запрещенные символы: '");
		ДлинаСтрокиЗапрещенныхСимволов 	= СтрДлина(ЗапрещенныеСимволы);
		
		Для Индекс = 1 По ДлинаСтрокиЗапрещенныхСимволов Цикл
			
			ЗапрещенныйСимвол = Сред(ЗапрещенныеСимволы, Индекс, 1);
			
			ЗапрещенныеСимволыПрописью = 
				ЗапрещенныеСимволыПрописью
				+ НазваниеСимвола(ЗапрещенныйСимвол) 
				+ ?(Индекс = ДлинаСтрокиЗапрещенныхСимволов, "", ", ");
		
		КонецЦикла; 
		
		ТекстОшибки = ЗапрещенныеСимволыПрописью;
		Если НЕ ТихийРежим Тогда
			ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(ЗапрещенныеСимволыПрописью, , Поле);
		КонецЕсли;
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

Функция ЗапрещенныеСимволыВСтроке(АнализируемаяСтрока) Экспорт
	
	// Исключение из стандарта 456.
	РазрешенныеСимволыПриказФНС142 = " ""%&'()+,-./0123456789:;@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyzЁ«ё№»АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя";
	
	// Вариант списка разрешенных символов от Калуги-Астрал:
	// А-ЯЁа-яёA-Za-z0-9 "%&'()+,-.:;@_№«»!?/=
	ДополнительныеСимволыОтКалугиАстрал = "!?=";
	
	РазрешенныеСимволыПриказФНС142 = РазрешенныеСимволыПриказФНС142 + ДополнительныеСимволыОтКалугиАстрал;
	
	ЗапрещенныеСимволы = "";
	
	Для Инд = 1 По СтрДлина(АнализируемаяСтрока) Цикл
		
		СимволАнализируемойСтроки = Сред(АнализируемаяСтрока, Инд, 1);
		
		СимволНаходитсяВМножествеЗапрещенных = СтрНайти(РазрешенныеСимволыПриказФНС142, СимволАнализируемойСтроки) = 0;
		Если СимволНаходитсяВМножествеЗапрещенных Тогда
			
			СимволЕщеНеДобавленВРезультат = СтрНайти(ЗапрещенныеСимволы, СимволАнализируемойСтроки) = 0;
			Если СимволЕщеНеДобавленВРезультат Тогда
				
				ЗапрещенныеСимволы = ЗапрещенныеСимволы + СимволАнализируемойСтроки;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЗапрещенныеСимволы;
	
КонецФункции

Функция ПараметрыОткрытияМастера() Экспорт
		
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("СоздатьНовоеЗаявление",		Истина);
	ДополнительныеПараметры.Вставить("Организация", 				Неопределено);
	ДополнительныеПараметры.Вставить("ЗначениеКопирования", 		Неопределено);
	ДополнительныеПараметры.Вставить("ВидЗаявления", 				Неопределено);
	ДополнительныеПараметры.Вставить("ПараметрыОткрытияМастера",	Неопределено);
	ДополнительныеПараметры.Вставить("РучнойВвод", 					Ложь);
	ДополнительныеПараметры.Вставить("ИгнорироватьКонфликт", 		Ложь);
	ДополнительныеПараметры.Вставить("КриптопровайдерПриКонфликте", Неопределено);
	ДополнительныеПараметры.Вставить("НовыйСертификат", 			Неопределено);
	
	// Не сереализуются!
	ДополнительныеПараметры.Вставить("ВыполняемоеОповещение", 		Неопределено);
	ДополнительныеПараметры.Вставить("ВладелецОткрываемойФормы",	Неопределено);
	
	Возврат ДополнительныеПараметры;
		
КонецФункции

Функция ИзменитьОформлениеРекомендацииДоверенностиДляФНС(ВладелецЭЦПТип, ЭтоЮридическоеЛицо, ПолучателиФНС, ЦветТекста = Неопределено) Экспорт
	
	Если ЦветТекста = Неопределено Тогда
		ЦветТекста = Новый Цвет();
	КонецЕсли;
	
	Если ВладелецЭЦПТип = ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.Руководитель") Тогда
		Возврат "";
	КонецЕсли;
	
	РекомендацияЧасть1 = Новый ФорматированнаяСтрока(НСтр("ru = 'Так как сертификат оформляется '"),,ЦветТекста);
	
	Если ЭтоЮридическоеЛицо И ВладелецЭЦПТип = ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.ГлавныйБухгалтер") Тогда
		РекомендацияНаКого = НСтр("ru = 'на главного бухгалтера'");
	ИначеЕсли ЭтоЮридическоеЛицо И ВладелецЭЦПТип = ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.ДругойСотрудник") Тогда
		РекомендацияНаКого = НСтр("ru = 'на сотрудника, не являющегося руководителем'");
	ИначеЕсли НЕ ЭтоЮридическоеЛицо Тогда
		РекомендацияНаКого = НСтр("ru = 'не на самого предпринимателя'");
	КонецЕсли;
	РекомендацияНаКого = Новый ФорматированнаяСтрока(РекомендацияНаКого,,ЦветТекста);
	
	РекомендацияЧасть2 = Новый ФорматированнаяСтрока(НСтр("ru = ', необходимо представить '"),,ЦветТекста);
	
	Если ЭтоЮридическоеЛицо Тогда
		РекомендацияНотариус = Новый ФорматированнаяСтрока("",,ЦветТекста);
	Иначе
		РекомендацияНотариус = Новый ФорматированнаяСтрока(НСтр("ru = 'нотариально заверенную '"),,ЦветТекста);
	КонецЕсли;
	
	РекомендацияДоверенность = Новый ФорматированнаяСтрока(НСтр("ru = 'доверенность'"),,,,"доверенность");
	
	ФНСНесколько = Ложь;
	сч = 0;
	Пока сч <= ПолучателиФНС.Количество() - 2 Цикл
		Если ПолучателиФНС[сч].КодПолучателя <> ПолучателиФНС[сч + 1].КодПолучателя Тогда
			ФНСНесколько = Истина;
			Прервать;
		КонецЕсли;
		сч = сч + 1;
	КонецЦикла;
	
	Если ФНСНесколько Тогда
		РекомендацияЧасть3 = НСтр("ru = ' в каждую ИФНС '");
	Иначе
		РекомендацияЧасть3 = НСтр("ru = ' в вашу ИФНС '");
	КонецЕсли;
	РекомендацияЧасть3 = Новый ФорматированнаяСтрока(РекомендацияЧасть3,,ЦветТекста);
	
	РекомендацияЧасть4 = Новый ФорматированнаяСтрока(НСтр("ru = 'и сопоставить ее '"),,ЦветТекста);
	
	Если ПолучателиФНС.Количество() > 1 Тогда
		РекомендацияЧасть5 = НСтр("ru = 'каждой '");
	Иначе
		РекомендацияЧасть5 = НСтр("ru = ''");
	КонецЕсли;
	РекомендацияЧасть5 = Новый ФорматированнаяСтрока(РекомендацияЧасть5,,ЦветТекста);
	
	РекомендацияРегистрации = Новый ФорматированнаяСтрока(НСтр("ru = 'регистрации'"),,,,"регистрации");
	
	РекомендацияЧасть6 = Новый ФорматированнаяСтрока(НСтр("ru = ' в налоговом органе.'") + Символы.НПП  + Символы.НПП + Символы.НПП,,ЦветТекста);
	
	РекомендацияСтатья = Новый ФорматированнаяСтрока(НСтр("ru = '?'"),,,,"статья");
	
	Рекомендация = Новый ФорматированнаяСтрока(
		РекомендацияЧасть1,
		РекомендацияНаКого,
		РекомендацияЧасть2,
		РекомендацияНотариус,
		РекомендацияДоверенность,
		РекомендацияЧасть3,
		РекомендацияЧасть4,
		РекомендацияЧасть5,
		РекомендацияРегистрации,
		РекомендацияЧасть6,
		РекомендацияСтатья);

	Возврат Рекомендация;
	
КонецФункции

Функция ВидыДокументовВЗаявлении(
		ЭтоЭлектронноеПодписание, 
		ЭтоНулевка, 
		ВладелецЭЦПТип, 
		ЭтоЮридическоеЛицо, 
		ЭтоПервичноеЗаявление, 
		ИспользоватьСуществующийСертификат) Экспорт
	
	// Ключи:
	// "Паспорт"
	// "СНИЛС"
	// "СвидетельствоОПостановкеНаУчет"
	// "ПодтверждениеПолномочий"
	// "Заявление"
	
	ЭтоБумажноеПодписание = НЕ ЭтоЭлектронноеПодписание;
	
	Виды = Новый Структура;
	
	// Паспорт
	Описание = ОписаниеВидаДокумента();
	Описание.Видимость 	   = (ЭтоНулевка ИЛИ ЭтоЭлектронноеПодписание) И НЕ ИспользоватьСуществующийСертификат;
	Описание.Представление = НСтр("ru = 'Паспорт (разворот с фото)'");
	Описание.ОдинФайл 	   = Истина;
	
	Виды.Вставить("Паспорт", Описание);
	
	Если ЭтоПервичноеЗаявление Тогда
	
		// СНИЛС
		Описание = ОписаниеВидаДокумента();
		Описание.Видимость		= (ЭтоНулевка ИЛИ ЭтоЭлектронноеПодписание) И НЕ ИспользоватьСуществующийСертификат;
		Описание.Представление 	= НСтр("ru = 'Свидетельство СНИЛС'");
		Описание.ОдинФайл 		= Истина;
		
		Виды.Вставить("СНИЛС", Описание);
		
		// Постановка на учет в ФНС
		Описание = ОписаниеВидаДокумента();
		Описание.Видимость			= (ЭтоНулевка И ЭтоБумажноеПодписание) И НЕ ИспользоватьСуществующийСертификат;
		Описание.Представление 		= НСтр("ru = 'Свидетельство ИНН орг-ции'");
		Описание.ТолькоДляНулевки 	= Истина;
		
		Виды.Вставить("СвидетельствоОПостановкеНаУчет", Описание);
		
		// Подтверждение полномочий
		Описание = ОписаниеВидаДокумента();
		
		ЭтоРуководитель = ВладелецЭЦПТип = ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.Руководитель");
		
		Если ЭтоЮридическоеЛицо И НЕ ЭтоРуководитель Тогда
			Описание.Видимость = (ЭтоНулевка ИЛИ ЭтоЭлектронноеПодписание) И НЕ ИспользоватьСуществующийСертификат;

		Иначе
			Описание.Видимость = Ложь;
		КонецЕсли;
		
		Если ЭтоРуководитель Тогда
			Описание.Представление 	= НСтр("ru = 'Приказ о назначении'");
		Иначе
			Описание.Представление 	= НСтр("ru = 'Подтверждение полномочий'");
		КонецЕсли;
		
		Виды.Вставить("ПодтверждениеПолномочий", Описание);
		
		// Доверенность
		Описание = ОписаниеВидаДокумента();
		
		Если НЕ ЭтоРуководитель Тогда
			Описание.Видимость = ЭтоЭлектронноеПодписание И НЕ ИспользоватьСуществующийСертификат;
		Иначе
			Описание.Видимость = Ложь;
		КонецЕсли;
		Описание.Представление 	= НСтр("ru = 'Доверенность'");
		
		Виды.Вставить("Доверенность", Описание);
		
		// Заявление
		Описание = ОписаниеВидаДокумента();
		Описание.Видимость			= (ЭтоНулевка И ЭтоБумажноеПодписание) И НЕ ИспользоватьСуществующийСертификат;
		Описание.Представление 		= НСтр("ru = 'Заявление на подключение'");
		Описание.ТолькоДляНулевки 	= Истина;

		Виды.Вставить("Заявление", Описание);
		
	КонецЕсли;

	Возврат Виды;

КонецФункции

Функция ПроверитьСНИЛС(Параметр, ПропускатьПустой = Ложь, ПроверятьКонтрольноеЧисло = Ложь) Экспорт
	
	ПараметрТолькоЦифры = СтрЗаменить(Параметр,"-","");
	ПараметрТолькоЦифры = СтрЗаменить(ПараметрТолькоЦифры," ","");
	
	Результат = (ПустаяСтрока(Параметр) И ПропускатьПустой)
	ИЛИ (Сред(Параметр,4,1) = "-" 
	И Сред(Параметр,8,1) = "-" 
	И Сред(Параметр,12,1) = " " 
	И СтрДлина(Параметр) = 14 
	И ПроверитьЦифровойКодЗаданнойДлины(ПараметрТолькоЦифры,11));
	
	Если Результат И ПроверятьКонтрольноеЧисло  Тогда
		
		ПроверяемоеЧисло = Лев(ПараметрТолькоЦифры,9);
		КонтрольноеЧисло = Прав(ПараметрТолькоЦифры,2);
		
		Если (Число(ПроверяемоеЧисло) > 1001998) Тогда
			
			Сумма =0;
			
			Для Счетчик = 1 По СтрДлина(ПроверяемоеЧисло) Цикл
				Цифра = Число(Сред(ПроверяемоеЧисло, Счетчик, 1));
				Сумма=Сумма + Цифра * (СтрДлина(ПроверяемоеЧисло) - Счетчик +1);
			КонецЦикла;
			
			Если Сумма < 100 Тогда
				КонтрольнаяСумма = Сумма;
			ИначеЕсли Сумма=100 ИЛИ Сумма=101 Тогда
				КонтрольнаяСумма = 0;
			Иначе
				Сумма = Сумма%101;
				
				Если (Сумма < 100) Тогда
					КонтрольнаяСумма = Сумма;
				Иначе
					КонтрольнаяСумма = 0;
				КонецЕсли;
				
			КонецЕсли;
			
			Возврат КонтрольнаяСумма = Число(КонтрольноеЧисло);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция РезультатПроверкиРеквизитов() Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	
	ДополнительныеПараметры.Вставить("ЕстьОшибка",  Ложь);
	ДополнительныеПараметры.Вставить("Пустой",      Ложь);
	ДополнительныеПараметры.Вставить("ТекстОшибки", "");
	
	// Не заполняются в случае проверки одного реквизита:
	
	// Реквизит формы, который нужно оформлять:
	// треугольничек ошибки или красная надпись
	ДополнительныеПараметры.Вставить("Реквизит", "");
	// Указатель, к которому привязывается сообщение об ошибке
	ДополнительныеПараметры.Вставить("Поле",     "");
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция ВывестиОшибкуПроверкиРеквизита(МастерДалее, РезультатПроверки, ВыводитьСообщения) Экспорт
	
	ЕстьОшибка = Ложь;
	Если ЗначениеЗаполнено(РезультатПроверки.ТекстОшибки) Тогда
		РезультатПроверки.ЕстьОшибка = Истина;
		МастерДалее = Ложь;
		ЕстьОшибка  = Истина;
		Если ВыводитьСообщения Тогда
			#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
				ОбщегоНазначения.СообщитьПользователю(РезультатПроверки.ТекстОшибки, ,РезультатПроверки.Поле);
			#Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатПроверки.ТекстОшибки, ,РезультатПроверки.Поле);
			#КонецЕсли
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЕстьОшибка;
	
КонецФункции

// Сравнивает одну версию формата с другой, например "5.05" и "5.04"
// Написана на базе ОбщегоНазначенияКлиентСервер.СравнитьВерсии
// 
// Возвращаемое значение:
//   Число   - отрицательное, если первая меньше второй.
//           - 0, если равны.
//           - положительное, если первая больше второй.
Функция СравнитьВерсииФормата(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	
	Версия1 = СтрРазделить(СтрокаВерсии1, ".");
	Версия2 = СтрРазделить(СтрокаВерсии2, ".");
	
	Результат = 0;
	Для Разряд = 0 По 1 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обход ошибки платформы 10214719 Веб - не прорисовываются элементы управления
Процедура АктивизироватьСтраницу(МногостраничныйЭлемент, ТекущаяСтраница) Экспорт
	
	Для каждого Страница Из МногостраничныйЭлемент.ПодчиненныеЭлементы Цикл
		Если Страница <> ТекущаяСтраница Тогда
			Страница.Видимость = Ложь;
		Иначе
			Страница.Видимость = Истина;
		КонецЕсли;
	КонецЦикла;
	
	МногостраничныйЭлемент.ТекущаяСтраница 	= ТекущаяСтраница;
	
КонецПроцедуры

Функция ПредставлениеПакетаСДопДокументами(СМаленькойБуквы = Ложь) Экспорт

	Если СМаленькойБуквы Тогда
		Возврат НСтр("ru = 'пакет с доп. документами для ФНС'");
	Иначе
		Возврат НСтр("ru = 'Пакет с доп. документами для ФНС'");
	КонецЕсли;

КонецФункции

Функция ПредставлениеПакетаСДопДокументамиВРодительномПадеже(СМаленькойБуквы = Ложь) Экспорт

	Если СМаленькойБуквы Тогда
		Возврат НСтр("ru = 'пакета с доп. документами для ФНС'");
	Иначе
		Возврат НСтр("ru = 'Пакета с доп. документами для ФНС'");
	КонецЕсли;

КонецФункции

Процедура ИзменитьОформлениеДокумента(Форма, ВидДокумента, Размер, Количество, ИмяПервого, ЗапретитьИзменение = Ложь, Обязательно = Истина) Экспорт
	
	Элементы 		= Форма.Элементы;
	КрестикОчистки 	= Элементы["ОчиститьСсылка" + ВидДокумента];
	
	Размер = ОбщегоНазначенияЭДКОКлиентСервер.ТекстовоеПредставлениеРазмераФайла(Размер);
	
	Если Количество = 0 Тогда
		
		КрестикОчистки.Видимость = Ложь;
		
		Если Обязательно Тогда
			Цвет = Форма.КрасныйЦвет;
		Иначе
			Цвет = Новый Цвет(28, 85, 174);
		КонецЕсли;
		
		Если ЗапретитьИзменение Тогда
			ЗаголовокСсылки = НСтр("ru = '<Файл не выбран>'");
		ИначеЕсли Форма.СканированиеДоступно Тогда
			
			СтрокаОтсканируйте = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Отсканировать'"),
				,
				Цвет,
				,
				"Отсканируйте");
				
			СтрокаВыберите = Новый ФорматированнаяСтрока(
				НСтр("ru = 'выбрать файл'"),
				,
				Цвет,
				,
				"выберите");
				
			ЗаголовокСсылки = Новый ФорматированнаяСтрока(СтрокаОтсканируйте, НСтр("ru = ' или '"), СтрокаВыберите, " ");
			
		Иначе
			
			// Неразрывный пробел в середине - обход ошибки платформы 
			// 10187265 веб - Форматированная строка разбивается на две, хотя не должна
			ЗаголовокСсылки = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Выбрать" + Символы.НПП + "файл'"),
				,
				Цвет,
				,
				"выберите");
			
		КонецЕсли;
			
		Элементы["Ссылка" + ВидДокумента].Заголовок = ЗаголовокСсылки;
		
	ИначеЕсли Количество = 1 Тогда
		
		Представление = ИмяПервого + " (" + Размер + ")";
		Представление = СтрЗаменить(Представление, " ", Символы.НПП);
		
		Элементы["Ссылка" + ВидДокумента].Заголовок = Новый ФорматированнаяСтрока(Представление,,,,"Файл");
		
		КрестикОчистки.Видимость = НЕ Форма.ЗапретитьИзменение;
		
	Иначе
		
		Количество = ДлительнаяОтправкаКлиентСервер.ЧислоИПредметИсчисления(
			Количество,
			НСтр("ru = 'файл'"),
			НСтр("ru = 'файла'"),
			НСтр("ru = 'файлов'"),
			"м");
		
		Представление = Количество + " (" + Размер + ")";
		Представление = СтрЗаменить(Представление, " ", Символы.НПП);
		
		Элементы["Ссылка" + ВидДокумента].Заголовок = Новый ФорматированнаяСтрока(Представление,,,,"Файл");
		
		КрестикОчистки.Видимость = НЕ Форма.ЗапретитьИзменение;
		
	КонецЕсли;
	
КонецПроцедуры

Функция НазваниеСимвола(Символ) Экспорт
	
	Если Символ = Символы.ВК Тогда
		НазваниеСимвола = НСтр("ru = 'символ возврата каретки'");
	ИначеЕсли Символ = Символы.ВТаб Тогда
		НазваниеСимвола = НСтр("ru = 'символ табуляции'");
	ИначеЕсли Символ = Символы.НПП Тогда
		НазваниеСимвола = НСтр("ru = 'символ неразрывного пробела'");
	ИначеЕсли Символ = Символы.ПС Тогда
		НазваниеСимвола = НСтр("ru = 'символ перевода строки'");
	ИначеЕсли Символ = Символы.ПФ Тогда
		НазваниеСимвола = НСтр("ru = 'символ перевода страницы'");
	ИначеЕсли Символ = Символы.Таб Тогда
		НазваниеСимвола = НСтр("ru = 'символ табуляции'");
	Иначе
		НазваниеСимвола = Символ;
	КонецЕсли;
			
	Возврат НазваниеСимвола;
	
КонецФункции

Функция ОписаниеВидаДокумента()
	
	Описание = Новый Структура;
	Описание.Вставить("Видимость", 			Истина);
	Описание.Вставить("Представление", 		"");
	Описание.Вставить("Постфикс", 			"");
	Описание.Вставить("ТолькоДляНулевки", 	Ложь);
	Описание.Вставить("ОдинФайл", 			Ложь);
	
	Возврат Описание;
	
КонецФункции

Функция ПредставлениеСертификата(Сертификат) Экспорт
	
	Если Сертификат = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Если Сертификат.Свойство("ДействителенС") Тогда
		СертификатДействителенС = Формат(Сертификат.ДействителенС, "ДЛФ=D");
	ИначеЕсли Сертификат.Свойство("ДатаНачала") Тогда
		СертификатДействителенС = Формат(Сертификат.ДатаНачала, "ДЛФ=D");
	КонецЕсли;
		
	Если Сертификат.Свойство("ДействителенПо") Тогда
		СертификатДействителенПо = Формат(Сертификат.ДействителенПо, "ДЛФ=D");
	ИначеЕсли Сертификат.Свойство("ДатаОкончания") Тогда
		СертификатДействителенПо = Формат(Сертификат.ДатаОкончания, "ДЛФ=D");
	КонецЕсли;

	Если Сертификат.Свойство("ПоставщикСтруктура") И Сертификат.ПоставщикСтруктура.Свойство("O") Тогда
		Издатель = Сертификат.ПоставщикСтруктура["O"];
	ИначеЕсли Сертификат.Свойство("Издатель") И Сертификат.Издатель.Свойство("O") Тогда
		Издатель = Сертификат.Издатель["O"];
	Иначе
		Издатель = "";
	КонецЕсли;
	
	Представление = НСтр("ru = '%1 (%2-%3), %4'");
	Представление = СтрШаблон(
		Представление,
		Сертификат.Наименование,
		СертификатДействителенС,
		СертификатДействителенПо,
		Издатель);
	
	Возврат Представление;
	
КонецФункции

#Область ЗаявленияВПФР

Функция НужноОтправитьЗаявлениеНаСертификат(Состояние) Экспорт
	
	Возврат Состояние.НаСертификат.НужноОтправитьЗаявление
		И Состояние.НаПодключение.ОрганизацияПодключена
		И НЕ Состояние.НаСертификат.ЗаявлениеОтправлено;
		
КонецФункции

Процедура ИзменитьОформлениеСтраницыОтправкаЗаявленияВПФР(Форма) Экспорт

	Элементы = Форма.Элементы;
	
	ИзменитьОформлениеПодсказкиПроЗаявление(Форма);
	ИзменитьОформлениеКрасныхНадписей(Форма);
	
	Если ЗначениеЗаполнено(Форма.ТекущееЗаявлениеПо1СОтчетности) Тогда
		Заявление = Форма.ТекущееЗаявлениеПо1СОтчетности;
		Реквизиты = ОбработкаЗаявленийАбонентаВызовСервера.ПолучитьСтруктуруРеквизитовЗаявления(Заявление);
		ИспользоватьСуществующий = Реквизиты.СпособПолученияСертификата = ПредопределенноеЗначение("Перечисление.СпособПолученияСертификата.ИспользоватьСуществующий");
	Иначе
		ИспользоватьСуществующий = Ложь;
	КонецЕсли;
	
	Элементы.ЗаявлениеВПФР_ГруппаЗаявления.Видимость = Форма.ЭтоИзначальноНаПодключениеИлиОтключение;
	
	Элементы.ЗаявлениеВПФР_ГруппаСертификата.Видимость = 
		НЕ Форма.ЭтоИзначальноНаПодключениеИлиОтключение
		И Форма.СостояниеЭДОсПФР.НаСертификат.СертификатыОтправляются
		ИЛИ Форма.СостояниеЭДОсПФР.НаСертификат.НужноОтправитьЗаявление 
		И Форма.ЭтоИзначальноНаПодключениеИлиОтключение 
		И Форма.ФлагЗаявлениеУжеПредоставленоВПФР;
		
	// Кнопки
	Элементы.ЗаявленияВПФР_ПропуститьОтправку.Видимость = НЕ Форма.ЭтоПредупреждениеИзНастроек;
	Если Элементы.ЗаявлениеВПФР_ГруппаСертификата.Видимость И НЕ Форма.ФлагСертификатУжеОтправленВПФР Тогда
		ЗаголовокКнопки = НСтр("ru = 'Отправить сертификат в ПФР'");
	ИначеЕсли Элементы.ЗаявлениеВПФР_ГруппаЗаявления.Видимость И НЕ Форма.ФлагЗаявлениеУжеПредоставленоВПФР Тогда
		ЗаголовокКнопки = НСтр("ru = 'Отправить заявление в ПФР'");
	Иначе
		ЗаголовокКнопки = Форма.ЗаголовокКнопкиПоЗавершению;
		Элементы.ЗаявленияВПФР_ПропуститьОтправку.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ЗаявленияВПФР_ОтправитьЗаявление.Заголовок = ЗаголовокКнопки;
	Элементы.ЗаявленияВПФР_ОтправитьЗаявление.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

Процедура ИзменитьОформлениеКрасныхНадписей(Форма)
	
	Элементы = Форма.Элементы;
	НадписьПодЗаявлением = Элементы.ТекстПодГалкойЗаявленияВПФР;
	НадписьПодСертификатом = Элементы.ТекстПодГалкойСертификатаВПФР;
	
	ЭтоНужныйРежим = Форма.ЭтоПредупреждениеИзНастроек ИЛИ Форма.ЭтоПредупреждениеИзОтправки И ЗначениеЗаполнено(Форма.Отчет);
	
	Если ЭтоНужныйРежим Тогда
		
		Если Форма.ЭтоПредупреждениеИзОтправки Тогда
			
			Представление = ДлительнаяОтправкаКлиентСервер.НазваниеОбъектаВИменительномПадеже(Форма.Отчет);
			
			Шаблон = НСтр("ru = 'Отправляемый %1 не будет принят, если заявление не было предоставлено в ПФР ранее.'");
			НадписьПодЗаявлением.Заголовок = СтрШаблон(Шаблон, Представление);
			
			Шаблон = НСтр("ru = 'Отправляемый %1 не будет принят, если сертификат не был предоставлен в ПФР ранее.'");
			НадписьПодСертификатом.Заголовок = СтрШаблон(Шаблон, Представление);
			
		ИначеЕсли Форма.ЭтоПредупреждениеИзНастроек Тогда
			
			НадписьПодЗаявлением.Заголовок = НСтр("ru = 'Отправляемые документы не будут приняты, если заявление не предоставлено в ПФР ранее.'");
			НадписьПодСертификатом.Заголовок = НСтр("ru = 'Отправляемые документы не будут приняты, если сертификат не предоставлен в ПФР ранее.'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	НадписьПодЗаявлением.Видимость = 
		ЭтоНужныйРежим 
		И Форма.ФлагЗаявлениеУжеПредоставленоВПФР;
		
	НадписьПодСертификатом.Видимость =
		ЭтоНужныйРежим 
		И Форма.СостояниеЭДОсПФР.НаСертификат.НужноОтправитьЗаявление
		И Форма.ФлагСертификатУжеОтправленВПФР;
	
КонецПроцедуры

Процедура ИзменитьОформлениеПодсказкиПроЗаявление(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ИзначальныйВидЗаявленияПФР = Форма.НаПодключение Тогда
		
		Элементы.ЗаявлениеВПФР_ПодсказкаПроЗаявление.Заголовок = 
			НСтр("ru = 'Для перехода на электронные трудовые книжки необходимо отправить в ПФР специальное заявление и дождаться положительного результата его рассмотрения.'");
			
	ИначеЕсли Форма.ИзначальныйВидЗаявленияПФР = Форма.НаОтключение Тогда
		
		Элементы.ЗаявлениеВПФР_ПодсказкаПроЗаявление.Заголовок = 
			НСтр("ru = 'В связи с тем, что направление ПФР было отключено в настройках учетной записи, вам необходимо отправить в ПФР специальное заявление на отключение от эл. документооборота.'");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьОформлениеСтраницыОшибкаОтправкиВПФР(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Элементы.ОшибкаОтправкиЗаявленияВПФР_ПовторитьОтправку.КнопкаПоУмолчанию = Истина;
	Элементы.ОшибкаОтправкиЗаявленияВПФР_ДляЗаявления.Видимость = Истина;
	Элементы.ОшибкаОтправкиЗаявленияВПФР_ДляСертификата.Видимость = Ложь;
	
	Если Форма.ВидОтправляемогоЗаявления = Форма.НаПодключение Тогда
		
		Элементы.ОшибкаОтправкиЗаявленияВПФР_Подсказка.Заголовок = НСтр("ru = 'Не удалось отправить в ПФР заявление на подключение к эл. документообороту.'");
		
	ИначеЕсли Форма.ВидОтправляемогоЗаявления = Форма.НаОтключение Тогда
		
		Элементы.ОшибкаОтправкиЗаявленияВПФР_Подсказка.Заголовок = НСтр("ru = 'Не удалось отправить в ПФР заявление на отключение от эл. документооборота.'");
		
	ИначеЕсли Форма.ВидОтправляемогоЗаявления = Форма.НаСертификат Тогда
		
		Элементы.ОшибкаОтправкиЗаявленияВПФР_Подсказка.Заголовок = НСтр("ru = 'Не удалось отправить в ПФР сертификат.'");
		Элементы.ОшибкаОтправкиЗаявленияВПФР_ДляЗаявления.Видимость = Ложь;
		Элементы.ОшибкаОтправкиЗаявленияВПФР_ДляСертификата.Видимость = Истина;
		
	Иначе
		Элементы.ОшибкаОтправкиЗаявленияВПФР_Подсказка.Заголовок = НСтр("ru = 'Не удалось отправить заявление в ПФР.'");
	КонецЕсли;
	
КонецПроцедуры

Функция ИзменитьЗаголовокФормыОтправкиВПФР(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ОтправкаЗаявленияВПФР Тогда
		
		Если Элементы.ЗаявлениеВПФР_ГруппаЗаявления.Видимость И НЕ Элементы.ЗаявлениеВПФР_ГруппаСертификата.Видимость Тогда
			Форма.Заголовок = НСтр("ru = 'Отправьте заявление на подключение к эл. документообороту с ПФР'");
		Иначе
			Форма.Заголовок = НСтр("ru = 'Отправьте сертификат в ПФР'");
		КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ОшибкаОтправкиВПФР Тогда
		
		Если Форма.ВидОтправляемогоЗаявления = Форма.НаПодключение Тогда
			Форма.Заголовок = НСтр("ru = 'Отправка в ПФР заявления на подключение к эл. документообороту'");
		ИначеЕсли Форма.ВидОтправляемогоЗаявления = Форма.НаСертификат Тогда
			Форма.Заголовок = НСтр("ru = 'Отправка сертификата в ПФР'");
		КонецЕсли;

	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ОжидаетсяРезультатРассмотрения Тогда
		
		Если Форма.ЭтоПредупреждениеИзОтправки Тогда
			
			ВидОтчета = ДлительнаяОтправкаКлиентСервер.НазваниеОбъектаВИменительномПадеже(Форма.Отчет);
			Шаблон    = НСтр("ru = 'Внимание! Отправляемый %1 может быть не принят'");
			Форма.Заголовок = СтрШаблон(Шаблон, ВидОтчета);
			
		Иначе
			Форма.Заголовок = НСтр("ru = 'Ожидается результат рассмотрения заявления'");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Форма.Заголовок;
	
КонецФункции

Функция ПодсказкаКЗаявлениюНаПодключениеПФР() Экспорт
	 Возврат НСтр("ru = 'Заявление необходимо для перехода на электронные трудовые книжки. Заявление обязательно к представлению независимо от того, заключалось ли ранее соглашение об обмена электронными документами с ПФР.'");
КонецФункции
 
Функция ПодсказкаКЗаявлениюНаОтключениеПФР() Экспорт
	 Возврат НСтр("ru = 'Заявление представляется в случае отказа от использования электронных трудовых книжек.'");
КонецФункции
 
Функция ПодсказкаКЗаявлениюНаСертификатПФР() Экспорт
	 Возврат НСтр("ru = 'Ранее вы перешли на электронные трудовые книжки. Заявление необходимо для того, чтобы сообщить ПФР об изменении сертификата.'");
КонецФункции
 
#КонецОбласти

#КонецОбласти