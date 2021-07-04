
//Изменяет запись о трудозатрате для дальнейшего удаления в мобильном приложении
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь для изменения
//  День - Дата - День для отбора трудозатраты
//  НомерДобавления - НомерДобавления для трудозатраты
Процедура ЗафиксироватьУдалениеЗаписиОТрудозатрате(Пользователь, День, НомерДобавления) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМобильныеКлиенты") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерДобавления) Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.МП_ИзмененныеТрудозатраты.УдалитьЗаписьОТрудозатрате(Пользователь, День, НомерДобавления);
	
КонецПроцедуры
