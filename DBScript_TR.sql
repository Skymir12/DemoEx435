
CREATE DATABASE ReadNow;
GO
USE ReadNow;
GO


CREATE TABLE Roles (
    RoleId   INT          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);
GO


CREATE TABLE Users (
    UserId     INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    FullName   NVARCHAR(300) NOT NULL,
    Login      NVARCHAR(100) NOT NULL UNIQUE,
    Password   NVARCHAR(255) NOT NULL,
    RoleId     INT           NOT NULL,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);
GO


CREATE TABLE Categories (
    CategoryId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);
GO


CREATE TABLE Manufacturers (
    ManufacturerId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    ManufacturerName NVARCHAR(200) NOT NULL UNIQUE
);
GO


CREATE TABLE Suppliers (
    SupplierId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(200) NOT NULL UNIQUE
);
GO


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


CREATE TABLE PickupPoints (
    PickupPointId INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Address       NVARCHAR(300) NOT NULL
);
GO


CREATE TABLE OrderStatuses (
    StatusId   INT           NOT NULL IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(100) NOT NULL UNIQUE
);
GO


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


INSERT INTO Roles (RoleName) VALUES (N'Àäìèíèñòðàòîð'), (N'Ìåíåäæåð'), (N'Êëèåíò');
GO


INSERT INTO Users (FullName, Login, Password, RoleId) VALUES
(N'Íèêèôîðîâà Àííà Ñåìåíîâíà', N'94d5ous@gmail.com', N'uzWC67', 1),
(N'Ñòåëèíà Åâãåíèÿ Ïåòðîâíà', N'uth4iz@mail.com', N'2L6KZG', 1),
(N'Ìèõàéëþê Àííà Âÿ÷åñëàâîâíà', N'5d4zbu@tutanota.com', N'rwVDh9', 1),
(N'Ñèòäèêîâà Åëåíà Àíàòîëüåâíà', N'ptec8ym@yahoo.com', N'LdNyos', 2),
(N'Âîðñèí Ïåòð Åâãåíüåâè÷', N'1qz4kw@mail.com', N'gynQMT', 2),
(N'Ñòàðèêîâà Åëåíà Ïàâëîâíà', N'4np6se@mail.com', N'AtnDjr', 2),
(N'Íèêèôîðîâà Âåñåíèÿ Íèêîëàåâíà', N'yzls62@outlook.com', N'JlFRCZ', 3),
(N'Ñàçîíîâ Ðóñëàí Ãåðìàíîâè÷', N'1diph5e@tutanota.com', N'8ntwUp', 3),
(N'Îäèíöîâ Ñåðàôèì Àðò¸ìîâè÷', N'tjde7c@yahoo.com', N'YOyhfR', 3),
(N'Ñòåïàíîâ Ìèõàèë Àðò¸ìîâè÷', N'wpmrc3do@tutanota.com', N'RSbvHv', 3);
GO


INSERT INTO Categories (CategoryName) VALUES
(N'Õóäîæåñòâåííàÿ ëèòåðàòóðà'), (N'Ó÷åáíèê äëÿ âóçîâ'), (N'Õðåñòîìàòèÿ'), (N'Ó÷åáíîå ïîñîáèå');
GO


INSERT INTO Manufacturers (ManufacturerName) VALUES
(N'Âèêòîð Àñòàôüåâ'), (N'Ãèëáåðò Êèò ×åñòåðòîí'), (N'Êèðèëë Êàëàíäæè'), (N'Ëþäìèëà Óëèöêàÿ'),
(N'Àðêàäèé Ãàéäàð'), (N'Þðèé Ðîäè÷åâ'), (N'Äýíèåë Äæåé Áàððåòò'), (N'Øîí Êýððîëë'),
(N'ßêîâ Ãîðäèí'), (N'Èîñèô Áðîäñêèé'), (N'ßíü ×óííÿíü ßíü ×óííÿíü'), (N'Äìèòðèé Ìåðåæêîâñêèé'),
(N'Äìèòðèé Ùåðáàêîâ'), (N'Ðîäæåð Îñáîðí, Äýí Ñòåðäæèñ'), (N'Ëþáîâü Áåëèêîâà, Èííà Åðîôååâà, Òàòüÿíà Øóòîâà'),
(N'Ñåðãåé Ìîðãà÷åâ'), (N'Åêàòåðèíà Ãàáàðòà, Èðèíà Èãíàòüåâà'), (N'Òàòüÿíà Ëîïàòêèíà, Ñîôüÿ Ìàííàïîâà');
GO


