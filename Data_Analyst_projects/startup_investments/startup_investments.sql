-- Сколько компаний закрылось?
SELECT COUNT(id)
FROM company
WHERE status = 'closed';

-- Сколько привлечено средств для новостных компаний США?
SELECT SUM(funding_total)
FROM company
WHERE country_code = 'USA'
  AND category_code = 'news'
GROUP BY name
ORDER BY SUM(funding_total) DESC;

-- Какая общая сумма сделок по покупке одних компаний другими? 
-- Учесть только сделки за наличные с 2011 по 2013 год включительно
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash'
  AND EXTRACT (YEAR FROM CAST(acquired_at AS timestamp)) BETWEEN 2011 AND 2013;
  
 -- Отобразить данные аккаунтов людей в твиттере, у которых названия начинаются на 'Silver'
 SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%';

-- Вывести на экран всю информацию о людях, у которых названия аккаунтов в твиттере 
-- содержат подстроку 'money', а фамилия начинается на 'K'
SELECT *
FROM people
WHERE twitter_username LIKE '%money%'
  AND last_name LIKE 'K%';
  
-- Какую общую сумму привлечённых инвестиций для каждой страны, 
-- получили компании, зарегистрированные в этой стране?
SELECT country_code,
       SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC;

-- Составить таблицу, в которую войдёт дата проведения раунда, а также минимальное 
-- и максимальное значения суммы инвестиций, привлечённых в эту дату
SELECT funded_at,
       MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0
   AND MIN(raised_amount) != MAX(raised_amount);
   
-- Создать поля с категориями для фондов
SELECT *,
      CASE
          WHEN invested_companies > 100 THEN 'high_activity'
          WHEN invested_companies >= 20 AND 
          invested_companies < 100 THEN 'middle_activity'
          WHEN invested_companies < 20 THEN 'low_activity'
       END
FROM fund;

-- Для каждой из категорий определить среднее количество инвестиционных раундов, 
-- в которых фонд принимал участие
SELECT 
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds))
FROM fund
GROUP BY activity
ORDER BY ROUND(AVG(investment_rounds));

-- В каких странах находятся фонды, которые чаще всего инвестируют в стартапы?
SELECT *
FROM
(SELECT country_code,
       MIN(invested_companies),
       MAX(invested_companies),
       AVG(invested_companies) AS avg
FROM fund
WHERE founded_at BETWEEN '20100101' AND '20121231'
GROUP BY country_code
HAVING MIN(invested_companies) != 0
ORDER BY AVG(invested_companies) DESC
LIMIT 10) AS country
ORDER BY country.avg DESC, country.country_code;

-- Отобразить имя и фамилию всех сотрудников стартапов и добавьте название 
-- учебного заведения, которое окончил сотрудник
SELECT first_name,
       last_name,
       instituition
FROM people
LEFT OUTER JOIN education ON people.id = education.person_id;

-- Какое количество учебных заведений окончили сотрудники каждой компани? 
-- Составить ТОП-5
SELECT company.name,
       c.count
FROM company
RIGHT OUTER JOIN
(SELECT company_id,
       COUNT(DISTINCT instituition)
FROM people
LEFT OUTER JOIN education ON people.id = education.person_id
WHERE company_id IS NOT NULL
GROUP BY company_id
ORDER BY COUNT(DISTINCT instituition) DESC
LIMIT 5) AS c ON company.id = c.company_id;

-- Составьть список с уникальными названиями закрытых компаний, 
-- для которых первый раунд финансирования оказался последним
WITH
comp AS (SELECT id,
                name
         FROM company
         WHERE status = 'closed'),
round AS (SELECT company_id
          FROM funding_round
          WHERE is_first_round = 1
            AND is_last_round = 1)               
SELECT DISTINCT comp.name
FROM comp
INNER JOIN round ON comp.id = round.company_id;

-- Составить список уникальных номеров сотрудников, 
-- которые работают в компаниях, отобранных в предыдущем запросе
WITH
comp AS (SELECT id
         FROM company
         WHERE status = 'closed'),
round AS (SELECT company_id
          FROM funding_round
          WHERE is_first_round = 1
            AND is_last_round = 1)               
