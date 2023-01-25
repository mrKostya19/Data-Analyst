import random as rnd

answers = [
  'Бесспорно', 'Мне кажется - да', 'Пока неясно, попробуй снова',
  'Даже не думай', 'Предрешено', 'Вероятнее всего', 'Спроси позже',
  'Мой ответ - нет', 'Никаких сомнений', 'Хорошие перспективы',
  'Лучше не рассказывать', 'По моим данным - нет', 'Определённо да',
  'Знаки говорят - да', 'Сейчас нельзя предсказать',
  'Перспективы не очень хорошие', 'Можешь быть уверен в этом', 'Да',
  'Сконцентрируйся и спроси опять', 'Весьма сомнительно'
]

print('Привет, я магический шар, и я знаю ответ на любой твой вопрос!\n')

name = input('Назови себя и мы отправимся в мир пророчества:\n')
print(f'Я так и знал, что тебя зовут {name.title()}! Давай приступим!')

while True:
  print('Что ты хочешь узнать?')
  input()
  print(rnd.choice(answers))
  next = input(f'Хочешь ли ты задать еще один вопрос, {name.title()}?')
  if next.lower() in ['yes', 'да', 'конечно', 'д']:
    continue
  else:
    print('Возвращайся если что нибудь придумаешь!')
    break