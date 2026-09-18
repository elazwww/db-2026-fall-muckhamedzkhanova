CREATE TABLE client (
    client_id INT PRIMARY KEY,
    full_name VARCHAR(50)
);

CREATE TABLE coach (
    coach_id INT PRIMARY KEY,
    full_name VARCHAR(50),
    specialization VARCHAR(50),
    age INT CHECK (age >= 18)
);

CREATE TABLE membership (
    membership_id INT PRIMARY KEY,
    price INT CHECK (price > 0 AND  price < 100000),
    start_date INT,
    end_date DATE,
    client_id INT UNIQUE REFERENCES client(client_id)
);

CREATE TABLE room (
    room_id INT PRIMARY KEY,
    room_name VARCHAR(50),
    capacity INT CHECK (capacity > 0)
);

CREATE TABLE training (
    training_id INT PRIMARY KEY,
    training_name VARCHAR(50),
    duration INT CHECK (duration > 0 AND duration < 180),
    datetime TIMESTAMP,
    room_id INT REFERENCES room(room_id),
    coach_id INT REFERENCES coach(coach_id)
);

CREATE TABLE visit (
    visit_id INT PRIMARY KEY,
    attended BOOlEAN,
    client_id INT REFERENCES client(client_id),
    training_id INT REFERENCES training(training_id)
);


ALTER TABLE client ADD COLUMN phone VARCHAR(20);

ALTER TABLE coach DROP COLUMN age;

ALTER TABLE membership DROP COLUMN start_date;

ALTER TABLE membership ADD COLUMN start_date DATE;


INSERT INTO client(client_id, full_name, phone) VALUES
(1, 'Суханова Полина Сергеевна', '+79176565656'),
(2, 'Шафигуллина Лия Эдуардовна', '+79048282822'),
(3, 'Шубин Рим Евгеньевич', '+79875656565'),
(4, 'Терентьев Константин Сергеевич', '+79174477388');

INSERT INTO coach(coach_id, full_name, specialization) VALUES
(1, 'Мухамеджанова Эльза Эдуардовна', 'Бокс'),
(2, 'Иванов Петр Дмитриевич', 'Йога'),
(3, 'Гаврилова Юлия Владимировна', 'Пилатес'),
(4, 'Хакимов Борис Анатольевич', 'Кроссфит');

INSERT INTO membership(membership_id, price, start_date, end_date, client_id) VALUES
(1, 12000, '2026-02-07', '2026-08-08', 2),
(2, 5000, '2026-05-26', '2026-08-26', 4),
(3, 30000, '2025-01-10', '2027-01-11', 1),
(4, 15000, '2026-10-16', '2027-10-17', 3);

INSERT INTO room(room_id, room_name, capacity) VALUES
(1, 'Бассейн', 40),
(2, 'Зал 1', 15),
(3, 'Зал 2', 30),
(4, 'Зал 3', 18);

INSERT INTO training(training_id, training_name, duration, datetime, room_id, coach_id) VALUES
(1, 'Силовая йога', 90, '2026-04-04 10:10', 2, 2),
(2, 'Кроссфит для продвинутых', 120, '2026-04-01 18:00', 3, 4),
(3, 'Бокс для начинающих', 60, '2026-04-01 16:45', 3, 1),
(4, 'Базовый пилатес', 45, '2026-04-06 12:00', 4, 3);

INSERT INTO visit(visit_id, attended, client_id, training_id) VALUES
(1, TRUE, 1, 1),
(2, TRUE, 1, 4),
(3, FALSE, 2, 1),
(4, TRUE, 4, 2),
(5, FALSE, 3, 3),
(6, TRUE, 3, 4);

UPDATE membership
SET price = price * 0.2
WHERE client_id = 1;

UPDATE coach
SET specialization = 'Пилатес и растяжка'
WHERE coach_id = 3;

UPDATE room
SET capacity = capacity + 10
WHERE room_name = 'Бассейн';