﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ЗаписанныеФайлы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Объект.КаталогПрограммы = КаталогПрограммы(); 
	Объект.ИмяФайлаНастроекЗахвата = ПолучитьИмяВременногоФайла("xml");  
	ЗаписанныеФайлы = Новый Соответствие;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)  
	
	Если Не ЗавершениеРаботы Тогда 
		ЗаписатьНастройки();	
	КонецЕсли;
	
	Для Каждого ЭлементЗаписанных Из ЗаписанныеФайлы Цикл
		Попытка      
			УдалитьФайлы(ЭлементЗаписанных.Ключ);
		Исключение   
			// Действий не предусмотрено
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСконструировать(Команда)
	КомандаСконструироватьНаСервере(); 
	Элементы.СтраницыНастроек.ТекущаяСтраница = Элементы.ГруппаРезультат;
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьФайл(Команда)
    ЗаписатьФайлНаКлиенте();
	ПоказатьОповещениеПользователя("Файл записан");
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗапуститьКонфигуратор(Команда)
	
	ЗаписатьФайлНаКлиенте();                
	
	КодЗавершения = Неопределено;     
	ОжидатьЗавершение = Ложь; // Пока сделал без ожидания завершения
	ЗапуститьПриложение(Объект.СтрокаЗапуска, , ОжидатьЗавершение, КодЗавершения);
	
	Если ОжидатьЗавершение Тогда 
		Если КодЗавершения=0 Тогда 
			ПоказатьОповещениеПользователя("Запуск конфигуратора успешно выполнен");
		Иначе
			ПоказатьОповещениеПользователя("При запуске конфигуратора возникла ошибка.
				|Код завершения: " + КодЗавершения);
		КонецЕсли;                   
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьРежимЗахвата(Команда) 
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьУстановкуРежимЗахвата", ЭтотОбъект);
	ОткрытьФорму("ВнешняяОбработка.ЗахватОбъектовПоПодсистемам.Форма.ФормаВыборРежимаЗахвата", , 
		ЭтаФорма, УникальныйИдентификатор, , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаКлиенте
Процедура ОбработатьУстановкуРежимЗахвата(ВведенноеЧисло, ДополнительныеПараметры) Экспорт  
	
	Если ВведенноеЧисло=Неопределено Тогда 
		Возврат;
	КонецЕсли;
	Если ВведенноеЧисло<0 Или ВведенноеЧисло>2 Тогда
		ВызватьИсключение(НСтр("ru = 'Введите число от 0 до 2'"));
	КонецЕсли;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ДеревоПодсистем.ВыделенныеСтроки Цикл  
		Объект.ДеревоПодсистем.НайтиПоИдентификатору(ВыделеннаяСтрока).РежимЗахвата = ВведенноеЧисло;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройки() 
	РеквизитФормыВЗначение("Объект").ЗаписатьНастройки();
КонецПроцедуры

&НаСервере
Процедура КомандаСконструироватьНаСервере()
	О = РеквизитФормыВЗначение("Объект");
	О.СформироватьСтрокуЗапуска();
	ЗначениеВРеквизитФормы(О, "Объект");
КонецПроцедуры  

&НаКлиенте
Процедура ЗаписатьФайлНаКлиенте()    
	
	Текст = Новый ТекстовыйДокумент;
	Текст.УстановитьТекст(Объект.НастройкиЗахватаОбъектов);
	Текст.Записать(Объект.ИмяФайлаНастроекЗахвата, КодировкаТекста.UTF8);  
	
	ЗаписанныеФайлы.Вставить(Объект.ИмяФайлаНастроекЗахвата);
	
КонецПроцедуры

#КонецОбласти