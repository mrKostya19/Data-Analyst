-- Какое количество вопросов набрали больше 300 очков или как минимум 100 раз были добавлены в «Закладки»?
SELECT COUNT(*)
FROM stackoverflow.posts
LEFT JOIN stackoverflow.post_types ON posts.post_type_id = post_types.id
WHERE (favorites_count >= 100
   OR score > 300)
  AND type = 'Question';
  
-- Сколько пользователей получили значки сразу в день регистрации?
SELECT COUNT(DISTINCT u.id)
FROM stackoverflow.users AS u
JOIN stackoverflow.badges AS b ON u.id = b.user_id
WHERE u.creation_date::date = b.creation_date::date;

-- Сколько уникальных постов пользователя с именем Joel Coehoorn получили хотя бы один голос?
SELECT COUNT(DISTINCT post_id)
FROM stackoverflow.votes
WHERE post_id IN (SELECT p.id
                  FROM stackoverflow.posts As p
                  JOIN stackoverflow.users AS u ON p.user_id = u.id
                  WHERE u.display_name LIKE '%Joel Coehoorn%');
               
-- Выгрузить все поля таблицы vote_types. Добавить к таблице поле rank, 
-- в которое войдут номера записей в обратном порядке
SELECT *,
       ROW_NUMBER() OVER(ORDER BY id DESC) AS rank
FROM stackoverflow.vote_types
ORDER BY id;

-- Определить 10 пользователей, которые поставили больше всего голосов типа Close
SELECT DISTINCT user_id,
       COUNT(*) OVER(PARTITION BY user_id) AS cnt
FROM stackoverflow.votes AS v
JOIN stackoverflow.vote_types AS vt ON v.vote_type_id = vt.id
WHERE name = 'Close'
ORDER BY 2 DESC, 1 DESC
LIMIT 10;

-- Отобрать 10 пользователей по количеству значков, полученных в период с 15 ноября по 15 декабря 2008 года
SELECT user_id,
       COUNT(*),
       DENSE_RANK() OVER(ORDER BY COUNT(*) DESC)
FROM stackoverflow.badges
WHERE creation_date::date BETWEEN '20081115' AND '20081215'
GROUP BY user_id
ORDER BY 2 DESC,
         user_id
LIMIT 10;

-- Сколько в среднем очков получает пост каждого пользователя?
SELECT title,
       user_id,
       score,
       ROUND(AVG(score) OVER(PARTITION BY user_id))
FROM stackoverflow.posts
WHERE score != 0
  AND title is not null;
 
-- Отобразить заголовки постов, которые были написаны пользователями, получившими более 1000 значков
WITH
users AS (SELECT user_id,
                 COUNT(*)
          FROM stackoverflow.badges
          GROUP BY user_id
          HAVING COUNT(*) > 1000)

SELECT title
FROM stackoverflow.posts
WHERE title IS NOT NULL
  AND user_id IN (SELECT user_id
                  FROM users);
                 
--  Выгрузить данные о пользователях из США. Разделить пользователей на три группы 
-- в зависимости от количества просмотров их профилей
SELECT id,
       views,
       CASE
          WHEN views >= 350 THEN 1
          WHEN 100 <= views AND views < 350 THEN 2
          WHEN views < 100 THEN 3
        END
FROM stackoverflow.users
WHERE location LIKE '%United States%'
  AND views != 0;
 
-- Дополнить предыдущий запрос. Отобразить лидеров каждой группы — пользователей, 
-- которые набрали максимальное число просмотров в своей группе
WITH
tt AS (
SELECT id,
       views,
       CASE
          WHEN views >= 350 THEN 1
          WHEN 100 <= views AND views < 350 THEN 2
          WHEN views < 100 THEN 3
        END AS groupe
FROM stackoverflow.users
WHERE location LIKE '%United States%'
  AND views != 0),
ttt AS (  
SELECT groupe,
       MAX(views) AS mm
FROM tt
GROUP BY 1)
SELECT id,
       ttt.groupe,
       mm
FROM ttt
JOIN tt ON ttt.mm = tt.views AND ttt.groupe = tt.groupe
ORDER BY 3 DESC,
         1;

-- Посчитать ежедневный прирост новых пользователей в ноябре 2008 года
WITH 
tt AS (
SELECT EXTRACT (DAY FROM creation_date) AS dt,
       COUNT(*) AS cnt
FROM stackoverflow.users
WHERE DATE_TRUNC('month', creation_date)::date = '20081101'
GROUP BY EXTRACT (DAY FROM creation_date))

