CREATE TABLE Todo(
    ID_Todo INTEGER PRIMARY KEY, 
    TodoName TEXT NULL,
    TodoDescription TEXT NULL,
    TodoDate DATETIME NULL
);

CREATE TABLE Tasks(
    ID_Task INTEGER PRIMARY KEY,
    TaskName TEXT NULL,
    TaskDone INTEGER DEFAULT 0,
    ID_Todo INTEGER
);


CREATE TABLE Types(
    ID_Type INTEGER PRIMARY KEY,
    TypeName TEXT NULL,
    TypeColor TEXT NULL,

);

CREATE TABLE TypesTodo(
    ID_TypesTodo INTEGER PRIMARY KEY,
    ID_Type INTEGER,
    ID_Todo INTEGER
);