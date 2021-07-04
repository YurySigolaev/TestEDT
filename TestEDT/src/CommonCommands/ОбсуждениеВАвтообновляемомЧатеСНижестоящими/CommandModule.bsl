
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Обсуждение = АвтообноновляемоеОбсуждение(ПараметрКоманды);
	
	Если Обсуждение = "НеПодключеноНетПравНаПодключение" Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Использование обсуждений недоступно. Обратитесь к администратору.'"));
		Возврат;
	ИначеЕсли Обсуждение = "НеПодключеноВозможноПодключить" Тогда
		ПредлагатьОбсужденияТекст = 
			НСтр("ru = 'Включить обсуждения?
				|
				|С их помощью пользователи смогут отправлять друг другу текстовые сообщения 
				|и совершать видеозвонки, создавать тематические обсуждения и вести переписку по документам.'");
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПредлагатьОбсужденияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОЗавершении, ПредлагатьОбсужденияТекст, РежимДиалогаВопрос.ДаНет);
		Возврат;
	ИначеЕсли Обсуждение = "ПревышенЛимит" Тогда
		ТекстПредупреждения = 
			НСтр("ru = 'Не удалось создать обсуждение: превышен лимит количества участников. Обратитесь к администратору.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);	
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Обсуждение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПредлагатьОбсужденияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбсужденияСлужебныйКлиент.ПоказатьПодключение();
	
КонецПроцедуры

&НаСервере
Функция АвтообноновляемоеОбсуждение(Знач КонтейнерСсылка)
	
	Если Не ОбсужденияСлужебныйВызовСервера.Подключены() Тогда
		Если ПравоДоступа("РегистрацияИнформационнойБазыСистемыВзаимодействия", Метаданные) Тогда 
			Возврат "НеПодключеноВозможноПодключить";
		Иначе 
			Возврат "НеПодключеноНетПравНаПодключение";
		КонецЕсли;
	КонецЕсли;
	
	Обсуждение = ОбсужденияДокументооборот.АвтообноновляемоеОбсуждение(КонтейнерСсылка, Истина);
	Возврат Обсуждение;
	
КонецФункции

#КонецОбласти
