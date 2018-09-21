--trigger instead of
Create View [view_Genre] as
Select [GenreId], [Name] from [Genre]
go

CREATE TRIGGER InsteadOfAddGenre ON [view_Genre]
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO Genre
       SELECT [GenreId], [Name]
       FROM inserted
END;
go

--trigger after update
create trigger CustomerUpdate on [Customer]
after update
as
begin
	UPDATE [Customer] 
	SET customer.[ModificationDate] = GETDATE()
	from [Customer] customer 
	INNER JOIN inserted ins 
	ON customer.[CustomerId] = ins.[CustomerId]
end
go
