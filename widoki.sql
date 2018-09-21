-- Create views --
/*
Widoki
1. Sfinalizowane faktury klientów
2. 10 najchêtniej wypo¿yczanych filmów
3. Historia wypo¿yczeñ (klient i jego zakupy)
4. Lista klientów z adresami
5. Pobranie listy dostêpnych produktów danego filmu
	-> musi sprawdziæ czy nie ma blokady na ShoppingCartAvailableUntil
*/

/*(1)*/
CREATE VIEW [view_CustomerFinalizedRentalTransaction]
AS
	SELECT customer.[CustomerId]
		  ,customer.[Name]
		  ,customer.[Surname]
		  ,rental.MoneyAmount
		  ,rental.DateStart AS TransactionStart 
		  ,rental.DateEnd AS TRansactionEnd
		  ,rental.RentalDateStart AS RentalFromDate
		  ,rental.RentalDateEnd AS RentalToDate
		  ,rental.RentalReturnTerm
	FROM [Customer] as customer
	JOIN [RentalTransaction] rental
	ON rental.[CustomerId] = customer.[CustomerId]
	WHERE rental.[Finalized] = 1
go

/*(2)*/
CREATE VIEW [view_Top10Movies]
AS
	SELECT TOP 10 movie.[Title], COUNT(*) AS OrderNumber
	FROM [Movie] as movie
	JOIN [Product] product
	ON product.[MovieId] = movie.[MovieId]
	JOIN [ProductsInShoppingCart] prodCart
	ON prodCart.[ProductId] = product.[ProductId]
	JOIN [ShoppingCart] cart
	ON cart.[ShoppingCartId] = prodCart.[ShoppingCartId]
	WHERE cart.Finalized = 1
	GROUP BY movie.[Title]
	ORDER BY OrderNumber DESC
go

/*(3) Customer Rental History*/
CREATE VIEW [view_CustomerRentalHistory]
AS
	SELECT TOP 500 customer.[CustomerId]
			  ,customer.[Name]
			  ,customer.[Surname]
			  ,rental.RentalDateStart
			  ,movie.Title
	FROM [Customer] as customer
	JOIN [RentalTransaction] rental
	ON rental.[CustomerId] = customer.[CustomerId]
	--WHERE rental.[Finalized] = 1
	JOIN [ShoppingCart] cart
	ON cart.[RentalTransactionId] = rental.[RentalTransactionId]
	JOIN [ProductsInShoppingCart] prodCart
	ON prodCart.[ShoppingCartId] = cart.[ShoppingCartId]
	JOIN [Product] product
	ON product.[ProductId] = prodCart.[ProductId]
	JOIN [Movie] movie
	ON product.[MovieId] = movie.[MovieId]
	WHERE rental.[Finalized] = 1
	ORDER BY rental.DateStart
go

/*(4)*/
CREATE VIEW [view_CustomersWithAddresses]
AS
	SELECT customer.[CustomerId]
			  ,customer.[Name]
			  ,customer.[Surname]
			  ,addr.Country + ', ' + addr.ZipCode + ' ' + addr.City + ', ' + addr.Street AS FullAddress
	FROM [Customer] customer
	JOIN [Address] addr
	ON customer.[AddressId] = addr.[Id]
go

/*(5)*/
CREATE VIEW [view_AvailableMovies]
AS
	SELECT movie.Title FROM 
	[Movie] AS movie
	JOIN [Product] product
	ON product.[MovieId] = movie.[MovieId]

	LEFT JOIN [ProductsInShoppingCart] prodCart
	ON prodCart.[ProductId] = product.[ProductId]

	LEFT JOIN [ShoppingCart] cart
	ON cart.[ShoppingCartId]  = prodCart.[ShoppingCartId]

	WHERE prodCart.ProductInShoppingCartId is null OR (cart.Finalized = 0 AND cart.[ShoppingCartAvailableUntil] > GETDATE())

	/*
	WHERE (
		NOT EXISTS 
		(
			SELECT * FROM
			[ProductsInShoppingCart] as prodCart
			WHERE prodCart.[ProductId] = product.[ProductId]
		)
		OR
		(
			
		)
	)
	*/
go



/*(6)*/
CREATE VIEW [view_GetFinalizedTransactionsWithCustomersAndStartDate]
AS 
	SELECT 
		SUM(trans.MoneyAmount) as Amount,
		trans.CustomerId as CustomerId,
		trans.RentalDateStart as DateStart
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
	GROUP BY trans.CustomerId, trans.RentalDateStart
go

