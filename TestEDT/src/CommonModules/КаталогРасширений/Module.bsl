// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//	УстанавливаемыеРасширения - Массив Из Структура - со свойствами:
//		* Идентификатор - УникальныйИдентификатор - идентификатор расширения в сервисе.
//		* Представление - Строка - представление расширения. 
//		* Инсталляция - УникальныйИдентификатор - новый идентификатор инсталляции.
//		
// Возвращаемое значение:
// 	Булево - Истина, если успешно, Ложь - в противном случае.
//
Функция ВосстановитьРасширенияВНовойОбласти(Знач УстанавливаемыеРасширения) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  КодОбластиДанных - Число - 
//  
// Возвращаемое значение:
//	Структура - со свойствами:
//	 * КлючОбластиДанных - Строка - 
//	 * РасширенияДляВосстановления - см. ВосстановитьРасширенияВНовойОбласти.УстанавливаемыеРасширения
//
Функция ПолучитьРасширенияДляНовойОбласти(Знач КодОбластиДанных) Экспорт
КонецФункции

#КонецОбласти