SELECT *,
       SUM(cnt) OVER(ORDER BY dt)
FROM tt;

-- Для каждого пользователя, который написал хотя бы один пост, найи интервал 
-- между регистрацией и временем создания первого поста
SELECT user_id,
       MIN(p.creation_date - u.creation_date)
FROM stackoverflow.users AS u
JOIN stackoverflow.posts AS p ON u.id = p.user_id
GROUP BY user_id;

-- Определить общую сумму просмотров постов за каждый месяц 2008 года
SELECT DISTINCT DATE_TRUNC('month', creation_date)::date,
       SUM(views_count) OVER(PARTITION BY DATE_TRUNC('month', creation_date))
FROM stackoverflow.posts
ORDER BY 2 DESC;

-- Вывести имена самых активных пользователей, которые в первый месяц после регистрации 
-- дали больше 100 ответов
SELECT display_name,
       COUNT(DISTINCT user_id) AS cnt
FROM stackoverflow.users AS u
JOIN stackoverflow.posts AS p ON u.id = p.user_id
LEFT JOIN stackoverflow.post_types AS pt ON p.post_type_id = pt.id
WHERE type = 'Answer'
  AND p.creation_date::date BETWEEN u.creation_date::date AND (u.creation_date::date + INTERVAL '1 month')
GROUP BY display_name
HAVING COUNT(user_id) > 100
ORDER BY display_name;

-- Вывести количество постов за 2008 год по месяцам. Учесть посты от пользователей, которые 
-- зарегистрировались в сентябре 2008 года и сделали хотя бы один пост в декабре того же года
SELECT DISTINCT DATE_TRUNC('month', p.creation_date)::date,
                COUNT(*) OVER (PARTITION BY DATE_TRUNC('month', p.creation_date))
FROM stackoverflow.posts AS p
WHERE user_id IN (SELECT DISTINCT u.id
                  FROM stackoverflow.users AS u
                  JOIN stackoverflow.posts AS p ON u.id = p.user_id
                  WHERE DATE_TRUNC('month', u.creation_date)::date = '20080901'
                    AND DATE_TRUNC('month', p.creation_date)::date = '20081201')
ORDER BY DATE_TRUNC('month', p.creation_date)::date DESC;

/* Используя данные о постах, выведите несколько полей:
- идентификатор пользователя, который написал пост;
- дата создания поста;
- количество просмотров у текущего поста;
- сумму просмотров постов автора с накоплением */
SELECT user_id,
       creation_date,
       views_count,
       SUM(views_count) OVER(PARTITION BY user_id ORDER BY creation_date)
FROM stackoverflow.posts
ORDER BY 1;

-- Сколько в среднем дней в период с 1 по 7 декабря 2008 года пользователи взаимодействовали с платформой?
WITH
tt AS (
SELECT user_id,
       COUNT(DISTINCT creation_date::date) AS cnt
FROM stackoverflow.posts
WHERE creation_date::date BETWEEN '20081201' AND '20081207'
GROUP BY user_id
ORDER BY user_id)
SELECT ROUND(AVG(cnt))
FROM tt;

-- На сколько процентов менялось количество постов ежемесячно с 1 сентября по 31 декабря 2008 года?
WITH
tt AS (
SELECT EXTRACT (MONTH FROM creation_date) AS dt,
       COUNT(DISTINCT id) AS cnt
FROM stackoverflow.posts
WHERE DATE_TRUNC('month', creation_date)::date BETWEEN '20080901' AND '20081231'
GROUP BY EXTRACT (MONTH FROM creation_date))
SELECT *,
       ROUND((cnt - LAG(cnt) OVER(ORDER BY dt)) * 100.0 / LAG(cnt) OVER(ORDER BY dt), 2)
FROM tt;

/* Выгрузить данные активности пользователя, который опубликовал больше всего постов за всё время. 
Вывести данные за октябрь 2008 года в таком виде:
- номер недели;
- дата и время последнего поста, опубликованного на этой неделе */
WITH 
tt AS (
SELECT user_id,
       COUNT(DISTINCT id) AS cnt
FROM stackoverflow.posts
GROUP BY user_id
ORDER BY 2 DESC
LIMIT 1)
SELECT EXTRACT(week FROM creation_date),
       MAX(creation_date)
FROM stackoverflow.posts
WHERE DATE_TRUNC('month', creation_date)::date = '20081001'
  AND user_id IN (SELECT user_id
                  FROM tt)
GROUP BY EXTRACT(week FROM creation_date)