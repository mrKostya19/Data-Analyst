{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "c90e75e5",
   "metadata": {},
   "source": [
    "# Исследовательский анализ компании - девелопера\n",
    "\n",
    "## Описание проекта\n",
    "\n",
    "Компания - заказчик приняла решение провести рекламные акции по привлечению клиентов. С этой целью она наняла 8 рекламных кампаний, которые работали 3 дня. Необходимо оценить их эффективность, а также определить наиболее интересные и популярные объекты для клиентов.\n",
    "\n",
    "Результаты исследования будут учтены при дальнейшем планировании рекламных кампаний, а также для формирования базы потенциально приоритетных объектов для клиентов.\n",
    "\n",
    "## Набор данных\n",
    "\n",
    "Датафрейм представлен 2 таблицами с информацией о действиях клиентов:\n",
    "\n",
    "**1. Таблица 1:**\n",
    "- Источник обращения     \n",
    "- Статус обращения      \n",
    "- UTM Campaign - номер рекламной кампании     \n",
    "- Дата создания обращения     \n",
    "- Объект                \n",
    "- Город объекта\n",
    "\n",
    "**2. Таблица 2:**\n",
    "- UTM Campaign - номер рекламной кампании  \n",
    "- Дата работы кампании\n",
    "- Показы - количество показов    \n",
    "- Клики - количество \"нажатий\" клиентов      \n",
    "- Расход, руб. - стоимость рекламной кампании\n",
    "\n",
    "## Используемые библиотеки и методы\n",
    "\n",
    "Самостоятельный проект нацелен на закрепление и совершенствование навыков по предобработке, исследованию и визуализации данных. В работе определяются 3 основных шага:\n",
    "1. Импорт данных и предварительное знакомство\n",
    "    - использование методов `head(), info(), isna()`\n",
    "2. Предобработка данных для дальнейшей работы\n",
    "    - использование библиотеки `pandas`\n",
    "    - удаление столбцов, обработка датафрейма, объединение таблиц, \n",
    "3. Исследование данных\n",
    "    - использование библиотеки `pandas, matplotlib, seaborn`\n",
    "    - добавление и удаление столбцов, объединение таблиц, использование группировки данных, сводных таблиц, возможностей библиотеки\n",
    "    - визуализация с помощью гистограмм, круговых диаграмм\n",
    "    - расчет конверсии и успешности кампаний"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.9.15"
  },
  "toc": {
   "base_numbering": 1,
   "nav_menu": {},
   "number_sections": true,
   "sideBar": true,
   "skip_h1_title": true,
   "title_cell": "Table of Contents",
   "title_sidebar": "Contents",
   "toc_cell": false,
   "toc_position": {
    "height": "calc(100% - 180px)",
    "left": "10px",
    "top": "150px",
    "width": "356px"
   },
   "toc_section_display": true,
   "toc_window_display": false
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}