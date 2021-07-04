
#Область ПрограмныйИнтерфейс

// Выполняет заполнение состояния чат-бота.
// Данные из табличных частей дополняются новыми данными, а не заменяются.
//
// Параметры:
//  Состояние - СправочникССылка.СостоянияЧатБота - Заполняемое состояние
//  ТипСостояния - ПеречислениеСсылка.ТипыСостоянийЧатБота - Тип состояния
//  Действие  - Строка - Действие состояния
//  КлючевыеСлова      - Строка - ключевые слова для поиска состояния
//  Высказывание - Строка - Высказывания состояния
//  Параметры - ТаблицаЗначений - Параметры состояния
// 
Процедура ЗаполнитьСостояние(СостояниеСсылка, ТипСостояния = Неопределено, Действие = Неопределено,
	КлючевыеСлова = Неопределено, Высказывание = Неопределено, Параметры = Неопределено) Экспорт
	
	Состояние = СостояниеСсылка.ПолучитьОбъект();
	
	Если ЗначениеЗаполнено(ТипСостояния) Тогда
		
		Состояние.ТипСостояния = ТипСостояния;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Действие) Тогда
		
		Состояние.Действие = Действие;
		
	КонецЕсли;
	
	Состояние.Используется = Истина;
	
	Если ЗначениеЗаполнено(КлючевыеСлова) Тогда
		Состояние.КлючевыеСлова = КлючевыеСлова;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Высказывание) Тогда
		Состояние.Высказывание = Высказывание;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры) Тогда
	
		Для Каждого Параметр Из Параметры Цикл
		
			Строка = Состояние.Параметры.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, Параметр);
		
		КонецЦикла;
	
	КонецЕсли;
	
	Состояние.Записать();
	
КонецПроцедуры

#КонецОбласти
