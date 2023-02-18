# Исследовательский анализ приложения Procrastinate Pro+

## Описание проекта

Несмотря на огромные вложения в рекламу, последние несколько месяцев компания развлекательного приложения Procrastinate Pro+ терпит убытки. Целью проекта является идентификация причин экономических убытков и определение вариантов для вывода компании в плюс.

## Набор данных

Представлены данные о пользователях, привлечённых с 1 мая по 27 октября 2019 года в виде 3 датасетов:
- лог сервера с данными об их посещениях,
- выгрузка их покупок за этот период,
- рекламные расходы.

## Используемые библиотеки и методы

Проект направлен на закрепление и совершенствование навыков и знаний в части анализа бизнес - показателей. В работе определяются 4 основных шага:
1. Импорт данных и изучение обще информации
    - использование функций и методов `head(), info(), isna(), duplicated()`
2. Предобработка данных для дальнейшей работы
    - использование библиотек `pandas, numpy, datetime`
    - использование функций, циклов, работа с датой и временем
3. Создание функций для расчёта и анализа LTV, ROI, удержания и конверсии
    - использование библиотек `pandas, matplotlib`
    - использование группировки данных, сводных таблиц, объединение таблиц, циклов, срезов, условий, возможностей библиотек
4. Исследовательский анализ данных
    - использование библиотеки `pandas, matplotlib`
    - работа с датой и временем, группировка, сводные таблицы, построение графиков, оценка LTV, CAC, ROI, конверсии и удержания 