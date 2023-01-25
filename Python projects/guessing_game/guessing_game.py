import random
rnd = random.randint(1, 100)
print('Добро пожаловать в числовую угадайку :)\n\n\
     Компьютер загадает число, а твоя задача отгадать его за меньшее количество попыток!\n')

def tes (n):
  try:
    if 100 <= int(n):
      return True
    else:
      return False
  except:
    return False

while True:
  right = input('Введи целое число больше 100 - определи диапазон для загадывания числа от 1 до \n')

  if tes (right) == False:  # Проверяем число
    print('Следуй правилам - введи целое число больше 100!\n')
    continue
  else:
    num = int(right)
    break

print('Число уже загадно, спорим, что не отгадаешь за 5 попыток?\n')

def is_valid (num):  # Функция валидации
  try:
    if 0 < int(num) <= int(right):
      return True
    else:
      return False
  except:
    return False

count = 0
while True:
  num = input(f'Введи число в диапазоне от 1 до {right}:\n')

  if is_valid (num) == False:  # Проверяем число
    print(f'Следуй правилам - введи целое число от 1 до {right}!\n')
    continue
  else:
    num = int(num)

  if num < rnd:
    print('Твое число меньше загаданного, попробуй еще разок...\n')
    count += 1
    continue
  elif num > rnd:
    print('Твое число больше загаданного, попробуй еще разок...\n')
    count += 1
    continue
  elif num == rnd:
    count += 1
    if count > 5:
      print(f'Попыток больше 5, ты проиграл, но число {num} верное!\n')
    else:
      print(f'Ты угадал с {count} попытки верное число {num}, поздравляю!\n')
    break

print('Спасибо, что играл в числовую угадайку. Еще увидимся...')
