////////////////////////////////////////////////////////////////////////////////
// Подсистема "Документооборот с Банком России".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ОтправитьОтчет(Организация, СсылкаНаОтчет, Пакет, ПараметрыАутентификации) Экспорт
	
	Возврат ДокументооборотСБанкомРоссии.ОтправитьОтчет(Организация, СсылкаНаОтчет, Пакет, ПараметрыАутентификации);

КонецФункции

Функция ПолучитьСтатусОтчета(Ссылка, ПараметрыАутентификации) Экспорт
	
	Возврат ДокументооборотСБанкомРоссии.ПолучитьСтатусОтчета(Ссылка, ПараметрыАутентификации);
	
КонецФункции

Функция ПроверитьВозможностьВыполненияОперации(ПараметрыАутентификации) Экспорт
	
	Возврат ДокументооборотСБанкомРоссии.ПроверитьВозможностьВыполненияОперации(ПараметрыАутентификации);
	
КонецФункции

Функция ПолучитьНастройки(Организация) Экспорт
	
	Возврат ДокументооборотСБанкомРоссии.ПолучитьНастройки(Организация);
	
КонецФункции

Функция СохранитьНастройки(Организация, Сертификат) Экспорт
	
	Возврат ДокументооборотСБанкомРоссии.СохранитьНастройки(Организация, Сертификат);
	
КонецФункции

Функция ПолучитьНеЗавершенныеОтправки(Организация) Экспорт
	
	Возврат ДокументооборотСБанкомРоссии.ПолучитьНеЗавершенныеОтправки(Организация);
	
КонецФункции

Функция ПолучитьПоследнююОтправкуОтчета(ОтчетСсылка) Экспорт
	
	Возврат ДокументооборотСБанкомРоссии.ПолучитьПоследнююОтправкуОтчета(ОтчетСсылка);
	
КонецФункции

#КонецОбласти