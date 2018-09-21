-- Create tables section -------------------------------------------------

-- Table Movie

CREATE TABLE [Movie]
(
 [MovieId] Bigint NOT NULL,
 [Title] Varchar(20) NOT NULL,
 [Director] Varchar(20) NOT NULL,
 [ProductionCompany] Varchar(20) NULL,
 [MinimalAge] Int NULL,
 [Rating] Decimal(2,0) NULL
)
go

-- Add keys for table Movie

ALTER TABLE [Movie] ADD CONSTRAINT [MovieId] PRIMARY KEY ([MovieId])
go

-- Table Genre

CREATE TABLE [Genre]
(
 [GenreId] Bigint NOT NULL,
 [Name] Varchar(20) NULL
)
go

-- Add keys for table Genre

ALTER TABLE [Genre] ADD CONSTRAINT [GenreId] PRIMARY KEY ([GenreId])
go

-- Table MoviesGenres

CREATE TABLE [MoviesGenres]
(
 [MovieGenreId] Bigint NOT NULL,
 [GenreId] Bigint NULL,
 [MovieId] Bigint NULL
)
go

-- Create indexes for table MoviesGenres

CREATE INDEX [GenreIndex] ON [MoviesGenres] ([GenreId],[MovieId])
go

CREATE INDEX [IX_Relationship8] ON [MoviesGenres] ([GenreId])
go

CREATE INDEX [IX_Relationship10] ON [MoviesGenres] ([MovieId])
go

-- Add keys for table MoviesGenres

ALTER TABLE [MoviesGenres] ADD CONSTRAINT [Id] PRIMARY KEY ([MovieGenreId])
go

-- Table dbo.Address

CREATE TABLE [dbo].[Address]
(
 [Id] Bigint IDENTITY(1,1) NOT NULL,
 [Street] Nvarchar(100) COLLATE Polish_CI_AS NOT NULL,
 [ZipCode] Nchar(10) COLLATE Polish_CI_AS NOT NULL,
 [City] Nvarchar(50) COLLATE Polish_CI_AS NOT NULL,
 [Country] Nvarchar(100) NOT NULL
)
ON [PRIMARY]
go

-- Add keys for table dbo.Address

ALTER TABLE [dbo].[Address] ADD CONSTRAINT [AddressId] PRIMARY KEY ([Id])
 ON [PRIMARY]
go

-- Table dbo.Customer

CREATE TABLE [dbo].[Customer]
(
 [CustomerId] Bigint IDENTITY(1,1) NOT NULL,
 [Name] Nvarchar(30) COLLATE Polish_CI_AS NOT NULL,
 [Surname] Nvarchar(50) COLLATE Polish_CI_AS NOT NULL,
 [AddressId] Bigint NOT NULL,
 [MoviesLimitNumber] Int NOT NULL,
 [CustomerMaxRentalTime] Bigint NOT NULL,
 [CustomerMaxTransactionTime] Bigint NOT NULL,
 [ModificationDate] Datetime NULL
)
ON [PRIMARY]
go

-- Add keys for table dbo.Customer

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [CustomerId] PRIMARY KEY ([CustomerId])
 ON [PRIMARY]
go


-- Table dbo.ShoppingCart

CREATE TABLE [dbo].[ShoppingCart]
(
 [ShoppingCartId] Bigint IDENTITY(1,1) NOT NULL,
 [Amount] Int NOT NULL,
 [RentalTransactionId] Bigint NULL,
 [ShoppingCartAvailableUntil] Datetime NOT NULL,
 [Finalized] Bit NULL
)
ON [PRIMARY]
go

-- Create indexes for table dbo.ShoppingCart

CREATE INDEX [IX_Relationship6] ON [dbo].[ShoppingCart] ([RentalTransactionId])
go

-- Add keys for table dbo.ShoppingCart

ALTER TABLE [dbo].[ShoppingCart] ADD CONSTRAINT [ShoppingCartId] PRIMARY KEY ([ShoppingCartId])
 ON [PRIMARY]
go

-- Table dbo.Employee

CREATE TABLE [dbo].[Employee]
(
 [EmployeeId] Bigint IDENTITY(1,1) NOT NULL,
 [Name] Nvarchar(30) COLLATE Polish_CI_AS NOT NULL,
 [Surname] Nvarchar(50) COLLATE Polish_CI_AS NOT NULL,
 [AddressId] Bigint NOT NULL
)
ON [PRIMARY]
go

-- Add keys for table dbo.Employee

ALTER TABLE [dbo].[Employee] ADD CONSTRAINT [EmployeeId] PRIMARY KEY ([EmployeeId])
 ON [PRIMARY]
