
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВидСобытия = ОбщегоНазначенияДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(ПараметрКоманды, "ВидСобытия");
	ПараметрыФормы = Новый Структура("ВидСобытия", ВидСобытия);
	ОткрытьФорму("РегистрСведений.СвязьПользовательскихОбработчиковБизнесСобытийИВидаСобытий.Форма.ФормаСпискаДляВидаСобытия", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры
