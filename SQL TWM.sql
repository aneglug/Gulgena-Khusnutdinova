-- Выбор всех пользователей
SELECT * FROM user;

-- Выбор определенных столбцов с фильтрацией по дате рождения
SELECT first_name, last_name, birthday FROM user 
WHERE birthday > '2000-01-01';

-- Пользователи с подпиской PRO из определенного города (Москва)
SELECT u.first_name, u.last_name, c.name FROM user u
JOIN city c ON u.city_id = c.id
WHERE u.is_pro = TRUE AND c.name = 'Москва';

-- Подписки, которые заканчиваются в следующем месяце
SELECT s.id, u.first_name, u.last_name, s.end_date FROM subscription s
JOIN user u ON s.user_id = u.id
WHERE s.end_date BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '1 month');

-- Информация о пользователях с их городом и страной
SELECT 
    u.first_name, 
    u.last_name, 
    c.name as city, 
    co.name as country
FROM user u
JOIN city c ON u.city_id = c.id
JOIN country co ON c.region_id = co.id;

-- Подписки с информацией о тарифе
SELECT 
    u.first_name, 
    u.last_name, 
    t.name as tariff_name, 
    t.price,
    s.start_date,
    s.end_date
FROM subscription s
JOIN user u ON s.user_id = u.id
JOIN tariff t ON s.tariff_id = t.id;

-- Количество пользователей по городам
SELECT 
    c.name as city, 
    COUNT(u.id) as user_count -- подсчет количества пользователей
FROM user u
JOIN city c ON u.city_id = c.id
GROUP BY c.name; -- группировка результатов по названию города

-- Средняя стоимость подписки по статусам
SELECT 
    s.status,
    AVG(t.price) as avg_price -- среднее значение цены тарифа
FROM subscription s
JOIN tariff t ON s.tariff_id = t.id
GROUP BY s.status; -- группировка результатов по статусу подписки

-- Города с более чем 10 пользователями
SELECT 
    c.name as city, 
    COUNT(u.id) as user_count -- подсчет количества пользователей
FROM user u
JOIN city c ON u.city_id = c.id
GROUP BY c.name
HAVING COUNT(u.id) > 10; -- фильтрация групп, оставляя только города с более чем 10 пользователями

-- Тарифы, которые купили более 5 раз
SELECT 
    t.name,
    COUNT(s.id) as subscription_count -- подсчет количества подписок с этим тарифом
FROM tariff t
JOIN subscription s ON t.id = s.tariff_id
GROUP BY t.name -- группировка результатов по названию тарифа
HAVING COUNT(s.id) > 5; -- фильтрация групп, оставляя только те тарифы, у которых количество подписок больше 5

-- Пользователи, отсортированные по фамилии и имени
SELECT first_name, last_name, email FROM user
ORDER BY last_name, first_name;

-- Самые дорогие подписки
SELECT 
    u.first_name, 
    u.last_name, 
    t.name as tariff_name, 
    t.price
FROM subscription s
JOIN user u ON s.user_id = u.id
JOIN tariff t ON s.tariff_id = t.id
ORDER BY t.price DESC;

-- Пользователи из определенных городов
SELECT first_name, last_name FROM user
WHERE city_id IN (
    SELECT id FROM city WHERE name IN ('Москва', 'Санкт-Петербург', 'Новосибирск')
);

-- Подписки с определенными статусами
SELECT s.id, u.first_name, u.last_name, s.status FROM subscription s
JOIN user u ON s.user_id = u.id
WHERE s.status IN ('active', 'pending');

-- Добавление страны
INSERT INTO country (
    id, 
    name, 
    created_at, 
    updated_at
) VALUES (
    'bce3a613-86c9-451e-a7d6-7af5d69e9d00',
    'Россия',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Добавление новой подписки
INSERT INTO subscription (
    id,
    user_id,
    tariff_id,
    start_date,
    end_date,
    status,
    created_at,
    updated_at
) VALUES (
    '36916aee-c2a8-4207-b123-95f0db6d6a37',
    (SELECT id FROM user WHERE email = 'ivanov@example.com' LIMIT 1),
    (SELECT id FROM tariff WHERE name = 'PRO' LIMIT 1),
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 year',
    'active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Обновление статуса подписки
UPDATE subscription
SET 
    status = 'expired',
    updated_at = CURRENT_TIMESTAMP
WHERE end_date < CURRENT_DATE AND status = 'active';

-- Обновление информации о пользователе
UPDATE user
SET 
    first_name = 'Иван',
    last_name = 'Петров',
    updated_at = CURRENT_TIMESTAMP
WHERE email = 'ivanov@example.com';

-- Удаление тестовых пользователей
DELETE FROM user
WHERE email LIKE '%test%' OR phone LIKE '%000000%';

-- Удаление отмененных подписок старше года
DELETE FROM subscription
WHERE status = 'cancelled' 
AND created_at < (CURRENT_DATE - INTERVAL '1 year');