go

-- Table dbo.Product

CREATE TABLE [dbo].[Product]
(
 [Description] Nvarchar(max) COLLATE Polish_CI_AS NULL,
 [Price] Decimal(9,2) NOT NULL,
 [ProductId] Bigint NOT NULL,
 [MovieId] Bigint NULL,
 [Rating] Decimal(2,0) NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
go

-- Create indexes for table dbo.Product

CREATE INDEX [IX_Relationship2] ON [dbo].[Product] ([MovieId])
go

-- Add keys for table dbo.Product

ALTER TABLE [dbo].[Product] ADD CONSTRAINT [ProductId] PRIMARY KEY ([ProductId])
 ON [PRIMARY]
go

-- Table dbo.RentalTransaction

CREATE TABLE [dbo].[RentalTransaction]
(
 [RentalTransactionId] Bigint IDENTITY(1,1) NOT NULL,
 [DateStart] Datetime NOT NULL,
 [DateEnd] Datetime NULL,
 [CustomerId] Bigint NOT NULL,
 [EmployeeId] Bigint NOT NULL,
 [MoneyAmount] Decimal(2,0) NULL,
 [RentalDateStart] Datetime NULL,
 [RentalReturnTerm] Datetime NULL,
 [RentalDateEnd] Datetime NULL,
 [TransactionAvailableUntil] Bigint NOT NULL,
 [Finalized] Bit NULL
)
ON [PRIMARY]
go
EXEC sp_addextendedproperty 'MS_Description', 'Czas waznosci transakcji (zwiekszany przy kazdym dodaniu produktu)', 'SCHEMA', 'dbo', 'TABLE', 'RentalTransaction', 'COLUMN', 'DateEnd'
go
EXEC sp_addextendedproperty 'MS_Description', 'Wyznaczony przez system termin zwrotu', 'SCHEMA', 'dbo', 'TABLE', 'RentalTransaction', 'COLUMN', 'RentalReturnTerm'
go

-- Add keys for table dbo.RentalTransaction

ALTER TABLE [dbo].[RentalTransaction] ADD CONSTRAINT [RentalTransactionId] PRIMARY KEY ([RentalTransactionId])
 ON [PRIMARY]
go

-- Table dbo.ProductsInShoppingCart

CREATE TABLE [dbo].[ProductsInShoppingCart]
(
 [ProductInShoppingCartId] Bigint NOT NULL,
 [ShoppingCartId] Bigint NULL,
 [ProductId] Bigint NULL
)
ON [PRIMARY]
go

-- Create indexes for table dbo.ProductsInShoppingCart

CREATE INDEX [IX_Relationship14] ON [dbo].[ProductsInShoppingCart] ([ShoppingCartId])
go

CREATE INDEX [IX_Relationship1] ON [dbo].[ProductsInShoppingCart] ([ProductId])
go

-- Add keys for table dbo.ProductsInShoppingCart

ALTER TABLE [dbo].[ProductsInShoppingCart] ADD CONSTRAINT [ProductsInShoppingCartId] PRIMARY KEY ([ProductInShoppingCartId])
 ON [PRIMARY]
go

-- Create relationships section ------------------------------------------------- 

ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [CustomerHasAddress] FOREIGN KEY ([AddressId]) REFERENCES [dbo].[Address] ([Id]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [dbo].[Employee] ADD CONSTRAINT [EmployeeHasAddress] FOREIGN KEY ([AddressId]) REFERENCES [dbo].[Address] ([Id]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [dbo].[RentalTransaction] ADD CONSTRAINT [CustomerRentalTransactions] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [dbo].[RentalTransaction] ADD CONSTRAINT [FK_Transaction_Employee] FOREIGN KEY ([EmployeeId]) REFERENCES [dbo].[Employee] ([EmployeeId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [dbo].[Product] ADD CONSTRAINT [MovieIsAsProducts] FOREIGN KEY ([MovieId]) REFERENCES [Movie] ([MovieId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [dbo].[ShoppingCart] ADD CONSTRAINT [RentalTransactionShouldHaveShoppingCart] FOREIGN KEY ([RentalTransactionId]) REFERENCES [dbo].[RentalTransaction] ([RentalTransactionId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [MoviesGenres] ADD CONSTRAINT [MoviesBelongsToGenres] FOREIGN KEY ([GenreId]) REFERENCES [Genre] ([GenreId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [MoviesGenres] ADD CONSTRAINT [MovieHasGenres] FOREIGN KEY ([MovieId]) REFERENCES [Movie] ([MovieId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [dbo].[ProductsInShoppingCart] ADD CONSTRAINT [ShoppingCartCanHaveManyProducts] FOREIGN KEY ([ShoppingCartId]) REFERENCES [dbo].[ShoppingCart] ([ShoppingCartId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE [dbo].[ProductsInShoppingCart] ADD CONSTRAINT [ProductCanBeInManyShoppingCarts] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId]) ON UPDATE NO ACTION ON DELETE NO ACTION
go


INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23500	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23501	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23502	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23503	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23504	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23505	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23506	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23507	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23508	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23509	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23510	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23511	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23512	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23513	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23514	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23515	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23516	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23517	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23518	,	N'Miasto'	,	N'Kraj'	)
INSERT INTO [dbo].[Address] ([Street],[ZipCode],[City],[Country]) VALUES (	N'Ulica'	,	23519	,	N'Miasto'	,	N'Kraj'	)
								
								
UPDATE [dbo].[Address]								
SET 								
Street = Street + str(Id),								
City = City + str(Id),								
Country = Country + str(Id)														


INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	1	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	2	,	10	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	3	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	4	,	3	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	5	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	6	,	10	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	7	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	8	,	3	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	9	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	10	,	10	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	11	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	12	,	3	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	13	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	14	,	10	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	15	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	16	,	3	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	17	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	18	,	10	,	60480000	,	60000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	19	,	5	,	60480000	,	30000	)
INSERT INTO [dbo].[Customer]([Name],[Surname],[AddressId],[MoviesLimitNumber],[CustomerMaxRentalTime],[CustomerMaxTransactionTime]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	20	,	3	,	60480000	,	60000	)



INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	1	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	2	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	3	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	4	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	5	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	6	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	7	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	8	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	9	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	10	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	11	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	12	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	13	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	14	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	15	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	16	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	17	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	18	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	19	)
INSERT INTO [dbo].[Employee]([Name],[Surname],[AddressId]) VALUES (	N'Imiê'	,	N'Nazwisko'	,	20	)




INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	1	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	2	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	3	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	4	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	5	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	6	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	7	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	8	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	9	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	10	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	11	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	12	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	13	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	14	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	15	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	16	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	17	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	18	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	19	,	N'Gat'	)
INSERT INTO [dbo].[Genre]([GenreId],[Name]) VALUES (	20	,	N'Gat'	)
				
				
UPDATE [dbo].[Genre]				
   SET [Name] = [Name] + str(GenreId)				

   
   
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	1	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	6	,	1	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	2	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	2	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	3	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	18	,	3	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	4	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	4	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	5	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	6	,	5	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	6	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	6	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	7	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	18	,	7	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	8	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	8	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	9	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	6	,	9	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	10	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	10	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	11	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	18	,	1	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	12	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	2	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	13	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	6	,	3	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	14	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	4	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	15	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	18	,	5	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	16	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	6	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	17	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	6	,	7	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	18	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	8	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	19	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	18	,	9	)
INSERT INTO [dbo].[Movie]([MovieId],[Title],[Director],[ProductionCompany],[MinimalAge],[Rating]) VALUES (	20	,	N'Tytu³'	,	N'TenSam'	,	N'Producent'	,	12	,	10	)
												
												
												
UPDATE [dbo].[Movie]												
   SET [Title] = [Title] + str(MovieId)												

   
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	1	,	1	,	1	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	2	,	2	,	2	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	3	,	3	,	3	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	4	,	4	,	4	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	5	,	5	,	5	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	6	,	6	,	1	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	7	,	7	,	2	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	8	,	8	,	3	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	9	,	9	,	4	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	10	,	10	,	5	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	11	,	11	,	6	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	12	,	12	,	7	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	13	,	13	,	8	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	14	,	14	,	9	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	15	,	15	,	10	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	16	,	16	,	11	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	17	,	17	,	12	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	18	,	1	,	13	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	19	,	2	,	1	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	20	,	3	,	2	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	21	,	4	,	3	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	22	,	5	,	4	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	23	,	6	,	5	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	24	,	7	,	6	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	25	,	8	,	7	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	26	,	9	,	8	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	27	,	10	,	9	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	28	,	11	,	10	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	29	,	12	,	11	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	30	,	13	,	12	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	31	,	14	,	13	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	32	,	15	,	14	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	33	,	16	,	15	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	34	,	17	,	16	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	35	,	18	,	17	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	36	,	19	,	18	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	37	,	20	,	19	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	38	,	1	,	20	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	39	,	2	,	1	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	40	,	3	,	2	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	41	,	4	,	3	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	42	,	5	,	4	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	43	,	6	,	5	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	44	,	7	,	6	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	45	,	8	,	7	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	46	,	9	,	8	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	47	,	10	,	9	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	48	,	11	,	10	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	49	,	12	,	11	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	50	,	13	,	12	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	51	,	1	,	13	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	52	,	2	,	14	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	53	,	3	,	15	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	54	,	4	,	16	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	55	,	5	,	17	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	56	,	6	,	1	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	57	,	7	,	2	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	58	,	8	,	3	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	59	,	9	,	4	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	60	,	10	,	5	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	61	,	11	,	6	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	62	,	12	,	7	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	63	,	13	,	8	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	64	,	14	,	9	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	65	,	15	,	10	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	66	,	16	,	11	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	67	,	1	,	12	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	68	,	2	,	13	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	69	,	3	,	1	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	70	,	4	,	2	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	71	,	5	,	3	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	72	,	6	,	4	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	73	,	7	,	5	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	74	,	8	,	6	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	75	,	9	,	7	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	76	,	10	,	8	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	77	,	11	,	9	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	78	,	12	,	10	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	79	,	13	,	11	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	80	,	14	,	12	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	81	,	15	,	13	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	82	,	16	,	14	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	83	,	17	,	15	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	84	,	18	,	16	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	85	,	19	,	17	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	86	,	20	,	18	)
INSERT INTO [dbo].[MoviesGenres]([MovieGenreId],[GenreId],[MovieId]) VALUES (	87	,	19	,	19	)



INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	1	,	1	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	2	,	2	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	3	,	3	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	4	,	4	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	5	,	5	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	6	,	6	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	7	,	7	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	8	,	8	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	9	,	9	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	10	,	10	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	11	,	11	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	12	,	12	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	13	,	13	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	14	,	14	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	15	,	15	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	16	,	16	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	17	,	17	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	18	,	18	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	19	,	19	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	20	,	20	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	21	,	1	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	22	,	2	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	23	,	3	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	24	,	4	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	25	,	5	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	26	,	6	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	27	,	7	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	28	,	8	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	29	,	9	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	30	,	10	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	31	,	11	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	32	,	12	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	33	,	13	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	34	,	14	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	35	,	15	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	36	,	16	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	37	,	17	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	38	,	18	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	39	,	19	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	40	,	20	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	41	,	1	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	42	,	2	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	43	,	3	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	44	,	4	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	45	,	5	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	46	,	6	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	47	,	7	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	48	,	8	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	49	,	9	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	50	,	10	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	51	,	11	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	52	,	12	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	53	,	13	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	54	,	14	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	55	,	15	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	56	,	16	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	57	,	17	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	58	,	18	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	59	,	19	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	60	,	20	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	61	,	1	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	62	,	2	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	63	,	3	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	64	,	4	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	65	,	5	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	66	,	6	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	67	,	7	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	68	,	8	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	69	,	9	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	70	,	10	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	71	,	11	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	72	,	12	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	73	,	13	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	74	,	14	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	75	,	15	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	76	,	16	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	77	,	17	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	7	,	78	,	18	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	10	,	79	,	19	)
INSERT INTO [dbo].[Product]([Description],[Price],[ProductId],[MovieId]) VALUES (	N'Opis'	,	8	,	80	,	20	)




SELECT [GenreId]
      ,[Name]
FROM [Genre]
  
  
SELECT [Id]
      ,[Street]
      ,[ZipCode]
      ,[City]
      ,[Country]
FROM [Address]

SELECT [CustomerId]
      ,[Name]
      ,[Surname]
      ,[AddressId]
      ,[MoviesLimitNumber]
      ,[CustomerMaxRentalTime]
      ,[CustomerMaxTransactionTime]
FROM [Customer]

SELECT [EmployeeId]
      ,[Name]
      ,[Surname]
      ,[AddressId]
FROM [Projekt].[dbo].[Employee]

SELECT [Description]
      ,[Price]
      ,[ProductId]
      ,[MovieId]
FROM [Product]

UPDATE [Address]
   SET [Street] = [Street]

UPDATE [Customer]
   SET [Name] = [Name]
   
UPDATE [Employee]
   SET [Name] = [Name]

UPDATE [Genre]
   SET [Name] = [Name]

UPDATE [Product]
   SET [Description] = [Description]
   
   
DELETE [Address]
WHERE [Id] = 0

DELETE [Customer]
WHERE [CustomerId] = 0
   
DELETE [Employee]
WHERE [EmployeeId] = 0

DELETE [Genre]
WHERE [GenreId] = 0

DELETE [Product]
WHERE [ProductId] = 0
