SELECT p.*, c.Name AS CategoryName, COUNT(o.Id) AS OrderCount
FROM Products p
LEFT JOIN Categories c ON p.CategoryId = c.Id
LEFT JOIN Orders o ON p.Id = o.ProductId
GROUP BY p.Id, p.Name, p.ExpireDate, p.CostPrice, p.SalePrice, c.Name, p.CategoryId;


SELECT o.*, SUM(p.SalePrice * o.Count) AS TotalAmount
FROM Orders o
LEFT JOIN Products p ON o.ProductId = p.Id
GROUP BY o.Id, o.ProductId, o.Count, o.CreatedAt


CREATE PROCEDURE CalculateOrderProfit
    @OrderId INT
AS
BEGIN
    DECLARE @Profit DECIMAL(18, 2)
    SELECT @Profit = (p.SalePrice - p.CostPrice) * o.Count
    FROM Orders o
    INNER JOIN Products p ON o.ProductId = p.Id
    WHERE o.Id = @OrderId
    
    SELECT @Profit AS OrderProfit
END

CREATE VIEW ProductsWithProfit AS
SELECT p.*, c.Name AS CategoryName, (p.SalePrice - p.CostPrice) AS Profit
FROM Products p
LEFT JOIN Categories c ON p.CategoryId = c.Id


CREATE PROCEDURE GetOrdersBetweenDates
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT o.*, SUM(p.SalePrice * o.Count) AS TotalAmount
    FROM Orders o
    LEFT JOIN Products p ON o.ProductId = p.Id
    WHERE o.CreatedAt BETWEEN @StartDate AND @EndDate
    GROUP BY o.Id, o.ProductId, o.Count, o.CreatedAt
END
