
//Выполняет вставку изображения штрихкода вместо тэга в файле Open Office Writer
//Параметры:
//			ДвоичныеДанныеКартинки - двоичные данные изображения штрихкода
//			ДвоичныеДанныеФайла - двоичные данные файла Open Office Writer, в который производится вставка
//			Тэг - строка, которая будет заменена в файле на изображение штрихкода
//Возвращает:
//			Имя временного файла Open Office Writer, в который вставлено изображение штрихкода
Функция ВставитьШтрихкодВФайлODTВместоТэга(ДвоичныеДанныеКартинки, ДвоичныеДанныеФайла, Тэг, ВысотаШтрихкода) Экспорт
	
	СтарыйПутьКФайлу = ПолучитьИмяВременногоФайла("odt");
	ДвоичныеДанныеФайла.Записать(СтарыйПутьКФайлу);
	НовыйПутьКФайлу = ПолучитьИмяВременногоФайла("odt");
	
	КопироватьФайл(СтарыйПутьКФайлу, СтрЗаменить(СтарыйПутьКФайлу, "odt", "zip"));
	ИмяФайлаСПутемZIP = СтрЗаменить(СтарыйПутьКФайлу, "odt", "zip");

	ВременнаяПапкаДляРазархивирования = ПолучитьИмяВременногоФайла("");
	ВременныйZIPФайл = ПолучитьИмяВременногоФайла("zip"); 

	Архив = Новый ЧтениеZipФайла();
	Архив.Открыть(ИмяФайлаСПутемZIP);
	Архив.ИзвлечьВсе(ВременнаяПапкаДляРазархивирования, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	Архив.Закрыть();

	ИДКартинки = "";
	СохранитьИзображениеВоВнутреннейСтруктуреФайла(ДвоичныеДанныеКартинки, ВременнаяПапкаДляРазархивирования, ИДКартинки);
	
	//Заполнение тела документа
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content.xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.Отступ = Ложь;
	ЗаписьXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content_update.xml");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаготовкаДляВставкиШтрихкода = 
		"<draw:frame draw:name=""" + Тэг + """ text:anchor-type=""as-char"" svg:y=""-3.395cm"" svg:width=""11.198cm"" svg:height=""_ВысотаШтрихкода_mm"" draw:z-index=""0"">
		|	<draw:image xlink:href=""Pictures/" + ИДКартинки + ".png"" xlink:type=""simple"" xlink:show=""embed"" xlink:actuate=""onLoad""/>
		|</draw:frame>";
	
	ВертикальноеСмещениеЧисло = "";
	ГоризонтальноеСмещениеЧисло = "";
	ВставленныйШтрихкод = Ложь;
	РедактированиеКартинки = Ложь;
	
	// Обязательно нужно ставить Ложь, иначе будут пропадать пробелы
	ЧтениеXML.ИгнорироватьПробелы = Ложь;
	
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			ЗаписьXML.ЗаписатьНачалоЭлемента(ЧтениеXML.Имя);
			Если ВставленныйШтрихкод И ЧтениеXML.Имя = "draw:image" Тогда
				РедактированиеКартинки = Истина;
			КонецЕсли;
			Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
				Если ЧтениеXML.Имя = "draw:name" И ЧтениеXML.Значение = Тэг Тогда
					ВставленныйШтрихкод = Истина;
					ЗаписьXML.ЗаписатьАтрибут(ЧтениеXML.Имя,ЧтениеXML.Значение);
				ИначеЕсли ЧтениеXML.Имя = "svg:height" И ВставленныйШтрихкод Тогда
					ЗаписьXML.ЗаписатьАтрибут(ЧтениеXML.Имя, Строка(ВысотаШтрихкода) + "mm");
				ИначеЕсли РедактированиеКартинки И ВставленныйШтрихкод И ЧтениеXML.Имя = "xlink:href" Тогда
					ЗаписьXML.ЗаписатьАтрибут(ЧтениеXML.Имя, "Pictures/" + ИДКартинки + ".png");
					РедактированиеКартинки = Ложь;
					ВставленныйШтрихкод = Ложь;
				Иначе
					ЗаписьXML.ЗаписатьАтрибут(ЧтениеXML.Имя,ЧтениеXML.Значение);
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			
			Если Найти(ЧтениеXML.Значение, Тэг) > 0 Тогда
				СтрокаДляВставкиШтампа = ЗаготовкаДляВставкиШтрихкода;
				СтрокаДляВставкиШтампа = СтрЗаменить(СтрокаДляВставкиШтампа, "_ВысотаШтрихкода_", ВысотаШтрихкода);
				ЗначениеДляЗаписи = СтрЗаменить(ЧтениеXML.Значение, Тэг, СтрокаДляВставкиШтампа);
                ЗаписьXML.ЗаписатьБезОбработки(ЗначениеДляЗаписи);
			Иначе
              	ЗаписьXML.ЗаписатьТекст(ЧтениеXML.Значение);
			КонецЕсли;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЦикла;	
	
	ЧтениеXML.Закрыть();
	ЗаписьXML.Закрыть();
	ПереместитьФайл(ВременнаяПапкаДляРазархивирования + "/content_update.xml", ВременнаяПапкаДляРазархивирования + "/content.xml");
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования + "/content_update.xml");
	
	Архиватор = Новый ЗаписьZipФайла(ВременныйZIPФайл, "", "");
	Архиватор.Добавить(ВременнаяПапкаДляРазархивирования + "\*.*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архиватор.Записать();

	ПереместитьФайл(ВременныйZIPФайл, НовыйПутьКФайлу);
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования);	
	УдалитьФайлы(СтарыйПутьКФайлу);
	УдалитьФайлы(ВременныйZIPФайл);
	
	ДвоичныеДанныеЗаполненногоФайла = Новый ДвоичныеДанные(НовыйПутьКФайлу);
	УдалитьФайлы(НовыйПутьКФайлу);
	Возврат ДвоичныеДанныеЗаполненногоФайла;	
	
КонецФункции

Процедура СохранитьИзображениеВоВнутреннейСтруктуреФайла(ДвоичныеДанныеКартинки, ВременнаяПапкаДляРазархивирования, ИДКартинки)
	
	//сохранение картинки в внутренней структуре документа
	ИДКартинки = СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", "");
	//непосредственное сохранение
	КартинкаШК = Новый Картинка(ДвоичныеДанныеКартинки);
	СоздатьКаталог(ВременнаяПапкаДляРазархивирования + "/Pictures");
	КартинкаШК.Записать(ВременнаяПапкаДляРазархивирования + "/Pictures/" + ИДКартинки + ".png");
	
	//изменение META-INF/manifest.xml
	ЧтениеXMLМанифест = Новый ЧтениеXML();
	ЧтениеXMLМанифест.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/META-INF/manifest.xml");
	ЗаписьXMLМанифест = Новый ЗаписьXML;
	ЗаписьXMLМанифест.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/META-INF/manifest_update.xml");
	ЗаписьXMLМанифест.ЗаписатьОбъявлениеXML();
	
	Пока ЧтениеXMLМанифест.Прочитать() Цикл
		Если ЧтениеXMLМанифест.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			ЗаписьXMLМанифест.ЗаписатьНачалоЭлемента(ЧтениеXMLМанифест.Имя);
			Пока ЧтениеXMLМанифест.ПрочитатьАтрибут() Цикл
				ЗаписьXMLМанифест.ЗаписатьАтрибут(ЧтениеXMLМанифест.Имя,ЧтениеXMLМанифест.Значение); 
			КонецЦикла;
		ИначеЕсли ЧтениеXMLМанифест.ТипУзла = ТипУзлаXML.Текст Тогда
			ЗаписьXMLМанифест.ЗаписатьТекст(ЧтениеXMLМанифест.Значение);
		ИначеЕсли ЧтениеXMLМанифест.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Если ЧтениеXMLМанифест.Имя = "manifest:manifest" Тогда
				НоваяСтрока = "<manifest:file-entry manifest:media-type=""image/png"" manifest:full-path=""Pictures/" + ИДКартинки + ".png""/>";
				ЗаписьXMLМанифест.ЗаписатьБезОбработки(НоваяСтрока);
			КонецЕсли;
			ЗаписьXMLМанифест.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЦикла;
	ЧтениеXMLМанифест.Закрыть();
	ЗаписьXMLМанифест.Закрыть();
	ПереместитьФайл(ВременнаяПапкаДляРазархивирования + "/META-INF/manifest_update.xml", ВременнаяПапкаДляРазархивирования + "/META-INF/manifest.xml");
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования + "/META-INF/manifest_update.xml");
	
КонецПроцедуры

//Выполняет вставку изображения штрихкода в указанное место в файле Open Office Writer 
//Параметры:
//			ДвоичныеДанныеКартинки - двоичные данные изображения штрихкода
//			ДвоичныеДанныеФайла - двоичные данные файла Open Office Writer, в который производится вставка
//			ДанныеОПоложении - структура
//				СмещениеПоГоризонтали - смещение изображения штрихкода по горизонтали
//				СмещениеПоВертикали - смещение изображения штрихкода по вертикали
//Возвращает:
//			Имя временного файла Open Office Writer, в который вставлено изображение штрихкода
//Примечание: 
//	Если смещение по горизонтали или по вертикали указано как MAX или MIN, 
//	то изображение штрихкода будет приклеено к соответствующему углу ПЕЧАТНОЙ ОБЛАСТИ файла.
//	Если смещение задано в виде количества миллиметров, то смещение изображения штрихкода будет
//	установлено от КРАЯ СТРАНИЦЫ.
Функция ВставитьИзображениеЭПВФайлODTСУказаниемПоложения(ДвоичныеДанныеКартинки, 
	ДвоичныеДанныеФайла, ПоложениеНаСтранице, ВысотаКартинки) Экспорт 
	
	СтарыйПутьКФайлу = ПолучитьИмяВременногоФайла("odt");
	ДвоичныеДанныеФайла.Записать(СтарыйПутьКФайлу);
	НовыйПутьКФайлу = ПолучитьИмяВременногоФайла("odt");
	
	КопироватьФайл(СтарыйПутьКФайлу, СтрЗаменить(СтарыйПутьКФайлу, "odt", "zip"));
	ИмяФайлаСПутемZIP = СтрЗаменить(СтарыйПутьКФайлу, "odt", "zip");

	ВременнаяПапкаДляРазархивирования = ПолучитьИмяВременногоФайла("");
	ВременныйZIPФайл = ПолучитьИмяВременногоФайла("zip"); 

	Архив = Новый ЧтениеZipФайла();
	Архив.Открыть(ИмяФайлаСПутемZIP);
	Архив.ИзвлечьВсе(ВременнаяПапкаДляРазархивирования, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	Архив.Закрыть();
	
	ИДКартинки = "";
	СохранитьИзображениеВоВнутреннейСтруктуреФайла(ДвоичныеДанныеКартинки, ВременнаяПапкаДляРазархивирования, ИДКартинки);
	
	//Заполнение тела документа
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content.xml");
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.Отступ = Ложь;
	ЗаписьXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content_update.xml");
	ЗаписьXML.ЗаписатьОбъявлениеXML();

	ЗаготовкаДляСтилей = 
	"<style:style style:name=""fr" + ИДКартинки + """ style:family=""graphic"" style:parent-style-name=""Graphics"">
	|	<style:graphic-properties
	|		style:wrap=""run-through""
	|		style:vertical-pos=""_ВертикальноеСмещение_"" 
	|		style:vertical-rel=""_ОтносительноЧегоСчитатьВертикальноеСмещение_""        
	|		style:horizontal-pos=""_ГоризонтальноеСмещение_"" 
	|		style:horizontal-rel=""_ОтносительноЧегоСчитатьГоризонтальноеСмещение_"">
	|	</style:graphic-properties>
	|</style:style>";
	
	ЗаготовкаДляВставкиШтрихкода = 
	"<draw:frame draw:style-name=""fr" + ИДКартинки + """ draw:name=""Графический объект1"" text:anchor-type=""page"" _ВертикальноеСмещениеЧисло_ _ГоризонтальноеСмещениеЧисло_ text:anchor-page-number=""1"" svg:width=""11.198cm"" svg:height=""_ВысотаШтрихкода_mm"" draw:z-index=""3"">
	|	<draw:image xlink:href=""Pictures/" + ИДКартинки + ".png"" xlink:type=""simple"" xlink:show=""embed"" xlink:actuate=""onLoad""/>
	|</draw:frame>";
	
	ВертикальноеСмещениеЧисло = "";
	ГоризонтальноеСмещениеЧисло = "";
	ВставкаВыполнена = Ложь;
	ВставитьСтиль = Ложь;
	ВставитьШтрихкод = Ложь;
	
	// Обязательно нужно ставить Ложь, иначе будут пропадать пробелы
	ЧтениеXML.ИгнорироватьПробелы = Ложь;
	
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			Если ЧтениеXML.Имя = "office:automatic-styles" И НЕ ВставкаВыполнена Тогда
				ВставитьСтиль = Истина;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:p" И НЕ ВставкаВыполнена Тогда
				ВставитьШтрихкод = Истина;
			КонецЕсли;
			
			ЗаписьXML.ЗаписатьНачалоЭлемента(ЧтениеXML.Имя);
			Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
				ЗаписьXML.ЗаписатьАтрибут(ЧтениеXML.Имя,ЧтениеXML.Значение); 
			КонецЦикла;
			
			Если ВставитьСтиль = Истина И НЕ ВставкаВыполнена Тогда
				//запись стилей
				НовыеСтили = ЗаготовкаДляСтилей;
				ОтносительноЧегоСчитатьВертикальноеСмещение =  	"page-content";
				ОтносительноЧегоСчитатьГоризонтальноеСмещение =	"page-content";
				ВертикальноеСмещениеЧисло = "";
				ГоризонтальноеСмещениеЧисло = "";
				
				Если ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыПечатиШтампаЭП.ПравыйНижний") Тогда
					ВертикальноеСмещение = "bottom";
					ГоризонтальноеСмещение = "right";
				ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыПечатиШтампаЭП.ПравыйВерхний") Тогда
					ВертикальноеСмещение = "top";
					ГоризонтальноеСмещение = "right";
				ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыПечатиШтампаЭП.ЛевыйВерхний") Тогда
					ВертикальноеСмещение = "top";
					ГоризонтальноеСмещение = "left";
				ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыПечатиШтампаЭП.ЛевыйНижний") Тогда
					ВертикальноеСмещение = "bottom";
					ГоризонтальноеСмещение = "left";
				Иначе
					//ОтносительноЧегоСчитатьВертикальноеСмещение =  	"page";
					//ОтносительноЧегоСчитатьГоризонтальноеСмещение =	"page";
					//ВертикальноеСмещение = "from-top";
					//ГоризонтальноеСмещение = "from-left";
					//ВертикальноеСмещениеЧисло = "svg:y=""" + ДанныеОПоложении.СмещениеПоВертикали + "mm""";
					//ГоризонтальноеСмещениеЧисло = "svg:x=""" + ДанныеОПоложении.СмещениеПоГоризонтали + "mm""";
				КонецЕсли;
				
				НовыеСтили = СтрЗаменить(НовыеСтили, "_ВертикальноеСмещение_", ВертикальноеСмещение);
				НовыеСтили = СтрЗаменить(НовыеСтили, "_ГоризонтальноеСмещение_", ГоризонтальноеСмещение);
				НовыеСтили = СтрЗаменить(НовыеСтили, "_ОтносительноЧегоСчитатьВертикальноеСмещение_", ОтносительноЧегоСчитатьВертикальноеСмещение);
				НовыеСтили = СтрЗаменить(НовыеСтили, "_ОтносительноЧегоСчитатьГоризонтальноеСмещение_", ОтносительноЧегоСчитатьГоризонтальноеСмещение);

				ЗаписьXML.ЗаписатьБезОбработки(НовыеСтили);
			КонецЕсли;
			
			Если ВставитьШтрихкод = Истина И НЕ ВставкаВыполнена Тогда
				СтрокаДляВставкиШтампа = ЗаготовкаДляВставкиШтрихкода;
				СтрокаДляВставкиШтампа = СтрЗаменить(СтрокаДляВставкиШтампа, "_ВертикальноеСмещениеЧисло_", ВертикальноеСмещениеЧисло);
				СтрокаДляВставкиШтампа = СтрЗаменить(СтрокаДляВставкиШтампа, "_ГоризонтальноеСмещениеЧисло_", ГоризонтальноеСмещениеЧисло);
				СтрокаДляВставкиШтампа = СтрЗаменить(СтрокаДляВставкиШтампа, "_ВысотаШтрихкода_", ВысотаКартинки);
                ЗаписьXML.ЗаписатьБезОбработки(СтрокаДляВставкиШтампа);
				ВставкаВыполнена = Истина;
			КонецЕсли;

		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			ЗаписьXML.ЗаписатьТекст(ЧтениеXML.Значение);
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
						
			ЗаписьXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЦикла;	
	
	ЧтениеXML.Закрыть();
	ЗаписьXML.Закрыть();
	ПереместитьФайл(ВременнаяПапкаДляРазархивирования + "/content_update.xml", ВременнаяПапкаДляРазархивирования + "/content.xml");
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования + "/content_update.xml");
	
	Архиватор = Новый ЗаписьZipФайла(ВременныйZIPФайл, "", "");
	Архиватор.Добавить(ВременнаяПапкаДляРазархивирования + "\*.*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архиватор.Записать();

	ПереместитьФайл(ВременныйZIPФайл, НовыйПутьКФайлу);
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования);	
	УдалитьФайлы(СтарыйПутьКФайлу);
	УдалитьФайлы(ВременныйZIPФайл);
	
	ДвоичныеДанныеЗаполненногоФайла = Новый ДвоичныеДанные(НовыйПутьКФайлу);
	УдалитьФайлы(НовыйПутьКФайлу);
	Возврат ДвоичныеДанныеЗаполненногоФайла;	
			
КонецФункции