INSERT INTO Suppliers (SupplierName) VALUES
(N'ßóçà'), (N'Ò8 Èçäàòåëüñêèå òåõíîëîãèè'), (N'Ïðîãðåññ êíèãà'), (N'Âðåìÿ'), (N'Ëåíèçäàò'),
(N'Íåîëèò'), (N'Àìðèòà-Ðóñü'), (N'Çëàòîóñò'), (N'Àñïåêò Ïðåññ'), (N'ÂÊÍ');
GO


INSERT INTO Products (Article, ProductName, CategoryId, Description, ManufacturerId, SupplierId, Price, Unit, StockQuantity, Discount, ImagePath) VALUES
(N'À112Ò4', N'Ïðîêëÿòû è óáèòû', 1, N'Ðîìàí-ýïîïåþ "Ïðîêëÿòû è óáèòû" Âèêòîðà Àñòàôüåâà ïî ïðàâó ñ÷èòàþò îäíèì èç ñàìûõ ñèëüíûõ è ïðîíçèòåëüíûõ ïðîèçâåäåíèé îòå÷åñòâåííîé âîåííîé ïðîçû.', 1, 1, 585.00, N'øò.', 6, 25.00, N'1.jpg'),
(N'G843H5', N'Òàéíû è çàãàäêè îòöà Áðàóíà', 1, N'Ãèëáåðò Êèò ×åñòåðòîí — ïðèçíàííûé êëàññèê àíãëèéñêîé ëèòåðàòóðû, îäèí èç ñàìûõ ÿðêèõ ïèñàòåëåé ïåðâîé ïîëîâèíû XX âåêà.', 2, 1, 193.00, N'øò.', 9, 30.00, N'2.jpg'),
(N'D325D4', N'Äåâàéñ', 1, N'Ìîëîäîé ôðèëàíñåð Çàõàð Ñêàðî óñòðàèâàåòñÿ íà î÷åðåäíóþ ïîäðàáîòêó. Çàäà÷à, êàçàëîñü áû, òðèâèàëüíàÿ: òåñòèðîâàíèå íîâîãî óñòðîéñòâà.', 3, 2, 1599.00, N'øò.', 12, 5.00, N'3.jpg'),
(N'S432T5', N'Íåîáûêíîâåííîå îáûêíîâåííîå ÷óäî. Øêîëüíûå èñòîðèè', 1, NULL, 4, 2, 549.00, N'øò.', 15, 15.00, N'4.jpg'),
(N'F325D4', N'×óê è Ãåê', 1, N'Â êíèãó âîøëè ïîâåñòè è ðàññêàçû Àðêàäèÿ Ïåòðîâè÷à Ãàéäàðà: "×óê è Ãåê", "Ãîðÿ÷èé êàìåíü" è "Ñêàçêà î âîåííîé òàéíå".', 5, 2, 209.00, N'øò.', 3, 18.00, N'5.jpg'),
(N'G432G6', N'Èíôîðìàöèîííàÿ áåçîïàñíîñòü. Íàöèîíàëüíûå ñòàíäàðòû ÐÔ. 3-å èçäàíèå.', 2, N'Â ó÷åáíîì ïîñîáèè ðàññìîòðåíî áîëåå 300 äåéñòâóþùèõ îòêðûòûõ äîêóìåíòîâ íàöèîíàëüíîé ñèñòåìû ñòàíäàðòèçàöèè ÐÔ.', 6, 3, 3899.00, N'øò.', 3, 22.00, N'6.jpg'),
(N'H542F5', N'Linux. Êîìàíäíàÿ ñòðîêà. Ëó÷øèå ïðàêòèêè', 2, N'Ïåðåéäèòå íà íîâûé óðîâåíü ðàáîòû â Linux! Êíèãà ïîìîæåò ðàáîòàòü áûñòðåå, ýëåãàíòíåå è ýôôåêòèâíåå.', 7, 3, 1799.00, N'øò.', 5, 4.00, N'7.jpg'),
(N'C346F5', N'Êâàíòîâûå ìèðû è âîçíèêíîâåíèå ïðîñòðàíñòâà-âðåìåíè', 2, N'Øîí Êýððîëë çàñòàâëÿåò íàñ ïî-íîâîìó âçãëÿíóòü íà ôèçèêó.', 8, 3, 1349.00, N'øò.', 4, 5.00, N'8.jpg'),
(N'F256G6', N'Âñåëåííàÿ. Ïðîèñõîæäåíèå æèçíè, ñìûñë íàøåãî ñóùåñòâîâàíèÿ è îãðîìíûé êîñìîñ', 2, N'Çíàìåíèòûé ôèçèê Øîí Êýððîëë îáúÿñíÿåò ïðèíöèïû, êîòîðûå ëåæàò â îñíîâàõ íàó÷íûõ ðåâîëþöèé îò Äàðâèíà äî Ýéíøòåéíà.', 8, 3, 1799.00, N'øò.', 2, 6.00, NULL),
(N'J532V5', N'Ïóøêèí. Áðîäñêèé. Èìïåðèÿ è ñóäüáà. Â 2-õ òîìàõ', 3, N'Ïåðâàÿ êíèãà äâóõòîìíèêà ïðîíèçàíà ïóøêèíñêîé òåìîé.', 9, 4, 529.00, N'øò.', 6, 8.00, N'10.jpg'),
(N'G643F4', N'Èîñèô Áðîäñêèé. Èçáðàííûå ýññå (êîìïëåêò èç 6-òè êíèã)', 3, N'Øåñòü ñáîðíèêîâ èçáðàííûõ ýññå Èîñèôà Áðîäñêîãî (1940-1996), âåëèêîãî ïîýòà, ëàóðåàòà Íîáåëåâñêîé ïðåìèè ïî ëèòåðàòóðå.', 10, 5, 4925.00, N'øò.', 24, 2.00, N'11.jpg'),
(N'J326V5', N'Òûñÿ÷åëåòèå èìïåðàòîðñêîé êåðàìèêè', 3, N'Ôàðôîð ñòàë âåëè÷àéøèì ñèìâîëîì êèòàéñêîé êóëüòóðû.', 11, 5, 2599.00, N'øò.', 4, 5.00, N'12.jpg'),
(N'J632F6', N'Âå÷íûå ñïóòíèêè: Ïîðòðåòû èç âñåìèðíîé ëèòåðàòóðû', 3, N'Öèêë êðèòè÷åñêèõ î÷åðêîâ î êóëüòóðå è âåëèêèõ ëèòåðàòîðàõ Äìèòðèÿ Ìåðåæêîâñêîãî.', 12, 5, 1599.00, N'øò.', 6, 0.00, N'13.jpg'),
(N'G632H6', N'Ôîðìèðîâàíèå ëèòåðàòóðíîé ðåïóòàöèè Í.Ã.×åðíûøåâñêîãî â ÕIX-XXI âåêàõ', 3, N'Ìîíîãðàôèÿ Ä. À. Ùåðáàêîâà - íîâàòîðñêàÿ.', 13, 6, 1349.00, N'øò.', 8, 2.00, N'14.jpg'),
(N'M642E5', N'Òåîðèÿ èñêóññòâà. Êðàòêèé ïóòåâîäèòåëü', 3, NULL, 14, 6, 879.00, N'øò.', 2, 3.00, N'15.jpg'),
(N'G543F5', N'Ðåëèãèîçíûå âåðîâàíèÿ ñ äðåâíåéøèõ âðåìåí äî íàøèõ äíåé', 3, N'Ñáîðíèê ïåðåâîäîâ ëåêöèé ïî èñòîðèè äîõðèñòèàíñêèõ è íåõðèñòèàíñêèõ ðåëèãèé.', 13, 7, 879.00, N'øò.', 6, 4.00, N'16.jpg'),
(N'B653G6', N'Ðóññêèé ÿçûê: Ïåðâûå øàãè. ×àñòü 3. Ó÷åáíîå ïîñîáèå', 4, N'Ïîñîáèå ÿâëÿåòñÿ çàâåðøàþùåé ÷àñòüþ ó÷åáíîãî êîìïëåêñà.', 15, 8, 2699.00, N'øò.', 9, 8.00, N'17.jpg'),
(N'J735J7', N'Ñèíòåòè÷åñêèé îáðàç èíäèâèäóàëüíîãî ïñèõè÷åñêîãî ìèðà', 3, N'Ïñèõèêà ïîäîáíà îïðåäåëåííûì îáúåêòàì, ýòî ôèêñèðóþò ñàìè ëþäè â ÿçûêå è èñêóññòâå.', 16, 8, 1099.00, N'øò.', 4, 9.00, N'18.jpg'),
(N'H436H7', N'Àíãëèéñêèé ÿçûê â ñïîðòå: Ó÷åáíîå ïîñîáèå', 4, N'Ó÷åáíîå ïîñîáèå ïîäãîòîâëåíî äëÿ ñëóøàòåëåé, èçó÷àþùèõ àíãëèéñêèé ÿçûê êàê ÿçûê ñïåöèàëüíîñòè.', 17, 9, 1999.00, N'øò.', 0, 2.00, N'19.jpg'),
(N'H475R5', N'Ëåêñèêà è ãðàììàòèêà ñîâðåìåííîãî êèòàéñêîãî ÿçûêà', 4, N'Ïîñîáèå âûñòóïàåò äîïîëíåíèåì êî âòîðîìó òîìó ó÷åáíèêà «Íîâûé ïðàêòè÷åñêèé êóðñ êèòàéñêîãî ÿçûêà».', 18, 10, 608.00, N'øò.', 12, 25.00, N'20.jpg');
GO


