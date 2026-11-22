-- ============================================
-- База данных: ReadNow
-- Стек: MS SQL Server + Entity Framework 6
-- ============================================
CREATE DATABASE ReadNow;
GO
USE ReadNow;
GO

-- Справочник ролей
CREATE TABLE Roles (
    RoleId   INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Пользователи
CREATE TABLE Users (
    UserId     INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    FullName   NVARCHAR(300) NOT NULL,
    Login      NVARCHAR(100) NOT NULL UNIQUE,
    Password   NVARCHAR(255) NOT NULL,
    RoleId     INT           NOT NULL,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);
GO

-- Категории товаров
CREATE TABLE Categories (
    CategoryId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- Производители
CREATE TABLE Manufacturers (
    ManufacturerId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ManufacturerName NVARCHAR(200) NOT NULL UNIQUE
);
GO

-- Поставщики
CREATE TABLE Suppliers (
    SupplierId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(200) NOT NULL UNIQUE
);
GO

-- Товары
CREATE TABLE Products (
    ProductId      INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Article        NVARCHAR(50)  NOT NULL UNIQUE,
    ProductName    NVARCHAR(300) NOT NULL,
    CategoryId     INT           NOT NULL,
    Description    NVARCHAR(MAX) NULL,
    ManufacturerId INT           NOT NULL,
    SupplierId     INT           NOT NULL,
    Price          DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Unit           NVARCHAR(50)  NOT NULL,
    StockQuantity  INT           NOT NULL DEFAULT 0 CHECK (StockQuantity >= 0),
    Discount       DECIMAL(5,2)  NOT NULL DEFAULT 0 CHECK (Discount >= 0 AND Discount <= 100),
    ImagePath      NVARCHAR(500) NULL,
    CONSTRAINT FK_Products_Categories    FOREIGN KEY (CategoryId)     REFERENCES Categories(CategoryId),
    CONSTRAINT FK_Products_Manufacturers FOREIGN KEY (ManufacturerId) REFERENCES Manufacturers(ManufacturerId),
    CONSTRAINT FK_Products_Suppliers     FOREIGN KEY (SupplierId)     REFERENCES Suppliers(SupplierId)
);
GO

-- Пункты выдачи
CREATE TABLE PickupPoints (
    PickupPointId INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Address       NVARCHAR(300) NOT NULL
);
GO

-- Статусы заказов
CREATE TABLE OrderStatuses (
    StatusId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- Заказы
CREATE TABLE Orders (
    OrderId       INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Article       NVARCHAR(50)  NOT NULL UNIQUE,
    StatusId      INT           NOT NULL,
    PickupPointId INT           NOT NULL,
    OrderDate     DATE          NOT NULL,
    DeliveryDate  DATE          NULL,
    ClientName    NVARCHAR(300) NULL,
    AccessCode    NVARCHAR(50)  NULL,
    CONSTRAINT FK_Orders_Statuses      FOREIGN KEY (StatusId)      REFERENCES OrderStatuses(StatusId),
    CONSTRAINT FK_Orders_PickupPoints  FOREIGN KEY (PickupPointId) REFERENCES PickupPoints(PickupPointId)
);
GO

-- Состав заказов
CREATE TABLE OrderProducts (
    OrderProductId INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    OrderId        INT           NOT NULL,
    ProductId      INT           NOT NULL,
    Quantity       INT           NOT NULL CHECK (Quantity > 0),
    PriceAtOrder   DECIMAL(10,2) NOT NULL CHECK (PriceAtOrder >= 0),
    CONSTRAINT FK_OrderProducts_Orders   FOREIGN KEY (OrderId)   REFERENCES Orders(OrderId),
    CONSTRAINT FK_OrderProducts_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    CONSTRAINT UQ_OrderProducts          UNIQUE (OrderId, ProductId)
);
GO

-- ДАННЫЕ: Роли
INSERT INTO Roles (RoleName) VALUES (N'Администратор'), (N'Менеджер'), (N'Клиент');
GO

-- ДАННЫЕ: Пользователи
INSERT INTO Users (FullName, Login, Password, RoleId) VALUES
(N'Никифорова Анна Семеновна', N'94d5ous@gmail.com', N'uzWC67', 1),
(N'Стелина Евгения Петровна', N'uth4iz@mail.com', N'2L6KZG', 1),
(N'Михайлюк Анна Вячеславовна', N'5d4zbu@tutanota.com', N'rwVDh9', 1),
(N'Ситдикова Елена Анатольевна', N'ptec8ym@yahoo.com', N'LdNyos', 2),
(N'Ворсин Петр Евгеньевич', N'1qz4kw@mail.com', N'gynQMT', 2),
(N'Старикова Елена Павловна', N'4np6se@mail.com', N'AtnDjr', 2),
(N'Никифорова Весения Николаевна', N'yzls62@outlook.com', N'JlFRCZ', 3),
(N'Сазонов Руслан Германович', N'1diph5e@tutanota.com', N'8ntwUp', 3),
(N'Одинцов Серафим Артёмович', N'tjde7c@yahoo.com', N'YOyhfR', 3),
(N'Степанов Михаил Артёмович', N'wpmrc3do@tutanota.com', N'RSbvHv', 3);
GO

-- ДАННЫЕ: Категории
INSERT INTO Categories (CategoryName) VALUES
(N'Художественная литература'), (N'Учебник для вузов'), (N'Хрестоматия'), (N'Учебное пособие');
GO

-- ДАННЫЕ: Производители
INSERT INTO Manufacturers (ManufacturerName) VALUES
(N'Виктор Астафьев'), (N'Гилберт Кит Честертон'), (N'Кирилл Каланджи'), (N'Людмила Улицкая'),
(N'Аркадий Гайдар'), (N'Юрий Родичев'), (N'Дэниел Джей Барретт'), (N'Шон Кэрролл'),
(N'Яков Гордин'), (N'Иосиф Бродский'), (N'Янь Чуннянь Янь Чуннянь'), (N'Дмитрий Мережковский'),
(N'Дмитрий Щербаков'), (N'Роджер Осборн, Дэн Стерджис'), (N'Любовь Беликова, Инна Ерофеева, Татьяна Шутова'),
(N'Сергей Моргачев'), (N'Екатерина Габарта, Ирина Игнатьева'), (N'Татьяна Лопаткина, Софья Маннапова');
GO

-- ДАННЫЕ: Поставщики
INSERT INTO Suppliers (SupplierName) VALUES
(N'Яуза'), (N'Т8 Издательские технологии'), (N'Прогресс книга'), (N'Время'), (N'Лениздат'),
(N'Неолит'), (N'Амрита-Русь'), (N'Златоуст'), (N'Аспект Пресс'), (N'ВКН');
GO

-- ДАННЫЕ: Товары (20 записей)
INSERT INTO Products (Article, ProductName, CategoryId, Description, ManufacturerId, SupplierId, Price, Unit, StockQuantity, Discount, ImagePath) VALUES
(N'А112Т4', N'Прокляты и убиты', 1, N'Роман-эпопею "Прокляты и убиты" Виктора Астафьева по праву считают одним из самых сильных и пронзительных произведений отечественной военной прозы.', 1, 1, 585.00, N'шт.', 6, 25.00, N'1.jpg'),
(N'G843H5', N'Тайны и загадки отца Брауна', 1, N'Гилберт Кит Честертон — признанный классик английской литературы, один из самых ярких писателей первой половины XX века.', 2, 1, 193.00, N'шт.', 9, 30.00, N'2.jpg'),
(N'D325D4', N'Девайс', 1, N'Молодой фрилансер Захар Скаро устраивается на очередную подработку. Задача, казалось бы, тривиальная: тестирование нового устройства.', 3, 2, 1599.00, N'шт.', 12, 5.00, N'3.jpg'),
(N'S432T5', N'Необыкновенное обыкновенное чудо. Школьные истории', 1, NULL, 4, 2, 549.00, N'шт.', 15, 15.00, N'4.jpg'),
(N'F325D4', N'Чук и Гек', 1, N'В книгу вошли повести и рассказы Аркадия Петровича Гайдара: "Чук и Гек", "Горячий камень" и "Сказка о военной тайне".', 5, 2, 209.00, N'шт.', 3, 18.00, N'5.jpg'),
(N'G432G6', N'Информационная безопасность. Национальные стандарты РФ. 3-е издание.', 2, N'В учебном пособии рассмотрено более 300 действующих открытых документов национальной системы стандартизации РФ.', 6, 3, 3899.00, N'шт.', 3, 22.00, N'6.jpg'),
(N'H542F5', N'Linux. Командная строка. Лучшие практики', 2, N'Перейдите на новый уровень работы в Linux! Книга поможет работать быстрее, элегантнее и эффективнее.', 7, 3, 1799.00, N'шт.', 5, 4.00, N'7.jpg'),
(N'C346F5', N'Квантовые миры и возникновение пространства-времени', 2, N'Шон Кэрролл заставляет нас по-новому взглянуть на физику.', 8, 3, 1349.00, N'шт.', 4, 5.00, N'8.jpg'),
(N'F256G6', N'Вселенная. Происхождение жизни, смысл нашего существования и огромный космос', 2, N'Знаменитый физик Шон Кэрролл объясняет принципы, которые лежат в основах научных революций от Дарвина до Эйнштейна.', 8, 3, 1799.00, N'шт.', 2, 6.00, NULL),
(N'J532V5', N'Пушкин. Бродский. Империя и судьба. В 2-х томах', 3, N'Первая книга двухтомника пронизана пушкинской темой.', 9, 4, 529.00, N'шт.', 6, 8.00, N'10.jpg'),
(N'G643F4', N'Иосиф Бродский. Избранные эссе (комплект из 6-ти книг)', 3, N'Шесть сборников избранных эссе Иосифа Бродского (1940-1996), великого поэта, лауреата Нобелевской премии по литературе.', 10, 5, 4925.00, N'шт.', 24, 2.00, N'11.jpg'),
(N'J326V5', N'Тысячелетие императорской керамики', 3, N'Фарфор стал величайшим символом китайской культуры.', 11, 5, 2599.00, N'шт.', 4, 5.00, N'12.jpg'),
(N'J632F6', N'Вечные спутники: Портреты из всемирной литературы', 3, N'Цикл критических очерков о культуре и великих литераторах Дмитрия Мережковского.', 12, 5, 1599.00, N'шт.', 6, 0.00, N'13.jpg'),
(N'G632H6', N'Формирование литературной репутации Н.Г.Чернышевского в ХIX-XXI веках', 3, N'Монография Д. А. Щербакова - новаторская.', 13, 6, 1349.00, N'шт.', 8, 2.00, N'14.jpg'),
(N'M642E5', N'Теория искусства. Краткий путеводитель', 3, NULL, 14, 6, 879.00, N'шт.', 2, 3.00, N'15.jpg'),
(N'G543F5', N'Религиозные верования с древнейших времен до наших дней', 3, N'Сборник переводов лекций по истории дохристианских и нехристианских религий.', 13, 7, 879.00, N'шт.', 6, 4.00, N'16.jpg'),
(N'B653G6', N'Русский язык: Первые шаги. Часть 3. Учебное пособие', 4, N'Пособие является завершающей частью учебного комплекса.', 15, 8, 2699.00, N'шт.', 9, 8.00, N'17.jpg'),
(N'J735J7', N'Синтетический образ индивидуального психического мира', 3, N'Психика подобна определенным объектам, это фиксируют сами люди в языке и искусстве.', 16, 8, 1099.00, N'шт.', 4, 9.00, N'18.jpg'),
(N'H436H7', N'Английский язык в спорте: Учебное пособие', 4, N'Учебное пособие подготовлено для слушателей, изучающих английский язык как язык специальности.', 17, 9, 1999.00, N'шт.', 0, 2.00, N'19.jpg'),
(N'H475R5', N'Лексика и грамматика современного китайского языка', 4, N'Пособие выступает дополнением ко второму тому учебника «Новый практический курс китайского языка».', 18, 10, 608.00, N'шт.', 12, 25.00, N'20.jpg');
GO

-- ДАННЫЕ: Пункты выдачи (36 записей)
INSERT INTO PickupPoints (Address) VALUES
(N'420151, г. Лесной, ул. Вишневая, 32'), (N'125061, г. Лесной, ул. Подгорная, 8'),
(N'630370, г. Лесной, ул. Шоссейная, 24'), (N'400562, г. Лесной, ул. Зеленая, 32'),
(N'614510, г. Лесной, ул. Маяковского, 47'), (N'410542, г. Лесной, ул. Светлая, 46'),
(N'620839, г. Лесной, ул. Цветочная, 8'), (N'443890, г. Лесной, ул. Коммунистическая, 1'),
(N'603379, г. Лесной, ул. Спортивная, 46'), (N'603721, г. Лесной, ул. Гоголя, 41'),
(N'410172, г. Лесной, ул. Северная, 13'), (N'614611, г. Лесной, ул. Молодежная, 50'),
(N'454311, г. Лесной, ул. Новая, 19'), (N'660007, г. Лесной, ул. Октябрьская, 19'),
(N'603036, г. Лесной, ул. Садовая, 4'), (N'394060, г. Лесной, ул. Фрунзе, 43'),
(N'410661, г. Лесной, ул. Школьная, 50'), (N'625590, г. Лесной, ул. Коммунистическая, 20'),
(N'625683, г. Лесной, ул. 8 Марта'), (N'450983, г. Лесной, ул. Комсомольская, 26'),
(N'394782, г. Лесной, ул. Чехова, 3'), (N'603002, г. Лесной, ул. Дзержинского, 28'),
(N'450558, г. Лесной, ул. Набережная, 30'), (N'344288, г. Лесной, ул. Чехова, 1'),
(N'614164, г. Лесной, ул. Степная, 30'), (N'394242, г. Лесной, ул. Коммунистическая, 43'),
(N'660540, г. Лесной, ул. Солнечная, 25'), (N'125837, г. Лесной, ул. Шоссейная, 40'),
(N'125703, г. Лесной, ул. Партизанская, 49'), (N'625283, г. Лесной, ул. Победы, 46'),
(N'614753, г. Лесной, ул. Полевая, 35'), (N'426030, г. Лесной, ул. Маяковского, 44'),
(N'450375, г. Лесной, ул. Клубная, 44'), (N'625560, г. Лесной, ул. Некрасова, 12'),
(N'630201, г. Лесной, ул. Комсомольская, 17'), (N'190949, г. Лесной, ул. Мичурина, 26');
GO

-- ДАННЫЕ: Статусы заказов
INSERT INTO OrderStatuses (StatusName) VALUES (N'Завершен'), (N'Новый');
GO

-- ДАННЫЕ: Заказы (10 записей)
INSERT INTO Orders (Article, StatusId, PickupPointId, OrderDate, DeliveryDate, ClientName, AccessCode) VALUES
(N'ORD-001', 1, 1, '2024-02-03', '2024-04-01', N'Степанов Михаил Артёмович', N'901'),
(N'ORD-002', 1, 11, '2023-09-04', '2024-04-02', N'Никифорова Весения Николаевна', N'902'),
(N'ORD-003', 1, 2, '2024-02-26', '2024-04-03', N'Сазонов Руслан Германович', N'903'),
(N'ORD-004', 1, 11, '2024-02-19', '2024-04-04', N'Одинцов Серафим Артёмович', N'904'),
(N'ORD-005', 1, 2, '2024-02-22', '2024-04-05', N'Степанов Михаил Артёмович', N'905'),
(N'ORD-006', 1, 15, '2024-02-06', '2024-04-06', N'Никифорова Весения Николаевна', N'906'),
(N'ORD-007', 1, 3, '2024-02-29', NULL, N'Сазонов Руслан Германович', N'907'),
(N'ORD-008', 2, 19, '2024-03-07', '2024-04-08', N'Одинцов Серафим Артёмович', N'908'),
(N'ORD-009', 2, 5, '2024-03-09', '2024-04-09', N'Степанов Михаил Артёмович', N'909'),
(N'ORD-010', 2, 19, '2024-03-10', '2024-04-10', N'Степанов Михаил Артёмович', N'910');
GO

-- ДАННЫЕ: Состав заказов
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 1, ProductId, 2, Price FROM Products WHERE Article = N'А112Т4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 1, ProductId, 2, Price FROM Products WHERE Article = N'G843H5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 2, ProductId, 1, Price FROM Products WHERE Article = N'G843H5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 2, ProductId, 1, Price FROM Products WHERE Article = N'А112Т4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 3, ProductId, 10, Price FROM Products WHERE Article = N'D325D4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 3, ProductId, 10, Price FROM Products WHERE Article = N'S432T5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 4, ProductId, 5, Price FROM Products WHERE Article = N'F325D4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 4, ProductId, 4, Price FROM Products WHERE Article = N'D325D4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 5, ProductId, 20, Price FROM Products WHERE Article = N'G432G6';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 5, ProductId, 20, Price FROM Products WHERE Article = N'H542F5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 6, ProductId, 2, Price FROM Products WHERE Article = N'А112Т4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 6, ProductId, 2, Price FROM Products WHERE Article = N'G843H5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 7, ProductId, 3, Price FROM Products WHERE Article = N'C346F5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 7, ProductId, 3, Price FROM Products WHERE Article = N'F256G6';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 8, ProductId, 1, Price FROM Products WHERE Article = N'F325D4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 8, ProductId, 1, Price FROM Products WHERE Article = N'G432G6';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 9, ProductId, 5, Price FROM Products WHERE Article = N'J532V5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 9, ProductId, 1, Price FROM Products WHERE Article = N'F256G6';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 10, ProductId, 5, Price FROM Products WHERE Article = N'F256G6';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 10, ProductId, 5, Price FROM Products WHERE Article = N'J532V5';
GO
