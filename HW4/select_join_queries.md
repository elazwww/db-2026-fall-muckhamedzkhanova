-- SELECT запросы

1) Выборка всех данных из таблицы

-- Найти все данные о клиентах.
SELECT * FROM client;

-- Найти все данные о тренерах.
SELECT * FROM coach;


2) Выборка отдельных столбцов

-- Найти идентификаторы клиентов и стоимость их абонементов.
SELECT client_id, price FROM membership;

-- Найти названия тренировок и их длительность.
SELECT training_name, duration FROM training;


3) Присвоение новых имен столбцам при формировании выборки

-- Найти названия залов и их вместимость, переименовав столбец room_name в special_sign.
SELECT room_name AS special_sign, capacity FROM room;

-- Найти специализации тренеров и их ФИО, переименовав столбец specialization в coach_specialization.
SELECT specialization AS coach_specialization, full_name FROM coach;


4) Выборка данных с созданием вычисляемого столбца

-- Найти клиентов и стоимость их абонементов со скидкой 30%.
SELECT client_id, price, price * 0.7 AS price_with_sale FROM membership;

-- Найти абонементы и их стоимость без налога (82% от исходной цены).
SELECT membership_id, start_date, end_date, price * 0.82 AS price_without_tax FROM membership;


5) Выборка данных, вычисляемые столбцы, математические функции

insurance - страховка

-- Найти клиентов, стоимость их абонементов, размер страховки (22% от цены, поделённые на 5) и налог (13% от цены).
SELECT client_id, price, (price*22/100)/5 AS insurance_price, price * 0.13 AS tax_price FROM membership;

-- Найти абонементы, дату начала и остаток от деления цены на 56.
SELECT membership_id, start_date, (price % 56) AS cost FROM membership;


6) Выборка данных, вычисляемые столбцы, логические функции

-- Найти тренировки, их длительность и coach_id. Если тренер с id = 3 — добавить 10 минут к длительности, иначе вычесть 10 минут.
SELECT training_name, 
       duration,
       coach_id,
       CASE 
           WHEN coach_id = 3 THEN duration + 10
           ELSE duration - 10
       END AS duration_with_gift_minutes
FROM training;

-- Найти клиентов и их абонементы. Если дата начала = '2026-05-26' — цена со скидкой 40%, иначе цена минус 1000.
SELECT client_id,
       start_date,
       price,
       CASE
           WHEN start_date = '2026-05-26' THEN price * 0.6
           ELSE price - 100*10
       END AS sale_price
FROM membership;


7) Выборка данных по условию

-- Найти абонементы, у которых цена со скидкой 20% превышает 20000.
SELECT membership_id, start_date, price * 0.8 AS gift_price
FROM membership
WHERE price * 0.8 > 20000;

-- Найти тренировки, у которых длительность, увеличенная на 30 минут, превышает 170 минут.
SELECT training_name, datetime, duration + 30 AS pro_training
FROM training
WHERE duration + 30 > 170;


8) Выборка данных, логические операции

-- Найти абонементы дороже 20000, оформленные 2025-01-10.
SELECT membership_id, start_date, price
FROM membership
WHERE price > 20000 AND start_date = '2025-01-10';

-- Найти тренировки «Бокс для начинающих» или «Кроссфит для продвинутых» длительностью больше 55 минут.
SELECT training_name, datetime, duration
FROM training
WHERE (training_name = 'Бокс для начинающих' OR training_name = 'Кроссфит для продвинутых') AND duration > 55;


9) Выборка данных, операторы BETWEEN, IN

-- Найти абонементы со стоимостью в диапазоне от 10000 до 25000 включительно.
SELECT membership_id, price
FROM membership
WHERE price BETWEEN 10000 AND 25000;

-- Найти тренеров со специализацией «Бокс» или «Йога».
SELECT full_name, specialization
FROM coach
WHERE specialization IN ('Бокс', 'Йога');


10) Выборка данных с сортировкой

-- Найти тренеров в возрасте от 20 до 30 лет, отсортировав по возрасту и ФИО по убыванию.
SELECT full_name, specialization, age
FROM coach
WHERE age BETWEEN 20 AND 30
ORDER BY age, full_name DESC;

-- Найти посещения, которые состоялись, отсортировав по client_id.
SELECT visit_id, client_id, attended
FROM visit
WHERE attended = TRUE
ORDER BY client_id;


11) Выборка данных, оператор LIKE

-- Найти тренеров, чьё ФИО состоит из трёх слов, где первое начинается на «М», второе и третье — на «Э».
SELECT full_name
FROM coach
WHERE full_name LIKE 'М% Э% Э%';

-- Найти тренеров со специализацией из ровно 4 символов.
SELECT full_name, specialization
FROM coach
WHERE specialization LIKE '____';


12) Выбор уникальных элементов столбца

-- Найти уникальные идентификаторы залов, в которых проходят тренировки.
SELECT DISTINCT room_id
FROM training;

-- Найти уникальные значения вместимости залов.
SELECT DISTINCT capacity
FROM room;


13) Выбор ограниченного количества возвращаемых строк

-- Найти первые 3 состоявшихся посещения, отсортированные по client_id.
SELECT visit_id, client_id, attended
FROM visit
WHERE attended = TRUE
ORDER BY client_id
LIMIT 3;

-- Найти двух клиентов с самыми «большими» ФИО в алфавитном порядке (по убыванию).
SELECT full_name, phone 
FROM client
ORDER BY full_name DESC
LIMIT 2;





-- JOIN запросы


14) Соединение INNER JOIN

-- Найти ФИО тренеров и их специализации для тренировок, которые они проводят.
SELECT full_name, specialization
FROM
    coach INNER JOIN training
    ON coach.coach_id = training.coach_id;

-- Найти ФИО клиентов, у которых есть абонемент.
SELECT full_name
FROM 
    client INNER JOIN membership
    ON client.client_id = membership.client_id;


15) Внешнее соединение LEFT и RIGHT OUTER JOIN

-- Найти ФИО и телефоны клиентов вместе с их абонементами (RIGHT JOIN от membership).
SELECT full_name, phone
FROM 
    client RIGHT JOIN membership
    ON client.client_id = membership.client_id
ORDER BY full_name;

-- Найти названия всех залов вместе с тренировками, которые в них проходят (LEFT JOIN от room).
SELECT room_name
FROM 
    room LEFT JOIN training
    ON room.room_id = training.room_id
ORDER BY room_name DESC;


16) Перекрестное соединение CROSS JOIN

-- Получить все возможные пары «тренер — тренировка».
SELECT full_name, training_name
FROM
    coach, training;

-- Получить все возможные пары «клиент — посещение».
SELECT full_name, visit_id
FROM
    client, visit;


17) Запросы на выборку из нескольких таблиц

-- Найти ФИО и телефоны клиентов, у которых есть и абонемент, и посещения.
SELECT full_name, phone
FROM
    client
    INNER JOIN membership ON client.client_id = membership.client_id
    INNER JOIN visit ON client.client_id = visit.client_id
ORDER BY full_name DESC;