INSERT INTO PickupPoints (Address) VALUES
(N'420151, ã. Ëåñíîé, óë. Âèøíåâàÿ, 32'), (N'125061, ã. Ëåñíîé, óë. Ïîäãîðíàÿ, 8'),
(N'630370, ã. Ëåñíîé, óë. Øîññåéíàÿ, 24'), (N'400562, ã. Ëåñíîé, óë. Çåëåíàÿ, 32'),
(N'614510, ã. Ëåñíîé, óë. Ìàÿêîâñêîãî, 47'), (N'410542, ã. Ëåñíîé, óë. Ñâåòëàÿ, 46'),
(N'620839, ã. Ëåñíîé, óë. Öâåòî÷íàÿ, 8'), (N'443890, ã. Ëåñíîé, óë. Êîììóíèñòè÷åñêàÿ, 1'),
(N'603379, ã. Ëåñíîé, óë. Ñïîðòèâíàÿ, 46'), (N'603721, ã. Ëåñíîé, óë. Ãîãîëÿ, 41'),
(N'410172, ã. Ëåñíîé, óë. Ñåâåðíàÿ, 13'), (N'614611, ã. Ëåñíîé, óë. Ìîëîäåæíàÿ, 50'),
(N'454311, ã. Ëåñíîé, óë. Íîâàÿ, 19'), (N'660007, ã. Ëåñíîé, óë. Îêòÿáðüñêàÿ, 19'),
(N'603036, ã. Ëåñíîé, óë. Ñàäîâàÿ, 4'), (N'394060, ã. Ëåñíîé, óë. Ôðóíçå, 43'),
(N'410661, ã. Ëåñíîé, óë. Øêîëüíàÿ, 50'), (N'625590, ã. Ëåñíîé, óë. Êîììóíèñòè÷åñêàÿ, 20'),
(N'625683, ã. Ëåñíîé, óë. 8 Ìàðòà'), (N'450983, ã. Ëåñíîé, óë. Êîìñîìîëüñêàÿ, 26'),
(N'394782, ã. Ëåñíîé, óë. ×åõîâà, 3'), (N'603002, ã. Ëåñíîé, óë. Äçåðæèíñêîãî, 28'),
(N'450558, ã. Ëåñíîé, óë. Íàáåðåæíàÿ, 30'), (N'344288, ã. Ëåñíîé, óë. ×åõîâà, 1'),
(N'614164, ã. Ëåñíîé, óë. Ñòåïíàÿ, 30'), (N'394242, ã. Ëåñíîé, óë. Êîììóíèñòè÷åñêàÿ, 43'),
(N'660540, ã. Ëåñíîé, óë. Ñîëíå÷íàÿ, 25'), (N'125837, ã. Ëåñíîé, óë. Øîññåéíàÿ, 40'),
(N'125703, ã. Ëåñíîé, óë. Ïàðòèçàíñêàÿ, 49'), (N'625283, ã. Ëåñíîé, óë. Ïîáåäû, 46'),
(N'614753, ã. Ëåñíîé, óë. Ïîëåâàÿ, 35'), (N'426030, ã. Ëåñíîé, óë. Ìàÿêîâñêîãî, 44'),
(N'450375, ã. Ëåñíîé, óë. Êëóáíàÿ, 44'), (N'625560, ã. Ëåñíîé, óë. Íåêðàñîâà, 12'),
(N'630201, ã. Ëåñíîé, óë. Êîìñîìîëüñêàÿ, 17'), (N'190949, ã. Ëåñíîé, óë. Ìè÷óðèíà, 26');
GO


