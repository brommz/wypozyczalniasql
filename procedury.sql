
-- Create procedures section -------------------------------------------------

/*
Procedury
1. Dodaj produktu do koszyka
	-> modyfikuje ShoppingCartAvailableUntil na wartoœæ 
	RentalDateStart + (CustomerMaxTransactionTime/MoviesLimitNumber)

2. Dodaj transakcje
	-> RentalReturnTime ustawiæ z Now()+CustomerMaxRentalTime
3. Finalizuj transakcjê
	-> podliczenie kasy
	-> ustawienie dat
4. Zaktualizuj ratingi filmów (kolumna Rating w Movie)
5. Dodanie produktu do bazy
*/

/*(1)*/
CREATE PROCEDURE proc_addProductToShoppingCart 
    @transactionId int,
    @productId int
AS
BEGIN
	DECLARE @TranscationAvailableUntil DATETIME
	DECLARE @RentalDateStart DATETIME
	DECLARE @MoviesLimitNumber INT
	SELECT TOP 1 
		@TranscationAvailableUntil = rental.[TransactionAvailableUntil],
		@RentalDateStart = rental.[RentalDateStart],
		@MoviesLimitNumber = customer.MoviesLimitNumber
	FROM [RentalTransaction] rental
	JOIN [Customer] customer
	ON rental.CustomerId = customer.CustomerId
	WHERE [RentalTransactionId] = @transactionId
	if @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No such transaction in DB', 16, 1)
			RETURN
		END
		
	--skorzystaæ z funkcji 5. Czy film (poprzez dostêpnoœæ niezablokowanych produktów) jest dostêpny
	DECLARE @IsProductAvailable BIT
	SELECT @IsProductAvailable = [dbo].func_isProductAvailable(@productId, GETDATE())
	if @IsProductAvailable = 0
		BEGIN
			RAISERROR('No product avaialble', 16, 1)
			RETURN
		END

	--jeœli transackja nie ma koszyka to dodaj
	DECLARE @ShoppingCartId BIGINT
	SELECT TOP 1 
		@ShoppingCartId = [ShoppingCartId]
	FROM [ShoppingCart] 
	WHERE [RentalTransactionId] = @transactionId AND [Finalized] = 0
	if @@ROWCOUNT = 0
		BEGIN
			INSERT INTO [ShoppingCart]
					   ([Amount]
					   ,[RentalTransactionId]
					   ,[ShoppingCartAvailableUntil]
					   ,[Finalized])
				 VALUES
					   (0
					   ,@transactionId
					   ,@TranscationAvailableUntil
					   ,0)
			SELECT @ShoppingCartId = SCOPE_IDENTITY();
			RETURN
		END
	
	--produkt i transakcja istniej¹
	UPDATE [ShoppingCart] 
	SET [Amount] = [Amount] + (SELECT top 1 [Price] FROM [Product] WHERE [ProductId] = @productId)
	WHERE [ShoppingCartId] = @ShoppingCartId
	INSERT INTO [dbo].[ProductsInShoppingCart]
           ([ShoppingCartId]
           ,[ProductId])
     VALUES
           (@ShoppingCartId
           ,@productId)
END
go


/*(2)*/
CREATE PROCEDURE proc_addRentalTransaction 
    @customerId int,
	@employeeId int
AS
BEGIN
	SELECT TOP 1 1 FROM [Customer] WHERE [CustomerId] = @customerId
	if @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No such customer in DB', 16, 1)
			RETURN
		END

	SELECT TOP 1 1 FROM [Employee] WHERE [EmployeeId] = @employeeId
	if @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No such employee in DB', 16, 1)
			RETURN
		END		
	
	
	DECLARE @Now DATETIME = GETDATE()
	
	DECLARE @TimeAvailable INT
	DECLARE @MaxTransactionTime INT
	
	SELECT 
		@TimeAvailable = [CustomerMaxTransactionTime] 
		,@MaxTransactionTime = [CustomerMaxRentalTime]
	FROM [Customer]
	WHERE [CustomerId] = @customerId

	INSERT INTO [RentalTransaction]
           ([DateStart]
           ,[DateEnd]
           ,[CustomerId]
           ,[EmployeeId]
           ,[MoneyAmount]
           ,[RentalDateStart]
           ,[RentalReturnTerm]
           ,[RentalDateEnd]
           ,[TransactionAvailableUntil]
           ,[Finalized])
     VALUES
           (@Now
           ,NULL
           ,@customerId
           ,@employeeId
           ,NULL
           ,NULL
           ,DATEADD(millisecond, @MaxTransactionTime, @Now)
           ,NULL
           ,DATEADD(millisecond, @TimeAvailable, @Now)
           ,0)
END
go

/*(3)*/
CREATE PROCEDURE proc_finalizeRentalTransaction 
    @transactionId int
AS
BEGIN
	--sprawdzanie czy istnieje taka transakcja
	SELECT TOP 1 *
	FROM [RentalTransaction] rental
	WHERE [RentalTransactionId] = @transactionId
	if @@ROWCOUNT = 0
		BEGIN
			RAISERROR('No such transaction in DB', 16, 1)
			RETURN
		END
	
	-- skorzystanie z funkcji 1. oblicz kosz transakcji
	DECLARE @CalculatedMoneyAmount DECIMAL(2,0) = [dbo].func_calcTransactionMoneyAmount(@transactionId)
	DECLARE @MoneyAmountFromShoppingCart DECIMAL(2,0) = (SELECT TOP 1 [Amount] FROM [ShoppingCart] WHERE [RentalTransactionId] = @transactionId AND [Finalized] = 0)
	
	IF @CalculatedMoneyAmount != @MoneyAmountFromShoppingCart
	BEGIN
		RAISERROR('DB incosistency: CalculatedMoneyAmount!=MoneyAmountFromShoppingCart :(', 16, 1)
		RETURN
	END
END
go

/*(4)*/
CREATE PROCEDURE proc_updateMovieRatings
AS
Begin
-- skorzystanie z funkcji 2. Oblicz rating filmu (na podstawie produktów)
	--u¿ycie kursora do zmiany ratingu
		DECLARE @Iterator INT
		open cMovie
			FETCH NEXT FROM cMovie INTO @Iterator;
			WHILE @@FETCH_STATUS = 0
			BEGIN
			--zmiana ceny o wspolczynnik
				UPDATE [Movie] 
				set [Rating] = [dbo].func_calcMovieRating(@Iterator)
				where MovieId = @Iterator
				FETCH NEXT FROM cMovie INTO @Iterator;
			END
		close cMovie
END
go


/*(5)*/
CREATE PROCEDURE proc_createShoppingCart
	@Description nvarchar(max),
	@Price decimal(2,0),
	@MovieId bigint
AS
BEGIN
	INSERT [Product]
           ([Description]
           ,[Price]
           ,[MovieId])
     VALUES
           (@Description
           ,@Price
           ,@MovieId)
END
go







