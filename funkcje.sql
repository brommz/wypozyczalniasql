
-- Create functions section -------------------------------------------------
/*
Funkcje
1. Oblicz koszt transakcji
2. Oblicz rating filmu (na podstawie produkt�w)
3. Oblicz przych�d dla danego miesi�ca
4. Oblicz kwot� wydan� przez klienta
5. Czy film (poprzez dost�pno�� niezablokowanych produkt�w) jest dost�pny
*/

/*(1)*/
CREATE FUNCTION func_calcTransactionMoneyAmount (@transactionId INT)
RETURNS decimal(2,0)
AS
BEGIN
	RETURN(
		SELECT SUM(product.Price)
		FROM [RentalTransaction] as trans
		JOIN [ShoppingCart] cart
		ON cart.RentalTransactionId = trans.RentalTransactionId
		JOIN [ProductsInShoppingCart] prodCart
		ON prodCart.ShoppingCartId = cart.ShoppingCartId
		JOIN [Product] product
		ON product.ProductId = prodCart.ProductId
		WHERE trans.RentalTransactionId = @transactionId
	)
END
go


/*(2)*/
CREATE FUNCTION func_calcMovieRating (@movieId INT)
RETURNS decimal(2,0)
AS
BEGIN
	/*get all rentals from all the time and rentals from last week and calc rating with some factors*/
	DECLARE @Rentals TABLE (RentalDate DATETIME, MovieId BIGINT)
	DECLARE @AllRentalsCount BIGINT
	DECLARE @LastWeekRentalsCount BIGINT
	DECLARE @AllRentalsCountForMovie BIGINT
	DECLARE @LastWeekRentalsCountForMovie BIGINT
		
	INSERT INTO @Rentals 
	SELECT 
		trans.RentalDateStart,
		movie.MovieId
	FROM [RentalTransaction] as trans
	JOIN [ShoppingCart] cart
	ON cart.RentalTransactionId = trans.RentalTransactionId
	JOIN [ProductsInShoppingCart] prodCart
	ON prodCart.ShoppingCartId = cart.ShoppingCartId
	JOIN [Product] product
	ON product.ProductId = prodCart.ProductId
	JOIN [Movie] movie
	ON movie.MovieId = product.MovieId
	WHERE trans.Finalized = 1

	SELECT @AllRentalsCount = COUNT(*) FROM @Rentals
	SELECT @AllRentalsCountForMovie = COUNT(*) FROM @Rentals WHERE MovieId = @movieId

	SELECT 
	@LastWeekRentalsCount = COUNT(*)
	FROM @Rentals
	WHERE RentalDate BETWEEN DATEADD(wk, -1, GETDATE()) AND GETDATE() AND MovieId = @movieId
	
	SELECT 
	@LastWeekRentalsCountForMovie = COUNT(*) 
	FROM @Rentals 
	WHERE RentalDate BETWEEN DATEADD(wk, -1, GETDATE()) AND GETDATE() AND  MovieId = @movieId
	
	
	RETURN(
		CONVERT(DECIMAL(2,0), (@AllRentalsCount/@AllRentalsCountForMovie + @LastWeekRentalsCount/@LastWeekRentalsCountForMovie))
	)
END
go


/*(3) Oblicz przych�d dla danego miesi�ca*/
CREATE FUNCTION func_calcMonthIncome(@monthDate DATETIME)
RETURNS decimal(9,2)
AS
BEGIN
	RETURN(
		SELECT SUM(trans.Amount)
		FROM [view_GetFinalizedTransactionsWithCustomersAndStartDate] as trans
		WHERE trans.DateStart BETWEEN DATEADD(month, -1, @monthDate) AND DATEADD(month, +1, @monthDate)
	)
END
go



/*(4) Oblicz kwot� wydan� przez klienta*/
CREATE FUNCTION func_calcCustomerMoneyPaid(@customerId BIGINT)
RETURNS decimal(9,2)
AS
BEGIN
	RETURN(
		SELECT SUM(trans.Amount)
		FROM [view_GetFinalizedTransactionsWithCustomersAndStartDate] as trans
		WHERE trans.CustomerId = @customerId
	)
END
go


/*(6) Czy produkt jest dost�pny - czy mo�e ju� wykupiony zosta� */
CREATE FUNCTION func_isProductAvailable(@productId BIGINT, @now DATETIME)
RETURNS BIT
AS
BEGIN
	RETURN(
		SELECT 
			case when count(*) > 0 then 1 else 0 end
		FROM [Product] as product
		JOIN [ProductsInShoppingCart] prodCart
		ON prodCart.ProductId = product.ProductId
		JOIN [ShoppingCart] as cart
		ON cart.ShoppingCartId = prodCart.ShoppingCartId
		WHERE product.ProductId = @productId AND (cart.Finalized = 1 OR cart.ShoppingCartAvailableUntil > @now)
	)
END
go



/*(5) Czy film (poprzez dost�pno�� niezablokowanych produkt�w) ale te� samych produkt�w jest dost�pny*/
CREATE FUNCTION func_isMovieAvailable(@movieId BIGINT)
RETURNS BIT
AS
BEGIN
	DECLARE @Now DATETIME = GETDATE()
	RETURN(
		SELECT 
			case when count(*) > 0 then 1 else 0 end
		FROM [Movie] as movie
		JOIN [Product] product
		ON product.MovieId = movie.MovieId
		WHERE ([dbo].func_isProductAvailable(product.ProductId, @Now)) = 1
	)
END
go



