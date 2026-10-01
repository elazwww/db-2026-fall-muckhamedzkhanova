Изменяем таблицы, чтобы они стали с нарушением НФ.

1) НФ1 - не все данные атомарны ( добавлю список номеров телефонов у клиента).


ALTER TABLE client ADD COLUMN phone_list VARCHAR(150);

UPDATE client SET phone_list = '+78005553535, +7917111111' WHERE client_id = 1;
UPDATE client SET phone_list = '+78005555555, +79171212121' WHERE client_id = 2;
UPDATE client SET phone_list = '+79047657657, +79171717171' WHERE client_id = 3;
UPDATE client SET phone_list = '+79876666666' WHERE client_id = 4;


Для исправления аномалии можно вынести phone_id, phone, client_id в отдельную таблицу. Так мы сможем обеспечить нф1, нф2, нф3 и нфбк.

ALTER TABLE client DROP COLUMN phone_list;

CREATE TABLE client_phone (
    phone_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES client(client_id),
    phone VARCHAR(20) NOT NULL UNIQUE
);



2) НФ2 - значение зависит только от части составного ключа.

CREATE TABLE visit (
    client_id INT REFERENCES client(client_id),
    training_id INT REFERENCES training(training_id),
    attended BOOLEAN,
    training_name VARCHAR(100),
    PRIMARY KEY (client_id, training_id)
);

Здесь training_name -> training_id, а  PRIMARY KEY (client_id, training_id). Значение зависит только от части составного ключа.
Чтобы привести таблицу в нф можно убрать данную колонку или можно сделать декомпозицию на два отношения.


DROP TABLE visit;

CREATE TABLE visit (
    client_id INT REFERENCES client(client_id),
    training_id INT REFERENCES training(training_id),
    attended BOOLEAN,
    PRIMARY KEY (client_id, training_id)
);

А в таблицу тренировок добавим колонку training_name;

ALTER TABLE training ADD COLUMN training_name VARCHAR(100);

Теперь у нас нет частичной зависимости.


3) НФ3 - транзитивная зависимость.

Предположим, в таблице training была колонка room_name: 

CREATE TABLE training (
    training_id SERIAL PRIMARY KEY,
    training_name VARCHAR(100),
    duration INT CHECK (duration > 0 AND duration < 180),
    datetime TIMESTAMP,
    room_name VARCHAR(100),
    room_id INT REFERENCES room(room_id),
    coach_id INT REFERENCES coach(coach_id)
);

В данной таблице training_id -> room_id -> room_name, что является транзитивной зависимостью. 
Аномалия обновления -  если один зал переименовали, то во всех тренировках нужно будет менять название зала.
Аномалия вставки - создать зал без тренировок будет нельзя.
Аномалия удаления - если удалить последнюю тренировку в каком-то зале, то информация о зале потеряется.

Для решения данной проблемы можно удалить колонку room_name или вынести в отдельную таблицу (room_id, room_name).

ALTER TABLE training DROP COLUMN room_name;