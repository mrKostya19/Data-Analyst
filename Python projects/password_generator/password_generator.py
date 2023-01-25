import random as rnd

print('Тебя приветствует генератор паролей - давай создадим тебе надежную защиту!\n\n')

digits = '0123456789'
lowercase_letters = 'abcdefghijklmnopqrstuvwxyz'
uppercase_letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
punctuation = '!#$%&*+-=?@^_'

chars = ''

def valid_D (text):  # Функция проверки ответа на целое число больше 0
  answer = input(text)
  while True:
    try:
      if int(answer) > 0:
        return answer
        break
      else:
        answer = input('Ответ должен быть целым числом больше 0:\n')
        continue
    except:
      answer = input('Ответ должен быть целым числом больше 0:\n')
      continue

def valid_YN (text):  # Функция проверки ответа на да или нет
  answer = input(text)
  while answer != 'да' and answer != 'нет':
    answer = input('Я тебя не понял: ответ должен быть "да" или "нет":\n')
  return answer

# Запрос вводных данных у пользователя
count = valid_D('Введи необходимое количество паролей для генерации:\n')
lens = valid_D('Введи требуемую длину одного пароля:\n')
is_digits = valid_YN('В твоем пароле должны быть цифры?\n')
lowletters = valid_YN('В твоем пароле должны быть прописные буквы?\n')
upperletters = valid_YN('В твоем пароле должны быть строчные буквы?\n')
punct = valid_YN('В твоем пароле должны быть знаки пунктуации?\n')
simbol = valid_YN('Исключать ли неоднозначные символы il1Lo0O?\n')

print()

# Генерация возможных символов
if is_digits == 'да':
  chars += digits
if lowletters == 'да':
  chars += lowercase_letters
if upperletters == 'да':
  chars += uppercase_letters
if punct == 'да':
  chars += punctuation
if simbol == 'да':
  new_chars = ''
  for simb in chars:
    if simb not in 'il1Lo0O':
      new_chars += simb
  chars = new_chars

def generate_password(length, chars):  # Функция генерации пароля
  password = ''
  for i in range(length):
    password += rnd.choice(chars)
  return password


for number in range(int(count)):  # Вывод паролей
  print(generate_password(int(lens), chars))