SELECT id
FROM people
WHERE company_id IN (SELECT DISTINCT comp.id
                     FROM comp
                     INNER JOIN round ON comp.id = round.company_id);
                     
-- Составить таблицу, куда войдут уникальные пары с номерами сотрудников из предыдущего запроса
-- и учебным заведением, которое окончил сотрудник
WITH
comp AS (SELECT id
         FROM company
         WHERE status = 'closed'),
round AS (SELECT company_id
          FROM funding_round
          WHERE is_first_round = 1
            AND is_last_round = 1)           
SELECT DISTINCT person_id,
       instituition
FROM education
WHERE person_id IN (SELECT id
            FROM people
            WHERE company_id IN (SELECT DISTINCT comp.id
                                 FROM comp
                                 INNER JOIN round ON comp.id = round.company_id));
                              
-- Какое количество учебных заведений закончил каждый сотрудник из предыдущего запроса?
WITH
comp AS (SELECT id
         FROM company
         WHERE status = 'closed'),
round AS (SELECT company_id
          FROM funding_round
          WHERE is_first_round = 1
            AND is_last_round = 1)          
SELECT person_id,
       COUNT(instituition)
FROM education
WHERE person_id IN (SELECT id
                    FROM people
                    WHERE company_id IN (SELECT DISTINCT comp.id
                                         FROM comp
                                         INNER JOIN round ON comp.id = round.company_id))
GROUP BY person_id;

-- Какое среднее число учебных заведений окончили сотрудники разных компаний?
WITH
comp AS (SELECT id
         FROM company
         WHERE status = 'closed'),
round AS (SELECT company_id
          FROM funding_round
          WHERE is_first_round = 1
            AND is_last_round = 1)            
SELECT AVG(p.inst)
FROM
(SELECT person_id,
       COUNT(instituition) AS inst
FROM education
WHERE person_id IN (SELECT id
                    FROM people
                    WHERE company_id IN (SELECT DISTINCT comp.id
                                         FROM comp
                                         INNER JOIN round ON comp.id = round.company_id))
GROUP BY person_id) AS p;

-- Какое среднее число учебных заведений окончили сотрудники Facebook?
SELECT AVG(p.inst)
FROM (SELECT pers.id,
      COUNT(instituition) AS inst
      FROM (SELECT id            
            FROM PEOPLE
            WHERE company_id = (SELECT id
                                FROM company
                                WHERE name = 'Facebook')) AS pers
LEFT OUTER JOIN education ON pers.id = education.person_id
GROUP BY pers.id) AS p
WHERE inst != 0;

-- Составить таблицу из полей: название фонда, название компании, сумма инвестиций, которую привлекла компания в раунде.
-- Учесть компании, у которых было больше шести важных этапов, а раунды проходили с 2012 по 2013 год
WITH
xz AS (SELECT id,
              company_id,
              raised_amount
       FROM funding_round
       WHERE funded_at BETWEEN '20120101' AND '20131231'),
comp AS (SELECT id,
                name
         FROM company
         WHERE milestones > 6),
xz_comp AS (SELECT xz.id,
              company_id,
                    name,
              raised_amount
           FROM comp
           INNER JOIN xz ON comp.id = xz.company_id),
invest AS (SELECT xz_comp.id,
              xz_comp.company_id,
                xz_comp.name AS name_of_company,
              xz_comp.raised_amount AS amount,
              fund.name AS name_of_fund,
              fund_id
           FROM xz_comp
           INNER JOIN investment ON xz_comp.id = investment.funding_round_id
           INNER JOIN fund ON investment.fund_id = fund.id)
SELECT name_of_fund,
       name_of_company,
       amount
FROM invest;

/* Выгрузить таблицу, в которой будут такие поля:
- название компании-покупателя;
- сумма сделки;
- название компании, которую купили;
- сумма инвестиций, вложенных в купленную компанию;
- доля, которая отображает, во сколько раз сумма покупки превысила сумму вложенных в компанию инвестиций */
WITH
name_bayers AS (SELECT acquisition.id,
                       acquiring_company_id,
                       company.name AS bayers
               FROM acquisition
               LEFT OUTER JOIN company ON acquiring_company_id = company.id),
