﻿
Перем мПустойЦвет;
Перем мЦветШапки;
Перем мЦветОсобогоЗначения;
Перем мЦветБулево;
Перем мЦветДата;
Перем мШиринаКолонокПоУмолчанию;
Перем мДляСсылокВыводитьГУИД;
Перем мМакет;
Перем мТипВсеСсылки;
Перем мТипЧисло;
Перем мТипСтрока;
Перем мТипДата;
Перем мТипБулево;
Перем мТипРезультатЗапроса;
Перем мТипОписаниеТипов;

Перем мАктуальныеРезультаты;
Перем мАвтоширинаКолонок;
Перем мСоставРезультатов;
Перем мВыводитьНомераСтрок;

Перем мЗначения;

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
// Переменные БСП

Перем Команда_Первая ЭКСПОРТ;
Перем ВерсияОбработки;
	
////////// ПОДКЛЮЧЕНИЕ ВНЕШНЕЙ ОБРАБОТКИ
//
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	Если НЕ МодульСуществует("ДополнительныеОтчетыИОбработкиКлиентСервер") тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Модуль_ДополнительныеОтчетыИОбработкиКлиентСервер = ОбщийМодуль("ДополнительныеОтчетыИОбработкиКлиентСервер");
		
	МассивНазначений     = Новый Массив;
	ПараметрыРегистрации = Новый Структура;
	
	ПараметрыРегистрации.Вставить("Вид",             Модуль_ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка());
	ПараметрыРегистрации.Вставить("Назначение",      МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование",    ЭтотОбъект.Метаданные().Синоним);
	ПараметрыРегистрации.Вставить("Версия",          ВерсияОбработки);
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация",      ЭтотОбъект.Метаданные().Комментарий);
	ПараметрыРегистрации.Вставить("ВерсияБСП",       "2.1.3.1");

	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	
	ДобавитьКоманду(ТаблицаКоманд,
					НСтр("ru = 'Консоль запросов (ARD)'"),
					Команда_Первая,
					Модуль_ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы(),
					Истина,
					"");
	
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	
КонецПроцедуры

//////////


Процедура ПолучитьДеревоИзФайла(АдресХранилища, ДеревоЗапросов, ШиринаКолонокПоУмолчанию) Экспорт
	
	мШиринаКолонокПоУмолчанию = ШиринаКолонокПоУмолчанию;
	ДеревоИзФайла = ПолучитьДеревоИзХранилища(АдресХранилища);
	Элементы = ДеревоЗапросов.ПолучитьЭлементы();
	Элементы.Очистить();
	ИмеетсяШиринаКолонок = (ДеревоИзФайла.Колонки.Найти("ШиринаКолонок") <> Неопределено);
	ЗаполнитьУровеньПроксиДерева(Элементы, ДеревоИзФайла.Строки, ИмеетсяШиринаКолонок);
	УдалитьИзВременногоХранилища(АдресХранилища);
	
КонецПроцедуры

Функция ВыполнитьЗапрос(ПараметрыВызова) Экспорт
	
	ТекстЗапроса 	       = ПараметрыВызова.ТекстЗапроса;
	ПараметрыЗапроса 	   = ПараметрыВызова.ПараметрыЗапроса;
	СпособВыгрузки         = ПараметрыВызова.СпособВыгрузки;
	мСоставРезультатов     = ПараметрыВызова.СоставРезультатов;
	ДляСсылокВыводитьГУИД  = ПараметрыВызова.ДляСсылокВыводитьГУИД;
	КодУстановкиПараметров = ПараметрыВызова.КодУстановкиПараметров;
	АктуальныеРезультаты   = ПараметрыВызова.АктуальныеРезультаты;
	мАвтоширинаКолонок     = ПараметрыВызова.АвтоширинаКолонок;
	мВыводитьНомераСтрок   = ПараметрыВызова.ВыводитьНомераСтрок;
		
	мДляСсылокВыводитьГУИД = ДляСсылокВыводитьГУИД;
	мАктуальныеРезультаты = АктуальныеРезультаты;
	ПодготовитьСтандартныеЗначения();
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Если мСоставРезультатов <> 1 тогда
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	КонецЕсли;
	
	ИмяПараметраТип = "";
	
	Для каждого ОписаниеПараметра из ПараметрыЗапроса Цикл
		Значение = ОписаниеПараметра.ЗначениеПараметра;
		Если ТипЗнч(Значение) = мТипОписаниеТипов Тогда
			ЗаданныеТипы = Значение.Типы();
			Если ЗаданныеТипы.Количество() > 0 Тогда
				Запрос.УстановитьПараметр(ОписаниеПараметра.ИмяПараметра, ЗаданныеТипы[0]);	
			Иначе
				ИмяПараметраТип = ОписаниеПараметра.ИмяПараметра;
				Прервать;
			КонецЕсли;
		Иначе
			Запрос.УстановитьПараметр(ОписаниеПараметра.ИмяПараметра, Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(КодУстановкиПараметров) Тогда
		Попытка
			Выполнить(КодУстановкиПараметров);
		Исключение
		    Возврат "Ошибка в коде установки параметров: " + Строка(ОписаниеОшибки());
		КонецПопытки; 
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИмяПараметраТип) Тогда
		Возврат "Для параметра """ + ИмяПараметраТип + """ не задано значение типа";
	КонецЕсли;
	
	Попытка
		
		Замер_Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
		МассивРезультатов = Запрос.ВыполнитьПакет();
		Замер_Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ВремяВыполненияЗапроса = Замер_Конец-Замер_Начало;
		
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки;
	
	Если ДляСсылокВыводитьГУИД Тогда
		мТипВсеСсылки = ПолучитьВсеСсылки();
	КонецЕсли;
	
	соАктуальные = Новый Соответствие;
	Если мАктуальныеРезультаты тогда
		
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
		Индекс = 0;
		Для каждого Пакет из СхемаЗапроса.ПакетЗапросов цикл
			Если ТипЗнч(Пакет) = Тип("ЗапросВыбораСхемыЗапроса") И Пакет.ТаблицаДляПомещения = "" тогда
				соАктуальные.Вставить(Индекс, Истина);
			КонецЕсли;
			Индекс = Индекс+1;
		КонецЦикла;
		
	КонецЕсли;
	
	ВсегоСтрок = 0;
	ВсегоСтрокВТ = 0;
	
	Замер_Начало = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	Если мСоставРезультатов = 1 Тогда 							// только запросы
		Моксель = ПолучитьРезультатыЗапросов(МассивРезультатов, СпособВыгрузки, соАктуальные, ВсегоСтрок);
	ИначеЕсли мСоставРезультатов = 2 Тогда 						// запросы и временные таблицы
		Моксель = ПолучитьРезультатыЗапросов(МассивРезультатов, СпособВыгрузки, соАктуальные, ВсегоСтрок);
		Моксель.Вывести(ПолучитьРезультатыВременыхТаблиц(Запрос, ВсегоСтрокВТ));
	ИначеЕсли мСоставРезультатов = 3 Тогда						// только временные таблицы
		Моксель = ПолучитьРезультатыВременыхТаблиц(Запрос, ВсегоСтрокВТ);
	КонецЕсли;
	
	Моксель.Область().РежимИзмененияРазмераКолонки = РежимИзмененияРазмера.БыстроеИзменение;

	Замер_Конец = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ВремяФормированияТабДока = Замер_Конец-Замер_Начало;
	
	ВсегоСтрок = ВсегоСтрок+ВсегоСтрокВТ;
	
	Если мСоставРезультатов > 1 тогда
		Запрос.МенеджерВременныхТаблиц.Закрыть();
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Моксель", Моксель);
	Результат.Вставить("ВремяВыполненияЗапроса", 	ВремяВыполненияЗапроса);
	Результат.Вставить("ВремяФормированияТабДока",	ВремяФормированияТабДока);
	Результат.Вставить("ВсегоСтрок",				ВсегоСтрок);
	
	Если ЭтотОбъект.ПодборСсылок тогда
		Результат.Вставить("МассивСсылок", ПолучитьМассивСсылок(МассивРезультатов[МассивРезультатов.Количество()-1]));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПреобразоватьДерево(ДеревоЗапросов) Экспорт
	Путь = ГенерироватьПуть();
	ЗначениеВФайл(Путь, ПолучитьДеревоЗначенийИзПрокси(ДеревоЗапросов));
	АдресХранилища = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Путь));
	УдалитьФайлы(Путь);
	Возврат АдресХранилища;
КонецФункции

Функция ЗаполнитьПараметрыЗапроса(ДеревоЗапросов, ИдентификаторТекущихДанных) Экспорт
	ТекущиеДанные = ДеревоЗапросов.НайтиПоИдентификатору(ИдентификаторТекущихДанных);
	СтруктураПараметров = Новый Структура();
	ТекстЗапроса = ТекущиеДанные.ТекстЗапроса;
	Если  НЕ ПустаяСтрока(ТекстЗапроса) Тогда
		Запрос = Новый Запрос(ТекстЗапроса);
		Попытка
			НайденныеПараметры = Запрос.НайтиПараметры();
		Исключение
			Возврат ОписаниеОшибки();
		КонецПопытки;
		Для каждого ПараметрЗапроса из НайденныеПараметры Цикл
			СтруктураПараметров.Вставить(ПараметрЗапроса.Имя, ПараметрЗапроса.ТипЗначения);
		КонецЦикла;
	КонецЕсли;
	Возврат СтруктураПараметров;
КонецФункции

Функция ПолучитьВсеСсылки() Экспорт
	Имена = 
	"Справочники
	|Документы
	|Перечисления
	|ПланыВидовХарактеристик
	|ПланыСчетов
	|ПланыВидовРасчета
	|ПланыОбмена
	|БизнесПроцессы
	|Задачи";
	ЧислоИмен = СтрЧислоСтрок(Имена);
	ВсеСсылки = Новый ОписаниеТипов(Новый Массив());
	Для Номер = 1 по ЧислоИмен Цикл
		ВсеСсылки = Новый ОписаниеТипов(ВсеСсылки, Вычислить(СтрПолучитьСтроку(Имена, Номер)).ТипВсеСсылки().Типы());
	КонецЦикла;
	ВсеСсылки = Новый ОписаниеТипов(ВсеСсылки, БизнесПроцессы.ТипВсеСсылкиТочекМаршрутаБизнесПроцессов().Типы());
	Возврат ВсеСсылки;
КонецФункции

// -----------------------------

Функция ПолучитьДеревоИзХранилища(АдресХранилища)
	Путь = ГенерироватьПуть();
	ПолучитьИзВременногоХранилища(АдресХранилища).Записать(Путь);
	Дерево = ЗначениеИзФайла(Путь);
	УдалитьФайлы(Путь);
	Возврат Дерево;
КонецФункции

Функция ГенерироватьПуть()
	Возврат КаталогВременныхФайлов() + "QLst-" + Строка(Новый УникальныйИдентификатор()) + ".tmp";
КонецФункции

Функция ПолучитьРезультатыЗапросов(МассивРезультатов, СпособВыгрузки, АктуальныеРезультаты, КоличествоСтрок) Экспорт

	Если МассивРезультатов.Количество() > 1 Тогда
		Если мАктуальныеРезультаты И АктуальныеРезультаты.Количество()=1 тогда        
			Для каждого АР из АктуальныеРезультаты цикл
				
				Если мСоставРезультатов=2 тогда
					
					врМоксель = ЗаполнитьМоксель(МассивРезультатов[АР.Ключ], СпособВыгрузки, КоличествоСтрок);

					Моксель = Новый ТабличныйДокумент;
					Моксель.Вывести(СформироватьЗаголовокЗапроса(0, КоличествоСтрок));
					Моксель.НачатьГруппуСтрок(,Ложь);
					Моксель.Вывести(врМоксель);
					Моксель.ЗакончитьГруппуСтрок();
					
				Иначе
					
					Моксель = ЗаполнитьМоксель(МассивРезультатов[АР.Ключ], СпособВыгрузки, КоличествоСтрок);	
					
				КонецЕсли;
				
			КонецЦикла;
		Иначе
			Моксель = ЗаполнитьМоксельПакета(МассивРезультатов, СпособВыгрузки, КоличествоСтрок, АктуальныеРезультаты);
		КонецЕсли;
	Иначе
		Моксель = ЗаполнитьМоксель(МассивРезультатов[0], СпособВыгрузки, КоличествоСтрок);
	КонецЕсли;
	
	Возврат Моксель;
	
КонецФункции

Функция СформироватьЗаголовокЗапроса(НомерЗапроса, КолвоЗаписей=0)
	
	ЗаголовокЗапроса = мМакет.ПолучитьОбласть("ЗаголовокЗапроса");
	
	Если НомерЗапроса<>0 тогда
		ЗаголовокЗапроса.Параметры.НомерЗапроса = НомерЗапроса;
	КонецЕсли;
	
	ЗаголовокЗапроса.Параметры.ДополнительнаяИнформация = ?(КолвоЗаписей=0,"","("+КолвоЗаписей+")");
	
	Возврат ЗаголовокЗапроса;
	
КонецФункции

Функция ПолучитьРезультатыВременыхТаблиц(Запрос, КоличествоСтрокВт)
	
	Моксель = Новый ТабличныйДокумент();
	ОбластьИмяТаблицы = мМакет.ПолучитьОбласть("НазваниеВременнойТаблицы");
	ОбластьСообщение = мМакет.ПолучитьОбласть("ОшибкаВыполнения");
	Моксель.Вывести(мМакет.ПолучитьОбласть("ЗаголовокВременныхТаблиц"));
	МассивВременыхТаблиц = НайтиВременныеТаблицы(Запрос.Текст);
	
	Если МассивВременыхТаблиц.Количество() > 0 Тогда
		Для Каждого ИмяТаблицы из МассивВременыхТаблиц Цикл
			
			МоксельДанных = Новый ТабличныйДокумент;
			
			еОшибка = Ложь;
			КолвоЗаписей = 0;
			Запрос.Текст = "ВЫБРАТЬ * ИЗ " + ИмяТаблицы;
			
			Попытка
				Результат = Запрос.Выполнить();
			Исключение
				СтрОшибка = ИнформацияОбОшибке();
				еОшибка = Истина;
			КонецПопытки;
			
		    Если НЕ еОшибка тогда
				МоксельДанных.Вывести(ЗаполнитьМоксель(Результат, 1, КолвоЗаписей));
			КонецЕсли;
			
			ОбластьИмяТаблицы.Параметры.ИмяТаблицы = ИмяТаблицы;
			ОбластьИмяТаблицы.Область(1,1,1,1).ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Строка;
    		ОбластьИмяТаблицы.Область(1,1,1,1).Расшифровка = Новый Структура("Тип, ИмяТаблицы","ПомещениеВВТ", ИмяТаблицы);
			
			ОбластьИмяТаблицы.Параметры.ДополнительнаяИнформация = ?(КолвоЗаписей=0,"","("+КолвоЗаписей+")");
			Моксель.Вывести(ОбластьИмяТаблицы);
			
			Если еОшибка тогда
				ОбластьСообщение.Параметры.ТекстОшибки = СтрОшибка.Описание;
				Моксель.НачатьГруппуСтрок(ИмяТаблицы, Ложь);
				Моксель.Вывести(ОбластьСообщение);
				Моксель.ЗакончитьГруппуСтрок();
				Продолжить;
			КонецЕсли;
			
			Моксель.НачатьГруппуСтрок(ИмяТаблицы, Ложь);
			Моксель.Вывести(МоксельДанных);
			Моксель.ЗакончитьГруппуСтрок();
			
			КоличествоСтрокВт = КоличествоСтрокВт + КолвоЗаписей;
			
			МоксельДанных.Очистить();
			МоксельДанных = Неопределено;
		КонецЦикла;
	Иначе
		ОбластьСообщение.Параметры.ТекстОшибки = нСтр("ru='(нет временных таблиц)'; en='(no temporary tables)'");
		Моксель.Вывести(ОбластьСообщение);
	КонецЕсли;
	
	Возврат Моксель;
	
КонецФункции

Функция ПолучитьМассивСсылок(РезультатЗапроса)
	
	МассивСсылок = Новый Массив;
	
	Если РезультатЗапроса.Пустой() тогда
		Возврат МассивСсылок;
	КонецЕсли;
	
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	Если ТаблицаРезультата.Колонки.Найти("Ссылка") = Неопределено тогда
		Возврат МассивСсылок;
	КонецЕсли;
	
	Возврат ТаблицаРезультата.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция ЗаполнитьМоксельПакета(МассивРезультатов, СпособВыгрузки, КоличествоСтрок, АктуальныеРезультаты)
	
	СловоЗапрос = "Запрос";
	Моксель = Новый ТабличныйДокумент();
	
	ЗапросНаУдаление = мМакет.ПолучитьОбласть("ЗапросНаУдаление");
	
	ВерхняяГраница = МассивРезультатов.Количество() - 1;
	
	Для Индекс = 0 по ВерхняяГраница Цикл
		
		МоксельРезультата = Новый ТабличныйДокумент;
		
		НомерЗапроса = Индекс + 1;
		
		Если мАктуальныеРезультаты тогда                                        
			Если АктуальныеРезультаты.Получить(Индекс)<>Истина тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		
		Результат = МассивРезультатов[Индекс];
		
		КолвоЗаписей = 0;
		
		Если Результат = Неопределено Тогда
			МоксельРезультата.Вывести(ЗапросНаУдаление);
		Иначе

			НоваяОбласть = МоксельРезультата.Вывести(ЗаполнитьМоксель(Результат, СпособВыгрузки, КолвоЗаписей));
			
		КонецЕсли;
		
		КоличествоСтрок = КоличествоСтрок+КолвоЗаписей;
		
		ЗаголовокЗапроса = СформироватьЗаголовокЗапроса(НомерЗапроса, КолвоЗаписей);
		Моксель.Вывести(ЗаголовокЗапроса);
		
		Моксель.НачатьГруппуСтрок(СловоЗапрос + Строка(НомерЗапроса), Ложь);
		Моксель.Вывести(МоксельРезультата);
		Моксель.ЗакончитьГруппуСтрок();		
		
		МоксельРезультата.Очистить();
		МоксельРезультата = Неопределено;
		
	КонецЦикла;
	
	Возврат Моксель;
	
КонецФункции

Функция ЗаполнитьМоксель(Результат, СпособВыгрузки, КоличествоСтрок)
	
	Моксель = Новый ТабличныйДокумент(); 

	Если Результат = Неопределено тогда
		Возврат Моксель;
	КонецЕсли;
	
	МассивДлинСтрок	  = Новый Массив;
	КолонкиРезультата = Результат.Колонки;
	КоличествоКолонок = КолонкиРезультата.Количество();
	Шапка         	  = Новый ТабличныйДокумент();
	Ячейка            = мМакет.ПолучитьОбласть("ЯчейкаРезультата");
	
	Если мВыводитьНомераСтрок тогда
		МассивДлинСтрок.Вставить(0, 3);
		Ячейка.Параметры.Содержание = "№";
		Шапка.Присоединить(Ячейка);
	КонецЕсли;
	
	Для каждого Колонка из КолонкиРезультата Цикл
		Ячейка.Параметры.Содержание = Колонка.Имя;
		Шапка.Присоединить(Ячейка);
		МассивДлинСтрок.Добавить(СтрДлина(Колонка.Имя));
	КонецЦикла;
	
	ОбластьШапки = Шапка.Область(1, 1, 1, КоличествоКолонок+мВыводитьНомераСтрок);
	ОбластьШапки.Шрифт = Новый Шрифт(ОбластьШапки.Шрифт, , , Истина);
	ОбластьШапки.ЦветФона = мЦветШапки;
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	ОбластьШапки.Обвести(Линия, Линия, Линия, Линия);
	
	Если СпособВыгрузки = 1 Тогда // список
		
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.Прямой);		
		РезультатВывода = ВывестиПлоско(Выборка, Ячейка, КоличествоКолонок - 1, МассивДлинСтрок);
		Шапка.Вывести(РезультатВывода.Таблица);
		
		НачалоНовогоФорматаСтрок = Моксель.ВысотаТаблицы + 1;
		Моксель.Вывести(Шапка);
		
		Если мАвтоширинаКолонок тогда
			АвтоШиринаКолонок(Моксель, РезультатВывода.МассивДлинСтрок, НачалоНовогоФорматаСтрок);
		КонецЕсли;
		
		КоличествоСтрок = Выборка.Количество(); 
		
	ИначеЕсли СпособВыгрузки = 2 Тогда // дерево
		
		ВыгрузкаВДерево = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		КоличествоСтрокДерева = 0;
		Таблица = Новый ТабличныйДокумент();
		
		Таблица.НачатьАвтогруппировкуСтрок();
		ВывестиИерархически(ВыгрузкаВДерево.Строки, Ячейка, КоличествоКолонок - 1, Таблица, МассивДлинСтрок, КоличествоСтрокДерева);
		Таблица.ЗакончитьАвтогруппировкуСтрок();
		
		Таблица.Область(, 1+мВыводитьНомераСтрок, ,1+мВыводитьНомераСтрок).АвтоОтступ = 2;
		НачалоНовогоФорматаСтрок = Моксель.ВысотаТаблицы + 1;
		
		Моксель.Вывести(Шапка);
		Моксель.Вывести(Таблица);
		
		Если мАвтоширинаКолонок тогда
			АвтоШиринаКолонок(Моксель, МассивДлинСтрок, НачалоНовогоФорматаСтрок);
		КонецЕсли;
		КоличествоСтрок = КоличествоСтрокДерева;
	КонецЕсли;
	
	Если мСоставРезультатов = 1 тогда
		Моксель.ФиксацияСверху = 1;
	КонецЕсли;
	
	Возврат Моксель;
	
КонецФункции

Процедура ЗаполнитьУровеньПроксиДерева(КоллекцияПриемник, КоллекцияИсточник, ИмеетсяШиринаКолонок)
	
	Для каждого СтрокаИсточник из КоллекцияИсточник Цикл
		
		НоваяСтрока = КоллекцияПриемник.Добавить();
		НоваяСтрока.Запрос         = СтрокаИсточник.Запрос;
		НоваяСтрока.ТекстЗапроса   = СтрокаИсточник.ТекстЗапроса;
		Попытка
			НоваяСтрока.ТекстПараметров   = СтрокаИсточник.ТекстПараметров;
		Исключение
		КонецПопытки; 
		НоваяСтрока.СпособВыгрузки = СтрокаИсточник.СпособВыгрузки;
		НоваяСтрока.ШиринаКолонок  = ?(ИмеетсяШиринаКолонок, СтрокаИсточник.ШиринаКолонок, мШиринаКолонокПоУмолчанию);
		ЗаполнитьПараметры(НоваяСтрока.ПараметрыЗапроса, СтрокаИсточник.ПараметрыЗапроса);
		ЗаполнитьУровеньПроксиДерева(НоваяСтрока.ПолучитьЭлементы(), СтрокаИсточник.Строки, ИмеетсяШиринаКолонок);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметры(ТаблицаПриемник, ТаблицаИсточник)
	Для каждого СтрокаИсточник из ТаблицаИсточник Цикл
		НоваяСтрока = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник);
		НоваяСтрока.ЭтоСписок = ТипЗнч(СтрокаИсточник.ЗначениеПараметра) = Тип("СписокЗначений");
	КонецЦикла;
КонецПроцедуры

Функция ВывестиПлоско(Выборка, Ячейка, ГраничныйИндекс, МассивДлинСтрок)
	
	Результат = Новый Структура;
	
	Смещение = ?(мВыводитьНомераСтрок,1,0);
	НС = 0;
	
	Таблица = Новый ТабличныйДокумент();
	Пока Выборка.Следующий() Цикл
		Запись = Новый ТабличныйДокумент();
		
		Если мВыводитьНомераСтрок тогда
			НС = НС+1;
			ФорматироватьЯчейку(Ячейка, НС);
			Запись.Присоединить(Ячейка);
		КонецЕсли;
	
		Для Индекс = 0 по ГраничныйИндекс Цикл
			ФорматироватьЯчейку(Ячейка, Выборка[Индекс]);
			Запись.Присоединить(Ячейка);
			
			//+автоширина
			ДлинаТекста = СтрДлина(Ячейка.Параметры.Содержание);
			Если МассивДлинСтрок[Индекс+Смещение] < ДлинаТекста тогда
				МассивДлинСтрок[Индекс+Смещение] = ДлинаТекста; 
			КонецЕсли;
			//-автоширина
			
		КонецЦикла;
		Таблица.Вывести(Запись);
	КонецЦикла;
	
	Если мВыводитьНомераСтрок тогда
		МассивДлинСтрок[0] = Макс(3, СтрДлина(НС));
	КонецЕсли;
	
	Результат.Вставить("Таблица", Таблица);
	Результат.Вставить("МассивДлинСтрок", МассивДлинСтрок);
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьДеревоЗначенийИзПрокси(ДеревоЗапросов)
	ДеревоИзПрокси    = Новый ДеревоЗначений();
	ОписаниеТипСтрока = Новый ОписаниеТипов("Строка");
	ОписаниеТипЧисло  = Новый ОписаниеТипов("Число");
	ДеревоИзПрокси.Колонки.Добавить("Запрос", ОписаниеТипСтрока);
	ДеревоИзПрокси.Колонки.Добавить("ТекстЗапроса", ОписаниеТипСтрока);
	ДеревоИзПрокси.Колонки.Добавить("ТекстПараметров", ОписаниеТипСтрока);
	ДеревоИзПрокси.Колонки.Добавить("ПараметрыЗапроса", Новый ОписаниеТипов("ТаблицаЗначений"));
	ДеревоИзПрокси.Колонки.Добавить("СпособВыгрузки", ОписаниеТипЧисло);
	ДеревоИзПрокси.Колонки.Добавить("ШиринаКолонок", ОписаниеТипЧисло);
	ЗаполнитьУровеньДереваЗначений(ДеревоИзПрокси.Строки, ДеревоЗапросов.ПолучитьЭлементы());
	Возврат ДеревоИзПрокси;
КонецФункции

Процедура ЗаполнитьУровеньДереваЗначений(КоллекцияПриемник, КоллекцияИсточник)
	
	Для каждого СтрокаИсточник из КоллекцияИсточник Цикл
		НоваяСтрока = КоллекцияПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник, ,"ПараметрыЗапроса");
		ТаблицаПараметров = НоваяСтрока.ПараметрыЗапроса;
		ТаблицаПараметров.Колонки.Добавить("ИмяПараметра", Новый ОписаниеТипов("Строка"));
		ТаблицаПараметров.Колонки.Добавить("ЗначениеПараметра");
		ТаблицаПараметров.Колонки.Добавить("ЭтоВыражение", Новый ОписаниеТипов("Булево"));
		ТаблицаПараметров.Колонки.Добавить("ЭтоСписок", Новый ОписаниеТипов("Булево")); //АРД
		
		ЗаполнитьПараметры(ТаблицаПараметров, СтрокаИсточник.ПараметрыЗапроса);
		ЗаполнитьУровеньДереваЗначений(НоваяСтрока.Строки, СтрокаИсточник.ПолучитьЭлементы());
	КонецЦикла;
	
КонецПроцедуры

Функция ВывестиИерархически(ТекущийУровеньДерева, Ячейка, ГраничныйИндекс, Таблица, МассивДлинСтрок=Неопределено, НомерСтроки)
	
	Смещение = ?(мВыводитьНомераСтрок,1,0); 

	Для каждого ТекущаяСтрока из ТекущийУровеньДерева Цикл
		
		Запись = Новый ТабличныйДокумент();
		
		Если мВыводитьНомераСтрок тогда
			НомерСтроки = НомерСтроки+1;
			ФорматироватьЯчейку(Ячейка, НомерСтроки);
			Запись.Присоединить(Ячейка);
		КонецЕсли;
		
		Для Индекс = 0 по ГраничныйИндекс Цикл
			
			ФорматироватьЯчейку(Ячейка, ТекущаяСтрока[Индекс]);
			Запись.Присоединить(Ячейка);
			
			//+автоширина
			ДлинаТекста = СтрДлина(Ячейка.Параметры.Содержание);
			Если МассивДлинСтрок[Индекс+Смещение] < ДлинаТекста тогда
				МассивДлинСтрок[Индекс+Смещение] = ДлинаТекста; 
			КонецЕсли;
			//-автоширина
			
		КонецЦикла;
		
		Если мВыводитьНомераСтрок тогда
			МассивДлинСтрок[0] = Макс(3, СтрДлина(НомерСтроки));
		КонецЕсли;
		
		Таблица.Вывести(Запись, ТекущаяСтрока.Уровень(), ,Ложь);
		Запись = Неопределено;
		
		ВывестиИерархически(ТекущаяСтрока.Строки, Ячейка, ГраничныйИндекс, Таблица, МассивДлинСтрок, НомерСтроки);
		
	КонецЦикла;
	
КонецФункции

Процедура ФорматироватьЯчейку(Ячейка, Значение)
	
	Область = Ячейка.Область();
	Область.ЦветТекста = мПустойЦвет;
	Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Ячейка;
	
	Если Значение = Null Тогда
		
		Ячейка.Параметры.Содержание      = "NULL";
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста               = мЦветОсобогоЗначения;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
		
	ИначеЕсли Значение = Неопределено Тогда
		
		Ячейка.Параметры.Содержание      = мЗначения.НЕОПРЕДЕЛЕНО;
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста               = мЦветОсобогоЗначения;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
		
	ИначеЕсли ТипЗнч(Значение) = мТипЧисло Тогда 
		
		Ячейка.Параметры.Содержание      = ?(Значение = 0, "0", Значение);
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Право;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
		
	ИначеЕсли ТипЗнч(Значение) = мТипСтрока Тогда
		
		Ячейка.Параметры.Содержание      = Значение;
		Ячейка.Параметры.Расшифровка     = Значение;
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Лево;

	ИначеЕсли ТипЗнч(Значение) = мТипБулево Тогда

		Ячейка.Параметры.Содержание      = ?(Значение, мЗначения.ИСТИНА, мЗначения.ЛОЖЬ);
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста               = мЦветБулево;
		Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
		
	ИначеЕсли ТипЗнч(Значение) = мТипДата Тогда
		
		Если Час(Значение)=0 и Минута(Значение)=0 и Секунда(Значение)=0 тогда
			Ячейка.Параметры.Содержание      = Формат(Значение, "ДФ=dd.MM.yyyy");
		Иначе
			Ячейка.Параметры.Содержание      = Значение;
		КонецЕсли;
		Область.ЦветТекста               = мЦветДата;
		Ячейка.Параметры.Расшифровка     = Значение;		
		Область.ГоризонтальноеПоложение  = ГоризонтальноеПоложение.Право;
		
	ИначеЕсли ТипЗнч(Значение) = мТипРезультатЗапроса Тогда
		
		КолвоСтрок = 0;
		Ячейка.Параметры.Расшифровка    = ЗаполнитьМоксель(Значение, 1, КолвоСтрок);
		Ячейка.Параметры.Содержание     = СтрЗаменить(нСтр("ru='<РЕЗУЛЬТАТ ЗАПРОСА (%1)>'; en='<QUERY RESULT (%1)>'"), "%1", КолвоСтрок);

		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		Область.ЦветТекста              = мЦветОсобогоЗначения;
		
	ИначеЕсли мДляСсылокВыводитьГУИД Тогда
		
		Если мТипВсеСсылки.СодержитТип(ТипЗнч(Значение)) Тогда
			Ячейка.Параметры.Содержание     = Строка(Значение.УникальныйИдентификатор());
			Ячейка.Параметры.Расшифровка    = Значение;
			Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
		Иначе
			Ячейка.Параметры.Содержание     = Строка(Значение);
			Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
		КонецЕсли;
		
	Иначе
		
		Ячейка.Параметры.Содержание     = Строка(Значение);
		Ячейка.Параметры.Расшифровка    = Значение;
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
		
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиВременныеТаблицы(ТекстЗапроса)
	
	МассивВременыхТаблиц = Новый Массив();
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	Для каждого Пакет из СхемаЗапроса.ПакетЗапросов цикл
		Если ТипЗнч(Пакет) = Тип("ЗапросВыбораСхемыЗапроса") И Пакет.ТаблицаДляПомещения <> "" тогда
			МассивВременыхТаблиц.Добавить(Пакет.ТаблицаДляПомещения);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивВременыхТаблиц;
	
	//Старый код, можно будет удалить 
	
	Текст = ВРег(ТекстЗапроса);
	ПОМЕСТИТЬ = "ПОМЕСТИТЬ";
	ДлинаПоместить = СтрДлина(ПОМЕСТИТЬ);
	Искать = Истина;
	Пока Искать Цикл
		ПозицияПоместить = Найти(Текст, ПОМЕСТИТЬ);
		Если ПозицияПоместить > 0 Тогда
			Текст = Сред(Текст, ПозицияПоместить + ДлинаПоместить);
			ДлинаТекста = СтрДлина(Текст);
			Для Позиция = 1 по ДлинаТекста Цикл
				Если НЕ ПустаяСтрока(Сред(Текст, Позиция, 1)) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Текст = Сред(Текст, Позиция);
			ИмяВременнойТаблицы = "";
			ДлинаТекста = СтрДлина(Текст);
			Для Позиция = 1 по ДлинаТекста Цикл
				ОчереднойСимвол = Сред(Текст, Позиция, 1);
				Если ПустаяСтрока(ОчереднойСимвол) Тогда
					Прервать;
				Иначе
					ИмяВременнойТаблицы = ИмяВременнойТаблицы + ОчереднойСимвол;
				КонецЕсли;
			КонецЦикла;
			МассивВременыхТаблиц.Добавить(ТРег(ИмяВременнойТаблицы));
		Иначе
			Искать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивВременыхТаблиц;
	
КонецФункции

Функция АвтоШиринаКолонок(ТабДок, МассивДлинСтрок, НачалоНовогоФорматаСтрок)  
	
	Коэф = 1.3;
	Область = ТабДок.Область(НачалоНовогоФорматаСтрок,,ТабДок.ВысотаТаблицы);
	Область.СоздатьФорматСтрок();
	Для Индекс = 0 по МассивДлинСтрок.Количество()-1 Цикл
		ТабДок.Область(НачалоНовогоФорматаСтрок, Индекс+1).ШиринаКолонки = МассивДлинСтрок[Индекс] * Коэф;
	КонецЦикла;

КонецФункции

Процедура ВыполнитьЗапросВФоне(ПараметрыВызова, АдресХранилища = "") Экспорт
	
	Результат = ВыполнитьЗапрос(ПараметрыВызова);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры


Процедура ПодготовитьСтандартныеЗначения()
	
	мЗначения = Новый Структура;
	мЗначения.Вставить("ИСТИНА",		нСтр("ru='ИСТИНА'; en='TRUE'"));
	мЗначения.Вставить("ЛОЖЬ", 			нСтр("ru='ЛОЖЬ'; en='FALSE'"));
	мЗначения.Вставить("НЕОПРЕДЕЛЕНО", 	нСтр("ru='НЕОПРЕДЕЛЕНО'; en='UNDEFINED'"));
	
КонецПроцедуры

Функция ОбщийМодуль(Имя)
	
	Если МодульСуществует(Имя) тогда
		Модуль = Вычислить(Имя);
	Иначе
		Модуль = Неопределено;
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

Функция МодульСуществует(ИмяМодуля)
	
	Возврат Метаданные.ОбщиеМодули.Найти(ИмяМодуля) <> Неопределено;
	
КонецФункции


Команда_Первая  = "ард_Консоль_запросов";
ВерсияОбработки = "2.2";

// -----------------------------
мПустойЦвет          = Новый Цвет();
мЦветШапки           = WebЦвета.СеребристоСерый; 
мЦветОсобогоЗначения = WebЦвета.ЦианНейтральный;
мЦветБулево			 = WebЦвета.ТемноБордовый;
мЦветДата			 = WebЦвета.ПолночноСиний;
мМакет               = ПолучитьМакет("МакетРезультата");
мТипЧисло            = Тип("Число");
мТипСтрока           = Тип("Строка");
мТипДата             = Тип("Дата");
мТипБулево           = Тип("Булево");
мТипРезультатЗапроса = Тип("РезультатЗапроса");
мТипОписаниеТипов    = Тип("ОписаниеТипов");