INSERT INTO OrderStatuses (StatusName) VALUES (N'Çàâåðøåí'), (N'Íîâûé');
GO


INSERT INTO Orders (Article, StatusId, PickupPointId, OrderDate, DeliveryDate, ClientName, AccessCode) VALUES
(N'ORD-001', 1, 1, '2024-02-03', '2024-04-01', N'Ñòåïàíîâ Ìèõàèë Àðò¸ìîâè÷', N'901'),
(N'ORD-002', 1, 11, '2023-09-04', '2024-04-02', N'Íèêèôîðîâà Âåñåíèÿ Íèêîëàåâíà', N'902'),
(N'ORD-003', 1, 2, '2024-02-26', '2024-04-03', N'Ñàçîíîâ Ðóñëàí Ãåðìàíîâè÷', N'903'),
(N'ORD-004', 1, 11, '2024-02-19', '2024-04-04', N'Îäèíöîâ Ñåðàôèì Àðò¸ìîâè÷', N'904'),
(N'ORD-005', 1, 2, '2024-02-22', '2024-04-05', N'Ñòåïàíîâ Ìèõàèë Àðò¸ìîâè÷', N'905'),
(N'ORD-006', 1, 15, '2024-02-06', '2024-04-06', N'Íèêèôîðîâà Âåñåíèÿ Íèêîëàåâíà', N'906'),
(N'ORD-007', 1, 3, '2024-02-29', NULL, N'Ñàçîíîâ Ðóñëàí Ãåðìàíîâè÷', N'907'),
(N'ORD-008', 2, 19, '2024-03-07', '2024-04-08', N'Îäèíöîâ Ñåðàôèì Àðò¸ìîâè÷', N'908'),
(N'ORD-009', 2, 5, '2024-03-09', '2024-04-09', N'Ñòåïàíîâ Ìèõàèë Àðò¸ìîâè÷', N'909'),
(N'ORD-010', 2, 19, '2024-03-10', '2024-04-10', N'Ñòåïàíîâ Ìèõàèë Àðò¸ìîâè÷', N'910');
GO


INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 1, ProductId, 2, Price FROM Products WHERE Article = N'À112Ò4';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 1, ProductId, 2, Price FROM Products WHERE Article = N'G843H5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 2, ProductId, 1, Price FROM Products WHERE Article = N'G843H5';
INSERT INTO OrderProducts (OrderId, ProductId, Quantity, PriceAtOrder)
SELECT 2, ProductId, 1, Price FROM Products WHERE Article = N'À112Ò4';
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
SELECT 6, ProductId, 2, Price FROM Products WHERE Article = N'À112Ò4';
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