name_buy AS (SELECT acquisition.id,
                    acquired_company_id,
                    company.name AS buy_name,
                    funding_total
               FROM acquisition
               LEFT OUTER JOIN company ON acquired_company_id = company.id
               WHERE funding_total != 0),
cost AS (SELECT acquisition.id,
                price_amount
         FROM acquisition
         WHERE price_amount != 0)              
SELECT name_bayers.bayers,
       cost.price_amount,
       name_buy.buy_name,
       name_buy.funding_total,
       ROUND(cost.price_amount / name_buy.funding_total)
FROM name_bayers
INNER JOIN name_buy ON name_bayers.id = name_buy.id
INNER JOIN cost ON name_buy.id = cost.id
ORDER BY cost.price_amount DESC, name_buy.buy_name
LIMIT 10;

-- Выгрузить таблицу, в которую войдут названия компаний из категории social, 
-- получившие финансирование с 2010 по 2013 год включительно
WITH
name_company AS (SELECT id,
                        name
                 FROM company
                 WHERE category_code = 'social'),
finance AS (SELECT company_id,
                   EXTRACT (MONTH FROM funded_at) AS month
            FROM funding_round
            WHERE funded_at BETWEEN '20100101' AND '20131231'
              AND raised_amount != 0)
SELECT name,
       month
FROM name_company
INNER JOIN finance ON name_company.id = finance.company_id;

/* По месяцам с 2010 по 2013 год получить таблицу с полями:
- номер месяца, в котором проходили раунды;
- количество уникальных названий фондов из США, которые инвестировали в этом месяце;
- количество компаний, купленных за этот месяц;
- общая сумма сделок по покупкам в этом месяце. */
WITH
rounds AS (SELECT id,  -- Отбираем данные раундов за нужный период
                  EXTRACT(MONTH FROM funded_at) AS month
           FROM funding_round
           WHERE funded_at BETWEEN '20100101' AND '20131231'),
funds AS (SELECT id, -- Фонды США
                 name
          FROM fund
          WHERE country_code = 'USA'),
USA_in_month AS (SELECT rounds.month,  -- Фонды США инвестирующие в конкретном месяце
                        COUNT(DISTINCT funds.name) AS funds
                 FROM rounds
                 INNER JOIN investment ON rounds.id = investment.funding_round_id
                 INNER JOIN funds ON investment.fund_id = funds.id
                 GROUP BY month),                                        
companes AS (SELECT COUNT(id) AS compain,-- Количество купленных компаний и сумма сделок за месяц
             SUM(price_amount) AS total,
             EXTRACT(MONTH FROM acquired_at) AS month
             FROM acquisition
             WHERE acquired_at BETWEEN '20100101' AND '20131231'
             GROUP BY month)           
SELECT USA_in_month.month,
       USA_in_month.funds,
       companes.compain,
       total
FROM USA_in_month
INNER JOIN companes ON USA_in_month.month = companes.month;

-- Определить среднюю сумму инвестиций для стран, в которых есть стартапы, 
-- зарегистрированные в 2011, 2012 и 2013 годах
WITH
country_2011 AS (SELECT country_code,
                   AVG(funding_total) AS y_2011
            FROM company
            WHERE EXTRACT(YEAR FROM founded_at) = 2011
            GROUP BY country_code),
country_2012 AS (SELECT country_code,
                   AVG(funding_total) AS y_2012
            FROM company
            WHERE EXTRACT(YEAR FROM founded_at) = 2012
            GROUP BY country_code),
country_2013 AS (SELECT country_code,
                   AVG(funding_total) AS y_2013
            FROM company
            WHERE EXTRACT(YEAR FROM founded_at) = 2013
            GROUP BY country_code)
SELECT country_2011.country_code,
       country_2011.y_2011,
       country_2012.y_2012,
       country_2013.y_2013
FROM country_2011
INNER JOIN country_2012 ON country_2011.country_code = country_2012.country_code
INNER JOIN country_2013 ON country_2012.country_code = country_2013.country_code
ORDER BY country_2011.y_2011 DESC;