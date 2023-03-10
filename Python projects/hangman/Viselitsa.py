import random as rnd

print('Привет, давай сыграем в Виселицу?! Я загадаю слово, а ты должен будешь отгадать за 7 попыток - если проиграешь, то человечка повесят(\n')
next = input('Напиши "начинаем", как будешь готов!\n')
while next.lower() != 'начинаем':
    next = input('Я тебя не понял: напиши "начинаем", и я загадаю слово!\n').lower()

word_list = ['Указатель', 'Радуга', 'Мармелад', 'Поиск', 'Прятки', 'Сторож', 'Копейка', 'Леопард', 'Аттракцион', 'Дрессировка', 'Ошейник', 'Карамель', 'Водолаз', 'Защита', 
'Батарея', 'Решётка', 'Квартира', 'Дельфинарий', 'Непогода', 'Вход', 'Полиция', 'Перекрёсток', 'Башня', 'Стрелка', 'Градусник', 'Бутылка', 'Щипцы', 'Наволочка', 'Павлин', 
'Карточка', 'Записка', 'Лестница', 'Переулок', 'Сенокос', 'Рассол', 'Закат', 'Сигнализация', 'Журнал', 'Заставка', 'Тиранозавр', 'Микрофон', 'Прохожий', 'Квитанция', 'Пауза', 
'Новости', 'Скарабей', 'Серебро', 'Творог', 'Осадок', 'Песня', 'Корзина', 'Сдача', 'Овчарка', 'Хлопья', 'Телескоп', 'Микроб', 'Угощение', 'Экскаватор', 'Письмо', 'Пришелец', 
'Айсберг', 'Пластик', 'Доставка', 'Полка', 'Мотор', 'Шарж', 'Кант', 'Хроника', 'Зал', 'Галера', 'Балл', 'Вес', 'Кафель', 'Знак', 'Фильтр', 'Башня', 'Кондитер', 'Омар', 'Чан', 
'Пламя', 'Банк', 'Тетерев', 'Муж', 'Камбала', 'Кино', 'Лаваш', 'Калач', 'Геолог', 'Бальзам', 'Бревно', 'Жердь', 'Борец', 'Самовар', 'Карабин', 'Подлокотник', 'Барак', 'Сустав', 
'Амфитеатр', 'Скворечник', 'Подлодка', 'Затычка', 'Ресница', 'Спичка', 'Кабан', 'Муфта', 'Синоптик', 'Характер', 'Мафиози', 'Фундамент', 'Бумажник', 'Библиофил', 'Дрожжи', 
'Казино', 'Конечность', 'Пробор', 'Дуст', 'Комбинация', 'Мешковина', 'Процессор', 'Крышка', 'Сфинкс', 'Пассатижи', 'Фунт', 'Кружево', 'Агитатор', 'Формуляр', 'Прокол', 'Абзац', 
'Караван', 'Леденец', 'Кашпо', 'Баркас', 'Кардан', 'Вращение', 'Заливное', 'Метрдотель', 'Клавиатура', 'Радиатор', 'Сегмент', 'Обещание', 'Магнитофон', 'Кордебалет', 'Заварушка']

def get_word(word):
    return rnd.choice(word).upper()

# функция получения текущего состояния
def display_hangman(tries):
    stages = [  # финальное состояние: голова, торс, обе руки, обе ноги
                '''
                   --------
                   |      |
                   |      O
                   |     /|\\
                   |      |
                   |     / \\
                   -
                ''',
                # голова, торс, обе руки, одна нога
                '''
                   --------
                   |      |
                   |      O
                   |     /|\\
                   |      |
                   |     / 
                   -
                ''',
                # голова, торс, обе руки
                '''
                   --------
                   |      |
                   |      O
                   |     /|\\
                   |      |
                   |      
                   -
                ''',
                # голова, торс и одна рука
                '''
                   --------
                   |      |
                   |      O
                   |     /|
                   |      |
                   |     
                   -
                ''',
                # голова и торс
                '''
                   --------
                   |      |
                   |      O
                   |      |
                   |      |
                   |     
                   -
                ''',
                # голова
                '''
                   --------
                   |      |
                   |      O
                   |    
                   |      
                   |     
                   -
                ''',
                 # петля
                '''
                   --------
                   |      |
                   |      
                   |    
                   |      
                   |     
                   -
                ''',
                # начальное состояние
                '''
                   --------
                   |      
                   |      
                   |    
                   |      
                   |     
                   -
                '''
    ]
    return stages[tries]

proposed_letters = []   # список уже названных букв
proposed_words = []   # список уже названных слов
guessed_letters = []  # список угаданных букв

def game (word):
    while True:
        answer = input('Твоя буква, или слово целиком:\n')
        while not answer.isalpha():
            answer = input('Следуй правилам, введи одну букву или слово целиком:\n')

        if len(answer) == 1:
            if answer.upper() not in proposed_letters:
                proposed_letters.append(answer.upper())
                if answer.upper() in word:
                    guessed_letters.append(answer.upper())
                break
            else:
                print('Назови другую букву, эту мы уже проверяли - попытка не засчитана!')
                continue

        elif len(answer) > 1:
            if answer.upper() not in proposed_words:
                proposed_words.append(answer.upper())
                break
            else:
                print('Назови другое слово, это мы уже проверяли - попытка не засчитана!')
                continue
    
    count = len(proposed_letters) + len(proposed_words) - len(guessed_letters)
  
    progress = ''       
    for i in range(len(word)):   
        if word[i] in guessed_letters:
            progress += word[i]
        else:
            progress += '_'
  
    for answ in proposed_words:
        if answ == word:
            print(f'Поздравляем, вы угадали слово {word}! Вы победили за {count} попыток!')
            flag = True
            return flag

    if progress == word:
        print(f'Поздравляем, вы угадали слово {word}! Вы победили за {count} попыток!')
        flag = True
        return flag
    if count == 7:
        print(display_hangman(7 - count))
        print(f'Вы исчерпали 7 попыток, загаданное слово {word}')
        flag = True
        return flag
    else:
        print(f'Текущий прогресс: {progress}')
        print(f'У вас осталось {7 - count} попыток!')
        print(display_hangman(7 - count))

def play():
    while True:
        word = get_word(word_list)
        print(f'Итак, поехали! Вот твое слово из {len(word)} букв:')
        print(len(word) * '_')
        print(display_hangman(7))

        flag = False
        while flag != True:
            flag = game(word)

        next = input('Желаешь ли сыграть еще раз?\n').lower()
        while next != 'да' and next != 'нет':
            next = input('Я тебя не понял, введи "да" или "нет":\n').lower()
        if next == 'да':
            global proposed_letters
            proposed_letters = []   # список уже названных букв
            global proposed_words
            proposed_words = []   # список уже названных слов
            global guessed_letters
            guessed_letters = []  # список угаданных букв
            continue
        elif next == 'нет':
            print('Был рад игре, приходи еще! :)')
            break

play()
