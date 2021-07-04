
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЯзыкиРаспознавания = РаботаСФайламиВызовСервера.ЯзыкиРаспознаванияПрограммы(
		Перечисления.ПрограммыРаспознавания.CuneiForm);
	Для Каждого Запись Из ЯзыкиРаспознавания Цикл
		Элементы.ЯзыкРаспознавания.СписокВыбора.Добавить(Запись.Language, Запись.Name);
	КонецЦикла;
	
	ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
	ПользовательЗаданияРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПользователяЗаданияРаспознавания();
	
	Если ПользовательЗаданияРаспознавания.Пустая() Тогда
		МенятьАвтораНовогоФайлаИлиВерсии = Ложь;
		Элементы.ПользовательЗаданияРаспознавания.Доступность = Ложь;
	Иначе
		МенятьАвтораНовогоФайлаИлиВерсии = Истина;
	КонецЕсли;	
	
	ИспользоватьImageMagickДляРаспознаванияPDF = РаботаСФайламиВызовСервера.ПолучитьИспользоватьImageMagickДляРаспознаванияPDF();
	ПутьКПрограммеКонвертацииPDF = РаботаСФайламиВызовСервера.ПолучитьПутьКПрограммеКонвертацииPDF();
	
	Элементы.ПутьКПрограммеКонвертацииPDF.Доступность = ИспользоватьImageMagickДляРаспознаванияPDF;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МенятьАвтораНовогоФайлаИлиВерсииПриИзменении(Элемент)
	
	Если НЕ МенятьАвтораНовогоФайлаИлиВерсии Тогда
		ПользовательЗаданияРаспознавания = ПользовательПустаяСсылка;
		Элементы.ПользовательЗаданияРаспознавания.Доступность = Ложь;
	Иначе
		Элементы.ПользовательЗаданияРаспознавания.Доступность = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьImageMagickПриИзменении(Элемент)
	
	Элементы.ПутьКПрограммеКонвертацииPDF.Доступность = ИспользоватьImageMagickДляРаспознаванияPDF;
	
	Если ИспользоватьImageMagickДляРаспознаванияPDF Тогда
		
		Текст = НСтр("ru = 'Включено использование ImageMagick для распознавания PDF. 
		|Для работы этой настройки необходимо установить бесплатные программы ImageMagick и Ghostscript.
		|Поставить в очередь на распознавание все существующие файлы формата PDF?'");		
		
		Обработчик = Новый ОписаниеОповещения("ПослеВопросаОПостановкеВОчередь", ЭтотОбъект);	 
		ПоказатьВопрос(Обработчик, Текст, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОПостановкеВОчередь(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат= КодВозвратаДиалога.Да Тогда
		
		Состояние(НСтр("ru = 'Формируется очередь распознавания файлов формата PDF. Пожалуйста подождите...'"));
		
		ЧислоКартинок = ПоставитьВсеPDFВОчередьРаспознавания();
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Очередь распознавания файлов формата PDF сформирована (файлов: %1).'"), ЧислоКартинок);
		Состояние(ТекстСообщения);
		
	КонецЕсли;	  
		
КонецПроцедуры	

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	РаботаСФайламиВызовСервера.УстановитьПараметрыРаспознаванияCuneiForm(
		ЯзыкРаспознавания,
		ПользовательЗаданияРаспознавания,
		ИспользоватьImageMagickДляРаспознаванияPDF,
		ПутьКПрограммеКонвертацииPDF);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоставитьВсеPDFВОчередьРаспознавания()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧислоКартинок = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.Ссылка,
		|	Файлы.ТекущаяВерсияРасширение
		|ИЗ
		|	Справочник.Файлы КАК Файлы";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		РасширениеПоддерживается = (НРег(Выборка.ТекущаяВерсияРасширение) = "pdf");
		
		Если РасширениеПоддерживается Тогда
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз;
			Объект.ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ЯзыкРаспознаванияCuneiFormПоУмолчанию();
			Объект.Записать();
			ЧислоКартинок = ЧислоКартинок + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииФайлов.Ссылка,
		|	ВерсииФайлов.Расширение
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		РасширениеПоддерживается = (НРег(Выборка.Расширение) = "pdf");
		
		Если РасширениеПоддерживается Тогда
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.СтатусРаспознаванияТекста = Перечисления.СтатусыРаспознаванияТекста.НужноРаспознать;
			Объект.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
	
	Возврат ЧислоКартинок;
	
КонецФункции

#КонецОбласти






